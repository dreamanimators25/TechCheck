//
//  CountryVC.swift
//  InstaCash
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import CoreTelephony
import GoogleSignIn

class CountryVC: UIViewController,CLLocationManagerDelegate,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var btnIndia: UIButton!
    @IBOutlet weak var btnMalaysia: UIButton!
    @IBOutlet weak var btnSingapore: UIButton!
    @IBOutlet weak var btnPhilipines: UIButton!
    @IBOutlet weak var btnTaiwan: UIButton!
    
    @IBOutlet weak var lblIndia: UILabel!
    @IBOutlet weak var lblMalaysia: UILabel!
    @IBOutlet weak var lblSingapore: UILabel!
    @IBOutlet weak var lblPhilipines: UILabel!
    @IBOutlet weak var lblTaiwan: UILabel!
    
    @IBOutlet weak var txtPhoneNumer: UITextField!
    @IBOutlet weak var btnGPlus: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgInterNetOff: UIImageView!
    
    @IBOutlet weak var lblSelCountry: UILabel!
    @IBOutlet weak var lblSelLanguage: UILabel!
    @IBOutlet weak var engView: UIView!
    @IBOutlet weak var chinaView: UIView!
    @IBOutlet weak var hindiView: UIView!
    @IBOutlet weak var engImgView: UIImageView!
    @IBOutlet weak var chinaImgView: UIImageView!
    @IBOutlet weak var hindiImgView: UIImageView!
    @IBOutlet weak var engLbl: UILabel!
    @IBOutlet weak var chinaLbl: UILabel!
    @IBOutlet weak var hindiLbl: UILabel!
    @IBOutlet weak var lblOrLoginWith: UILabel!
    
    let reachability: Reachability? = Reachability()
    var arrCountry = [CountryModel]()
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
        
        self.changeLanguageOfUI()
                
        txtPhoneNumer.autocorrectionType = .no
        getCountryBySimCard()
        
        //Set navigation Bar
        setNavBar()
        
        // This function set view border and shadow
        //get country from firebase
        
        if reachability?.connection.description != "No Connection" {
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
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func changeLanguageOfUI() {
        
        //txtField_email.attributedPlaceholder = NSAttributedString(string: "Email".localized(lang: langCode!),attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.lblSelCountry.text = "   Select Your Country".localized(lang: langCode)
        self.lblIndia.text = "India".localized(lang: langCode)
        self.lblMalaysia.text = "Malaysia".localized(lang: langCode)
        self.lblSingapore.text = "Singapore".localized(lang: langCode)
        self.lblTaiwan.text = "Taiwan".localized(lang: langCode)
        self.lblSelLanguage.text = "   Select Your Language".localized(lang: langCode)
        self.engLbl.text = "English".localized(lang: langCode)
        self.chinaLbl.text = "Chinese".localized(lang: langCode)
        self.hindiLbl.text = "Hindi".localized(lang: langCode)
        self.btnGPlus.setTitle("Login with Google".localized(lang: langCode), for: UIControlState.normal)
        self.txtPhoneNumer.placeholder = "Enter Number".localized(lang: langCode)
        self.lblOrLoginWith.text = "or login with mobile".localized(lang: langCode)
        self.btnNext.setTitle("Login".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    func setModifiedUI() {
        //English Language
        self.engView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.engView.layer.borderWidth = 0.8
        self.engView.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.engImgView.image = #imageLiteral(resourceName: "Selected")
        
        //Chinese Language
        self.chinaView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.chinaView.layer.borderWidth = 0.8
        self.chinaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Hindi Language
        self.hindiView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.hindiView.layer.borderWidth = 0.8
        self.hindiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "unCheck")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Disable gesture pop to controller
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //Sameer on 4/4/20
        self.setModifiedUI()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
//         NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        // set location
      
//        // notify internet is avaible or not
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
//        do{
//            try reachability?.startNotifier()
//        }catch{
//            print("could not start reachability notifier")
//        }
    }

    // MARK: - Notification oberserver methods
    
    @objc func didBecomeActive() {
        if isChangeLocation == false{
            isChangeLocation = true
        }
    }
    
    @objc func willEnterForeground() {
        setLocation()
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
    
    func setCountryValue(str:String)
    {
        if(str == "India")
        {
            self.onClickSelectCountry(btnIndia)
        }
        else if(str == "Malaysia")
        {
            self.onClickSelectCountry(btnMalaysia)
        }
        else if(str == "Singapore")
        {
            self.onClickSelectCountry(btnSingapore)
        }
        else if(str == "Taiwan")
        {
            self.onClickSelectCountry(btnTaiwan)
        }
        else
        {
            self.onClickSelectCountry(btnPhilipines)
        }
    }
    
    /*
    //MARK:- Tableview delegate/Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountry.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCountry = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        cellCountry.lblCountry.text = arrCountry[indexPath.row].strName
        let imgURL = URL(string:arrCountry[indexPath.row].strImageUrl!)
        cellCountry.imgCountry.sd_setImage(with: imgURL)
        if arrCountry[indexPath.row].isSelected == true{
            cellCountry.backgroundColor = UIColor.init(red: 255.0/255.0, green: 155.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            cellCountry.lblCountry.textColor = UIColor.white
        }
        else{
            cellCountry.backgroundColor = UIColor.white
            cellCountry.lblCountry.textColor = UIColor.black

        }
        return cellCountry
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idBaseUrl = indexPath.row
        btnNext.alpha = 1.0
        btnNext.isEnabled = true
        for index in 0..<arrCountry.count{
            if indexPath.row == index{
                arrCountry[index].isSelected = true
            }
            else{
                arrCountry[index].isSelected = false
            }
        }
    }*/

    //MARK:- button action methods
    
    @IBAction func btnEnglishLanguagePressed(_ sender: UIButton) {
        
        languageCode = "en"
        userDefaults.saveLanguageCode(langCode: languageCode)
        langCode = languageCode
   
        self.changeLanguageOfUI()
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.engImgView.image = #imageLiteral(resourceName: "Selected")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "unCheck")
        
    }
    
    @IBAction func btnChineseLanguagePressed(_ sender: UIButton) {
        
        languageCode = "zh-Hans"
        userDefaults.saveLanguageCode(langCode: languageCode)
        langCode = languageCode
        
        self.changeLanguageOfUI()
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.engImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "Selected")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "unCheck")
    
    }
    
    @IBAction func btnHindiLanguagePressed(_ sender: UIButton) {
        
        languageCode = "hi"
        userDefaults.saveLanguageCode(langCode: languageCode)
        langCode = languageCode
        
        self.changeLanguageOfUI()
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.engImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "Selected")
    
    }
    
    @IBAction func btnGPlusPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
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
                Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
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
    
    //MARK:- uitextfield delegate methpds
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
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
        if reachability?.connection.description != "No Connection"{
            
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
                            CustomUserDefault.setCurrency(data: "TWD")
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
                        
                        
                        //sameer 23/4/2020
                        let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                        userDefaults.set(straseUrl, forKey: "baseURL") //sm
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
                        userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
                        CustomUserDefault.removeCurrency()
                        CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
                        
                        
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
                            
                            
                            DispatchQueue.main.async {
                                let vc = SocialMobileRegisterVC()
                                let nav = UINavigationController(rootViewController: vc)
                                nav.navigationBar.isHidden = true
                                
                                vc.strSocialType = strFbOrGp
                                vc.strGetSocialId = socialId
                                
                                nav.modalPresentationStyle = .overCurrentContext
                                nav.modalTransitionStyle = .crossDissolve
                                self.present(nav, animated: true, completion: nil)
                            }
                            
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
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    @IBAction func btnNextPressed(_ sender: UIButton) {
        
        /* Sameer 23/4/2020
        if self.arrCountry.count == self.idBaseUrl {
            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL") //sm
            
            userDefaults.set("Taiwan", forKey: "countryName")
            userDefaults.set("+886", forKey: "countryCode")
            CustomUserDefault.removeCurrency()
            CustomUserDefault.setCurrency(data: "TWD")
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
        
        // Sameer 23/4/2020
        userDefaults.set(arrCountry[idBaseUrl].strName, forKey: "countryName")
        userDefaults.set(arrCountry[idBaseUrl].strCountryCode, forKey: "countryCode")
        CustomUserDefault.removeCurrency()
        CustomUserDefault.setCurrency(data:arrCountry[idBaseUrl].strCurrencySymbole ?? "")
        
        self.txtPhoneNumer.resignFirstResponder()
        if (txtPhoneNumer.text?.isEmpty)!{
            
            Alert.showAlert(strMessage: "Please enter mobile number".localized(lang: langCode) as NSString, Onview: self)
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
    
    func fireWebServiceForMobileNumberRegister(isResend:Bool)
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
                "mobile": txtPhoneNumer.text!,
                "name":"",
                "email":"",
                "GCMId":strGCMToken,
                "password":"",
                "preVerified":"0"
            ]
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
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
                            self.navigationController?.present(vc, animated: true, completion: nil)
                        }
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
                
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                internalOTP = "1"
            }
            else{
                internalOTP = "0"
            }
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile": txtPhoneNumer.text!,
                "GCMId":strGCMToken,
                "preVerified":"0",
                "OTPLength":"4"
            ]
            
            print(parameters)
            
            self.otpApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        if responseObject?.value(forKeyPath: "status") as? String == "Success"{
                            
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
                    Alert.showAlert(strMessage: responseObject?["msg"] as! NSString, Onview: self)
                }
            })
            
        }
        else
        {
            lblMessage.isHidden = false
            lblMessage.text = "No connection found".localized(lang: langCode)
        }
        
    }
    
    func otpApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    @IBAction func onClickSelectCountry(_ sender: Any) {
        
        let btn = sender as! UIButton
        
        if(btn == btnIndia) {
            btnIndia.isSelected = true
            btnMalaysia.isSelected = false
            btnSingapore.isSelected = false
            btnPhilipines.isSelected = false
            btnTaiwan.isSelected = false
            
            lblIndia.textColor = UIColor.black
            lblMalaysia.textColor = UIColor().HexToColor(hexString:"707070")
            lblSingapore.textColor = UIColor().HexToColor(hexString:"707070")
            lblPhilipines.textColor = UIColor().HexToColor(hexString:"707070")
            lblTaiwan.textColor = UIColor().HexToColor(hexString:"707070")
            
            idBaseUrl = 0
        }
        else if(btn == btnMalaysia) {
            btnIndia.isSelected = false
            btnMalaysia.isSelected = true
            btnSingapore.isSelected = false
            btnPhilipines.isSelected = false
            btnTaiwan.isSelected = false
            
            lblIndia.textColor = UIColor().HexToColor(hexString:"707070")
            lblMalaysia.textColor = UIColor.black
            lblSingapore.textColor = UIColor().HexToColor(hexString:"707070")
            lblPhilipines.textColor = UIColor().HexToColor(hexString:"707070")
            lblTaiwan.textColor = UIColor().HexToColor(hexString:"707070")
            
            idBaseUrl = 1
        }
        else if(btn == btnSingapore) {
            btnIndia.isSelected = false
            btnMalaysia.isSelected = false
            btnSingapore.isSelected = true
            btnPhilipines.isSelected = false
            btnTaiwan.isSelected = false
            
            lblIndia.textColor =  UIColor().HexToColor(hexString:"707070")
            lblMalaysia.textColor = UIColor().HexToColor(hexString:"707070")
            lblSingapore.textColor = UIColor.black
            lblPhilipines.textColor = UIColor().HexToColor(hexString:"707070")
            lblTaiwan.textColor = UIColor().HexToColor(hexString:"707070")
            
            idBaseUrl = 2
        }
        else if(btn == btnTaiwan) {
            btnIndia.isSelected = false
            btnMalaysia.isSelected = false
            btnSingapore.isSelected = false
            btnPhilipines.isSelected = false
            btnTaiwan.isSelected = true
            
            lblIndia.textColor =  UIColor().HexToColor(hexString:"707070")
            lblMalaysia.textColor = UIColor().HexToColor(hexString:"707070")
            lblSingapore.textColor = UIColor().HexToColor(hexString:"707070")
            lblPhilipines.textColor = UIColor().HexToColor(hexString:"707070")
            lblTaiwan.textColor = UIColor.black
            
            idBaseUrl = 3
        }
        else {
            /*
            btnIndia.isSelected = false
            btnMalaysia.isSelected = false
            btnSingapore.isSelected = false
            btnPhilipines.isSelected = true
            
            lblIndia.textColor =  UIColor().HexToColor(hexString:"707070")
            lblMalaysia.textColor = UIColor().HexToColor(hexString:"707070")
            lblSingapore.textColor = UIColor().HexToColor(hexString:"707070")
            lblPhilipines.textColor = UIColor.black
            
            idBaseUrl = 4
            */
        }
        
        CustomUserDefault.setUserPinCode(data: idBaseUrl)
        
        /* Sameer 23/4/2020
        if self.arrCountry.count == self.idBaseUrl {
            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL") //sm
            
            userDefaults.set("Taiwan", forKey: "countryName")
            userDefaults.set("+886", forKey: "countryCode")
            CustomUserDefault.removeCurrency()
            CustomUserDefault.setCurrency(data: "TWD")
        }else {
            
            if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
            }else {
                
                let straseUrl = arrCountry[idBaseUrl].strEndPoint //sm
                userDefaults.set(straseUrl, forKey: "baseURL") //sm
            }
            
            userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
            userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
            CustomUserDefault.removeCurrency()
            CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
        }
        */
        
        // Sameer 23/4/2020
        userDefaults.set(self.arrCountry[self.idBaseUrl].strEndPoint, forKey: "baseURL") // 21/4/20
        userDefaults.set(self.arrCountry[self.idBaseUrl].strName, forKey: "countryName")
        userDefaults.set(self.arrCountry[self.idBaseUrl].strCountryCode, forKey: "countryCode")
        CustomUserDefault.removeCurrency()
        CustomUserDefault.setCurrency(data: self.arrCountry[self.idBaseUrl].strCurrencySymbole ?? "")
        
    }
    
    //MARK:- Navigate to welcome screen
    func pushToWelcomeScreen() {
        let appconfiq = AppConfig()
        let vc = WelcomeVC()
        appconfiq.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
    }
    
    //MARK:- get country by simcard
    
    func getCountryBySimCard(){
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.subscriberCellularProvider {
           // print("country code is: " + carrier.mobileCountryCode!);
            
            //will return the actual country code
            //print("ISO country code is: " + carrier.isoCountryCode!);

            if carrier.isoCountryCode != nil {
            if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: carrier.isoCountryCode!) {
                
                // Country name was found
                strCountry = name
                
                for index in 0..<self.arrCountry.count{
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
                            CustomUserDefault.setCurrency(data:"TWD")
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
                }
            } else {
                // Country name cannot be found
            }
        }

        }
        else{
            //no sim
            setLocation()
        }
    }
    
    //MARK:- func setLocation Framework
    func setLocation(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        // Here you can check whether you have allowed the permission or not.
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude ?? 0.0)
                let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude ?? 0.0)
                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    }else if let country = placemarks?.first?.country,
                        
                        let city = placemarks?.first?.locality {
                        self.setCountryValue(str:country)
                        self.strCountry = country
                        
                        for index in 0..<self.arrCountry.count {
                            if self.arrCountry[index].strName == country {
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
                                    CustomUserDefault.setCurrency(data:"TWD")
                                }
                                */
                                
                                self.arrCountry[index].isSelected = true
                                
                                //* Sameer 23/4/2020
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
                        }
                    }
                    else {
                    }
                })
                break
                
            case .notDetermined:
                print("Not determined.")
                break
                
            case .restricted:
                print("Restricted.")
                break
                
            case .denied:
                print("Denied.")
            }
        }
        else{
            getCountryBySimCard()
            
//                        let alertController = UIAlertController(title: title, message: "Allow InstaCash to access your location while you are using the app?", preferredStyle: .alert)
//
//                        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel){
//                            (UIAlertAction) in
//
//                        }
//                        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
//                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
//                        }
//
//                        alertController.addAction(cancelAction)
//                        alertController.addAction(settingsAction)
//                        self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:- location update delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            //if self.isChangeLocation == true{
            if (self.strCountry.isEmpty){
                for index in 0..<self.arrCountry.count{
                    if self.arrCountry[index].strName == currentLocPlacemark.country{
                        self.strCountry = currentLocPlacemark.country!
                        self.setCountryValue(str:self.strCountry)
                        self.idBaseUrl = index
                        
                        /* Sameer 23/4/2020
                        if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                        userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
                            
                        }else if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "RM" || self.arrCountry[self.idBaseUrl].strCurrencySymbole == "SG$" {
                            
                            let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                            userDefaults.set(straseUrl, forKey: "baseURL") //sm
                        }else {
                            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL")
                        }
                        */
                        
                        // Sameer 23/4/2020
                        let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                        userDefaults.set(straseUrl, forKey: "baseURL") //sm
                        
                        self.arrCountry[index].isSelected = true
                        self.isChangeLocation = false
                    }
                    else{
                        self.arrCountry[index].isSelected = false
                    }
                }
        }
            //}
            //else{
            if (self.strCountry.isEmpty){
                for index in 0..<self.arrCountry.count{
                    if self.arrCountry[index].strName == currentLocPlacemark.country{
                        self.idBaseUrl = index
                        self.arrCountry[index].isSelected = true
                        self.strCountry = currentLocPlacemark.country!
                        self.setCountryValue(str:self.strCountry)
                        
                        /* Sameer 23/4/2020
                        if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "₹" {
                        userDefaults.set("https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/", forKey: "baseURL") //sm
                            
                        }else if self.arrCountry[self.idBaseUrl].strCurrencySymbole == "RM" || self.arrCountry[self.idBaseUrl].strCurrencySymbole == "SG$" {
                            
                            let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint //sm
                            userDefaults.set(straseUrl, forKey: "baseURL") //sm
                        }else {
                            userDefaults.set("https://getinstacash.com.tw/instaCash/api/v5/public/", forKey: "baseURL")
                        }*/
                        
                        // Sameer 23/4/2020
                        let straseUrl = self.arrCountry[self.idBaseUrl].strEndPoint
                        userDefaults.set(straseUrl, forKey: "baseURL")
                        
                    }
                    else{
                        self.arrCountry[index].isSelected = false
                    }
                }
            //}
            }
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
