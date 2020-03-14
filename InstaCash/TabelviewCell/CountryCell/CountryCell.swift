//
//  CountryCell.swift
//  InstaCash
//
//  Created by InstaCash on 11/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
