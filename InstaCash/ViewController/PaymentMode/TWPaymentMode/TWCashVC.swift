//
//  TWCashVC.swift
//  InstaCash
//
//  Created by Sameer Khan on 03/05/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

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
    var itemID = String()
    var orderID = String()
    var strSelectedBankName = String()
    
    var finalPriced = 0
    var placedOrderId = String()
    
    var drop = UIDropDown()
    var responseDict = [String:Any]()
    var arrDictKeys = [Any]()
    var arrDictValues = [[Any]]()
    
    var isHtml = true
    var textBoxStr = ""
    var autoCompTextStr = ""
    var textBoxBool = false
    var autoCompTextBool = false
    var textBoxKey = ""
    var autoCompTextKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPaymentDetailsFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
        
        tableView.register(UINib(nibName: "TextBoxCell", bundle: nil), forCellReuseIdentifier: "TextBoxCell")
        tableView.register(UINib(nibName: "HtmlCell", bundle: nil), forCellReuseIdentifier: "HtmlCell")
        tableView.register(UINib(nibName: "SelectTextCell", bundle: nil), forCellReuseIdentifier: "SelectTextCell")
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
        let vc = OrderFinalVC()
        vc.orderID = placedOrderId
        vc.finalPrice = self.finalPriced
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {            //self.setPaymentDetailsFromServer()
        
        if isHtml {
            let vc = OrderFinalVC()
            vc.orderID = self.placedOrderId
            vc.finalPrice = self.finalPriced
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            if self.textBoxBool {
                if self.textBoxStr == "" {
                    Alert.showAlertWithError(strMessage: "Please Enter the details".localized(lang: langCode) as NSString, Onview: self)
                    
                    return
                }
            }
            
            if self.autoCompTextBool {
                if self.autoCompTextStr == "" {
                    Alert.showAlertWithError(strMessage: "Please Enter the details".localized(lang: langCode) as NSString, Onview: self)
                    
                    return
                }
            }
            
            self.setPaymentDetailsFromServer()
        }
        
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
            
            //"CASH"
            //"UUPON (Cash+Points)"
            //"UUPON (Points Only)"            
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "paymentCode" : selectedPaymentType, //"UUPON (Points Only)",
                "quotationId" : quatationId, //"581",
                "customerId" : CustomUserDefault.getUserId(),
                "orderItemId" : itemID, //"191",
            ]
            
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
                            
                            for (key, value) in self.responseDict {
                                //print("\(key) -> \(value)")
                                
                                self.arrDictKeys.append(key)
                                self.arrDictValues.append([value])
                            }
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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

    //MARK:- webservice Set Payment detaisl
    
    func setPaymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func setPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var jsonString = ""
            
            var info = [String:Any]()
            
            if textBoxBool {
                info[textBoxKey] = self.textBoxStr
            }
            
            if autoCompTextBool {
                info[autoCompTextKey] = self.autoCompTextStr
            }
            
//            let info = [textBoxKey : self.textBoxStr,
//                        autoCompTextKey : self.autoCompTextStr,
//                       ]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
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
            
            print(parametersHome)
            
            self.setPaymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        let vc = OrderFinalVC()
                        vc.orderID = self.placedOrderId
                        vc.finalPrice = self.finalPriced
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
    
    //MARK:- tableview Delegates methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDictValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //for item in self.responseDict {
        //let data = item.value as! [Any]
        
        let data = self.arrDictValues[indexPath.row]
        
        let arrData = data[0] as! Array<Any>
        print(arrData)
        
        if (arrData[0] as? String) == "text" {
            isHtml = false
            textBoxBool = true
            
            let cellTextBox = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell", for: indexPath) as! TextBoxCell
            
            cellTextBox.txtField.placeholder = self.arrDictKeys[indexPath.row] as? String
            cellTextBox.txtField.tag = 1
            textBoxKey = self.arrDictKeys[indexPath.row] as? String ?? ""
            cellTextBox.txtField.delegate = self
            
            return cellTextBox
            
        }else if (arrData[0] as? String) == "html" {
            
            let cellTextHtml = tableView.dequeueReusableCell(withIdentifier: "HtmlCell", for: indexPath) as! HtmlCell
            
            cellTextHtml.htmlTextView.attributedText =  (arrData[3] as? String)?.htmlToAttributedString
            
            return cellTextHtml
            
        }else if (arrData[0] as? String) == "select" {
            isHtml = false
            autoCompTextBool = true
            
            let cellTextSelect = tableView.dequeueReusableCell(withIdentifier: "SelectTextCell", for: indexPath) as! SelectTextCell
            
            cellTextSelect.autoCompTxtField.placeholder = self.arrDictKeys[indexPath.row] as? String
            cellTextSelect.autoCompTxtField.tag = 2
            autoCompTextKey = self.arrDictKeys[indexPath.row] as? String ?? ""
            cellTextSelect.autoCompTxtField.delegate = self
            
            return cellTextSelect
            
        }
        //}
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- textField Delegates methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            self.textBoxStr = textField.text ?? ""
        default:
            self.autoCompTextStr = textField.text ?? ""
        }
        
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
