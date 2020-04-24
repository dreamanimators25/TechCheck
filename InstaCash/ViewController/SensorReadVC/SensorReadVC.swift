//
//  SensorReadVC.swift
//  InstaCash
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.

import UIKit
import PopupDialog
import SwiftyJSON

class SensorReadVC: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewGuide: UIView!
    //@IBOutlet weak var proximityText: UILabel!
    @IBOutlet weak var proximityImageView: UIImageView!
    
    @IBOutlet weak var lblCheckingProximity: UILabel!
    @IBOutlet weak var lblWaveHand: UILabel!
    @IBOutlet weak var btnGuideMe: UIButton!
    @IBOutlet weak var lblNotWorking: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    
    var resultJSON = JSON()
    var isComingFromTestResult = false
    var isComingFromProductquote = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "proximity_complete")
        userDefaults.setValue(false, forKey: "proximity_complete")
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "proximity_complete")
            userDefaults.setValue(false, forKey: "proximity_complete")
        }
        
        //proximityText.isHidden = false
        proximityImageView.loadGif(name: "proximity")
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector((self.proximityChanged)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        }
        
        lblPrice.text = CustomUserDefault.getCurrency()
        //self.set()
        
    }
    
    func changeLanguageOfUI() {
        
        self.lblCheckingProximity.text = "Checking proximity sensors".localized(lang: langCode)
        self.lblWaveHand.text = "Wave your hand on the device’s screen.".localized(lang: langCode)
        
        //self.btnGuideMe.setTitle("Guide me".localized(lang: langCode), for: UIControlState.normal)
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: navColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)] as [NSAttributedStringKey : Any]
        let str = NSAttributedString.init(string: "Guide me".localized(lang: langCode), attributes: myAttribute)
        self.btnGuideMe.setAttributedTitle(str, for: .normal)
        
        self.lblNotWorking.text = "It’s not working.".localized(lang: langCode)
        self.btnStart.setTitle("Start".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppOrientationUtility.lockOrientation(.portrait)
        
        self.changeLanguageOfUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        set()
    }
    
    func set()
    {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
        UserDefaults.standard.set(true, forKey: "proximity")
        userDefaults.setValue(true, forKey: "proximity_complete")
        
        if self.isComingFromTestResult{
            let vc = DiagnosticTestResultVC()
            self.resultJSON["Proximity"].int = 1
            vc.resultJSON = self.resultJSON
            self.present(vc, animated: true, completion: nil)
        }
        else if self.isComingFromProductquote == true{
            //  NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Proximity")
            
            resultJSON["Proximity"].int = 1
            NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Proximity"])
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let vc = VolumeCheckerVC()
            self.resultJSON["Proximity"].int = 1
            vc.resultJSON = self.resultJSON
            self.present(vc, animated: true, completion: nil)
        }
        if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
            let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
            self.resultJSON = sendJson
            self.resultJSON["Proximity"].int = 1
            
        }
        
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
            
        }else {
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
            
            //Sameer 14/4/2020
            userDefaults.removeObject(forKey: "volumebutton_complete")
            userDefaults.setValue(false, forKey: "volumebutton_complete")
        }
        
        //            let secondViewController:CameraViewController = CameraViewController()
        
        //            self.present(secondViewController, animated: true, completion: nil)
        
    }
    
    /*@IBAction func btnskipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Proximity Sensor Diagnosis"
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?"
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes") {
            UserDefaults.standard.set(false, forKey: "proximity")
            userDefaults.setValue(true, forKey: "proximity_complete")
            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Proximity"].int = -1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = VolumeCheckerVC()
                self.resultJSON["Proximity"].int = -1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Proximity"].int = -1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
     
     //Sameer 14/4/2020
     userDefaults.removeObject(forKey: "volumebutton_complete")
     userDefaults.setValue(false, forKey: "volumebutton_complete")

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
    }*/
    
    @objc func proximityChanged(notification: NSNotification) {
        if (notification.object as? UIDevice) != nil {
            let device = UIDevice.current
            device.isProximityMonitoringEnabled = false
            UserDefaults.standard.set(true, forKey: "proximity")
            userDefaults.setValue(true, forKey: "proximity_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["Proximity"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
//                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Proximity")
                
                resultJSON["Proximity"].int = 1
                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Proximity"])
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = VolumeCheckerVC()
                self.resultJSON["Proximity"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["Proximity"].int = 1

            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
            }else {
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "volumebutton_complete")
                userDefaults.setValue(false, forKey: "volumebutton_complete")
            }

            
            //            let secondViewController:CameraViewController = CameraViewController()
            
            //            self.present(secondViewController, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickGuide(_ sender: Any) {
        self.viewGuide.isHidden = false
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*@IBAction func onClickSkip(_ sender: Any) {
        
        let vc = VolumeCheckerVC()
        self.resultJSON["Proximity"].int = 1
        vc.resultJSON = self.resultJSON
        self.present(vc, animated: true, completion: nil)
        
    }*/
    
    @IBAction func onClickStart(_ sender: Any) {
        self.viewGuide.isHidden = true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
