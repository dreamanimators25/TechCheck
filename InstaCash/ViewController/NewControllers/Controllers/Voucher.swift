//
//  Voucher.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 04/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Voucher: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickOrderNow(_ sender: Any) {
        
    }
    
}
