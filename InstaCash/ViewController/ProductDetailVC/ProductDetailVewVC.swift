//
//  ProductDetailVewVC.swift
//  InstaCash
//
//  Created by InstaCash on 13/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MFSideMenu
import SwiftyJSON
import Firebase
import FacebookCore
import PopupDialog
import SystemServices

class ModelSkippedData: NSObject {
    var isSkipped = false
    var strName = ""
    var imgSkipped = UIImage()
    
}

class ProductDetailVewVC: UIViewController,UIViewControllerTransitioningDelegate,UITableViewDataSource,UITableViewDelegate {
    
    /*
    @IBOutlet weak var lblPromoter: UILabel!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewBottomAnimtePlaceOrder: UIView!
    @IBOutlet weak var placeOrderPopUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgScroolProductTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgNoteWarning: UIImageView!
    @IBOutlet weak var lblPlaceOrderNote: UILabel!
    */
    
    /*
    @IBOutlet weak var viewBottomForShadow: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnPlaceOrderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnLockPriceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbleviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPriceScroolUp: UILabel!
    @IBOutlet weak var lblPriceTitleScroolup: UILabel!
    @IBOutlet weak var lblProductNameWhenScroolUp: UILabel!
    @IBOutlet weak var imgProductWhenScroolUp: UIImageView!
    @IBOutlet weak var imgMainProductHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgMainDeviceWidhConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCompleteDignosisTile: UILabel!
    @IBOutlet weak var btnSendAppLink: UIButton!
    @IBOutlet weak var lblOtherDEviceName: UILabel!
    @IBOutlet weak var lblDiagnosticPending: UILabel!
    @IBOutlet weak var imgDiagnisticPending: UIImageView!
    @IBOutlet weak var tblViewTop: NSLayoutConstraint!
    @IBOutlet weak var viewBGForShadow: UIView!
    @IBOutlet weak var imgSwipeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var viewTopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblShadow: UILabel!
    @IBOutlet weak var viewCurve: UIView!
    @IBOutlet weak var viewmiddle: UIView!
    @IBOutlet weak var lblSwipe: UILabel!
    @IBOutlet weak var imgSwipe: UIImageView!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var collectionViewFailedTest: UICollectionView!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblCollectionviewTitle: UILabel!
    
    @IBOutlet weak var lblPriceworthtitle: UILabel!
    */
    
    
    @IBOutlet weak var btnLockPrice: UIButton!
    @IBOutlet weak var viewForBorder: UIView!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    var arrBrandDeviceGetData = [HomeModel]()
    var arrMyOderGetData = [HomeModel]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var arrPopularDeviceGetData = [HomeModel]()
    var arrBrandModelType = [HomeModel]()
    var strAppModeCode = ""
    
    let reachability: Reachability? = Reachability()
    
    @IBOutlet weak var heightOftbl: NSLayoutConstraint! //s.
    @IBOutlet weak var tableView: UITableView! //s.
    var arrKey = [String]() //s.
    var arrValue = [String]() //s.
    var quatationID = String() //s.
    
    //@IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblQuote: UILabel!
    @IBOutlet weak var lblYourDeviceWorth: UILabel!
    @IBOutlet weak var lblthePriceBased: UILabel!
    @IBOutlet weak var lblHurry: UILabel!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    
    var isSwipeTop = false
    var swipeUpAndDown = UISwipeGestureRecognizer()
    var swipeUpAndDownPanGesture = UIPanGestureRecognizer()
    var returnDictionary : NSMutableDictionary = [:]
    var strGetFinalAppCodeValues = ""
    var getReturnJson  =  JSON()
    var isComingFromOnPhoneDiagnostic = false
    var isComingFromOnhomeConfirmOrder = false
    
    var deviceId = String()
    var deviceName = String()
    var deviceImageUrl = String()

    var arrQuestionAndAnswerShow = [PickUpQuestionModel]()
    var productPrice = 0
    var couponPrice = 0
    var strDiagnosisFailed = ""
    var pickUpCharges = 0
    var priceSend = 0
    var strSkipData = ""

    var arrSkippedData = [ModelSkippedData]()
    var arrSkippedDataDumyQuestion = ["Display & Touch Screen your","Device Body (Back Panel / Cover)","Display & Touch Screen your","Device Body (Back Panel / Cover)","Display & Touch Screen your","Device Body (Back Panel / Cover)","Display & Touch Screen your","Device Body (Back Panel / Cover)"]
    var arrSkippedDataDumyAnswer = ["Flawless","Flawless","Flawless","Flawless","Flawless","Flawless","Flawless","Flawless"]
    var priceProduct = ""
    var increaseHeight = 0
    /*var childScrollView: UIScrollView {
        //return tableView
    }*/
    var isSwipeUP = false
    var childScrollingDownDueToParent = false
    
