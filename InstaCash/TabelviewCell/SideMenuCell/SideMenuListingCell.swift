//
//  SideMenuListingCell.swift
//  TechCheck
//
//  Created by TechCheck on 12/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class SideMenuListingCell: UITableViewCell {
    
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblComunication: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
