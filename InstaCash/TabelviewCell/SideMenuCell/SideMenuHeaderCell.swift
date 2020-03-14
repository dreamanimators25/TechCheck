//
//  SideMenuHeaderCell.swift
//  InstaCash
//
//  Created by InstaCash on 12/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class SideMenuHeaderCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.layer.cornerRadius = imgUser.frame.height/2
        imgUser.clipsToBounds = true
        btnSignIn.layer.cornerRadius = CGFloat(btnCornerRadius)
        imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
