//
//  MisMatchVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 26/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//


import UIKit
import SwiftyJSON
import SystemServices

class MisMatchVC: UIViewController {

    @IBOutlet weak var activityCancel: UIActivityIndicatorView!
    @IBOutlet weak var activityAgree: UIActivityIndicatorView!
    @IBOutlet weak var lblResultMisMatch: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var ResultBaseView: UIView!
    
    @IBOutlet weak var lblConditionString: UILabel!
    @IBOutlet weak var lblOldCond: UILabel!
    @IBOutlet weak var lblNewCond: UILabel!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    let reachability: Reachability? = Reachability()
    var resultJSONGet = JSON()
    var strDiagnosisFailed = ""
    var strAppCodes = ""
    var strDiagnosisId = ""
    var strDiagnosisIdOnPickUp = ""
    var strConditionString = ""
    var returnDictionary : NSMutableDictionary = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblConditionString.text = "Conditional Mismatch Found!".localized(lang: langCode)
        self.lblOldCond.text = "Old Condition".localized(lang: langCode)
        self.lblNewCond.text = "New Condition".localized(lang: langCode)
        
        self.btnAgree.setTitle("Swipe Here To Agree With Price".localized(lang: langCode), for: UIControlState.normal)
        self.btnCancel.setTitle("Swipe Here To Cancel This Order".localized(lang: langCode), for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblOldCond.isHidden = true
        self.lblNewCond.isHidden = true
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            
            btnCancel.setTitle("Swipe Here To Disagree This Order".localized(lang: langCode), for: .normal)
        }
        else{
            btnCancel.setTitle("Swipe Here To Cancel This Order".localized(lang: langCode), for: .normal)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
            //"pickupDiagnose"
            
            if userDefaults.value(forKey: "pickupDiagnose") as? String == "pickupDiagnose" {
                self.fireWebServiceForMatchingDataForDiagnoseOnPickUp()
            }else {
                self.fireWebServiceForMetchingDataForPickUp()
            }
            
        }
        else {
            fireWebServiceForMetchingData()
        }
    }
    
    //MARK:- APi for verification code
    func mismatchPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForMetchingData()
    {
        if reachability?.connection.description != "No Connection" {
            
            createReturnDictForDiagnosisMisMatch()
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            
            let returnMetaDetails : NSMutableDictionary = [:]
            
            var parameters = [String: Any]()
            
            strUrl = strBaseURL + "storeDiagnosisData"
            
            let deviceName  = UIDevice.current.modelName as String
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
            returnMetaDetails.setValue(KeychainWrapper.standard.string(forKey: "UUIDValue")!, forKey: "UUDIDValue")
            returnMetaDetails.setValue(SystemSharedServices.fullyCharged, forKey: "BattaryFullyCharged")
            
            if SystemSharedServices.jailbroken == 4783242 {
                returnMetaDetails.setValue("No", forKey: "JailBroken")
            }
            else{
                returnMetaDetails.setValue("YES", forKey: "JailBroken")
            }
           
            let jsonData = try! JSONSerialization.data(withJSONObject: returnMetaDetails, options:[])
            let jsonStringforMetaDetails = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let jsonData1 = try! JSONSerialization.data(withJSONObject: returnDictionary, options:[])
            
            let jsonStringforMetaDetails1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
            let strFinalCodeValues = strDiagnosisFailed.replacingOccurrences(of: ",,", with: ",")
            let converComaToSemocolum = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
            //let converComaToSemocolum = "STON01;" + strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "resultJson": jsonStringforMetaDetails1,
                "metaDetails":jsonStringforMetaDetails,
                "IMEINumber":KeychainWrapper.standard.string(forKey: "UUIDValue")!,//(userDefaults.value(forKeyPath: "imei_number") as? String)!,
                "customerId":CustomUserDefault.getUserId(),
                "appCode":converComaToSemocolum,
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as? String ?? ""
            ]
            
            print(parameters)
            
            self.mismatchPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
               
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        if responseObject?["match"] as! String == "true" {
                            
                            // show popup
                            self.lblPrice.isHidden = true
                            self.lblResultMisMatch.isHidden = true
                            self.lblConditionString.isHidden = true
                            self.btnAgree.isHidden = true
                            self.btnCancel.isHidden = true
                            
                            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message: "Daignosis successfully completed!".localized(lang: langCode), preferredStyle: .alert)
                            
                            let sendButton = UIAlertAction(title: "OK".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                                
                                obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                            })
                            
                            alertController.addAction(sendButton)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            
                            let swipeAgreeButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnAgreePressed))
                            swipeAgreeButton.direction = .right
                            self.btnAgree.addGestureRecognizer(swipeAgreeButton)
                            
                            let swipeCancelButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnCancelPressed))
                            swipeCancelButton.direction = .right
                            self.btnCancel.addGestureRecognizer(swipeCancelButton)
                            
                            self.lblPrice.isHidden = false
                            self.lblResultMisMatch.isHidden = false
                            self.lblConditionString.isHidden = false
                            self.btnAgree.isHidden = false
                            self.btnCancel.isHidden = false
                            self.strDiagnosisId = responseObject?["msg"] as? String ?? ""
                            self.strConditionString = responseObject?["newConditionString"] as? String ?? ""
                            let amount = responseObject?["newAmount"] as? Int64
                            let strAmountfinal = String(format: "%d", amount ?? 0)
                            self.lblPrice.text = "New Price:- ".localized(lang: langCode) + CustomUserDefault.getCurrency() + strAmountfinal
                            let resultData = responseObject?["compareData"] as? String ?? ""

                            /*
                            let data = Data(resultData.utf8)
                            
                            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                
                                self.lblResultMisMatch.attributedText = attributedString
                                
                                self.lblOldCond.isHidden = false
                                self.lblNewCond.isHidden = false
                                
                                DispatchQueue.main.async {
                                    self.ResultBaseView.layer.borderWidth = 1.0
                                    self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                }
                                
                            }*/
                            
                            
                            let data = Data(resultData.utf8)
                            
                            let options = [
                                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                ] as [NSAttributedString.DocumentReadingOptionKey : Any]
                            
                            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                                self.lblResultMisMatch.attributedText = attributedString
                                
                                self.lblOldCond.isHidden = false
                                self.lblNewCond.isHidden = false
                                
                                DispatchQueue.main.async {
                                    self.ResultBaseView.layer.borderWidth = 1.0
                                    self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                }
                                
                            }
                            
                        }
                        
                    }
                    else{
                        
                        // show popup
                        self.lblPrice.isHidden = true
                        self.lblResultMisMatch.isHidden = true
                        self.lblConditionString.isHidden = true
                        self.btnAgree.isHidden = true
                        self.btnCancel.isHidden = true
                        
                        //Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    // show popup
                    self.lblPrice.isHidden = true
                    self.lblResultMisMatch.isHidden = true
                    self.lblConditionString.isHidden = true
                    self.btnAgree.isHidden = true
                    self.btnCancel.isHidden = true
                    
                    let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                        
                    })
                    
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)

                }
            })
            
        }
        else
        {
            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
            
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func fireWebServiceForMetchingDataForPickUp()
    {
        if reachability?.connection.description != "No Connection" {
            
            createReturnDictForDiagnosisMisMatch()
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var userSelectedProductAppcodes = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "productReQuote"
            
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                
            if CustomUserDefault.getCurrency() == "£" {
                
                if strAppCodes.contains("CACC01;CACC02;CACC03;"){
                    UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                    UserDefaults.standard.set(true, forKey: "isShowBox")
                    UserDefaults.standard.set(true, forKey: "isShowCharger")
                }
                else{
                    if strAppCodes.contains("CACC01;CACC02;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC01;CACC03;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC02;CACC03;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC01;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC02;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC03;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else{
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                }
                
                if strAppCodes.contains("CAGE05;"){
                    UserDefaults.standard.set(false, forKey: "isShowValidBill")
                }
                else{
                    UserDefaults.standard.set(true, forKey: "isShowValidBill")
                }
                
                //userSelectedProductAppcodes =  "STON01;" + strAppCodes + strDiagnosisFailed // sameer 31/3/2020
                userSelectedProductAppcodes = strAppCodes + strDiagnosisFailed
            }
            else{
                //userSelectedProductAppcodes =  "STON01;" + strAppCodes + strDiagnosisFailed // sameer 31/3/2020
                userSelectedProductAppcodes = strAppCodes + strDiagnosisFailed
            }
            
            var strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,,", with: ";")
            strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ";")
             strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",", with: ";")
            
            //Sameer 25/6/2020
            /*
            if strFinalCodeValues.contains("SPTS03"){
                if strFinalCodeValues.contains("SBRK01"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS03", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else{
                    if strFinalCodeValues.contains("SPTS01"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS01", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                        
                    }
                    else if strFinalCodeValues.contains("SPTS02"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS02", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                    }
                    else if strFinalCodeValues.contains("SPTS03"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS03", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                        strFinalCodeValues = strFinalCodeValues + "SPTS03;"
                    }
                    else if strFinalCodeValues.contains("SPTS04"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS04", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                    }
                    else if strFinalCodeValues.contains("SPTS05"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS05", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                    }
                    else if strFinalCodeValues.contains("SPTS06"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS06", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                    }
                    else if strFinalCodeValues.contains("SPTS07"){
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS07", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                        strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                    }
                }
            }*/
            
            //Sameer 25/6/2020
            if strFinalCodeValues.contains("SBRK01"){
                if strFinalCodeValues.contains("SPTS01"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS01", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS02"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS02", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS03"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS03", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
            }
            
            if strFinalCodeValues.contains("SPTS03"){
                if strFinalCodeValues.contains("SPTS01"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS01", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS02"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS02", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
            }
            
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "newInputData": strFinalCodeValues,
                "isAppCode":"1",
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            print(parameters)
            
            self.mismatchPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        if responseObject?["match"] as! String == "true" {
                            
                            // show popup
                            self.lblPrice.isHidden = true
                            self.lblResultMisMatch.isHidden = true
                            self.lblConditionString.isHidden = true
                            self.btnAgree.isHidden = true
                            self.btnCancel.isHidden = true
                            
                            
                            DispatchQueue.main.async {
                                let vc = UploadIDVC()
                                let nav = UINavigationController(rootViewController: vc)
                                nav.navigationBar.isHidden = true
                                nav.modalPresentationStyle = .fullScreen
                                self.present(nav, animated: true, completion: nil)
                            }
                        }
                        else {
                            
                            let swipeAgreeButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnAgreePressed))
                            swipeAgreeButton.direction = .right
                            self.btnAgree.addGestureRecognizer(swipeAgreeButton)
                            let swipeCancelButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnCancelPressed))
                            swipeCancelButton.direction = .right
                            self.btnCancel.addGestureRecognizer(swipeCancelButton)
                            
                            
                            self.lblPrice.isHidden = false
                            self.lblResultMisMatch.isHidden = false
                            self.lblConditionString.isHidden = false
                            self.btnAgree.isHidden = false
                            self.btnCancel.isHidden = false
 
                            
                            self.strDiagnosisId = responseObject?["msg"] as? String ?? ""
                            
                            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
                                
                                self.strConditionString = responseObject?["newString"] as? String ?? ""

                                let amount = responseObject?["msg"] as? String ?? ""
                                //let strAmountfinal = String(format: "%d", amount)
                                print(amount)
                                
                                self.lblPrice.text = "New Price:- ".localized(lang: langCode) + CustomUserDefault.getCurrency() + amount
                                let resultData = responseObject?["newConditionString"] as? String ?? ""
                                
                                /*
                                let data = Data(resultData.utf8)
                                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                    self.lblResultMisMatch.attributedText = attributedString
                                    
                                    self.lblOldCond.isHidden = false
                                    self.lblNewCond.isHidden = false
                                    
                                    DispatchQueue.main.async {
                                        self.ResultBaseView.layer.borderWidth = 1.0
                                        self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                    }
                                    
                                }*/
                                
                                let data = Data(resultData.utf8)
                                
                                let options = [
                                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                    ] as [NSAttributedString.DocumentReadingOptionKey : Any]
                                
                                if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                                    self.lblResultMisMatch.attributedText = attributedString
                                    
                                    self.lblOldCond.isHidden = false
                                    self.lblNewCond.isHidden = false
                                    
                                    DispatchQueue.main.async {
                                        self.ResultBaseView.layer.borderWidth = 1.0
                                        self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                    }
                                    
                                }
                                
                            }
                            else {
                                self.strConditionString = responseObject?["newConditionString"] as? String ?? ""

                                let amount = responseObject?["newAmount"] as? Int64 ?? 0
                                let strAmountfinal = String(format: "%d", amount)
                                self.lblPrice.text = "New Price:- ".localized(lang: langCode) + CustomUserDefault.getCurrency() + strAmountfinal
                                let resultData = responseObject?["compareData"] as? String ?? ""
                                
                                /*
                                let data = Data(resultData.utf8)
                                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                    self.lblResultMisMatch.attributedText = attributedString
                                    
                                    self.lblOldCond.isHidden = false
                                    self.lblNewCond.isHidden = false
                                    
                                    DispatchQueue.main.async {
                                        self.ResultBaseView.layer.borderWidth = 1.0
                                        self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                    }
                                    
                                }*/
                                
                                let data = Data(resultData.utf8)
                                
                                let options = [
                                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                    ] as [NSAttributedString.DocumentReadingOptionKey : Any]
                                
                                if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                                    self.lblResultMisMatch.attributedText = attributedString
                                    
                                    self.lblOldCond.isHidden = false
                                    self.lblNewCond.isHidden = false
                                    
                                    DispatchQueue.main.async {
                                        self.ResultBaseView.layer.borderWidth = 1.0
                                        self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    else{
                        Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                        print("OK")
                    })
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        else
        {
            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                print("OK")
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func fireWebServiceForMatchingDataForDiagnoseOnPickUp()
    {
        if reachability?.connection.description != "No Connection" {
            
            createReturnDictForDiagnosisMisMatch()
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var userSelectedProductAppcodes = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "productReQuoteonPickup"
            
            
            let returnMetaDetails : NSMutableDictionary = [:]
            
            let deviceName  = UIDevice.current.modelName as String
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
            returnMetaDetails.setValue(KeychainWrapper.standard.string(forKey: "UUIDValue")!, forKey: "UUDIDValue")
            returnMetaDetails.setValue(SystemSharedServices.fullyCharged, forKey: "BattaryFullyCharged")
            
            if SystemSharedServices.jailbroken == 4783242 {
                returnMetaDetails.setValue("No", forKey: "JailBroken")
            }
            else{
                returnMetaDetails.setValue("YES", forKey: "JailBroken")
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: returnMetaDetails, options:[])
            let jsonStringforMetaDetails = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let jsonData1 = try! JSONSerialization.data(withJSONObject: returnDictionary, options:[])
            
            let jsonStringforMetaDetails1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
            //let strFinalCodeValues = strDiagnosisFailed.replacingOccurrences(of: ",,", with: ",")
            let FinalCodeValues = strDiagnosisFailed.replacingOccurrences(of: ",,", with: ",")
            let converComaToSemocolum = FinalCodeValues.replacingOccurrences(of: ",", with: ";")
            
            
            
            if CustomUserDefault.getCurrency() == "£" {
                
                if strAppCodes.contains("CACC01;CACC02;CACC03;"){
                    UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                    UserDefaults.standard.set(true, forKey: "isShowBox")
                    UserDefaults.standard.set(true, forKey: "isShowCharger")
                }
                else{
                    if strAppCodes.contains("CACC01;CACC02;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC01;CACC03;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC02;CACC03;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC01;"){
                        UserDefaults.standard.set(true, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC02;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(true, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                    else if strAppCodes.contains("CACC03;"){
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(true, forKey: "isShowCharger")
                    }
                    else{
                        UserDefaults.standard.set(false, forKey: "isShowEarPhone")
                        UserDefaults.standard.set(false, forKey: "isShowBox")
                        UserDefaults.standard.set(false, forKey: "isShowCharger")
                    }
                }
                
                if strAppCodes.contains("CAGE05;"){
                    UserDefaults.standard.set(false, forKey: "isShowValidBill")
                }
                else{
                    UserDefaults.standard.set(true, forKey: "isShowValidBill")
                }
                
                userSelectedProductAppcodes =  "STON01;" + strAppCodes + strDiagnosisFailed // sameer 31/3/2020
                //userSelectedProductAppcodes = strAppCodes + strDiagnosisFailed
            }
            else{
                userSelectedProductAppcodes =  "STON01;" + strAppCodes + strDiagnosisFailed // sameer 31/3/2020
                //userSelectedProductAppcodes = strAppCodes + strDiagnosisFailed
            }
            
            var strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,,", with: ";")
            strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ";")
            strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",", with: ";")
            
            //Sameer 25/6/2020
            if strFinalCodeValues.contains("SBRK01"){
                if strFinalCodeValues.contains("SPTS01"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS01", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS02"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS02", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS03"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS03", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
            }
            
            if strFinalCodeValues.contains("SPTS03"){
                if strFinalCodeValues.contains("SPTS01"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS01", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
                else if strFinalCodeValues.contains("SPTS02"){
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: "SPTS02", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;;", with: ";")
                    strFinalCodeValues = strFinalCodeValues.replacingOccurrences(of: ";;", with: ";")
                }
            }
            
            var strUudid = ""
            if (KeychainWrapper.standard.string(forKey: "UUIDValue") != nil){
                strUudid = KeychainWrapper.standard.string(forKey: "UUIDValue")!
            }
            else{
                strUudid = UIDevice.current.identifierForVendor!.uuidString
            }
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                //"newInputData" : strFinalCodeValues,
                "orderItemId" : userDefaults.value(forKey: "ChangeModeOrderId") as? String ?? "",
                
                "appCode" : strFinalCodeValues,
                "resultJson" : jsonStringforMetaDetails1,
                "metaDetails" : jsonStringforMetaDetails,
                "androidId" : strUudid
            ]
            
            print(parameters)
            
            self.mismatchPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        if responseObject?["match"] as! String == "true" {
                            
                            // show popup
                            self.lblPrice.isHidden = true
                            self.lblResultMisMatch.isHidden = true
                            self.lblConditionString.isHidden = true
                            self.btnAgree.isHidden = true
                            self.btnCancel.isHidden = true
                            
                            
                            DispatchQueue.main.async {
                                let vc = UploadIDVC()
                                let nav = UINavigationController(rootViewController: vc)
                                nav.navigationBar.isHidden = true
                                nav.modalPresentationStyle = .fullScreen
                                self.present(nav, animated: true, completion: nil)
                            }
                        }
                        else {
                            
                            let swipeAgreeButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnAgreePressed))
                            swipeAgreeButton.direction = .right
                            self.btnAgree.addGestureRecognizer(swipeAgreeButton)
                               let swipeCancelButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnCancelPressed))
                               swipeCancelButton.direction = .right
                               self.btnCancel.addGestureRecognizer(swipeCancelButton)
                               
                               
                               self.lblPrice.isHidden = false
                               self.lblResultMisMatch.isHidden = false
                               self.lblConditionString.isHidden = false
                               self.btnAgree.isHidden = false
                               self.btnCancel.isHidden = false
    
                               self.strDiagnosisIdOnPickUp = responseObject?["diagnosisId"] as? String ?? "" //Sameer 9/8/2020
                               self.strDiagnosisId = responseObject?["msg"] as? String ?? ""
                               
                               if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
                                   
                                   self.strConditionString = responseObject?["newString"] as? String ?? ""

                                   let amount = responseObject?["msg"] as? String ?? ""
                                   //let strAmountfinal = String(format: "%d", amount)
                                   print(amount)
                                   
                                   self.lblPrice.text = "New Price:- ".localized(lang: langCode) + CustomUserDefault.getCurrency() + amount
                                   let resultData = responseObject?["newConditionString"] as? String ?? ""
                                   
                                   /*
                                   let data = Data(resultData.utf8)
                                   if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                       self.lblResultMisMatch.attributedText = attributedString
                                       
                                       self.lblOldCond.isHidden = false
                                       self.lblNewCond.isHidden = false
                                       
                                       DispatchQueue.main.async {
                                           self.ResultBaseView.layer.borderWidth = 1.0
                                           self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                       }
                                       
                                   }*/
                                   
                                   let data = Data(resultData.utf8)
                                   
                                   let options = [
                                       NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                       NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                       ] as [NSAttributedString.DocumentReadingOptionKey : Any]
                                   
                                   if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                                       self.lblResultMisMatch.attributedText = attributedString
                                       
                                       self.lblOldCond.isHidden = false
                                       self.lblNewCond.isHidden = false
                                       
                                       DispatchQueue.main.async {
                                           self.ResultBaseView.layer.borderWidth = 1.0
                                           self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                       }
                                       
                                   }
                                   
                               }
                               else {
                                   self.strConditionString = responseObject?["newConditionString"] as? String ?? ""

                                   let amount = responseObject?["newAmount"] as? Int64 ?? 0
                                   let strAmountfinal = String(format: "%d", amount)
                                   self.lblPrice.text = "New Price:- ".localized(lang: langCode) + CustomUserDefault.getCurrency() + strAmountfinal
                                   let resultData = responseObject?["compareData"] as? String ?? ""
                                   
                                   /*
                                   let data = Data(resultData.utf8)
                                   if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                       self.lblResultMisMatch.attributedText = attributedString
                                       
                                       self.lblOldCond.isHidden = false
                                       self.lblNewCond.isHidden = false
                                       
                                       DispatchQueue.main.async {
                                           self.ResultBaseView.layer.borderWidth = 1.0
                                           self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                       }
                                       
                                   }*/
                                   
                                   let data = Data(resultData.utf8)
                                   
                                   let options = [
                                       NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                       NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                       ] as [NSAttributedString.DocumentReadingOptionKey : Any]
                                   
                                   if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                                       self.lblResultMisMatch.attributedText = attributedString
                                       
                                       self.lblOldCond.isHidden = false
                                       self.lblNewCond.isHidden = false
                                       
                                       DispatchQueue.main.async {
                                           self.ResultBaseView.layer.borderWidth = 1.0
                                           self.ResultBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                                       }
                                       
                                   }
                                   
                               }
                           }
                       }
                       else{
                           Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                       }
                   }
                   else
                   {
                       let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                       
                       let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                           print("OK")
                       })
                       alertController.addAction(sendButton)
                       self.present(alertController, animated: true, completion: nil)
                   }
               })
           }
           else
           {
               let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
               
               let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                   print("OK")
               })
               alertController.addAction(sendButton)
               self.present(alertController, animated: true, completion: nil)
           }
           
       }
    
    @objc func btnAgreePressed(){
        btnCancel.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.btnAgree.frame.size.width = 40
            self.btnAgree.frame.size.height = 40
            self.btnAgree.frame.origin.x = self.view.frame.size.width/2 - 18
            self.btnAgree.layer.cornerRadius = self.btnAgree.frame.height/2
            self.btnAgree.clipsToBounds = true
            self.btnAgree.setTitle("", for: .normal)
            
        }) { (_) in
            //self.rotateLeft(btnType: self.btnAgree)
            //self.rotate360Degrees()
            self.activityAgree.startAnimating()
            self.fireWebServiceForAgreePrice(isforCancel: false,isShowLiveProcess:false)
        }
        
    }
    
    @objc func btnCancelPressed(){
        btnAgree.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.25, animations: {
            self.btnCancel.frame.size.width = 40
            self.btnCancel.frame.size.height = 40
            self.btnCancel.frame.origin.x = self.view.frame.size.width/2 - 18
            self.btnCancel.layer.cornerRadius = self.btnAgree.frame.height/2
            self.btnCancel.clipsToBounds = true
            self.btnCancel.setTitle("", for: .normal)
            
        }) { (_) in
            //self.rotateLeft(btnType: self.btnAgree)
            //self.rotate360Degrees()
            self.activityCancel.startAnimating()
            
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                
            if CustomUserDefault.getCurrency() == "£" {
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
                    self.fireWebServiceForAgreePrice(isforCancel: false,isShowLiveProcess:true)
                }
                else{
                    self.fireWebServiceForAgreePrice(isforCancel: true,isShowLiveProcess:false)
                }
            }
            else{
                self.fireWebServiceForAgreePrice(isforCancel: true,isShowLiveProcess:false)
            }

        }
    }
    
    func fireWebServiceForAgreePrice(isforCancel:Bool,isShowLiveProcess:Bool)
    {
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var strType = ""
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup"{
                strType = "pickup"
            }
            else{
                strType = "diagnose"
            }

            var parameters = [String: Any]()
            
            
            var strUudid = ""
            if (KeychainWrapper.standard.string(forKey: "UUIDValue") != nil){
                strUudid = KeychainWrapper.standard.string(forKey: "UUIDValue")!
            }
            else{
                strUudid = UIDevice.current.identifierForVendor!.uuidString
            }
            
            
            if isforCancel {
                strUrl = strBaseURL + "orderCancel"
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "message" : "your order has been cancelled",
                    "type" : strType,
                    "orderItemId" : userDefaults.value(forKey: "ChangeModeOrderId") as? String ?? ""
                ]
            }
            else{
                strUrl = strBaseURL + "orderItemMismatch"
                if isShowLiveProcess {
                    parameters  = [
                        "userName" : apiAuthenticateUserName,
                        "apiKey" : key,
                        "conditionString" : strConditionString,
                        "type" : strType,
                        //"diagnosisId" : self.strDiagnosisId,
                        "orderItemId" : userDefaults.value(forKey: "ChangeModeOrderId") as? String ?? "",
                        "isManualOffer":"1"
                    ]
                }
                else{
                    parameters  = [
                        "userName" : apiAuthenticateUserName,
                        "apiKey" : key,
                        "conditionString" : strConditionString,
                        "type" : strType,
                        //"diagnosisId" : self.strDiagnosisId,
                        "orderItemId" : userDefaults.value(forKey: "ChangeModeOrderId") as? String ?? ""
                    ]
                }
                
                
                if userDefaults.value(forKey: "pickupDiagnose") as? String == "pickupDiagnose" {
                    parameters["diagnosisId"] = self.strDiagnosisIdOnPickUp //1562458
                    parameters["androidId"] = strUudid
                }else {
                    parameters["diagnosisId"] = self.strDiagnosisId
                }
                
            }
            
            print(parameters)
            
            self.mismatchPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if isforCancel {
                        self.activityCancel.stopAnimating()
                    }
                    else {
                        self.activityAgree.stopAnimating()
                    }

                    if responseObject?["status"] as! String == "Success" {
                        var mesasge  = ""
                        self.btnAgree.isUserInteractionEnabled = true
                        self.btnCancel.isUserInteractionEnabled = true

                        if isforCancel {
                            mesasge = "Order successfully Cancelled!"
                        }
                         else {
                            if isShowLiveProcess {
                                print("isShowLiveProcess")
                            }
                            else {
                                mesasge = "Order successfully updated!"
                            }
                        }
                        
                        if isShowLiveProcess {
                            userDefaults.removeObject(forKey: "ChangeModeOrderId")
                            let orderItemId = responseObject?["msg"] as! String
                            userDefaults.setValue(orderItemId, forKey: "ChangeModeOrderId")
                            let vc = LiveOfferVC()
                            vc.strGetConditionString = self.strConditionString
                            vc.strGetDiagnosisID = self.strDiagnosisId
                            vc.strOfferID = responseObject?["manualOfferId"] as! String
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        else {
                            //userDefaults.removeObject(forKey: "ChangeModeOrderId")
                            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:mesasge.localized(lang: langCode), preferredStyle: .alert)
                            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                                
                            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
                                    
                                    if isforCancel {
                                        obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                    }
                                    else {
                                        
                                        DispatchQueue.main.async {
                                            userDefaults.removeObject(forKey: "ChangeModeOrderId")
                                            let orderItemId = responseObject?["msg"] as! String
                                            //let strId = String(format: "%d", orderItemId)
                                            userDefaults.setValue(orderItemId, forKey: "ChangeModeOrderId")
                                            
                                            let vc = UploadIDVC()
                                            let nav = UINavigationController(rootViewController: vc)
                                            nav.navigationBar.isHidden = true
                                            nav.modalPresentationStyle = .fullScreen
                                            self.present(nav, animated: true, completion: nil)
                                        }
                                    }
                                }
                                else{
                                    obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                }
                            })
                            
                            alertController.addAction(sendButton)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    else {
                        self.activityCancel.stopAnimating()
                        self.setButtonFrame(isforCancelDone: isforCancel)
                        Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    self.setButtonFrame(isforCancelDone: isforCancel)

                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                    
                }
            })
            
        }
        else
        {
            self.setButtonFrame(isforCancelDone: isforCancel)

            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    func setButtonFrame(isforCancelDone:Bool){
        DispatchQueue.main.async {
        self.btnAgree.isUserInteractionEnabled = true
        self.btnCancel.isUserInteractionEnabled = true
            
        if isforCancelDone {
            self.btnCancel.frame.size.width = 260
            self.btnCancel.frame.size.height = 40
            self.btnCancel.frame.origin.x = self.view.frame.size.width/2 - 130
            self.btnCancel.layer.cornerRadius = 0
            self.btnCancel.clipsToBounds = true
            self.btnCancel.setTitle("Swipe Here To Cancel This Order".localized(lang: langCode), for: .normal)
        }
        else {
            self.btnAgree.frame.size.width = 260
            self.btnAgree.frame.size.height = 40
            self.btnAgree.frame.origin.x = self.view.frame.size.width/2 - 130
            self.btnAgree.layer.cornerRadius = 0
            self.btnAgree.clipsToBounds = true
            self.btnAgree.setTitle("Swipe Here To Agree With Price".localized(lang: langCode), for: .normal)
            
            }
        }
    }

    func rotate360Degrees(duration: CFTimeInterval = 1) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        btnAgree.layer.add(rotateAnimation, forKey: nil)
    }
    
    func createReturnDictForDiagnosisMisMatch(){
        
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup" {
            
            /////////////////////////////////////////////////////////
            
            if resultJSONGet["Screen"].int == 1 {
                returnDictionary.setValue("1", forKey: "Screen")
                //returnDictionary = ["Screen":"1"]
                if resultJSONGet["Dead Pixels"].int == 0{
                    strDiagnosisFailed = "SPTS03,"
                }
            }
            else{
                //returnDictionary = ["Screen":"-1"]
                returnDictionary.setValue("-1", forKey: "Screen")
                strDiagnosisFailed = "SBRK01,"
            }
            
            if resultJSONGet["Dead Pixels"].int == 1{
                //returnDictionary = ["USB":"1"]
                returnDictionary.setValue("1", forKey: "Dead Pixels")
            }
            else{
                //returnDictionary = ["USB":"-1"]
                returnDictionary.setValue("0", forKey: "Dead Pixels")
            }
            
            if userDefaults.value(forKey: "pickupDiagnose") as? String == "pickupDiagnose" {
                
                if resultJSONGet["Rotation"].int == 1{
                        // returnDictionary = ["Rotation":"1"]
                        returnDictionary.setValue("1", forKey: "Rotation")
                    }
                    else{
                        //returnDictionary = ["Rotation":"-1"]
                        returnDictionary.setValue("-1", forKey: "Rotation")
                    }
                    
                    if resultJSONGet["Proximity"].int == 1{
                        //returnDictionary = ["Proximity":"1"]
                        returnDictionary.setValue("1", forKey: "Proximity")
                    }
                    else{
                        //returnDictionary = ["Proximity":"-1"]
                        returnDictionary.setValue("-1", forKey: "Proximity")
                    }
                    
                    if resultJSONGet["Hardware Buttons"].int == 1{
                        //returnDictionary = ["Hardware Buttons":"1"]
                        returnDictionary.setValue("1", forKey: "Hardware Buttons")
                    }
                    else{
                        //returnDictionary = ["Hardware Buttons":"-1"]
                        returnDictionary.setValue("-1", forKey: "Hardware Buttons")
                        strDiagnosisFailed = strDiagnosisFailed + "CISS02,"
                    }
                                        
                    if CustomUserDefault.getCurrency() == "£" {
                        
                        if resultJSONGet["Earphone"].int == 1 {
                            returnDictionary.setValue("1", forKey: "Earphone")
                            // returnDictionary = ["Earphone":"1"]
                        }
                        else{
                            // returnDictionary = ["Earphone":"-1"]
                            returnDictionary.setValue("-1", forKey: "Earphone")
                            strDiagnosisFailed = strDiagnosisFailed + "CISS11,"
                        }
                        
                        if resultJSONGet["USB"].int == 1{
                            //returnDictionary = ["USB":"1"]
                            returnDictionary.setValue("1", forKey: "USB")
                        }
                        else{
                            //returnDictionary = ["USB":"-1"]
                            returnDictionary.setValue("-1", forKey: "USB")
                            strDiagnosisFailed = strDiagnosisFailed + "CISS05,"
                        }
                    }
                    
                    if resultJSONGet["Camera"].int == 1{
                        //returnDictionary = ["Camera":"1"]
                        returnDictionary.setValue("1", forKey: "Camera")
                    }
                    else{
                        //returnDictionary = ["Camera":"-1"]
                        returnDictionary.setValue("-1", forKey: "Camera")
                        strDiagnosisFailed = strDiagnosisFailed + "CISS01,"
                    }
                
                    if resultJSONGet["Fingerprint Scanner"].int == 1{
                        // returnDictionary = ["Fingerprint Scanner":"1"]
                        returnDictionary.setValue("1", forKey: "Fingerprint Scanner")
                        
                    }
                    else if  resultJSONGet["Fingerprint Scanner"].int == -1{
                        // returnDictionary = ["Fingerprint Scanner":"1"]
                        returnDictionary.setValue("-1", forKey: "Fingerprint Scanner")
                        strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                    }
                    else if  resultJSONGet["Fingerprint Scanner"].int == -2{
                        // returnDictionary = ["Fingerprint Scanner":"1"]
                        //  strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                        returnDictionary.setValue("-2", forKey: "Fingerprint Scanner")
                    }
                    else{
                        // returnDictionary = ["Fingerprint Scanner":"-1"]
                        returnDictionary.setValue("0", forKey: "Fingerprint Scanner")
                        strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                    }
                    
                    if resultJSONGet["WIFI"].int == 1 && resultJSONGet["GPS"].int == 1 && resultJSONGet["Bluetooth"].int == 1{
                    }
                    else{
                        strDiagnosisFailed  = strDiagnosisFailed + "CISS04,"
                    }
                    
                    if resultJSONGet["WIFI"].int == 1{
                        //  returnDictionary = ["WIFI":"1"]
                        returnDictionary.setValue("1", forKey: "WIFI")
                    }
                    else{
                        //returnDictionary = ["WIFI":"0"]
                        returnDictionary.setValue("0", forKey: "WIFI")
                    }
                    
                    if resultJSONGet["GSM"].int == 1{
                        //returnDictionary = ["GSM":"1"]
                        returnDictionary.setValue("1", forKey: "GSM")
                    }
                    else{
                        // returnDictionary = ["GSM":"0"]
                        returnDictionary.setValue("0", forKey: "GSM")
                    }
                    
                    if resultJSONGet["GPS"].int == 1{
                        //returnDictionary = ["GPS":"1"]
                        returnDictionary.setValue("1", forKey: "GPS")
                    }
                    else{
                        // returnDictionary = ["GPS":"0"]
                        returnDictionary.setValue("0", forKey: "GPS")
                    }
                    
                    if resultJSONGet["Bluetooth"].int == 1{
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
                                
            }
            
            /////////////////////////////////////////////////////////
        }
        else{
            
            if resultJSONGet["Screen"].int == 1{
                returnDictionary.setValue("1", forKey: "Screen")
                //returnDictionary = ["Screen":"1"]
                
            }
            else{
                //returnDictionary = ["Screen":"-1"]
                returnDictionary.setValue("-1", forKey: "Screen")
                strDiagnosisFailed = "SBRK01,"
                
            }
            
            
            if resultJSONGet["Rotation"].int == 1{
                // returnDictionary = ["Rotation":"1"]
                returnDictionary.setValue("1", forKey: "Rotation")
                
            }
            else{
                //returnDictionary = ["Rotation":"-1"]
                returnDictionary.setValue("-1", forKey: "Rotation")
                
            }
            
            if resultJSONGet["Proximity"].int == 1{
                //returnDictionary = ["Proximity":"1"]
                returnDictionary.setValue("1", forKey: "Proximity")
                
            }
            else{
                //returnDictionary = ["Proximity":"-1"]
                returnDictionary.setValue("-1", forKey: "Proximity")
                
            }
            
            
            if resultJSONGet["Hardware Buttons"].int == 1{
                //returnDictionary = ["Hardware Buttons":"1"]
                returnDictionary.setValue("1", forKey: "Hardware Buttons")
                
            }
            else{
                //returnDictionary = ["Hardware Buttons":"-1"]
                returnDictionary.setValue("-1", forKey: "Hardware Buttons")
                strDiagnosisFailed = strDiagnosisFailed + "CISS02,"
                
            }
            
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
            if CustomUserDefault.getCurrency() == "£" {
                
                if resultJSONGet["Earphone"].int == 1 {
                    returnDictionary.setValue("1", forKey: "Earphone")
                    
                    // returnDictionary = ["Earphone":"1"]
                }
                else{
                    // returnDictionary = ["Earphone":"-1"]
                    returnDictionary.setValue("-1", forKey: "Earphone")
                    strDiagnosisFailed = strDiagnosisFailed + "CISS11,"
                    
                }
                
                if resultJSONGet["USB"].int == 1{
                    //returnDictionary = ["USB":"1"]
                    returnDictionary.setValue("1", forKey: "USB")
                    
                }
                else{
                    //returnDictionary = ["USB":"-1"]
                    returnDictionary.setValue("-1", forKey: "USB")
                    strDiagnosisFailed = strDiagnosisFailed + "CISS05,"
                    
                }
            }
            
            if resultJSONGet["Camera"].int == 1{
                //returnDictionary = ["Camera":"1"]
                returnDictionary.setValue("1", forKey: "Camera")
                
            }
            else{
                //returnDictionary = ["Camera":"-1"]
                returnDictionary.setValue("-1", forKey: "Camera")
                strDiagnosisFailed = strDiagnosisFailed + "CISS01,"
                
            }
            if resultJSONGet["Fingerprint Scanner"].int == 1{
                // returnDictionary = ["Fingerprint Scanner":"1"]
                returnDictionary.setValue("1", forKey: "Fingerprint Scanner")
                
            }
            else if  resultJSONGet["Fingerprint Scanner"].int == -1{
                // returnDictionary = ["Fingerprint Scanner":"1"]
                returnDictionary.setValue("-1", forKey: "Fingerprint Scanner")
                strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                
            }
            else if  resultJSONGet["Fingerprint Scanner"].int == -2{
                // returnDictionary = ["Fingerprint Scanner":"1"]
                //  strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                returnDictionary.setValue("-2", forKey: "Fingerprint Scanner")
            }
            else{
                // returnDictionary = ["Fingerprint Scanner":"-1"]
                returnDictionary.setValue("0", forKey: "Fingerprint Scanner")
                strDiagnosisFailed = strDiagnosisFailed + "CISS12,"
                
            }
            
            if resultJSONGet["WIFI"].int == 1 && resultJSONGet["GPS"].int == 1 && resultJSONGet["Bluetooth"].int == 1{
            }
            else{
                strDiagnosisFailed  = strDiagnosisFailed + "CISS04,"
                
            }
            
            if resultJSONGet["WIFI"].int == 1{
                //  returnDictionary = ["WIFI":"1"]
                returnDictionary.setValue("1", forKey: "WIFI")
                
            }
            else{
                //returnDictionary = ["WIFI":"0"]
                returnDictionary.setValue("0", forKey: "WIFI")
                
            }
            
            if resultJSONGet["GSM"].int == 1{
                //returnDictionary = ["GSM":"1"]
                returnDictionary.setValue("1", forKey: "GSM")
                
            }
            else{
                // returnDictionary = ["GSM":"0"]
                returnDictionary.setValue("0", forKey: "GSM")
                
            }
            
            if resultJSONGet["GPS"].int == 1{
                //returnDictionary = ["GPS":"1"]
                returnDictionary.setValue("1", forKey: "GPS")
                
            }
            else{
                // returnDictionary = ["GPS":"0"]
                returnDictionary.setValue("0", forKey: "GPS")
                
            }
            
            if resultJSONGet["Bluetooth"].int == 1{
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
            
        }
        
        
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

}
