//
//  SideMenuVC.swift
//  TechCheck
//
//  Created by TechCheck on 12/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MFSideMenu

class SideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblViewSideMenu: UITableView!
    
    var arrLogoImage: [UIImage] = [
        UIImage(named: "myOrders")!,UIImage(named: "home")!,UIImage(named: "myAccount")!,UIImage(named: "myOrders")!,UIImage(named: "History")!,UIImage(named: "works")!,UIImage(named: "aboutUs")!,UIImage(named: "termsCondition")!,UIImage(named: "faq")!,UIImage(named: "contactUs")!,UIImage(named: "share")!,
        ]
    
    var arrTitle:[String] = ["","Home","MyAccount","MyOrders","History","How It Works","About Us","Terms & Conditions","FAQ","Contact Us","Share"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        viewSetDynamic()
        
        self.setStatusBarColor()
    }
    
    //MARK: set nav bar
    func setNavBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK:- set view dynamicaly
    func viewSetDynamic(){
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "£" {
            
             arrLogoImage = [
                UIImage(named: "myOrders")!,UIImage(named: "home")!,UIImage(named: "myAccount")!,UIImage(named: "myOrders")!,UIImage(named: "History")!,UIImage(named: "promoters")!,UIImage(named: "works")!,UIImage(named: "aboutUs")!,UIImage(named: "termsCondition")!,UIImage(named: "faq")!,UIImage(named: "contactUs")!,UIImage(named: "share")!,
                ]
            
             arrTitle = ["","Home","MyAccount","MyOrders","History","Promoters","How It Works","About Us","Terms & Conditions","FAQ","Contact Us","Share"]
        }
        else{
          arrLogoImage  = [
            UIImage(named: "myOrders")!,UIImage(named: "home")!,UIImage(named: "myAccount")!,UIImage(named: "myOrders")!,UIImage(named: "History")!,UIImage(named: "works")!,UIImage(named: "aboutUs")!,UIImage(named: "termsCondition")!,UIImage(named: "faq")!,UIImage(named: "contactUs")!,UIImage(named: "share")!,
            ]
           arrTitle =  ["","Home","MyAccount","MyOrders","History","How It Works","About Us","Terms & Conditions","FAQ","Contact Us","Share"]
        }
        
        //Register tableview cell
        tblViewSideMenu.register(UINib(nibName: "SideMenuHeaderCell", bundle: nil), forCellReuseIdentifier: "sideMenuHeaderCell")
        tblViewSideMenu.register(UINib(nibName: "SideMenuListingCell", bundle: nil), forCellReuseIdentifier: "sideMenuListingCell")
        
    }
    
    //MARK:- login pressed method
    @objc func btnLoginPressed(sender:UIButton){
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = LoginVC()
        VC.iscomingFromPlaceOrder = false
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    
    //MARK:- Tableview delegate/Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100.0
        }
        else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "sideMenuHeaderCell", for: indexPath) as! SideMenuHeaderCell
            headerCell.btnSignIn.tag = indexPath.row
            headerCell.btnSignIn.removeTarget(self, action: #selector(self.btnLoginPressed), for: .touchDragInside)
            headerCell.btnSignIn.addTarget(self, action: #selector(self.btnLoginPressed), for: .touchUpInside)
            if CustomUserDefault.isUserIdExit(){
                headerCell.imgUser.isHidden = false
                headerCell.lblTitle.text = "SEARCH"
                headerCell.lblSubTitle.isHidden = false
                headerCell.lblSubTitle.text = CustomUserDefault.getCityName()
                headerCell.btnSignIn.isHidden = true
                headerCell.lblName.isHidden = false
                headerCell.lblName.text = CustomUserDefault.getUserName()
                
                if CustomUserDefault.getUserProfileImage()?.isEmpty ?? false {
                    headerCell.imgUser.image = UIImage(named: "userPlaceHolder")
                }
                else{
                    let imgURL = URL(string:CustomUserDefault.getUserProfileImage() ?? "")
                    headerCell.imgUser.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "userPlaceHolder"))
                }
                
            }
            else{
                headerCell.imgUser.isHidden = true
                headerCell.lblTitle.text = "SignIn"
                headerCell.lblSubTitle.isHidden = true
                headerCell.btnSignIn.isHidden = false
                headerCell.lblName.isHidden = true
            }
            return headerCell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuListingCell", for: indexPath) as! SideMenuListingCell
            cell.lblName.text = arrTitle[indexPath.row]
            cell.imgLogo.image = arrLogoImage[indexPath.row]
            if indexPath.row == 5{
                cell.lblLine.isHidden = false
                cell.lblComunication.isHidden = false
            }
            else{
                cell.lblLine.isHidden = true
                cell.lblComunication.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "£" {
            
            if indexPath.row == 0{
                DispatchQueue.main.async {
                    if CustomUserDefault.isUserIdExit(){
                        let  VC  = CityVC()
                        VC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        self.present(VC, animated: true)
                    }
                }
            }
            if indexPath.row == 1{
                goToHomeController()
            }
            if indexPath.row == 2{
                goToMyAccountController()
            }
            if indexPath.row == 3{
                goToMyOrderController()
            }
            if indexPath.row == 4{
                goToMyHistoryController()
            }
            if indexPath.row == 5{
                goToPromoterssController()
            }
            if indexPath.row == 6{
                goToMyHowToWorkController()

            }
            if indexPath.row == 7{
                goToAboutUsController()

            }
            if indexPath.row == 8{
                goToMyTermsConditionController()

            }
            if indexPath.row == 9{
                goToFAQController()

            }
            if indexPath.row == 10{
                goToContactUsController()

            }
            if indexPath.row == 11{
                shareContent()

            }
        }
        else{
        
        if indexPath.row == 0{
            DispatchQueue.main.async {
                if CustomUserDefault.isUserIdExit(){
                    let  VC  = CityVC()
                    VC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.present(VC, animated: true)
                }
            }
        }
        if indexPath.row == 1{
            goToHomeController()
        }
        if indexPath.row == 2{
            goToMyAccountController()
        }
        if indexPath.row == 3{
            goToMyOrderController()
        }
        if indexPath.row == 4{
            goToMyHistoryController()
        }
        if indexPath.row == 5{
            goToMyHowToWorkController()
        }
        if indexPath.row == 6{
            goToAboutUsController()
        }
        if indexPath.row == 7{
            goToMyTermsConditionController()
        }
        if indexPath.row == 8{
            goToFAQController()
        }
        if indexPath.row == 9{
            goToContactUsController()
        }
        if indexPath.row == 10{
            shareContent()
        }
        }
        
    }
    
    func shareContent(){
        let vc = UIActivityViewController(activityItems: ["https://itunes.apple.com/in/app/instacash-sell-used-phone/id1310320724?mt=8"], applicationActivities: [])
        present(vc, animated: true)
    }
    func goToContactUsController()
    {
        DispatchQueue.main.async {
            let  VC  = ContactUsVC()
            VC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(VC, animated: true)
        }
        
    }
    
    func goToAboutUsController()
    {
        
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = AboutUsVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
        
    }
    
    func goToPromoterssController()
    {
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = PramotterVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
        
    }
    
    func goToHomeController()
    {
        
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = HomeVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
        
    }
    
    func goToMyAccountController()
    {
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = MyAccountVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    
    func goToMyOrderController()
    {
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = MyOrderVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
        
    }
    
    func goToMyHistoryController()
    {
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = HistoryVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    
    func goToMyHowToWorkController()
    {
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        let  VC  = HowItWorkVC()
        let  controllers = [VC]
        navigationControllers.viewControllers = controllers
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    
    func goToMyTermsConditionController()
    {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://getinstacash.in/terms-conditions.php") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://getinstacash.com.my/terms-conditions.php") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    func goToFAQController()
    {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            guard let url = URL(string: "https://getinstacash.in/faq.php") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else{
            guard let url = URL(string: "https://getinstacash.com.my/privacy.php") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
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
