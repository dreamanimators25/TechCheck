//
//  HeaderDetailCell.swift
//  TechCheck
//
//  Created by TechCheck on 08/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class HeaderDetailCell: UITableViewCell {

    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
