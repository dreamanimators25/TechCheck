//
//  AboutPageVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

var aboutText : ((_ title : String,_ html : String) -> (Void))?

class AboutPageVC: UIViewController {

    @IBOutlet weak var aboutImageTextView: UITextView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let combination = NSMutableAttributedString()
        combination.append(aboutTitleHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        combination.append(aboutHTML?.htmlToAttributedString ?? NSMutableAttributedString())
        self.aboutTextView.attributedText = combination
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        aboutText = { (title,html) in
            
            let combination = NSMutableAttributedString()
            //combination.append(title.htmlToAttributedString ?? NSMutableAttributedString())
            combination.append(html.htmlToAttributedString ?? NSMutableAttributedString())
            self.aboutTextView.attributedText = combination
            
            
            let combination1 = NSMutableAttributedString()
            combination1.append(title.htmlToAttributedString ?? NSMutableAttributedString())
            self.aboutImageTextView.attributedText = combination1
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
