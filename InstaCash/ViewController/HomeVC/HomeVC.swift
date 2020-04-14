//
//  HomeVC.swift
//  InstaCash
//
//  Created by InstaCash on 12/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MFSideMenu
import LocalAuthentication
import Firebase
import FacebookCore
import SwiftyJSON
import SystemServices
import MessageUI

class HomeVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ShowVerificationCodeDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblPriceDropMessage: UILabel!
    @IBOutlet weak var activityConfirmOrder: UIActivityIndicatorView!
    @IBOutlet weak var viewOrderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnConfirmOrder: UIButton!
    @IBOutlet weak var lblConfirmOrderProductName: UILabel!
    @IBOutlet weak var lblConfirmOrderPrice: UILabel!
    @IBOutlet weak var imgConfirmOrder: UIImageView!
    @IBOutlet weak var viewConfirmOrder: UIView!
    @IBOutlet weak var btnDiagnosticwidthConstraints: NSLayoutConstraint!
    var isDiagnosisModeCheck = ""
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewMiddleHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBrand9: UIView!
    @IBOutlet weak var viewBrand8: UIView!
    @IBOutlet weak var viewBrand7: UIView!
    @IBOutlet weak var viewBrand6: UIView!
    @IBOutlet weak var viewBrand5: UIView!
    @IBOutlet weak var viewBrand4: UIView!
    @IBOutlet weak var viewBrand3: UIView!
    @IBOutlet weak var viewBrand2: UIView!
    @IBOutlet weak var viewBrand1: UIView!
    @IBOutlet weak var lblBrand3: UILabel!
    
    @IBOutlet weak var lblBrand9: UILabel!
    @IBOutlet weak var lblBrand8: UILabel!
    @IBOutlet weak var lblBrand7: UILabel!
    @IBOutlet weak var lblBrand6: UILabel!
    @IBOutlet weak var lblBrand5: UILabel!
    @IBOutlet weak var lblBrand4: UILabel!
    @IBOutlet weak var imgBrand9: UIImageView!
    @IBOutlet weak var imgBrand8: UIImageView!
    @IBOutlet weak var imgBrand7: UIImageView!
    @IBOutlet weak var imgBrand6: UIImageView!
    @IBOutlet weak var imgBrand5: UIImageView!
    @IBOutlet weak var imgBrand4: UIImageView!
    @IBOutlet weak var imgBrand3: UIImageView!
    @IBOutlet weak var lblBrand2: UILabel!
    @IBOutlet weak var imgBrand2: UIImageView!
    @IBOutlet weak var lblBrand1: UILabel!
    @IBOutlet weak var imgBrand1: UIImageView!
    @IBOutlet weak var btnMoreBrands: UIButton!
    @IBOutlet weak var viewMiddle: UIView!
    @IBOutlet weak var collectionViewPopular: UICollectionView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var imgWhiteArrow: UIImageView!
    @IBOutlet weak var viewTopConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var collectionViewOrders: UICollectionView!
    @IBOutlet weak var collectionViewOrderDetails: UICollectionView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var startBtnViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStartDiagnoseHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStartDiagnose: UIButton!
    
    
    // Localized
    @IBOutlet weak var lblSell: UILabel!
    @IBOutlet weak var lblFindOut: UILabel!
    @IBOutlet weak var btnGetQuoteDevice: UIButton!
    @IBOutlet weak var lblNoBargaining: UILabel!
    @IBOutlet weak var lblTakeMinute: UILabel!
    @IBOutlet weak var lblGetAQuote: UILabel!
    @IBOutlet weak var lblAccurate: UILabel!
    @IBOutlet weak var lblGetAnotherDevice: UILabel!
    @IBOutlet weak var lblOfferPromotions: UILabel!
    @IBOutlet weak var lblThisDevice: UILabel!
    @IBOutlet weak var lblTitleUpto: UILabel!
    @IBOutlet weak var btnDiagnostic: UIButton!
    @IBOutlet weak var lblTitleOrders: UILabel!
    @IBOutlet weak var btnStartFromBegning: UIButton!
    @IBOutlet weak var lblDeviceByBrand: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var scrlViewHome: UIScrollView!
    @IBOutlet weak var promotionAndOfferView: UIView!
    @IBOutlet weak var floatTableView: UITableView!
    @IBOutlet weak var floatTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnFloating: UIButton!
    @IBOutlet weak var FloatBGView: UIView!
    @IBOutlet weak var orderDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderDetailTopConstraint: NSLayoutConstraint!
    
    var arrPopularDeviceGetData = [HomeModel]()
    var arrBrandDeviceGetData = [HomeModel]()
    var arrMyOderGetData = [HomeModel]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var arrShowMyOrders = NSMutableArray()
    var priceConfirmOrderFinal = 0
    var isConfrimOrderApiSucess = false
    var arrOrderList = [OrderListModel]()
    
    var isComingFromWelcomeScreen = false
    let reachability: Reachability? = Reachability()
    var countMyOrder = 0
    var strAppModeCode = ""
    var refreshControl: UIRefreshControl!
    var touchGest = UITapGestureRecognizer()
    
    var floatingItemsArrayIN:[String] = ["  Call  ","  Mail  ","  Zopim Chat  "]
    var floatingImageArrayIN:[UIImage] = [#imageLiteral(resourceName: "callSupport"),#imageLiteral(resourceName: "mailSupport"),#imageLiteral(resourceName: "chatSupport")]
    
    var floatingItemsArrayMY:[String] = ["  WhatsApp  ","  Call  ","  Mail  "]
    var floatingImageArrayMY:[UIImage] = [#imageLiteral(resourceName: "chatSupport"),#imageLiteral(resourceName: "callSupport"),#imageLiteral(resourceName: "mailSupport")]
    
    //MARK:- show custom delegate methods
    func showVerificationCodePopUp(processFor: String) {
        var strTitle = ""
        
        if processFor == "Yes"{
            strTitle = "Diagnosis Code"
        }
        else{
            strTitle = "Pickup Code"
        }
        
        let alertController = UIAlertController(title: strTitle.localized(lang: langCode), message: "This mode can only be run if an order has been placed for this device.If you don't have a code yet please call our customer care to get a new code.".localized(lang: langCode), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Verification Code".localized(lang: langCode)
        }
        
        let saveAction = UIAlertAction(title: "OK".localized(lang: langCode), style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if !(firstTextField.text?.isEmpty)!{
                if CustomUserDefault.isUserIdExit(){
                    self.fireWebServiceForVerificationCode(strVerificationCode: firstTextField.text!, withProcessCode: processFor)
                }
                else{
                    Alert.showAlert(strMessage: "Please Login First".localized(lang: langCode) as NSString, Onview: self)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "CANCEL".localized(lang: langCode), style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection" {
            //Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode) in
                
                self.refreshControl.endRefreshing()
                //Alert.HideProgressHud(Onview: self.view)
                self.arrMyOderGetData.removeAll()
                self.arrBrandDeviceGetData.removeAll()
                self.arrPopularDeviceGetData.removeAll()
                self.arrMyCurrentDeviceSend.removeAll()
                self.arrMyOderGetData = arrMyOderGetData
                self.strAppModeCode = strAppModeCode
                self.arrBrandDeviceGetData = arrBrandDeviceGetData
                self.arrPopularDeviceGetData = arrPopularDeviceGetData
                self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                self.lblMessage.isHidden = true
                self.imgLogo.isHidden = true
                
                if arrMyCurrentDeviceSend.count > 0{
                    self.lblPhoneName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                    self.lblConfirmOrderProductName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                    let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                    self.imgPhone.sd_setImage(with: imgURL)
                    self.imgConfirmOrder.sd_setImage(with: imgURL)
                    let strAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                    self.lblPrice.text = CustomUserDefault.getCurrency()  + strAmount
                    
                }
                
                if arrMyOderGetData.count == 0{
                    self.topViewHeightConstraint.constant = 230
                    self.lblTitleOrders.isHidden = true
                    //self.mainViewHeightConstraint.constant = 700
                    //self.setViewDynamicaly()
                }
                else{
                    self.arrShowMyOrders.removeAllObjects()
                    for index in 0..<arrMyOderGetData.count{
                        let model = arrMyOderGetData[index]
                        let arrItem = model.arrMyOrderItemList
                        for obj in 0..<arrItem.count{
                            let itemDict = arrItem[obj] as! NSDictionary
                            if (itemDict.value(forKey: "status") as! String).contains("Verified")  || (itemDict.value(forKey: "status") as! String).contains("Unverified") || (itemDict.value(forKey: "status") as! String).contains("Price Lock") || (itemDict.value(forKey: "status") as! String).contains("out for pickup"){
                                if self.arrShowMyOrders.count == 0{
                                    self.countMyOrder = 0
                                }
                                else{
                                    self.countMyOrder = self.countMyOrder + 1
                                }
                                self.arrShowMyOrders.insert(itemDict, at: self.countMyOrder)

                            }
                        }
                    }
                    
                    //arrShowMyOrders
                    if self.arrShowMyOrders.count > 0{
                        self.topViewHeightConstraint.constant = 380
                        self.lblTitleOrders.isHidden = true
                        //self.mainViewHeightConstraint.constant = 850
                        self.collectionViewOrders.reloadData()
                    }
                    else{
                        self.topViewHeightConstraint.constant = 230
                        self.lblTitleOrders.isHidden = true
                        //self.mainViewHeightConstraint.constant = 700
                    }
                    //self.setViewDynamicaly()
                    
                }
                
                if arrBrandDeviceGetData.count > 0{
                    
                    for obj in 0..<arrBrandDeviceGetData.count{
                        self.setBrandData(index: obj)
                    }
                    
                    UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                        self.viewMiddle.isHidden = true
                    }, completion: nil)
                }
                else{
                    
                }
                
                if arrPopularDeviceGetData.count > 0{
                    UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                        self.viewBottom.isHidden = true
                        self.collectionViewPopular.reloadData()
                    }, completion: nil)
                    
                }
                else{
                    
                }
                
                //                    DispatchQueue.main.async {
                //                        if self.isDiagnosisModeCheck == "No" || self.isDiagnosisModeCheck == "Yes" {
                //                            let vc = ChangeModePopUpVC()
                //                            vc.strProcessForDiagnosis = self.isDiagnosisModeCheck
                //                            vc.delegate = self
                //                            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                //                            self.navigationController?.present(vc, animated: true, completion: nil)
                //                        }
                //                        else{
                //
                //                        }
                //                    }
            }
        }
        else{
            lblMessage.isHidden = false
            imgLogo.isHidden = false
        }
    }
    
    //MARK:- confirm order price genrate method
    func confirmOrderPrice(){
        let priceProduct = userDefaults.value(forKey: "Product_UpToOffer") as! String
        let price = Int(priceProduct)
        let strPrice = price?.formattedWithSeparator
        let myString = "Hurry!! Your Offer Of ".localized(lang: langCode) + CustomUserDefault.getCurrency() + strPrice! + " May Drop In Few Days".localized(lang: langCode)
        //  let attrString = NSAttributedString(string: myString)
        let attribute = NSMutableAttributedString.init(string: myString)
        let strCount = CustomUserDefault.getCurrency() + strPrice!
        
        var myRange = NSRange()
        if langCode == "en" {
            myRange = NSRange(location: 22, length: (strCount.count))
        }else {
            myRange = NSRange(location: 9, length: (strCount.count))
        }
        
        //let myRange = NSRange(location: 22, length: (strCount.count))
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: navColor , range: myRange)
        self.lblConfirmOrderPrice.attributedText = attribute
    }
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////////////////////////////////////////////////////////////////////
        
        if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
            self.btnGetQuoteDevice.setTitle("Get quote for this device".localized(lang: langCode), for: UIControlState.normal)
            
            DispatchQueue.main.async {
                self.btnStartDiagnoseHeightConstraint.constant = 0
            }
        }
        else{
            self.btnGetQuoteDevice.setTitle("RESUME TEST".localized(lang: langCode), for: UIControlState.normal)

            DispatchQueue.main.async {
                self.btnStartDiagnoseHeightConstraint.constant = 50
                self.startBtnViewHeightConstraint.constant = 0
            }
            
        }
        
        ////////////////////////////////////////////////////////////////////
        
        self.orderDetailHeightConstraint.constant = 0
        self.orderDetailTopConstraint.constant = 0
        
        floatTableView.register(UINib(nibName: "FloatingItemCell", bundle: nil), forCellReuseIdentifier: "FloatingItemCell")
        
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            promotionAndOfferView.isHidden = false
        }else {
            promotionAndOfferView.isHidden = true
        }
        
        userDefaults.removeObject(forKey: "promoter_id")
        
        //Sameer - 28/3/20
        userDefaults.removeObject(forKey: "promoterID")
        userDefaults.removeObject(forKey: "promoter")
        userDefaults.removeObject(forKey: "promotionCouponCode")
        userDefaults.removeObject(forKey: "additionalInfo")
        
        
        userDefaults.setValue(false, forKey: "isSkippedRotation")
        //self.title = "InstaCash"
        scrlViewHome.alwaysBounceVertical = true
        scrlViewHome.bounces  = true
        //refreshControl = UIRefreshControl()
        //refreshControl.addTarget(self, action: #selector(self.didPullToRefresh), for: .valueChanged)
        //self.scrlViewHome.addSubview(refreshControl)
        lblPhoneName.text = UIDevice.current.modelName
        self.lblMessage.isHidden = true
        self.imgLogo.isHidden = true
        
        if isComingFromWelcomeScreen {
            self.btnDiagnosisUISet()
            if arrMyOderGetData.count == 0{
                //            topViewHeightConstraint.constant = 230
                //            lblTitleOrders.isHidden = true
                //            mainViewHeightConstraint.constant = 700
                if userDefaults.value(forKey: "isShowUIOnHomeForOrder") == nil{
                    self.viewConfirmOrder.isHidden = true
                    self.topViewHeightConstraint.constant = 230
                    self.lblTitleOrders.isHidden = true
                    //self.mainViewHeightConstraint.constant = 700
                    self.viewOrderHeightConstraint.constant = 0
                }
                else{
                    if userDefaults.value(forKey: "isShowUIOnHomeForOrder") as! Bool == false{
                        self.viewConfirmOrder.isHidden = true
                        self.topViewHeightConstraint.constant = 230
                        self.lblTitleOrders.isHidden = true
                        //self.mainViewHeightConstraint.constant = 700
                        self.viewOrderHeightConstraint.constant = 0
                        
                    }
                    else{
                        let strPrice = userDefaults.value(forKey: "Product_UpToOffer") as! String
                        let price = Int(strPrice)
                        self.priceConfirmOrderFinal = price!
                        self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: false)
                        self.viewConfirmOrder.isHidden = true
                        self.confirmOrderPrice()
                        self.lblConfirmOrderPrice.text = ""
                        self.viewOrderHeightConstraint.constant = 200
                        self.topViewHeightConstraint.constant = 230
                        self.lblTitleOrders.isHidden = true
                        //self.mainViewHeightConstraint.constant = 900
                    }
                }
                
            }
            else{
                self.arrShowMyOrders.removeAllObjects()
                for index in 0..<arrMyOderGetData.count{
                    let model = arrMyOderGetData[index]
                    let arrItem = model.arrMyOrderItemList
                    for obj in 0..<arrItem.count{
                        let itemDict = arrItem[obj] as! NSDictionary
                        if (itemDict.value(forKey: "status") as! String).contains("Verified")  || (itemDict.value(forKey: "status") as! String).contains("Unverified") || (itemDict.value(forKey: "status") as! String).contains("out for pickup"){
                            if self.arrShowMyOrders.count == 0{
                                self.countMyOrder = 0
                            }
                            else{
                                self.countMyOrder = self.countMyOrder + 1
                            }
                            self.arrShowMyOrders.insert(itemDict, at: self.countMyOrder)
                            
                        }
                        
                    }
                }
                //arrShowMyOrders
                if self.arrShowMyOrders.count > 0{
                    self.collectionViewOrders.reloadData()
                }
                else{
                    
                }
                //            topViewHeightConstraint.constant = 380
                //            lblTitleOrders.isHidden = false
                //            mainViewHeightConstraint.constant = 1100
                if userDefaults.value(forKey: "isShowUIOnHomeForOrder") == nil{
                    self.viewConfirmOrder.isHidden = true
                    self.topViewHeightConstraint.constant = 380
                    self.lblTitleOrders.isHidden = true
                    //self.mainViewHeightConstraint.constant = 1100
                    self.viewOrderHeightConstraint.constant = 0
                }
                else{
                    if userDefaults.value(forKey: "isShowUIOnHomeForOrder") as! Bool == false{
                        self.viewConfirmOrder.isHidden = true
                        self.topViewHeightConstraint.constant = 380
                        self.lblTitleOrders.isHidden = true
                        //self.mainViewHeightConstraint.constant = 1100
                        self.viewOrderHeightConstraint.constant = 0
                        
                    }
                    else{
                        let strPrice = userDefaults.value(forKey: "Product_UpToOffer") as! String
                        let price = Int(strPrice)
                        self.priceConfirmOrderFinal = price!
                        self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: false)
                        self.viewConfirmOrder.isHidden = true
                        self.confirmOrderPrice()
                        self.topViewHeightConstraint.constant = 380
                        self.lblTitleOrders.isHidden = false
                        self.viewOrderHeightConstraint.constant = 200
                        //self.mainViewHeightConstraint.constant = 1300
                    }
                    
                }
                
            }
            
            //Manage diagnosis button UI
            
            if arrMyCurrentDeviceSend.count > 0{
                userDefaults.removeObject(forKey: "DeviceNameForPromoters")
                userDefaults.removeObject(forKey: "ImageNameForPromoters")
                
                userDefaults.set(arrMyCurrentDeviceSend[0].strCurrentDeviceName, forKey: "DeviceNameForPromoters")
                userDefaults.set(arrMyCurrentDeviceSend[0].strCurrentDeviceImage, forKey: "ImageNameForPromoters")
                self.lblPhoneName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                self.lblConfirmOrderProductName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                self.imgPhone.sd_setImage(with: imgURL)
                self.imgConfirmOrder.sd_setImage(with: imgURL)
                
                let strAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                self.lblPrice.text = CustomUserDefault.getCurrency() + strAmount
            }
            if arrBrandDeviceGetData.count > 0{
                
                for obj in 0..<arrBrandDeviceGetData.count{
                    self.setBrandData(index: obj)
                }
                
                UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                    self.viewMiddle.isHidden = true
                }, completion: nil)
            }
            else{
            }
            
            if arrPopularDeviceGetData.count > 0{
                UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                    self.viewBottom.isHidden = true
                    self.collectionViewPopular.reloadData()
                }, completion: nil)
                
            }
            else{
                
            }
            
            DispatchQueue.main.async {
                if self.isDiagnosisModeCheck == "No" || self.isDiagnosisModeCheck == "Yes" {
                    let vc = ChangeModePopUpVC()
                    vc.strProcessForDiagnosis = self.isDiagnosisModeCheck
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
                else{
                    
                }
            }
        }
        else{
            //get home data
            if reachability?.connection.description != "No Connection" {
                Alert.ShowProgressHud(Onview: self.view)
                HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode) in
                    
                    Alert.HideProgressHud(Onview: self.view)
                    
                    self.arrMyOderGetData = arrMyOderGetData
                    self.strAppModeCode = strAppModeCode
                    self.arrBrandDeviceGetData = arrBrandDeviceGetData
                    self.arrPopularDeviceGetData = arrPopularDeviceGetData
                    self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                    self.lblMessage.isHidden = true
                    self.imgLogo.isHidden = true
                    
                    // Sameer 14/4/2020
                    // manage Diagnosis Button UI
                    //self.btnDiagnosisUISet()
                    
                    if arrMyCurrentDeviceSend.count > 0 {
                        
                        self.lblPhoneName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                        self.lblConfirmOrderProductName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                        
                        
                        userDefaults.removeObject(forKey: "DeviceNameForPromoters")
                        userDefaults.removeObject(forKey: "ImageNameForPromoters")
                        userDefaults.set(arrMyCurrentDeviceSend[0].strCurrentDeviceName, forKey: "DeviceNameForPromoters")
                        userDefaults.set(arrMyCurrentDeviceSend[0].strCurrentDeviceImage, forKey: "ImageNameForPromoters")
                        
                        let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                        self.imgPhone.sd_setImage(with: imgURL)
                        self.imgConfirmOrder.sd_setImage(with: imgURL)
                        
                        let strAmount = arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!.formattedWithSeparator
                        // let strAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                        
                        self.lblPrice.text = CustomUserDefault.getCurrency()  + strAmount
                    }
                    
                    if arrMyOderGetData.count == 0 {
                        if userDefaults.value(forKey: "isShowUIOnHomeForOrder") == nil{
                            self.viewConfirmOrder.isHidden = true
                            self.topViewHeightConstraint.constant = 230
                            self.lblTitleOrders.isHidden = true
                            //self.mainViewHeightConstraint.constant = 700
                            self.viewOrderHeightConstraint.constant = 0
                        }
                        else{
                            if userDefaults.value(forKey: "isShowUIOnHomeForOrder") as! Bool == false {
                                self.viewConfirmOrder.isHidden = true
                                self.topViewHeightConstraint.constant = 230
                                self.lblTitleOrders.isHidden = true
                                //self.mainViewHeightConstraint.constant = 700
                                self.viewOrderHeightConstraint.constant = 0
                                
                            }
                            else{
                                let strPrice = userDefaults.value(forKey: "Product_UpToOffer") as! String
                                let price = Int(strPrice)
                                self.priceConfirmOrderFinal = price!
                                self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: false)
                                self.viewConfirmOrder.isHidden = true
                                self.confirmOrderPrice()
                                self.viewOrderHeightConstraint.constant = 200
                                self.topViewHeightConstraint.constant = 230
                                self.lblTitleOrders.isHidden = true
                                //self.mainViewHeightConstraint.constant = 900
                            }
                            
                        }
                        
                        //self.setViewDynamicaly()
                    }
                    else{
                        self.arrShowMyOrders.removeAllObjects()
                        for index in 0..<arrMyOderGetData.count{
                            let model = arrMyOderGetData[index]
                            let arrItem = model.arrMyOrderItemList
                            for obj in 0..<arrItem.count{
                                let itemDict = arrItem[obj] as! NSDictionary
                                if (itemDict.value(forKey: "status") as! String).contains("Verified")  || (itemDict.value(forKey: "status") as! String).contains("Unverified") || (itemDict.value(forKey: "status") as! String).contains("Price Lock") || (itemDict.value(forKey: "status") as! String).contains("out for pickup"){
                                    if self.arrShowMyOrders.count == 0{
                                        self.countMyOrder = 0
                                    }
                                    else{
                                        self.countMyOrder = self.countMyOrder + 1
                                    }
                                    self.arrShowMyOrders.insert(itemDict, at: self.countMyOrder)
                                    
                                }
                                
                            }
                        }//arrShowMyOrders
                        
                        if self.arrShowMyOrders.count > 0 {
                            //                            self.topViewHeightConstraint.constant = 380
                            //                            self.lblTitleOrders.isHidden = false
                            //                            //self.mainViewHeightConstraint.constant = 850
                            
                            if userDefaults.value(forKey: "isShowUIOnHomeForOrder") == nil{
                                self.viewConfirmOrder.isHidden = true
                                self.topViewHeightConstraint.constant = 380
                                self.lblTitleOrders.isHidden = false
                                //self.mainViewHeightConstraint.constant = 850
                                self.viewOrderHeightConstraint.constant = 0
                            }
                            else{
                                if userDefaults.value(forKey: "isShowUIOnHomeForOrder") as! Bool == false{
                                    self.viewConfirmOrder.isHidden = true
                                    self.topViewHeightConstraint.constant = 380
                                    self.lblTitleOrders.isHidden = false
                                    //self.mainViewHeightConstraint.constant = 850
                                    self.viewOrderHeightConstraint.constant = 0
                                    
                                }
                                else{
                                    let strPrice = userDefaults.value(forKey: "Product_UpToOffer") as! String
                                    let price = Int(strPrice)
                                    self.priceConfirmOrderFinal = price!
                                    self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: false)
                                    self.viewConfirmOrder.isHidden = true
                                    self.confirmOrderPrice()
                                    self.topViewHeightConstraint.constant = 380
                                    self.lblTitleOrders.isHidden = false
                                    self.viewOrderHeightConstraint.constant = 200
                                    //self.mainViewHeightConstraint.constant = 1050
                                }
                                
                            }
                            
                            self.collectionViewOrders.reloadData()
                            
                        }
                        else{
                            
                            if userDefaults.value(forKey: "isShowUIOnHomeForOrder") == nil{
                                self.viewConfirmOrder.isHidden = true
                                self.topViewHeightConstraint.constant = 230
                                self.lblTitleOrders.isHidden = true
                                //self.mainViewHeightConstraint.constant = 700
                                self.viewOrderHeightConstraint.constant = 0
                            }
                            else{
                                if userDefaults.value(forKey: "isShowUIOnHomeForOrder") as! Bool == false{
                                    self.viewConfirmOrder.isHidden = true
                                    self.topViewHeightConstraint.constant = 230
                                    self.lblTitleOrders.isHidden = true
                                    //self.mainViewHeightConstraint.constant = 700
                                    self.viewOrderHeightConstraint.constant = 0
                                    
                                }
                                else{
                                    let strPrice = userDefaults.value(forKey: "Product_UpToOffer") as! String
                                    let price = Int(strPrice)
                                    self.priceConfirmOrderFinal = price!
                                    self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: false)
                                    self.viewConfirmOrder.isHidden = false
                                    self.confirmOrderPrice()
                                    self.viewOrderHeightConstraint.constant = 200
                                    self.topViewHeightConstraint.constant = 230
                                    self.lblTitleOrders.isHidden = true
                                    //self.mainViewHeightConstraint.constant = 900
                                }
                                
                            }
                            
                        }
                        
                        //self.setViewDynamicaly()
                        
                    }
                    
                    if arrBrandDeviceGetData.count > 0{
                        
                        for obj in 0..<arrBrandDeviceGetData.count{
                            self.setBrandData(index: obj)
                        }
                        
                        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                            self.viewMiddle.isHidden = true
                        }, completion: nil)
                    }
                    else{
                        
                    }
                    
                    if arrPopularDeviceGetData.count > 0{
                        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
                            self.viewBottom.isHidden = true
                            self.collectionViewPopular.reloadData()
                        }, completion: nil)
                        
                    }
                    else{
                        
                    }
                    //                    DispatchQueue.main.async {
                    //                        if self.isDiagnosisModeCheck == "No" || self.isDiagnosisModeCheck == "Yes" {
                    //                            let vc = ChangeModePopUpVC()
                    //                            vc.strProcessForDiagnosis = self.isDiagnosisModeCheck
                    //                            vc.delegate = self
                    //                            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    //                            self.navigationController?.present(vc, animated: true, completion: nil)
                    //                        }
                    //                        else{
                    //
                    //                        }
                    //                    }
                    
                    // Sameer 13/4/20
                    if self.reachability?.connection.description != "No Connection" {
                        OrderListModel.fetchOrderListFromServer(isInterNet:true,getController: self) { (arrOrderList) in
                            
                            if arrOrderList.count > 0 {
                                self.arrOrderList = arrOrderList
                                
                                DispatchQueue.main.async {
                                    self.orderDetailHeightConstraint.constant = 160
                                    self.orderDetailTopConstraint.constant = 20
                                    self.collectionViewOrderDetails.reloadData()
                                }
                                
                            }
                            else{
                                self.orderDetailHeightConstraint.constant = 0
                                self.orderDetailTopConstraint.constant = 0
                            }
                        }
                    }
                    else{
                        Alert.showAlert(strMessage: "No Connection found".localized(lang: langCode) as NSString, Onview: self)
                    }
                    
                }
            }
            else{
                lblMessage.isHidden = false
                imgLogo.isHidden = false
            }
        }
        
        //setNavigationBar()
        collectionViewOrderDetails.register(UINib(nibName: "MyOrdersCell", bundle: nil), forCellWithReuseIdentifier: "MyOrdersCell")
        
        collectionViewOrders.register(UINib(nibName: "YoursOrderCell", bundle: nil), forCellWithReuseIdentifier: "yoursOrderCell")
        collectionViewPopular.register(UINib(nibName: "TrandingDeviceCell", bundle: nil), forCellWithReuseIdentifier: "trandingDeviceCell")
        
        viewConfirmOrder.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewConfirmOrder.clipsToBounds = true
        viewMiddle.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewMiddle.clipsToBounds = true
        viewBottom.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewBottom.clipsToBounds = true
        viewBrand1.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand1.clipsToBounds = true
        viewBrand2.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand2.clipsToBounds = true
        viewBrand3.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand3.clipsToBounds = true
        viewBrand4.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand4.clipsToBounds = true
        viewBrand5.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand5.clipsToBounds = true
        viewBrand6.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand6.clipsToBounds = true
        viewBrand7.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand7.clipsToBounds = true
        viewBrand8.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand8.clipsToBounds = true
        viewBrand9.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBrand9.clipsToBounds = true
        btnMoreBrands.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnMoreBrands.clipsToBounds = true
        
        //setViewDynamicaly()
    }
    
    @IBAction func btnStartFromBeginningClicked(_ sender: UIButton) {
        let vc = Sell1()
        vc.strDevie = self.lblPhoneName.text!
        vc.imgView = self.imgPhone
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendToLastVCToCompletediagnosisProcess() {
        var sendJson = JSON()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
                
            }else {
                sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
            }
            
            if userDefaults.value(forKey: "rotation_complete") as! Bool == false{
                let vc = RotationVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "proximity_complete") as! Bool == false{
                let vc = SensorReadVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "volumebutton_complete") as! Bool == false{
                let vc = VolumeCheckerVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
            }
            else if userDefaults.value(forKey: "earphone_complete") as! Bool == false{
                let vc = EarPhoneVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
            
            }else if userDefaults.value(forKey: "charger_complete") as! Bool == false{
                let  vc = DeviceChargerVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
            
            }else if userDefaults.value(forKey: "camera_complete") as! Bool == false{
                let  vc = CameraVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "fingerprint_complete") as! Bool == false{
                let  vc = FingerPrintDevice()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
            
            }else if userDefaults.value(forKey: "bluetooth_complete") as! Bool == false{
                let vc = BlueToothTestingVC()
                vc.resultJSON = sendJson
                vc.iscomingFromHome = true
                self.present(vc, animated: true, completion:nil)
            }
            
        }else{
            if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
                
            }else {
                sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
            }
            
            if userDefaults.value(forKey: "rotation_complete") as! Bool == false{
                let vc = RotationVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "proximity_complete") as! Bool == false{
                let vc = SensorReadVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "volumebutton_complete") as! Bool == false{
                let vc = VolumeCheckerVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "camera_complete") as! Bool == false{
                let vc = CameraVC()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "fingerprint_complete") as! Bool == false{
                let vc = FingerPrintDevice()
                vc.resultJSON = sendJson
                self.present(vc, animated: true, completion:nil)
                
            }else if userDefaults.value(forKey: "bluetooth_complete") as! Bool == false{
                let vc = BlueToothTestingVC()
                vc.resultJSON = sendJson
                vc.iscomingFromHome = true
                self.present(vc, animated: true, completion:nil)
            }
            
        }
    }
    
    //    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
    //        var screenshotImage :UIImage?
    //        let layer = UIApplication.shared.keyWindow!.layer
    //        let scale = UIScreen.main.scale
    //        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
    //        guard let context = UIGraphicsGetCurrentContext() else {return nil}
    //        layer.render(in:context)
    //        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        if let image = screenshotImage, shouldSave {
    //            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    //        }
    //        return screenshotImage
    //    }
    
    func btnDiagnosisUISet(){
        
        //s.
        //if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if userDefaults.value(forKey: "screen_complete") == nil || self.strAppModeCode == "1" || self.strAppModeCode == "2" {
                btnDiagnostic.setTitle("Run Diagnostics".localized(lang: langCode), for: .normal)
                btnDiagnostic.setImage(UIImage(named: "dignostic"), for: .normal)
                btnStartFromBegning.isHidden = true
                btnDiagnosticwidthConstraints.constant = 180
                userDefaults.removeObject(forKey: "Diagnosis_DataSave")
            }
            else{
                var btntitle = ""
                var btnImage = ""
                btnDiagnosticwidthConstraints.constant = 230
                btnStartFromBegning.isHidden = true
                if userDefaults.value(forKey: "rotation_complete") as! Bool == false{
                    btntitle = "Continue Rotation Test".localized(lang: langCode)
                    btnImage = "rotateTest"
                }
                else if userDefaults.value(forKey: "proximity_complete") as! Bool == false{
                    btntitle = "Continue Proximity Test".localized(lang: langCode)
                    btnImage = "proximtyTest"
                }
                else if userDefaults.value(forKey: "volumebutton_complete") as! Bool == false{
                    btntitle = "Continue Volume Test".localized(lang: langCode)
                    btnImage = "hardWareButtonTest"
                }
                else if userDefaults.value(forKey: "earphone_complete") as! Bool == false{
                    btntitle = "Continue Earphone Test".localized(lang: langCode)
                    btnImage = "earPhoneCable"
                }
                else if userDefaults.value(forKey: "charger_complete") as! Bool == false{
                    btntitle = "Continue charger Test".localized(lang: langCode)
                    btnImage = "chargerCable"
                }
                else if userDefaults.value(forKey: "camera_complete") as! Bool == false{
                    btntitle = "Continue Camera Test".localized(lang: langCode)
                    btnImage = "cameraSkippedTest"
                }
                else if userDefaults.value(forKey: "fingerprint_complete") as! Bool == false{
                    btntitle = "Continue Fingerprint Test".localized(lang: langCode)
                    btnImage = "fingerPrintTest"
                }
                else if userDefaults.value(forKey: "bluetooth_complete") as! Bool == false{
                    btntitle = "Continue Bluetooth Test".localized(lang: langCode)
                    btnImage = "conectivity"
                }else{
                    btntitle = "Run Diagnostics".localized(lang: langCode)
                    btnImage = "dignostic"
                    
                    btnStartFromBegning.isHidden = true
                    btnDiagnosticwidthConstraints.constant = 180
                }
                btnDiagnostic.setTitle(btntitle, for: .normal)
                btnDiagnostic.setImage(UIImage(named: btnImage), for: .normal)
            }
        }
        else{
            //            btnDiagnostic.setTitle("Run Diagnostics", for: .normal)
            //            btnDiagnostic.setImage(UIImage(named: "dignostic"), for: .normal)
            if userDefaults.value(forKey: "screen_complete") == nil || self.strAppModeCode == "1" || self.strAppModeCode == "2" {
                btnDiagnostic.setTitle("Start Trade-in".localized(lang: langCode), for: .normal)
                btnDiagnostic.setImage(UIImage(named: "dignostic"), for: .normal)
                btnStartFromBegning.isHidden = true
                btnDiagnosticwidthConstraints.constant = 180
            }
            else{
                var btntitle = ""
                var btnImage = ""
                btnDiagnosticwidthConstraints.constant = 230
                btnStartFromBegning.isHidden = true
                if (userDefaults.value(forKey: "rotation_complete") as? Bool != nil) == false {
                    btntitle = "Continue Rotation Test".localized(lang: langCode)
                    btnImage = "rotateTest"
                }
                else if (userDefaults.value(forKey: "proximity_complete") as? Bool != nil) == false{
                    btntitle = "Continue Proximity Test".localized(lang: langCode)
                    btnImage = "proximtyTest"
                }
                else if (userDefaults.value(forKey: "volumebutton_complete") as? Bool != nil) == false{
                    btntitle = "Continue Volume Test".localized(lang: langCode)
                    btnImage = "hardWareButtonTest"
                }
                else if (userDefaults.value(forKey: "camera_complete") as? Bool != nil) == false {
                    btntitle = "Continue Camera Test".localized(lang: langCode)
                    btnImage = "cameraSkippedTest"
                }
                else if (userDefaults.value(forKey: "fingerprint_complete") as? Bool != nil) == false {
                    btntitle = "Continue Fingerprint Test".localized(lang: langCode)
                    btnImage = "fingerPrintTest"
                }
                else if (userDefaults.value(forKey: "bluetooth_complete") as? Bool != nil) == false{
                    btntitle = "Continue Bluetooth Test".localized(lang: langCode)
                    btnImage = "conectivity"
                }else{
                    btntitle = "Start Trade-in".localized(lang: langCode)
                    btnImage = "dignostic"
                    btnStartFromBegning.isHidden = true
                    btnDiagnosticwidthConstraints.constant = 180
                    
                }
                btnDiagnostic.setTitle(btntitle, for: .normal)
                btnDiagnostic.setImage(UIImage(named: btnImage), for: .normal)
            }
            
        }
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        btnFloating.isSelected = !btnFloating.isSelected
        
        self.floatTableView.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.floatTableViewHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            self.floatTableView.alpha = 0
            self.FloatBGView.isHidden = true
        })
        
    }
    
    func changeLanguageOfUI() {
        
        if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
            self.btnGetQuoteDevice.setTitle("Get quote for this device".localized(lang: langCode), for: UIControlState.normal)
        }
        else{
            self.btnGetQuoteDevice.setTitle("RESUME TEST".localized(lang: langCode), for: UIControlState.normal)
        }
        
        self.btnStartDiagnose.setTitle("Start from the beginning".localized(lang: langCode), for: UIControlState.normal)
        self.lblSell.text = "Sell".localized(lang: langCode)
        self.lblFindOut.text = "Find out how much cash you’ll get by selling this device.".localized(lang: langCode)
        self.lblNoBargaining.text = "No bargaining. No headaches!".localized(lang: langCode)
        self.lblTakeMinute.text = "Takes 5 mins. Save time.".localized(lang: langCode)
        self.lblGetAQuote.text = "Get a quote from anywhere. Convenient and casual.".localized(lang: langCode)
        self.lblAccurate.text = "Accurate and market-leading prices. Scam-free.".localized(lang: langCode)
        self.lblGetAnotherDevice.text = "Got another device to sell? See how much its worth.".localized(lang: langCode)
        self.lblOfferPromotions.text = "See Promotions and Offers".localized(lang: langCode)
        self.lblThisDevice.text = "THIS DEVICE".localized(lang: langCode)
        self.lblTitleUpto.text = "get upto".localized(lang: langCode)
        self.lblTitleOrders.text = "YOUR ORDERS".localized(lang: langCode)
        self.lblDeviceByBrand.text = "DEVICE BY BRAND".localized(lang: langCode)
        self.lblMessage.text = "No Connection found".localized(lang: langCode)
        
        self.btnDiagnostic.setTitle("Run Diagnostics".localized(lang: langCode), for: UIControlState.normal)
        self.btnStartFromBegning.setTitle("Start from the beginning".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.changeLanguageOfUI()
        
        touchGest = UITapGestureRecognizer(target: self, action: #selector(HomeVC.myviewTapped(_:)))
        touchGest.numberOfTapsRequired = 1
        touchGest.numberOfTouchesRequired = 1
        FloatBGView.addGestureRecognizer(touchGest)
        FloatBGView.isUserInteractionEnabled = true
        
        
        AppOrientationUtility.lockOrientation(.portrait)
        
        if CustomUserDefault.getCityId().isEmpty
        {
            /*let vc  = CityVC()
             vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
             self.navigationController?.present(vc, animated: true, completion: nil)*/
            
            let vc  = CountrySelection()
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
        //self.menuContainerViewController.panMode = MFSideMenuPanMode(rawValue: 0)
        if isComingFromWelcomeScreen{
            //setViewDynamicaly()
        }
        
    }
    
    //MARK:-
    func setBrandData(index:Int){
        if index == 0{
            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
            imgBrand1.sd_setImage(with: imgURL)
            lblBrand1.text = arrBrandDeviceGetData[index].strBrandName
            viewBrand1.isHidden = true
            viewBrand2.isHidden = true
            viewBrand3.isHidden = true
            viewBrand4.isHidden = true
            viewBrand5.isHidden = true
            viewBrand6.isHidden = true
            viewBrand7.isHidden = true
            viewBrand8.isHidden = true
            viewBrand9.isHidden = true
            
        }
        else if index == 1{
            //      let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
            //            imgBrand2.sd_setImage(with: imgURL)
            //            lblBrand2.text = arrBrandDeviceGetData[index].strBrandName
            viewBrand1.isHidden = true
            viewBrand2.isHidden = true
            viewBrand3.isHidden = true
            viewBrand4.isHidden = true
            viewBrand5.isHidden = true
            viewBrand6.isHidden = true
            viewBrand7.isHidden = true
            viewBrand8.isHidden = true
            viewBrand9.isHidden = true
        }
        //        else if index == 2{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand3.sd_setImage(with: imgURL)
        //            lblBrand3.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = true
        //            viewBrand5.isHidden = true
        //            viewBrand6.isHidden = true
        //            viewBrand7.isHidden = true
        //            viewBrand8.isHidden = true
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 3{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand4.sd_setImage(with: imgURL)
        //            lblBrand4.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = true
        //            viewBrand6.isHidden = true
        //            viewBrand7.isHidden = true
        //            viewBrand8.isHidden = true
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 4{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand5.sd_setImage(with: imgURL)
        //            lblBrand5.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = false
        //            viewBrand6.isHidden = true
        //            viewBrand7.isHidden = true
        //            viewBrand8.isHidden = true
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 5{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand6.sd_setImage(with: imgURL)
        //            lblBrand6.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = false
        //            viewBrand6.isHidden = false
        //            viewBrand7.isHidden = true
        //            viewBrand8.isHidden = true
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 6{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand7.sd_setImage(with: imgURL)
        //            lblBrand7.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = false
        //            viewBrand6.isHidden = false
        //            viewBrand7.isHidden = false
        //            viewBrand8.isHidden = true
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 7{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand8.sd_setImage(with: imgURL)
        //            lblBrand8.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = false
        //            viewBrand6.isHidden = false
        //            viewBrand7.isHidden = false
        //            viewBrand8.isHidden = false
        //            viewBrand9.isHidden = true
        //        }
        //        else if index == 8{
        //            let imgURL = URL(string:arrBrandDeviceGetData[index].strBrandLogo!)
        //            imgBrand9.sd_setImage(with: imgURL)
        //            lblBrand9.text = arrBrandDeviceGetData[index].strBrandName
        //            viewBrand1.isHidden = false
        //            viewBrand2.isHidden = false
        //            viewBrand3.isHidden = false
        //            viewBrand4.isHidden = false
        //            viewBrand5.isHidden = false
        //            viewBrand6.isHidden = false
        //            viewBrand7.isHidden = false
        //            viewBrand8.isHidden = false
        //            viewBrand9.isHidden = false
        //        }
        // if arrBrandDeviceGetData.count <= 3{
        viewMiddleHeightConstraint.constant = 150
        //            mainViewHeightConstraint.constant = 850
        // }
        //        else if arrBrandDeviceGetData.count > 3 && arrBrandDeviceGetData.count <= 6{
        //            viewMiddleHeightConstraint.constant = 300
        //        mainViewHeightConstraint.constant = 850
        //        }
        //        else {
        //            viewMiddleHeightConstraint.constant = 420
        //        }
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(HomeVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
        
        //Right menu
        let btnCity = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint1 = btnCity.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint1 = btnCity.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        btnCity.setImage(UIImage(named: "location"), for: .normal)
        btnCity.addTarget(self, action: #selector(HomeVC.btnCityPressed), for: .touchUpInside)
        //BtnSearch
        let btnSearch = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint2 = btnSearch.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint2 = btnSearch.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint2.isActive = true
        widthConstraint2.isActive = true
        btnSearch.setImage(UIImage(named: "search"), for: .normal)
        
        btnSearch.addTarget(self, action: #selector(HomeVC.btnSearchPressed), for: .touchUpInside)
        // space
        let btnSpace = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 5, height: 5)))
        let widthConstraint3 = btnSpace.widthAnchor.constraint(equalToConstant: 5)
        let heightConstraint3 = btnSpace.heightAnchor.constraint(equalToConstant: 5)
        heightConstraint3.isActive = true
        widthConstraint3.isActive = true
        let rightBarButtonSpace = UIBarButtonItem(customView: btnSpace)
        let rightBarButtonSearch = UIBarButtonItem(customView: btnSearch)
        let rightBarButtonCity = UIBarButtonItem(customView: btnCity)
        navigationItem.rightBarButtonItems = [rightBarButtonCity,rightBarButtonSpace,rightBarButtonSearch]//rightBarButtonCity
        
        
    }
    //MARK:- set view dynamically
    func setViewDynamicaly(){
        DispatchQueue.main.async {
            self.lblDevice.layer.cornerRadius = self.lblDevice.frame.size.height/2
            self.lblDevice.clipsToBounds = true
            self.lblTitleOrders.layer.cornerRadius = self.lblDevice.frame.size.height/2
            self.lblTitleOrders.clipsToBounds = true
            self.btnDiagnostic.layer.cornerRadius = CGFloat(btnCornerRadius)
            self.btnDiagnostic.clipsToBounds = true
            self.btnConfirmOrder.layer.cornerRadius = CGFloat(btnCornerRadius)
            self.btnConfirmOrder.clipsToBounds = true
            self.applyCurvedPath(givenView: self.viewTop, curvedPercent: 0.2)
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = self.viewTop.frame.size
            //            gradientLayer.colors =
            //                [UIColor.white.cgColor,UIColor.red.withAlphaComponent(1).cgColor]
            gradientLayer.colors =
                [UIColor.init(red: 114.0/255.0, green: 217.0/255.0, blue: 139.0/255.0, alpha: 1).cgColor,UIColor.init(red: 114.0/255.0, green: 217.0/255.0, blue: 207.0/255.0, alpha: 1).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            self.viewTop.layer.addSublayer(gradientLayer)
            self.viewTop.bringSubview(toFront: self.lblDevice)
            self.viewTop.bringSubview(toFront: self.lblPrice)
            self.viewTop.bringSubview(toFront: self.lblPhoneName)
            self.viewTop.bringSubview(toFront: self.lblTitleUpto)
            self.viewTop.bringSubview(toFront: self.imgPhone)
            self.viewTop.bringSubview(toFront: self.btnDiagnostic)
            self.viewTop.bringSubview(toFront: self.btnStartFromBegning)
            self.viewTop.bringSubview(toFront: self.lblTitleOrders)
            self.viewTop.bringSubview(toFront: self.collectionViewOrders)
            self.viewTop.bringSubview(toFront: self.imgWhiteArrow)
            
            //change constraint's property
            UIView.animate(withDuration: 15.0, delay: 20.0, options: .curveEaseInOut, animations: {
                self.viewTop.isHidden = true
                self.viewTopConstraintTop.constant = 0
            }, completion: nil)
        }
        
        DispatchQueue.main.async {
            var strDiagnosisSend = ""
            if self.strAppModeCode == "1"{
                if self.isDiagnosisModeCheck == "Yes"{
                    strDiagnosisSend = "Yes"
                }
                else if self.isDiagnosisModeCheck == "No"{
                    strDiagnosisSend = "No"
                    
                }
                else{
                    strDiagnosisSend = "Yes"
                    
                }
                let vc = ChangeModePopUpVC()
                vc.strProcessForDiagnosis = strDiagnosisSend
                vc.delegate = self
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(vc, animated: true, completion: nil)
                
            }
            else if self.strAppModeCode == "2"{
                
                if self.isDiagnosisModeCheck == "Yes"{
                    strDiagnosisSend = "Yes"
                }
                else if self.isDiagnosisModeCheck == "No"{
                    strDiagnosisSend = "No"
                    
                }
                else{
                    strDiagnosisSend = "No"
                    
                }
                let vc = ChangeModePopUpVC()
                vc.strProcessForDiagnosis = strDiagnosisSend
                vc.delegate = self
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
            else{
                if self.isDiagnosisModeCheck == "Yes"{
                    strDiagnosisSend = "Yes"
                    let vc = ChangeModePopUpVC()
                    vc.strProcessForDiagnosis = strDiagnosisSend
                    vc.delegate = self
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
                else if self.isDiagnosisModeCheck == "No"{
                    strDiagnosisSend = "No"
                    let vc = ChangeModePopUpVC()
                    vc.strProcessForDiagnosis = strDiagnosisSend
                    vc.delegate = self
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
                else{
                    
                }
            }
            
        }
        
    }
    
    //MARK:- cureview method
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        return arrowPath
        
    }
    
    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
    
    //MARK:- button action methods
    
    @IBAction func onClickCustomSupport(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.floatTableView.alpha = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.floatTableViewHeightConstraint.constant = 0.0
                self.view.layoutIfNeeded()
                self.floatTableView.alpha = 0
                self.FloatBGView.isHidden = true
            })
        }else {
            sender.isSelected = !sender.isSelected
            
            self.floatTableView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" || CustomUserDefault.getCurrency() == "RM" {
                    self.floatTableViewHeightConstraint.constant = 150.0
                }else {
                    self.floatTableViewHeightConstraint.constant = 150.0
                }
                
                self.view.layoutIfNeeded()
                self.floatTableView.alpha = 1
                self.FloatBGView.isHidden = false
            })
        }
        
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
    
    @IBAction func btnLaterPressed(_ sender: UIButton) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.viewConfirmOrder.isHidden = true
        })
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.viewOrderHeightConstraint.constant = 0
            //self.mainViewHeightConstraint.constant =  //self.mainViewHeightConstraint.constant - 200
        })
        userDefaults.setValue(true, forKey: "isLaterForConfirmOrder")
        userDefaults.setValue(false, forKey: "isShowUIOnHomeForOrder")
    }
    
    @IBAction func btnConfirmOrderPressed(_ sender: UIButton) {
        if isConfrimOrderApiSucess{
            setDataForConfirmOrder()
        }
        else{
            self.fireWebServiceGettingConfrimPrice(isPressedConfirmButton: true)
        }
    }
    
    func setDataForConfirmOrder(){
        let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave_forConfirmOrder") as! String)
        if let data = UserDefaults.standard.object(forKey: "Diagnosis_AnserAndQuestionData_forConfirmOrder") as? Data {
            if let arrGetQuestionAnserArrayForConfirmOrder = (NSKeyedUnarchiver.unarchiveObject(with: data) as? NSMutableArray){
                if arrGetQuestionAnserArrayForConfirmOrder.count > 0{
                    var arrQuestionAndAnswerShowSend = [PickUpQuestionModel]()
                    
                    for index in
                        0..<arrGetQuestionAnserArrayForConfirmOrder.count {
                            
                            let model = PickUpQuestionModel()
                            let dict = arrGetQuestionAnserArrayForConfirmOrder[index] as! NSMutableDictionary
                            
                            model.strQuestionName = dict.value(forKey: "questionName") as! String
                            model.strViewType = dict.value(forKey: "appViewType") as! String
                            model.strAnswerName = dict.value(forKey: "answerName") as! String
                            model.strAppViewType = dict.value(forKey: "viewType") as! String
                            
                            let arrQuestionObj = dict.value(forKey: "arrayQuestion") as! NSMutableArray
                            
                            for obj in 0..<arrQuestionObj.count {
                                
                                let moodelQuestionObj = PickUpQuestionTypesModel()
                                let dictQuestionObj = arrQuestionObj[obj] as! NSMutableDictionary
                                moodelQuestionObj.strQuestionValue = dictQuestionObj.value(forKey: "questionValue") as! String
                                moodelQuestionObj.strQuestionValueImage = dictQuestionObj.value(forKey: "questionValueImage") as! String
                                moodelQuestionObj.strQuestionValueAppCodde = dictQuestionObj.value(forKey: "questionValueAppCode") as! String
                                moodelQuestionObj.isSelected = dictQuestionObj.value(forKey: "isSelected") as! Bool
                                model.arrQuestionTypes.insert(moodelQuestionObj, at: obj)
                            }
                            arrQuestionAndAnswerShowSend.insert(model, at: index)
                    }
                    
                    userDefaults.removeObject(forKey: "productName")
                    userDefaults.set(arrMyCurrentDeviceSend[0].strCurrentDeviceName, forKey: "productName")
                    userDefaults.removeObject(forKey: "otherProductDeviceImage")
                    userDefaults.setValue(arrMyCurrentDeviceSend[0].strCurrentDeviceImage, forKey: "otherProductDeviceImage")
                    
                    let vc = ProductDetailVewVC()
                    vc.getReturnJson = sendJson
                    vc.strGetFinalAppCodeValues = userDefaults.value(forKey: "Diagnosis_AppCode_forConfirmOrder") as! String
                    vc.isComingFromOnPhoneDiagnostic = true
                    vc.isComingFromOnhomeConfirmOrder = true
                    vc.arrQuestionAndAnswerShow = arrQuestionAndAnswerShowSend
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnStratFromBegningPressed(_ sender: UIButton) {
        pushToControllerToProceedDiagnosos()
    }
    
    @IBAction func btnMoreBrandsPressed(_ sender: UIButton) {
        let vc = BrandModelTypeVC()
        vc.arrBrand = arrBrandDeviceGetData
        vc.isComingMore = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSideMenuPressed() -> Void {
        
        //        let vc = ProductDetailVewVC()
        //        self.navigationController?.pushViewController(vc, animated: true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    @IBAction @objc func btnSearchPressed(_ sender:UIButton){
        let vc  = AnotherDevice()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPromotionAndOfferPressed(_ sender:UIButton){
        let vc  = OffersAndPromotionsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnCityPressed(sender:UIButton){
        let vc  = CountrySelection()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnDiagnosticPressed(_ sender: UIButton) {
        sendToControllerToCompletediagnosisProcess()
    }
    
    func pushToControllerToProceedDiagnosos(){
        // firebase analytics event
        if arrMyCurrentDeviceSend.count > 0 {
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
            let strMaxAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
            Analytics.logEvent(AnalyticsEventViewItem, parameters: [
                AnalyticsParameterItemID: CustomUserDefault.getProductId(),
                AnalyticsParameterItemName: arrMyCurrentDeviceSend[0].strCurrentDeviceName!,
                AnalyticsParameterPrice:CustomUserDefault.getCurrency() + strMaxAmount
                ])
            
            userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
            userDefaults.setValue("", forKey: "ChangeModeComingFromDiadnosis")
            // let imei = UserDefaults.standard.string(forKey: "imei_number")
            //            if (imei?.count == 15){
            //                if arrMyCurrentDeviceSend.count > 0{
            //                    let vc  = DeviceInfoVC()
            //                    vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceSend
            //                    self.navigationController?.pushViewController(vc, animated: true)
            //                }
            //                else{
            //                    Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
            //                }
            //            }else{
            if arrMyCurrentDeviceSend.count > 0{
                //                    let vc = IMEIVC()
                //                    vc.arrMyCurrentDeviceGet = arrMyCurrentDeviceSend
                //                    self.navigationController?.pushViewController(vc, animated: true)
                let vc  = DeviceInfoVC()
                vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceSend
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                Alert.showAlert(strMessage: "Device is not map,Please try later".localized(lang: langCode) as NSString, Onview: self)
            }
            //  }
        }
        else{
            Alert.showAlert(strMessage: "Device is not map,Please try later".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    func sendToControllerToCompletediagnosisProcess(){
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if userDefaults.value(forKey: "screen_complete") == nil || self.strAppModeCode == "1" || self.strAppModeCode == "2" {
                pushToControllerToProceedDiagnosos()
            }
            else{
                var sendJson = JSON()
                if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
                    //sendJson = JSON()
                }
                else{
                    sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                }
                if userDefaults.value(forKey: "rotation_complete") as! Bool == false{
                    let vc = RotationVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                    
                }
                else if userDefaults.value(forKey: "proximity_complete") as! Bool == false{
                    let vc = SensorReadVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                    
                }
                else if userDefaults.value(forKey: "volumebutton_complete") as! Bool == false{
                    let vc = VolumeCheckerVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "earphone_complete") as! Bool == false{
                    let vc = EarPhoneVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "charger_complete") as! Bool == false{
                    let  vc = DeviceChargerVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "camera_complete") as! Bool == false{
                    let  vc = CameraVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "fingerprint_complete") as! Bool == false{
                    let  vc = FingerPrintDevice()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "bluetooth_complete") as! Bool == false{
                    let vc = BlueToothTestingVC()
                    vc.resultJSON = sendJson
                    vc.iscomingFromHome = true
                    self.present(vc, animated: true, completion:nil)
                }else{
                    pushToControllerToProceedDiagnosos()
                }
            }
        }
        else{
            if userDefaults.value(forKey: "screen_complete") == nil || self.strAppModeCode == "1" || self.strAppModeCode == "2" {
                pushToControllerToProceedDiagnosos()
                
            }
            else{
                var sendJson = JSON()
                if userDefaults.value(forKey: "Diagnosis_DataSave") == nil {
                    //sendJson = JSON()
                }
                else{
                    sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                }
                if userDefaults.value(forKey: "rotation_complete") as! Bool == false{
                    let vc = RotationVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "proximity_complete") as! Bool == false{
                    let vc = SensorReadVC()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "volumebutton_complete") as! Bool == false{
                    let vc = VolumeCheckerVC()
                    vc.resultJSON = sendJson
                    
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "camera_complete") as! Bool == false{
                    let vc = CameraVC()
                    vc.resultJSON = sendJson
                    
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "fingerprint_complete") as! Bool == false{
                    let vc = FingerPrintDevice()
                    vc.resultJSON = sendJson
                    self.present(vc, animated: true, completion:nil)
                }
                else if userDefaults.value(forKey: "bluetooth_complete") as! Bool == false{
                    let vc = BlueToothTestingVC()
                    vc.resultJSON = sendJson
                    vc.iscomingFromHome = true
                    self.present(vc, animated: true, completion:nil)
                }else{
                    pushToControllerToProceedDiagnosos()
                }
                
            }
        }
    }
    
    
    func moveToBrandTypeController(withId:Int){
        // if arrMyCurrentDeviceSend.count > 0{
        let strModelIdSend = arrBrandDeviceGetData[withId].strBrandId
        let vc = BrandModelTypeVC()
        vc.strGetBrandId = strModelIdSend!
        vc.arrBrand = arrBrandDeviceGetData
        vc.selectedIndex = withId
        vc.isComingMore = false
        self.navigationController?.pushViewController(vc, animated: true)
        //        }
        //        else{
        //            Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
        //
        //        }
    }
    
    @IBAction func btnDeviceBrand1Pressed(_ sender: UIButton) {
        moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand2Pressed(_ sender: UIButton) {
        moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand3Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand4Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand5Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand6Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand7Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand8Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func btnDeviceBrand9Pressed(_ sender: UIButton) {
        //moveToBrandTypeController(withId: sender.tag)
    }
    
    @IBAction func onClickGetQuote(_ sender: UIButton) {
        
        userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
        userDefaults.setValue("", forKey: "ChangeModeComingFromDiadnosis")
        
        if sender.titleLabel?.text == "RESUME TEST".localized(lang: langCode) {
            
            self.sendToLastVCToCompletediagnosisProcess()
            
        }else {
            let vc = Sell1()
            vc.strDevie = self.lblPhoneName.text!
            vc.imgView = self.imgPhone
            self.navigationController?.pushViewController(vc, animated: true)
            //self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPopular{
            return arrPopularDeviceGetData.count
        }
        else{
            //return arrShowMyOrders.count
            
            // Sameer 13/4/20
            return arrOrderList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewPopular{
            let cellPopular = collectionView.dequeueReusableCell(withReuseIdentifier: "trandingDeviceCell", for: indexPath) as! TrandingDeviceCell
            cellPopular.lblPhoneName.text = arrPopularDeviceGetData[indexPath.row].strPopularName
            let strAmount = arrPopularDeviceGetData[indexPath.row].maximumTotal!.formattedWithSeparator
            //let strAmount  = String(format: "%d", arrPopularDeviceGetData[indexPath.row].maximumTotal!)
            cellPopular.lblPrice.text = CustomUserDefault.getCurrency()  + strAmount
            let imgURL = URL(string:arrPopularDeviceGetData[indexPath.row].strPopularImage!)
            cellPopular.imgDevice.sd_setImage(with: imgURL)
            return cellPopular
        }
        else{
            /*
             let cellOrders = collectionView.dequeueReusableCell(withReuseIdentifier: "yoursOrderCell", for: indexPath) as! YoursOrderCell
             let dict = arrShowMyOrders[indexPath.row] as! NSDictionary
             cellOrders.lblOrderDate.text = arrMyOderGetData[indexPath.row].strMyOrderDate
             cellOrders.lblOrderName.text = dict.value(forKey: "productName") as? String
             let imgURL = URL(string:(dict.value(forKey: "productImage") as? String)!)!
             cellOrders.imgOrder.sd_setImage(with: imgURL)
             return cellOrders
             */
            
            let cellOrders = collectionViewOrderDetails.dequeueReusableCell(withReuseIdentifier: "MyOrdersCell", for: indexPath) as! MyOrdersCell
            let dict = arrOrderList[indexPath.row]
            print(dict.strStatus ?? [:])
            cellOrders.lblOrderName.text = dict.strProductName
            cellOrders.lblOrderId.text = dict.strRefrenceNumber
            
            switch dict.strStatus {
            case "Unverified":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "packman waiting")
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            case "Verified":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "packman waiting")
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            case "Out for pickup":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "packman waiting")
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            case "Pacman cancelled":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "pacman cancel")
                cellOrders.lblPacman.text = "Pacman cancelled".localized(lang: langCode)
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
            case "Pending Payment":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "pacman cancel")
                cellOrders.lblPacman.text = "Pending Payment".localized(lang: langCode)
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
            case "Complete":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "pacman cancel")
                cellOrders.lblPacman.text = "Complete".localized(lang: langCode)
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
            case "Rejected":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "pacman cancel")
                cellOrders.lblPacman.text = "Rejected".localized(lang: langCode)
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
            case "User cancelled":
                cellOrders.imgPlaced.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgVerify.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgOutFor.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.imgPacman.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
                cellOrders.imgPacman.image = #imageLiteral(resourceName: "pacman cancel")
                cellOrders.lblPacman.text = "User cancelled".localized(lang: langCode)
                
                cellOrders.lblVerifyLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblVerifyRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForLeft.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblOutForRight.backgroundColor = #colorLiteral(red: 0.04828050733, green: 0.656562984, blue: 0.2261204422, alpha: 1)
                cellOrders.lblPacmanLeft.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.06666666667, alpha: 1)
            default:
                print("Nothing to do")
            }
            
            return cellOrders
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewPopular {
            return CGSize(width: collectionViewPopular.frame.width/3, height:200)
        }
        else{
            //return CGSize(width: collectionViewOrders.frame.width, height:collectionViewOrders.frame.height)
            
            //Sameer 12/4/20
            return CGSize(width: collectionViewOrderDetails.frame.width, height:collectionViewOrderDetails.frame.height)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewPopular {
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
                
                let strMaxAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                
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
                else{
                    Alert.showAlert(strMessage: "Device is not map,Please try later".localized(lang: langCode) as NSString, Onview: self)
                    
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
        else{
            let vc = OrderDetail()
            let model = arrOrderList[indexPath.row]
            vc.orderDetail = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- APi for verification code
    func diagnosisPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForVerificationCode(strVerificationCode:String,withProcessCode:String)
    {
        if reachability?.connection.description != "No Connection" {
            var strAppCode = ""
            if withProcessCode == "Yes" {
                strAppCode = "1"
            }
            else{
                strAppCode = "2"
            }
            var strUudid = ""
            if (KeychainWrapper.standard.string(forKey: "UUIDValue") != nil){
                strUudid = KeychainWrapper.standard.string(forKey: "UUIDValue")!
            }
            else{
                let uuID = UIDevice.current.identifierForVendor!.uuidString
                _ = KeychainWrapper.standard.set(uuID, forKey: "UUIDValue")
                strUudid = uuID
            }
            
            // let imEINumber = userDefaults.value(forKey: "imei_number") as! String
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "appModeCode"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "appModeCode": strVerificationCode,
                "appMode":strAppCode,
                "customerId":CustomUserDefault.getUserId(),
                "uniqueIdentifire":strUudid + "~" + strUudid
            ]
            
            print(parameters)
            
            self.diagnosisPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
                        userDefaults.removeObject(forKey: "ChangeModeOrderId")
                        userDefaults.set(responseObject?["orderItemId"] as! String, forKey: "ChangeModeOrderId")
                        if withProcessCode == "Yes"{
                            userDefaults.set("Diagnosis", forKey: "ChangeModeComingFromDiadnosis")
                            DispatchQueue.main.async {
                                let vc = ScreenTestingVC()
                                self.navigationController?.present(vc, animated: true, completion: nil)
                            }
                        }
                        else{
                            userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
                            //userDefaults.removeObject(forKey: "pickUpAppCodes")
                            
                            userDefaults.set("Pickup", forKey: "ChangeModeComingFromDiadnosis")
                            // userDefaults.set(responseObject?["selectedStr"] as! String, forKey: "pickUpAppCodes")
                            
                            //Set array for questions
                            
                            var arrPickUpQuestion = NSArray()
                            arrPickUpQuestion = responseObject?["msg"] as! NSArray
                            userDefaults.removeObject(forKey: "PickUpQuestions")
                            let myData = NSKeyedArchiver.archivedData(withRootObject: arrPickUpQuestion)
                            userDefaults.set(myData, forKey: "PickUpQuestions")
                            
                            DispatchQueue.main.async {
                                // let vc = PickUpQuestionVC()
                                let vc = ScreenTestPickUp()
                                self.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                        }
                    }
                    else{
                        
                        Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                }
            })
            
        }
        else
        {
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    func fireWebServiceGettingConfrimPrice(isPressedConfirmButton:Bool)
    {
        // self.isConfrimOrderApiSucess = true
        if reachability?.connection.description != "No Connection"{
            if isPressedConfirmButton == true{
                activityConfirmOrder.startAnimating()
            }
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "productQuote"
            let returnMetaDetails : NSMutableDictionary = [:]
            let strSourceOfQuote = "diagnosis"
            userDefaults.set(true, forKey: "OrderPlaceFordiagnosis")
            var returnDictionary : NSMutableDictionary = [:]
            returnDictionary = userDefaults.value(forKey: "resturn_dictonoryFor_confirm_Order") as! NSMutableDictionary
            let IMEINumer = KeychainWrapper.standard.string(forKey: "UUIDValue")!
            let productId = CustomUserDefault.getProductId()
            let deviceName  = UIDevice.current.modelName  as String
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let strRam = ProcessInfo.processInfo.physicalMemory
            let bundleID = Bundle.main.bundleIdentifier!
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            let strValues = userDefaults.value(forKey: "Final_AppCodes_Diagnosis") as! String
            let strRom = UIDevice.current.totalDiskSpace()
            let SystemSharedServices = SystemServices.shared()
            let BatteryLevel = String(format: "%.1f %@", SystemSharedServices.batteryLevel,"%")
            returnMetaDetails.setValue(bundleID, forKey: "Apppackagename")
            returnMetaDetails.setValue(buildNumber, forKey: "BuildRelease")
            returnMetaDetails.setValue("\(version ?? "")", forKey: "versionname")
            returnMetaDetails.setValue(deviceName, forKey: "Devicemodel")
            returnMetaDetails.setValue(strRom, forKey: "DeviceStorag")
            returnMetaDetails.setValue(strRam, forKey: "DeviceRAM")
            returnMetaDetails.setValue(BatteryLevel, forKey: "BattaryLevel")
            returnMetaDetails.setValue(SystemSharedServices.fullyCharged, forKey: "BattaryFullyCharged")
            returnMetaDetails.setValue(KeychainWrapper.standard.string(forKey: "UUIDValue")!, forKey: "UUDIDValue")
            if SystemSharedServices.jailbroken == 4783242{
                returnMetaDetails.setValue("No", forKey: "JailBroken")
            }
            else{
                returnMetaDetails.setValue("YES", forKey: "JailBroken")
            }
            var userId = ""
            if CustomUserDefault.isUserIdExit(){
                userId = CustomUserDefault.getUserId()
            }
            else{
                userId = "-1"
            }
            let jsonData = try! JSONSerialization.data(withJSONObject: returnMetaDetails, options:[])
            let jsonStringforMetaDetails = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let jsonData1 = try! JSONSerialization.data(withJSONObject: returnDictionary, options:[])
            let jsonStringforMetaDetails1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
            
            let strSkipData = userDefaults.value(forKey: "SkipDateForConfirmOrder") as! String
            
            let parameters : [String : Any] = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "productId":productId,
                "mobile":CustomUserDefault.getPhoneNumber() ?? "",
                "str":strValues,
                "city":CustomUserDefault.getCityId(),
                "lat":"",
                "lon":"",
                "userCityDetect":CustomUserDefault.getCityName(),
                "sourceOfQuote":strSourceOfQuote,
                "resultJson":jsonStringforMetaDetails1,
                "metaDetails":jsonStringforMetaDetails,//returnMetaDetails,
                "IMEINumber":  IMEINumer,
                "customerId":userId,
                "isAppCode":"1",
                "skipStr":strSkipData,
                "ipAddress":""
            ]
            print(parameters)
            
            self.diagnosisPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                if isPressedConfirmButton == true {
                    self.activityConfirmOrder.stopAnimating()
                } 
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        self.isConfrimOrderApiSucess = true
                        let pickUpCharges = responseObject?["pickupCharges"] as! Int
                        userDefaults.setValue(pickUpCharges, forKey: "pickupCharges")
                        let strPriceOld = userDefaults.value(forKey: "Product_UpToOffer") as! String
                        
                        let priceNewForFinal = responseObject?["totalPromoterAmount"] as! Int
                        var strPriceNew = String(priceNewForFinal)
                        if  strPriceNew == strPriceOld {
                            self.lblPriceDropMessage.isHidden = true
                        }
                        else{
                            let price  = Int(strPriceNew)
                            strPriceNew = (price?.formattedWithSeparator)!
                            self.priceConfirmOrderFinal = price!
                            //self.lblPriceDropMessage.isHidden = false
                            self.lblPriceDropMessage.isHidden = true
                            
                            let myString = "Hurry!! Your Offer Of ".localized(lang: langCode) + CustomUserDefault.getCurrency() + strPriceNew + " May Drop In Few Days".localized(lang: langCode)
                            //  let attrString = NSAttributedString(string: myString)
                            let attribute = NSMutableAttributedString.init(string: myString)
                            let strCount = CustomUserDefault.getCurrency() + strPriceNew
                            
                            var myRange = NSRange()
                            if langCode == "en" {
                                myRange = NSRange(location: 22, length: (strCount.count))
                            }else {
                                myRange = NSRange(location: 9, length: (strCount.count))
                            }
                            
                            //let myRange = NSRange(location: 22, length: (strCount.count))
                            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: navColor , range: myRange)
                            self.lblConfirmOrderPrice.attributedText = attribute
                        }
                    }
                    else{
                        self.isConfrimOrderApiSucess = false
                    }
                }
                else
                {
                    self.isConfrimOrderApiSucess = false
                }
            })
            
        }
        else
        {
            self.isConfrimOrderApiSucess = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

extension HomeVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            return self.floatingItemsArrayIN.count
        }else if CustomUserDefault.getCurrency() == "RM" {
            return self.floatingItemsArrayMY.count
        }else {
            return self.floatingItemsArrayMY.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let floatingItemCell = tableView.dequeueReusableCell(withIdentifier: "FloatingItemCell", for: indexPath) as! FloatingItemCell
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            floatingItemCell.itemImgView.image = floatingImageArrayIN[indexPath.row]
            floatingItemCell.itemDescriptionLbl.text = floatingItemsArrayIN[indexPath.row].localized(lang: langCode)
            
        }else if CustomUserDefault.getCurrency() == "RM" {
            
            floatingItemCell.itemImgView.image = floatingImageArrayMY[indexPath.row]
            floatingItemCell.itemDescriptionLbl.text = floatingItemsArrayMY[indexPath.row].localized(lang: langCode)
            
        }else {
            
            floatingItemCell.itemImgView.image = floatingImageArrayMY[indexPath.row]
            floatingItemCell.itemDescriptionLbl.text = floatingItemsArrayMY[indexPath.row].localized(lang: langCode)
            
        }
        
        return floatingItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //var floatingItemsArrayIN:[String] = ["  Call  ","  Mail  ","  Zopim Chat  "]
        //var floatingItemsArrayMY:[String] = ["  WhatsApp  ","  Call  ","  Mail  "]
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            switch indexPath.row {
            case 0:
                self.onClickCallButton()
            case 1:
                self.onClickEmailButton()
            default:
                print("Zopim Chat")
            }
            
        }else if CustomUserDefault.getCurrency() == "RM" {
            
            switch indexPath.row {
            case 0:
                
                guard let url = URL(string: "https://wa.me/601165273417") else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            case 1:
                self.onClickCallButton()
            default:
                self.onClickEmailButton()
            }
            
        }else {
            
            switch indexPath.row {
            case 0:
                
                guard let url = URL(string: "https://wa.me/601165273417") else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            case 1:
                self.onClickCallButton()
            default:
                self.onClickEmailButton()
            }
            
        }
        
        btnFloating.isSelected = !btnFloating.isSelected
        
        self.floatTableView.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.floatTableViewHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            self.floatTableView.alpha = 0
            self.FloatBGView.isHidden = true
        })
        
    }
    
    func onClickEmailButton() {
        
        if !MFMailComposeViewController.canSendMail() {
            Alert.showAlert(strMessage: "Oops! Mail Service not available.".localized(lang: langCode) as NSString, Onview: self)
        }
        else{
            var emailAddress = String()
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                emailAddress = "support@getinstacash.in"
            }else {
                emailAddress = "support@getinstacash.com.my"
            }
            
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([emailAddress])
            composeVC.setSubject("Message Subject".localized(lang: langCode))
            composeVC.setMessageBody("Message content.".localized(lang: langCode), isHTML: false)
            
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
    
    func onClickCallButton() {
        
        var phoneNumber = String()
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            phoneNumber = "0141-4232323"
        }else {
            phoneNumber = "+60365273417"
        }        
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            Alert.showAlert(strMessage: "Your device doesn't support this feature.".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
}
