//
//  BankTransfer.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 04/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class BankTransfer: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var pytmView: UIView!
    @IBOutlet weak var pytmImageView: UIImageView!
    
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDevicePrice: UILabel!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtConfirmAccountNumber: UITextField!
    @IBOutlet weak var txtIfsc: UITextField!
    @IBOutlet weak var txtBranch: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnProceed: UIButton!
    
    
    var totalNumberCount = 0
    var strPaymentProcessMode = "1"
    var getFinalPrice4 = 0
    var pickUpChargeGet4 = 0
    var finalPriceSet4 = 0
    var strProductName4 = ""
    var strProductImg4 = ""
    let reachability: Reachability? = Reachability()
    var quatationId4 = String()
    var userDetails4 = [String:Any]()
    var arrDictPaymentMode4 = [NSDictionary]()
    var selectePaymentType4 = String()
    var donation = String()
    var bankDetails = [String:Any]()
    
    func changeLanguageOfUI() {
      
        self.lblDeviceName.text = "Transfer Details".localized(lang: langCode)
        self.lblDevicePrice.text = "Please Enter the details".localized(lang: langCode)
        
        self.txtAccountHolderName.placeholder = "Account Holder Name".localized(lang: langCode)
        self.txtBankName.placeholder = "Bank Name".localized(lang: langCode)
        self.txtAccountNumber.placeholder = "Account Number".localized(lang: langCode)
        self.txtConfirmAccountNumber.placeholder = "Confirm Account Number".localized(lang: langCode)
        self.txtIfsc.placeholder = "IFSC".localized(lang: langCode)
        self.txtBranch.placeholder = "Bank Branch".localized(lang: langCode)
        self.txtMobileNumber.placeholder = "Mobile Number".localized(lang: langCode)
        
        self.btnSkip.setTitle("SKIP".localized(lang: langCode), for: UIControlState.normal)
        self.btnProceed.setTitle("PROCEED".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            totalNumberCount = 10
        }else if CustomUserDefault.getCurrency() == "RM" {
            totalNumberCount = 8
        }else {
            totalNumberCount = 8
        }
        
        txtIfsc.delegate = self
        txtMobileNumber.delegate = self
        
        if selectePaymentType4 == "NEFT" {
            self.lblTitle.text = "NEFT".localized(lang: langCode)
            self.bankView.isHidden = false
            self.pytmView.isHidden = true
            
        }else if selectePaymentType4 == "IMPS" {
            self.lblTitle.text = "IMPS".localized(lang: langCode)
            self.bankView.isHidden = false
            self.pytmView.isHidden = true
            
        }else if selectePaymentType4 == "PYTM" {
            self.lblTitle.text = "PAYTM".localized(lang: langCode)
            self.pytmView.isHidden = false
            self.bankView.isHidden = true
            
            lblDeviceName.text = strProductName4
            
            self.lblDevicePrice.text = CustomUserDefault.getCurrency() + String(finalPriceSet4.formattedWithSeparator)
            
            //let imgURL = URL.init(string: strProductImg4)
            //self.pytmImageView.sd_setImage(with: imgURL)
            
        }else if selectePaymentType4 == "DONATION" {
            self.lblTitle.text = "DONATION".localized(lang: langCode)
            
            self.pytmView.isHidden = true
            self.bankView.isHidden = true
        }
        
        self.getPaymentStructureFromServer()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickOrderProceed(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if selectePaymentType4 == "NEFT" {
            
            if Validation() {
                self.setPaymentDetailsFromServer()
            }
            
        }else if selectePaymentType4 == "IMPS" {
            
            if Validation() {
                self.setPaymentDetailsFromServer()
            }
            
        }else if selectePaymentType4 == "PYTM" {
            
            if txtMobileNumber.text!.isEmpty {
                Alert.showAlert(strMessage: "Please enter mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else if txtMobileNumber.text?.count ?? 0 < totalNumberCount {
                Alert.showAlert(strMessage: "Please enter Valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else{
                self.setPaymentDetailsFromServer()
            }
            
        }else if selectePaymentType4 == "DONATION" {
            
        }
        
    }
    
    @IBAction func onClickOrderSkip(_ sender: Any) {
        
        let vc = UploadDocumentVC()
        
        vc.getFinalPrice5 = self.getFinalPrice4
        vc.pickUpChargeGet5 = self.pickUpChargeGet4
        vc.finalPriceSet5 = self.finalPriceSet4
        vc.strProductName5 = self.strProductName4
        vc.strProductImg5 = self.strProductImg4
        vc.quatationId5 = self.quatationId4
        vc.userDetails5 = self.userDetails4
        vc.arrDictPaymentMode5 = self.arrDictPaymentMode4
        vc.selectePaymentType5 = self.selectePaymentType4
        vc.donation5 = self.donation
        vc.bankDETAILS = self.bankDetails
        vc.skipOrder = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func Validation()->Bool
    {
        if txtAccountHolderName.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter account holder's name".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtBankName.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter your bank name".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtAccountNumber.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter account number".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtConfirmAccountNumber.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter confirm account number".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtAccountNumber.text != txtConfirmAccountNumber.text
        {
            Alert.showAlert(strMessage: "Account Number doesn't match!".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtIfsc.text!.isEmpty
        {
            Alert.showAlert(strMessage: "Please enter IFSC Code".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtBranch.text!.isEmpty {
            Alert.showAlert(strMessage: "Please enter bank branch".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        
        return true
    }
    
    //MARK:- webservice GetPaymentStructure
    
    func paymentStructureApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func getPaymentStructureFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "getPaymentStructure"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName, //1
                "apiKey" : key, //1
                "paymentCode" : selectePaymentType4, //1
                "quotationId" : quatationId4, //0
            ]
            
            print(parametersHome)
            
            self.paymentStructureApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let structure = (responseObject?["paymentStructure"] as? [String:Any])
                        
                        if structure?.count == 1 {
                            
                            //Paytm wallet
                            
                            let dict = (responseObject?["msg"] as? NSDictionary)
                            
                            let imgURL = URL.init(string: dict?.value(forKey: "paymentImage") as! String)
                            self.pytmImageView.sd_setImage(with: imgURL)
                            
                        }else if structure?.count == 5 {
                            
                            //Neft or Imps
                            
                        }else {
                            
                            //Donation
                            
                        }
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    //MARK:- webservice Razorpay Api
    
    func razorPayApiGet(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.getRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
        
        //web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
          //              completionHandler: completionHandler)
    }
    
    func razorpayApiCheckFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            //let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = "https://ifsc.razorpay.com/\(txtIfsc.text ?? "")"
            
            self.razorPayApiGet(strURL: strUrl, parameters: [:], completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil && responseObject != nil {
                    
                    self.txtBranch.text = responseObject?["BRANCH"] as? String
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
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
            
            if selectePaymentType4 == "NEFT" || selectePaymentType4 == "IMPS" {
                
                let info = ["Account_Holders_Name":txtAccountHolderName.text ?? "",
                            "Bank_Name":txtBankName.text ?? "",
                            "Account_Number":txtAccountNumber.text ?? "",
                            "IFSC":txtIfsc.text ?? "",
                            "Bank_Branch":txtBranch.text ?? ""]
                
                bankDetails = info
                
                let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
            }else {
                let info = ["Mobile_Number":txtMobileNumber.text ?? ""]
                
                let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
            }
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                "orderItemId" : self.quatationId4,
                "paymentInformation" : jsonString,
                "isOffer" : "1",
                "paymentCode": selectePaymentType4,
            ]
            
            print(parametersHome)
            
            self.setPaymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        self.fetchOrderFromServer(isRefreshPrice: true) //Scenario Change
                        
                        /*
                        let vc = UploadDocumentVC()
                        
                        vc.getFinalPrice5 = self.getFinalPrice4
                        vc.pickUpChargeGet5 = self.pickUpChargeGet4
                        vc.finalPriceSet5 = self.finalPriceSet4
                        vc.strProductName5 = self.strProductName4
                        vc.strProductImg5 = self.strProductImg4
                        vc.quatationId5 = self.quatationId4
                        vc.userDetails5 = self.userDetails4
                        vc.arrDictPaymentMode5 = self.arrDictPaymentMode4
                        vc.selectePaymentType5 = self.selectePaymentType4
                        vc.donation5 = self.donation
                        vc.bankDETAILS = self.bankDetails
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        */
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    //MARK:- webservice orderCreate
    
    func orderCreateApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(isRefreshPrice:Bool) {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var producdID = ""
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
            }
            
            var strValue = ""
            var userSelectedProductAppcodes = ""
            
            let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
            let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
            
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
                strValue = "STON01,"
                
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
                strValue = ""
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes
            }
            
            let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
            let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
            
            
            var strGCMToken = ""
            if (userDefaults.value(forKey: "FCMToken") != nil) {
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else {
                strGCMToken = ""
            }
            
            let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
            
            var strPromoterId = ""
            if userDefaults.value(forKey: "promoter_id") == nil {
                strPromoterId = ""
            }
            else {
                strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
            }
            
            //Sameer - 28/3/20
            if userDefaults.value(forKey: "promoterID") == nil {
                strPromoterId = ""
            }
            else{
                strPromoterId = userDefaults.value(forKey: "promoterID") as! String
            }
            
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "orderCreate"
            
            var smallParam = ["IMEINumber" : KeychainWrapper.standard.string(forKey: "UUIDValue") ?? "",
                              "name" : userDetails4["name"] ?? "",
                              "email" : userDetails4["email"] ?? "",
                              "mobile" : userDetails4["mobile"] ?? "",
                              "address1" : userDetails4["address1"] ?? "",
                              "address2" : userDetails4["address1"] ?? "",
                              "pincode" : userDetails4["pincode"] ?? "",
                              "city" : userDetails4["city"] ?? "",
                              "paymentType" : selectePaymentType4,
            ]
            
            smallParam["Account_Holders_Name"] = txtAccountHolderName.text ?? ""
            smallParam["Bank_Name"] = txtBankName.text ?? ""
            smallParam["Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["Confirm_Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["IFSC"] = txtIfsc.text ?? ""
            
            
            smallParam["type"] = "createOrder"
            smallParam["isNewAddress"] = "1"
            //smallParam["donateTo"] = "NSS"
            //smallParam["donateAmount"] = "31"
            
            if donation == "" {
                smallParam["donateTo"] = ""
                smallParam["donateAmount"] = ""
            }else {
                smallParam["donateTo"] = "NSS"
                smallParam["donationAmount"] = donation
            }
            
            var parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName, //1
                "apiKey" : key, //1
                "mobile":CustomUserDefault.getPhoneNumber() ?? "", //1
                
                "name":CustomUserDefault.getUserName() ?? "", //1
                "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", //1
                
                "city":CustomUserDefault.getCityId(), //1
                
                ////////////////////////////////////////////////////////////
                "productId":producdID, //1
                "conditionString":converComaToSemocolumForProductValues, //1
                "diagnosisId":userDefaults.value(forKey: "diagnosisId") as! String, //1
                "processMode":self.strPaymentProcessMode, //1
                ////////////////////////////////////////////////////////////
                
                //"remark":"", //0
                "email":CustomUserDefault.getUserEmail() ?? "", //0
                //"productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String, //0
                //"GCMId":strGCMToken, //0
                //"customerId":CustomUserDefault.getUserId(), //0
                //"landmark":"", //0
                "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "", //1
                "isNewAddress":"1", //0
                
                "uniqueIdentifire":KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //1
                "paymentCode": selectePaymentType4, //1
                
                "couponCode":userDefaults.value(forKey: "orderPromoCode") as? String ?? "", //1
                "couponAmount":couponAmount, //1
                "promoterId":strPromoterId, //0
                
                //"paymentDetails" : smallParam,
                "donateTo" : "NSS",
                "donationAmount" : donation,
                
                "quotationId":quatationId4, //0
                "preferredDate":"", //0
                "preferredTime":"", //0
                //"additionalInformation":"", //0
            ]
            
            if let addInfo = userDefaults.value(forKey: "additionalInfo") {
                parametersHome["additionalInformation"] = addInfo
            }
            
            print(parametersHome)
            print(strUrl)
            
            self.orderCreateApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        /*
                         UIViewController().showAlert("InstaCash", message: "Your order has been successfully placed.", alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self
                         , completion: { (ind) in
                         
                         //let vc = HomeVC()
                         //self.navigationController?.pushViewController(vc, animated: true)
                         })*/
                        
                        /*
                        let vc = OrderFinalVC()
                        //vc.orderid =
                        vc.finalPrice = self.finalPriceSet4
                        self.navigationController?.pushViewController(vc, animated: true)
                        */
                        
                        let orderPlaceID = responseObject?["msg"] as? String
                        
                        //*
                         //let itemID = responseObject?["itemId"] as! String
                        if let orderID = responseObject?["orderId"] as? String {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = orderID
                            vc.getFinalPrice5 = self.getFinalPrice4
                            vc.placedOrderId = orderPlaceID ?? ""
                            vc.skipOrder = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = ""
                            vc.getFinalPrice5 = self.getFinalPrice4
                            vc.placedOrderId = orderPlaceID ?? ""
                            vc.skipOrder = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                         //*/
                        
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }

    
    //MARK: UITextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtIfsc {
            if (txtIfsc.text?.isEmpty)! {
                Alert.showAlert(strMessage: "Enter valid IFSC Code".localized(lang: langCode) as NSString, Onview: self)
            }
            else {
                //self.lblPincodeMatchMessage.isHidden = true
                self.razorpayApiCheckFromServer()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtMobileNumber {
            // YOU SHOULD FIRST CHECK FOR THE BACKSPACE. IF BACKSPACE IS PRESSED ALLOW IT
            
            if string == "" {
                return true
            }
            
            if let characterCount = textField.text?.count {
                // CHECK FOR CHARACTER COUNT IN TEXT FIELD
                if characterCount == totalNumberCount {
                    // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                    return textField.resignFirstResponder()
                }
            }
        }
            return true
            
    }
    
}
