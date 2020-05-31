//
//  TextBoxCell.swift
//  InstaCash
//
//  Created by sameer khan on 31/05/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class TextBoxCell: UITableViewCell {
    
    @IBOutlet weak var txtField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
