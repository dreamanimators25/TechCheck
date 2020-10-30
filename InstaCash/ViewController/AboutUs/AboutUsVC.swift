//
//  AboutUsVC.swift
//  TechCheck
//
//  Created by TechCheck on 28/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MessageUI


class AboutUsVC: UIViewController,MFMailComposeViewControllerDelegate,PushToHomeForDiagnosisModeDelegate {

    @IBOutlet weak var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        lblVersion.text = "Version " + version!
        
    }
    
    //MARK:- custom delegate metthods
    func PushToHome(isDiagnosisMode:String){
        let vc = HomeVC()
        vc.isDiagnosisModeCheck = isDiagnosisMode
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "About Us"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(AboutUsVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    @IBAction func btnChangeAppModePressed(_ sender: UIButton) {
        
        if CustomUserDefault.isUserIdExit(){
//            let imei = UserDefaults.standard.string(forKey: "imei_number")
//            if (imei?.count == 15){
                let vc = ChangeAppModeVC()
                vc.delegate = self
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(vc, animated: true, completion: nil)
//            }
//            else{
//                let vc = IMEIVC()
//                vc.isComingForProcessmode = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }

        }
        else{
            let  VC  = LoginVC()
            VC.iscomingFromPlaceOrder = false
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func btnRateUsPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://itunes.apple.com/in/app/instacash-sell-used-phone/id1310320724?mt=8") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func btnYouTubePressed(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://www.youtube.com/channel/UCUEYdVx2ftX2NhPjgQ5qVlA") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://www.youtube.com/channel/UCUEYdVx2ftX2NhPjgQ5qVlA") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnInstagramPressed(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://www.instagram.com/get_instacash/") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://www.instagram.com/getinstacash.my//") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnFollowOnTwitterPressed(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://twitter.com/GetInstaCash") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://twitter.com/getinstacashmy") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnFaceBookPressed(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://www.facebook.com/GetInstaCash/") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
          else {
            guard let url = URL(string: "https://www.facebook.com/Getinstacash.my/") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnWesitePressed(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://getinstacash.in/") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://getinstacash.com.my") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func btnContactUs(_ sender: UIButton) {
        var emailAddress = ""
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "£" {
            emailAddress = "support@getinstacash.in"
        }
        else{
            emailAddress = "support@getinstacash.com.my"
        }

        if !MFMailComposeViewController.canSendMail() {

            Alert.showAlertWithError(strMessage: "Mail services are not available", Onview: self)
            return
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([emailAddress])
            composeVC.setSubject("Message Subject")
            composeVC.setMessageBody("Message content.", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
