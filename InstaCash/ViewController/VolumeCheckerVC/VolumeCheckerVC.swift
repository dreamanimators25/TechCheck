//
//  VolumeCheckerVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import JPSVolumeButtonHandler
import PopupDialog
import SwiftyJSON

class VolumeCheckerVC: UIViewController {

    @IBOutlet weak var volumeDownImg: UIImageView!
    @IBOutlet weak var volumeUpImg: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblCheckingHardware: UILabel!
    @IBOutlet weak var lblFollowInstruction: UILabel!
    @IBOutlet weak var lblPressVolumeUp: UILabel!
    @IBOutlet weak var lblPressVolumeDown: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    var resultJSON = JSON()
    var volDown = false
    var volUp = false
    var isComingFromTestResult = false
    var isComingFromProductquote = false

    private var volumeButtonHandler: JPSVolumeButtonHandler?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
      
        self.lblCheckingHardware.text = "Checking hardware buttons".localized(lang: langCode)
        self.lblFollowInstruction.text = "Follow the instructions below to complete check.".localized(lang: langCode)
        self.lblPressVolumeUp.text = "Press volume up button".localized(lang: langCode)
        self.lblPressVolumeDown.text = "Press volume down button".localized(lang: langCode)
        
        self.btnSkip.setTitle("SKIP".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "volumebutton_complete")
            userDefaults.setValue(false, forKey: "volumebutton_complete")
        }
        
        volumeButtonHandler = JPSVolumeButtonHandler(
            up: {
                self.volumeUpImg.image = UIImage(named: "check")
                self.volUp = true
                if(self.volDown == true){
                    self.tearDown()
                    UserDefaults.standard.set(true, forKey: "volume")
                    userDefaults.setValue(true, forKey: "volumebutton_complete")
                    
                    if self.isComingFromTestResult{
                        let vc = DiagnosticTestResultVC()
                        self.resultJSON["Hardware Buttons"].int = 1
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if self.isComingFromProductquote == true{
                        //                        NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Hardware Buttons")
                        self.resultJSON["Hardware Buttons"].int = 1
                        
                        NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Hardware Buttons"])
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        
                        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                            let vc = EarPhoneVC()
                            self.resultJSON["Hardware Buttons"].int = 1
                            vc.resultJSON = self.resultJSON
                            self.present(vc, animated: true, completion: nil)
                        }else {
                            let vc = CameraVC()
                            self.resultJSON["Hardware Buttons"].int = 1
                            vc.resultJSON = self.resultJSON
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                    }
                    if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                        let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                        self.resultJSON = sendJson
                        self.resultJSON["Hardware Buttons"].int = 1
                        
                    }
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                }
                self.action()
        }, downBlock: {
            
            self.volDown = true
            self.volumeDownImg.image = UIImage(named: "check")
            
            if(self.volUp == true){
                UserDefaults.standard.set(true, forKey: "volume")
                userDefaults.setValue(true, forKey: "volumebutton_complete")
                
                self.tearDown()
                if self.isComingFromTestResult{
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Hardware Buttons"].int = 1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    //                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Hardware Buttons")
                    self.resultJSON["Hardware Buttons"].int = 1
                    
                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Hardware Buttons"])
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                        let vc = EarPhoneVC()
                        self.resultJSON["Hardware Buttons"].int = 1
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }else {
                        let vc = CameraVC()
                        self.resultJSON["Hardware Buttons"].int = 1
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Hardware Buttons"].int = 1
                    
                }
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
            }
            self.action()
        })
        //        let vc = CameraVC()
        //        self.resultJSON["USB"].int = 1
        //        vc.resultJSON = self.resultJSON
        //        self.present(vc, animated: true, completion: nil)
        
        let handler = volumeButtonHandler
        handler!.start(true)
        
        lblPrice.text = CustomUserDefault.getCurrency()
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSkipPressed(_ sender: UIButton) {
        
        // Prepare the popup assets
        let title = "Hardware Button Diagnosis".localized(lang: langCode)
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?".localized(lang: langCode)
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
            self.tearDown()
            UserDefaults.standard.set(false, forKey: "volume")
            userDefaults.setValue(true, forKey: "volumebutton_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Hardware Buttons"].int = -1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                    let vc = EarPhoneVC()
                    self.resultJSON["Hardware Buttons"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }else {
                    let vc = CameraVC()
                    self.resultJSON["Hardware Buttons"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Hardware Buttons"].int = -1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
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
    var action: (() -> Void) = {} {
        didSet {
            // Is the handler already there, that is, is this module already in use?..
            if let handler = volumeButtonHandler {
                // ..If so, then add the action to the handler right away.
                handler.upBlock = action
                handler.downBlock = action
            }
            // Otherwise, just save the action here and see it added when the handler is created when the module goes into use (isInUse = true).
        }
    }
    func tearDown() {
        if let handler = volumeButtonHandler {
            handler.stop()
            volumeButtonHandler = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
