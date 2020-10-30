//
//  HowItWorkVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class HowItWorkPageVC: UIViewController {
    
    @IBOutlet weak var howWorkTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let combination = NSMutableAttributedString()
        combination.append(howitWorkTitleHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        combination.append(howitWorkHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        self.howWorkTextView.attributedText = combination
       
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
