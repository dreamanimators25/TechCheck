//
//  MyOrdersCell.swift
//  InstaCash
//
//  Created by Sameer Khan on 12/04/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyOrdersCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: UIView!

    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderDetail: UILabel!
    
    @IBOutlet weak var imgPlaced: UIImageView!
    @IBOutlet weak var lblPlaced: UILabel!
    @IBOutlet weak var lblPlacedRight: UILabel!
    
    @IBOutlet weak var imgVerify: UIImageView!
    @IBOutlet weak var lblVerify: UILabel!
    @IBOutlet weak var lblVerifyLeft: UILabel!
    @IBOutlet weak var lblVerifyRight: UILabel!
    
    @IBOutlet weak var imgOutFor: UIImageView!
    @IBOutlet weak var lblOutFor: UILabel!
    @IBOutlet weak var lblOutForLeft: UILabel!
    @IBOutlet weak var lblOutForRight: UILabel!
    
    @IBOutlet weak var imgPacman: UIImageView!
    @IBOutlet weak var lblPacman: UILabel!
    @IBOutlet weak var lblPacmanLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewBg.clipsToBounds = true
        
        self.lblOrderDetail.text = "Order Details".localized(lang: langCode)
        self.lblPlaced.text = "Placed".localized(lang: langCode)
        self.lblVerify.text = "Verify".localized(lang: langCode)
        self.lblOutFor.text = "Out For Pickup".localized(lang: langCode)
        self.lblPacman.text = "Pacman Cancelled".localized(lang: langCode)
        
    }
    
}
