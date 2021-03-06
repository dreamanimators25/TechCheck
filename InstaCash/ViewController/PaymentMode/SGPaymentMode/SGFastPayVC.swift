//
//  SGFastPayVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 20/01/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class SGFastPayVC: UIViewController {
    
    @IBOutlet weak var ddView: UIView!
    
    @IBOutlet weak var lblFastpay: UILabel!
    @IBOutlet weak var lblTransferDetail: UILabel!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var txtFAccountHolderName: UITextField!
    @IBOutlet weak var txtFAccountNumber: UITextField!
    @IBOutlet weak var txtFSwiftBic: UITextField!
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
    }
    
    func changeLanguageOfUI() {
        
        self.lblFastpay.text = "FASTPAY".localized(lang: langCode)
        self.lblTransferDetail.text = "Transfer Details".localized(lang: langCode)
        self.lblPleaseEnter.text = "Please Enter the details".localized(lang: langCode)
        
        self.txtFAccountHolderName.placeholder = "Account Holders Name".localized(lang: langCode)
        self.txtFAccountNumber.placeholder = "Account Number".localized(lang: langCode)
        self.txtFSwiftBic.placeholder = "SwiftBic".localized(lang: langCode)
        
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
        if txtFAccountHolderName.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter account holder's name".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtFAccountNumber.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter account number".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtFSwiftBic.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter SwiftBic ID".localized(lang: langCode) as NSString, Onview: self)
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
                "orderItemId" : itemID
            ]
            
            print(parametersHome)
            
            self.paymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                       
                        
                        
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
            
            let info = ["Bank_Holders_Name": txtFAccountHolderName.text ?? "",
                        "Bank_Account_Number": txtFAccountNumber.text ?? "",
                        "SwiftBic" : txtFSwiftBic.text ?? ""]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                "orderItemId" : self.itemID,
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
