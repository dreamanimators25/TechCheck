//
//  PromoCodeVC.swift
//  InstaCash
//
//  Created by InstaCash on 31/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.

import UIKit
import Firebase
import FacebookCore

class PromoCodeVC: UIViewController,UpdateUIForOrderDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var viewPromoApplied: cornerView!
    @IBOutlet weak var viewPromo: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var promoCodeView: UIView!

    //@IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var txtPromocode: UITextField!
    @IBOutlet weak var lblFinalPrice: UILabel!
    @IBOutlet weak var lblPromoOfferPrice: UILabel!
    @IBOutlet weak var lblLogisticCharges: UILabel!
    @IBOutlet weak var lblDeviceWorth: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var txtAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var NssImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stkView1: UIView!
    @IBOutlet weak var stkView2: UIView!
    @IBOutlet weak var stkViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblTitleSummary: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblPickUpCharge: UILabel!
    @IBOutlet weak var lblPromoOffer: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnPromoCode: UIButton!
    @IBOutlet weak var lblDonateDest: UILabel!
    @IBOutlet weak var btnChangeAmount: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    
    
    var getFinalPrice = 0
    var pickUpChargeGet = 0
    var finalPriceSet = 0
    var strProductName = ""
    var strProductImg = ""
    let reachability: Reachability? = Reachability()
    var quatationId = String() //s.
    var donateAmount = 0
    var Donation = 0
    var userDetails = [String:Any]() //s.
    var isComingForPriceLock = false
    @IBOutlet weak var activityIndicatorePromoCode: UIActivityIndicatorView!
    
    func reSetDiagnosHomeUIProcessForMaintainCache(){
        
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
        reSetDiagnosHomeUIProcessForMaintainCache()
        userDefaults.set(0, forKey: "couponCodePrice")
        setNavigationBar()
//        btnRemove.layer.cornerRadius = CGFloat(btnCornerRadius)
//        btnRemove.clipsToBounds = true
//        btnRemove.layer.borderWidth = 1.0
//        btnRemove.layer.borderColor = UIColor.red.cgColor
        //btnNext.layer.cornerRadius = CGFloat(btnCornerRadius)
        //btnNext.clipsToBounds = true
        btnApply.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnApply.clipsToBounds = true

        lblDeviceWorth.text = CustomUserDefault.getCurrency() + getFinalPrice.formattedWithSeparator
        //lblFinalPrice.text = CustomUserDefault.getCurrency() + finalPriceSet.formattedWithSeparator //s.
        //lblLogisticCharges.text = "-" + CustomUserDefault.getCurrency() + pickUpChargeGet.formattedWithSeparator //s.
        lblLogisticCharges.text = "-" + CustomUserDefault.getCurrency() + pickUpChargeGet.formattedWithSeparator //s.
        
        let finlaAmount = Int(getFinalPrice - pickUpChargeGet) //s.
        lblFinalPrice.text = CustomUserDefault.getCurrency() + finlaAmount.formattedWithSeparator //s.
        
        //finalPriceSet = getFinalPrice - 30 //s.
        finalPriceSet = getFinalPrice - pickUpChargeGet //s.
        
        let amount = getFinalPrice
        let rounded = amount/100 * 100
        print(rounded)
        let discount = rounded/100
        donateAmount = discount
        Donation = discount
        
        
        DispatchQueue.main.async {
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.lblDonateDest.text = "I want to donate ₹".localized(lang: langCode) + " \(self.Donation) " + "to Narayan Seva Sansthan.".localized(lang: langCode)
                self.NssImageViewHeight.constant = 80.0
                self.stkView1.isHidden = false
                //self.stkView2.isHidden = true
                //self.stkViewHeightConstraint.constant = 45.0
                self.stkViewHeightConstraint.constant = 90.0
                
            }else {
                
                self.donateAmount = 100
                self.Donation = 100
                
                self.lblDonateDest.text = "I want to donate".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) \(self.Donation)" + "to World Wide Fund for Nature.".localized(lang: langCode)
                self.NssImageViewHeight.constant = 0.0
                self.stkView1.isHidden = false
                //self.stkView2.isHidden = true
                self.stkViewHeightConstraint.constant = 45.0
                
                if self.donateAmount > amount {
                    self.stkView1.isHidden = true
                    self.stkView2.isHidden = true
                    self.stkViewHeightConstraint.constant = 0.0
                    self.donateAmount = 0
                }else {
                    self.stkView1.isHidden = false
                    //self.stkView2.isHidden = true
                    //self.stkViewHeightConstraint.constant = 45.0
                    self.stkViewHeightConstraint.constant = 90.0
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            UIView.addShadowOn4side(baseView: self.viewBG)
            self.promoCodeView.layer.cornerRadius = 5.0
            self.btnPromoCode.layer.cornerRadius = 5.0
        }
        
        txtAmount.delegate = self
        
        //Sameer - 28/3/20
        if userDefaults.value(forKey: "promotionCouponCode") != nil {
            self.applyPromoCode()
        }
        
        self.changeLanguageOfUI()
        
    }
    
    func changeLanguageOfUI() {
   
        self.lblTitleSummary.text = "Summary".localized(lang: langCode)
        self.lblSummary.text = "Summary".localized(lang: langCode)
        self.lblSubTotal.text = "Subtotal Amount".localized(lang: langCode)
        self.lblPickUpCharge.text = "Pickup Charge".localized(lang: langCode)
        self.lblPromoOffer.text = "Promo offer".localized(lang: langCode)
        self.lblTotal.text = "Total".localized(lang: langCode)
        self.btnPromoCode.setTitle("Have a promo code? Click here.".localized(lang: langCode), for: UIControlState.normal)
        self.lblDonateDest.text = "I want to donate ₹ 30 to Narayan Sewa Sansthan.".localized(lang: langCode)
        self.btnChangeAmount.setTitle("Change Amount".localized(lang: langCode), for: UIControlState.normal)
        self.txtAmount.placeholder = "Enter Amount".localized(lang: langCode)
        self.btnNext.setTitle("NEXT".localized(lang: langCode), for: UIControlState.normal)
        self.lblPleaseEnter.text = "Please enter promo code".localized(lang: langCode)
        self.btnRemove.setTitle("CANCEL".localized(lang: langCode), for: UIControlState.normal)
        self.btnApply.setTitle("APPLY".localized(lang: langCode), for: UIControlState.normal)
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "InstaCash".localized(lang: langCode)
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(PromoCodeVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtAmount {
            //donateAmount = Int(txtAmount.text!) ?? 0
            
            if (txtAmount.text?.isEmpty)!{
                //lblDonateDest.text = "I want to donate ₹ \(Donation) to Narayan Sewa Sansthan."
                
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    
                    lblDonateDest.text =  "I want to donate ₹".localized(lang: langCode) + " \(self.Donation) " + "to Narayan Seva Sansthan.".localized(lang: langCode)
                    
                }else {

                    lblDonateDest.text = "I want to donate".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) \(self.Donation)" + "to World Wide Fund for Nature.".localized(lang: langCode)
                }
                
                donateAmount = Donation
            }
            else {
                //lblDonateDest.text = "I want to donate ₹ \(txtAmount.text ?? "0") to Narayan Sewa Sansthan."
                
                if Int(txtAmount.text!) ?? 0 > finalPriceSet {
                    Alert.showAlert(strMessage: "Please Enter Valid Amount".localized(lang: langCode) as NSString, Onview: self)
                    return
                }else {
                    donateAmount = Int(txtAmount.text!) ?? 0
                }
                
                
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    
                    lblDonateDest.text = "I want to donate ₹".localized(lang: langCode) + " \(txtAmount.text ?? "0") " + "to Narayan Seva Sansthan.".localized(lang: langCode)
                    //lblDonateDest.text = "I want to donate ₹ \(txtAmount.text ?? "0") to Narayan Seva Sansthan."
                    
                }else {
                    lblDonateDest.text = "I want to donate".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) \(txtAmount.text ?? "0")" + "to World Wide Fund for Nature.".localized(lang: langCode)
                    //lblDonateDest.text = "I want to donate \(CustomUserDefault.getCurrency()) \(txtAmount.text ?? "0") to World Wide Fund for Nature."
                }
                
                
                //donateAmount = Int(txtAmount.text!) ?? 0
            }
        }
    }
    
    //MARK:- buttons methods
    //s.
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            print(btnCheckBox.isSelected)
            //finalPriceSet = finalPriceSet - 30
            //btnChangeHeight.constant = 35
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                stkView2.isHidden = false
                stkViewHeightConstraint.constant = 90.0
                
            }else {
                //stkView2.isHidden = true
                //stkViewHeightConstraint.constant = 45.0
                stkViewHeightConstraint.constant = 90.0
            }
            
            DispatchQueue.main.async {
                sender.setImage(UIImage.init(named: "testPass"), for: .normal)
            }
            
            donateAmount = donateAmount + Donation
            print(donateAmount)
            
            //lblDonateDest.text = "I want to donate ₹ \(donateAmount) to Narayan Sewa Sansthan."
            //lblDonateDest.text = "I want to donate ₹ \(Donation) to Narayan Sewa Sansthan."
            
        }else {
            sender.isSelected = !sender.isSelected
            print(btnCheckBox.isSelected)
            //finalPriceSet = finalPriceSet + 30
            //btnChangeHeight.constant = 0
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                //stkView2.isHidden = true
                //stkViewHeightConstraint.constant = 45.0
                stkViewHeightConstraint.constant = 90.0
                
            }else {
                //stkView2.isHidden = true
                //stkViewHeightConstraint.constant = 45.0
                stkViewHeightConstraint.constant = 90.0
            }
            
            txtAmountHeight.constant = 0
            DispatchQueue.main.async {
                sender.setImage(UIImage.init(named: "unchk"), for: .normal)
            }
            
            donateAmount = 0
            print(donateAmount)
            
            //lblDonateDest.text = "I want to donate ₹ \(donateAmount) to Narayan Sewa Sansthan."
            //lblDonateDest.text = "I want to donate ₹ \(Donation) to Narayan Sewa Sansthan."
        }
        
    }
    
    //s.
    @IBAction func onClickChangeAmount(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            txtAmountHeight.constant = 0
        }else {
            sender.isSelected = !sender.isSelected
            txtAmountHeight.constant = 35
        }
        
    }
    
    //s.
    @IBAction func onClickNext(_ sender: UIButton) {
        
        let vc = PaymentsModeVC()
        
        vc.strProductImg3 = self.strProductImg
        vc.strProductName3 = self.strProductName
        //vc.getFinalPrice3 = self.getFinalPrice
        vc.getFinalPrice3 = self.finalPriceSet - self.donateAmount
        vc.donationMoney = String(self.donateAmount)
        vc.pickUpChargeGet3 = self.pickUpChargeGet
        vc.quatationId3 = self.quatationId
        vc.userDetails3 = self.userDetails
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickNEFTTransfer(_ sender: Any) {
        
        let vc = BankTransfer()
//        vc.QuatID = self.quatationId
//        vc.userDetail = self.userDetails
//        vc.selectedPaymentType = "NEFT"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickIMPSTransfer(_ sender: Any) {
        
        let vc = BankTransfer()
//        vc.QuatID = self.quatationId
//        vc.userDetail = self.userDetails
//        vc.selectedPaymentType = "IMPS"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickDonation(_ sender: Any) {
        
        let vc = Wallet()
        vc.QuatID = quatationId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickPaytm(_ sender: Any) {
        
        let vc = Voucher()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
   @objc func btnBackPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextPressed(_ sender: UIButton) {
        
        if isComingForPriceLock {
            let vc  = LockPricePopUp()
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else {
         
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
        var productName = ""
        var producdID = ""
        if userDefaults.value(forKey: "productName") != nil{
            productName = userDefaults.value(forKey: "productName") as? String ?? ""
        }
        else{
            productName = ""
        }
        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
        }
        else{
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
        }
        AppEventsLogger.log(
            .addedToCart(
                contentType: productName,
                contentId: producdID,
                currency: currency))
        
        Analytics.logEvent(AnalyticsEventAddToCart, parameters: [
            AnalyticsParameterItemID: producdID,
            AnalyticsParameterItemName: productName,
            AnalyticsParameterCurrency:currency
            ])
        
        
            if CustomUserDefault.isUserIdExit(){
                let vc = PlaceOrderVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = LoginVC()
                vc.iscomingFromPlaceOrder = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            userDefaults.removeObject(forKey: "isPlaceOrder")
            userDefaults.setValue(true, forKey: "isPlaceOrder")
            userDefaults.set(finalPriceSet, forKey: "productPriceFromAPI")
        }
    }
    
    @IBAction func btnRemovePressed(_ sender: UIButton) {
        
        /*
        imgCoupenCodeSuccess.isHidden = true
        lblSucessfullyApplied.isHidden = true
        btnRemove.isHidden = true
        lblPromoCodeName.isHidden = true
        txtPromocode.isHidden = false
        txtPromocode.text = ""
        lblLinePromoCode.isHidden = false
        btnApply.isHidden = false
        lblPromoOfferPrice.isHidden = true
        lblPromoOffer.isHidden = true
        let couponPrice = userDefaults.value(forKey: "couponCodePrice") as! Int
        finalPriceSet = finalPriceSet - couponPrice
        lblFinalPrice.text = CustomUserDefault.getCurrency() + finalPriceSet.formattedWithSeparator
        userDefaults.set(0, forKey: "couponCodePrice")
        */

        txtPromocode.text = ""
        self.viewPromo.isHidden = true
        
    }
    
    @IBAction func onClickPromoPressed(_ sender: Any) {
        self.viewPromo.isHidden = !self.viewPromo.isHidden
    }
    
    @IBAction func btnApplyPressed(_ sender: UIButton) {
        
        if !(txtPromocode.text?.isEmpty)!{
            
            if reachability?.connection.description != "No Connection" {
                
                self.txtPromocode.textColor = UIColor.darkGray
                self.btnApply.isUserInteractionEnabled = false
                applyPromoCode()
                //self.viewPromoApplied.isHidden = false //s.
                self.viewPromo.isHidden = false
                
            }
            else{
                Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
            }
        }else {
            Alert.showAlert(strMessage: "Please Enter valid coupon code".localized(lang: langCode) as NSString, Onview: self) //s.
        }
    }
    
    //MARK:- web service methods
    
    func promoApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func applyPromoCode() {
        
        activityIndicatorePromoCode.startAnimating()
        
        var producdID = ""
        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
        }
        else{
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
        }
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "couponCode"
        
        var parametersHome = [String:Any]()
        
        //Sameer - 28/3/20
        if let couponAvailable = userDefaults.value(forKey: "promotionCouponCode") {
            
            //strUrl = "https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/" + "couponCode"
            //strUrl = "https://getinstacash.in/instaCash/api/v5/public/couponCode"
            
             parametersHome = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "productId":producdID,
                "couponCode":couponAvailable as! String,
                "productQuote":String(getFinalPrice),
                "city":CustomUserDefault.getCityId(),
                "quotationId":quatationId
            ]
            
        }else {
             parametersHome = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "productId":producdID,
                "couponCode":txtPromocode.text!,
                "productQuote":String(getFinalPrice),
                "city":CustomUserDefault.getCityId(),
                "quotationId":quatationId
            ]
        }
        
        print(parametersHome)
        
        self.promoApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            
            print(responseObject ?? [:])
            
            self.activityIndicatorePromoCode.stopAnimating()
            self.btnApply.isUserInteractionEnabled = true
            
            self.txtPromocode.text = ""
            self.viewPromo.isHidden = true //s.
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    self.viewPromoApplied.isHidden = false
                    
                    userDefaults.set(self.txtPromocode.text!, forKey: "orderPromoCode")
                    
                    self.txtPromocode.textColor = UIColor.darkGray
                    self.lblPromoOfferPrice.isHidden = false
                    //self.txtPromocode.isHidden = true //s.
                    //self.btnApply.isHidden = true //s.
                    
                    let myString = "Promo Code: ".localized(lang: langCode) +  self.txtPromocode.text!
                    //  let attrString = NSAttributedString(string: myString)
                    let attribute = NSMutableAttributedString.init(string: myString)
                    let strCount = self.txtPromocode.text!.count
                    let myRange = NSRange(location: 12, length: (strCount))
                    attribute.addAttribute(NSAttributedStringKey.foregroundColor, value:navColor , range: myRange)

                    self.btnRemove.isHidden = false
                    let couponPrice  = (responseObject?.value(forKeyPath: "msg.amount") as? Int)!
                    userDefaults.set(couponPrice, forKey: "couponCodePrice")
                    self.lblPromoOfferPrice.text = "+" + CustomUserDefault.getCurrency() + " \(couponPrice)"
                    let finalPrice = self.finalPriceSet + couponPrice
                    self.finalPriceSet = self.finalPriceSet + couponPrice
                    self.lblFinalPrice.text = CustomUserDefault.getCurrency() + finalPrice.formattedWithSeparator//"\(finalPrice)"
                    print(self.finalPriceSet) //s.
                    
                    
                    //Sameer - 28/3/20
                    if userDefaults.value(forKey: "promotionCouponCode") != nil {
                    
                    }else {
                        
                        let vc  = PromocodePopUpVC()
                        vc.strConditionURL = (responseObject?.value(forKeyPath: "msg.link") as? String)!
                        vc.arrTermsCondition = (responseObject?.value(forKeyPath: "msg.html") as? NSArray)!
                        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        self.navigationController?.present(vc, animated: true, completion: nil)
                        
                    }                    
                    
                }
                else{
                    
                    //self.txtPromocode.textColor = UIColor.red
                    
                    // failed
                    Alert.showAlert(strMessage: "Invalid coupon code".localized(lang: langCode) as NSString, Onview: self)
                }
            }
            else{
                Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        
    }
    
    //MARK:- custom delegate
    func updateUIAndPushToNextController(){
        if CustomUserDefault.isUserIdExit(){
            let vc = PlaceOrderVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = LoginVC()
            vc.iscomingFromPlaceOrder = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        userDefaults.removeObject(forKey: "isPlaceOrder")
        userDefaults.setValue(false, forKey: "isPlaceOrder")
        userDefaults.set(finalPriceSet, forKey: "productPriceFromAPI")
    }
    
}
