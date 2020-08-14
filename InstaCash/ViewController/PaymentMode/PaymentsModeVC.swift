//
//  PaymentsModeVC.swift
//  InstaCash
//
//  Created by InstaCash on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class PaymentsModeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblTitlePaymentMode: UILabel!
    @IBOutlet weak var lblHeadSelectedPaymentMode: UILabel!
    @IBOutlet weak var lblChooseOnePayment: UILabel!
    @IBOutlet weak var lblPayableAmount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblSelPayMode: UILabel!
    @IBOutlet weak var lblSelectedPaymentMode: UILabel!
    @IBOutlet weak var paymentModeTableView: UITableView!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    
    var arrBankGroup = [NSDictionary]()
    var arrOtherGroup = [NSDictionary]()
    var arrWalletGroup = [NSDictionary]()
    
    var openSectionNumber = 0
    var selectedPaymentModeIndex = 1
    var paymentTypeBankSelect = false
    var paymentTypeOtherSelect = false
    var paymentTypeWalletSelect = false
    
    var strPaymentProcessMode = "1"
    var getFinalPrice3 = 0
    var pickUpChargeGet3 = 0
    var finalPriceSet3 = 0
    var strProductName3 = ""
    var strProductImg3 = ""
    let reachability: Reachability? = Reachability()
    var quatationId3 = String()
    var userDetails3 = [String:Any]()
    var selectePaymentType = String()
    var donationMoney = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentModeTableView.register(UINib(nibName: "PaymentModeHeaderTblCell", bundle: nil), forCellReuseIdentifier: "PaymentModeHeaderTblCell")
        paymentModeTableView.register(UINib(nibName: "PaymentModeFooterTblCell", bundle: nil), forCellReuseIdentifier: "PaymentModeFooterTblCell")
        
        lblTotalPrice.text = CustomUserDefault.getCurrency() + getFinalPrice3.formattedWithSeparator
        self.getPaymentType()
                
    }

    func changeLanguageOfUI() {
      
        self.lblTitlePaymentMode.text = "Payment Mode".localized(lang: langCode)
        self.lblHeadSelectedPaymentMode.text = "Select Payment Mode".localized(lang: langCode)
        self.lblChooseOnePayment.text = "Choose one payment option".localized(lang: langCode)
        self.lblPayableAmount.text = "Payable amount".localized(lang: langCode)
    
        self.lblSelPayMode.text = "Selected Payment Mode".localized(lang: langCode)
        
        self.btnNext.setTitle("NEXT".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                if paymentTagValue == "samsung" {
                    paymentTagValue = "smg"
                }
            }
            
            let host = strBaseURL.components(separatedBy: ".")
            let path = host.last
            let val = path?.components(separatedBy: "/")
            let country = val?[0] ?? ""
            print(country)
            
            //Sameer 24/6/2020
            var parametersHome = [String : Any]()
            
            if (userDefaults.value(forKeyPath: "paymodeResponse") != nil) {
                
                let recovedUserJsonData = UserDefaults.standard.object(forKey: "paymodeResponse")
                let dictResponse = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data) as! NSDictionary
                print(dictResponse)
                
                if let paymentModeKey = dictResponse.value(forKey: "paymode") as? String, let countryKey = dictResponse.value(forKey: "country") as? String {
                    if countryKey == country {
                        
                        parametersHome = [
                            "apiKey" : key,
                            "userName" : apiAuthenticateUserName,
                            "amount" : strFinalAmount,
                            "couponAmount" : couponAmount,
                            "categoryId" : "15",
                            "paymentTag" : paymentModeKey,
                            "pincode" : userDefaults.value(forKey: "orderPinCode") as? String ?? ""
                        ]
                        
                    }else {
                        parametersHome = [
                            "apiKey" : key,
                            "userName" : apiAuthenticateUserName,
                            "amount" : strFinalAmount,
                            "couponAmount" : couponAmount,
                            "categoryId" : "15",
                            //"paymentTag" : paymentTagValue,
                            "pincode" : userDefaults.value(forKey: "orderPinCode") as? String ?? ""
                        ]
                    }
                }else {
                    parametersHome = [
                        "apiKey" : key,
                        "userName" : apiAuthenticateUserName,
                        "amount" : strFinalAmount,
                        "couponAmount" : couponAmount,
                        "categoryId" : "15",
                        //"paymentTag" : paymentTagValue,
                        "pincode" : userDefaults.value(forKey: "orderPinCode") as? String ?? ""
                    ]
                }
            
            }else {
                
                parametersHome = [
                    "apiKey" : key,
                    "userName" : apiAuthenticateUserName,
                    "amount" : strFinalAmount,
                    "couponAmount" : couponAmount,
                    "categoryId" : "15",
                    //"paymentTag" : paymentTagValue,
                    "pincode" : userDefaults.value(forKey: "orderPinCode") as? String ?? ""
                ]
            }
            
            print(strUrl)
            print(parametersHome)
            
            self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let arrPaymentTypeData = responseObject?["msg"] as? NSArray
                        
                        for index in 0..<arrPaymentTypeData!.count {
                            let dict = arrPaymentTypeData![index] as? NSDictionary
                            
                            if dict?["paymentGroup"] as? String == "Bank" {
                                self.arrBankGroup.append(dict ?? [:])
                            }else if dict?["paymentGroup"] as? String == "Other" {
                                self.arrOtherGroup.append(dict ?? [:])
                            }else if dict?["paymentGroup"] as? String == "Wallet" {
                                self.arrWalletGroup.append(dict ?? [:])
                            }
                                                        
                        }
                        
                        
                        if self.arrWalletGroup.count > 0 {
                            self.openSectionNumber = 2
                            self.selectedPaymentModeIndex = 1
                            
                            self.paymentTypeBankSelect = false
                            self.paymentTypeOtherSelect = false
                            self.paymentTypeWalletSelect = true
                            
                            self.lblSelectedPaymentMode.text = (self.arrWalletGroup[0]["typeCode"] as! String).localized(lang: langCode)
                            
                            self.selectePaymentType = self.arrWalletGroup[0]["typeCode"] as? String ?? ""
                            
                            let gateWayCharge = self.arrWalletGroup[0]["gatewayCharge"] as? Int ?? 0
                            let finalCharge = self.getFinalPrice3 + gateWayCharge
                            self.finalPriceSet3 = finalCharge
                        }
                        
                        if self.arrOtherGroup.count > 0 {
                            self.openSectionNumber = 1
                            self.selectedPaymentModeIndex = 1
                            
                            self.paymentTypeBankSelect = false
                            self.paymentTypeOtherSelect = true
                            self.paymentTypeWalletSelect = false
                            
                            self.lblSelectedPaymentMode.text = (self.arrOtherGroup[0]["typeCode"] as! String).localized(lang: langCode)
                            
                            self.selectePaymentType = self.arrOtherGroup[0]["typeCode"] as? String ?? ""
                            
                            let gateWayCharge = self.arrOtherGroup[0]["gatewayCharge"] as? Int ?? 0
                            let finalCharge = self.getFinalPrice3 + gateWayCharge
                            self.finalPriceSet3 = finalCharge
                        }
                        
                        if self.arrBankGroup.count > 0 {
                            self.openSectionNumber = 0
                            self.selectedPaymentModeIndex = 1
                            
                            self.paymentTypeBankSelect = true
                            self.paymentTypeOtherSelect = false
                            self.paymentTypeWalletSelect = false
                            
                            self.lblSelectedPaymentMode.text = (self.arrBankGroup[0]["typeCode"] as! String).localized(lang: langCode)
                            
                            self.selectePaymentType = self.arrBankGroup[0]["typeCode"] as? String ?? ""
                            
                            let gateWayCharge = self.arrBankGroup[0]["gatewayCharge"] as? Int ?? 0
                            let finalCharge = self.getFinalPrice3 + gateWayCharge
                            self.finalPriceSet3 = finalCharge
                        }
                        
                        UIView.animate(withDuration: 0.4, animations: {
                            if arrPaymentTypeData?.count ?? 0 > 6 {
                                self.paymentModeTableView.isScrollEnabled = true
                            }else {
                                self.paymentModeTableView.isScrollEnabled = false
                            }
                            
                            self.paymentModeTableView.reloadData()
                        }) { (true) in
                            self.view.layoutIfNeeded()
                        }
                                                
                        
                    }
                    else{
                        // failed
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
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
        
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            /*
            guard btnSelect else {
                Alert.showAlert(strMessage: "Please select payment mode!", Onview: self)
                return
            }*/
            
            //let vc = BankTransfer()
            let vc = TWCashVC()
            vc.strProductImg4 = self.strProductImg3
            vc.strProductName4 = self.strProductName3
            vc.getFinalPrice4 = self.finalPriceSet3
            vc.pickUpChargeGet4 = self.pickUpChargeGet3
            vc.finalPriceSet4 = self.finalPriceSet3
            vc.donation = self.donationMoney
            vc.quatationId4 = self.quatationId3
            vc.userDetails4 = self.userDetails3
            vc.selectePaymentType4 = self.selectePaymentType
            vc.selectedPaymentType = self.selectePaymentType
            self.navigationController?.pushViewController(vc, animated: true)
        
        }else {
            
            self.fetchOrderFromServer(orderRefType: self.selectePaymentType)
            
//            let vc = TWCashVC()
//            vc.quatationId = self.quatationId3
//            vc.selectedPaymentType = self.selectePaymentType
//            vc.finalPriced = self.finalPriceSet3
//            self.navigationController?.pushViewController(vc, animated: true)
    
        }
        
    }
    
    //MARK: UITableView DateSource & Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            
            if arrBankGroup.count > 0 && openSectionNumber == section {
                return arrBankGroup.count + 1
            }else if arrBankGroup.count > 0 {
                return 1
            }else {
                return 0
            }
            
        case 1:
            
            if arrOtherGroup.count > 0 && openSectionNumber == section {
                return arrOtherGroup.count + 1
            }else if arrOtherGroup.count > 0 {
                return 1
            }else {
                return 0
            }
        default:
            
            if arrWalletGroup.count > 0 && openSectionNumber == section {
                return arrWalletGroup.count + 1
            }else if arrWalletGroup.count > 0 {
                return 1
            }else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                let headCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeHeaderTblCell", for: indexPath) as! PaymentModeHeaderTblCell
                headCell.paymentGroupImgView.image = #imageLiteral(resourceName: "bank")
                headCell.lblPaymentGroupName.text = "Bank"
                
                let gateWayCharge = self.arrBankGroup[indexPath.row].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    headCell.lblTotalPayment.text = ""
                }else {
                    headCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                }
                
                return headCell
            }else {
                let footCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeFooterTblCell", for: indexPath) as! PaymentModeFooterTblCell
                                
                if self.selectedPaymentModeIndex == indexPath.row && openSectionNumber == indexPath.section && paymentTypeBankSelect {
                    footCell.selectionImgView.image = #imageLiteral(resourceName: "smallRight")
                }else {
                    footCell.selectionImgView.image = nil
                }
                
                let imgURL = URL.init(string: self.arrBankGroup[indexPath.row - 1]["image"] as! String)
                footCell.paymentTypeImgView.sd_setImage(with: imgURL)
                
                footCell.lblPaymentType.text = (self.arrBankGroup[indexPath.row - 1]["paymentType"] as? String)?.localized(lang: langCode)
                
                let gateWayCharge = self.arrBankGroup[indexPath.row - 1].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    //footCell.lblGatewayCharge.text = ""
                    footCell.lblGatewayCharge.isHidden = true
                }else {
                    footCell.lblGatewayCharge.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                }
                
                footCell.lblPayable.text = "Payable".localized(lang: langCode)
                
                footCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
            
                return footCell
            }
            
        case 1:
            
            if indexPath.row == 0 {
                let headCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeHeaderTblCell", for: indexPath) as! PaymentModeHeaderTblCell
                headCell.paymentGroupImgView.image = #imageLiteral(resourceName: "voucher")
                headCell.lblPaymentGroupName.text = "Other"
                
                let gateWayCharge = self.arrOtherGroup[indexPath.row].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    headCell.lblTotalPayment.text = ""
                }else {
                    headCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                }
                
                return headCell
            }else {
                let footCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeFooterTblCell", for: indexPath) as! PaymentModeFooterTblCell
                
                if self.selectedPaymentModeIndex == indexPath.row && openSectionNumber == indexPath.section && paymentTypeOtherSelect {
                    footCell.selectionImgView.image = #imageLiteral(resourceName: "smallRight")
                }else {
                    footCell.selectionImgView.image = nil
                }
                
                let imgURL = URL.init(string: self.arrOtherGroup[indexPath.row - 1]["image"] as! String)
                footCell.paymentTypeImgView.sd_setImage(with: imgURL)
                
                footCell.lblPaymentType.text = (self.arrOtherGroup[indexPath.row - 1]["paymentType"] as? String)?.localized(lang: langCode)
                
                /*
                var strPayType = (self.arrOtherGroup[indexPath.row - 1]["paymentType"] as? String)?.localized(lang: langCode)
                if strPayType?.contains("PChome") ?? false {
                    //strPayType = strPayType?.replacingOccurrences(of: "PChome", with: "")
                    strPayType = " 現金 "
                }
                footCell.lblPaymentType.text = strPayType
                */
                
                let gateWayCharge = self.arrOtherGroup[indexPath.row - 1].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    //footCell.lblGatewayCharge.text = ""
                    footCell.lblGatewayCharge.isHidden = true
                }else {
                    footCell.lblGatewayCharge.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                }
                                
                footCell.lblPayable.text = "Payable".localized(lang: langCode)
                
                if (self.arrOtherGroup[indexPath.row - 1]["paymentType"] as? String) == "UUPON (Points Only)" || (self.arrOtherGroup[indexPath.row - 1]["paymentType"] as? String) == "HamiPoints" {
                    footCell.lblTotalPayment.text = " 點數 " + String(bankCharge.formattedWithSeparator)
                }else{
                    footCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                }
                                
                return footCell
            }
            
        default:
            
            if indexPath.row == 0 {
                let headCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeHeaderTblCell", for: indexPath) as! PaymentModeHeaderTblCell
                headCell.paymentGroupImgView.image = #imageLiteral(resourceName: "wallet")
                headCell.lblPaymentGroupName.text = "Wallet"
                
                let gateWayCharge = self.arrWalletGroup[indexPath.row].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    headCell.lblTotalPayment.text = ""
                }else {
                    headCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                }
                
                return headCell
            }else {
                let footCell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeFooterTblCell", for: indexPath) as! PaymentModeFooterTblCell
                
                if self.selectedPaymentModeIndex == indexPath.row && openSectionNumber == indexPath.section && paymentTypeWalletSelect {
                    footCell.selectionImgView.image = #imageLiteral(resourceName: "smallRight")
                }else {
                    footCell.selectionImgView.image = nil
                }
                
                let imgURL = URL.init(string: self.arrWalletGroup[indexPath.row - 1]["image"] as! String)
                footCell.paymentTypeImgView.sd_setImage(with: imgURL)
                
                footCell.lblPaymentType.text = (self.arrWalletGroup[indexPath.row - 1]["paymentType"] as? String)?.localized(lang: langCode)
                
                let gateWayCharge = self.arrWalletGroup[indexPath.row - 1].value(forKey: "gatewayCharge") as? Int ?? 0
                let bankCharge = self.getFinalPrice3 + gateWayCharge
                //self.finalPriceSet3 = bankCharge
                
                if CustomUserDefault.getCurrency() == "NT$" {
                    //footCell.lblGatewayCharge.text = ""
                    footCell.lblGatewayCharge.isHidden = true
                }else {
                    footCell.lblGatewayCharge.text = "Gateway charges".localized(lang: langCode) + "-" + CustomUserDefault.getCurrency() + String(gateWayCharge)
                }
                                
                footCell.lblPayable.text = "Payable".localized(lang: langCode)
                
                footCell.lblTotalPayment.text = CustomUserDefault.getCurrency() + String(bankCharge.formattedWithSeparator)
                
                return footCell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                openSectionNumber = indexPath.section
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.paymentModeTableView.reloadData()
                }) { (true) in
                    self.view.layoutIfNeeded()
                }
                
            }else {
                print(arrBankGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                
                self.lblSelectedPaymentMode.text = (arrBankGroup[indexPath.row - 1]["typeCode"] as? String ?? "").localized(lang: langCode)
                
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
                            
                            self.paymentTypeBankSelect = true
                            self.paymentTypeOtherSelect = false
                            self.paymentTypeWalletSelect = false
                            
                            self.selectedPaymentModeIndex = indexPath.row
                            self.paymentModeTableView.reloadData()
                        }
                    }
                }
                
                selectePaymentType = (arrBankGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                
                //To Calculate Final Price After Selected payment type
                let gateWayCharge = arrBankGroup[indexPath.row - 1]["gatewayCharge"] as? Int ?? 0
                let finalCharge = self.getFinalPrice3 + gateWayCharge
                self.finalPriceSet3 = finalCharge
                print(self.finalPriceSet3)
            }
            
        case 1:
            
            if indexPath.row == 0 {
                openSectionNumber = indexPath.section
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.paymentModeTableView.reloadData()
                }) { (true) in
                    self.view.layoutIfNeeded()
                }
                
            }else {
                print(arrOtherGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                
                self.lblSelectedPaymentMode.text = (arrOtherGroup[indexPath.row - 1]["typeCode"] as? String ?? "").localized(lang: langCode)
                
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
                            
                            self.paymentTypeBankSelect = false
                            self.paymentTypeOtherSelect = true
                            self.paymentTypeWalletSelect = false
                            
                            self.selectedPaymentModeIndex = indexPath.row
                            self.paymentModeTableView.reloadData()
                        }
                    }
                }
                
                selectePaymentType = (arrOtherGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                
                //To Calculate Final Price After Selected payment type
                let gateWayCharge = arrOtherGroup[indexPath.row - 1]["gatewayCharge"] as? Int ?? 0
                let finalCharge = self.getFinalPrice3 + gateWayCharge
                self.finalPriceSet3 = finalCharge
                print(self.finalPriceSet3)
            }
            
        default:
            
            if indexPath.row == 0 {
                openSectionNumber = indexPath.section
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.paymentModeTableView.reloadData()
                }) { (true) in
                    self.view.layoutIfNeeded()
                }
                
            }else {
                print(arrWalletGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                                
                self.lblSelectedPaymentMode.text = (arrWalletGroup[indexPath.row - 1]["typeCode"] as? String ?? "").localized(lang: langCode)
                
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
                            
                            self.paymentTypeBankSelect = false
                            self.paymentTypeOtherSelect = false
                            self.paymentTypeWalletSelect = true
                            
                            self.selectedPaymentModeIndex = indexPath.row
                            self.paymentModeTableView.reloadData()
                        }
                    }
                }
                
                selectePaymentType = (arrWalletGroup[indexPath.row - 1]["typeCode"] as? String ?? "")
                
                //To Calculate Final Price After Selected payment type
                let gateWayCharge = arrWalletGroup[indexPath.row - 1]["gatewayCharge"] as? Int ?? 0
                let finalCharge = self.getFinalPrice3 + gateWayCharge
                self.finalPriceSet3 = finalCharge
                print(self.finalPriceSet3)
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
                
                //"name":CustomUserDefault.getUserName() ?? "",
                //"email":CustomUserDefault.getUserEmail() ?? "",
                //"mobile":CustomUserDefault.getPhoneNumber() ?? "",
                
                "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", 
                
                "city":CustomUserDefault.getCityId(),
                
                "name":CustomUserDefault.getEnteredUserName() ?? "",
                "email":CustomUserDefault.getEnteredUserEmail() ?? "",
                "mobile":CustomUserDefault.getEnteredPhoneNumber() ?? "",
                
                ////////////////////////////////////////////////////////////
                "productId":producdID,
                "conditionString":converComaToSemocolumForProductValues,
                "diagnosisId":userDefaults.value(forKey: "diagnosisId") as? String ?? "",
                "processMode":self.strPaymentProcessMode,
                ////////////////////////////////////////////////////////////
                
                //"remark":"",
                
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
                        
                        //Sameer 2/6/2020
                        Analytics.logEvent("purchase", parameters: ["currency" : CustomUserDefault.getCurrency(),
                                                                      "item_id" : CustomUserDefault.getProductId(),
                                                                      "item_name" : self.strProductName3 ])
                        
                        
                        let orderPlaceID = responseObject?["msg"] as? String
                        let orderID = responseObject?["orderId"] as? String
                        let itemID = responseObject?["itemId"] as? String
                        
                        let vc = TWCashVC()
                        vc.quatationId = self.quatationId3
                        vc.orderID = orderID ?? ""
                        vc.itemID = itemID ?? ""
                        vc.selectedPaymentType = self.selectePaymentType
                        
                        vc.finalPriced = self.finalPriceSet3
                        vc.placedOrderId = orderPlaceID ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        // failed
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
