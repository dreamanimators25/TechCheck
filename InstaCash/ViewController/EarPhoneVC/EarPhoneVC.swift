//
//  EarPhoneVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import AVFoundation
import PopupDialog
import SwiftGifOrigin
import SwiftyJSON

class EarPhoneVC: UIViewController {
    
    var resultJSON = JSON()
    let session = AVAudioSession.sharedInstance()
    var isComingFromTestResult = false
    var isComingFromProductquote = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.present(vc, animated: true, completion: nil)
        }
        else if self.isComingFromProductquote == true{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let vc = DeviceChargerVC()
            self.resultJSON["Earphone"].int = -1
            vc.resultJSON = self.resultJSON
            self.present(vc, animated: true, completion: nil)
        }
        if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
            let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
            self.resultJSON = sendJson
            self.resultJSON["Earphone"].int = -1
            
        }
        userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
        
    }

    @IBAction func btnSkipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Earphone Jack Diagnosis"
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes") {
            UserDefaults.standard.set(false, forKey: "earphone")
            userDefaults.setValue(true, forKey: "earphone_complete")
            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Earphone"].int = -1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = DeviceChargerVC()
                self.resultJSON["Earphone"].int = -1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Earphone"].int = -1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

        }
        
        let buttonTwo = DefaultButton(title: "No") {
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
        pv.titleFont    = UIFont(name: "HelveticaNeue-Medium", size: 20)!
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 16)!
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius    = 2
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
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc dynamic private func audioRouteChangeListener(notification:NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            UserDefaults.standard.set(true, forKey: "earphone")
            userDefaults.setValue(true, forKey: "earphone_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Earphone"].int = 1
                vc.resultJSON = self.resultJSON
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
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Earphone"].int = 1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

            break
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            UserDefaults.standard.set(true, forKey: "earphone")
            userDefaults.setValue(true, forKey: "earphone_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Earphone"].int = 1
                vc.resultJSON = self.resultJSON
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
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Earphone"].int = 1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

          
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
