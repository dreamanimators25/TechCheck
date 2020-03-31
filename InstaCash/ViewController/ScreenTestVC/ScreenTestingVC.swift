//
//  ScreenTestingVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyJSON
import PopupDialog
import MFSideMenu
import CoreMotion
import AVFoundation
import AudioToolbox
import Firebase

class LevelView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        let levelLayer = CAShapeLayer()
        levelLayer.path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                           y: 0,
                                                           width: frame.width,
                                                           height: frame.height),
                                       cornerRadius: 0).cgPath
        levelLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(levelLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required, but Will not be called in a Playground")
    }
}

class ScreenTestingVC: UIViewController,RecorderDelegate {
    
    @IBOutlet weak var viewGuide: UIView!

    @IBOutlet weak var screenImageView: UIImageView!
    //@IBOutlet weak var startScreenBtn: UIButton!
    
    var obstacleViews : [UIView] = []
    var flags: [Bool] = []
    var countdownTimer: Timer!
    var totalTime = 40
    var startTest = false
    var resultJSON = JSON()
    var isComingFromTestResult = false
    var isComingFromProductquote = false

    var audioPlayer: AVAudioPlayer!
    var recording: Recording!
    var recordDuration = 0
    
    func audioMeterDidUpdate(_ db: Float) {
        self.recording.recorder?.updateMeters()
        let ALPHA = 0.05
        let peakPower = pow(10, (ALPHA * Double((self.recording.recorder?.peakPower(forChannel: 0))!)))
        var rate: Double = 0.0
        if (peakPower <= 0.2) {
            rate = 0.2
        } else if (peakPower > 0.9) {
            rate = 1.0
        } else {
            rate = peakPower
        }
        recordDuration += 1
    }
    
