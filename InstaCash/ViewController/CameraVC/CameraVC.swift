//
//  CameraVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import AVFoundation
import DKCamera
import PopupDialog
import SwiftyJSON

class CameraVC: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblCheckCamera: UILabel!
    @IBOutlet weak var lblGetReady: UILabel!
    @IBOutlet weak var lblTap: UILabel!
    @IBOutlet weak var lblPressCapture: UILabel!
    @IBOutlet weak var btnStartCamera: UIButton!
    @IBOutlet weak var btnSkip: UIButton!

    
    var resultJSON = JSON()
    var isComingFromTestResult = false
    var isComingFromProductquote = false
    var isFrontClick = false
    var isBackClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "camera_complete")
        userDefaults.setValue(false, forKey: "camera_complete")
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "camera_complete")
            userDefaults.setValue(false, forKey: "camera_complete")
        }
        
        lblPrice.text = CustomUserDefault.getCurrency()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblCheckCamera.text = "Checking cameras".localized(lang: langCode)
        self.lblGetReady.text = "Get ready to smile. We’re making sure this device is selfie-ready!".localized(lang: langCode)
        self.lblTap.text = "1. Tap anywhere on the screen to autofocus".localized(lang: langCode)
        self.lblPressCapture.text = "2. Press capture to take a shot!".localized(lang: langCode)
        
        self.btnStartCamera.setTitle("Start Camera Check".localized(lang: langCode), for: UIControlState.normal)
        self.btnSkip.setTitle("Skip".localized(lang: langCode), for: UIControlState.normal)
        
    }

    @IBAction func btnClickPicturePressed(_ sender: UIButton) {
        
        let camera = DKCamera()
        DispatchQueue.main.async {
            camera.cameraSwitchButton.isUserInteractionEnabled = false
            camera.cameraSwitchButton.isHidden = true
        }
        camera.didCancel = {
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
            let isFront = camera.currentDevice == camera.captureDeviceFront
            if isFront{
                self.isFrontClick = true
            }
            else{
                self.isBackClick = true
                if self.isFrontClick == false{
                camera.currentDevice = camera.currentDevice == camera.captureDeviceRear ?
                    camera.captureDeviceFront : camera.captureDeviceRear
                camera.setupCurrentDevice()
                }
            }
            if self.isFrontClick == true && self.isBackClick == true{
                self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "camera")
            userDefaults.setValue(true, forKey: "camera_complete")
                
            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Camera"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                
                self.resultJSON["Camera"].int = 1
                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Camera"])

                self.dismiss(animated: true, completion: nil)
            }
            else{
                if  UIDevice.current.modelName == "iPhone 5c" || UIDevice.current.modelName == "iPhone 5" {
                    UserDefaults.standard.set(false, forKey: "fingerprint")
                    let vc = BlueToothTestingVC()
                    self.resultJSON["Fingerprint Scanner"].int = -2
                    self.resultJSON["Camera"].int = 1
                    vc.resultJSON = self.resultJSON
                    vc.iscomingFromHome = true
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    let vc = FingerPrintDevice()
                    self.resultJSON["Camera"].int = 1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Camera"].int = 1

                }
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                    
                }else {
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                    //Sameer 14/4/2020
                    userDefaults.removeObject(forKey: "fingerprint_complete")
                    userDefaults.setValue(false, forKey: "fingerprint_complete")
                }
            }
        }
        
        self.present(camera, animated: true, completion: nil)
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSkipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Camera Diagnosis".localized(lang: langCode)
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?".localized(lang: langCode)
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
            DispatchQueue.main.async() {
                UserDefaults.standard.set(false, forKey: "camera")
                userDefaults.setValue(true, forKey: "camera_complete")
                
                if self.isComingFromTestResult{
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Camera"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    if  UIDevice.current.modelName == "iPhone 5c" || UIDevice.current.modelName == "iPhone 5"{
                        UserDefaults.standard.set(false, forKey: "fingerprint")
                        let vc = BlueToothTestingVC()
                        self.resultJSON["Fingerprint Scanner"].int = -2
                        self.resultJSON["Camera"].int = -1
                        vc.iscomingFromHome = true
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        let vc = FingerPrintDevice()
                        self.resultJSON["Camera"].int = -1
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Camera"].int = -1
                    
                }
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                    
                }else {
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                    //Sameer 14/4/2020
                    userDefaults.removeObject(forKey: "fingerprint_complete")
                    userDefaults.setValue(false, forKey: "fingerprint_complete")
                }
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
