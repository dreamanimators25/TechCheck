//
//  ExactQuote.swift
//  TechCheck
//
//  Created by CULT OF PERSONALITY on 09/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class ExactQuote: UIViewController {
    
    @IBOutlet weak var lblTitleFirst: UILabel!
    @IBOutlet weak var lblTitleSecond: UILabel!
    @IBOutlet weak var lblTitleThird: UILabel!
    
    @IBOutlet weak var lblPriceFirst: UILabel!
    @IBOutlet weak var lblPriceSecond: UILabel!
    @IBOutlet weak var lblPriceThird: UILabel!
    
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewThird: UIView!
    
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    
    var strDevie = String()
    var imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPriceFirst.text = CustomUserDefault.getCurrency()
        lblPriceSecond.text = CustomUserDefault.getCurrency()
        lblPriceThird.text = CustomUserDefault.getCurrency()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAction(_ sender: Any) {
        
        let btn = sender as! UIButton
        
        if(btn == btnFirst)
        {
            lblTitleFirst.textColor = UIColor.white
            lblPriceFirst.textColor = UIColor.white
            lblTitleSecond.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceSecond.textColor = UIColor.black
            lblTitleThird.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceThird.textColor = UIColor.black
            
            viewFirst.backgroundColor = UIColor().colorGreen()
            viewSecond.backgroundColor = UIColor.white
            viewThird.backgroundColor = UIColor.white
            
        }
        else if(btn == btnSecond)
        {
            lblTitleSecond.textColor = UIColor.white
            lblPriceSecond.textColor = UIColor.white
            lblTitleFirst.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceFirst.textColor = UIColor.black
            lblTitleThird.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceThird.textColor = UIColor.black
            
            viewFirst.backgroundColor = UIColor.white
            viewSecond.backgroundColor = UIColor().colorGreen()
            viewThird.backgroundColor = UIColor.white
        }
        else
        {
            lblTitleThird.textColor = UIColor.white
            lblPriceThird.textColor = UIColor.white
            lblTitleSecond.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceSecond.textColor = UIColor.black
            lblTitleFirst.textColor = UIColor().HexToColor(hexString:"A1A1A1")
            lblPriceFirst.textColor = UIColor.black
            
            viewFirst.backgroundColor = UIColor.white
            viewSecond.backgroundColor = UIColor.white
            viewThird.backgroundColor = UIColor().colorGreen()
        }
    }
}
