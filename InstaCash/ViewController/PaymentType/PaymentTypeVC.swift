//
//  PaymentTypeVC.swift
//  InstaCash
//
//  Created by InstaCash on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore

class PaymentTypeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblViewPaymentType: UITableView!
    
    var arrPaymentType = [NSDictionary]()
    var strPaymentcode = ""
    var tableDataCount = 0
    var strLandMark = ""
    var selectedindex = -1
    var selectedBankImage = ""
    var productName = ""
    let reachability: Reachability? = Reachability()
    
    var strPaymentProcessMode = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewPaymentType.register(UINib(nibName: "PaymentTypeHeader", bundle: nil), forCellReuseIdentifier: "paymentTypeHeader")
        tblViewPaymentType.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "paymentCell")
        tblViewPaymentType.register(UINib(nibName: "PaymentTypeFooter", bundle: nil), forCellReuseIdentifier: "paymentTypeFooter")
        
        if reachability?.connection.description != "No Connection"{
            getPaymentType()
            getProcessPaymentMode()
        }
        else {
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    

    //MARK:- button action methods
    
    @objc func btnOlaceOrderPlaces() {
        if strPaymentcode == ""{
            Alert.showAlert(strMessage: "Select any payment mode".localized(lang: langCode) as NSString, Onview: self)
        }
        else {
            
            lockAndPlaceOrderApi()

        }
    }
    //MARK:- Tableview delegate/Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrPaymentType.count > 0{
            return arrPaymentType.count + 2
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 150.0
        }
        else if tableDataCount == indexPath.row {
            return 60.0
        }
        else{
            return 80.0

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "paymentTypeHeader", for: indexPath) as! PaymentTypeHeader
            let amount = userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int
