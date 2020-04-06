//
//  StartDeviceCondition.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 10/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class StartDevice1: UIViewController {
    
    @IBOutlet weak var btnReady: UIButton!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lblHii: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            lbl.isHidden = false
        }else {
            lbl.isHidden = true
        }
        
    }
    
    func changeLanguageOfUI() {
        
        self.lbl.text = "You will need your charger and earphones.".localized(lang: langCode)
        self.lblHii.text = "Hi! You’re about to diagnose your phone to help us give you an exact quote.".localized(lang: langCode)
        
        self.btnReady.setTitle("I’m Ready".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeviceCondition(_ sender: Any) {
        // apply check for diagnose process, start from begning
        let vc = ScreenTestingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
