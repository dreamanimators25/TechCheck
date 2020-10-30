//
//  ScreenTestPickUp.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 02/03/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
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

class LevelViewPickUp : UIView {
    
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

class ScreenTestPickUp: UIViewController {

    @IBOutlet weak var screenTestViewPickup: UIImageView!
    
    @IBOutlet weak var lblCheckScreen: UILabel!
    @IBOutlet weak var lblPressStart: UILabel!
    @IBOutlet weak var btnGuideMe: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var btnStartScreenTest: UIButton!
    
    
    var obstacleViews : [UIView] = []
    var flags: [Bool] = []
    var countdownTimer: Timer!
    var totalTime = 40
    var startTest = false
    var resultJSON = JSON()
    var audioPlayer: AVAudioPlayer?
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
       
        self.lblCheckScreen.text = "Checking screen calibration".localized(lang: langCode)
        self.lblPressStart.text = "Press “Start“ and follow the path".localized(lang: langCode)
        
        //self.btnGuideMe.setTitle("Guide me".localized(lang: langCode), for: UIControlState.normal)
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: navColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)] as [NSAttributedStringKey : Any]
        let str = NSAttributedString.init(string: "Total time for test 60sec".localized(lang: langCode), attributes: myAttribute)
        self.btnGuideMe.setAttributedTitle(str, for: .normal)
        
        self.btnStartScreenTest.setTitle("Start".localized(lang: langCode), for: UIControlState.normal)
        self.btnRetry.setTitle("Retry".localized(lang: langCode), for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        Analytics.logEvent("start_diagnosis_test", parameters: [
            "event_category":"start diagnosis",
            "event_action":"start diagnosis with screen test",
            "event_label":"screen test"
            ])*/
        
        setNavigationBar()
        screenTestViewPickup.loadGif(name: "final_touch")
        checkVibrator()
        checkAudio()
    }
    
    func checkAudio(){
        guard let filePath = Bundle.main.path(forResource: "whistle", ofType: "mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        playUsingAVAudioPlayer(url: url)
    }
    
    func checkVibrator(){
        let manager = CMMotionManager()
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.02
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x > 0.03  {
                    self?.resultJSON["Vibrator"].int = 1
                    manager.stopDeviceMotionUpdates()
                }
            }
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
        self.title = "TechCheck".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(ScreenTestPickUp.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    @objc func btnBackPressed() -> Void {
      
    }

    @IBAction func startScreenTestPressed(_ sender: UIButton) {
        drawScreenTest()
    }
    
    func drawScreenTest(){
        btnStartScreenTest.isHidden = true
        screenTestViewPickup.isHidden = true
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
                //levelLayer.fillColor = UIColor.green.cgColor
                levelLayer.fillColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1).cgColor
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
                let vc = DeadPixelVC()
                resultJSON["Screen"].int = 1
                vc.resultJSON = self.resultJSON
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            
            //self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }else{
            
            let title = "Screen Diagnosis Test Failed!".localized(lang: langCode)
            let message = "Do you want to retry the test?".localized(lang: langCode)
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = DefaultButton(title: "Yes".localized(lang: langCode)) {
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
                    self.btnStartScreenTest.isHidden = false
                    self.screenTestViewPickup.isHidden = false
                }
            }
            
            let buttonTwo = CancelButton(title: "No".localized(lang: langCode)) {
                //Do Nothing
                UserDefaults.standard.set(false, forKey: "screen")
                
                    let vc = DeadPixelVC()
                    self.resultJSON["Screen"].int = 0
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                
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
        
    }

}
