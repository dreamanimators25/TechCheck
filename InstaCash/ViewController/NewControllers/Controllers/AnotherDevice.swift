//
//  AnotherDevice.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 09/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FacebookCore

class AnotherDevice: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionViewDevice: UICollectionView!
    @IBOutlet weak var collectionViewCompany: UICollectionView!
    
    var arrBrandDeviceGetData = [HomeModel]()
    var arrMyOderGetData = [HomeModel]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var arrPopularDeviceGetData = [HomeModel]()
    var arrBrandModelType = [HomeModel]()
    var strAppModeCode = ""
    
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        didPullToRefresh()
        
        collectionViewDevice.register(UINib(nibName: "AnotherDeviceCell", bundle: nil), forCellWithReuseIdentifier: "anotherCell")
        
        collectionViewCompany.register(UINib(nibName: "SearchManufactureCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
        userDefaults.setValue("", forKey: "ChangeModeComingFromDiadnosis")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {        
        return 1
    }
    
    func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode)  in
                
                self.arrPopularDeviceGetData.removeAll()
                self.arrBrandModelType.removeAll()
                
                self.arrBrandDeviceGetData = arrBrandDeviceGetData
                self.arrPopularDeviceGetData = arrPopularDeviceGetData
                self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
            
                if arrPopularDeviceGetData.count > 0 {
                    UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                        self.collectionViewDevice.reloadData()
                        self.collectionViewCompany.reloadData()
                        
                        Alert.HideProgressHud(Onview: self.view)
                        
                    }, completion: nil)
                }
            }
        }
        else{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collectionViewDevice)
        {
            return arrPopularDeviceGetData.count
        }
        else
        {
            return arrBrandDeviceGetData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == collectionViewDevice)
        {
            return CGSize(width:collectionView.frame.width/3-5, height:collectionView.frame.width/3)
        }
        else
        {
            return CGSize(width:collectionView.frame.width/3-5, height:collectionView.frame.width/3-5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == collectionViewDevice)
        {
            let cell = collectionViewDevice.dequeueReusableCell(withReuseIdentifier: "anotherCell", for: indexPath as IndexPath) as! AnotherDeviceCell
            
            cell.lblName.text = arrPopularDeviceGetData[indexPath.row].strPopularName
            let imgURL = URL(string:arrPopularDeviceGetData[indexPath.row].strPopularImage!)
            cell.img.sd_setImage(with: imgURL)
            
            return cell
        }
        else
        {
            let cell = collectionViewCompany.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchManufactureCell
            
            let imgURL = URL(string:arrBrandDeviceGetData[indexPath.row].strBrandLogo!)
            cell.imgCompany.sd_setImage(with: imgURL)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == collectionViewDevice)
        {
            if  CustomUserDefault.getProductId() == arrPopularDeviceGetData[indexPath.row].strPopularId{
                // let imei = UserDefaults.standard.string(forKey: "imei_number")
                //    if (imei?.count == 15){
                Analytics.logEvent("diagnosis_tapped", parameters: [
                    "event_category":"Diagnosis Button Click",
                    "event_action":"Diagnosis Button Click Action",
                    "event_label":"Diagnosis Button Test"
                    ])
                
                // facebook analysis event
                
                var currency = ""
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                    
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    currency = "INR"
                }
                //else if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                else if CustomUserDefault.getCurrency() == "MY" {
                    currency = "MYR"
                }
                else{
                    currency = "SGD"
                }
                
                AppEventsLogger.log(
                    .addedToCart(
                        contentType: arrMyCurrentDeviceSend[0].strCurrentDeviceName,
                        contentId: CustomUserDefault.getProductId(),
                        currency: currency))
                
                let strMaxAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal ?? 0)
                
                Analytics.logEvent(AnalyticsEventViewItem, parameters: [
                    AnalyticsParameterItemID: CustomUserDefault.getProductId(),
                    AnalyticsParameterItemName: arrMyCurrentDeviceSend[0].strCurrentDeviceName!,
                    AnalyticsParameterPrice:CustomUserDefault.getCurrency() + strMaxAmount
                    ])
                
                userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
                userDefaults.setValue("", forKey: "ChangeModeComingFromDiadnosis")
                // let imei = UserDefaults.standard.string(forKey: "imei_number")
                //      if (imei?.count == 15){
                if arrMyCurrentDeviceSend.count > 0{
                    let vc  = DeviceInfoVC()
                    vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceSend
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
                    
                }
                //                    }else{
                //                        if arrMyCurrentDeviceSend.count > 0{
                ////                            let vc = IMEIVC()
                ////                            vc.arrMyCurrentDeviceGet = arrMyCurrentDeviceSend
                ////                            self.navigationController?.pushViewController(vc, animated: true)
                //                            let vc  = DeviceInfoVC()
                //                            vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceSend
                //                            self.navigationController?.pushViewController(vc, animated: true)
                //                        }
                //                        else{
                //                            Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
                //
                //                        }
                //                    }
                //                }else{
                //                    let vc  = DeviceInfoVC()
                //                    vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceSend
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                   // if arrMyCurrentDeviceSend.count > 0{
                ////                    let vc = IMEIVC()
                ////                    self.navigationController?.pushViewController(vc, animated: true)
                ////                    }
                ////                    else{
                ////                        Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
                ////                    }
                //                }
            }
            else{
                // facebook analysis event
                
                var currency = ""
                
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                    
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    currency = "INR"
                }
                //else if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                    
                else if CustomUserDefault.getCurrency() == "MY" {
                    
                    currency = "MYR"
                }
                else{
                    currency = "SGD"
                }
                
                AppEventsLogger.log(
                    .addedToCart(
                        contentType: arrPopularDeviceGetData[indexPath.row].strPopularName!,
                        contentId: arrPopularDeviceGetData[indexPath.row].strPopularId!,
                        currency: currency))
                // analysis event
                Analytics.logEvent("diagnosfromquestion_tapped", parameters: [
                    "event_category":"Diagnosis From Question Button Click",
                    "event_action":"Diagnosis From Question Button Click Action",
                    "event_label":"Diagnosis From Question Button Test"
                    ])
                let strAmount  = String(format: "%d", arrPopularDeviceGetData[indexPath.row].maximumTotal!)
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                    AnalyticsParameterItemID: arrPopularDeviceGetData[indexPath.row].strPopularId!,
                    AnalyticsParameterItemName: arrPopularDeviceGetData[indexPath.row].strPopularName!,
                    AnalyticsParameterPrice:CustomUserDefault.getCurrency()  + strAmount
                    ])
                
                
                //                        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                //                            AnalyticsParameterItemID: "diagnosfromquestion_tapped-\("diagnosfromquestion_tapped")",
                //                            AnalyticsParameterItemName: "diagnosfromquestion_tapped",
                //                            AnalyticsParameterContentType: "cont"
                //                            ])
                userDefaults.removeObject(forKey: "otherProductDeviceID")
                userDefaults.removeObject(forKey: "otherProductDeviceImage")
                userDefaults.setValue(arrPopularDeviceGetData[indexPath.row].strPopularImage, forKey: "otherProductDeviceImage")
                userDefaults.setValue(arrPopularDeviceGetData[indexPath.row].strPopularId!, forKey: "otherProductDeviceID")
                
                // if arrMyCurrentDeviceSend.count > 0{
                let vc = ProductConditionVC()
                vc.strProductIdGet = arrPopularDeviceGetData[indexPath.row].strPopularId!
                self.navigationController?.pushViewController(vc, animated: true)
                //                }
                //                else{
                //                    Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
                //
                //                }
                
            }
        }
        else
        {
            let strModelIdSend = arrBrandDeviceGetData[indexPath.row].strBrandId
            let vc = BrandModelTypeVC()
            vc.strGetBrandId = strModelIdSend!
            vc.arrBrand = arrBrandDeviceGetData
            vc.selectedIndex = indexPath.row
            vc.isComingMore = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickSearchPopularDevice(_ sender: Any) {
        let vc = SellOtherDeviceSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickSerchManufecture(_ sender: Any) {
        
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        
    }
    
    @IBAction func onclickBack(_ sender:Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onclickHome(_ sender:Any) {
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
    
    
}
