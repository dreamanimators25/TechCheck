//
//  TouchScreen.swift
//  TechCheck
//
//  Created by CULT OF PERSONALITY on 11/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Speaker: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPrice.text = CustomUserDefault.getCurrency()
        
        self.setStatusBarColor()
    }
    
    @IBAction func onClickGuideMe(sender: AnyObject) {
        
    }
    
    @IBAction func onClickStart(sender: AnyObject) {
    
    }
    
}
