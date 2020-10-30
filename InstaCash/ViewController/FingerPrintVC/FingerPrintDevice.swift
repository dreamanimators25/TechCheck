//
//  FingerPrintDevice.swift
//  TechCheck
//
//  Created by TechCheck on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import PopupDialog
import BiometricAuthentication
import SwiftyJSON

class FingerPrintDevice: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var biometricImage: UIImageView!
    
    @IBOutlet weak var lblCheckScanner: UILabel!
    @IBOutlet weak var lblThenYou: UILabel!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var btnGuideme: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    //@IBOutlet weak var btnScanFingerPrint: UIButton!
    
    var resultJSON = JSON()
    var isComingFromTestResult = false
    var isComingFromProductquote = false
    
    var isCancel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "fingerprint_complete")
        userDefaults.setValue(false, forKey: "fingerprint_complete")
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "fingerprint_complete")
            userDefaults.setValue(false, forKey: "fingerprint_complete")
        }
        
        if BioMetricAuthenticator.canAuthenticate() {
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                print("hello faceid available")
                // device supports face id recognition.
                let yourImage: UIImage = UIImage(named: "face-id")!
                biometricImage.image = yourImage
            }
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        lblPrice.text = CustomUserDefault.getCurrency()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblCheckScanner.text = "Checking fingerprint scanner".localized(lang: langCode)
        self.lblThenYou.text = "During the test place your finger on the scanner as you normally would to unlock your phone".localized(lang: langCode)
        self.lblFirst.text = "First, enable the fingerprint function on your phone.".localized(lang: langCode)
        
        //self.btnGuideme.setTitle("Guide me".localized(lang: langCode), for: UIControlState.normal)
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: navColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)] as [NSAttributedStringKey : Any]
        let str = NSAttributedString.init(string: "Guide me".localized(lang: langCode), attributes: myAttribute)
        self.btnGuideme.setAttributedTitle(str, for: .normal)
        
        self.btnSkip.setTitle("Skip".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    @objc func appMovedToBackground() {
    //Your Process
        if isCancel == false{
            self.viewDidAppear(true)
        }
    }
    
    @IBAction func btnScanFingrtPreint(_ sender: UIButton) {
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            UserDefaults.standard.set(true, forKey: "fingerprint")
            userDefaults.setValue(true, forKey: "fingerprint_complete")
            
            if self.isComingFromTestResult {
                self.isCancel = true
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Fingerprint Scanner"].int = 1
                vc.resultJSON = (self.resultJSON)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
//                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Fingerprint Scanner")
                self.resultJSON["Fingerprint Scanner"].int = 1

                  NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Fingerprint Scanner"])
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.isCancel = true
                let vc = BlueToothTestingVC()
                self.resultJSON["Fingerprint Scanner"].int = 1
                vc.resultJSON = (self.resultJSON)
                vc.iscomingFromHome = true
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Fingerprint Scanner"].int = 1

            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
            }else {
                
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "bluetooth_complete")
                userDefaults.setValue(false, forKey: "bluetooth_complete")
            }

            // authentication successful
            
        }, failure: { [weak self] (error) in
            
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem {
                return
            }
                
                // device does not support biometric (face id or touch id) authentication
            else if error == .biometryNotAvailable {
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)
            }
                
                // show alternatives on fallback button clicked
            else if error == .fallback {
                
                // here we're entering username and password
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)

            }
                
                // No biometry enrolled in this device, ask user to register fingerprint or face
            else if error == .biometryNotEnrolled {
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)

            }
                
                // Biometry is locked out now, because there were too many failed attempts.
                // Need to enter device passcode to unlock.
            else if error == .biometryLockedout {
                // show passcode authentication
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)
            }
                
                // show error on authentication failed
            else {
                UserDefaults.standard.set(false, forKey: "fingerprint")
                userDefaults.setValue(true, forKey: "fingerprint_complete")

                //Alert.showAlert(strMessage: error.message() as NSString, Onview: self!)
                if (self?.isComingFromTestResult)!{
                    self!.isCancel = true
                    let vc = DiagnosticTestResultVC()
                    self?.resultJSON["Fingerprint Scanner"].int = 0
                    vc.resultJSON = (self?.resultJSON)!
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
                else if self?.isComingFromProductquote == true{
                    self!.isCancel = true
                    self?.dismiss(animated: true, completion: nil)
                }
                else{
                    self!.isCancel = true
                    let vc = BlueToothTestingVC()
                    self?.resultJSON["Fingerprint Scanner"].int = 0
                    vc.resultJSON = (self?.resultJSON)!
                    vc.iscomingFromHome = true
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
                userDefaults.setValue(self?.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

            }
        })
        
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSkipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        //let title = "FingerPrint Scanner Diagnosis".localized(lang: langCode)
        let title = "FingerPrint Scanner Test".localized(lang: langCode)
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?".localized(lang: langCode)
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
            UserDefaults.standard.set(false, forKey: "fingerprint")
            userDefaults.setValue(true, forKey: "fingerprint_complete")

            if self.isComingFromTestResult {
                self.isCancel = true
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Fingerprint Scanner"].int = -1
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.isCancel = true
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.isCancel = true
                let vc = BlueToothTestingVC()
                self.resultJSON["Fingerprint Scanner"].int = -1
                vc.resultJSON = self.resultJSON
                vc.iscomingFromHome = true
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Fingerprint Scanner"].int = -1

            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
            }else {
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "bluetooth_complete")
                userDefaults.setValue(false, forKey: "bluetooth_complete")
            }

        }
        
        let buttonTwo = DefaultButton(title: "No".localized(lang: langCode)) {
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
        pv.titleFont    = UIFont(name: fontNameMedium, size: 20)!
        pv.messageFont  = UIFont(name: fontNameRegular, size: 16)!
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius    = 10
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
        db.titleFont      = UIFont(name: fontNameMedium, size: 16)!
        
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: fontNameMedium, size: 16)!
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //let btn = UIButton()
        //self.btnSkipPressed(btn)
        //btnScanFingerPrint.isHidden = false
        
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            UserDefaults.standard.set(true, forKey: "fingerprint")
            userDefaults.setValue(true, forKey: "fingerprint_complete")

            if self.isComingFromTestResult{
                self.isCancel = true

                let vc = DiagnosticTestResultVC()
                self.resultJSON["Fingerprint Scanner"].int = 1
                vc.resultJSON = (self.resultJSON)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
//                  NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Fingerprint Scanner")
                self.resultJSON["Fingerprint Scanner"].int = 1
                
                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Fingerprint Scanner"])
                self.isCancel = true
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.isCancel = true
                
                let vc = BlueToothTestingVC()
                self.resultJSON["Fingerprint Scanner"].int = 1
                vc.resultJSON = (self.resultJSON)
                vc.iscomingFromHome = true
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Fingerprint Scanner"].int = 1

            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
            }else {
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
            
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "bluetooth_complete")
                userDefaults.setValue(false, forKey: "bluetooth_complete")
            }

            // authentication successful
            
        }, failure: { [weak self] (error) in
            
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem {
                self!.isCancel = true
                return
            }
                
                // device does not support biometric (face id or touch id) authentication
            else if error == .biometryNotAvailable {
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)

            }
                
                // show alternatives on fallback button clicked
            else if error == .fallback {
                
                // here we're entering username and password
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)
            }
                
                // No biometry enrolled in this device, ask user to register fingerprint or face
            else if error == .biometryNotEnrolled {
                
                //self!.btnScanFingerPrint.isHidden = false
                
                let alertController = UIAlertController (title: "Enable fingerprint".localized(lang: langCode), message: "Go to Settings -> Touch ID & Passcode".localized(lang: langCode), preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings".localized(lang: langCode), style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: "App-Prefs:root") else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            self!.isCancel = false
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel".localized(lang: langCode), style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                self!.present(alertController, animated: true, completion: nil)
//                UserDefaults.standard.set(false, forKey: "fingerprint")
//                if (self?.isComingFromTestResult)!{
//                    let vc = DiagnosticTestResultVC()
//                    self?.resultJSON["Fingerprint Scanner"].int = -1
//                    vc.resultJSON = (self?.resultJSON)!
//                    self?.present(vc, animated: true, completion: nil)
//                }
//                else{
//                    let vc = BlueToothTestingVC()
//                    self?.resultJSON["Fingerprint Scanner"].int = -1
//                    vc.resultJSON = (self?.resultJSON)!
//                    self?.present(vc, animated: true, completion: nil)
//                }
                
            }
                
                // Biometry is locked out now, because there were too many failed attempts.
                // Need to enter device passcode to unlock.
            else if error == .biometryLockedout {
                // show passcode authentication
                Alert.showAlertWithError(strMessage: error.message() as NSString, Onview: self!)
            }
                
                // show error on authentication failed
            else {

               // Alert.showAlert(strMessage: error.message() as NSString, Onview: self!)
                UserDefaults.standard.set(false, forKey: "fingerprint")
                userDefaults.setValue(true, forKey: "fingerprint_complete")

                if (self?.isComingFromTestResult)!{
                    self!.isCancel = true

                    let vc = DiagnosticTestResultVC()
                    self?.resultJSON["Fingerprint Scanner"].int = 0
                    vc.resultJSON = (self?.resultJSON)!
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
                else if self?.isComingFromProductquote == true{
                   
                    self?.isCancel = true
                    self?.dismiss(animated: true, completion: nil)
                }
                else{
                    self!.isCancel = true
                    let vc = BlueToothTestingVC()
                    self?.resultJSON["Fingerprint Scanner"].int = 0
                    vc.resultJSON = (self?.resultJSON)!
                    vc.iscomingFromHome = true
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                }
                userDefaults.setValue(self?.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

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
