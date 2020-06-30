//
//  OrderFinalVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 29/12/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class OrderFinalVC: UIViewController {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lblNowIsnt: UILabel!
    @IBOutlet weak var btnSeeOrderStatus: UIButton!
    
    var finalPrice = 0
    var orderID = ""
    var selectPaymentType = ""
    var str3 = NSAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        //Sameer - 28/3/2020
        userDefaults.removeObject(forKey: "promoterID")
        userDefaults.removeObject(forKey: "promoter")
        userDefaults.removeObject(forKey: "promotionCouponCode")
        userDefaults.removeObject(forKey: "urlResponse")
        userDefaults.removeObject(forKey: "additionalInfo")
        
        //Sameer - 17/6/2020
        CustomUserDefault.removeEnteredUserName()
        CustomUserDefault.removeEnteredUserEmail()
        CustomUserDefault.removeEnteredPhoneNumber()
        
        //Sameer 2/6/2020
        Analytics.logEvent("order_completed", parameters: [:])
        
    }
    
    func changeLanguageOfUI() {
        
        self.lblNowIsnt.text = "Now isn't that easy? :)".localized(lang: langCode)
        self.btnSeeOrderStatus.setTitle("SEE ORDER STATUS".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.changeLanguageOfUI()
                
        lbl1.text = "Get ready to be ".localized(lang: langCode) + CustomUserDefault.getCurrency() + " \(finalPrice.formattedWithSeparator)" + " richer!".localized(lang: langCode)
        
        let str1 = NSAttributedString.init(string: "Your order has been placed successfully. Your Order ID is ".localized(lang: langCode))
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verify the order and schedule the pickup. For any queries please call 0141-4232323 (10:00am - 07:00pm.)".localized(lang: langCode))
            
            let myAttribute = [NSAttributedString.Key.foregroundColor: navColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
            let str2 = NSAttributedString.init(string: orderID, attributes: myAttribute)
            
            let combination = NSMutableAttributedString()
            combination.append(str1)
            combination.append(str2)
            combination.append(str3)
            
            lbl2.attributedText = combination
            
        }else if CustomUserDefault.getCurrency() == "NT$" {
                        
            if selectPaymentType == "UUPON (Points Only)" {
                lbl1.text = "Get ready to be ".localized(lang: langCode) + " 點數 " + " \(finalPrice.formattedWithSeparator)" + " richer!".localized(lang: langCode)
            }
            
            self.str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verify the order and schedule the pickup. For any queries please call +886-277300795 (09:00am - 06:00pm.)".localized(lang: langCode))
            
            let myAttribute = [NSAttributedString.Key.foregroundColor: navColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
            let str2 = NSAttributedString.init(string: self.orderID, attributes: myAttribute)
            
            let combination = NSMutableAttributedString()
            combination.append(str1)
            combination.append(str2)
            combination.append(self.str3)
            
            self.lbl2.attributedText = combination
            
            self.lbl1.text = ""
            self.lblNowIsnt.text = ""
            
        }else if CustomUserDefault.getCurrency() == "SG$" {
            
            str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verify the order and schedule the pickup. For any queries please call +60365273417 (08:30am - 06:00pm Mon - Fri)".localized(lang: langCode))
            
            let myAttribute = [NSAttributedString.Key.foregroundColor: navColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
            let str2 = NSAttributedString.init(string: orderID, attributes: myAttribute)
            
            let combination = NSMutableAttributedString()
            combination.append(str1)
            combination.append(str2)
            combination.append(str3)
            
            lbl2.attributedText = combination
            
        } else {
            
            //str3 = NSAttributedString.init(string: " Our team will get in touch with you shortly to verity the order and schedule the pickup. For any queries please call +60365273417 (08:30am - 06:00pm Mon - Fri)".localized(lang: langCode))
            
            let dnd = "Do not delete"
            let factoryReset = "Factory Reset"
            
            let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkText,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
            
            let str1 = NSAttributedString.init(string: "1) Your Order ID is ")
            let str2 = NSAttributedString.init(string: orderID, attributes: myAttribute)
            let str2a = NSAttributedString.init(string: ".")
            let str3a = NSAttributedString.init(string: "\n2) Our team will get in touch with you shortly to verify your order and schedule the pick-up.")
            let str4 = NSAttributedString.init(string: "\n3) ")
            let str5 = NSAttributedString.init(string: dnd, attributes: myAttribute)
            let str6 = NSAttributedString.init(string: " 'Instacash' or ")
            let str7 = NSAttributedString.init(string: factoryReset, attributes: myAttribute)
            let str8 = NSAttributedString.init(string: " your device before the collection.")
            let str9 = NSAttributedString.init(string: "\n4) The final trade-in value will be quoted to you by our logistic personnel.")
            let str10 = NSAttributedString.init(string: "\n5) You are only required to remove your passcode and accounts upon agree-ing to our final trade-in value.")
            let str11 = NSAttributedString.init(string: "\n6) ")
            let str12 = NSAttributedString.init(string: "For any queries, please call 03-7931 3417 (08:30am - 06:00pm Mon - Fri)")
            
            let combination = NSMutableAttributedString()
            combination.append(str1)
            combination.append(str2)
            combination.append(str2a)
            combination.append(str3a)
            combination.append(str4)
            combination.append(str5)
            combination.append(str6)
            combination.append(str7)
            combination.append(str8)
            combination.append(str9)
            combination.append(str10)
            combination.append(str11)
            combination.append(str12)
            
            lbl2.textAlignment = .left
            lbl2.attributedText = combination
            
        }
        
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
