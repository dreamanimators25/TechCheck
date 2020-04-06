//
//  PromocodePopUpVC.swift
//  InstaCash
//
//  Created by InstaCash on 21/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class PromocodePopUpVC: UIViewController {

    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lblTermsCondition: UILabel!

    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var btnDetailTerms: UIButton!
    @IBOutlet weak var lblOK: UILabel!
    
    
    var strConditionURL = ""
    var arrTermsCondition  = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for obj in 0..<arrTermsCondition.count{

            if obj == 0{
                lblTermsCondition.text = "1." + (arrTermsCondition[0] as! String)
            }
            if obj == 1{
                lbl2.text = "2." + (arrTermsCondition[1] as! String)
            }
            if obj == 2{
                lbl3.text = "3." + (arrTermsCondition[2] as! String)
            }
            if obj == 3{
                lbl4.text = "4." + (arrTermsCondition[3] as! String)
            }
            if obj == 4{
                lbl5.text = "5." + (arrTermsCondition[4] as! String)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblCoupon.text = "Coupon Terms & Conditions".localized(lang: langCode)
        self.lblOK.text = "OK".localized(lang: langCode)
        
        self.btnDetailTerms.setTitle("Detailed Terms and Conditions".localized(lang: langCode), for: UIControlState.normal)
    }

    @IBAction func btnDetailedPressed(_ sender: UIButton) {
        guard let url = URL(string: strConditionURL) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func btnOkayPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
