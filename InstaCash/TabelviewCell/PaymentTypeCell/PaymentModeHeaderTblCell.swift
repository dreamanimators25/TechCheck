//
//  PaymentModeHeaderTblCell.swift
//  TechCheck
//
//  Created by sameer khan on 04/06/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class PaymentModeHeaderTblCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var paymentGroupImgView: UIImageView!
    @IBOutlet weak var lblPaymentGroupName: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            self.baseView.layer.borderWidth = 1.0
            self.baseView.layer.borderColor = UIColor.gray.cgColor
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
