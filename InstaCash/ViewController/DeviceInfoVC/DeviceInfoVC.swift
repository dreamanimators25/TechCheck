//
//  DeviceInfoVC.swift
//  TechCheck
//
//  Created by TechCheck on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class DeviceInfoVC: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    
    @IBOutlet weak var lblMarketPrice: UILabel!
    @IBOutlet weak var lblInstacashPrice: UILabel!
    @IBOutlet weak var lblTheInsta: UILabel!
    @IBOutlet weak var lblGettingAn: UILabel!
    @IBOutlet weak var btnGetQuote: UIButton!
    
    
    var arrMyCurrentDeviceGetInfo = [HomeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBar()
        setViewDynamically()
        
        //lblPrice.text = CustomUserDefault.getCurrency()
        
        self.setStatusBarColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblMarketPrice.text = "Market Price".localized(lang: langCode)
        self.lblInstacashPrice.text = "TechCheck Price".localized(lang: langCode)
        self.lblTheInsta.text = "The price stated above depends on the condition of the device. A final price offer will be quoted after you run the device diagnosis.".localized(lang: langCode)
        self.lblGettingAn.text = "Getting an exact quote takes 5 mins. Ready to roll? Just grab your earphone and data cable for respective diagnosis.".localized(lang: langCode)
        
        self.btnGetQuote.setTitle("Get exact quote".localized(lang: langCode), for: UIControlState.normal)
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = arrMyCurrentDeviceGetInfo[0].strCurrentDeviceName
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(DeviceInfoVC.btnBackPress), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func setViewDynamically(){
        
        self.lblPhoneName.text = arrMyCurrentDeviceGetInfo[0].strCurrentDeviceName
        
        let imgURL = URL(string:arrMyCurrentDeviceGetInfo[0].strCurrentDeviceImage!)
        self.imgPhone.sd_setImage(with: imgURL)
        
        self.lblPrice.text = CustomUserDefault.getCurrency() + (self.arrMyCurrentDeviceGetInfo[0].currentDeviceMedianTotal?.formattedWithSeparator ?? "")
        
        let strMaxAmount = arrMyCurrentDeviceGetInfo[0].currentDeviceMaximumTotal!.formattedWithSeparator
        let strMinAmount = arrMyCurrentDeviceGetInfo[0].currentDeviceMedianTotal!.formattedWithSeparator
        
       // let strMaxAmount  = String(format: "%d", arrMyCurrentDeviceGetInfo[0].currentDeviceMaximumTotal!)
     //   let strMinAmount  = String(format: "%d", arrMyCurrentDeviceGetInfo[0].currentDeviceMedianTotal!)
        
        self.lblOfferPrice.text = CustomUserDefault.getCurrency() + strMinAmount + " To " +  CustomUserDefault.getCurrency() + strMaxAmount

    }
    
    //MARK:- button action methods
    
    @objc func btnBackPress() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnGetExactQuotePressed(_ sender: UIButton) {
        userDefaults.set(arrMyCurrentDeviceGetInfo[0].strCurrentDeviceImage, forKey: "otherProductDeviceImage")
  
        userDefaults.set(arrMyCurrentDeviceGetInfo[0].strCurrentDeviceName, forKey: "productName")
        let vc = ScreenTestingVC()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
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
