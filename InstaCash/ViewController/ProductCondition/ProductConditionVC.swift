//
//  ProductConditionVC.swift
//  InstaCash
//
//  Created by InstaCash on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class ProductConditionVC: UIViewController {

    var strProductIdGet = ""
    
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblTellUs: UILabel!
    @IBOutlet weak var btnLetsBegin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblProductCondition.text = "Product Condition".localized(lang: langCode)
        self.lblTellUs.text = "Tell us More about the product.The following screens will have a few questions regarding the product's condition select appropriate answer to the questions and instantly get the best price for your product. ".localized(lang: langCode)
       
        self.btnLetsBegin.setTitle("LET'S BEGIN".localized(lang: langCode), for: UIControlState.normal)
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Product Condition".localized(lang: langCode)
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(ProductConditionVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLetsBeginPressed(_ sender: UIButton) {
       // let vc = DeiceSwitchOnVC()
        let vc = OtherDeviceQuestionFlow()
        vc.strGetProductID = strProductIdGet
       // vc.getProductID = strProductIdGet
      //  vc.isComingFrom = "Not Diagnosis"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
