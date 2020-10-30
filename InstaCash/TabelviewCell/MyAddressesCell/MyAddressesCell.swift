//
//  MyAddressesCell.swift
//  TechCheck
//
//  Created by TechCheck on 28/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyAddressesCell: UITableViewCell {

    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var lblLandMark: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
