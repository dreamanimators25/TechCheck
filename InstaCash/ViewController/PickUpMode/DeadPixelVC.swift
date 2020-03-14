//
//  DeadPixelVC.swift
//  InstaCash
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
    @IBOutlet weak var deadPixelInfo: UILabel!
    @IBOutlet weak var deadPixelInfoImage: UIImageView!
    @IBOutlet weak var startTestBtn: UIButton!
    
    var resultJSON = JSON()
    var timer: Timer?
    var timerIndex = 0
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        deadPixelInfoImage.loadGif(name: "dead_pixel")
        lblPrice.text = CustomUserDefault.getCurrency()
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
            let title = "Dead Pixel Test"
            let message = "Did you see any black or white spots on the screen?"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
            
            // Create buttons
            let buttonOne = CancelButton(title: "Yes") {
                self.resultJSON["Dead Pixels"].int = 0
                UserDefaults.standard.set(false, forKey: "deadPixel")
                //let vc = FirstDiagnosisQuestionVC()
                
                let vc = PickUpQuestionVC()
                vc.resultJSON = self.resultJSON
                let nav = UINavigationController(rootViewController: vc)
                UINavigationBar.appearance().barTintColor = navColor
                self.present(nav, animated: true, completion: nil)
                
            }
            
            let buttonTwo = DefaultButton(title: "No") {
                self.resultJSON["Dead Pixels"].int = 1
                UserDefaults.standard.set(true, forKey: "deadPixel")
                //let vc = FirstDiagnosisQuestionVC()
                
                let vc = PickUpQuestionVC()
                vc.resultJSON = self.resultJSON
                let nav = UINavigationController(rootViewController: vc)
                UINavigationBar.appearance().barTintColor = navColor
                self.present(nav, animated: true, completion: nil)
                
            }
            
            let buttonThree = DefaultButton(title: "Retry") {
                self.startDeadPixelTestPressed(sender: nil)
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
            break
            
        default:
            self.view.backgroundColor = colors[timerIndex]
        }
        
    }

    @IBAction func startDeadPixelTestPressed(sender: AnyObject?) {
        checkVibrator()
        checkAudio()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.setRandomBackgroundColor), userInfo: nil, repeats: true)
        self.view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        self.startTestBtn.isHidden = true
        self.deadPixelInfo.isHidden = true
        self.deadPixelInfoImage.isHidden = true
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
    
    func checkAudio(){
        guard let filePath = Bundle.main.path(forResource: "whistle", ofType: "mp3") else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        print(url)
        playUsingAVAudioPlayer(url: url)
    }

}