    //MARK:- custom delegate
    func showPromoCode(){
        //let strPriceUpTo = userDefaults.value(forKey: "Product_UpToPrice") as? String
        let vc = PromoCodeVC()
        vc.getFinalPrice = self.priceSend
        vc.strProductName = userDefaults.value(forKey: "productName") as? String ?? ""
        vc.strProductImg = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
        vc.pickUpChargeGet = self.pickUpCharges
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- broadcast methods
    @objc func methodOfReceivedNotificationForSkippedData(notification: Notification) {
        reSetDiagnosHomeUIProcess()
        self.getReturnJson = notification.object as! JSON
        //save json
        userDefaults.removeObject(forKey: "Diagnosis_DataSave_forConfirmOrder")
        userDefaults.setValue(self.getReturnJson.rawString(), forKey: "Diagnosis_DataSave_forConfirmOrder")
        
        if arrSkippedData.count > 0 {
            let strObject = notification.userInfo?["TestPassName"] as? String
            for i in 0..<arrSkippedData.count{
                let model = arrSkippedData[i]
                if strObject == model.strName{
                    model.isSkipped = false
                  //  strObject = ""
                }
                else {
                  //  model.isSkipped = true
                }

            }
            if reachability?.connection.description != "No Connection"{
                //self.fetchOrderFromServer(isRefreshPrice: true)
            }
            else{
                Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
            }
            //collectionViewFailedTest.reloadData()
        }
        else{
            
        }
    }
    
    func setFontSize(){
        self.lblProductName.font = UIFont(name: fontNameLight, size: fontSizeHeading)
        //self.lblPriceworthtitle.font = UIFont(name: fontNameLight, size: fontSizeSubHeading)
        self.lblPrice.font = UIFont(name: fontNameMedium, size: fontSizebuttons)
        //self.lblDiagnosticPending.font = UIFont(name: fontNameMedium, size: fontSizeSubHeadingVerySmall)
        //lblCollectionviewTitle.font = UIFont(name: fontNameMedium, size: fontSizeSubHeading)
        //lblOtherDEviceName.font = UIFont(name: fontNameLight, size: fontSizeSubHeading)
      //  btnSendAppLink.titleLabel?.font = UIFont(name: fontNameRegular, size: fontSizeSubHeading)
        //lblCompleteDignosisTile.font = UIFont(name: fontNameLight, size: fontSizeSubHeadingSmall)
        //lblSwipe.font = UIFont(name: fontNameLight, size: fontSizeSubHeadingSmall)
        //lblPlaceOrderNote.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingSmall)
      //  btnPlaceOrder.titleLabel?.font = UIFont(name: fontNameRegular, size: fontSizeSubHeading)
      //  btnLockPrice.titleLabel?.font = UIFont(name: fontNameRegular, size: fontSizeSubHeading)
    }
    
    //MARK:- view lifecycle
    override func viewWillAppear(_ animated: Bool) {
        AppOrientationUtility.lockOrientation(.portrait)
        
        self.viewForBorder.layer.borderWidth = 1.0
        self.viewForBorder.layer.borderColor = UIColor.gray.cgColor
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblQuote.text = "Quotation".localized(lang: langCode)
        self.lblYourDeviceWorth.text = "Your device is worth".localized(lang: langCode)
        self.lblthePriceBased.text = "The price is based on your self-reported device condition.".localized(lang: langCode)
        self.lblHurry.text = "Hurry, prices may drop in few days...".localized(lang: langCode)
        self.btnPlaceOrder.setTitle("PLACE ORDER".localized(lang: langCode), for: UIControlState.normal)
    }

    func reSetDiagnosHomeUIProcess(){
        userDefaults.removeObject(forKey: "screen_complete")
        userDefaults.removeObject(forKey: "rotation_complete")
        userDefaults.removeObject(forKey: "proximity_complete")
        userDefaults.removeObject(forKey: "volumebutton_complete")
        userDefaults.removeObject(forKey: "earphone_complete")
        userDefaults.removeObject(forKey: "charger_complete")
        userDefaults.removeObject(forKey: "camera_complete")

        userDefaults.setValue(true, forKey: "screen_complete")
        userDefaults.setValue(true, forKey: "rotation_complete")
        userDefaults.setValue(true, forKey: "proximity_complete")
        userDefaults.setValue(true, forKey: "volumebutton_complete")
        userDefaults.setValue(true, forKey: "earphone_complete")
        userDefaults.setValue(true, forKey: "charger_complete")
        userDefaults.setValue(true, forKey: "camera_complete")
        
        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone XS" || UIDevice.current.modelName == "iPhone XS Max" || UIDevice.current.modelName == "iPhone 5c" || UIDevice.current.modelName == "iPhone 5" || UIDevice.current.modelName == "iPhone XR"{
            userDefaults.removeObject(forKey: "fingerprint_complete")
            userDefaults.setValue(true, forKey: "fingerprint_complete")
        }
        else{
            userDefaults.removeObject(forKey: "fingerprint_complete")
            userDefaults.setValue(true, forKey: "fingerprint_complete")
        }
        userDefaults.removeObject(forKey: "bluetooth_complete")
        userDefaults.setValue(true, forKey: "bluetooth_complete")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.value(forKey: "promoter_id") == nil {
           //lblPromoter.text = ""
            btnLockPrice.isHidden = false
        }
        else{
            let prmoterName = userDefaults.value(forKey: "promoter_Name") as! String
            //lblPromoter.text =  "Includes " + prmoterName + " additional value"
            btnLockPrice.isHidden = true
        }
        
        //didPullToRefresh() //s.
        self.fetchOrderFromServer(isRefreshPrice: false) //s.
        
        tableView.register(UINib(nibName: "ProductSummaryTblViewCell", bundle: nil), forCellReuseIdentifier: "ProductSummaryTblViewCell")
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 60
        btnPlaceOrder.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnPlaceOrder.clipsToBounds = true
        userDefaults.setValue(false, forKey: "isSkippedRotation")
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationForSkippedData(notification:)), name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: nil)
        //lblProductNameWhenScroolUp.text = userDefaults.value(forKey: "productName") as? String
        /*if (lblProductNameWhenScroolUp.text?.contains("iPhone"))!{
            btnSendAppLink.setImage(UIImage(named: "sendAppLink"), for: .normal)
        }
        else{
            btnSendAppLink.setImage(UIImage(named: "googlePlay"), for: .normal)
        }*/
        //lblProductName.text = userDefaults.value(forKey: "productName") as? String
        //lblOtherDEviceName.text = userDefaults.value(forKey: "productName") as? String
        //let strImgProducct = userDefaults.value(forKey: "ProductDeviceImage") as? String
        //let imgURL = URL(string:strImgProducct!)
        //imgProductWhenScroolUp.sd_setImage(with: imgURL)
        //imgProduct.sd_setImage(with: imgURL)
        //btnSendAppLink.layer.cornerRadius = CGFloat(btnCornerRadius)
        //btnSendAppLink.clipsToBounds = true
        
        if isComingFromOnPhoneDiagnostic {
            if isComingFromOnhomeConfirmOrder == false{
                reSetDiagnosHomeUIProcess()
            }
            /*lblDiagnosticPending.isHidden = true
             lblCompleteDignosisTile.isHidden = true
             imgDiagnisticPending.isHidden = true
             lblOtherDEviceName.isHidden = true
             lblPriceTitleScroolup.isHidden = true
             lblCollectionviewTitle.text = "Complete these tests to Unlock above price"
             btnSendAppLink.isHidden = true
             btnPlaceOrder.setTitle("Place order @", for: .normal)
             collectionViewFailedTest.isHidden = false
             imgNoteWarning.isHidden = false
             }
             else{
             imgNoteWarning.isHidden = true
             lblCompleteDignosisTile.isHidden = false
             lblDiagnosticPending.isHidden = false
             imgDiagnisticPending.isHidden = false
             lblOtherDEviceName.isHidden = false
             lblCollectionviewTitle.text = "run InstaCash app on your"
             btnSendAppLink.isHidden = false
             lblPriceTitleScroolup.isHidden = true
             lblPlaceOrderNote.text = "I'll run the diagnostics later"
             btnPlaceOrder.setTitle("Place order", for: .normal)
             collectionViewFailedTest.isHidden = true
             }*/
            //createSkippedDataForShowData(isRefreshForData: false)
            
            //tableView.delegate = self
            //tableView.dataSource = self
            //collectionViewFailedTest.register(UINib(nibName: "TestFailedAndSkipCell", bundle: nil), forCellWithReuseIdentifier: "testFailedAndSkipCell")
            //tableView.register(UINib(nibName: "NewProductQuoteHeaderCell", bundle: nil), forCellReuseIdentifier: "newProductQuoteHeaderCell")
            //tableView.register(UINib(nibName: "QuestionAndAnswerCell", bundle: nil), forCellReuseIdentifier: "questionAndAnswerCell")
            
            Analytics.logEvent("finish_diagnosis_test", parameters: [
                "event_category":"finish diagnosis",
                "event_action":"finish diagnosis test",
                "event_label":"finish test"
                ])
            userDefaults.set(0, forKey: "couponCodePrice")
            userDefaults.set("", forKey: "orderPromoCode")
            
            if reachability?.connection.description != "No Connection"{
                //self.fetchOrderFromServer(isRefreshPrice: false)
            }
            else{
                Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
            }
            //        if UIScreen.main.bounds.size.height <= 568{
            //            //iphone 4,5
            //            tbleviewHeightConstraint.constant = 250
            //            imgMainDeviceWidhConstraint.constant = 40
            //            imgMainProductHeightConstraint.constant = 40
            //
            //        }
            //        else if UIScreen.main.bounds.size.height >= 568 && UIScreen.main.bounds.size.height <= 667{
            //            //iphone 6,7,8
            //            tbleviewHeightConstraint.constant = 330
            //            imgMainDeviceWidhConstraint.constant = 100
            //            imgMainProductHeightConstraint.constant = 100
            //
            //        }
            //        else if UIScreen.main.bounds.size.height >= 667 && UIScreen.main.bounds.size.height <= 736{
            //            //iphone 6,7,8 plus
            //            tbleviewHeightConstraint.constant = 360
            //            imgMainDeviceWidhConstraint.constant = 120
            //            imgMainProductHeightConstraint.constant = 120
            //        }
            //        else if UIScreen.main.bounds.size.height >= 736 && UIScreen.main.bounds.size.height <= 812{
            //            //iphone x,xs
            //            tbleviewHeightConstraint.constant = 400
            //            imgMainDeviceWidhConstraint.constant = 140
            //            imgMainProductHeightConstraint.constant = 140
            //            btnPlaceOrderHeightConstraint.constant = 45
            //            btnLockPriceHeightConstraint.constant = 45
            //            collectionViewHeightConstraint.constant = 90
            //
            //        }
            //        else if UIScreen.main.bounds.size.height >= 812 && UIScreen.main.bounds.size.height <= 896{
            //            //iphone xr,xs Max
            //            tbleviewHeightConstraint.constant = 430
            //            imgMainDeviceWidhConstraint.constant = 150
            //            imgMainProductHeightConstraint.constant = 150
            //            btnPlaceOrderHeightConstraint.constant = 50
            //            btnLockPriceHeightConstraint.constant = 50
            //            collectionViewHeightConstraint.constant = 100
            //        }
            //        else{
            //            //iphone xr,xs Max above
            //            tbleviewHeightConstraint.constant = 550
            //            imgMainDeviceWidhConstraint.constant = 150
            //            imgMainProductHeightConstraint.constant = 150
            //            btnPlaceOrderHeightConstraint.constant = 45
            //            btnLockPriceHeightConstraint.constant = 45
            //            collectionViewHeightConstraint.constant = 90
            //        }
            //setNavigationBar()
            //setViewDynamically()
            setFontSize()
            
            // Do any additional setup after loading the view.
        }
    }
    
    func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection" {
            //Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode)  in
                
                self.arrPopularDeviceGetData.removeAll()
                self.arrBrandModelType.removeAll()
                
                self.arrBrandDeviceGetData = arrBrandDeviceGetData
                self.arrPopularDeviceGetData = arrPopularDeviceGetData
                
                self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                
                if arrMyCurrentDeviceSend.count > 0 {
                    
                    let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                    self.imgProduct.sd_setImage(with: imgURL)
                    self.lblProductName.text = arrMyCurrentDeviceSend[0].strCurrentDeviceName
                    //let strAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                    
                    let price = Int(arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                    
                    self.lblPrice.text = CustomUserDefault.getCurrency() + price.formattedWithSeparator
                }
            }
        }
        else{
            
        }
    }
    
    //MARK:- create skipped data
    
    func createSkippedDataForShowData(isRefreshForData:Bool){
        strSkipData = ""
        if getReturnJson["Screen"].int == -1{
            let model = ModelSkippedData()
            model.isSkipped = true
            model.strName = "Screen"
            model.imgSkipped = UIImage(named: "screenTouchTest")!
            if isRefreshForData == false{
            arrSkippedData.append(model)
            }
            strSkipData = "SBRK01;"

        }
   
//        if getReturnJson["Rotation"].int == -1{
//            userDefaults.setValue(true, forKey: "isSkippedRotation")
//            let model = ModelSkippedData()
//            model.isSkipped = true
//            model.strName = "Rotation"
//            model.imgSkipped = UIImage(named: "rotateTest")!
//            arrSkippedData.append(model)
//
//        }

//        if getReturnJson["Proximity"].int == -1{
//            let model = ModelSkippedData()
//            model.isSkipped = true
//            model.strName = "Proximity"
//            model.imgSkipped = UIImage(named: "proximtyTest")!
//            arrSkippedData.append(model)
//
//        }
        
        if getReturnJson["Hardware Buttons"].int == -1{
            let model = ModelSkippedData()
            model.isSkipped = true
            model.strName = "Hardware Buttons"
            model.imgSkipped = UIImage(named: "hardWareButtonTest")!
            if isRefreshForData == false{
            arrSkippedData.append(model)
            }
            strSkipData = strSkipData + "CISS02;"

        }
 
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if getReturnJson["Earphone"].int == -1{
                let model = ModelSkippedData()
                model.isSkipped = true
                model.strName = "Earphone"
                model.imgSkipped = UIImage(named: "earphoneSkipped")!
                if isRefreshForData == false{
                arrSkippedData.append(model)
                }
                strSkipData = "CISS11;"

            }
            
            if getReturnJson["USB"].int == -1{
                let model = ModelSkippedData()
                model.isSkipped = true
                model.strName = "Charger"
                model.imgSkipped = UIImage(named: "chargerTest")!
                if isRefreshForData == false{
                    arrSkippedData.append(model)
                }
                strSkipData = strSkipData + "CISS05;"

            }

        }
        if getReturnJson["Camera"].int == -1{
            let model = ModelSkippedData()
            model.isSkipped = true
            model.strName = "Camera"
            model.imgSkipped = UIImage(named: "cameraSkippedTest")!
            if isRefreshForData == false{
            arrSkippedData.append(model)
            }
            strSkipData = strSkipData + "CISS01;"

        }
        
        if getReturnJson["Fingerprint Scanner"].int == -1{
            let model = ModelSkippedData()
            model.isSkipped = true
            model.strName = "Fingerprint Scanner"
            model.imgSkipped = UIImage(named: "fingerPrintTest")!
            if isRefreshForData == false{
            arrSkippedData.append(model)
            }
            strSkipData = strSkipData + "CISS12;"

        }
        
        /*if arrSkippedData.count > 0{
            collectionViewFailedTest.reloadData()
            lblCollectionviewTitle.isHidden = false
            collectionViewFailedTest.isHidden = false
            imgDiagnisticPending.isHidden = true
            lblDiagnosticPending.isHidden = true
            lblCollectionviewTitle.text = "Retry these tests to unlock the price above"
            if UIScreen.main.bounds.size.height <= 568{
                imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.08
                imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.08
                tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.48
            }
            else if UIScreen.main.bounds.size.height >= 736{
                if UIScreen.main.bounds.size.height == 896{
                    tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.46
                    imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.12
                    imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.12
                    collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.14

                }
                else{
                collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.14
                imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.14
                imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.14
                tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.53
                }
            }

            else{
                collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.55

            }
         
        }
        else{
            if isComingFromOnPhoneDiagnostic{
            tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.45
                collectionViewFailedTest.isHidden = true
                imgDiagnisticPending.isHidden = false
                lblDiagnosticPending.isHidden = false
                lblCollectionviewTitle.isHidden = false
                imgDiagnisticPending.image = UIImage(named: "testPass")
                lblDiagnosticPending.text = "Fully Functional"
                lblCollectionviewTitle.text = "This price is based on your self reported device condition"
                imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.15
            }
            else{
                collectionViewFailedTest.isHidden = true
                imgDiagnisticPending.isHidden = false
                lblDiagnosticPending.isHidden = false
                lblCollectionviewTitle.isHidden = false
                imgDiagnisticPending.image = UIImage(named: "skipped")
                lblDiagnosticPending.text = "Diagnostic Pending"
                lblCollectionviewTitle.text = "run InstaCash app on your"
                if UIScreen.main.bounds.size.height <= 568{
                    tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.48
                    imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.08
                    imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.08
                }
                else if UIScreen.main.bounds.size.height >= 736{
                    
                    if UIScreen.main.bounds.size.height == 896{
                        tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.46
                        imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.13
                        imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.13
                    }
                    else{
                        tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.50
                        imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                        imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                    }
                    
               
                }

                else{
                    tbleviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.55
                    imgMainDeviceWidhConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                    imgMainProductHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.15
                }
            }
        }*/
    }
    
    //s.
    /*
    //MARK: tableview delegate and data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if arrSkippedData.count <= 6{
            if isSwipeUP{
                if indexPath.row == 0 {
                    let cellHeader = tableView.dequeueReusableCell(withIdentifier: "newProductQuoteHeaderCell", for: indexPath) as! NewProductQuoteHeaderCell
                    cellHeader.lblPrice.font = UIFont(name: fontNameLight, size: fontSizeSubHeading)
                    cellHeader.lblPrice.text = CustomUserDefault.getCurrency() +  self.priceProduct
                    return cellHeader
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "questionAndAnswerCell", for: indexPath) as! QuestionAndAnswerCell
                    cell.lblQuestion.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                    cell.lblAnswer.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                    cell.lblQuestion.text = arrQuestionAndAnswerShow[indexPath.row - 1].strQuestionName
                    cell.lblAnswer.text = arrQuestionAndAnswerShow[indexPath.row - 1].strAnswerName
                    
                    return cell
                }
            }
            else{
                if indexPath.row == 0 {
                    let cellHeader = tableView.dequeueReusableCell(withIdentifier: "newProductQuoteHeaderCell", for: indexPath) as! NewProductQuoteHeaderCell
                    cellHeader.lblPrice.font = UIFont(name: fontNameLight, size: fontSizeSubHeading)
                    cellHeader.lblPrice.text = self.priceProduct
                    return cellHeader
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "questionAndAnswerCell", for: indexPath) as! QuestionAndAnswerCell
                    cell.lblQuestion.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                    cell.lblAnswer.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                    cell.lblQuestion.text = arrSkippedDataDumyQuestion[indexPath.row - 1]
                    cell.lblAnswer.text = arrSkippedDataDumyAnswer[indexPath.row - 1]
                    return cell
                }
                
            }
            
        }
        else{
            if indexPath.row == 0 {
                let cellHeader = tableView.dequeueReusableCell(withIdentifier: "newProductQuoteHeaderCell", for: indexPath) as! NewProductQuoteHeaderCell
                cellHeader.lblPrice.font = UIFont(name: fontNameLight, size: fontSizeSubHeading)
                cellHeader.lblPrice.text = self.priceProduct
                return cellHeader
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionAndAnswerCell", for: indexPath) as! QuestionAndAnswerCell
                cell.lblQuestion.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                cell.lblAnswer.font = UIFont(name: fontNameRegular, size: fontSizeSubHeadingListing)
                cell.lblQuestion.text = arrQuestionAndAnswerShow[indexPath.row - 1].strQuestionName
                cell.lblAnswer.text = arrQuestionAndAnswerShow[indexPath.row - 1].strAnswerName
                
                return cell
            }
        }
        
        
        
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSkippedData.count <= 6{
            if isSwipeUP{
                return arrQuestionAndAnswerShow.count + 1

            }
            else{
                return arrSkippedDataDumyAnswer.count + 1
            }
            
        }
        else{
            return arrQuestionAndAnswerShow.count + 1

        }
    }
    //s.
    */
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 60
//        }
//        else{
//           return UITableViewAutomaticDimension
//        }
//    }
    
    //MARK:- gesture methods
    /*@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .up{
            print("UP")
            isSwipeUP = true
        //    self.collectionViewFailedTest.alpha = 0
            
//            self.imgProductWhenScroolUp.alpha = 0
//            self.imgProductWhenScroolUp.isHidden = false
//            self.lblPriceScroolUp.alpha = 0
//            self.lblPriceScroolUp.isHidden = false
//            self.lblProductNameWhenScroolUp.alpha = 0
//            self.lblProductNameWhenScroolUp.isHidden = false
//            self.lblPriceTitleScroolup.alpha = 0
//            self.lblPriceTitleScroolup.isHidden = false
            
                UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    if UIScreen.main.bounds.size.height <= 568{
                        self.viewBGForShadow.frame.origin.y -= self.viewTop.frame.height * 0.68

                    }
                    else if UIScreen.main.bounds.size.height >= 736{
                        self.viewBGForShadow.frame.origin.y -= self.viewTop.frame.height * 0.74
                    }
                    else{
                        self.viewBGForShadow.frame.origin.y -= self.viewTop.frame.height * 0.72
                    }

                    //self.viewBGForShadow.frame.origin.y -= 100
                   // self.tblViewTop.constant = self.viewTop.frame.origin.y
                    self.swipeUpAndDown.direction = .down
                    self.imgSwipe.image = UIImage(named: "swipeDown")
                    self.tableView.isUserInteractionEnabled = true
                    self.collectionViewFailedTest.isHidden = true
                    self.tableView.reloadData()
                    UIView.animate(withDuration: 1.0) {
                        if self.isComingFromOnPhoneDiagnostic{
                            if self.arrSkippedData.count == 0{
                                if UIScreen.main.bounds.size.height <= 568{
                                    self.imgScroolProductTopConstraint.constant = -28

                                }
                                else{
                                    if self.lblDiagnosticPending.text == "Fully Functional"{
                                        if UIScreen.main.bounds.size.height >= 736{
                                            self.imgScroolProductTopConstraint.constant = -8

                                        }
                                        else{
                                            self.imgScroolProductTopConstraint.constant = -28

                                        }
                                    }
                                    else{
                                        self.imgScroolProductTopConstraint.constant = 8

                                    }

                                }
                            }
                            else{
                                 if UIScreen.main.bounds.size.height >= 736{
                                    if UIScreen.main.bounds.size.height == 896{
                                        self.imgScroolProductTopConstraint.constant = 40

                                    }
                                    else{
                                    self.imgScroolProductTopConstraint.constant = 75
                                    }

                                }

                            }
                            self.tableView.alpha = 1.0
                            self.imgProductWhenScroolUp.alpha = 1.0
                            self.lblPriceScroolUp.alpha = 1.0
                            self.lblProductNameWhenScroolUp.alpha = 1.0
                            self.lblPriceTitleScroolup.alpha = 1.0
                            self.collectionViewFailedTest.alpha = 0.0
                            self.lblCollectionviewTitle.alpha = 0.0

                            self.lblCollectionviewTitle.isHidden = true

                            
                            self.collectionViewFailedTest.isHidden = true
                            self.imgProductWhenScroolUp.isHidden = false
                            self.lblPriceScroolUp.isHidden = false
                            self.lblProductNameWhenScroolUp.isHidden = false
                            self.lblPriceTitleScroolup.isHidden = false
                         
                        }
                        else{
                                self.tableView.alpha = 1.0
                                self.imgProductWhenScroolUp.alpha = 1.0
                                self.lblPriceScroolUp.alpha = 1.0
                                self.lblProductNameWhenScroolUp.alpha = 1.0
                                self.lblPriceTitleScroolup.alpha = 1.0
                                self.btnSendAppLink.alpha = 0.0
                                self.lblCompleteDignosisTile.alpha = 0.0
                            
                            self.lblOtherDEviceName.isHidden = true
                                self.lblCompleteDignosisTile.isHidden = true
                                self.collectionViewFailedTest.isHidden = true
                                self.imgProductWhenScroolUp.isHidden = false
                                self.lblPriceScroolUp.isHidden = false
                                self.lblProductNameWhenScroolUp.isHidden = false
                                self.lblPriceTitleScroolup.isHidden = false

                        }
                      
                    }
                    
                }) { (_) in
                    // Follow up animations...
      
                }
           
        }
        else if gesture.direction == .down{
            
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.viewBGForShadow.frame.origin.y = 0
               // self.tblViewTop.constant = 80
                self.swipeUpAndDown.direction = .down
                self.imgSwipe.image = UIImage(named: "swipeUp")
                self.tableView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 1.0) {
                    if self.isComingFromOnPhoneDiagnostic{
                        if self.arrSkippedData.count == 0{
                            self.imgScroolProductTopConstraint.constant = 45
                        }
                        else{
                        }
                        self.tableView.alpha = 0.4
                        self.collectionViewFailedTest.alpha = 1.0
                        self.imgProductWhenScroolUp.alpha = 0.0
                        self.lblPriceScroolUp.alpha = 0.0
                        self.lblProductNameWhenScroolUp.alpha = 0.0
                        self.lblPriceTitleScroolup.alpha = 0.0
                        self.lblCollectionviewTitle.alpha = 1.0
                        self.lblCollectionviewTitle.isHidden = false
                        self.collectionViewFailedTest.isHidden = false
                        self.imgProductWhenScroolUp.isHidden = true
                        self.lblPriceScroolUp.isHidden = true
                        self.lblProductNameWhenScroolUp.isHidden = true
                        self.lblPriceTitleScroolup.isHidden = true
                    }
                    else{
                        self.tableView.alpha = 0.4
                        self.btnSendAppLink.alpha = 1.0
                        self.imgProductWhenScroolUp.alpha = 0.0
                        self.lblPriceScroolUp.alpha = 0.0
                        self.lblProductNameWhenScroolUp.alpha = 0.0
                        self.lblPriceTitleScroolup.alpha = 0.0
                        self.lblCompleteDignosisTile.alpha = 1.0
                        self.lblCompleteDignosisTile.isHidden = false
                        self.btnSendAppLink.isHidden = false
                        self.lblOtherDEviceName.isHidden = false
                        self.imgProductWhenScroolUp.isHidden = true
                        self.lblPriceScroolUp.isHidden = true
                        self.lblProductNameWhenScroolUp.isHidden = true
                        self.lblPriceTitleScroolup.isHidden = true
                    }
                  
                }

            }) { (_) in
                // Follow up animations...
             
            }
            isSwipeUP = false
            self.swipeUpAndDown.direction = .up

            if arrQuestionAndAnswerShow.count <= 6 {
                tableView.reloadData()
            }
        }
        else{
        }
    }*/
    // MARK:- navigation bar setup.
    /*func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Price quote"
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(ProductDetailVewVC.btnBackPressedDone), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
        //Right menu
        let btnCity = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint1 = btnCity.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint1 = btnCity.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        btnCity.setImage(UIImage(named: "location"), for: .normal)
        btnCity.addTarget(self, action: #selector(ProductDetailVewVC.btnCityPressed), for: .touchUpInside)
        //BtnSearch
        //        let btnSearch = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        //        let widthConstraint2 = btnSearch.widthAnchor.constraint(equalToConstant: 25)
        //        let heightConstraint2 = btnSearch.heightAnchor.constraint(equalToConstant: 25)
        //        heightConstraint2.isActive = true
        //        widthConstraint2.isActive = true
        //        btnSearch.setImage(UIImage(named: "search"), for: .normal)
        //
        //        btnSearch.addTarget(self, action: #selector(HomeVC.btnCityPressed), for: .touchUpInside)
        //let rightBarButtonSearch = UIBarButtonItem(customView: btnSearch)
        let rightBarButtonCity = UIBarButtonItem(customView: btnCity)
        navigationItem.rightBarButtonItem = rightBarButtonCity
    }*/
        
    //MARK:- button action methods
    
    /*@IBAction func btnSendAppLinkPressed(_ sender: UIButton) {
        var isSend = false
        if (lblProductNameWhenScroolUp.text?.contains("iPhone"))!{
            isSend = false
        }
        else{
            isSend = true
        }
        let vc  = SendAppLinkPopUp()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.isAndroidPhone = isSend
        vc.getProductName = lblProductNameWhenScroolUp.text ?? ""
        self.present(vc, animated: true, completion: nil)
    }
        
    @objc func btnBackPressedDone() -> Void {
        //self.navigationController?.popViewController(animated: true)
        // Prepare the popup assets
        let title = "InstaCash"
        let message = "Are you sure you want to quit?"
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        // Create buttons
        let buttonOne = CancelButton(title: "Yes") {
            DispatchQueue.main.async() {
                obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
            }
        }
        let buttonTwo = DefaultButton(title: "No") {
            //Do Nothing
            popup.dismiss(animated: true, completion: nil)
        }
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        popup.dismiss(animated: true, completion: nil)
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Medium", size: 20)!
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 16)!
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.opacity         = 0.7
        ov.color           = .black
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    @objc func btnCityPressed() -> Void {
        DispatchQueue.main.async {
            let alertBox = UIAlertController(title: "Changing City", message:"Changing city could affect the price quote.Do you want to change city?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancel = UIAlertAction(title:"No", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                let vc  = CityVC()
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.navigationController?.present(vc, animated: true, completion: nil)
            })
            alertBox.addAction(okAction)
            alertBox.addAction(cancel)
            
            self.present(alertBox, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- daynamic view  method

    func setViewDynamically(){
        DispatchQueue.main.async {
        self.viewTop.addBottomRoundedEdge(desiredCurve: 1.15)
            let origin:CGPoint = self.imgSwipe.center
            let target:CGPoint = CGPoint(x: self.imgSwipe.center.x, y: self.imgSwipe.center.y + 8)
            let bounce = CABasicAnimation(keyPath: "position.y")
            bounce.duration = 0.5
            bounce.fromValue = origin.y
            bounce.toValue = target.y
            bounce.repeatCount = 10000
            bounce.autoreverses = true
            self.imgSwipe.layer.add(bounce, forKey: "position")
            self.viewBGForShadow.layer.shadowOffset = CGSize(width: 0, height: 5)
            self.viewBGForShadow.layer.shadowOpacity = 0.6
            self.viewBGForShadow.layer.shadowRadius = 3.0
            self.viewBGForShadow.layer.shadowColor = UIColor.lightGray.cgColor
            
            self.viewBottomForShadow.layer.shadowOffset = CGSize(width: 0, height: -4)
            self.viewBottomForShadow.layer.shadowOpacity = 0.4
            self.viewBottomForShadow.layer.shadowRadius = 2.0
            self.viewBottomForShadow.layer.shadowColor = UIColor.lightGray.cgColor
            
            self.swipeUpAndDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
            self.swipeUpAndDown.direction = UISwipeGestureRecognizerDirection.up
            self.viewTop.addGestureRecognizer(self.swipeUpAndDown)
            
//            self.swipeUpAndDownPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
//             self.viewTop.isUserInteractionEnabled = true
//            self.viewTop.addGestureRecognizer(self.swipeUpAndDownPanGesture)
            
            
        }
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
      //  self.view.bringSubview(toFront: viewDrag)
           UIView.animate(withDuration: 0.1, animations: {
        let translation = sender.translation(in: self.viewBGForShadow)
        let direction = sender.direction(in: self.viewBGForShadow)

            if direction.contains(.Up) {
                if self.viewBGForShadow.frame.maxY >= 128.0{
                    self.viewBGForShadow.center = CGPoint(x: self.viewBGForShadow.center.x, y: self.viewBGForShadow.center.y + translation.y)
                    sender.setTranslation(CGPoint.zero, in: self.viewBGForShadow)
                    
                }
                else{
                    self.imgSwipe.image = UIImage(named: "swipeDown")
                    self.tableView.isUserInteractionEnabled = true
                    self.collectionViewFailedTest.isHidden = true
                    
                    UIView.animate(withDuration: 1.0) {
                        self.imgProductWhenScroolUp.alpha = 1.0
                        self.lblPriceScroolUp.alpha = 1.0
                        self.lblProductNameWhenScroolUp.alpha = 1.0
                        self.lblPriceTitleScroolup.alpha = 1.0
                        self.collectionViewFailedTest.alpha = 0.0
                        
                        self.collectionViewFailedTest.isHidden = true
                        self.imgProductWhenScroolUp.isHidden = false
                        self.lblPriceScroolUp.isHidden = false
                        self.lblProductNameWhenScroolUp.isHidden = false
                        self.lblPriceTitleScroolup.isHidden = false
                    }
                }
            } else if direction.contains(.Down) {
                if self.viewBGForShadow.frame.maxY <= 400.0{

                 self.viewBGForShadow.center = CGPoint(x: self.viewBGForShadow.center.x, y: self.viewBGForShadow.center.y + translation.y)
                sender.setTranslation(CGPoint.zero, in: self.viewBGForShadow)
                    self.imgSwipe.image = UIImage(named: "swipeUp")
                    self.tableView.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 1.0) {
                        self.collectionViewFailedTest.alpha = 1.0
                        self.imgProductWhenScroolUp.alpha = 0.0
                        self.lblPriceScroolUp.alpha = 0.0
                        self.lblProductNameWhenScroolUp.alpha = 0.0
                        self.lblPriceTitleScroolup.alpha = 0.0
                        self.collectionViewFailedTest.isHidden = false
                        self.imgProductWhenScroolUp.isHidden = true
                        self.lblPriceScroolUp.isHidden = true
                        self.lblProductNameWhenScroolUp.isHidden = true
                        self.lblPriceTitleScroolup.isHidden = true
                    }
                }
                else{
                }
            }
            else{
            }
        })
    }*/
    
    //MARK:- collection view delegate / data source methods
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSkippedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellFailed = collectionView.dequeueReusableCell(withReuseIdentifier: "testFailedAndSkipCell", for: indexPath) as! TestFailedAndSkipCell
        
        let model = arrSkippedData[indexPath.row]
        if model.isSkipped{
            cellFailed.viewBG.backgroundColor = UIColor.init(red: 67.0/255.0, green: 139.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            cellFailed.imgTestPassOrFailed.image = UIImage(named: "skipped")
            cellFailed.lblTestPassOrFailed.text = "Skipped"
        }
        else{
            cellFailed.viewBG.backgroundColor = UIColor.init(red: 0.0/255.0, green: 127.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            cellFailed.imgTestPassOrFailed.image = UIImage(named: "testPass")
            cellFailed.lblTestPassOrFailed.text = "Passed"

        }
        cellFailed.lblTestName.text = model.strName
        cellFailed.imgTest.image = model.imgSkipped

            return cellFailed
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         if UIScreen.main.bounds.size.height >= 736 && UIScreen.main.bounds.size.height <= 812{
//            return CGSize(width: collectionView.frame.size.width/3 - 10, height:90.0)
//        }
//        else if UIScreen.main.bounds.size.height >= 812 && UIScreen.main.bounds.size.height <= 896{
//            return CGSize(width: collectionView.frame.size.width/3 - 10, height:90.0)
//
//         }
//         else if UIScreen.main.bounds.size.height >= 812 && UIScreen.main.bounds.size.height <= 896{            return CGSize(width: collectionView.frame.size.width/3 - 10, height:100.0)
//
//         }
//
//        else{
            return CGSize(width: collectionView.frame.size.width/3 - 10, height:UIScreen.main.bounds.size.height * 0.15)

      //  }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if arrSkippedData.count == 1 {
        // Make sure that the number of items is worth the computing effort.
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }


        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset


        // Make sure to remove the last item spacing or it will
        // miscalculate the actual total width.
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - UIScreen.main.bounds.size.width * 0.15


        // If the number of cells that exist take up less room than the
        // collection view width, then center the content with the appropriate insets.
        // Otherwise return the default layout inset.
        guard totalCellWidth < contentWidth else {
            return insets
        }


        // Calculate the right amount of padding to center the cells.
        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
        }
        else if arrSkippedData.count == 2{
            // Make sure that the number of items is worth the computing effort.
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
                let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
                dataSourceCount > 0 else {
                    return .zero
            }
            
            
            let cellCount = CGFloat(dataSourceCount)
            let itemSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = flowLayout.itemSize.width + itemSpacing
            var insets = flowLayout.sectionInset
            
            
            // Make sure to remove the last item spacing or it will
            // miscalculate the actual total width.
            let totalCellWidth = (cellWidth * cellCount) - itemSpacing
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right - UIScreen.main.bounds.size.width * 0.29
            
            // If the number of cells that exist take up less room than the
            // collection view width, then center the content with the appropriate insets.
            // Otherwise return the default layout inset.
            guard totalCellWidth < contentWidth else {
                return insets
            }
            
            
            // Calculate the right amount of padding to center the cells.
            let padding = (contentWidth - totalCellWidth) / 2.0
            insets.left = padding
            insets.right = padding
            return insets
        }
        else{
            return .zero

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = arrSkippedData[indexPath.row]
        if model.isSkipped{
            if model.strName == "Screen"{
                let vc  = ScreenTestingVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Rotation" {
                let vc  = RotationVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Proximity" {
                let vc  = SensorReadVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Hardware Buttons" {
                let vc  = VolumeCheckerVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                self.present(vc, animated: true, completion: nil)
                
            }
            else if model.strName == "Earphone" {
                let vc  = EarPhoneVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Charger" {
                let vc  = DeviceChargerVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Camera" {
                let vc  = CameraVC()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                
                self.present(vc, animated: true, completion: nil)
            }
            else if model.strName == "Fingerprint Scanner" {
                let vc  = FingerPrintDevice()
                vc.isComingFromProductquote = true
                vc.resultJSON = self.getReturnJson
                self.present(vc, animated: true, completion: nil)
            }
            else{
                
            }
        }
        else{
          
            
        }

    }*/

    //MARK:- button action methods
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func btnLockPricePressed(_ sender: UIButton) {
        
        let vc = PromoCodeVC()
        vc.getFinalPrice = self.priceSend
        vc.strProductName = userDefaults.value(forKey: "productName") as? String ?? ""
        vc.strProductImg = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
        vc.pickUpChargeGet = self.pickUpCharges
        vc.quatationId = quatationID //s.
        vc.isComingForPriceLock = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPlaceOrderPressed(_ sender: UIButton) {
        if isComingFromOnPhoneDiagnostic == true {
//            strPriceUpTo = strPriceUpTo?.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
//            var strPriceUpToNot = self.priceProduct.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
            
            if userDefaults.value(forKeyPath: "promoter_id") == nil {
//        if  sender.titleLabel?.text == "Place order" {
                /* //s.
            let vc = PromoCodeVC()
            vc.getFinalPrice = self.priceSend
            vc.strProductName = userDefaults.value(forKey: "productName") as? String ?? ""
            vc.strProductImg = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
            vc.pickUpChargeGet = self.pickUpCharges
            vc.quatationId = quatationID //s.
            self.navigationController?.pushViewController(vc, animated: true)
            */
                
                let vc = SellerDetailsVC()
                vc.getFinalPrice1 = self.priceSend
                vc.strProductName1 = self.deviceName
                vc.strProductImg1 = self.deviceImageUrl
                //vc.strProductName1 = userDefaults.value(forKey: "productName") as? String ?? ""
                //vc.strProductImg1 = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
                vc.pickUpChargeGet1 = self.pickUpCharges
                vc.quatationId1 = quatationID //s.
                self.navigationController?.pushViewController(vc, animated: true)
                
                
//        }
//            else{
//                let strPriceUpTo = userDefaults.value(forKey: "Product_UpToPrice") as? String
//                let vc = OrderPlacePopUp()
//                vc.strGetPrice = self.priceProduct
//                vc.delegate = self
//                vc.strGetPriceUPTO = strPriceUpTo ?? ""
//                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                self.present(vc, animated: true, completion: nil)
//        }
        }
            else{
                userDefaults.removeObject(forKey: "isPlaceOrder")
                userDefaults.setValue(true, forKey: "isPlaceOrder")
                userDefaults.set(self.priceSend, forKey: "productPriceFromAPI")
                
                if CustomUserDefault.isUserIdExit(){
                    let vc = PlaceOrderVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = LoginVC()
                    vc.iscomingFromPlaceOrder = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              
            }
        }
        else {
            
            /* //s.
            let vc = PromoCodeVC()
            vc.getFinalPrice = self.priceSend
            vc.strProductName = userDefaults.value(forKey: "productName") as? String ?? ""
            vc.strProductImg = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
            vc.pickUpChargeGet = self.pickUpCharges
            vc.quatationId = quatationID //s.
            self.navigationController?.pushViewController(vc, animated: true)
            */ //s.
            
            let vc = SellerDetailsVC()
            vc.getFinalPrice1 = self.priceSend
            vc.strProductName1 = userDefaults.value(forKey: "productName") as? String ?? ""
            vc.strProductImg1 = userDefaults.value(forKey: "otherProductDeviceImage") as? String ?? ""
            vc.pickUpChargeGet1 = self.pickUpCharges
            vc.quatationId1 = quatationID //s.
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
    
    //MARK:- webservice data
    
    func orderApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(isRefreshPrice:Bool) {
        
        if isRefreshPrice{
            //refreshActivityIndicator.startAnimating()
            self.createSkippedDataForShowData(isRefreshForData: true)
        }
        else{
            Alert.ShowProgressHud(Onview: self.view)
        }
        
        var strSourceOfQuote = ""
        var productId = ""
        var returnMetaDetails : NSMutableDictionary = [:]
        let IMEINumer = KeychainWrapper.standard.string(forKey: "UUIDValue")!
        var strPromoterId = ""
        
        if userDefaults.value(forKey: "promoter_id") == nil {
            strPromoterId = ""
        }
        else{
            strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
        }
        
        //Sameer - 28/3/20
        if userDefaults.value(forKey: "promoterID") == nil {
            strPromoterId = ""
        }
        else{
            strPromoterId = userDefaults.value(forKey: "promoterID") as! String
        }
        

        if isComingFromOnPhoneDiagnostic {
            
            strSourceOfQuote = "diagnosis"
            userDefaults.set(true, forKey: "OrderPlaceFordiagnosis")
            productId = CustomUserDefault.getProductId()
            let deviceName  = UIDevice.current.modelName  as String
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let strRam = ProcessInfo.processInfo.physicalMemory
            let bundleID = Bundle.main.bundleIdentifier!
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
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
            
            self.createReturnDictForDiagnosis()
            userDefaults.removeObject(forKey: "resturn_dictonoryFor_confirm_Order")
            userDefaults.set(returnDictionary, forKey: "resturn_dictonoryFor_confirm_Order")
        }
        else{
            userDefaults.set(false, forKey: "OrderPlaceFordiagnosis")
            strSourceOfQuote = "questions"
            productId = userDefaults.value(forKey: "otherProductDeviceID") as! String
        }
        
        // sameer on 31/3/20
        //let  userSelectedProductAppcodes =  "STON01," + strGetFinalAppCodeValues + strDiagnosisFailed
        var userSelectedProductAppcodes = ""
        if isComingFromOnPhoneDiagnostic{
            userSelectedProductAppcodes =  "STON01," + strGetFinalAppCodeValues + strDiagnosisFailed
        }
        else{
            userSelectedProductAppcodes = strGetFinalAppCodeValues + strDiagnosisFailed
        }
        
        userDefaults.removeObject(forKey: "failedDiagnosData")
        userDefaults.set(strDiagnosisFailed, forKey: "failedDiagnosData")
        
        let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
        let converComaToSemocolum = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")

        if isComingFromOnPhoneDiagnostic {
            userDefaults.removeObject(forKey: "Final_AppCodes_Diagnosis")
            userDefaults.set(converComaToSemocolum, forKey: "Final_AppCodes_Diagnosis")
            userDefaults.removeObject(forKey: "Final_AppCodes")
            userDefaults.set(converComaToSemocolum, forKey: "Final_AppCodes")
        }
        else{
            userDefaults.removeObject(forKey: "Final_AppCodes")
            userDefaults.set(converComaToSemocolum, forKey: "Final_AppCodes")
        }
        
        var userId = ""
        if CustomUserDefault.isUserIdExit(){
            userId = CustomUserDefault.getUserId()
        }
        else{
            userId = "-1"
        }
       
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "productQuote"
        let jsonData = try! JSONSerialization.data(withJSONObject: returnMetaDetails, options:[])
        var jsonStringforMetaDetails = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let jsonData1 = try! JSONSerialization.data(withJSONObject: returnDictionary, options:[])
        let jsonStringforMetaDetails1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
        
        if isComingFromOnPhoneDiagnostic{
             strSkipData = converComaToSemocolum.replacingOccurrences(of: strSkipData, with: "")
            userDefaults.removeObject(forKey: "SkipDateForConfirmOrder")
            userDefaults.set(strSkipData, forKey: "SkipDateForConfirmOrder")
        }
        else{
            jsonStringforMetaDetails = ""
        }
        
        var parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "productId":productId,
            "mobile":CustomUserDefault.getPhoneNumber() ?? "",
            "str":converComaToSemocolum,
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
            "ipAddress":"",
            "promoterId":strPromoterId
        ]
        
        if let addInfo = userDefaults.value(forKey: "additionalInfo") {
            parametersHome["additionalInformation"] = addInfo
        }
        
        print(parametersHome)
        
        self.orderApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            
            if isRefreshPrice{
                //self.refreshActivityIndicator.stopAnimating()
            }
            else{
                Alert.HideProgressHud(Onview: self.view)
            }
            
            print("\(String(describing: responseObject) ) , \(String(describing: error))")
            print(responseObject ?? [:])

            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    // self.viewMain.isHidden = false
                    //self.viewBottomForShadow.isHidden = false
                    
                    //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                    
                    if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                        self.btnPlaceOrder.isHidden = false
                    }
                    else{
                        self.btnLockPrice.isHidden = true
                    }
                    self.btnPlaceOrder.isHidden = false
                    //self.btnEdit.isHidden = true
                    //self.lblCouponPrice.isHidden = true
                    //self.lblCoupnTitle.isHidden = true
                   // self.btnApply.isHidden = true
                    
                    let amount = (responseObject?["totalPromoterAmount"] as! Int)
                  //  let amount = Int(price1)
                    self.priceSend = amount
                    let strFinalAmount = amount.formattedWithSeparator
                    self.priceProduct = CustomUserDefault.getCurrency() + strFinalAmount
                    self.pickUpCharges = responseObject?["pickupCharges"] as! Int
                    userDefaults.setValue(self.pickUpCharges, forKey: "pickupCharges")
                  //  self.lblPickUpCharges.text = CustomUserDefault.getCurrency() + "-" + "\(chareges)"
                   // self.lblCity.text = CustomUserDefault.getCityName()
                    let price = Int(responseObject?["totalPromoterAmount"] as! Int)
                    
                    self.quatationID = String(responseObject?["quotationId"] as? String ?? "")
                    
                    //let finalPrice = price! - chareges
                    //self.productPrice = finalPrice
                    //self.lblPriceScroolUp.text = CustomUserDefault.getCurrency() + price!.formattedWithSeparator //"\(finalPrice)"
                    
                    self.lblPrice.text = CustomUserDefault.getCurrency() + price.formattedWithSeparator
                    
                    //s.
                    let finalSummaryText = responseObject?["summaryText"] as! String
                    let arrSummaryString : [String?] = finalSummaryText.components(separatedBy: ";")
                    
                    for item in arrSummaryString {
                        //if item != "Original Charger" && item != " faulty Or cracked sound" && item != "" {
                        
                        if item != "" {
                            let arrStr1 : [String?] = item?.components(separatedBy: "->") ?? [""]
                            
                            if arrStr1.count > 1 {
                                
                                if arrStr1[0] == "Select the available accessories" || arrStr1[0] == "Select the available original accessories" {
                                    // IN Case .........
                                    
                                    var completeString = ""
                                    
                                    if finalSummaryText.contains("Earphone;") {
                                        completeString = "Earphone".localized(lang: langCode)
                                    }
                                    
                                    if finalSummaryText.contains("Box;") {
                                        if completeString == "" {
                                            completeString = completeString + "Box".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nBox"
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Original Charger;") {
                                        if completeString == "" {
                                            completeString = completeString + "Original Charger".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nOriginal Charger"
                                        }
                                    }
                                    
                                    self.arrKey.append(arrStr1[0] ?? "")
                                    //self.arrValue.append(arrStr1[1] ?? "")
                                    self.arrValue.append(completeString)
                                    
                                }else if arrStr1[0] == "Device Condition" {
                                    // MY & SG Case .........
                                    
                                    var completeString = ""
                                    
                                    if finalSummaryText.contains("Bloated Battery;") {
                                        completeString = "Bloated Battery".localized(lang: langCode)
                                    }
                                    
                                    if finalSummaryText.contains("Liquid Damage;") {
                                        if completeString == "" {
                                            completeString = completeString + "Liquid Damage".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nLiquid Damage"
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Ghost Touch;") {
                                        if completeString == "" {
                                            completeString = completeString + "Ghost Touch".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nGhost Touch"
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Sim Card Tray Broken;") {
                                        if completeString == "" {
                                            completeString = completeString + "Sim Card Tray Broken".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nSim Card Tray Broken"
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Home and Power Button;") {
                                        if completeString == "" {
                                            completeString = completeString + "Home and Power Button".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nHome and Power Button"
                                        }
                                    }
                                    
                                    self.arrKey.append(arrStr1[0] ?? "")
                                    //self.arrValue.append(arrStr1[1] ?? "")
                                    self.arrValue.append(completeString)
                                
                                }else if arrStr1[0] == "Select the functional issues of your device" {
                                    // IN Case .........
                                    
                                    var completeString = ""
                                    
                                    if finalSummaryText.contains("Front Or Back Camera - Not working or faulty;") {
                                        completeString = "Front Or Back Camera - Not working or faulty".localized(lang: langCode)
                                    }
                                    
                                    if finalSummaryText.contains("Volume Button not working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Volume Button not working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nVolume Button not working"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Power/Home Button Faulty;") {
                                        if completeString == "" {
                                            completeString = completeString + "Power/Home Button Faulty".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nPower/Home Button Faulty"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Hard or Not Working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Hard or Not Working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nHard or Not Working"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Wifi Or Bluetooth Or GPS Not Working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Wifi Or Bluetooth Or GPS Not Working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nWifi Or Bluetooth Or GPS Not Working"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Charging Defect;") {
                                        if completeString == "" {
                                            completeString = completeString + "Charging Defect".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nCharging Defect"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("unable to charge the phone;") {
                                        if completeString == "" {
                                            completeString = completeString + "unable to charge the phone".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nunable to charge the phone"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Battery Faulty or Very Low Battery Back up;") {
                                        if completeString == "" {
                                            completeString = completeString + "Battery Faulty or Very Low Battery Back up".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nBattery Faulty or Very Low Battery Back up"
                                            
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Speakers not working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Speakers not working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nSpeakers not working"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("faulty Or cracked sound;") {
                                        if completeString == "" {
                                            completeString = completeString + "faulty Or cracked sound".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nfaulty Or cracked sound"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Microphone Not Working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Microphone Not Working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nMicrophone Not Working"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("GSM (Call Function) is not-working normally;") {
                                        if completeString == "" {
                                            completeString = completeString + "GSM (Call Function) is not-working normally".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nGSM (Call Function) is not-working normally"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Earphone Jack is damaged or not-working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Earphone Jack is damaged or not-working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nEarphone Jack is damaged or not-working"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    if finalSummaryText.contains("Fingerprint Sensor Not-working;") {
                                        if completeString == "" {
                                            completeString = completeString + "Fingerprint Sensor Not-working".localized(lang: langCode)
                                        }else {
                                            completeString = completeString + "\nFingerprint Sensor Not-working"
                                            self.increaseHeight += 1
                                        }
                                    }
                                    
                                    self.arrKey.append(arrStr1[0] ?? "")
                                    //self.arrValue.append(arrStr1[1] ?? "")
                                    self.arrValue.append(completeString)
                                    
                                }
                                
                                else {
                                    self.arrKey.append(arrStr1[0] ?? "")
                                    self.arrValue.append(arrStr1[1] ?? "")
                                }
                                
                            }
                        }
                        
                        /*
                        if item != "" {
                            let arrStr1 : [String?] = item?.components(separatedBy: "->") ?? [""]
                            
                            if arrStr1.count > 1 {
                                self.arrKey.append(arrStr1[0] ?? "")
                                self.arrValue.append(arrStr1[1] ?? "")
                            }
                        }*/
                        
                    }
               
                    let imgURL = URL.init(string: self.deviceImageUrl)
                    self.imgProduct.sd_setImage(with: imgURL)
                    self.lblProductName.text = self.deviceName
                    
                    self.tableView.contentSize = CGSize(width: self.tableView.frame.width, height: ((CGFloat(self.arrKey.count)) * 50))
                    //self.heightOftbl.constant = (CGFloat(self.arrKey.count) * 50) + 40
                    self.heightOftbl.constant = (CGFloat(self.arrKey.count + self.increaseHeight) * 50) + 40
                    self.tableView.reloadData()
                    
                    //s.
                    
                    if self.isComingFromOnPhoneDiagnostic {
                        if userDefaults.value(forKeyPath: "promoter_id") == nil{
                            userDefaults.setValue(true, forKey: "isShowUIOnHomeForOrder")
                        }
                        else{
                            userDefaults.setValue(false, forKey: "isShowUIOnHomeForOrder")
                        }
                        
                        // save date for show confirm UI in home controller
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy"
                        let result = formatter.string(from: date)
                        userDefaults.setValue(result, forKey: "priceDate_quote")


                        let strPriceQuote = responseObject?["skipQuote"] as! String
                        let bumPerPrice = responseObject?["bumpupAmount"] as! Int
                        let priceSkip = Int(strPriceQuote)! + bumPerPrice
                        userDefaults.setValue(strPriceQuote, forKey: "Product_UpToPrice")
                        let priceSave =  responseObject?["totalPromoterAmount"] as! Int
                        let finalPriceSave = String(priceSave)
                        userDefaults.removeObject(forKey: "Product_UpToOffer")
                        userDefaults.setValue(finalPriceSave, forKey: "Product_UpToOffer")

                        let priceSkipQuote = priceSkip.formattedWithSeparator
                        if strPriceQuote == (responseObject?["msg"] as! String){
                            let priceF = "Place order"
                            self.btnPlaceOrder.setTitle(priceF, for: .normal)
                            //self.lblPlaceOrderNote.isHidden = true
                            //self.imgNoteWarning.isHidden = true
                        }
                        else{
                            let priceF = "Place order @ ".localized(lang: langCode) + CustomUserDefault.getCurrency() + price.formattedWithSeparator
                            self.btnPlaceOrder.setTitle(priceF, for: .normal)
                        }
                        
                        self.lblPrice.text = CustomUserDefault.getCurrency() + priceSkipQuote
                        //self.lblPriceScroolUp.text = CustomUserDefault.getCurrency() + priceSkipQuote
                        let myString = "Note:- your Quote is lower than ".localized(lang: langCode) + CustomUserDefault.getCurrency() + priceSkipQuote + " because certain tests were failed or skipped".localized(lang: langCode)
                        //  let attrString = NSAttributedString(string: myString)
                        let attribute = NSMutableAttributedString.init(string: myString)
                        let strCount = CustomUserDefault.getCurrency() + priceSkipQuote
                        let myRange = NSRange(location: 32, length: (strCount.count))
                        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange , range: myRange)
                        //self.lblPlaceOrderNote.attributedText = attribute
                        
//                        let priceF = "Place order @ " + CustomUserDefault.getCurrency() + price!.formattedWithSeparator
//                        self.btnPlaceOrder.setTitle(priceF, for: .normal)
                        
                    }
                     else{
                        self.lblPrice.text = CustomUserDefault.getCurrency() + strFinalAmount
                        //self.lblPriceScroolUp.text = CustomUserDefault.getCurrency() + strFinalAmount
                    }
                    
                    userDefaults.setValue(responseObject?["diagnosisId"] as? NSString, forKey: "diagnosisId")
                    
                    /*
                    if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                        userDefaults.setValue(responseObject?["diagnosisId"] as? NSString, forKey: "diagnosisId")
                    }else if CustomUserDefault.getCurrency() == "RM" {
                        userDefaults.setValue(responseObject?["diagnosisId"] as? NSString, forKey: "diagnosisId")
                    }else {
                        userDefaults.setValue(responseObject?["diagnosisId"] as? Int64, forKey: "diagnosisId")
                    }*/
                    
                }
                else{
                    // failed
                    Alert.showAlert(strMessage: "oops,No data found".localized(lang: langCode) as NSString, Onview: self)
                }
                
            }
            else{
                debugPrint(error as Any)
                Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        
    }
    
    func createReturnDictForDiagnosis(){
        
        strDiagnosisFailed = ""
        if getReturnJson["Screen"].int == 1{
            returnDictionary.setValue("1", forKey: "Screen")
            //returnDictionary = ["Screen":"1"]
            
        }
        else{
            //returnDictionary = ["Screen":"-1"]
            returnDictionary.setValue("-1", forKey: "Screen")
            strDiagnosisFailed = "SBRK01,"
        }
        
        
        if getReturnJson["Rotation"].int == 1{
            // returnDictionary = ["Rotation":"1"]
            returnDictionary.setValue("1", forKey: "Rotation")
            
        }
        else{
            //returnDictionary = ["Rotation":"-1"]
            returnDictionary.setValue("-1", forKey: "Rotation")
            
        }
        
        if getReturnJson["Proximity"].int == 1{
            //returnDictionary = ["Proximity":"1"]
            returnDictionary.setValue("1", forKey: "Proximity")
            
        }
        else{
            //returnDictionary = ["Proximity":"-1"]
            returnDictionary.setValue("-1", forKey: "Proximity")
            
        }
        
        
        if getReturnJson["Hardware Buttons"].int == 1{
            //returnDictionary = ["Hardware Buttons":"1"]
            returnDictionary.setValue("1", forKey: "Hardware Buttons")
            
        }
        else{
            //returnDictionary = ["Hardware Buttons":"-1"]
            returnDictionary.setValue("-1", forKey: "Hardware Buttons")
            strDiagnosisFailed = strDiagnosisFailed + "CISS02,"
            
        }
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if getReturnJson["Earphone"].int == 1{
                returnDictionary.setValue("1", forKey: "Earphone")
                
                // returnDictionary = ["Earphone":"1"]
            }
            else{
                // returnDictionary = ["Earphone":"-1"]
                returnDictionary.setValue("-1", forKey: "Earphone")
                strDiagnosisFailed = strDiagnosisFailed + "CISS11,"
                
            }
            
            if getReturnJson["USB"].int == 1{
                //returnDictionary = ["USB":"1"]
                returnDictionary.setValue("1", forKey: "USB")
                
            }
            else{
                //returnDictionary = ["USB":"-1"]
                returnDictionary.setValue("-1", forKey: "USB")
                strDiagnosisFailed = strDiagnosisFailed + "CISS05,"
                
                
            }
        }
        if getReturnJson["Camera"].int == 1{
            //returnDictionary = ["Camera":"1"]
            returnDictionary.setValue("1", forKey: "Camera")
        }
        else{
            //returnDictionary = ["Camera":"-1"]
            returnDictionary.setValue("-1", forKey: "Camera")
            strDiagnosisFailed = strDiagnosisFailed + "CISS01,"
        }
        if getReturnJson["Fingerprint Scanner"].int == 1{
            // returnDictionary = ["Fingerprint Scanner":"1"]
            returnDictionary.setValue("1", forKey: "Fingerprint Scanner")
        }
        else if  getReturnJson["Fingerprint Scanner"].int == -1{
            // returnDictionary = ["Fingerprint Scanner":"1"]
            returnDictionary.setValue("-1", forKey: "Fingerprint Scanner")
            strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
        }
        else if  getReturnJson["Fingerprint Scanner"].int == -2{
            // returnDictionary = ["Fingerprint Scanner":"1"]
          //  strDiagnosisFailed = strDiagnosisFailed + ""
            returnDictionary.setValue("-2", forKey: "Fingerprint Scanner")
        }
        else{
            // returnDictionary = ["Fingerprint Scanner":"-1"]
            returnDictionary.setValue("0", forKey: "Fingerprint Scanner")
            strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
            
        }
        if getReturnJson["WIFI"].int == 1 && getReturnJson["GPS"].int == 1 && getReturnJson["Bluetooth"].int == 1{
        }
        else{
            strDiagnosisFailed  = strDiagnosisFailed + "CISS04,"
        }
        
        if getReturnJson["WIFI"].int == 1{
            //  returnDictionary = ["WIFI":"1"]
            returnDictionary.setValue("1", forKey: "WIFI")
        }
        else{
            //returnDictionary = ["WIFI":"0"]
            returnDictionary.setValue("0", forKey: "WIFI")
            
        }
        if getReturnJson["GSM"].int == 1{
            //returnDictionary = ["GSM":"1"]
            returnDictionary.setValue("1", forKey: "GSM")
            
        }
        else{
            // returnDictionary = ["GSM":"0"]
            returnDictionary.setValue("0", forKey: "GSM")
            
        }
        if getReturnJson["GPS"].int == 1{
            //returnDictionary = ["GPS":"1"]
            returnDictionary.setValue("1", forKey: "GPS")
            
        }
        else{
            // returnDictionary = ["GPS":"0"]
            returnDictionary.setValue("0", forKey: "GPS")
            
        }
        if getReturnJson["Bluetooth"].int == 1{
            //returnDictionary = ["Bluetooth":"1"]
            returnDictionary.setValue("1", forKey: "Bluetooth")
            
        }
        else{
            //returnDictionary = ["Bluetooth":"0"]
            returnDictionary.setValue("0", forKey: "Bluetooth")
            
        }
        if UIDevice.current.modelName == "iPhone 4" ||  UIDevice.current.modelName == "iPhone 4s" ||  UIDevice.current.modelName == "iPhone 5" ||  UIDevice.current.modelName == "iPhone 5c" ||  UIDevice.current.modelName == "iPhone 5s"
        {
            //returnDictionary = ["NFC":"1"]
            returnDictionary.setValue("-2", forKey: "NFC")
        }
        else{
            //   returnDictionary = ["NFC":"0"]
            returnDictionary.setValue("1", forKey: "NFC")
        }
        
        returnDictionary.setValue("1", forKey: "SMS verification")
        returnDictionary.setValue("1", forKey: "Storage")
        returnDictionary.setValue("1", forKey: "Torch")
        returnDictionary.setValue("1", forKey: "Vibrator")
        returnDictionary.setValue("1", forKey: "MIC")
        returnDictionary.setValue("1", forKey: "Autofocus")
        
        
        //        returnDictionary = [
        //            "SMS verification":"1",
        //            "Storage":"1",
        //            "Torch":"1",
        //            "Vibrator":"1",
        //            "MIC":"1",
        //            "Autofocus":"1"
        //        ]
        
        
        
        //  "Speaker"
        // "Microphone"
    }
    
//    //MARK: scroolview delegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        viewTopHeightConstraint.constant = 440 - scrollView.contentOffset.y
//        imgProduct.alpha = 1.0 - (scrollView.contentOffset.y/200)
//        if scrollView.contentOffset.y < 0 {
//           // imageViewCustom.contentMode = .scaleAspectFill
//        }else{
//          //  imageViewCustom.contentMode = .scaleAspectFit
//        }
//    }

    
/*}
extension UIView {
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
//    //top curve
//        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height/2  , width:  bounds.size.width, height: bounds.size.height / 2)
//        let rectPath = UIBezierPath(rect: rectBounds)
//        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
//        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
//        rectPath.append(ovalPath)
        
        // bottom curve
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        rectPath.fill()

        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        ovalPath.fill()
        rectPath.append(ovalPath)
        
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
       // maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer

        
//        self.layer.mask?.masksToBounds = false
//        self.layer.mask?.shadowColor = UIColor.black.cgColor
//        self.layer.mask?.shadowOffset = CGSize(width: 0, height: 1)
//        self.layer.mask?.shadowOpacity = 0.45
//        self.layer.mask?.shadowPath = UIBezierPath(rect: bounds).cgPath
//        self.layer.mask?.shadowRadius = 1.0
  

    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
}
extension UIPanGestureRecognizer {
    
    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        static let Up = PanGestureDirection(rawValue: 1 << 0)
        static let Down = PanGestureDirection(rawValue: 1 << 1)
        static let Left = PanGestureDirection(rawValue: 1 << 2)
        static let Right = PanGestureDirection(rawValue: 1 << 3)
    }
    
    private func getDirectionBy(velocity: CGFloat, greater: PanGestureDirection, lower: PanGestureDirection) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }
    
    public func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(velocity: velocity.y, greater: PanGestureDirection.Down, lower: PanGestureDirection.Up)
        let xDirection = getDirectionBy(velocity: velocity.x, greater: PanGestureDirection.Right, lower: PanGestureDirection.Left)
        return xDirection.union(yDirection)
    }*/
    
    //MARK:- tableview Delegates methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Product Details".localized(lang: langCode)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTestResult = tableView.dequeueReusableCell(withIdentifier: "ProductSummaryTblViewCell", for: indexPath) as! ProductSummaryTblViewCell
        cellTestResult.lblQuateName.text = arrKey[indexPath.row].localized(lang: langCode)
        cellTestResult.lblQuateValue.text = arrValue[indexPath.row].localized(lang: langCode)
        
        return cellTestResult
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
