//
//  StartDeviceCondition.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 10/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class StartDevice: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeviceCondition(_ sender: Any) {
        let vc = StartDevice1()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
