//
//  YoursOrderCell.swift
//  InstaCash
//
//  Created by InstaCash on 13/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class YoursOrderCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var imgOrder: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewBg.clipsToBounds = true
    }

}
