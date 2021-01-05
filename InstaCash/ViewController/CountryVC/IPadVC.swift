//
//  IPadVC.swift
//  TechCheck
//
//  Created by sameer khan on 17/09/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class IPadVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setStatusBarColor()
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
