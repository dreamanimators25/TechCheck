//
//  DropOffAddTVCell.swift
//  InstaCash
//
//  Created by sameer khan on 24/12/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class DropOffAddTVCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgViewCircle: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            // Set border
            let borderWidth = CGFloat(1.0)
            let borderColor = UIColor.lightGray.cgColor
            
            self.viewBG.layer.borderWidth = borderWidth
            self.viewBG.layer.borderColor = borderColor
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
