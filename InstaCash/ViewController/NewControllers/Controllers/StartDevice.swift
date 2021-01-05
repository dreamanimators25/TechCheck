//
//  StartDeviceCondition.swift
//  TechCheck
//
//  Created by CULT OF PERSONALITY on 10/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class StartDevice: UIViewController {
    
    @IBOutlet weak var btnStartDevice: UIButton!
    @IBOutlet weak var lblWeAre: UILabel!
    @IBOutlet weak var lblAwesome: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setStatusBarColor()
    }
    
    func changeLanguageOfUI() {
        
        self.lblWeAre.text = "We’re almost there. The final thing we need from you is an honest self-report of the device condition.".localized(lang: langCode)
        self.lblAwesome.text = "Awesome! One last thing…".localized(lang: langCode)
        
        self.btnStartDevice.setTitle("Start device condition reporting".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeLanguageOfUI()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeviceCondition(_ sender: Any) {
        let vc = StartDevice1()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
