//
//  PaymentsModeVC.swift
//  InstaCash
//
//  Created by InstaCash on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class PaymentsModeVC: UIViewController {
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblBankTotalAmount: UILabel!
    @IBOutlet weak var lblNEFTcharges: UILabel!
    @IBOutlet weak var lblNEFTtotalPrice: UILabel!
    @IBOutlet weak var lblIMPScharges: UILabel!
    @IBOutlet weak var lblIMPSTotalPrice: UILabel!
    @IBOutlet weak var lblWalletPrice: UILabel!
    @IBOutlet weak var lblPaytmWalletPrice: UILabel!
    @IBOutlet weak var lblPaytmWalletCharges: UILabel!
    
    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var neftImage: UIImageView!
    @IBOutlet weak var impsImage: UIImageView!
    @IBOutlet weak var paytmWalletImage: UIImageView!
    
    @IBOutlet weak var smallNEFTImage: UIImageView!
    @IBOutlet weak var smallIMPSImage: UIImageView!
    @IBOutlet weak var smallCENDOLImage: UIImageView!
    @IBOutlet weak var smallMAXISImage: UIImageView!
    @IBOutlet weak var smallSAMSUNGImage: UIImageView!
    
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var neftView: UIView!
    @IBOutlet weak var impsView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var paytmWalletView: UIView!
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var cendolView: UIView!
    @IBOutlet weak var maxisView: UIView!
    @IBOutlet weak var samsungView: UIView!
    @IBOutlet weak var cendolImage: UIImageView!
    @IBOutlet weak var maxisImage: UIImageView!
    @IBOutlet weak var samsungImage: UIImageView!
    @IBOutlet weak var lblCENDOLcharges: UILabel!
    @IBOutlet weak var lblCENDOLtotalPrice: UILabel!
    @IBOutlet weak var lblMAXIScharges: UILabel!
    @IBOutlet weak var lblMAXIStotalPrice: UILabel!
    @IBOutlet weak var lblSAMSUNGcharges: UILabel!
    @IBOutlet weak var lblSAMSUNGtotalPrice: UILabel!
    @IBOutlet weak var lblOTHERtotalPrice: UILabel!
    
    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var btnNeft: UIButton!
    @IBOutlet weak var btnImps: UIButton!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var btnPaytm: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnCendol: UIButton!
    @IBOutlet weak var btnMaxis: UIButton!
    @IBOutlet weak var btnSamsung: UIButton!
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var lblSelectedPaymentMode: UILabel!
    
    
    // Localized
    @IBOutlet weak var lblTitlePaymentMode: UILabel!
    @IBOutlet weak var lblHeadSelectedPaymentMode: UILabel!
    @IBOutlet weak var lblChooseOnePayment: UILabel!
    @IBOutlet weak var lblPayableAmount: UILabel!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblBankMode1: UILabel!
    @IBOutlet weak var lblPayable1: UILabel!
    @IBOutlet weak var lblBankMode2: UILabel!
    @IBOutlet weak var lblPayable2: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblPaytm: UILabel!
    @IBOutlet weak var lblPaytmWallet: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblCendolVoucher: UILabel!
    @IBOutlet weak var lblPayable3: UILabel!
    @IBOutlet weak var lblMaxis: UILabel!
    @IBOutlet weak var lblPayable4: UILabel!
    @IBOutlet weak var lblSamsung: UILabel!
    @IBOutlet weak var lblPayable5: UILabel!
    @IBOutlet weak var lblSelPayMode: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    
    //var btnSelect = false
    //var selectedPayment = 0
    var strPaymentProcessMode = "1"
    var getFinalPrice3 = 0
    var pickUpChargeGet3 = 0
    var finalPriceSet3 = 0
    var strProductName3 = ""
    var strProductImg3 = ""
    let reachability: Reachability? = Reachability()
    var quatationId3 = String()
    var userDetails3 = [String:Any]()
    var arrDictPaymentMode = [NSDictionary]()
    var selectePaymentType = String()
    var donationMoney = String()
    
    var neft = 0
    var imps = 0
    //var donation = 0
    var wallet = 0
    
    var fastPay = 0
    var paynow = 0
    
    var bank = 0
    var cendol = 0
    var maxis = 0
    var samsung = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTotalPrice.text = CustomUserDefault.getCurrency() + getFinalPrice3.formattedWithSeparator
        self.getPaymentType()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnWallet.isSelected = false
            self.btnPaytm.isSelected = false
            
            self.lblSelectedPaymentMode.text = "NEFT".localized(lang: langCode)
            selectePaymentType = "NEFT"
            
            self.paytmWalletView.isHidden = true
            self.lblBankMode1.text = "NEFT".localized(lang: langCode)
            self.lblBankMode2.text = "IMPS".localized(lang: langCode)
            
            self.otherView.isHidden = true
            self.cendolView.isHidden = true
            self.maxisView.isHidden = true
            self.samsungView.isHidden = true
            
            self.smallNEFTImage.isHidden = false
            self.smallIMPSImage.isHidden = true
            
        }else if CustomUserDefault.getCurrency() == "RM" {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnOther.isSelected = false
            self.btnCendol.isSelected = false
            self.btnMaxis.isSelected = false
            self.btnSamsung.isSelected = false
            
            self.lblSelectedPaymentMode.text = "BANK".localized(lang: langCode)
            selectePaymentType = "Bank"
            
            self.lblBankMode1.text = "BANK".localized(lang: langCode)
            self.lblBankMode2.text = "BANK".localized(lang: langCode)
            
            self.impsView.isHidden = true
            
            self.walletView.isHidden = true
            self.paytmWalletView.isHidden = true
            
            self.cendolView.isHidden = true
            self.maxisView.isHidden = true
            self.samsungView.isHidden = true
            
            self.smallNEFTImage.isHidden = false
            self.smallCENDOLImage.isHidden = true
            self.smallMAXISImage.isHidden = true
            self.smallSAMSUNGImage.isHidden = true
            
        }else {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            
            self.lblSelectedPaymentMode.text = "FASTPAY".localized(lang: langCode)
            selectePaymentType = "Fastpay"
            
            self.walletView.isHidden = true
            self.paytmWalletView.isHidden = true
            
            self.lblBankMode1.text = "BANK".localized(lang: langCode)
            self.lblBankMode2.text = "BANK".localized(lang: langCode)
            
            self.otherView.isHidden = true
            self.cendolView.isHidden = true
            self.maxisView.isHidden = true
            self.samsungView.isHidden = true
            
            self.smallNEFTImage.isHidden = false
            self.smallIMPSImage.isHidden = true
            
        }
        
    }

    func changeLanguageOfUI() {
      
        self.lblTitlePaymentMode.text = "Payment Mode".localized(lang: langCode)
        self.lblHeadSelectedPaymentMode.text = "Select Payment Mode".localized(lang: langCode)
        self.lblChooseOnePayment.text = "Choose one payment option".localized(lang: langCode)
        self.lblPayableAmount.text = "Payable amount".localized(lang: langCode)
        
        self.lblBank.text = "Bank".localized(lang: langCode)
        self.lblBankMode1.text = "NEFT".localized(lang: langCode)
        self.lblPayable1.text = "Payable".localized(lang: langCode)
        self.lblBankMode2.text = "IMPS".localized(lang: langCode)
        
        self.lblPayable2.text = "Payable".localized(lang: langCode)
        self.lblWallet.text = "Wallet".localized(lang: langCode)
        self.lblPaytm.text = "Paytm".localized(lang: langCode)
        self.lblPaytmWallet.text = "PAYTM WALLET".localized(lang: langCode)
        
        self.lblOther.text = "Other".localized(lang: langCode)
        self.lblCendolVoucher.text = "Cendol Voucher".localized(lang: langCode)
        self.lblPayable3.text = "Payable".localized(lang: langCode)
        self.lblMaxis.text = "Maxis".localized(lang: langCode)
        
        self.lblPayable4.text = "Payable".localized(lang: langCode)
        self.lblSamsung.text = "Samsung".localized(lang: langCode)
        self.lblPayable5.text = "Payable".localized(lang: langCode)
        self.lblSelPayMode.text = "Selected Payment Mode".localized(lang: langCode)
        
        self.btnNext.setTitle("NEXT".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setBorder(width: 1.0, color: UIColor.gray)
        
        self.changeLanguageOfUI()
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Payment Mode".localized(lang: langCode)
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(PaymentsModeVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func setBorder(width:CGFloat,color:UIColor) {
        bankView.layer.borderWidth = width
        bankView.layer.borderColor = color.cgColor
        
        neftView.layer.borderWidth = width
        neftView.layer.borderColor = color.cgColor
        
        impsView.layer.borderWidth = width
        impsView.layer.borderColor = color.cgColor
        
        walletView.layer.borderWidth = width
        walletView.layer.borderColor = color.cgColor
        
        paytmWalletView.layer.borderWidth = width
        paytmWalletView.layer.borderColor = color.cgColor
        
        otherView.layer.borderWidth = width
        otherView.layer.borderColor = color.cgColor
        
        cendolView.layer.borderWidth = width
        cendolView.layer.borderColor = color.cgColor
        
        maxisView.layer.borderWidth = width
        maxisView.layer.borderColor = color.cgColor
        
        samsungView.layer.borderWidth = width
        samsungView.layer.borderColor = color.cgColor
    }
    
    //MARK:- web service methods
    
    func apiPayment(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func getPaymentType() {
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "paymentMode"
            
            let couponAmount = (userDefaults.value(forKeyPath: "couponCodePrice") as? Int) ?? 0
            let finalAmount = getFinalPrice3 - couponAmount
            let strFinalAmount = String(format: "%d",finalAmount)
            
            var paymentTagValue = ""
            if userDefaults.value(forKey: "Utm_Term_Value") == nil {
                paymentTagValue = ""
            }
            else{
                paymentTagValue = userDefaults.value(forKey: "Utm_Term_Value") as! String
                if paymentTagValue == "samsung"{
                    paymentTagValue = "smg"
                }
            }
            
            let parametersHome : [String : Any] = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "amount":strFinalAmount,
                "couponAmount":couponAmount,
                "categoryId":"15",
                "paymentTag":paymentTagValue,
                "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "" //110011
            ]
            print(parametersHome)
            
            self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let arrPaymentTypeData = responseObject?["msg"] as? NSArray
                        for index in 0..<arrPaymentTypeData!.count{
                            let dict = arrPaymentTypeData![index] as? NSDictionary
                            
                            self.arrDictPaymentMode.append(dict ?? NSDictionary())
                        }
                        
                        print(self.arrDictPaymentMode)
                        
                        //To set priceValues from api response
                        
                        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                            
                            for (index,item) in self.arrDictPaymentMode.enumerated() {
                                print(index,item)
                                
                                if item["typeCode"] as? String == "NEFT" {
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.neft = bankCharge
                                    self.finalPriceSet3 = bankCharge
                                    
                                    self.lblBankTotalAmount.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    self.lblNEFTcharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    self.lblNEFTtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.neftImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "IMPS" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    self.lblIMPScharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.imps = bankCharge
                                    
                                    
                                    self.lblIMPSTotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.impsImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "PYTM" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.wallet = bankCharge
                                    
                                    self.lblPaytmWalletCharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    self.lblWalletPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    self.lblPaytmWalletPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.paytmWalletImage.sd_setImage(with: imgURL)
                                }
                            }
                            
                        }else if CustomUserDefault.getCurrency() == "RM" {
                            
                            for (index,item) in self.arrDictPaymentMode.enumerated() {
                                print(index,item)
                                
                                if item["typeCode"] as? String == "BANK" {
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.bank = bankCharge
                                    self.finalPriceSet3 = bankCharge
                                    
                                    self.lblBankTotalAmount.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    self.lblOTHERtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    self.lblNEFTcharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    self.lblNEFTtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.neftImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "Ashita" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    self.lblCENDOLcharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.cendol = bankCharge
                                    
                                    
                                    self.lblCENDOLtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.cendolImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "Maxis" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    self.lblMAXIScharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.maxis = bankCharge
                                    
                                    
                                    self.lblMAXIStotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.maxisImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "Samsung" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    self.lblSAMSUNGcharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.samsung = bankCharge
                                    
                                    
                                    self.lblSAMSUNGtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.samsungImage.sd_setImage(with: imgURL)
                                    
                                }
                            }

                        }else {

                            for (index,item) in self.arrDictPaymentMode.enumerated() {
                                print(index,item)
                                
                                if item["typeCode"] as? String == "Fastpay" {
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.fastPay = bankCharge
                                    self.finalPriceSet3 = bankCharge
                                    
                                    self.lblBankTotalAmount.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    self.lblNEFTcharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    self.lblNEFTtotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.neftImage.sd_setImage(with: imgURL)
                                    
                                }else if item["typeCode"] as? String == "Paynow" {
                                    
                                    let gateWayCharge = item.value(forKey: "gatewayCharge") as? Int ?? 0
                                    
                                    self.lblIMPScharges.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                                    
                                    let bankCharge = self.getFinalPrice3 + gateWayCharge
                                    self.paynow = bankCharge
                                    
                                    
                                    self.lblIMPSTotalPrice.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                                    
                                    let imgURL = URL.init(string: item["image"] as! String)
                                    self.impsImage.sd_setImage(with: imgURL)
                                    
                                }
                            }
                        }
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
        }
        else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBankTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.btnBank.isSelected = true
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = false
                self.btnWallet.isSelected = false
                self.btnPaytm.isSelected = false
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        self.paytmWalletView.isHidden = true
                        self.view.layoutIfNeeded()
                    }) { (true) in
                        UIView.animate(withDuration: 0.4) {
                            self.view.layoutIfNeeded()
                            self.neftView.isHidden = false
                            self.impsView.isHidden = false
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                
            }else if CustomUserDefault.getCurrency() == "RM" {
                
                self.btnBank.isSelected = true
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = false
                self.btnOther.isSelected = false
                self.btnCendol.isSelected = false
                self.btnMaxis.isSelected = false
                self.btnSamsung.isSelected = false
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.view.layoutIfNeeded()
                        self.cendolView.isHidden = true
                        self.maxisView.isHidden = true
                        self.samsungView.isHidden = true
                        
                        self.neftView.isHidden = false
                        self.view.layoutIfNeeded()
                    }) { (true) in
                        
                    }
                }
                
            }else {
                
                self.btnBank.isSelected = true
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = false
            
            }
        }
    }
    
    @IBAction func btnNEFTTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.BottomView.frame.origin.y += 45
                    self.view.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y -= 45
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = true
                self.btnImps.isSelected = false
                self.btnWallet.isSelected = false
                self.btnPaytm.isSelected = false
                
                self.lblSelectedPaymentMode.text = "NEFT".localized(lang: langCode)
                
                selectePaymentType = "NEFT"
                finalPriceSet3 = neft
                
                self.smallNEFTImage.isHidden = false
                self.smallIMPSImage.isHidden = true
                
            }else if CustomUserDefault.getCurrency() == "RM" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = true
                self.btnImps.isSelected = false
                self.btnOther.isSelected = false
                self.btnCendol.isSelected = false
                self.btnMaxis.isSelected = false
                self.btnSamsung.isSelected = false
                
                self.lblSelectedPaymentMode.text = "BANK".localized(lang: langCode)
                
                selectePaymentType = "Bank"
                finalPriceSet3 = bank
                
                self.smallNEFTImage.isHidden = false
                self.smallCENDOLImage.isHidden = true
                self.smallMAXISImage.isHidden = true
                self.smallSAMSUNGImage.isHidden = true
                
            }else {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = true
                self.btnImps.isSelected = false
                
                self.lblSelectedPaymentMode.text = "FASTPAY".localized(lang: langCode)
                
                selectePaymentType = "Fastpay"
                finalPriceSet3 = fastPay
                
                self.smallNEFTImage.isHidden = false
                self.smallIMPSImage.isHidden = true
            }
        }
        
    }
    
    @IBAction func btnIMPSTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.BottomView.frame.origin.y += 45
                    self.view.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y -= 45
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = true
                self.btnWallet.isSelected = false
                self.btnPaytm.isSelected = false
                
                self.smallNEFTImage.isHidden = true
                self.smallIMPSImage.isHidden = false
                
                self.lblSelectedPaymentMode.text = "IMPS".localized(lang: langCode)
                
                selectePaymentType = "IMPS"
                finalPriceSet3 = imps
                
            }else if CustomUserDefault.getCurrency() == "RM" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = true
                self.btnOther.isSelected = false
                self.btnCendol.isSelected = false
                self.btnMaxis.isSelected = false
                self.btnSamsung.isSelected = false
                
            }else {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = true
                
                self.lblSelectedPaymentMode.text = "PAYNOW".localized(lang: langCode)
                
                selectePaymentType = "Paynow"
                finalPriceSet3 = paynow
                
                self.smallNEFTImage.isHidden = true
                self.smallIMPSImage.isHidden = false
            }
        }
    }
    
    @IBAction func btnDONATIONTapped(_ sender: UIButton) {
        /*
        self.lblSelectedPaymentMode.text = "DONATION"
.
        selectePaymentType = "DONATION"
        finalPriceSet3 = donation
        selectedPayment = 2
        btnSelect = true
        */
    }
    
    @IBAction func btnWALLETTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = false
                self.btnWallet.isSelected = true
                self.btnPaytm.isSelected = false
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        self.neftView.isHidden = true
                        self.impsView.isHidden = true
                        self.view.layoutIfNeeded()
                    }) { (true) in
                        UIView.animate(withDuration: 0.4) {
                            self.view.layoutIfNeeded()
                            self.paytmWalletView.isHidden = false
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                
            }else if CustomUserDefault.getCurrency() == "RM" {
                
                
            }else {
                
            }
        }
    }
    
    @IBAction func btnPaytmWALLETTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                self.btnBank.isSelected = false
                self.btnNeft.isSelected = false
                self.btnImps.isSelected = false
                self.btnWallet.isSelected = false
                self.btnPaytm.isSelected = true
                
                self.lblSelectedPaymentMode.text = "PAYTM".localized(lang: langCode)
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y += 45
                        self.view.layoutIfNeeded()
                    }) { (true) in
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                            self.BottomView.frame.origin.y -= 45
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                
                selectePaymentType = "PYTM"
                finalPriceSet3 = wallet
                
                self.smallNEFTImage.isHidden = true
                self.smallIMPSImage.isHidden = true
                
            }else if CustomUserDefault.getCurrency() == "RM" {
                
                
            }else {
                
            }
        }
    }
    
    @IBAction func btnOTHERTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnOther.isSelected = true
            self.btnCendol.isSelected = false
            self.btnMaxis.isSelected = false
            self.btnSamsung.isSelected = false
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.neftView.isHidden = true
                    
                    self.cendolView.isHidden = false
                    self.maxisView.isHidden = false
                    self.samsungView.isHidden = false
                    self.view.layoutIfNeeded()
                }) { (true) in
                    
                }
            }
            
        }
    }
    
    @IBAction func btnCENDOLTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnOther.isSelected = false
            self.btnCendol.isSelected = true
            self.btnMaxis.isSelected = false
            self.btnSamsung.isSelected = false
            
            self.lblSelectedPaymentMode.text = "CENDOL VOUCHER".localized(lang: langCode)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.BottomView.frame.origin.y += 45
                    self.view.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y -= 45
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            selectePaymentType = "Ashita"
            finalPriceSet3 = cendol
            
            self.smallNEFTImage.isHidden = true
            self.smallCENDOLImage.isHidden = false
            self.smallMAXISImage.isHidden = true
            self.smallSAMSUNGImage.isHidden = true
        }
    }
    
    @IBAction func btnMAXISTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnOther.isSelected = false
            self.btnCendol.isSelected = false
            self.btnMaxis.isSelected = true
            self.btnSamsung.isSelected = false
            
            self.lblSelectedPaymentMode.text = "MAXIS".localized(lang: langCode)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.BottomView.frame.origin.y += 45
                    self.view.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y -= 45
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            selectePaymentType = "Maxis"
            finalPriceSet3 = maxis
            
            self.smallNEFTImage.isHidden = true
            self.smallCENDOLImage.isHidden = true
            self.smallMAXISImage.isHidden = false
            self.smallSAMSUNGImage.isHidden = true
        }
    }
    
    @IBAction func btnSAMSUNGTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            
            self.btnBank.isSelected = false
            self.btnNeft.isSelected = false
            self.btnImps.isSelected = false
            self.btnOther.isSelected = false
            self.btnCendol.isSelected = false
            self.btnMaxis.isSelected = false
            self.btnSamsung.isSelected = true
            
            self.lblSelectedPaymentMode.text = "SAMSUNG".localized(lang: langCode)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                    self.BottomView.frame.origin.y += 45
                    self.view.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.BottomView.frame.origin.y -= 45
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            selectePaymentType = "Samsung"
            finalPriceSet3 = samsung
            
            self.smallNEFTImage.isHidden = true
            self.smallCENDOLImage.isHidden = true
            self.smallMAXISImage.isHidden = true
            self.smallSAMSUNGImage.isHidden = false
        }
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            /*
            guard btnSelect else {
                Alert.showAlert(strMessage: "Please select payment mode!", Onview: self)
                return
            }*/
            
            let vc = BankTransfer()
            vc.strProductImg4 = self.strProductImg3
            vc.strProductName4 = self.strProductName3
            vc.getFinalPrice4 = self.finalPriceSet3
            vc.pickUpChargeGet4 = self.pickUpChargeGet3
            vc.finalPriceSet4 = self.finalPriceSet3
            vc.donation = self.donationMoney
            vc.quatationId4 = self.quatationId3
            vc.userDetails4 = self.userDetails3
            vc.selectePaymentType4 = self.selectePaymentType
            self.navigationController?.pushViewController(vc, animated: true)
        
        }else if CustomUserDefault.getCurrency() == "RM" {
            
            switch selectePaymentType {
                case "Bank":
                    
                    self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                    /*
                    let vc = MYBankDetailVC()
                    vc.quatationId = self.quatationId3
                    vc.selectedPaymentType = self.selectePaymentType
                    self.navigationController?.pushViewController(vc, animated:     true)
                    */
                
                case "Ashita":
                
                    self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                    /*
                    let vc = MYCendolVC()
                    vc.quatationId = self.quatationId3
                    vc.selectedPaymentType = self.selectePaymentType
                    self.navigationController?.pushViewController(vc, animated:     true)*/
                
                case "Maxis":
                
                    self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                    /*
                    let vc = MYMaxisVC()
                    vc.quatationId = self.quatationId3
                    vc.selectedPaymentType = self.selectePaymentType
                    self.navigationController?.pushViewController(vc, animated:     true)*/
                
                default:
                    
                    self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                    /*
                    let vc = MYSamsungVC()
                    vc.quatationId = self.quatationId3
                    vc.selectedPaymentType = self.selectePaymentType
                    self.navigationController?.pushViewController(vc, animated:     true)*/
                
            }
            
        }else {
            
            if selectePaymentType == "Fastpay" {
                
                self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                /*
                let vc = SGFastPayVC()
                vc.quatationId = self.quatationId3
                vc.selectedPaymentType = self.selectePaymentType
                self.navigationController?.pushViewController(vc, animated:     true)*/
                
            }else {
                
                self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
                
                /*
                let vc = SGPaynowVC()
                vc.quatationId = self.quatationId3
                vc.selectedPaymentType = self.selectePaymentType
                self.navigationController?.pushViewController(vc, animated:     true)*/
                
            }
            
        }

        
    }
    
    //MARK:- webservice orderCreate
    
    func orderCreateApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(orderRefType:String) {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var producdID = ""
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
            }
            
            var strValue = ""
            var userSelectedProductAppcodes = ""
            
            let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
            let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
            
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
                strValue = "STON01,"
                
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
                strValue = ""
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes
            }
            
            let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
            let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
            
            
            var strGCMToken = ""
            if (userDefaults.value(forKey: "FCMToken") != nil) {
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else {
                strGCMToken = ""
            }
            
            let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
            
            var strPromoterId = ""
            if userDefaults.value(forKey: "promoter_id") == nil {
                strPromoterId = ""
            }
            else {
                strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
            }
            
            //Sameer - 28/3/20
            if userDefaults.value(forKey: "promoterID") == nil {
                strPromoterId = ""
            }
            else{
                strPromoterId = userDefaults.value(forKey: "promoterID") as! String
            }
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "orderCreate"
            
            var smallParam = ["IMEINumber" : KeychainWrapper.standard.string(forKey: "UUIDValue") ?? "",
                              "name" : userDetails3["name"] ?? "",
                              "email" : userDetails3["email"] ?? "",
                              "mobile" : userDetails3["mobile"] ?? "",
                              "address1" : userDetails3["address1"] ?? "",
                              "address2" : userDetails3["address1"] ?? "",
                              "pincode" : userDetails3["pincode"] ?? "",
                              "city" : userDetails3["city"] ?? "",
                              "paymentType" : orderRefType,
            ]
            
            /*
            smallParam["Account_Holders_Name"] = txtAccountHolderName.text ?? ""
            smallParam["Bank_Name"] = txtBankName.text ?? ""
            smallParam["Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["Confirm_Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["IFSC"] = txtIfsc.text ?? ""
            */
            
            smallParam["type"] = "createOrder"
            smallParam["isNewAddress"] = "1"
            
            //smallParam["donateTo"] = "NSS"
            //smallParam["donateAmount"] = "31"
            
            if donationMoney == "" {
                smallParam["donateTo"] = ""
                smallParam["donationAmount"] = ""
            }else {
                smallParam["donateTo"] = "NSS"
                smallParam["donationAmount"] = donationMoney
            }
            
            var parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "mobile":CustomUserDefault.getPhoneNumber() ?? "",
                
                "name":CustomUserDefault.getUserName() ?? "",
                "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", 
                
                "city":CustomUserDefault.getCityId(),
                
                ////////////////////////////////////////////////////////////
                "productId":producdID,
                "conditionString":converComaToSemocolumForProductValues,
                "diagnosisId":userDefaults.value(forKey: "diagnosisId") as? String ?? "",
                "processMode":self.strPaymentProcessMode,
                ////////////////////////////////////////////////////////////
                
                //"remark":"",
                "email":CustomUserDefault.getUserEmail() ?? "",
                //"productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String,
                //"GCMId":strGCMToken,
                "customerId":CustomUserDefault.getUserId(),
                //"landmark":"",
                "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "",
                "isNewAddress":"1",
                
                "uniqueIdentifire":KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!,
                "paymentCode": orderRefType,
                
                "couponCode":userDefaults.value(forKey: "orderPromoCode") as? String ?? "",
                "couponAmount":couponAmount,
                "promoterId":strPromoterId,
                
                //"paymentDetails" : smallParam,
                "donateTo" : "NSS",
                "donationAmount" : donationMoney,
                
                "quotationId":self.quatationId3,
                "preferredDate":"",
                "preferredTime":"",
                //"additionalInformation":"",
            ]
            
            if let addInfo = userDefaults.value(forKey: "additionalInfo") {
                parametersHome["additionalInformation"] = addInfo
            }
            
            print(strUrl)
            print(parametersHome)
            
            self.orderCreateApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let orderPlaceID = responseObject?["msg"] as? String
                        let orderID = responseObject?["orderId"] as? String
                        let itemID = responseObject?["itemId"] as? String
                        
                        
                        switch self.selectePaymentType {
                        case "Bank":
                            
                            let vc = MYBankDetailVC()
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:true)
                            
                        case "Ashita":
                            
                            let vc = MYCendolVC()
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:     true)
                            
                        case "Maxis":
                            
                            let vc = MYMaxisVC()
                            
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:     true)
                            
                        case "Samsung":
                            
                            let vc = MYSamsungVC()
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:     true)
                            
                        case "Fastpay":
                            
                            let vc = SGFastPayVC()
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:     true)
                            
                        default:
                            
                            let vc = SGPaynowVC()
                            vc.quatationId = self.quatationId3
                            vc.orderID = orderID ?? ""
                            vc.itemID = itemID ?? ""
                            vc.selectedPaymentType = self.selectePaymentType
                            
                            vc.finalPriced = self.finalPriceSet3
                            vc.placedOrderId = orderPlaceID ?? ""
                            self.navigationController?.pushViewController(vc, animated:     true)
                            
                        }
                        
                    }
                    else{
                        // failed
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlert(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlert(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
