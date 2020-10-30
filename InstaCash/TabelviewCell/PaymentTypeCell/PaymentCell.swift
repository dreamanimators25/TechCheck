//
//  PaymentCell.swift
//  TechCheck
//
//  Created by TechCheck on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var imgBankName: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
