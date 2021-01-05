//
//  HistoryListTblCell.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class HistoryListTblCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgViewPhone: UIImageView!
    @IBOutlet weak var lblPhoneName: UILabel!
    @IBOutlet weak var lblPhonePrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSeeDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            UIView.addShadowOn4side(baseView: self.viewBG)
        }
        
        DispatchQueue.main.async {
            //self.lblSeeDetail.layer.cornerRadius = 5.0
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
