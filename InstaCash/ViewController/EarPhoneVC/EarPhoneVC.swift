//
//  EarPhoneVC.swift
//  TechCheck
//
//  Created by TechCheck on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import AVFoundation
import PopupDialog
import SwiftGifOrigin
import SwiftyJSON

class EarPhoneVC: UIViewController {
    
    @IBOutlet weak var lblCheckEarphone: UILabel!
    @IBOutlet weak var lblPressStart: UILabel!
    @IBOutlet weak var btnSkip: UIButton!

    
    var resultJSON = JSON()
    let session = AVAudioSession.sharedInstance()
    var isComingFromTestResult = false
    var isComingFromProductquote = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "earphone_complete")
        userDefaults.setValue(false, forKey: "earphone_complete")
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "earphone_complete")
            userDefaults.setValue(false, forKey: "earphone_complete")
        }
        
        //earphoneInfoImage.loadGif(name: "earphone_jack")
        
        let currentRoute = self.session.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                } else {
                }
            }
        } else {
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioRouteChangeListener),
            name: NSNotification.Name.AVAudioSessionRouteChange,
            object: nil)
        
    }
    
    func changeLanguageOfUI() {
        
        self.lblCheckEarphone.text = "Checking earphone socket".localized(lang: langCode)
        self.lblPressStart.text = "Press “Start“ and follow instructions.".localized(lang: langCode)
        self.btnSkip.setTitle("Skip".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.changeLanguageOfUI()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnStartPressed(_ sender: UIButton) {
        
        UserDefaults.standard.set(false, forKey: "earphone")
        userDefaults.setValue(true, forKey: "earphone_complete")
        
        if self.isComingFromTestResult{
            let vc = DiagnosticTestResultVC()
            self.resultJSON["Earphone"].int = -1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else if self.isComingFromProductquote == true{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let vc = DeviceChargerVC()
            self.resultJSON["Earphone"].int = -1
            vc.resultJSON = self.resultJSON
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
            let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
            self.resultJSON = sendJson
            self.resultJSON["Earphone"].int = -1
            
        }
        
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
            
        }else {
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
            
            //Sameer 14/4/2020
            userDefaults.removeObject(forKey: "charger_complete")
            userDefaults.setValue(false, forKey: "charger_complete")
        }
        
    }

    @IBAction func btnSkipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Earphone Jack Diagnosis".localized(lang: langCode)
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?".localized(lang: langCode)
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
            UserDefaults.standard.set(false, forKey: "earphone")
            userDefaults.setValue(true, forKey: "earphone_complete")
            
            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Earphone"].int = -1
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = DeviceChargerVC()
                self.resultJSON["Earphone"].int = -1
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Earphone"].int = -1
            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
            }else {
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "charger_complete")
                userDefaults.setValue(false, forKey: "charger_complete")
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
    
    @objc func audioRouteChangeListener(notification:NSNotification) {
        DispatchQueue.main.async {
            let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
            switch audioRouteChangeReason {
            case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
                UserDefaults.standard.set(true, forKey: "earphone")
                userDefaults.setValue(true, forKey: "earphone_complete")
                
                if self.isComingFromTestResult {
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Earphone"].int = 1
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    //NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Earphone")
                    self.resultJSON["Earphone"].int = 1
                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Earphone"])
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    let vc = DeviceChargerVC()
                    self.resultJSON["Earphone"].int = 1
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Earphone"].int = 1
                    
                }
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                    
                }else {
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                    //Sameer 14/4/2020
                    userDefaults.removeObject(forKey: "charger_complete")
                    userDefaults.setValue(false, forKey: "charger_complete")
                }
                
                break
            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
                UserDefaults.standard.set(true, forKey: "earphone")
                userDefaults.setValue(true, forKey: "earphone_complete")
                
                if self.isComingFromTestResult {
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Earphone"].int = 1
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    //                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Earphone")
                    self.resultJSON["Earphone"].int = 1
                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Earphone"])
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    let vc = DeviceChargerVC()
                    self.resultJSON["Earphone"].int = 1
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Earphone"].int = 1
                    
                }
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                    
                }else {
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                    //Sameer 14/4/2020
                    userDefaults.removeObject(forKey: "charger_complete")
                    userDefaults.setValue(false, forKey: "charger_complete")
                }
                
                break
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
