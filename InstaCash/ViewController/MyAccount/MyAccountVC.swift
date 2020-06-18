//
//  MyAccountVC.swift
//  InstaCash
//
//  Created by InstaCash on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewMiddle: UIView!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var btnCreateOrder: UIButton!
    @IBOutlet weak var lblOrderDEscription: UILabel!
    @IBOutlet weak var imgVerify: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    var arrOrderListData = [OrderListModel]()
    let reachability: Reachability? = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        if reachability?.connection.description != "No Connection"{
            OrderListModel.fetchOrderListFromServer(isInterNet:true,getController: self) { (arrOrderListData) in
                if arrOrderListData.count > 0{
                    self.arrOrderListData = arrOrderListData
                    self.btnCreateOrder.setTitle("VIEW ALL ORDERS", for: .normal)
                     self.lblOrderDEscription.text = "Click on View all order to see your order listing."
                }
                else{
                    self.lblOrderDEscription.text = "No New orders to show.click on Create new order to start selling your used electronics."
                }
            }
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection found", Onview: self)
        }
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2
        imgUser.clipsToBounds = true
        viewMiddle.layer.cornerRadius = 5
        viewBottom.layer.cornerRadius = 5
        viewMiddle.layer.shadowColor = UIColor.black.cgColor
        viewMiddle.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewMiddle.layer.shadowOpacity = 0.5
        viewMiddle.layer.shadowRadius = 2.0
        
        viewBottom.layer.shadowColor = UIColor.black.cgColor
        viewBottom.layer.shadowOffset = CGSize(width: 2, height: 2)
        viewBottom.layer.shadowOpacity = 0.5
        viewBottom.layer.shadowRadius = 2.0
        
        if CustomUserDefault.isUserIdExit(){
            imgUser.isHidden = false
            lblPhoneNumber.text = CustomUserDefault.getPhoneNumber()
            lblUserName.text = CustomUserDefault.getUserName()
            lblEmail.text = CustomUserDefault.getUserEmail()

            let imgURL = URL(string:CustomUserDefault.getUserProfileImage() ?? "")
            imgUser.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "userPlaceHolder"))
            imgVerify.isHidden = false
        }
        else{
            imgVerify.isHidden = true
        }
       
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "User Profile"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(MyAccountVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
        
        if CustomUserDefault.isUserIdExit(){
            //Right menu
            let btnLogout = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
            let widthConstraint1 = btnLogout.widthAnchor.constraint(equalToConstant: 25)
            let heightConstraint1 = btnLogout.heightAnchor.constraint(equalToConstant: 25)
            heightConstraint1.isActive = true
            widthConstraint1.isActive = true
            btnLogout.setImage(UIImage(named: "more"), for: .normal)
            btnLogout.addTarget(self, action: #selector(MyAccountVC.btnLogOutPressed), for: .touchUpInside)
            let rightBarButtonCity = UIBarButtonItem(customView: btnLogout)
            navigationItem.rightBarButtonItem = rightBarButtonCity
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    @objc func btnLogOutPressed(sender:UIButton){
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
    
    @IBAction func btnCreatePreessed(_ sender: UIButton) {
        
        if btnCreateOrder.titleLabel?.text == "CREATE NEW ORDER"{
           // self.navigationController!.viewControllers.removeAll()
            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
            
        }
        else{
            let vc = MyOrderVC()
            vc.iscomingFromMyAccount = true
            vc.arrOrderList = self.arrOrderListData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnAllAddressPressed(_ sender: UIButton) {
        let vc = MyAddresses()
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        //Sameer - 28/3/20
        userDefaults.removeObject(forKey: "promoterID")
        userDefaults.removeObject(forKey: "promoter")
        userDefaults.removeObject(forKey: "promotionCouponCode")
        userDefaults.removeObject(forKey: "urlResponse")
        userDefaults.removeObject(forKey: "additionalInfo")
        //
        
        userDefaults.set(false, forKey: "baseURL")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
