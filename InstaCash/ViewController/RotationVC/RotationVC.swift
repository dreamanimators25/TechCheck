//
//  RotationVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
import PopupDialog

class RotationVC: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewGuid: UIView!
    @IBOutlet weak var AutoRotationImage: UIImageView!
    @IBOutlet weak var AutoRotationImageView: UIImageView!
    //@IBOutlet weak var AutoRotationText: UITextView!
    
    
    @IBOutlet weak var lblCheckingDevice: UILabel!
    @IBOutlet weak var lblPleaseEnsure: UILabel!
    @IBOutlet weak var btnGuideMe: UIButton!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var StartBtn: UIButton!
    
    
    var isComingFromTestResult = false
    var isComingFromProductquote = false

    var hasStarted = false
    var resultJSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "rotation_complete")
        userDefaults.setValue(false, forKey: "rotation_complete")
        
        if isComingFromTestResult == false && isComingFromProductquote == false{
            if userDefaults.value(forKey: "screen_complete") == nil {
                userDefaults.removeObject(forKey: "rotation_complete")
                userDefaults.setValue(false, forKey: "rotation_complete")
            }
        }
   
        setNavigationBar()
        AutoRotationImage.loadGif(name: "rotation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        lblPrice.text = CustomUserDefault.getCurrency()
        
    }
    
    func changeLanguageOfUI() {
  
        self.lblCheckingDevice.text = "Checking device rotation".localized(lang: langCode)
        self.lblPleaseEnsure.text = "Please ensure device rotation option is enabled. Press “Start’ and rotate your device as seen below.".localized(lang: langCode)
        
        self.btnGuideMe.setTitle("Guide me".localized(lang: langCode), for: UIControlState.normal)
        self.beginBtn.setTitle("Start".localized(lang: langCode), for: UIControlState.normal)
        self.StartBtn.setTitle("Start".localized(lang: langCode), for: UIControlState.normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppOrientationUtility.lockOrientation(.portrait)
        
        self.changeLanguageOfUI()
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "InstaCash".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(RotationVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        self.viewGuid.isHidden = true
    }
    
    @IBAction func onClickGuide(_ sender: Any) {
        self.viewGuid.isHidden = false
    }
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func beginBtnClicked(_ sender: UIButton) {
        if hasStarted {
            // Prepare the popup assets
            let title = "Auto Rotation Diagnosis".localized(lang: langCode)
            let message = "If you skip this test there would be a substantial decline in the price offered. Do you still want to skip?".localized(lang: langCode)
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
            userDefaults.setValue(true, forKey: "rotation_complete")
                UserDefaults.standard.set(false, forKey: "rotation")

                if self.isComingFromTestResult{
                    self.hasStarted = false
                    
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Rotation"].int = -1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true || userDefaults.value(forKey: "isSkippedRotation") as? Bool ?? false == true{
                   // self.hasStarted = false
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.hasStarted = false
                    if userDefaults.value(forKey: "isSkippedRotation") as? Bool ?? false == true{
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        let vc = SensorReadVC()
                        self.resultJSON["Rotation"].int = -1
                        vc.resultJSON = self.resultJSON
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                   
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Rotation"].int = -1

                }
                
                if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                    
                }else {
                    
                    userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                    
                    //Sameer 14/4/2020
                    userDefaults.removeObject(forKey: "proximity_complete")
                    userDefaults.setValue(false, forKey: "proximity_complete")
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
            
        }else{
            hasStarted = true
            AppOrientationUtility.lockOrientation(.all)

            //AutoRotationText.text = "Please Tilt your Phone to Landscape mode."
            beginBtn.setTitle("Skip".localized(lang: langCode),for: .normal)
            AutoRotationImage.isHidden = true
            //AutoRotationImageView.isHidden = false
            //AutoRotationImageView.image = UIImage(named: "landscape_image")!
        }
    }
    
    @objc func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            //AutoRotationText.text = "Please Tilt your Phone back to Portrait mode."
            //AutoRotationImageView.image = UIImage(named: "portrait_image")!
            
        }
        
        if hasStarted == true {
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            hasStarted = false
            UserDefaults.standard.set(true, forKey: "rotation")
            userDefaults.setValue(true, forKey: "rotation_complete")

            if self.isComingFromTestResult{
                let vc = DiagnosticTestResultVC()
                resultJSON["Rotation"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true || userDefaults.value(forKey: "isSkippedRotation") as? Bool ?? false == true{
//                     NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Rotation")
                resultJSON["Rotation"].int = 1
                  NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Rotation"])
                
                    self.dismiss(animated: true, completion: nil)
            }
            else{
                if  userDefaults.value(forKey: "isSkippedRotation") as? Bool ?? false == true{
                    
//                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Rotation")
                    resultJSON["Rotation"].int = 1
                    NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Rotation"])
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    let vc = SensorReadVC()
                    resultJSON["Rotation"].int = 1
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
              
            }
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                resultJSON["Rotation"].int = 1

            }
            
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" || userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup" {
                
                
            }else {
                
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                //Sameer 14/4/2020
                userDefaults.removeObject(forKey: "proximity_complete")
                userDefaults.setValue(false, forKey: "proximity_complete")
            }
           
        }
        }
        
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
