//
//  OrderHeaderCell.swift
//  TechCheck
//
//  Created by TechCheck on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class OrderHeaderCell: UITableViewCell {

    //@IBOutlet weak var btnBankLeadingConstraint: NSLayoutConstraint!
    //@IBOutlet weak var btnConvertToOrder: UIButton!
    //@IBOutlet weak var downArrow: UIImageView!
    //@IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    //@IBOutlet weak var btnBank: UIButton!
    //@IBOutlet weak var btnDocumentUpLoad: UIButton!
    //@IBOutlet weak var btnBankDetail: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    //@IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var phoneName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    //@IBOutlet weak var lblOrderID: UILabel!
    //@IBOutlet weak var lblPaymentMode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.lblVerified.layer.cornerRadius = 5.0
        
        DispatchQueue.main.async {
            //UIView.addShadowOn4side(baseView: self.viewBG)
            self.viewBG.layer.borderWidth = 1.0
            self.viewBG.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
