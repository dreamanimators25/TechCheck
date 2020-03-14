//  TestResultCell.swift
//  InstaCash
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.

import UIKit

class TestResultCell: UITableViewCell {
    
    @IBOutlet weak var lblReTry: UILabel!
    @IBOutlet weak var imgReTry: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
