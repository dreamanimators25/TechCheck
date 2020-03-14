//
//  ChangeAppModeVC.swift
//  InstaCash
//
//  Created by InstaCash on 17/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

protocol PushToHomeForDiagnosisModeDelegate {
    func PushToHome(isDiagnosisMode:String)
}

class ChangeAppModeVC: UIViewController {
    
    var delegate:PushToHomeForDiagnosisModeDelegate?
    @IBOutlet weak var viewMiddle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMiddle.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewMiddle.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPickUp(_ sender: UIButton) {
        self.delegate?.PushToHome(isDiagnosisMode: "No")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnDiagnosisPressed(_ sender: UIButton) {
        self.delegate?.PushToHome(isDiagnosisMode: "Yes")
        dismiss(animated: true, completion: nil)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
