//
//  Sell1.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 08/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Sell1: UIViewController {
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var lblPhonePrice: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.addShadowOn4side(baseView: self.viewBG)
        }
       
    }
    
    //MARK: IBActions
    
    @IBAction func onClickBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickGetExactQuote(_ sender: Any) {
        let vc = StartDevice()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    @IBAction func onClickFingerPrintScanner(_ sender: Any) {
        let vc  = FingerPrintDevice()
        vc.isComingFromTestResult = false
        vc.isComingFromProductquote = false
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
