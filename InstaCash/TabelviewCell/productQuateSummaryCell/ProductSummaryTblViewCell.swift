//
//  ProductSummaryTblViewCell.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 16/12/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class ProductSummaryTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuateName: UILabel!
    @IBOutlet weak var lblQuateValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