    open func createRecorder() {
        recording = Recording(to: "recording.m4a")
        recording.delegate = self
        
        // Optionally, you can prepare the recording in the background to
        // make it start recording faster when you hit `record()`.
        
        DispatchQueue.global().async {
            // Background thread
            do {
                try self.recording.prepare()
            } catch {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // createRecorder()
        userDefaults.setValue(true, forKey: "screen_complete")
        userDefaults.setValue(true, forKey: "rotation_complete")
        userDefaults.setValue(true, forKey: "proximity_complete")
        userDefaults.setValue(true, forKey: "volumebutton_complete")

        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            userDefaults.setValue(true, forKey: "earphone_complete")
            userDefaults.setValue(true, forKey: "charger_complete")
        }
        else{
            userDefaults.setValue(true, forKey: "earphone_complete")
            userDefaults.setValue(true, forKey: "charger_complete")
        }
        userDefaults.setValue(true, forKey: "camera_complete")
         if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone XS" || UIDevice.current.modelName == "iPhone XS Max" || UIDevice.current.modelName == "iPhone 5c" || UIDevice.current.modelName == "iPhone 5" || UIDevice.current.modelName == "iPhone XR"{
            userDefaults.setValue(true, forKey: "fingerprint_complete")
        }
         else{
            userDefaults.setValue(true, forKey: "fingerprint_complete")
        }
        
        userDefaults.setValue(true, forKey: "bluetooth_complete")
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        Analytics.logEvent("start_diagnosis_test", parameters: [
            "event_category":"start diagnosis",
            "event_action":"start diagnosis with screen test",
            "event_label":"screen test"
            ])
        setNavigationBar()
        screenImageView.loadGif(name: "final_touch")
        checkVibrator()
        checkAudio()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.menuContainerViewController.panMode = MFSideMenuPanMode(rawValue: 0)
//    }
    
    func checkAudio(){
        guard let filePath = Bundle.main.path(forResource: "whistle", ofType: "mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        self.playUsingAVAudioPlayer(url: url)

        //startRecording(url: url)
    }
    
    func checkVibrator(){
        let manager = CMMotionManager()
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x > 0.03 {
                    self?.resultJSON["Vibrator"].int = 1
                    manager.stopDeviceMotionUpdates()
                }
            }
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    open func startRecording(url: URL) {
        recordDuration = 0
        do {
            Timer.scheduledTimer(timeInterval: 2,
                                 target: self,
                                 selector: #selector(self.stopRecording),
                                 userInfo: nil,
                                 repeats: false)
            try recording.record()
           // self.playUsingAVAudioPlayer(url: url)
        } catch {
        }
    }
    
    @objc func stopRecording(){
        recordDuration = 0
        recording.stop()
        do {
            try recording.play()
        } catch {
        }
    }
    
    func playUsingAVAudioPlayer(url: URL) {
        self.resultJSON["Speakers"].int = 1
        self.resultJSON["MIC"].int = 1
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
        } catch {
        }
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "InstaCash"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(ScreenTestingVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    
    @IBAction func onClickRetry(_ sender: Any) {
        
    }
    
    @IBAction func onClickGuide(_ sender: Any) {
        self.viewGuide.isHidden = false
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        self.viewGuide.isHidden = true
    }
    
    @objc func btnBackPressed() -> Void {
        if isComingFromTestResult {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func beginScreenBtnClicked(_ sender: UIButton) {
        drawScreenTest()
    }
    
    func drawScreenTest(){
        //startScreenBtn.isHidden = true
        //screenImageView.isHidden = true
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth:Int = Int(screenSize.width) + 10
        let screenHeight:Int = Int(screenSize.height)
        let widthPerimeterImage:Int =  Int(screenWidth/9)
        let heightPerimeterImage:Int = Int((screenHeight)/14)
        
        var l = 0
        var t = 20
        
        for _ in (0..<14).reversed()
        {
            for _ in (0..<9).reversed()
            {
                let view = LevelView(frame: CGRect(x: l, y: t, width: widthPerimeterImage, height: heightPerimeterImage))
                l = l+widthPerimeterImage
                
                obstacleViews.append(view)
                flags.append(false)
                self.view.addSubview(view)
            }
            l=0
            t=t+heightPerimeterImage
        }
        startTest = true
        startTimer()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testTouches(touches: touches)
        
        //        if let layer = self.view.layer.hitTest(point!) as? CAShapeLayer { // If you hit a layer and if its a Shapelayer
        //            if CGPathContainsPoint(layer.path, nil, point, false) { // Optional, if you are inside its content path
        //            }
        //        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!) {
        testTouches(touches: touches)
    }
    
    func testTouches(touches: Set<UITouch>) {
        // Get the first touch and its location in this view controller's view coordinate system
        let touch = touches.first
        let touchLocation = touch?.location(in: self.view)
        var finalFlag = true
        
        for (index,obstacleView) in obstacleViews.enumerated() {
            // Convert the location of the obstacle view to this view controller's view coordinate system
            let obstacleViewFrame = self.view.convert(obstacleView.frame, from: obstacleView.superview)
            
            // Check if the touch is inside the obstacle view
            if obstacleViewFrame.contains(touchLocation!) {
                flags[index] = true
                let levelLayer = CAShapeLayer()
                levelLayer.path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                                   y: 0,
                                                                   width: obstacleViewFrame.width ,
                                                                   height: obstacleViewFrame.height),
                                               cornerRadius: 0).cgPath
                levelLayer.fillColor = UIColor.green.cgColor
                obstacleView.layer.addSublayer(levelLayer)
                
            }
            finalFlag = flags[index]&&finalFlag
        }
        if finalFlag && startTest{
            endTimer(type: 1)
        }
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer(type: 0)
        }
    }
    
    func endTimer(type: Int) {
        countdownTimer.invalidate()
        if type == 1 {
            UserDefaults.standard.set(true, forKey: "screen")
            userDefaults.setValue(true, forKey: "screen_complete")
            
            if isComingFromTestResult {
                let vc = DiagnosticTestResultVC()
                resultJSON["Screen"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if self.isComingFromProductquote == true {
                //                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: "Screen")
                resultJSON["Screen"].int = 1
                NotificationCenter.default.post(name: Notification.Name("Product_quote_DataChageForSkippedTpPass"), object: self.resultJSON,userInfo: ["TestPassName": "Screen"])
                
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let vc = RotationVC()
                resultJSON["Screen"].int = 1
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            
            if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                self.resultJSON = sendJson
                resultJSON["Screen"].int = 1
                
            }
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
            
            //self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }else{
            
            let title = "Screen Diagnosis Test Failed!"
            let message = "Do you want to retry the test?"
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = DefaultButton(title: "Yes") {
                popup.dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    for v in self.obstacleViews{
                        v.removeFromSuperview()
                    }
                    self.obstacleViews = []
                    self.flags = []
                    self.totalTime = 40
                    self.startTest = false
                    self.resultJSON = JSON()
                    //self.startScreenBtn.isHidden = false
                    self.screenImageView.isHidden = false
                }
                
            }
            
            let buttonTwo = CancelButton(title: "No") {
                //Do Nothing
                userDefaults.setValue(true, forKey: "screen_complete")
                UserDefaults.standard.set(false, forKey: "screen")
                if self.isComingFromTestResult{
                    let vc = DiagnosticTestResultVC()
                    self.resultJSON["Screen"].int = 0
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                else if self.isComingFromProductquote == true{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    let vc = RotationVC()
                    self.resultJSON["Screen"].int = 0
                    vc.resultJSON = self.resultJSON
                    self.present(vc, animated: true, completion: nil)
                }
                if (userDefaults.value(forKey: "Diagnosis_DataSave") != nil){
                    let sendJson =  JSON.init(parseJSON:userDefaults.value(forKey: "Diagnosis_DataSave") as! String)
                    self.resultJSON = sendJson
                    self.resultJSON["Screen"].int = 0
                    
                }
                userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave")
                
                
                //                let vc = RotationVC()
                //                self.resultJSON["Screen"].int = 0
                //                vc.resultJSON = self.resultJSON
                //                self.present(vc, animated: true, completion: nil)
                
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
