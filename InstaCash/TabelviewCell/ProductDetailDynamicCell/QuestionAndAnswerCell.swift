//
//  QuestionAndAnswerCell.swift
//  InstaCash
//
//  Created by InstaCash on 08/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class QuestionAndAnswerCell: UITableViewCell {

    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
