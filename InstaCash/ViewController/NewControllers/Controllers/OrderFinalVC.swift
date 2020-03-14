//
//  OrderFinalVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 29/12/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class OrderFinalVC: UIViewController {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    var finalPrice = 0
    var orderID = ""
    var str3 = NSAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        lbl1.text = "Get ready to be " + CustomUserDefault.getCurrency() + " \(finalPrice.formattedWithSeparator)" + " richer!"
        
        let str1 = NSAttributedString.init(string: "Your order has been placed successfully. Your Order ID is ")
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verity the order and schedule the pickup. For any queries please call 0141-4232323 (10:00am - 07:00pm.)")
        }else {
            str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verity the order and schedule the pickup. For any queries please call +60365273417 (08:30am - 06:00pm Mon - Fri)")
        }
        
        
        //if let url = URL(string: "tel://\("0141-4232323")"),
        //if let url = URL(string: "tel://\("+60365273417")"),
        //emailAddress = "support@getinstacash.in"
        //emailAddress = "support@getinstacash.com.my"
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: navColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
        let str2 = NSAttributedString.init(string: orderID, attributes: myAttribute)
        
        let combination = NSMutableAttributedString()
        combination.append(str1)
        combination.append(str2)
        combination.append(str3)
        
        lbl2.attributedText = combination
    }
    
    @IBAction func closeBtnTapped(_ sender:UIButton) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func orderListBtnTapped(_ sender:UIButton) {
        let vc = MyOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
