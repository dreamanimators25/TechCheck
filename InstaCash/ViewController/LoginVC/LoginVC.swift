//
//  LoginVC.swift
//  InstaCash
//  Created by Prakhar Gupta on 9/6/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TrueSDK

//MARK: Error display
class LoginVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,TCTrueSDKDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var btnMobileNumber: UIButton!
    @IBOutlet weak var btnGPlus: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnTrueCaller: UIButton!
    let reachability: Reachability? = Reachability()
    
    var strTrueCallerId = ""
    var strTrueCallerName = ""
    var strTrueCallerImage = ""
    var strTrueEmail = ""
    var strTrueMobile = ""
    
    var isTrueCallerSuccess = false
    var iscomingFromPlaceOrder = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set navigation Bar
        setNavBar()
        //setViewDynamically
        viewSetDynamic()
        // Do any additional setup after loading the view.
    }
    
    //MARK: set nav bar
    
    func setNavBar(){
        self.navigationController?.navigationBar.isHidden = false
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(LoginVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button back method
    
    @objc func btnBackPressed(sender:UIButton){
        if iscomingFromPlaceOrder{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
        }
    }
    
    //MARK:- set view dynamicaly
    func viewSetDynamic(){
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if userDefaults.value(forKey: "isTrueCallerSupported")  as! Bool == true{
                btnTrueCaller.isHidden = false
            }
            else{
                btnTrueCaller.isHidden = true
            }
        }
        else{
            btnTrueCaller.isHidden = true
        }
        btnGPlus.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnGPlus.clipsToBounds = true
        btnFb.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnFb.clipsToBounds = true
        btnTrueCaller.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnTrueCaller.clipsToBounds = true
    }
    
    //MARK:- Button action methods
    
    @IBAction func btnMobileNumberPressed(_ sender: UIButton) {
        let vc = MobileNumberVC()
        vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
        vc.isOnleMobileNumber = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnTrueCallerPressed(_ sender: UIButton) {
        if userDefaults.value(forKey: "isTrueCallerSupported") as! Bool == false{
        }
        else{
            TCTrueSDK.sharedManager().delegate = self
            TCTrueSDK.sharedManager().requestTrueProfile()
        }
    }
    
    @IBAction func btnFbPressed(_ sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                if (result?.isCancelled)!{
                }
                else{
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    @IBAction func btnGPlusPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnContinueGuestPressed(_ sender: UIButton) {
    
    }
    
    //MARK:- get fbUser data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    if self.reachability?.connection.description != "No Connection"{
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
                        if (dict.value(forKeyPath: "picture.data.url") != nil){
                            imageUrl = dict.value(forKeyPath: "picture.data.url") as! String
                        }
                        else{
                            imageUrl = ""
                        }
                        CustomUserDefault.removeUserProfile()
                        CustomUserDefault.setUserProfileImage(data: imageUrl)
                        self.fireWebServiceForFbLogin(userName:strFinalUserName, socialId: fbId, email: email, strProfile: imageUrl,strFbOrGp:"facebook")
                    }
                    else{
                        Alert.showAlert(strMessage: "No connection found", Onview: self)
                    }
                }
            })
        }
    }
    //MARK:Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
        } else {
            if self.reachability?.connection.description != "No Connection"{
                var strFinalUserName  = ""
                var gPlusId = ""
                var email = ""
                var imageUrl = ""
                
                if (user?.profile.name != nil){
                    strFinalUserName = (user?.profile.name)!
                    CustomUserDefault.removeUserName()
                    CustomUserDefault.setUserName(data: strFinalUserName)
                }
                else{
                    strFinalUserName = ""
                }
                
                if (user?.userID != nil){
                    gPlusId = (user?.userID)!
                }
                else{
                    gPlusId = ""
                }
                if (user?.profile.email != nil){
                    email = (user?.profile.email)!
                }
                else{
                    email = ""
                }
                if user.profile.hasImage{
                    if let url = user.profile.imageURL(withDimension:100)  {
                        do {
                            let contents = try String(contentsOf: url)
                            imageUrl = contents
                            
                        } catch {
                            // contents could not be loaded
                        }
                    } else {
                        // the URL was bad!
                    }
                }
                else{
                    imageUrl = ""
                    
                }
                self.fireWebServiceForFbLogin(userName:strFinalUserName, socialId: gPlusId, email: email, strProfile: imageUrl,strFbOrGp: "gplus")
            }
            else{
                Alert.showAlert(strMessage: "No connection found", Onview: self)
                
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
    
    //MARK:- textfield flight
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.utf8CString.count)! > 10
        {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
            else
            {
                //Alert.showAlert(strMessage: "10 characters are allowed", Onview: self)
                return false
            }
            
        }
        else
        {
            return true
            
        }
    }
    
    //MARK:- web service methods
    
    func loginApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForFbLogin(userName:String,socialId:String,email:String,strProfile:String,strFbOrGp:String)
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
            var strUrl =  ""
            var parameters = [String: Any]()
            
            if strFbOrGp == "gplus"{
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
            
            
            self.loginApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success"{
                        
                        CustomUserDefault.removeUserProfile()
                        CustomUserDefault.setUserProfileImage(data: strProfile)
                        CustomUserDefault.setUserEmail(data: email)
                        
                        let dictMsg = responseObject?["msg"] as! NSDictionary
                        if dictMsg.value(forKeyPath: "status") as! String == "unverified"{
                            
                            let vc = MobileNumberVC()
                            vc.strGetSocialId = socialId
                            vc.isComingToCheckForPlaceOrder = self.iscomingFromPlaceOrder
                            vc.strSocialType = strFbOrGp
                            self.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        else{
                            let dictUser = responseObject?["msg"] as! NSDictionary
                            
                            if ((responseObject?.value(forKeyPath: "msg.mobile")) != nil){
                                CustomUserDefault.setPhoneNumber(data: (responseObject?.value(forKeyPath: "msg.mobile") as? String)!)
                            }
                            CustomUserDefault.setUserProfile(data: dictUser)
                            CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                            if self.iscomingFromPlaceOrder{
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
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
        
    }
    
    func fireWebServiceForTrueCallerLogin()
    {
        if reachability?.connection.description != "No Connection" {
            var strGCMToken = ""
            if (userDefaults.value(forKey: "FCMToken") != nil){
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else{
                strGCMToken = ""
            }
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl =  ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "customerLoginTrueCaller"
            parameters = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "trueId": strTrueCallerId,
                "GCMId" : strGCMToken,
                "name":strTrueCallerName,
                "email":strTrueEmail,
                "profileImage":strTrueCallerImage,
                "phone":strTrueCallerId
            ]
            
            self.loginApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        
                        let dictUser = responseObject?["msg"] as! NSDictionary
                        CustomUserDefault.removeUserName()
                        CustomUserDefault.setUserName(data: self.strTrueCallerName)
                        CustomUserDefault.setUserEmail(data: self.strTrueEmail)
                        CustomUserDefault.removeUserProfile()
                        CustomUserDefault.setUserProfileImage(data: self.strTrueCallerImage)
                        CustomUserDefault.setUserProfile(data: dictUser)
                        CustomUserDefault.setUserId(data: dictUser.value(forKey: "userId") as! String)
                       
                        if self.iscomingFromPlaceOrder{
                            obj_app.setRootWithMrnuForPlaceOreder(isComingFrom:true)
                        }
                        else{
                            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
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
    
    //MARK: - TCTrueSDKDelegate
    open func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        //setEmptyUserData()
        if  error.getCode().rawValue == 4{
            Alert.showAlert(strMessage: "Please login in truecaller app ", Onview: self)
            
        }
    }
    
    open func didReceive(_ profile: TCTrueProfile) {
        if profile.phoneNumber != nil{
            strTrueMobile = profile.phoneNumber!
            let stripped = String(strTrueMobile.dropFirst(3))
            strTrueMobile = stripped
        }
        else{
            strTrueMobile = ""
            
        }
        if profile.firstName != nil{
            if profile.lastName != nil{
                strTrueCallerName = profile.firstName!
            }
            else{
                strTrueCallerName = profile.firstName! + " " + profile.lastName!
                
            }
            
        }
        else{
            strTrueCallerName = ""
            
        }
        if profile.email != nil{
            strTrueEmail = profile.email!
            
        }
        else{
            strTrueEmail = ""
            
        }
        if profile.phoneNumber != nil{
            strTrueCallerId = profile.phoneNumber!
            let stripped = String(strTrueCallerId.dropFirst(3))
            strTrueCallerId = stripped
            
            
        }
        else{
            strTrueCallerId = ""
            
        }
        if profile.avatarURL != nil{
            strTrueCallerImage = profile.avatarURL!
            
        }
        else{
            strTrueCallerImage = ""
            
        }
        if isTrueCallerSuccess{
            fireWebServiceForTrueCallerLogin()
            
        }
        
    }
    
    open func willRequestProfile(withNonce nonce: String) {
        // You may store the nonce string to verify the response
    }
    
    open func didReceive(_ profileResponse : TCTrueProfileResponse) {
        // Response signature and signature algorithm can be fetched from profileResponse
        // Nonce can also be retrieved from response and checked against the one received in willRequestProfile method
        isTrueCallerSuccess = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