//            let coupon = userDefaults.value(forKeyPath: "couponCodePrice") as? Int
//            //let pickUp =  userDefaults.value(forKeyPath: "pickupCharges") as? Int
//            let amountFinal = amount! - coupon!
            let finalAmount = amount!.formattedWithSeparator
             cellHeader.lblValue.text = CustomUserDefault.getCurrency() + finalAmount
           // cellHeader.lblValue.text = String(format: "%@%d",CustomUserDefault.getCurrency(), (userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int)!)
            cellHeader.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            return cellHeader

        }
         else if tableDataCount == indexPath.row {
            let cellFooter = tableView.dequeueReusableCell(withIdentifier: "paymentTypeFooter", for: indexPath) as! PaymentTypeFooter
            cellFooter.backgroundColor = UIColor.white
            cellFooter.btnPlaceOrder.removeTarget(self, action: #selector(self.btnOlaceOrderPlaces), for: .touchUpInside)
            cellFooter.btnPlaceOrder.addTarget(self, action: #selector(self.btnOlaceOrderPlaces), for: .touchUpInside)
            return cellFooter
            
        }
        else {
          
            let cellList = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentCell
            let dict = arrPaymentType[indexPath.row - 1]
            if selectedindex == indexPath.row{
                cellList.viewBg.backgroundColor = navColor
                cellList.lblPrice.textColor = UIColor.white
                cellList.lblPaymentType.textColor = UIColor.white
            }
            else{
                cellList.viewBg.backgroundColor = UIColor.white
                cellList.lblPrice.textColor = UIColor.darkGray
                cellList.lblPaymentType.textColor = UIColor.darkGray
            }
            let imgURL = URL(string:dict.value(forKey: "image") as! String)
            cellList.imgBankName.sd_setImage(with: imgURL)
            let str = String(format: "%.0f", (dict.value(forKey: "total") as? Double)!)
            let amount = Int(str)
            let finalAmount = amount!.formattedWithSeparator

            cellList.lblPrice.text = CustomUserDefault.getCurrency() + finalAmount//str
            cellList.lblPaymentType.text = dict.value(forKey: "typeCode") as? String

            return cellList
        }
//        cellCountry.lblCountry.text = arrCountry[indexPath.row].strName
//        let imgURL = URL(string:arrCountry[indexPath.row].strImageUrl!)
//        cellCountry.imgCountry.sd_setImage(with: imgURL)
//        if arrCountry[indexPath.row].isSelected == true{
//            cellCountry.backgroundColor = UIColor.init(red: 255.0/255.0, green: 155.0/255.0, blue: 122.0/255.0, alpha: 1.0)
//            cellCountry.lblCountry.textColor = UIColor.white
//        }
//        else{
//            cellCountry.backgroundColor = UIColor.white
//            cellCountry.lblCountry.textColor = UIColor.black
//
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 && tableDataCount != indexPath.row {
            selectedindex = indexPath.row
            let dict = arrPaymentType[indexPath.row - 1]
            strPaymentcode = (dict.value(forKey: "typeCode") as? String)!
            selectedBankImage = (dict.value(forKey: "image") as? String)!
            tblViewPaymentType.reloadData()
            
        }
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- web service methods
    
    func apiPayment(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func getPaymentType() {
        
        Alert.ShowProgressHud(Onview: self.view)
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "paymentMode"
        let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
     

        let amount = userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int
        let coupncode = userDefaults.value(forKeyPath: "couponCodePrice") as? Int
        let finalAmount = amount! - coupncode!
        
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
                if responseObject?["status"] as! String == "Success"{
                  let arrPaymentTypeData = responseObject?["msg"] as? NSArray
                    for index in 0..<arrPaymentTypeData!.count{
                        let dict = arrPaymentTypeData![index] as? NSDictionary
                        self.arrPaymentType.insert(dict!, at: index)
                    }
                    self.tableDataCount = self.arrPaymentType.count + 1
                    self.tblViewPaymentType.reloadData()
                    
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
    
    
    func getProcessPaymentMode() {
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getServices"
       
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "categoryId":"15",
            "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "" //110011
        ]
        
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            if error == nil {
                if responseObject?["status"] as! String == "Success" {
                    let strProcess = responseObject?.value(forKeyPath: "msg.process") as? String
                    let badchar = CharacterSet(charactersIn: "[]")
                    let cleanedstring = strProcess!.components(separatedBy: badchar).joined()
                    self.strPaymentProcessMode = cleanedstring
                }
                else{
                    // failed
                    
                }
                
            }
            else{
                
            }
            
        })
    }

    func lockAndPlaceOrderApi() {
        
        Alert.ShowProgressHud(Onview: self.view)
        var strValue = ""
        var userSelectedProductAppcodes = ""
        var producdID = ""
     //   var imEINumber = ""
        let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
        let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String

        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
            strValue = "STON01,"
          //  imEINumber = userDefaults.value(forKey: "imei_number") as! String
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
            
        }
        else{
         //   imEINumber = userDefaults.value(forKey: "orderOtherIMEINumber") as! String
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
            strValue = ""
            userSelectedProductAppcodes =  strValue + strQuestionAppCodes

        }
    
        let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
        let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        var strUrl = ""
        if userDefaults.value(forKey: "isPlaceOrder") as! Bool == true{
            strUrl = strBaseURL + "orderCreate"
        }
        else{
            strUrl = strBaseURL + "priceLock"
        }
        var strGCMToken = ""
        if (userDefaults.value(forKey: "FCMToken") != nil){
            strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            
        }
        else{
            strGCMToken = ""
            
        }
        let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
        //let finalAmount = String(format: "%d", (userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int)!)
        var strPromoterId = ""
        if userDefaults.value(forKey: "promoter_id") == nil {
            strPromoterId = ""
        }
        else{
            strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
        }
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "mobile":CustomUserDefault.getPhoneNumber() ?? "",
            "name":CustomUserDefault.getUserName() ?? "",
            "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "",
            "city":CustomUserDefault.getCityId(),
            "productId": producdID,
            "conditionString":converComaToSemocolumForProductValues,
            "remark" : "",
            "email" : CustomUserDefault.getUserEmail() ?? "",
            "productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String,
            "GCMId":strGCMToken,
            "pincode":userDefaults.value(forKey: "orderPinCode") as! String,
            "customerId":CustomUserDefault.getUserId(),
            "landmark": strLandMark,
            "isNewAddress":"1",
            "diagnosisId" : userDefaults.value(forKey: "diagnosisId") as! String,
            "uniqueIdentifire" :KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //+ "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //+ "~" + imEINumber,
            "paymentCode":strPaymentcode,
            "processMode":self.strPaymentProcessMode,
            "couponCode":userDefaults.value(forKey: "orderPromoCode") as! String,
            "couponAmount": couponAmount,
            "promoterId":strPromoterId
            
            //userDefaults.value(forKeyPath: "orderPinCode") as? String ?? ""
        ]
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    var currency = ""
                    //if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                    
                    if CustomUserDefault.getCurrency() == "MY" {
                        currency = "MYR"
                    }
                    //else if (userDefaults.value(forKey: "countryName") as?  String)?.contains("India") != nil {
                    else if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                        currency = "INR"
                    }
                    else{
                        currency = "SGD"
                    }
                    
                    
                    let amount = Double((userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int)!)
                    AppEventsLogger.log(
                        .purchased(
                        amount:  amount,
                            currency: currency, extraParameters: [:]))
                    Analytics.logEvent("order_placed", parameters: [
                        "event_category":"order placed for India",
                        "event_action":"order placed for India Click Action",
                        "event_label":"order placed for India Test"
                        ])
                    Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
                        AnalyticsParameterItemID: producdID,
                        AnalyticsParameterItemName: self.productName,
                        AnalyticsParameterCurrency:currency
                        ])
                    if userDefaults.value(forKey: "isShowUIOnHomeForOrder") != nil{
                        userDefaults.setValue(false, forKey: "isShowUIOnHomeForOrder")
                        userDefaults.setValue(false, forKey: "isLaterForConfirmOrder")

                    }
                    let vc = BankDetailVC()
                    vc.getDictOderCreated = (responseObject ?? [:]) as! [AnyHashable : Any] as NSDictionary
                    vc.getBankImageURL = self.selectedBankImage
                    self.navigationController?.pushViewController(vc, animated: true)
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
