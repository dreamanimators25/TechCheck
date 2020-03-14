//
//  DeviceChargerVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import PopupDialog
import DKCamera
import SwiftGifOrigin
import SwiftyJSON

class DeviceChargerVC: UIViewController {
    
    @IBOutlet weak var viewGuide: UIView!
    
    var resultJSON = JSON()
    var imagePicker: UIImagePickerController!
    var isComingFromTestResult = false
    var isComingFromProductquote = false

    @IBOutlet weak var chargerInfoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingFromTestResult == false && isComingFromProductquote == false{
            userDefaults.removeObject(forKey: "charger_complete")
            userDefaults.setValue(false, forKey: "charger_complete")
        }

        chargerInfoImage.loadGif(name: "charging")
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        self.viewGuide.isHidden = true
    }
    
    @IBAction func btnStartPressed(_ sender: UIButton) {
        
        //self.viewGuide.isHidden = false
        let btn = UIButton()
        
        self.btnSkipPressed(btn)
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSkipPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Device Charger Diagnosis"
        let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?"
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes") {
            DispatchQueue.main.async() {
                UserDefaults.standard.set(false, forKey: "charger")
                userDefaults.setValue(true, forKey: "charger_complete")
                if self.isComingFromTestResult{
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["USB"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    let vc = CameraVC()
                    self.resultJSON["USB"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["USB"].int = -1

                }
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

            }
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
    
    @objc func batteryStateDidChange(notification: NSNotification){
        // The stage did change: plugged, unplugged, full charge...
        DispatchQueue.main.async() {
            UserDefaults.standard.set(true, forKey: "charger")
            userDefaults.setValue(true, forKey: "charger_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                self.resultJSON["USB"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true{
                self.resultJSON["USB"].int = 1
                   NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Charger"])
//                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Charger")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = CameraVC()
                self.resultJSON["USB"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                self.resultJSON["USB"].int = 1

            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")

        }
        
        
    }
    
    
    @objc func batteryLevelDidChange(notification: NSNotification){
        // The battery's level did change (98%, 99%, ...)
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
