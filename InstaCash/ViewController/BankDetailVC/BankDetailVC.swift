//
//  BankDetailVC.swift
//  InstaCash
//
//  Created by InstaCash on 24/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FacebookCore
import Firebase

class BankDetailVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnSaveChanges: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTokenNumber: UILabel!
    
    var getDictOderCreated = NSDictionary()
    var getBankImageURL = ""
    var dicBankDetail = NSDictionary()
    var arrUiComponents = [BankDetailUIModel]()
    let reachability: Reachability? = Reachability()
    var arrDeafaultBankValue = NSArray()
    var strSelectedDeafaultValue = ""
    var arrTextField = [UITextField]()
    var parameters: NSMutableDictionary = [:]
    var isComingFromOrderList = false
    var getIdFromOrderList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        //setViewDynamic()
        
        if reachability?.connection.description != "No Connection" {
            getUIComponentsToCreateUIDynamic()
        }
        else{
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }

    }

    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "Bank Detail".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(BankDetailVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    @objc func btnBackPressed() -> Void {
        if isComingFromOrderList{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            pushToSucessPage()
        }
    }
    
    func pushToSucessPage(){
        let vc  = FillDetailLater()
        vc.strGetUserID = getDictOderCreated.value(forKey: "msg") as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSaveChngesPressed(_ sender: UIButton) {
        let allTextFiled = view.allSubViewsOf(type: UITextField.self)
        DispatchQueue.main.async {
            let alertBox = UIAlertController(title: "Are You Sure".localized(lang: langCode), message:"This would overwrite the payment details.Are you sure you want to continue?".localized(lang: langCode), preferredStyle: UIAlertControllerStyle.alert)
            
            let cancel = UIAlertAction(title:"No".localized(lang: langCode), style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Yes".localized(lang: langCode), style: UIAlertActionStyle.destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.reachability?.connection.description != "No Connection"{
                    
                    
                    //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                        
                    if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                        
                    for obj in 0..<allTextFiled.count{
                        let model =  self.arrUiComponents[obj]
                        let txt = allTextFiled[obj]
                        if obj < allTextFiled.count{
                            if txt.placeholder == model.strPlaceHolder{
                                if (txt.text?.isEmpty)!{
                                    let strMessage  = "Please Enter ".localized(lang: langCode) + model.strKeyName
                                    Alert.showAlert(strMessage: strMessage as NSString, Onview: self)
                                    return
                                }
                                self.parameters.setValue(txt.text, forKey: model.strKeyName)
                            }
                        }
                        else{
                        }
                    }
                }
                     else{
                        var arrRemoveSelectTypeUI = [BankDetailUIModel]()
                        var count = -1
                        for i in 0..<self.arrUiComponents.count{
                            let model = self.arrUiComponents[i]
                            if model.strUIType != "select"{
                                count = count + 1
                                arrRemoveSelectTypeUI.insert(model, at: count)
                            }
                            else{
                                if self.strSelectedDeafaultValue == ""{
                                    Alert.showAlert(strMessage: model.strKeyName as NSString, Onview: self)
                                    return
                                }
                            }
                            
                        }
                        for obj in 0..<arrRemoveSelectTypeUI.count{
                            let model =  arrRemoveSelectTypeUI[obj]
                            let txt = allTextFiled[obj]
                            if obj < allTextFiled.count{
                                if txt.placeholder == model.strPlaceHolder{
                                    if (txt.text?.isEmpty)!{
                                        let strMessage  = "Please Enter ".localized(lang: langCode) + model.strKeyName
                                        Alert.showAlert(strMessage: strMessage as NSString, Onview: self)
                                        return
                                    }
                                    self.parameters.setValue(txt.text, forKey: model.strKeyName)
                                }
                            }
                            else{
                            }
                        }
                    }
                    
                    //                    for index in 0..<allTextFiled.count{
                    //                        let modelFinal =  self.arrUiComponents[index]
                    //                        let txt = allTextFiled[index]
                    //                        let strKey = modelFinal.strKeyName
                    //                        print(strKey)
                    //
                    //
                    //                    }
//                    if !(userDefaults.value(forKey: "countryName") as! String).contains("India"){
//                        if self.strSelectedDeafaultValue.isEmpty{
//                            Alert.showAlert(strMessage: "please enter Bank Name", Onview: self)
//                            return
//                        }
                   // }
                    self.saveBankDetails()
                    
                    
                }
                else{
                    Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
                    
                }
            })
            alertBox.addAction(okAction)
            alertBox.addAction(cancel)
            
            self.present(alertBox, animated: true, completion: nil)
        }
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            let alertBox = UIAlertController(title: "Are You Sure".localized(lang: langCode), message:"This would reject all the changes made so far. Are you sure you want to discard all the changes?".localized(lang: langCode), preferredStyle: UIAlertControllerStyle.alert)
            
            let cancel = UIAlertAction(title:"No".localized(lang: langCode), style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Yes".localized(lang: langCode), style: UIAlertActionStyle.destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if self.isComingFromOrderList{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.pushToSucessPage()
                }
            })
            alertBox.addAction(okAction)
            alertBox.addAction(cancel)
            
            self.present(alertBox, animated: true, completion: nil)
        }
    }
    
    //MARK:- setview dynamically
    func setViewDynamic(){
        lblDate.text = getDictOderCreated.value(forKey: "timeStamp") as? String
        lblTokenNumber.text = getDictOderCreated.value(forKey: "msg") as? String
        let imgURLBank = URL(string:getBankImageURL)
        imgBank.sd_setImage(with: imgURLBank)
        
        var topConstraint:CGFloat = 0.0
        topConstraint = self.imgBank.frame.origin.y + 120
        for obj in 0..<arrUiComponents.count{
            let model = arrUiComponents[obj]
            let lblTitle = UILabel()
            lblTitle.frame = CGRect(x: 10, y: topConstraint - 10, width: screenWidth - 10, height: 15)
            lblTitle.text = model.strPlaceHolder
            lblTitle.textColor = UIColor.darkGray
            //                lblTitle.font = lblTitle.font.withSize(12)
            mainView.addSubview(lblTitle)
            topConstraint = topConstraint + lblTitle.frame.size.height
            
            if model.strUIType == "select"{
                let btnTransParent = UIButton()
                btnTransParent.frame = CGRect(x: 10, y: topConstraint, width: screenWidth - 20, height: 35)
                btnTransParent.backgroundColor = UIColor.red
                btnTransParent.setTitle(model.strValue, for: .normal)
                btnTransParent.setTitleColor(UIColor.darkGray, for: .normal)
                btnTransParent.contentHorizontalAlignment = .left
                btnTransParent.backgroundColor = UIColor.clear
                btnTransParent.addTarget(self, action: #selector(self.btnDropDownListPressed), for: .touchUpInside)
                mainView.addSubview(btnTransParent)
                //                    let imgArrow = UIImageView()
                //                    imgArrow.frame = CGRect(x: btnTransParent.frame.size.width - 40 , y: btnTransParent.frame.size.height/2 - 9, width: 18, height: 18)
                //                    imgArrow.image = UIImage(named: "downArrow")
                //                    btnTransParent.addSubview(imgArrow)
                topConstraint = topConstraint + btnTransParent.frame.size.height + 2
                
            }
            else{
                let txtFieled = UITextField()
                txtFieled.delegate = self
                txtFieled.frame = CGRect(x: 10, y: topConstraint, width: screenWidth - 20, height: 35)
                
                if model.strPlaceHolder == "Account Number"{
                    txtFieled.keyboardType = .numberPad
                }
                else{
                    txtFieled.keyboardType = .default
                }
                txtFieled.textColor = UIColor.darkGray
                txtFieled.placeholder = model.strPlaceHolder
                txtFieled.text = model.strValue
                txtFieled.borderStyle = .none
                mainView.addSubview(txtFieled)
                topConstraint = topConstraint + txtFieled.frame.size.height + 2
            }
            
            let lblLine = UILabel()
            lblLine.frame = CGRect(x: 10, y: topConstraint, width: screenWidth - 20, height: 1)
            lblLine.backgroundColor = UIColor.lightGray
            mainView.addSubview(lblLine)
            topConstraint = topConstraint + lblLine.frame.size.height + 30
            
        }
        mainViewHeightConstraint.constant = topConstraint + 120
    }
    
    
    //MARK:- buton action methods
    @IBAction func btnFillDetailLaterPressed(_ sender: UIButton) {
        if isComingFromOrderList{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            pushToSucessPage()
        }
    }
    
    @objc func btnDropDownListPressed(sender:UIButton){
        ActionSheetMultipleStringPicker.show(withTitle: "Title".localized(lang: langCode), rows: [arrDeafaultBankValue], initialSelection: [0, 0], doneBlock: {
            picker, values, indexes in
            let numIndex = values![0]
            let finalIndex = Int((numIndex as! Int).description)
            let strTitle = self.arrDeafaultBankValue[finalIndex!]
            self.strSelectedDeafaultValue = strTitle as! String
            sender.setTitle(strTitle as? String, for: .normal)
            sender.setTitleColor(UIColor.darkGray, for: .normal)
            sender.titleLabel?.textAlignment = .left
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    //MARK:- web service methods
    
    func apiPayment(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func getUIComponentsToCreateUIDynamic() {
        Alert.ShowProgressHud(Onview: self.view)
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl =  strBaseURL + "getPaymentDetails"
        var strFinalOrderId = ""
        if isComingFromOrderList{
            strFinalOrderId = getIdFromOrderList
        }
        else{
            strFinalOrderId = getDictOderCreated.value(forKey: "itemId") as? String ?? ""
        }
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "orderItemId":strFinalOrderId,
            "customerId":CustomUserDefault.getUserId()
        ]
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    let dict = responseObject?.value(forKey: "paymentStructure") as? NSDictionary
                    // Get array of keys
                    if dict?.allKeys.count ?? 0 > 0{
                        let keys = Array(dict!.allKeys)
                        for index in 0..<keys.count{
                            let keyValue = keys[index] as! String
                            if (dict![keyValue] != nil){
                                if dict!.object(forKey: keyValue)  is NSArray{
                                    let arrData = dict!.object(forKey: keyValue) as! NSArray
                                    let model = BankDetailUIModel()
                                    if arrData[0] as! String == "select"{
                                        model.strKeyName = keyValue
                                        model.strUIType = arrData[0] as! String
                                        model.mandatory = arrData[1] as! Int
                                        model.strPlaceHolder = arrData[2] as! String
                                        model.strValue = arrData[4] as! String
                                        self.arrDeafaultBankValue = arrData[3] as! NSArray
                                    }
                                    else{
                                        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                                            
                                        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                                            
                                            model.strKeyName = keyValue
                                            model.strUIType = arrData[0] as! String
                                            model.mandatory = arrData[1] as! Int
                                            model.strPlaceHolder = arrData[3] as! String
                                            model.strValue = arrData[2] as! String
                                        }
                                        else{
                                            model.strKeyName = keyValue
                                            model.strUIType = arrData[0] as! String
                                            model.mandatory = arrData[1] as! Int
                                            model.strPlaceHolder = arrData[2] as! String
                                            model.strValue = arrData[3] as! String
                                        }
                                    }
                                    self.arrUiComponents.insert(model, at: index)
                                }
                                
                            }
                            
                        }
                        
                        if self.arrUiComponents.count > 0{
                            self.setViewDynamic()
                            self.lblProductName.text = responseObject?.value(forKeyPath: "msg.productName") as? String
                            let amount = (responseObject!.value(forKeyPath: "msg.amount") as? Int)
                            let strFinalAmount =  amount?.formattedWithSeparator
                            self.lblPrice.text =  CustomUserDefault.getCurrency() + strFinalAmount!
                            var orderItemId = ""
                            if self.isComingFromOrderList{
                                orderItemId = self.getIdFromOrderList
                            }
                            else{
                                orderItemId = self.getDictOderCreated.value(forKey: "itemId") as? String ?? ""
                            }
                            AppEventsLogger.log(
                                .addedToCart(
                                    contentType: self.lblProductName.text,
                                    contentId: orderItemId,
                                    currency: "INR"))
                            Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
                                AnalyticsParameterItemID: orderItemId,
                                AnalyticsParameterItemName: self.lblProductName.text ?? "",
                                AnalyticsParameterCurrency:"INR"
                                ])
                            
                        }
                    }
                    else{
                        self.pushToSucessPage()
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
    
    func saveBankDetails() {
        Alert.ShowProgressHud(Onview: self.view)
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "setPaymentDetails"
        
       // if !(userDefaults.value(forKey: "countryName") as! String).contains("India"){
            parameters.setValue(strSelectedDeafaultValue, forKey: "Bank Name")
     //   }
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options:[])
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        var orderItemId = ""
        if isComingFromOrderList{
            orderItemId = getIdFromOrderList
        }
        else{
            orderItemId = getDictOderCreated.value(forKey: "itemId") as? String ?? ""
        }
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "customerId":CustomUserDefault.getUserId(),
            "orderItemId": orderItemId,
            "paymentInformation":jsonString
        ]
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    if self.isComingFromOrderList{
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.pushToSucessPage()
                    }
                }
                else{
                    // failed
                    Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                }
                
            }
            else{
                // self.pushToSucessPage()
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

extension UIView {
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
