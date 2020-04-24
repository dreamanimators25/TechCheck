//
//  SocialMobileRegisterVC.swift
//  InstaCash
//
//  Created by Sameer Khan on 23/04/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class SocialMobileRegisterVC: UIViewController {
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let reachability: Reachability? = Reachability()
    var strGetSocialId = ""
    var strSocialType = ""
    var trimmedStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        self.txtMobileNumber.placeholder = "Enter Mobile Number".localized(lang: langCode)
        self.submitButton.setTitle("SUBMIT".localized(lang: langCode), for: UIControlState.normal)
    }
    
    //MARK:- button methods
    
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        
        self.trimmedStr = self.txtMobileNumber.text ?? ""
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if self.trimmedStr.hasPrefix("0") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 1) ?? ""
            }
            
            if self.trimmedStr.hasPrefix("91") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 2) ?? ""
            }
            
            if self.trimmedStr.isEmpty {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else if self.trimmedStr.count < 10 || self.trimmedStr.count > 10 {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else {
                self.fireWebServiceForGoogleLogin()
            }
        
        }else if CustomUserDefault.getCurrency() == "RM" {
            
            if self.trimmedStr.hasPrefix("0") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 1) ?? ""
            }
            
            if self.trimmedStr.hasPrefix("60") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 2) ?? ""
            }
            
            if self.trimmedStr.isEmpty {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else if self.trimmedStr.count < 8 || self.trimmedStr.count > 11 {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else {
                self.fireWebServiceForGoogleLogin()
            }
            
        }else if CustomUserDefault.getCurrency() == "SG$" {
            
            //if self.trimmedStr.hasPrefix("0") && self.trimmedStr.length > 1 {
                //trimmedStr = txtMobileNumber.text?.substring(fromIndex: 1) ?? ""
            //}
            
            if self.trimmedStr.hasPrefix("65") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 2) ?? ""
            }
            
            if self.trimmedStr.isEmpty {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else if self.trimmedStr.count < 8 || self.trimmedStr.count > 11 {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else {
                self.fireWebServiceForGoogleLogin()
            }
            
        }else {
            //"NT$"
            //if self.trimmedStr.hasPrefix("0") && self.trimmedStr.length > 1 {
                //trimmedStr = txtMobileNumber.text?.substring(fromIndex: 1) ?? ""
            //}
            
            if self.trimmedStr.hasPrefix("886") && self.trimmedStr.length > 1 {
                trimmedStr = txtMobileNumber.text?.substring(fromIndex: 2) ?? ""
            }
            
            if self.trimmedStr.isEmpty {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else if self.trimmedStr.count < 9 || self.trimmedStr.count > 9 {
                Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            }else {
                self.fireWebServiceForGoogleLogin()
            }
        }
        
    }
    
    @IBAction func btnResignPressed(_ sender: UIButton) {
    
    }
    
    //MARK:- web service methods
    
    func otpApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForGoogleLogin()
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
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                internalOTP = "1"
            }
            else{
                internalOTP = "0"
            }
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            
            strUrl = strBaseURL + "socialMobileConnect"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile" : self.trimmedStr,
                "socialMediaType" : strSocialType,
                "socialMediaId" : strGetSocialId,
                "GCMId" : strGCMToken,
                "internalOTP" : internalOTP,
                "OTPLength" : "4"
            ]
            
            print(parameters)
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let dictUser = responseObject?["msg"] as! NSDictionary
                        CustomUserDefault.setPhoneNumber(data: self.trimmedStr)
                        
                        if ((responseObject?.value(forKeyPath: "msg.customerId")) != nil){
                            CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                        }
                        
                        if ((responseObject?.value(forKeyPath: "msg.email")) != nil){
                            CustomUserDefault.setUserEmail(data: dictUser.value(forKey: "email") as! String)
                        }
                        
                        if ((responseObject?.value(forKeyPath: "msg.name")) != nil){
                            CustomUserDefault.setUserName(data: dictUser.value(forKey: "name") as! String)
                        }                        
                        
                        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                            
                            DispatchQueue.main.async {
                                let vc = MobileNumberVC()
                                //vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                                vc.isOnleMobileNumber = true
                                vc.isOtpGet = true
                                vc.strMobileNumberStore = self.trimmedStr //self.txtMobileNumber.text!
                                self.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                        }
                        else{
                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                        }
                                                
                    }
                    else{
                        Alert.showAlert(strMessage: responseObject?["msg"] as! NSString, Onview: self)
                    }
                    
                }
                else
                {
                    Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                }
            })
        }
        else
        {
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
