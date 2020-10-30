//
//  SelectModelCell.swift
//  TechCheck
//
//  Created by TechCheck on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class SelectModelCell: UITableViewCell {

    @IBOutlet weak var lblMobileName: UILabel!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var imgViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
