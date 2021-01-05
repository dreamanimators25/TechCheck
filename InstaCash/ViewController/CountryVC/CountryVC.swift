//
//  CountryVC.swift
//  TechCheck
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import CoreTelephony
import GoogleSignIn
import AuthenticationServices
import FacebookCore
import FBSDKLoginKit

class CountryVC: UIViewController,CLLocationManagerDelegate,GIDSignInDelegate,UITextFieldDelegate, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var txtPhoneNumer: UITextField!
    @IBOutlet weak var btnGPlus: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgInterNetOff: UIImageView!
    @IBOutlet weak var signInButtonStack: UIStackView!
    
    let reachability: Reachability? = Reachability()
    //var arrCountry = [CountryModel]()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    //var idBaseUrl =  -1 //s.
    var idBaseUrl =  0
    var strCountry = String()
    var isOtpGet = false
    var iscomingFromPlaceOrder = false
    var isChangeLocation = false
 
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // ...
        
        //Sameer 4/5/2020
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = true
            self.setUpSignInAppleButton()
            
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            //statusbarView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 127.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            statusbarView.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            self.btnApple.isHidden = true
            //591091
            
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            //statusBar?.backgroundColor = UIColor.init(red: 0.0/255.0, green: 127.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            statusBar?.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
        }
        
        //self.changeLanguageOfUI()
                
        txtPhoneNumer.autocorrectionType = .no
        //getCountryBySimCard()
        
        //Set navigation Bar
        setNavBar()
        
        // This function set view border and shadow
        
        //Sameer 24/9/20
        /*
        //get country from firebase
        if reachability.connection.description != "No Connection" {
            CountryModel.fetchCountryFromFireBase(isInterNet:true,getController: self) { (arrCountry) in
                
                Alert.HideProgressHud(Onview: self.view)
                
                if arrCountry.count > 0 {
                    self.arrCountry = arrCountry
                    self.setLocation()
                    self.btnNext.isHidden = false
                    self.lblMessage.isHidden = true
                    self.imgInterNetOff.isHidden = true
                }
                else{

                }
            }
        }
        else{
            self.lblMessage.isHidden = false
            self.imgInterNetOff.isHidden = false
            self.btnNext.isHidden = true
        }*/
        
        // Sameer 24/9/20
        userDefaults.set(UKBabseUrl, forKey: "baseURL")
        userDefaults.set("UK", forKey: "countryName")
        userDefaults.set("+44", forKey: "countryCode")
        CustomUserDefault.removeCurrency()
        CustomUserDefault.setCurrency(data: "£")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func changeLanguageOfUI() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Disable gesture pop to controller
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    // MARK: - Notification oberserver methods
    @objc func didBecomeActive() {
        if isChangeLocation == false{
            isChangeLocation = true
        }
    }
    
    @objc func willEnterForeground() {
        //setLocation()
    }
    
    //Mark:- notfify method when internet off
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        if reachability.connection == .wifi {
        
        } else {
        
        }
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        
    }
    
    //MARK: set nav bar
    func setNavBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setCountryValue(str:String) {
        
    }
    
    @IBAction func onClickSelectCountry(_ sender: Any) {
        
    }

    //MARK:- button action methods
    @IBAction func btnFacebookPressed(_ sender: Any) {
        
        if self.reachability?.connection.description != "No Connection" {
    
            let fbLoginManager : LoginManager = LoginManager()
            
            fbLoginManager.logOut()
            
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                
                if (error == nil){
                    let fbloginresult : LoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((AccessToken.current) != nil){
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender "]).start(completionHandler: { (connection, result, error) -> Void in
                                    
                                    if (error == nil) {
                                        
                                        let dict = result as! NSDictionary
                                        var strFinalUserName  = ""
                                        var fbId = ""
                                        var email = ""
                                        var imageUrl = ""
                                        
                                        
                                        if (dict.value(forKey: "name") != nil){
                                            strFinalUserName = dict.value(forKey: "name") as! String
                                        }
                                        else{
                                            strFinalUserName = ""
                                        }
                                        
                                        CustomUserDefault.removeUserName()
                                        CustomUserDefault.setUserName(data: strFinalUserName)
                                        
                                        if (dict.value(forKey: "id") != nil){
                                            fbId = dict.value(forKey: "id") as! String
                                        }
                                        else{
                                            fbId = ""
                                        }
                                        
                                        if (dict.value(forKey: "email") != nil){
                                            email = dict.value(forKey: "email") as! String
                                        }
                                        else{
                                            email = ""
                                        }
                                        
                                        CustomUserDefault.removeUserEmail()
                                        CustomUserDefault.setUserEmail(data: email)
                                        
                                        if (dict.value(forKeyPath: "picture.data.url") != nil){
                                            imageUrl = dict.value(forKeyPath: "picture.data.url") as! String
                                        }
                                        else{
                                            imageUrl = ""
                                        }
                                        
                                        CustomUserDefault.removeUserProfile()
                                        CustomUserDefault.setUserProfileImage(data: imageUrl)
                                        
                                        self.fireWebServiceForFbLogin(userName: strFinalUserName, socialId: fbId, email: email, strProfile: imageUrl, strFbOrGp:"facebook")
                                        
                                    }else {
                                        print(error ?? "")
                                        Alert.showAlertWithError(strMessage: "oops,something went wrong".localized(lang: langCode) as NSString, Onview: self)
                                    }
                                })
                            }
                        }
                    }
                } else {
                    self.showaAlert(message: error?.localizedDescription ?? "", title: "Error !!")
                }
            }
        }else {
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    @IBAction func btnGPlusPressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnApplePressed(_ sender: UIButton) {
        if self.reachability?.connection.description != "No Connection" {
            self.handleAppleIdRequest()
        }
        else {
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    //MARK:Apple SignIn Delegate
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.frame = self.btnApple.frame
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.cornerRadius = 5
            //Add button on some view or stack
            self.signInButtonStack.addArrangedSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            if self.reachability?.connection.description != "No Connection" {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.performRequests()
            }
            else {
                Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            //let appleToken = appleIDCredential.identityToken
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            if let name = fullName {
                CustomUserDefault.removeUserName()
                CustomUserDefault.setUserName(data: name.givenName ?? "")
            }
            
            if let mail = email {
                CustomUserDefault.removeUserEmail()
                CustomUserDefault.setUserEmail(data: mail)
            }
         
            self.fireWebServiceForFbLogin(userName: "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")", socialId: userIdentifier, email: email ?? "", strProfile: "", strFbOrGp: "apple")
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        Alert.showAlertWithError(strMessage: "oops,something went wrong".localized(lang: langCode) as NSString, Onview: self)
    }
    
    //MARK:Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
        } else {
            if self.reachability?.connection.description != "No Connection" {
                var strFinalUserName  = ""
                var gPlusId = ""
                var email = ""
                var imageUrl = ""
                
                if (user?.profile.name != nil) {
                    strFinalUserName = (user?.profile.name)!
                    
                    CustomUserDefault.removeUserName()
                    CustomUserDefault.setUserName(data: strFinalUserName)
                }
                else{
                    strFinalUserName = ""
                }
                
                if (user?.userID != nil) {
                    gPlusId = (user?.userID)!
                }
                else{
                    gPlusId = ""
                }
                
                if (user?.profile.email != nil){
                    email = (user?.profile.email)!
                    
                    CustomUserDefault.removeUserEmail()
                    CustomUserDefault.setUserEmail(data: email)
                }
                else{
                    email = ""
                }
                
                if user.profile.hasImage {
                    if let url = user.profile.imageURL(withDimension:100) {
                        
                        let abURL = url.absoluteString
                        CustomUserDefault.setUserProfileImage(data: abURL)
                        
                        do {
                            let contents = try String(contentsOf: url)
                            imageUrl = contents
                            
                            CustomUserDefault.setUserProfileImage(data: imageUrl)
                            
                        } catch {
                             print("contents could not be loaded")
                        }
                    } else {
                        print("the URL was bad!")
                    }
                }
                else {
                    imageUrl = ""
                }
                
                self.fireWebServiceForFbLogin(userName:strFinalUserName, socialId: gPlusId, email: email, strProfile: imageUrl,strFbOrGp: "gplus")
            }
            else {
                Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
            }
            
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            // ...
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: Error!,_: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITextfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
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
    }
    
    //MARK:- web service methods
    func loginApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForFbLogin(userName:String, socialId:String, email:String, strProfile:String, strFbOrGp:String)
    {
        if reachability?.connection.description != "No Connection" {
            
            var strGCMToken = ""
            
            if (userDefaults.value(forKey: "FCMToken") != nil) {
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else {
                strGCMToken = ""
            }
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            
            var strUrl =  ""
            var parameters = [String: Any]()
            
            if strFbOrGp == "gplus" {
                strUrl = strBaseURL + "customerLogingPlus"
                
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "gPlusId": socialId,
                    "GCMId" : strGCMToken,
                    "name":userName,
                    "email":email,
                    "profileImage":strProfile,
                    "profileData":[:]
                ]
                
            }else if strFbOrGp == "apple" {
                strUrl = strBaseURL + "customerLoginApple"
                
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "appleId" : socialId,
                    "GCMId" : strGCMToken,
                    "name" : userName,
                    "email" : email
                ]
                
                print(parameters)
            }
            else{
                strUrl = strBaseURL + "customerLoginFacebook"
                
                parameters = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "facebookId": socialId,
                    "GCMId" : strGCMToken,
                    "name":userName,
                    "email":email,
                    "profileImage":strProfile,
                    "profileData":[:]
                ]
            }
            
            print(parameters)
            
            self.loginApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        //CustomUserDefault.removeUserProfile()
                        //CustomUserDefault.setUserProfileImage(data: strProfile)
                        //CustomUserDefault.setUserEmail(data: email)
                        
                        /* Sameer 23/4/2020
                        if self.arrCountry.count == self.idBaseUrl {
                        userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL") //sm
                            
                            userDefaults.set("Taiwan", forKey: "countryName")
                            userDefaults.set("+886", forKey: "countryCode")
                            CustomUserDefault.removeCurrency()
                            CustomUserDefault.setCurrency(data: "NT$")
                        }else {
                            
                            if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                            userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
                            }else {
                                
                                let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                                userDefaults.set(straseUrl, forKey: "baseURL") //sm
                            }
                            
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                            CustomUserDefault.removeCurrency()
                            CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                        }
                        */
                        
                        
                        //sameer 24/9/2020
                        /*
                        let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                        userDefaults.set(straseUrl, forKey: "baseURL") //sm
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                        CustomUserDefault.removeCurrency()
                        CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                        */
                        
                        
                        //s.
                        let dictMsg = responseObject?["msg"] as! NSDictionary
                        
                        if dictMsg.value(forKeyPath: "status") as! String == "unverified" {
                            
                            /*
                            let vc = MobileNumberVC()
                            vc.strGetSocialId = socialId
                            vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                            vc.strSocialType = strFbOrGp
                            vc.isOtpGet = true
                            vc.strMobileNumberStore = self.txtPhoneNumer.text!
                            self.navigationController?.present(vc, animated: true, completion: nil)
                            */
                            
                            CustomUserDefault.setUserId(data: dictMsg.value(forKey: "userId") as! String)
                            
                            if ((responseObject?.value(forKeyPath: "msg.mobile")) != nil) {
                                
                                CustomUserDefault.setPhoneNumber(data: (responseObject?.value(forKeyPath: "msg.mobile") as? String ?? ""))
                            }
                        
                            //Sameer 23/4/2020
                            //obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                            
                            //*
                            DispatchQueue.main.async {
                                let vc = SocialMobileRegisterVC()
                                let nav = UINavigationController(rootViewController: vc)
                                nav.navigationBar.isHidden = true
                                
                                vc.strSocialType = strFbOrGp
                                vc.strGetSocialId = socialId
                                
                                nav.modalPresentationStyle = .overCurrentContext
                                nav.modalTransitionStyle = .crossDissolve
                                self.present(nav, animated: true, completion: nil)
                                
                            }//*/
                            
                        }
                        else{
                        
                            let dictUser = responseObject?["msg"] as! NSDictionary
                            
                            if ((responseObject?.value(forKeyPath: "msg.mobile")) != nil){
                                CustomUserDefault.setPhoneNumber(data: (responseObject?.value(forKeyPath: "msg.mobile") as? String ?? ""))
                            }
                            
                            //CustomUserDefault.setUserProfile(data: dictUser)
                            CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                            
                            if self.iscomingFromPlaceOrder {
                                obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                            }
                            else{
                                obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
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
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    @IBAction func btnNextPressed(_ sender: UIButton) {
        
        /* Sameer 23/4/2020
        if self.arrCountry.count == self.idBaseUrl {
            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL") //sm
            
            userDefaults.set("Taiwan", forKey: "countryName")
            userDefaults.set("+886", forKey: "countryCode")
            CustomUserDefault.removeCurrency()
            CustomUserDefault.setCurrency(data: "NT$")
        }else {
            
            if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                
                userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
            }else {
                
                let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                userDefaults.set(straseUrl, forKey: "baseURL") //sm
            }
            
            userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
            userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
            CustomUserDefault.removeCurrency()
            CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
        }
        */
        
        //let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint
        //userDefaults.set(straseUrl, forKey: "baseURL")
        
        // Sameer 24/9/2020
        /*
        userDefaults.set(arrCountry[idBaseUrl].strName, forKey: "countryName")
        userDefaults.set(arrCountry[idBaseUrl].strCountryCode, forKey: "countryCode")
        CustomUserDefault.removeCurrency()
        CustomUserDefault.setCurrency(data:arrCountry[idBaseUrl].strCurrencySymbole ?? "")
        */
        
        self.txtPhoneNumer.resignFirstResponder()
        if (txtPhoneNumer.text?.isEmpty)!{
            Alert.showAlertWithError(strMessage: "Please enter mobile number".localized(lang: langCode) as NSString, Onview: self)
        }
            
        /*
        else if(!validatePhoneNo(value: txtPhoneNumer.text!)){
            Alert.showAlert(strMessage: "Please enter valid mobile number", Onview: self)
        }
        else if(!txtPhoneNumer.text!.isValidContact){
            Alert.showAlert(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
        }
        */
            
        else {
            fireWebServiceForMobileNumberLogin(isResend: false)
        }
    }
    
    func fireWebServiceForMobileNumberRegister(isResend : Bool)
    {
        if reachability?.connection.description != "No Connection" {
            var strGCMToken = ""
            var internalOTP = ""
            
            if (userDefaults.value(forKey: "FCMToken") != nil) {
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
            
            if CustomUserDefault.getCurrency() == "£" {
                internalOTP = "1"
            }
            else{
                internalOTP = "0"
            }
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile": txtPhoneNumer.text!,
                "name":"",
                "email":"",
                "GCMId":strGCMToken,
                "password":"",
                "preVerified":"0"
            ]
            
            print(parameters)
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let vc = MobileNumberVC()
                        vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                        vc.isOnleMobileNumber = true
                        vc.isOtpGet = true
                        vc.strMobileNumberStore = self.txtPhoneNumer.text!
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.present(vc, animated: true, completion: nil)
                        
                        /*
                        if responseObject?.value(forKeyPath: "msg.status") as? String == "verified" {
                            
                            let dictUser = responseObject?["msg"] as! NSDictionary
                            CustomUserDefault.setPhoneNumber(data: self.txtPhoneNumer.text!)
                            CustomUserDefault.setUserName(data: (dictUser.value(forKey: "name") as? String)!)
                            CustomUserDefault.setUserProfileImage(data: "")
                            CustomUserDefault.setUserProfile(data: dictUser)
                            
                            if dictUser.value(forKey: "userId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                            }

                            if dictUser.value(forKey: "customerId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                            }
                            
                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                        }
                        else
                        {
                            let vc = MobileNumberVC()
                            vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                            vc.isOnleMobileNumber = true
                            vc.isOtpGet = true
                            vc.strMobileNumberStore = self.txtPhoneNumer.text!
                            vc.modalPresentationStyle = .fullScreen
                            self.navigationController?.present(vc, animated: true, completion: nil)
                        }*/
                    }
                    else
                    {
                        
                    }
                }
                else
                {
                    
                }
            })
            
        }
        else
        {
            lblMessage.isHidden = false
            lblMessage.text = "No connection found".localized(lang: langCode)
        }
        
    }
    
    func fireWebServiceForMobileNumberLogin(isResend:Bool)
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
            //strUrl = strBaseURL + "customerRegister"
            strUrl = strBaseURL + "sendOTP"
            
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                
            if CustomUserDefault.getCurrency() == "£" {
                
                internalOTP = "1"
            }
            else{
                internalOTP = "0"
            }
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile" : txtPhoneNumer.text!,
                "GCMId":strGCMToken,
                "preVerified":"0",
                "OTPLength":"4"
            ]
            
            print(strUrl)
            print(parameters)
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        if responseObject?.value(forKeyPath: "status") as? String == "Success" {
                            
                            //let dictUser = responseObject?["msg"] as! NSDictionary
                            CustomUserDefault.setPhoneNumber(data: self.txtPhoneNumer.text!)
                            
                            /*
                            CustomUserDefault.setUserNmae(data: (dictUser.value(forKey: "name") as? String)!)
                            CustomUserDefault.setUserProfileImage(data: "")
                            CustomUserDefault.setUserProfile(data: dictUser)
                            if dictUser.value(forKey: "userId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                                
                            }
                            if dictUser.value(forKey: "customerId") != nil {
                                CustomUserDefault.setUserId(data: dictUser.value(forKey: "customerId") as! String)
                            }
                            
                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                             */
                            
                            let vc = MobileNumberVC()
                            vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                            vc.isOnleMobileNumber = true
                            vc.isOtpGet = true
                            vc.strMobileNumberStore = self.txtPhoneNumer.text!
                            vc.modalPresentationStyle = .fullScreen
                            self.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        else
                        {
                            self.fireWebServiceForMobileNumberRegister(isResend: false)
                        }
                    }
                    else {
                        self.fireWebServiceForMobileNumberRegister(isResend: false)
                    }
                }
                else
                {
                    //Alert.showAlert(strMessage: responseObject?["msg"] as! NSString, Onview: self)
                    self.fireWebServiceForMobileNumberRegister(isResend: false)
                }
            })
            
        }
        else {
            lblMessage.isHidden = false
            lblMessage.text = "No connection found".localized(lang: langCode)
        }
        
    }
    
    func otpApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    //MARK:- Navigate to welcome screen
    func pushToWelcomeScreen() {
        let appconfiq = AppConfig()
        let vc = WelcomeVC()
        appconfiq.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
    }
    
    //MARK:- get country by simcard
    func getCountryBySimCard() {
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.subscriberCellularProvider {
           // print("country code is: " + carrier.mobileCountryCode!);
            
            //will return the actual country code
            //print("ISO country code is: " + carrier.isoCountryCode!);

            if carrier.isoCountryCode != nil {
            if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: carrier.isoCountryCode!) {
                
                // Country name was found
                strCountry = name
                
                // Sameer 24/9/20
                /*
                for index in 0..<self.arrCountry.count {
                    if self.arrCountry[index].strName == name
                    {
                        self.idBaseUrl = index
                        
                        /* Sameer 23/4/2020
                        if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                        userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
                            
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                            CustomUserDefault.removeCurrency()
                            CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                            
                        }else if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "RM" || self.arrCountry[self.idBaseUrl].strCurrencySymbole == "SG$" {
                            
                            let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                            userDefaults.set(straseUrl, forKey: "baseURL") //sm
                            
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                            userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                            CustomUserDefault.removeCurrency()
                            CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                        }else {
                            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL")
                            
                            userDefaults.set("Taiwan", forKey: "countryName")
                            userDefaults.set("+886", forKey: "countryCode")
                            CustomUserDefault.removeCurrency()
                            CustomUserDefault.setCurrency(data:"NT$")
                        }
                        */
                
                        self.arrCountry[index].isSelected = true
                        
                        // Sameer 23/4/2020
                        let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint
                        userDefaults.set(straseUrl, forKey: "baseURL")
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                        CustomUserDefault.removeCurrency()
                        CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                
                    }
                    else{
                        self.arrCountry[index].isSelected = false
                    }
                }*/
            } else {
                // Country name cannot be found
            }
        }

        }
        else{
            //no sim
            //setLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Locale {
    static let currencies = Dictionary(uniqueKeysWithValues: Locale.isoRegionCodes.map {
        region -> (String, (code: String, symbol: String, locale: Locale)) in
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: region]))
        return (region, (locale.currencyCode ?? "", locale.currencySymbol ?? "", locale))
    })
}

extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}
