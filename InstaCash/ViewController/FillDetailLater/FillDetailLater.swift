//
//  FillDetailLater.swift
//  TechCheck
//
//  Created by TechCheck on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FacebookCore

class FillDetailLater: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    
    /*@IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblName: UILabel!*/
    
    var strGetUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBar()
        
        self.setStatusBarColor()
        
        lblPrice.text = "Get ready to be \(CustomUserDefault.getCurrency()) richer"
        
        /*lblName.text = CustomUserDefault.getUserName()
        lblOrderId.text = strGetUserID
        
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            lblnumber.text = "0141-4232323"
            lbltime.text = "(10AM To 7PM,Monday to Saturday)"
        }
        else{
            lblnumber.text = "+60365273417"
            lbltime.text = "(9AM To 6PM,Monday to Friday)"

        }*/
        
        removeAllQuestionFlowCache()
        // Do any additional setup after loading the view.
    }
    
    func removeAllQuestionFlowCache(){
        userDefaults.set(false, forKey: "OrderPlaceFordiagnosis")
        userDefaults.removeObject(forKey: "productName")
        userDefaults.removeObject(forKey: "orderOtherIMEINumber")
        userDefaults.removeObject(forKey: "isDiagnosisForSTONValue")
        userDefaults.removeObject(forKey: "orderPromoCode")
        userDefaults.removeObject(forKey: "couponCodePrice")
        userDefaults.removeObject(forKey: "diagnosisId")
        userDefaults.removeObject(forKey: "productPriceFromAPI")
        userDefaults.removeObject(forKey: "diagnosisId")

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
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "TechCheck"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(FillDetailLater.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func btnSideMenuPressed() -> Void {
        
        obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickStatus(_ sender: Any) {
        
        let vc = OrderStatus1()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
