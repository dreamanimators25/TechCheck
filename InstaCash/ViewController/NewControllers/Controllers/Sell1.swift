//
//  Sell1.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 08/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class Sell1: UIViewController {
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var lblPhonePrice: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblQuote: UILabel!
    @IBOutlet weak var lblGetUpto: UILabel!
    @IBOutlet weak var lblThePrice: UILabel!
    @IBOutlet weak var lblGetting: UILabel!
    @IBOutlet weak var btnGetQuote: UIButton!
    
    
    let reachability: Reachability? = Reachability()
    var strDevie = String()
    var imgView = UIImageView()
    
    var arrMyCurrentDevice = [HomeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.didPullToRefresh()
        
        self.lblPhoneName.text = strDevie
        self.imgPhone.image = imgView.image
    }
    
    func changeLanguageOfUI() {
        
        self.lblQuote.text = "Quote".localized(lang: langCode)
        self.lblGetUpto.text = "Get Upto".localized(lang: langCode)
        self.lblThePrice.text = "The price stated above depends on the condition of the device. A final price offer will be quoted after you run the device diagnosis.".localized(lang: langCode)
        self.lblGetting.text = "Getting an exact quote takes 5 mins. Ready to roll?".localized(lang: langCode)
        
        self.btnGetQuote.setTitle("GET EXACT QUOTE".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.addShadowOn4side(baseView: self.viewBG)
        }
        
    }
    
    //MARK : Web Service
    
    @objc func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode) in
                
                Alert.HideProgressHud(Onview: self.view)
                
                self.arrMyCurrentDevice = arrMyCurrentDeviceSend
                
                if self.arrMyCurrentDevice.count > 0 {
                    
                    self.lblPhoneName.text = self.arrMyCurrentDevice[0].strCurrentDeviceName
                    
                    let imgURL = URL(string:self.arrMyCurrentDevice[0].strCurrentDeviceImage!)
                    self.imgPhone.sd_setImage(with: imgURL)
                    
                    
                    //let strAmount  = String(format: "%d", self.arrMyCurrentDevice[0].currentDeviceMaximumTotal!)
                    //self.lblPhonePrice.text = CustomUserDefault.getCurrency()  + " \(strAmount)"
                    
                    
                    let price = Int(self.arrMyCurrentDevice[0].currentDeviceMaximumTotal!)
                    self.lblPhonePrice.text = CustomUserDefault.getCurrency() + " \(price.formattedWithSeparator)"
                    
                }
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func onClickBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickGetExactQuote(_ sender: Any) {
        //let vc = StartDevice()
        let vc = StartDevice1()
        self.navigationController?.pushViewController(vc, animated: true)
        
        //Sameer 2/6/2020
        Analytics.logEvent("diagnostic", parameters: ["currency" : CustomUserDefault.getCurrency(),
                                                      "item_id" : CustomUserDefault.getProductId(),
                                                      "item_name" : self.arrMyCurrentDevice[0].strCurrentDeviceName ?? ""])
        
    }
    
    /*
    @IBAction func onClickFingerPrintScanner(_ sender: Any) {
        let vc  = FingerPrintDevice()
        vc.isComingFromTestResult = false
        vc.isComingFromProductquote = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickStartFromBeginning(_ sender: Any) {
        let vc = StartDevice()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction @objc func btnSearchPressed(_ sender:UIButton){
        let vc  = AnotherDevice()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickPromotions(_ sender: Any) {

    }
    
    @IBAction func onClickHome(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
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
        let vc = UserAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    */
    
}
