//
//  MobileNumberVC.swift
//  InstaCash
//
//  Created by InstaCash on 15/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class MobileNumberVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    
    let reachability: Reachability? = Reachability()
    var strGetSocialId = ""
    var strMobileNumberStore = ""
    var strSocialType = ""
    var counter = 30
    var timer = Timer()
    var isOtpGet = false
    var isComingToCheckForPlaceOrder = false
    var isOnleMobileNumber = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt1.autocorrectionType = .no
        txt2.autocorrectionType = .no
        txt3.autocorrectionType = .no
        txt4.autocorrectionType = .no
        
    }
    
    //MARK:- uitextfield delegate methpds
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // On inputing value to textfield
        if ((textField.text?.count)! < 1  && string.count > 0){
            if(textField == txt1){
                txt2.becomeFirstResponder()
            }
            if(textField == txt2){
                txt3.becomeFirstResponder()
            }
            if(textField == txt3){
                txt4.becomeFirstResponder()
            }
            if(textField == txt4){
                txt4.resignFirstResponder()
            }
            textField.text = string
            return false
            
        }else if ((textField.text?.count)! >= 1  && string.count == 0){
            // on deleting value from Textfield
            if(textField == txt2){
                txt1.becomeFirstResponder()
            }
            if(textField == txt3){
                txt2.becomeFirstResponder()
            }
            if(textField == txt4) {
                txt3.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }else if ((textField.text?.count)! >= 1  ){
            textField.text = string
            return false
        }
        return true
    }
    
    //MARK:- button methods
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
        
        if(txt1.text?.count ?? 0 <= 0 || txt2.text?.count ?? 0 <= 0 || txt3.text?.count ?? 0 <= 0 || txt4.text?.count ?? 0 <= 0)
        {
            Toast(text:"Please enter OTP with 4 digits").show()
        }
        else
        {
            if isOtpGet
            {
                fireWebServiceForLoginWithOtp()
            }
            else
            {
                fireWebServiceForMobileNumberLogin(isResend: false)
            }
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResendPresed(_ sender: UIButton) {
        
        fireWebServiceForFbLogin(isResend: true)
    }
    
    //MARK:- web service methods
    
    func otpApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    
    func fireWebServiceForFbLogin(isResend:Bool)
    {
        if reachability?.connection.description != "No Connection"{
            var strGCMToken = ""
            var internalOTP = ""
            
            
            if (userDefaults.value(forKey: "FCMToken") != nil){
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else{
                strGCMToken = ""
            }
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            
            if isResend{
                strUrl = strBaseURL + "resendOTP"
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "mobile": strMobileNumberStore
                ]
            }
            else{
                strUrl = strBaseURL + "socialMobileConnect"
                
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                    
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    internalOTP = "1"
                }
                else{
                    internalOTP = "0"
                }
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "mobile": strMobileNumberStore,
                    "socialMediaType":strSocialType,
                    "socialMediaId":strGetSocialId,
                    "GCMId":strGCMToken,
                    "internalOTP":internalOTP,
                    "OTPLength":"4"
                ]
            }
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        if isResend == false{
                            if internalOTP == "0"{
                                //txtPhoneNumer.text =
                                let dictUser = responseObject?["msg"] as! NSDictionary
                                CustomUserDefault.setPhoneNumber(data: self.strMobileNumberStore)
                                CustomUserDefault.setUserProfile(data: dictUser)
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                                CustomUserDefault.setUserName(data: dictUser.value(forKey: "name") as! String)
                                
                                if self.isComingToCheckForPlaceOrder {
                                    obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                                }
                                else {
                                    obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                }
                            }
                            else
                            {
                                self.txt1.text = ""
                                self.txt2.text = ""
                                self.txt3.text = ""
                                self.txt4.text = ""
                                
                                self.isOtpGet = true
                                
                                //                                if responseObject?.value(forKeyPath: "msg.otp") != nil{
                                //                                    self.fireWebServiceForLoginWithOtp()
                                //                                }
                                
                            }
                        }
                    }
                    else{
                        if isResend{
                            Alert.showAlert(strMessage: responseObject?["msg"] as! NSString, Onview: self)
                        }
                    }
                    
                }
                else
                {
                    
                }
            })
            
        }
        else
        {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
    }
    
    func fireWebServiceForLoginWithOtp()
    {
        if reachability?.connection.description != "No Connection"{
            var strGCMToken = ""
            
            if (userDefaults.value(forKey: "FCMToken") != nil){
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else{
                strGCMToken = ""
            }
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            strUrl = strBaseURL + "customerLoginOTP"
            
            let parameters:[String: Any]  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile": strMobileNumberStore,
                "otp":self.txt1.text! + self.txt2.text! + self.txt3.text! + self.txt4.text!,
                "GCMId":strGCMToken,
            ]
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        self.view.endEditing(true)
                        let dictUser = responseObject?["msg"] as! NSDictionary
                        CustomUserDefault.setPhoneNumber(data: self.strMobileNumberStore)
                        CustomUserDefault.setUserProfile(data: dictUser)
                        CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                        CustomUserDefault.setUserProfileImage(data: "")
                        CustomUserDefault.setUserName(data: (dictUser.value(forKey: "name") as? String)!)
                        
                        if self.isComingToCheckForPlaceOrder{
                            obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                        }
                        else{
                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                        }
                    }
                    else{
                        
                        Toast(text:responseObject!["msg"] as? String).show()
                    }
                }
                else
                {
                    
                }
            })
        }
        else
        {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fireWebServiceForMobileNumberLogin(isResend:Bool)
    {
        if reachability?.connection.description != "No Connection" {
            var strGCMToken = ""
            var internalOTP = ""
            
            if (userDefaults.value(forKey: "FCMToken") != nil){
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else{
                strGCMToken = ""
            }
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "customerRegister"
            
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                internalOTP = "1"
            }
            else{
                internalOTP = "0"
            }
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile": self.strMobileNumberStore,
                "name":"",
                "email":"",
                "GCMId":strGCMToken,
                "password":"",
                "preVerified":"0"
            ]
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success"{
                        if responseObject?.value(forKeyPath: "msg.status") as? String == "verified"{
                            
                            let dictUser = responseObject?["msg"] as! NSDictionary
                            CustomUserDefault.setPhoneNumber(data: self.strMobileNumberStore)
                            CustomUserDefault.setUserName(data: (dictUser.value(forKey: "name") as? String)!)
                            CustomUserDefault.setUserProfileImage(data: "")
                            CustomUserDefault.setUserProfile(data: dictUser)
                            if dictUser.value(forKey: "userId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                                
                            }
                            if dictUser.value(forKey: "customerId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                                
                            }
                            if self.isComingToCheckForPlaceOrder{
                                obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                            }
                            else{
                                obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                            }
                        }
                        else{
                            if isResend == false{
                                if internalOTP == "0"{
                                    let dictUser = responseObject?["msg"] as! NSDictionary
                                    if self.isOnleMobileNumber{
                                        self.txt1.text = ""
                                        self.txt2.text = ""
                                        self.txt3.text = ""
                                        self.txt4.text = ""
                                        self.isOtpGet = true
                                        
                                    }
                                    else{
                                        CustomUserDefault.setPhoneNumber(data: self.strMobileNumberStore)
                                        CustomUserDefault.setUserProfile(data: dictUser)
                                        CustomUserDefault.setUserName(data: (dictUser.value(forKey: "name") as? String)!)
                                        
                                        if dictUser.value(forKey: "userId") != nil {
                                            CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                                            
                                        }
                                        
                                        if dictUser.value(forKey: "customerId") != nil {
                                            CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                                            
                                        }
                                        
                                        if self.isComingToCheckForPlaceOrder{
                                            obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                                        }
                                        else{
                                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                        }
                                        
                                    }
                                }
                                else{
                                    self.txt1.text = ""
                                    self.txt2.text = ""
                                    self.txt3.text = ""
                                    self.txt4.text = ""
                                    self.isOtpGet = true
                                }
                            }
                        }
                    }
                    else{
                        
                    }
                    
                }
                else
                {
                    
                }
            })
            
        }
        else
        {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
        
    }
    
}
