//
//  HistoryDetailVC.swift
//  InstaCash
//
//  Created by sameer khan on 18/11/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class HistoryDetailVC: UIViewController {

    @IBOutlet weak var txtViewHistoryData: UITextView!
    
    var historyData : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = Data(historyData!.utf8)
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.txtViewHistoryData.attributedText = attributedString
        }

        self.setStatusBarColor()
    }
    
    //MARK: IBActions
    @IBAction func onClickBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
