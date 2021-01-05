//
//  Profile.swift
//  TechCheck
//
//  Created by CULT OF PERSONALITY on 05/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Profile: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtNameOnCard: UITextField!

    
    var isMatchPincode = false
    var strMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.txtPostCode.delegate = self
        
        if CustomUserDefault.getCityName() == "" {
            self.txtCity.text = ""
        }else {
            self.txtCity.text = CustomUserDefault.getCityName()
        }
        
        if let name = CustomUserDefault.getUserName() {
            txtName.text = name
        }
        
        if let email = CustomUserDefault.getUserEmail() {
            txtEmailAddress.text = email
        }
        
        if let number = CustomUserDefault.getPhoneNumber() {
            txtNumber.text = number
        }
        
        if let pincode = CustomUserDefault.getUserPinCode() {
            if pincode == "0" || pincode == "1" {
                txtPostCode.text = ""
            }else {
                txtPostCode.text = String(pincode)
            }
        }
        
        if let address1 = UserDefaults.standard.value(forKey: "placeOrderAddress") as? String {
            txtAddress1.text = address1
        }
        
        if let address2 = UserDefaults.standard.value(forKey: "address2") as? String {
            txtAddress2.text = address2
        }
        
        if let accountNumber = UserDefaults.standard.value(forKey: "accountNumber") as? String {
            txtAccount.text = accountNumber
        }
        
        if let nameOnCard = UserDefaults.standard.value(forKey: "nameOnCard") as? String {
            txtNameOnCard.text = nameOnCard
        }
        
        if let imgUrl = CustomUserDefault.getUserProfileImage() {
            //self.userImgView?.sd_setImage(with: imgUrl)
        }
        
    }
    
    func cityMatchiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func matchCityByAPI() {
        
        //activityPincode.startAnimating()
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getCity"
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "pincode":txtPostCode.text!
        ]
        
        print(parametersHome)
        
        self.cityMatchiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            
            print(responseObject ?? [:])
            //self.activityPincode.stopAnimating()
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    if CustomUserDefault.getCityId() == responseObject?.value(forKeyPath: "msg.cityId") as! String {
                        
                        self.isMatchPincode = true
                    }
                    else{
                        
                        self.strMessage = "Pincode not match with your city."
                        self.isMatchPincode = false
                        
                        Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                    }
                    
                }
                else{
                    // failed
                    self.strMessage = (responseObject?["msg"] as! String)
                    Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server", Onview: self)
            }
            
        })
        
    }
    
    //MARK:- textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPostCode {
            if (txtPostCode.text?.isEmpty)!{
                Alert.showAlertWithError(strMessage: "Enter valid Code", Onview: self)
            }
            else{
                //self.lblPincodeMatchMessage.isHidden = true
                matchCityByAPI()
            }
        }
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtNumber {
            //s.
     
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
     
            if CustomUserDefault.getCurrency() == "£" {
            
            //if (userDefaults.value(forKey: "countryName") as! String).contains("India"){ //s.
                
                if (textField.text?.utf8CString.count)! > 10
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
            else{
                if (textField.text?.utf8CString.count)! > 11
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
            
        } //s.
        else if textField == txtPostCode {
            
            let pin = CustomUserDefault.getUserPinCode()
            var maxLength = 0
            switch pin {
            case 0 :
                maxLength = 6
            case 1:
                maxLength = 5
            case 2:
                maxLength = 6
            default:
                maxLength = 4
            }
            
            let currentString : NSString = textField.text! as NSString
            let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
          
            //return true //s.
            
        }else {
            return true
        }
    }*/
    
    func Validation()->Bool
    {
        if txtName.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter name" as NSString, Onview: self)
            return false
        }
        else if txtEmailAddress.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter E-mail address" as NSString, Onview: self)
            return false
        }
        else if(!Alert.isValidEmail(testStr: txtEmailAddress.text!))
        {
            Alert.showAlertWithError(strMessage: "Please Enter Correct Email Address" as NSString, Onview: self)
            return false
        }
        else if txtNumber.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter mobile number", Onview: self)
            return false
        }
        else if txtAddress1.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter address line 1", Onview: self)
            return false
        }
        else if txtPostCode.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter pincode", Onview: self)
            return false
        }else if !self.isMatchPincode {
            self.strMessage = "Pincode not match with your city."
            
            Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
            return false
        }

        
        return true
    }
    
    func setLanguageCode() {
        //to get language code of device ......
        lang_code = Locale.preferredLanguages[0]
        
        //To convert full name of language from language code
        let locale = NSLocale.current
        translation = locale.localizedString(forLanguageCode: lang_code as String)!
        
        if translation == "English" {
            languageCode = "en"
            userDefaults.saveLanguageCode(langCode: languageCode)
            langCode = languageCode
        }else if translation == "हिन्दी" {
            languageCode = "hi"
            userDefaults.saveLanguageCode(langCode: languageCode)
            langCode = languageCode
        }else if translation == "中文" {
            languageCode = "zh-Hans"
            userDefaults.saveLanguageCode(langCode: languageCode)
            langCode = languageCode
        }else {
            languageCode = "en"
            userDefaults.saveLanguageCode(langCode: languageCode)
            langCode = languageCode
        }
    }
    
    func removeCache(){
        CustomUserDefault.removeUserId()
        CustomUserDefault.removeCurrency()
        CustomUserDefault.removeUserName()
        CustomUserDefault.removeEnteredUserName()
        CustomUserDefault.removeEnteredUserEmail()
        CustomUserDefault.removeEnteredPhoneNumber()
        CustomUserDefault.removeProductId()
        CustomUserDefault.removeUserProfile()
        CustomUserDefault.removeUserProfileImage()
        CustomUserDefault.removeCityId()
        CustomUserDefault.removeCityName()
        CustomUserDefault.removePhoneNumber()
        CustomUserDefault.removeUserEmail()
        
        CustomUserDefault.removePinCode() //s.
        
        //4/4/2020
        userDefaults.removeObject(forKey: "langCode")
        self.setLanguageCode()
        
        //Sameer - 28/3/20
        userDefaults.removeObject(forKey: "promoterID")
        userDefaults.removeObject(forKey: "promoter")
        userDefaults.removeObject(forKey: "promotionCouponCode")
        userDefaults.removeObject(forKey: "urlResponse")
        userDefaults.removeObject(forKey: "selectedCountrySymbol")
        userDefaults.removeObject(forKey: "paymodeResponse")
        userDefaults.removeObject(forKey: "additionalInfo")
        //
        
        UserDefaults.standard.removeObject(forKey: "placeOrderAddress") //s.
        UserDefaults.standard.removeObject(forKey: "address2") //s.
        UserDefaults.standard.removeObject(forKey: "accountNumber") //s.
        UserDefaults.standard.removeObject(forKey: "nameOnCard") //s.
        
        //userDefaults.removeValue(forKey: "baseURL") //s.
        UserDefaults.standard.removeObject(forKey: "baseURL") //s.
        
        //userDefaults.set(false, forKey: "baseURL")
        userDefaults.removeObject(forKey: "countryName")
        userDefaults.set(false, forKey: "OrderPlaceFordiagnosis")
        userDefaults.removeObject(forKey: "isDiagnosisForSTONValue")
        userDefaults.removeObject(forKey: "orderPromoCode")
        userDefaults.removeObject(forKey: "couponCodePrice")
        userDefaults.removeObject(forKey: "diagnosisId")
        userDefaults.removeObject(forKey: "productPriceFromAPI")
        userDefaults.removeObject(forKey: "diagnosisId")
        userDefaults.removeObject(forKey: "orderOtherIMEINumber")
        
        userDefaults.removeObject(forKey: "question_firstAnswerCode")
        userDefaults.removeObject(forKey: "question_secondQuestionCode")
        userDefaults.removeObject(forKey: "question_thirdQuestionCode")
        userDefaults.removeObject(forKey: "question_FourthCode")
        userDefaults.removeObject(forKey: "question_FifthCode")
        userDefaults.removeObject(forKey: "question_sixthCode")
        userDefaults.removeObject(forKey: "question_seventhCode")
        userDefaults.removeObject(forKey: "question_eightCode")
        userDefaults.removeObject(forKey: "question_nineCode")
        userDefaults.removeObject(forKey: "question_tenthCode")
        userDefaults.removeObject(forKey: "question_elevenCode")
        userDefaults.removeObject(forKey: "question_twelthCode")
        userDefaults.removeObject(forKey: "question_thirteenCode")
        userDefaults.removeObject(forKey: "question_FourtheenCode")
        userDefaults.removeObject(forKey: "question_FifteenCode")
        userDefaults.removeObject(forKey: "question_sixteenCode")
        userDefaults.removeObject(forKey: "question_firstAnswer")
        userDefaults.removeObject(forKey: "question_secondAnswer")
        userDefaults.removeObject(forKey: "question_thirdAnswer")
        userDefaults.removeObject(forKey: "question_FourthAnswer")
        userDefaults.removeObject(forKey: "question_FifthAnswer")
        userDefaults.removeObject(forKey: "question_sixthAnswer")
        userDefaults.removeObject(forKey: "question_seventhAnswer")
        userDefaults.removeObject(forKey: "question_eightAnswer")
        userDefaults.removeObject(forKey: "question_nineAnswer")
        userDefaults.removeObject(forKey: "question_tenthAnswer")
        userDefaults.removeObject(forKey: "question_elevenAnswer")
        userDefaults.removeObject(forKey: "question_twelthAnswer")
        userDefaults.removeObject(forKey: "question_thirteenAnswer")
        userDefaults.removeObject(forKey: "question_FourtheenAnswer")
        userDefaults.removeObject(forKey: "question_FifteenAnswer")
        userDefaults.removeObject(forKey: "question_sixteenAnswer")
        userDefaults.removeObject(forKey: "question_firstQuestion")
        userDefaults.removeObject(forKey: "question_secondQuestion")
        userDefaults.removeObject(forKey: "question_thirdQuestion")
        userDefaults.removeObject(forKey: "question_FourthQuestion")
        userDefaults.removeObject(forKey: "question_FifthQuestion")
        userDefaults.removeObject(forKey: "question_sixthQuestion")
        userDefaults.removeObject(forKey: "question_seventhQuestion")
        userDefaults.removeObject(forKey: "question_eightQuestion")
        userDefaults.removeObject(forKey: "question_nineQuestion")
        userDefaults.removeObject(forKey: "question_tenthQuestion")
        userDefaults.removeObject(forKey: "question_elevenQuestion")
        userDefaults.removeObject(forKey: "question_twelthQuestion")
        userDefaults.removeObject(forKey: "question_thirteenQuestion")
        userDefaults.removeObject(forKey: "question_FourtheenQuestion")
        userDefaults.removeObject(forKey: "question_FifteenQuestion")
        userDefaults.removeObject(forKey: "question_sixteenQuestion")
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        
        let alertController = UIAlertController(title: "LOG-OUT", message: "Are you sure you want to log-out?", preferredStyle: .alert)
        
        let sendButton = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            self.removeCache()
            obj_app.setRootViewController()
        })
        
        let cancelButton = UIAlertAction(title: "NO", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(sendButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        if Validation() {
            
            CustomUserDefault.setUserName(data: txtName.text!)
            CustomUserDefault.setUserEmail(data: txtEmailAddress.text!)
            CustomUserDefault.setPhoneNumber(data: txtNumber.text!)
            
            UserDefaults.standard.set(txtAddress1.text, forKey: "placeOrderAddress")
            UserDefaults.standard.set(txtAddress2.text, forKey: "address2")
            CustomUserDefault.setUserPinCode(data: txtPostCode?.text ?? "")
            
            UserDefaults.standard.set(txtAccount.text, forKey: "accountNumber")
            UserDefaults.standard.set(txtNameOnCard.text, forKey: "nameOnCard")
            
            Alert.showAlert(strMessage: "Profile has been saved", Onview: self)
        }
    }
    
    @IBAction func onClickHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickOrdres(_ sender: Any) {
        let vc = MyOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = NotificationNew()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
