//
//  UserAccountVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 05/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import SDWebImage

var changeLanguage : (() -> (Void))?

class UserAccountVC: UIViewController {
    
    @IBOutlet weak var accountLbl: UILabel!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userPhoneLbl: UILabel!
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var promoterView: UIView!
    @IBOutlet weak var partnerView: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var diagnoseView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var historyLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var diagnoseModeLbl: UILabel!
    @IBOutlet weak var pickupModeLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = CustomUserDefault.getUserName() {
            self.userNameLbl.text = name
        }
        
        if let email = CustomUserDefault.getUserEmail() {
            self.userEmailLbl.text = email
        }
        
        if let number = CustomUserDefault.getPhoneNumber() {
            self.userPhoneLbl.text = number
        }
        
        if let imgUrl = URL(string: CustomUserDefault.getUserProfileImage() ?? "") {            
            self.userImgView?.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "userPlaceHolder"))
        }
        
        //To set shadow on multiple views
        DispatchQueue.main.async {
            UIView.addShadowOn4side(baseView: self.historyView)
            UIView.addShadowOn4side(baseView: self.aboutView)
            UIView.addShadowOn4side(baseView: self.shareView)
            UIView.addShadowOn4side(baseView: self.languageView)
            UIView.addShadowOn4side(baseView: self.promoterView)
            UIView.addShadowOn4side(baseView: self.partnerView)
            UIView.addShadowOn4side(baseView: self.pickUpView)
            UIView.addShadowOn4side(baseView: self.diagnoseView)
            UIView.addShadowOn4side(baseView: self.logoutView)
        }
        
        changeLanguage = {
            self.changeLanguageOfUI()
        }
        
        self.changeLanguageOfUI()
    }
    
    //MARK: Custom Methods
    func changeLanguageOfUI() {
                
        self.accountLbl.text = "Account".localized(lang: langCode)
        self.historyLbl.text = "HISTORY".localized(lang: langCode)
        self.aboutLbl.text = "ABOUT".localized(lang: langCode)
        self.shareLbl.text = "SHARE".localized(lang: langCode)
        self.languageLbl.text = "LANGUAGE".localized(lang: langCode)
        self.diagnoseModeLbl.text = "DIAGNOSE MODE".localized(lang: langCode)
        self.pickupModeLbl.text = "PICKUP MODE".localized(lang: langCode)
        self.logoutLbl.text = "LOGOUT".localized(lang: langCode)
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            self.languageView.isHidden = true
        }else {
            self.languageView.isHidden = true
        }
        
    }
    
    //MARK: IBActions
    @IBAction func btnUserImagePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnHistoryPressed(_ sender: UIButton) {
        let vc = MyHistoryListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAboutPressed(_ sender: UIButton) {
        let vc = AboutVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSharePressed(_ sender: UIButton) {
        
        if let name = URL(string: "https://itunes.apple.com/in/app/instacash-sell-used-phone/id1310320724?mt=8"), !name.absoluteString.isEmpty {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }else  {
            // show alert for not available
            self.showaAlert(message: "Service not available!".localized(lang: langCode))
        }
    }
    
    @IBAction func btnLanguagePressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            let vc = LanguagePopUpVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnPromoterLoginPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnPartnerAccessPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func btnPickUpPressed(_ sender: UIButton) {
        
        /*
        let vc = PickUpCodeVC()
        vc.isComeFromVC = "pickupmode"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        */
        
        DispatchQueue.main.async {
            let vc = PickUpCodeVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            vc.isComeFromVC = "pickupmode"
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnDiagnoseModePressed(_ sender: UIButton) {
        
        /*
        let vc = PickUpCodeVC()
        vc.isComeFromVC = "diagnosemode"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        */
        
        DispatchQueue.main.async {
            let vc = PickUpCodeVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            vc.isComeFromVC = "diagnosemode"
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnLogoutPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "LOG-OUT".localized(lang: langCode), message: "Are you sure you want to log-out?".localized(lang: langCode), preferredStyle: .alert)
        
        let sendButton = UIAlertAction(title: "YES".localized(lang: langCode), style: .default, handler: { (action) -> Void in
            self.removeCache()
            obj_app.setRootViewController()
        })
        
        let cancelButton = UIAlertAction(title: "NO".localized(lang: langCode), style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(sendButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }

    @IBAction func onClickHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickOrders(_ sender: Any) {
        let vc = MyOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = NotificationNew()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        //let vc = Profile()
        //let vc = UserAccountVC()
        //self.navigationController?.pushViewController(vc, animated: true)
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
    
    //MARK: Custom Methods
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
        
        userDefaults.removeObject(forKey: "eventSource") //Sameer 2/6/2020
        
        //Sameer - 28/3/20
        userDefaults.removeObject(forKey: "promoterID")
        userDefaults.removeObject(forKey: "promoter")
        userDefaults.removeObject(forKey: "promotionCouponCode")
        userDefaults.removeObject(forKey: "urlResponse")
        userDefaults.removeObject(forKey: "additionalInfo")
        
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

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
