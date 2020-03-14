//
//  ContactUsVC.swift
//  InstaCash
//
//  Created by InstaCash on 29/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var lblMailService: UILabel!
    @IBOutlet weak var viewMiddle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMailService.isHidden = true

        viewMiddle.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewMiddle.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
        
    }
   
    @IBAction func btnCallPressed(_ sender: UIButton) {
        lblMailService.isHidden = true

        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if let url = URL(string: "tel://\("0141-4232323")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else{
            if let url = URL(string: "tel://\("+60365273417")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func onclickback(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChatPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnMailPressed(_ sender: UIButton) {
        var emailAddress = ""
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            emailAddress = "support@getinstacash.in"
        }
        else{
            emailAddress = "support@getinstacash.com.my"
        }
        
        if !MFMailComposeViewController.canSendMail() {
            lblMailService.isHidden = false
        }
        else{
            lblMailService.isHidden = true
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([emailAddress])
            composeVC.setSubject("Message Subject")
            composeVC.setMessageBody("Message content.", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
