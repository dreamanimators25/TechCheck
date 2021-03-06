//
//  MYBankDetailVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 20/01/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MYBankDetailVC: UIViewController {
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var ddView: UIView!
    
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblTransferDetail: UILabel!
    @IBOutlet weak var lblEnterDetails: UILabel!
    @IBOutlet weak var txtFBankHolderName: UITextField!
    @IBOutlet weak var txtFBankAccountNumber: UITextField!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnProceed: UIButton!
    
    
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
        
        self.changeLanguageOfUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.drop = UIDropDown.init(frame: CGRect(x: 15, y: 0, width: self.scrlView.frame.size.width - 30, height: 40))
            
            self.drop.borderColor = .clear
            self.drop.center = CGPoint(x: self.ddView.frame.midX,y: self.ddView.frame.midY)
            self.drop.options = self.arrDrop
            self.drop.animationType = .Bouncing
            self.drop.textAlignment = .left
            self.drop.placeholder = "Select Bank Name".localized(lang: langCode)
            
            self.drop.didSelect { (option, index) in
                self.drop.placeholder = option
                self.strSelectedBankName = option
                print("You just select: \(option) at index: \(index)")
            }
            
            self.scrlView.addSubview(self.drop)
        }
    }
    
    func changeLanguageOfUI() {
       
        self.lblBank.text = "BANK".localized(lang: langCode)
        self.lblTransferDetail.text = "Transfer Details".localized(lang: langCode)
        self.lblEnterDetails.text = "Please Enter the details".localized(lang: langCode)
        
        self.txtFBankHolderName.text = "Bank Holders Name".localized(lang: langCode)
        self.txtFBankAccountNumber.text = "Bank Account Number".localized(lang: langCode)
        
        self.btnSkip.setTitle("SKIP".localized(lang: langCode), for: UIControlState.normal)
        self.btnProceed.setTitle("PROCEED".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    //MARK:- button action methods
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        let vc = OrderFinalVC()
        vc.orderID = placedOrderId
        vc.finalPrice = self.finalPriced
        self.navigationController?.pushViewController(vc, animated: true)
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
            Alert.showAlertWithError(strMessage: "Please enter account holder's name".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtFBankAccountNumber.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter account number".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if self.strSelectedBankName == ""
        {
            Alert.showAlertWithError(strMessage: "Please select your bank".localized(lang: langCode) as NSString, Onview: self)
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
 
            /*
            let parametersHome = ["paymentCode": "Bank",
                                  "orderItemId": "10571",
                                  "apiKey": "3614bc420a37b5a2b0bcd8aebb2a968d",
                                  "customerId": "58749",
                                  "userName": "instantIOS",
                                  "quotationId": "243267"]*/
            
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
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
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
            
            let info = ["Bank Holders Name": txtFBankHolderName.text ?? "",
                        "Bank Account Number": txtFBankAccountNumber.text ?? "",
                        "Bank Name" : self.strSelectedBankName,
                        "Promoter ID" : "",
                        "Referral ID" : ""]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                //"orderItemId" : self.quatationId,
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
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

