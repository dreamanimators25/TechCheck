//
//  TrandingDeviceCell.swift
//  InstaCash
//
//  Created by InstaCash on 14/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class TrandingDeviceCell: UICollectionViewCell {
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var imgDevice: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhoneName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.layer.cornerRadius = CGFloat(viewCornerRadius)
        viewBg.clipsToBounds = true
        // Initialization code
    }

}
