//
//  ItemPickUpVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 07/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class ItemPickUpVC: UIViewController {
    
    @IBOutlet weak var deviceBtn: UIButton!
    @IBOutlet weak var validBillBtn: UIButton!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var validBillView: UIView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var validBillImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: IBActions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deviceBtnPressed(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.deviceBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.deviceView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.deviceImageView.image = nil
            self.deviceImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else {
            sender.isSelected = !sender.isSelected
            
            self.deviceBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.deviceView.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.deviceImageView.image = #imageLiteral(resourceName: "smallRight")
        }
        
    }
    
    @IBAction func validBillBtnPressed(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
            
            self.validBillBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.validBillView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.validBillImageView.image = nil
            self.validBillImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else {
            sender.isSelected = !sender.isSelected
            
            self.validBillBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.validBillView.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.validBillImageView.image = #imageLiteral(resourceName: "smallRight")
        }
        
    }
    
    @IBAction func yesBtnPressed(_ sender: UIButton) {
        print("YES")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
