//
//  ChangeModePopUpVC.swift
//  TechCheck
//
//  Created by TechCheck on 17/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

protocol ShowVerificationCodeDelegate {
    func showVerificationCodePopUp(processFor:String)
}

class ChangeModePopUpVC: UIViewController {

    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lbltile: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewMiddle: UIView!
    
    var strProcessForDiagnosis = ""
    var delegate:ShowVerificationCodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMiddle.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewMiddle.clipsToBounds = true
        
        self.setStatusBarColor()
        
        if strProcessForDiagnosis == "Yes"{
            imgLogo.image = UIImage(named: "diagnosisMode")
            lbltile.text = "Entering Diagnosis Mode"
            lblSubtitle.text = "The app is now enterning the Diagnosis mode.Do you want to continue?"
        }
        else{
            imgLogo.image = UIImage(named: "pickUpMode")
            lbltile.text = "Entering Pickup Mode"
            lblSubtitle.text = "The app is now enterning the Pickup mode.Do you want to continue?"
        }
        
    }

    @IBAction func btnYesPressed(_ sender: UIButton) {
        self.delegate?.showVerificationCodePopUp(processFor: strProcessForDiagnosis)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnNoPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
