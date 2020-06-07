//
//  MobileNumberCell.swift
//  InstaCash
//
//  Created by sameer khan on 06/06/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MobileNumberCell: UITableViewCell {
    
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var paymentImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
