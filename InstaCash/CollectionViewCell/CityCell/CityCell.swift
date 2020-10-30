//
//  CityCell.swift
//  TechCheck
//
//  Created by TechCheck on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class CityCell: UICollectionViewCell {

    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = CGFloat(btnCornerRadius)
        contentView.clipsToBounds = true
        // Initialization code
    }

}
