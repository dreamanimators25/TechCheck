//
//  StartDeviceCondition.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 10/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class StartDevice1: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            lbl.isHidden = false
        }else {
            lbl.isHidden = true
        }
        
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
