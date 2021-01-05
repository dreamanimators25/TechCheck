//
//  DeadPixelVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 02/03/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import PopupDialog
import AVFoundation
import SwiftGifOrigin
import AudioToolbox
import SwiftyJSON
import CoreMotion
import AVFoundation

class DeadPixelVC: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var deadPixelInfoImage: UIImageView!
    @IBOutlet weak var deadPixelGifImage: UIImageView!
    
    @IBOutlet weak var titleInfoLbl: UILabel!
    @IBOutlet weak var deadPixelInfoLbl: UILabel!
    @IBOutlet weak var btnGuideMe: UIButton!
    @IBOutlet weak var startTestBtn: UIButton!
    
    var resultJSON = JSON()
    var timer: Timer?
    var timerIndex = 0
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
        
        //4/4/20
        //self.deadPixelGifImage.isHidden = true

        //s. 18/3/20
        self.deadPixelGifImage.loadGif(name: "dead_pixel")
        //lblPrice.text = CustomUserDefault.getCurrency()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.titleInfoLbl.text = "Checking screen for white or black dot".localized(lang: langCode)
        self.deadPixelInfoLbl.text = "We will show you white screen with maximum brightness for 8-10 seconds. Please tell us if you see a black dot.".localized(lang: langCode)
        
        //self.btnGuideMe.setTitle("Guide me".localized(lang: langCode), for: UIControlState.normal)
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: navColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)] as [NSAttributedStringKey : Any]
        let str = NSAttributedString.init(string: "Guide me".localized(lang: langCode), attributes: myAttribute)
        self.btnGuideMe.setAttributedTitle(str, for: .normal)
        
        self.startTestBtn.setTitle("Start".localized(lang: langCode), for: UIControlState.normal)
    }
    
    @objc func setRandomBackgroundColor() {
        timerIndex += 1
        
        let colors = [
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        ]
        
        switch timerIndex {
        case 5:
            self.view.backgroundColor = colors[timerIndex]
            timer?.invalidate()
            timer = nil
            
            
            // Prepare the popup assets
            let title = "Dead Pixel Test".localized(lang: langCode)
            let message = "Did you see any black or white spots on the screen?".localized(lang: langCode)
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = CancelButton(title: "Yes".localized(lang: langCode)) {
                self.resultJSON["Dead Pixels"].int = 0
                UserDefaults.standard.set(false, forKey: "deadPixel")
                //let vc = FirstDiagnosisQuestionVC()
                
                if userDefaults.value(forKey: "pickupDiagnose") as? String == "pickupDiagnose" {
                    let vc = RotationVC()
                    
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else {
                    let vc = PickUpQuestionVC()
                    vc.resultJSON = self.resultJSON
                    let nav = UINavigationController(rootViewController: vc)
                    UINavigationBar.appearance().barTintColor = navColor
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
                
            }
            
            let buttonTwo = DefaultButton(title: "No".localized(lang: langCode)) {
                self.resultJSON["Dead Pixels"].int = 1
                UserDefaults.standard.set(true, forKey: "deadPixel")
                //let vc = FirstDiagnosisQuestionVC()
                
                if userDefaults.value(forKey: "pickupDiagnose") as? String == "pickupDiagnose" {
                    let vc = RotationVC()
                    
                    vc.resultJSON = self.resultJSON
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else {
                    let vc = PickUpQuestionVC()
                    vc.resultJSON = self.resultJSON
                    let nav = UINavigationController(rootViewController: vc)
                    UINavigationBar.appearance().barTintColor = navColor
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
                                
            }
            
            let buttonThree = DefaultButton(title: "Retry".localized(lang: langCode)) {
                self.startDeadPixelTestPressed(sender: nil)
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
            break
            
        default:
            self.view.backgroundColor = colors[timerIndex]
        }
        
    }

    @IBAction func startDeadPixelTestPressed(sender: AnyObject?) {
        checkVibrator()
        checkAudio()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
        //self.view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1) //s. 18/3/20
        
        self.startTestBtn.isHidden = true
        self.deadPixelInfoLbl.isHidden = true
        self.titleInfoLbl.isHidden = true
        self.deadPixelInfoImage.isHidden = true
        self.deadPixelGifImage.isHidden = true
        
        //S. 18/3/20
        //S. 4/4/20
        //self.deadPixelGifImage.isHidden = false
        //deadPixelInfoImage.loadGif(name: "dead_pixel") //s. 18/3/20
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
    
    func checkAudio(){
        guard let filePath = Bundle.main.path(forResource: "whistle", ofType: "mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        print(url)
        playUsingAVAudioPlayer(url: url)
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

}
