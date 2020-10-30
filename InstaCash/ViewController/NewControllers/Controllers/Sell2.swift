//
//  Sell2.swift
//  TechCheck
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
    
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var notiLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    
    var strDevie = String()
    var imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblPhoneName.text = strDevie
        self.imgPhone.image = imgView.image
        
        lblGetMore.text = "Get" + " \(CustomUserDefault.getCurrency()) " + "50 more when you pass failed tests. Retry now"
        lblGetMore1.text = "Get" + " \(CustomUserDefault.getCurrency()) " + "50 more when you pass failed tests. Retry now"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.homeLbl.text = "Home"
        self.orderLbl.text = ""
        self.notiLbl.text = ""
        self.userLbl.text = ""
    }
    
}
