//
//  TestFailedAndSkipCell.swift
//  InstaCash
//
//  Created by InstaCash on 13/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class TestFailedAndSkipCell: UICollectionViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgTestPassOrFailed: UIImageView!
    
    @IBOutlet weak var lblTestPassOrFailed: UILabel!
    @IBOutlet weak var lblTestName: UILabel!
    @IBOutlet weak var imgTest: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBG.layer.cornerRadius = viewBG.frame.width/2
        viewBG.clipsToBounds = true
    }

}
