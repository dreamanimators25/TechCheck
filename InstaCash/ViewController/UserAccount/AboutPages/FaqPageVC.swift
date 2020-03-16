//
//  FaqVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class FaqPageVC: UIViewController {
    
    @IBOutlet weak var faqTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let combination = NSMutableAttributedString()
        combination.append(faqTitleHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        combination.append(faqHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        self.faqTextView.attributedText = combination
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
