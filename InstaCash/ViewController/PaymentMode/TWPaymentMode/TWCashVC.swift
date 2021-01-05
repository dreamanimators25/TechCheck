//
//  TWCashVC.swift
//  TechCheck
//
//  Created by Sameer Khan on 03/05/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TWCashVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tncTextView: UITextView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTransferDetail: UILabel!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnProceed: UIButton!
        
    let reachability: Reachability? = Reachability()
    var quatationId = String()
    var selectedPaymentType = String()
    var selectedCurrency = String()
    var itemID = String()
    var orderID = String()
    var strSelectedBankName = String()
    
    var finalPriced = 0
    var placedOrderId = String()
    
    var drop = UIDropDown()
    var arrDrop = [String]()
    
    var responseDictIN = [String:Any]()
    var responseDict = [String:Any]()
    var arrDictKeys = [Any]()
    var arrDictKeys1 = [String]()
    var arrDictValues = [[Any]]()
    
    var isHtml = true
    var setInfo = [String:String]()
    
    //India Country Case
    var totalNumberCount = 0
    var strPaymentProcessMode = "1"
    var getFinalPrice4 = 0
    var pickUpChargeGet4 = 0
    var finalPriceSet4 = 0
    var strProductName4 = ""
    var strProductImg4 = ""
    var quatationId4 = String()
    var userDetails4 = [String:Any]()
    var arrDictPaymentMode4 = [NSDictionary]()
    var selectePaymentType4 = String()
    var donation = String()
    var bankDetails = [String:Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
        
        if CustomUserDefault.getCurrency() == "£" {
            self.getPaymentStructureFromServer()
            totalNumberCount = 10
        }else {
            self.getPaymentDetailsFromServer()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeLanguageOfUI()
        
        tableView.register(UINib(nibName: "TextBoxCell", bundle: nil), forCellReuseIdentifier: "TextBoxCell")
        tableView.register(UINib(nibName: "HtmlCell", bundle: nil), forCellReuseIdentifier: "HtmlCell")
        tableView.register(UINib(nibName: "SelectTextCell", bundle: nil), forCellReuseIdentifier: "SelectTextCell")
        tableView.register(UINib(nibName: "MobileNumberCell", bundle: nil), forCellReuseIdentifier: "MobileNumberCell")
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    func changeLanguageOfUI() {
       
        self.lblTitle.text = selectedPaymentType.localized(lang: langCode)
        self.lblTransferDetail.text = "Transfer Details".localized(lang: langCode)
        //self.lblPleaseEnter.text = "Please Enter the details".localized(lang: langCode)
        
        self.btnSkip.setTitle("SKIP".localized(lang: langCode), for: UIControlState.normal)
        self.btnProceed.setTitle("PROCEED".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    //MARK:- button action methods
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        
        if CustomUserDefault.getCurrency() == "£" {
            
            let vc = UploadDocumentVC()
            vc.getFinalPrice5 = self.getFinalPrice4
            vc.pickUpChargeGet5 = self.pickUpChargeGet4
            vc.finalPriceSet5 = self.finalPriceSet4
            vc.strProductName5 = self.strProductName4
            vc.strProductImg5 = self.strProductImg4
            vc.quatationId5 = self.quatationId4
            vc.userDetails5 = self.userDetails4
            vc.arrDictPaymentMode5 = self.arrDictPaymentMode4
            vc.selectePaymentType5 = self.selectePaymentType4
            vc.donation5 = self.donation
            vc.bankDETAILS = self.bankDetails
            vc.skipOrder = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            
            let vc = OrderFinalVC()
            vc.orderID = placedOrderId
            vc.finalPrice = self.finalPriced
            vc.selectPaymentType = self.selectedPaymentType
            vc.selectCurrency = self.selectedCurrency
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {
                
        if isHtml {
            let vc = OrderFinalVC()
            vc.orderID = self.placedOrderId
            vc.finalPrice = self.finalPriced
            vc.selectPaymentType = self.selectedPaymentType
            vc.selectCurrency = self.selectedCurrency
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
            for (index,keyFld) in (arrDictKeys as! [String]).enumerated() {
                
                let data = self.arrDictValues[index]
                let arrData = data[0] as! Array<Any>
                
                if (arrData[0] as? String) == "text" {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.tableView.cellForRow(at: ndx) as! TextBoxCell
                    
                    if cell.txtField.text?.isEmpty ?? false && arrData[1] as! Int == 1 {
                        
                        Alert.showAlertWithError(strMessage: "Please Enter \(arrData[2])".localized(lang: langCode) as NSString, Onview: self)
                        
                        return
                    }else {
                        
                        setInfo[keyFld] = cell.txtField.text
                    }
                    
                }else if (arrData[0] as? String) == "html" {
                    
                    //let ndx = IndexPath(row:index, section: 0)
                    //let cell = self.tableView.cellForRow(at: ndx) as! HtmlCell
                    
                }else if (arrData[0] as? String) == "select" && arrData[1] as! Int == 1 {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.tableView.cellForRow(at: ndx) as! SelectTextCell
                    
                    if cell.selectTextField.text?.isEmpty ?? false {
                        
                        Alert.showAlertWithError(strMessage: "Please select your bank".localized(lang: langCode) as NSString, Onview: self)
                        
                        return
                    }else {
                        
                        setInfo[keyFld] = cell.selectTextField.text
                    }
                    
                }else if (arrData[0] as? String) == "mobile" && arrData[1] as! Int == 1 {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.tableView.cellForRow(at: ndx) as! MobileNumberCell
                    
                    if cell.mobileNumberTxtField.text?.isEmpty ?? false {
                        
                        Alert.showAlertWithError(strMessage: "Please enter mobile number".localized(lang: langCode) as NSString, Onview: self)
                                                
                        return
                    }else {
                        
                        setInfo[keyFld] = cell.mobileNumberTxtField.text
                    }
                    
                }
                
            }
                         
            self.bankDetails = setInfo
            
            self.setPaymentDetailsFromServer()
        }
        
    }
    
    @objc func selectBankNameButtonClicked(_ sender: UITextField) {
        let existingFileDropDown = DropDown()
        existingFileDropDown.anchorView = sender
        existingFileDropDown.cellHeight = 44
        existingFileDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        let typeOfFileArray = self.arrDrop
        existingFileDropDown.dataSource = typeOfFileArray
        
        // Action triggered on selection
        existingFileDropDown.selectionAction = { [unowned self] (index, item) in
            //sender.setTitle(item, for: .normal)
            sender.text = item
        }
        existingFileDropDown.show()
    }
   
    //MARK:- webservice Get Payment Details
    
    func paymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func getPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "getPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "paymentCode" : selectedPaymentType,
                "quotationId" : quatationId,
                "customerId" : CustomUserDefault.getUserId(),
                "orderItemId" : itemID,
            ]
            
            
//            let parametersHome : [String : Any] = [
//                "userName" : apiAuthenticateUserName,
//                "apiKey" : key,
//                "paymentCode" : "Ashita", //"Switch", //selectedPaymentType,
//                "quotationId" : "276023", //quatationId,
//                "customerId" : "58749", //CustomUserDefault.getUserId(),
//                "orderItemId" : "12126", //itemID,
//            ]
                    
            print(strUrl)
            print(parametersHome)
            
            self.paymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        if ((responseObject?.value(forKey: "paymentStructure") as? NSDictionary) == nil) {
                            let vc = OrderFinalVC()
                            vc.orderID = self.placedOrderId
                            vc.finalPrice = self.finalPriced
                            vc.selectPaymentType = self.selectedPaymentType
                            vc.selectCurrency = self.selectedCurrency
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            //let actualHTML = ((responseObject?.value(forKey: "msg") as! NSDictionary)["html"] as! NSArray)[3] as? String
                            //self.tncTextView.attributedText = actualHTML?.htmlToAttributedString
                            
                            /*
                            if let actualHTMLArray = ((responseObject?.value(forKey: "msg") as! NSDictionary)["html"] as? NSArray) {
                                self.tncTextView.attributedText =  (actualHTMLArray[3] as? String)?.htmlToAttributedString
                            }else {
                                let vc = OrderFinalVC()
                                vc.orderID = self.placedOrderId
                                vc.finalPrice = self.finalPriced
                                self.navigationController?.pushViewController(vc, animated: true)
                            }*/
                            
                            self.responseDict = (responseObject?.value(forKey: "paymentStructure") as? [String:Any] ?? [:])
                            
                            //print(self.responseDict)
                            
                            for (ind,item) in (responseObject?.value(forKey: "paymentStructure") as? [String:Any] ?? [:]).enumerated() {
                                print(ind)
                                //print(item)
                                
                                self.arrDictKeys1.append(item.key)
                                //self.arrDictKeys.append(item.key)
                                //self.arrDictValues.append([item.value])
                                
                                if item.key == "Bank Name" {
                                    let arr = (item.value as! NSArray)[3] as? [String]
                                    
                                    self.arrDrop = arr ?? []
                                    self.drop.options = self.arrDrop
                                }
                            }
                            
                            self.arrDictKeys = self.arrDictKeys1.sorted()
                            //print(self.arrDictKeys)
                            
                            
                            for item in self.arrDictKeys {
                                let val = self.responseDict[item as? String ?? ""]
                                self.arrDictValues.append([val ?? []])
                            }
                            
                            if CustomUserDefault.getCurrency() == "NT$" {
                                self.arrDictValues = self.arrDictValues.reversed()
                                self.arrDictKeys = self.arrDictKeys.reversed()
                            }

                            //print(self.arrDictKeys)
                            //print(self.arrDictValues)
                            
//                            for (key, value) in self.responseDict {
//                                //print("\(key) -> \(value)")
//
//                                self.arrDictKeys.append(key)
//                                self.arrDictValues.append([value])
//
//                                if key == "Bank Name" {
//                                    let arr = (value as! NSArray)[3] as! [String]
//
//                                    self.arrDrop = arr
//                                    self.drop.options = self.arrDrop
//                                }
//                            }
                            
                            //self.tableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
//                                if self.arrDictKeys.count > 7 {
//                                    self.tableView.isScrollEnabled = true
//                                }else {
//                                    self.tableView.isScrollEnabled = false
//                                }
                                
                                self.tableView.dataSource = self
                                self.tableView.delegate = self
                                self.tableView.tableFooterView = UIView()
                            }
                                
                        }
                       
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
    
    //MARK:- webservice GetPaymentStructure
    
    func paymentStructureApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func getPaymentStructureFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "getPaymentStructure"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "paymentCode" : selectePaymentType4,
                "quotationId" : quatationId4,
            ]
            
            print(parametersHome)
            
            self.paymentStructureApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        self.responseDictIN = (responseObject?["msg"] as? NSDictionary) as? [String : Any] ?? [:]
                        
                        if ((responseObject?.value(forKey: "paymentStructure") as? NSDictionary) == nil) {
                            
                            let vc = UploadDocumentVC()
                            vc.getFinalPrice5 = self.getFinalPrice4
                            vc.pickUpChargeGet5 = self.pickUpChargeGet4
                            vc.finalPriceSet5 = self.finalPriceSet4
                            vc.strProductName5 = self.strProductName4
                            vc.strProductImg5 = self.strProductImg4
                            vc.quatationId5 = self.quatationId4
                            vc.userDetails5 = self.userDetails4
                            vc.arrDictPaymentMode5 = self.arrDictPaymentMode4
                            vc.selectePaymentType5 = self.selectePaymentType4
                            vc.donation5 = self.donation
                            vc.bankDETAILS = self.bankDetails
                            vc.skipOrder = true
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            
                            self.responseDict = (responseObject?.value(forKey: "paymentStructure") as? [String:Any] ?? [:])
                            
                            //print(self.responseDict)
                            
                            for (ind,item) in (responseObject?.value(forKey: "paymentStructure") as? [String:Any] ?? [:]).enumerated() {
                                print(ind)
                                //print(item)
                                
                                self.arrDictKeys1.append(item.key)
                                //self.arrDictKeys.append(item.key)
                                //self.arrDictValues.append([item.value])
                                
                                if item.key == "Bank Name" {
                                    let arr = (item.value as! NSArray)[3] as? [String]
                                    
                                    self.arrDrop = arr ?? []
                                    self.drop.options = self.arrDrop
                                }
                            }
                            
                            self.arrDictKeys = self.arrDictKeys1.sorted()
                            //print(self.arrDictKeys)
                            
                            
                            for item in self.arrDictKeys {
                                let val = self.responseDict[item as? String ?? ""]
                                self.arrDictValues.append([val ?? []])
                            }
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
//                                if self.arrDictKeys.count > 7 {
//                                    self.tableView.isScrollEnabled = true
//                                }else {
//                                    self.tableView.isScrollEnabled = false
//                                }
                                
                                self.tableView.dataSource = self
                                self.tableView.delegate = self
                                self.tableView.tableFooterView = UIView()
                            }
                            
                        }
                        
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
    
    //MARK:- tableview Delegates methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDictValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = self.arrDictValues[indexPath.row]
        
        let arrData = data[0] as? Array<Any>
        
        if (arrData?[0] as? String) == "text" {
            
            isHtml = false
            
            let cellTextBox = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell", for: indexPath) as! TextBoxCell
            
            cellTextBox.txtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)?.localized(lang: langCode)
            cellTextBox.txtField.tag = indexPath.row
            cellTextBox.txtField.delegate = self
            
            if CustomUserDefault.getCurrency() == "£" {
                
                if (self.arrDictKeys[indexPath.row] as? String) == "Bank Branch" {
                    cellTextBox.txtField.isUserInteractionEnabled = false
                }
                
            }else {
                cellTextBox.txtField.layer.cornerRadius = 5.0
                cellTextBox.txtField.layer.borderWidth = 1.0
                cellTextBox.txtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
                cellTextBox.seperatorLbl.backgroundColor = .clear
            }
            
            return cellTextBox
            
        }else if (arrData?[0] as? String) == "html" {
            
            self.tableView.isScrollEnabled = true
                        
            let cellTextHtml = tableView.dequeueReusableCell(withIdentifier: "HtmlCell", for: indexPath) as! HtmlCell
            
            cellTextHtml.htmlTextView.attributedText =  (arrData?[3] as? String)?.htmlToAttributedString
            
            return cellTextHtml
            
        }else if (arrData?[0] as? String) == "select" {
            
            isHtml = false
            
            let cellTextSelect = tableView.dequeueReusableCell(withIdentifier: "SelectTextCell", for: indexPath) as! SelectTextCell
            
            cellTextSelect.selectTextField.tag = indexPath.row
            cellTextSelect.selectTextField.placeholder = (self.arrDictKeys[indexPath.row] as? String)?.localized(lang: langCode)
            cellTextSelect.selectTextField.addTarget(self, action: #selector(selectBankNameButtonClicked(_:)), for: .editingDidBegin)
            
            
            return cellTextSelect
            
        }else if (arrData?[0] as? String) == "mobile" {
            
            isHtml = false
            
            let cellMobNum = tableView.dequeueReusableCell(withIdentifier: "MobileNumberCell", for: indexPath) as! MobileNumberCell
            
            if let imgURL = URL.init(string: self.responseDictIN["paymentImage"] as? String ?? "") {
                cellMobNum.paymentImgView.sd_setImage(with: imgURL)
            }
            
            if CustomUserDefault.getCurrency() == "£" {
            
            }else {
                cellMobNum.mobileNumberTxtField.layer.cornerRadius = 5.0
                cellMobNum.mobileNumberTxtField.layer.borderWidth = 1.0
                cellMobNum.mobileNumberTxtField.layer.borderColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
                cellMobNum.seperatorLbl.backgroundColor = .clear
            }
            
            cellMobNum.mobileNumberTxtField.placeholder = (self.arrDictKeys[indexPath.row] as? String)?.localized(lang: langCode)
            cellMobNum.mobileNumberTxtField.tag = indexPath.row
            cellMobNum.mobileNumberTxtField.delegate = self
            
            return cellMobNum
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- UITextField Delegates methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if CustomUserDefault.getCurrency() == "£" {
            
            if textField.placeholder == "IFSC" {
                let ndx = IndexPath(row:textField.tag, section: 0)
                let cell = self.tableView.cellForRow(at: ndx) as! TextBoxCell
                
                if cell.txtField.text?.isEmpty ?? false {
                    
                    Alert.showAlertWithError(strMessage: "Enter valid IFSC Code".localized(lang: langCode) as NSString, Onview: self)
                    
                    return
                }else {
                    
                    self.razorpayApiCheckFromServer(txtFValue: cell.txtField.text ?? "")
                }
            }
                       
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*
        if CustomUserDefault.getCurrency() == "£" {
            
            for (index,_) in (arrDictKeys as! [String]).enumerated() {
                
                let data = self.arrDictValues[index]
                let arrData = data[0] as! Array<Any>
                
                if (arrData[0] as? String) == "mobile" {
                    
                    let ndx = IndexPath(row:index, section: 0)
                    let cell = self.tableView.cellForRow(at: ndx) as! TextBoxCell
                    
                    if textField == cell.txtField {
                        // YOU SHOULD FIRST CHECK FOR THE BACKSPACE. IF BACKSPACE IS PRESSED ALLOW IT
                        
                        if string == "" {
                            return true
                        }
                        
                        if let characterCount = textField.text?.count {
                            // CHECK FOR CHARACTER COUNT IN TEXT FIELD
                            if characterCount == totalNumberCount {
                                // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                                return textField.resignFirstResponder()
                            }
                        }
                    }
                }
            }
        }*/
        return true
    }
    
    //MARK:- webservice Set Payment details
    
    func setPaymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),completionHandler: completionHandler)
    }
    
    func setPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var jsonString = ""
            
            let jsonData = try! JSONSerialization.data(withJSONObject: setInfo, options:[])
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                "orderItemId" : self.orderID,
                "paymentInformation" : jsonString,
                "isOffer" : "1",
                "paymentCode": selectedPaymentType,
            ]
            
            print(strUrl)
            print(parametersHome)
            
            self.setPaymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        if CustomUserDefault.getCurrency() == "£" {
                            
                            self.fetchOrderFromServer(isRefreshPrice: true) //Scenario Change
                            
                        }else {
                            
                            let vc = OrderFinalVC()
                            vc.orderID = self.placedOrderId
                            vc.finalPrice = self.finalPriced
                            vc.selectPaymentType = self.selectedPaymentType
                            vc.selectCurrency = self.selectedCurrency
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                                                
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
    
    //MARK:- webservice Razorpay Api
    
    func razorPayApiGet(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let web = WebServies()
        web.getRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func razorpayApiCheckFromServer(txtFValue:String) {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            //let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = "https://ifsc.razorpay.com/\(txtFValue)"
            print(strUrl)
            
            self.razorPayApiGet(strURL: strUrl, parameters: [:], completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil && responseObject != nil {
                    
                    //self.txtBranch.text = responseObject?["BRANCH"] as? String
                    
                    for (index,keyFld) in (self.arrDictKeys as! [String]).enumerated() {
                        
                        let data = self.arrDictValues[index]
                        let arrData = data[0] as! Array<Any>
                        
                        if (arrData[0] as? String) == "text" && keyFld == "Bank Branch" {
                            
                            let ndx = IndexPath(row:index, section: 0)
                            let cell = self.tableView.cellForRow(at: ndx) as! TextBoxCell
                            
                            cell.txtField.text = responseObject?["BRANCH"] as? String
                            
                        }
                        
                    }
                    
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "oops,something went wrong".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    //MARK:- webservice orderCreate
    
    func orderCreateApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(isRefreshPrice:Bool) {
        
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
            
            /*
            var smallParam = ["IMEINumber" : KeychainWrapper.standard.string(forKey: "UUIDValue") ?? "",
                              "name" : userDetails4["name"] ?? "",
                              "email" : userDetails4["email"] ?? "",
                              "mobile" : userDetails4["mobile"] ?? "",
                              "address1" : userDetails4["address1"] ?? "",
                              "address2" : userDetails4["address1"] ?? "",
                              "pincode" : userDetails4["pincode"] ?? "",
                              "city" : userDetails4["city"] ?? "",
                              "paymentType" : selectePaymentType4,
            ]
            
            smallParam["Account_Holders_Name"] = txtAccountHolderName.text ?? ""
            smallParam["Bank_Name"] = txtBankName.text ?? ""
            smallParam["Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["Confirm_Account_Number"] = txtAccountNumber.text ?? ""
            smallParam["IFSC"] = txtIfsc.text ?? ""
            
            smallParam["type"] = "createOrder"
            smallParam["isNewAddress"] = "1"
            //smallParam["donateTo"] = "NSS"
            //smallParam["donateAmount"] = "31"
            
            if donation == "" {
                smallParam["donateTo"] = ""
                smallParam["donateAmount"] = ""
            }else {
                smallParam["donateTo"] = "NSS"
                smallParam["donationAmount"] = donation
            }*/
            
            var parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName, //1
                "apiKey" : key, //1
                
                //"name":CustomUserDefault.getUserName() ?? "", //1
                //"email":CustomUserDefault.getUserEmail() ?? "", //0
                //"mobile":CustomUserDefault.getPhoneNumber() ?? "", //1
                
                "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", //1
                
                "city":CustomUserDefault.getCityId(), //1
                
                "name":CustomUserDefault.getEnteredUserName() ?? "",
                "email":CustomUserDefault.getEnteredUserEmail() ?? "",
                "mobile":CustomUserDefault.getEnteredPhoneNumber() ?? "",
                
                ////////////////////////////////////////////////////////////
                "productId":producdID, //1
                "conditionString":converComaToSemocolumForProductValues, //1
                "diagnosisId":userDefaults.value(forKey: "diagnosisId") as! String, //1
                "processMode":self.strPaymentProcessMode, //1
                ////////////////////////////////////////////////////////////
                
                //"remark":"", //0
                
                //"productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String, //0
                //"GCMId":strGCMToken, //0
                "customerId":CustomUserDefault.getUserId(), //0
                //"landmark":"", //0
                "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "", //1
                "isNewAddress":"1", //0
                
                "uniqueIdentifire":KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //1
                "paymentCode": selectePaymentType4, //1
                
                "couponCode":userDefaults.value(forKey: "orderPromoCode") as? String ?? "", //1
                "couponAmount":couponAmount, //1
                "promoterId":strPromoterId, //0
                
                //"paymentDetails" : smallParam,
                "donateTo" : "NSS",
                "donationAmount" : donation,
                
                "quotationId":quatationId4, //0
                "preferredDate":"", //0
                "preferredTime":"", //0
                //"additionalInformation":"", //0
            ]
            
            if let addInfo = userDefaults.value(forKey: "additionalInfo") {
                parametersHome["additionalInformation"] = addInfo
            }
            
            print(parametersHome)
            print(strUrl)
            
            self.orderCreateApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                       
                        //Sameer 2/6/2020
                        Analytics.logEvent("purchase", parameters: ["currency" : CustomUserDefault.getCurrency(),
                                                                      "item_id" : CustomUserDefault.getProductId(),
                                                                      "item_name" : self.strProductName4 ])
                        
                        
                        let orderPlaceID = responseObject?["msg"] as? String
                        
                        //*
                         //let itemID = responseObject?["itemId"] as! String
                        if let orderID = responseObject?["orderId"] as? String {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = orderID
                            vc.getFinalPrice5 = self.getFinalPrice4
                            vc.placedOrderId = orderPlaceID ?? ""
                            vc.skipOrder = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = ""
                            vc.getFinalPrice5 = self.getFinalPrice4
                            vc.placedOrderId = orderPlaceID ?? ""
                            vc.skipOrder = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                         //*/
                        
                        
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
