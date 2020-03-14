//
//  MYMaxisVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 20/01/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MYMaxisVC: UIViewController {
    
    @IBOutlet weak var txtFBankHolderName: UITextField!
    @IBOutlet weak var txtFBankAccountNumber: UITextField!
    @IBOutlet weak var txtFPromoterID: UITextField!
    @IBOutlet weak var txtFReferrelID: UITextField!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var ddView: UIView!
    
    let reachability: Reachability? = Reachability()
    var quatationId = String()
    var selectedPaymentType = String()
    var itemID = String()
    var orderID = String()
    var strSelectedBankName = String()
    
    var finalPriced = 0
    var placedOrderId = String()
    
    var drop = UIDropDown()
    var arrDrop = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPaymentDetailsFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.drop = UIDropDown.init(frame: CGRect(x: 15, y: 0, width: self.scrlView.frame.size.width - 30, height: 30))
            
            self.drop.borderColor = .clear
            self.drop.center = CGPoint(x: self.ddView.frame.midX,y: self.ddView.frame.midY)
            self.drop.options = self.arrDrop
            self.drop.animationType = .Bouncing
            self.drop.textAlignment = .left
            self.drop.placeholder = "Select Bank Name"
            
            self.drop.didSelect { (option, index) in
                self.drop.placeholder = option
                self.strSelectedBankName = option
                print("You just select: \(option) at index: \(index)")
            }
            
            self.scrlView.addSubview(self.drop)
        }
    }

    //MARK:- button action methods
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {
        if Validation() {
            self.setPaymentDetailsFromServer()
        }
    }
    
    func Validation()->Bool
    {
        if txtFBankHolderName.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter account holder's name" as NSString, Onview: self)
            return false
        }
        else if txtFBankAccountNumber.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter account number", Onview: self)
            return false
        }
        else if self.strSelectedBankName == ""
        {
            Alert.showAlert(strMessage: "Please select your bank" as NSString, Onview: self)
            return false
        }else if txtFPromoterID.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter promoter ID" as NSString, Onview: self)
            return false
        }
        else if txtFReferrelID.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter referrel ID", Onview: self)
            return false
        }
        
        return true
    }
    
    //MARK:- webservice Get Payment Details
    
    func paymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func getPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "getPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "paymentCode" : selectedPaymentType,
                "quotationId" : quatationId,
                "customerId" : CustomUserDefault.getUserId(),
                "orderItemId" : orderID
            ]
            
            print(parametersHome)
            
            self.paymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let arrBankData = responseObject?.value(forKeyPath: "msg") as! NSDictionary
                        print(arrBankData)
                        
                        let arr = ((responseObject?.value(forKey: "msg") as! NSDictionary).value(forKey: "Bank Name") as! NSArray)[3] as! [String]
                        
                        print(arr.count)
                        self.arrDrop = arr
                        self.drop.options = self.arrDrop
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server", Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found", Onview: self)
        }
        
    }

    //MARK:- webservice Set Payment detaisl
    
    func setPaymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func setPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var jsonString = ""
            
            let info = ["Bank_Holders_Name": txtFBankHolderName.text ?? "",
                        "Bank_Account_Number": txtFBankAccountNumber.text ?? "",
                        "Bank_Name" : self.strSelectedBankName,
                        "Promoter ID" : txtFPromoterID.text ?? "",
                        "Referral ID" : txtFReferrelID.text ?? ""]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                "orderItemId" : self.orderID,
                "paymentInformation" : jsonString,
                "isOffer" : "1",
                "paymentCode": selectedPaymentType,
            ]
            
            print(parametersHome)
            
            self.setPaymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let vc = OrderFinalVC()
                        vc.orderID = self.placedOrderId
                        vc.finalPrice = self.finalPriced
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server", Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found", Onview: self)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
