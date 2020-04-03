//
//  Sell2.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 08/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Sell2: UIViewController {

    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    
    @IBOutlet weak var lblGetMore: UILabel!
    @IBOutlet weak var lblGetMore1: UILabel!
    
    var strDevie = String()
    var imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblPhoneName.text = strDevie
        self.imgPhone.image = imgView.image
        
        lblGetMore.text = "Get" + " \(CustomUserDefault.getCurrency()) " + "50 more when you pass failed tests. Retry now"
        lblGetMore1.text = "Get" + " \(CustomUserDefault.getCurrency()) " + "50 more when you pass failed tests. Retry now"
        
    }
}
