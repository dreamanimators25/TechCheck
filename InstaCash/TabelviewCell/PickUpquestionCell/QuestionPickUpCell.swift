//
//  QuestionPickUpCell.swift
//  TechCheck
//
//  Created by TechCheck on 01/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class QuestionPickUpCell: UITableViewCell {

    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var collectionViewQuestionValues: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.viewData.layer.cornerRadius = 5.0
        //self.viewData.clipsToBounds = true
        self.collectionViewQuestionValues.register(UINib.init(nibName: "PickUpQuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pickUpQuestionCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
