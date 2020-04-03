//
//  CustomerSupportVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 11/01/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import MessageUI

class CustomerSupportVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var faqTextView: UITextView!
    
    var emailAddress = String()
    var phoneNumber = String()
    
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fireWebServiceForFaqDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: IBActions
    @IBAction func onClickBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEmailButton(_ sender: Any) {
        
        /*
        var emailAdd = ""
        if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            //emailAddress = "support@getinstacash.in"
            emailAdd = emailAddress
        }
        else{
            //emailAddress = "support@getinstacash.com.my"
            emailAdd = emailAddress
        }*/
        
        if !MFMailComposeViewController.canSendMail() {
            Alert.showAlert(strMessage: "Oops! Mail Service not available.", Onview: self)
        }
        else{
            
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
    
    @IBAction func onClickCallButton(_ sender: Any) {
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            Alert.showAlert(strMessage: "Your device doesn't support this feature.", Onview: self)
        }

    }
    
    @IBAction func onClickChatButton(_ sender: Any) {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            print("Zopim Chat")
        
        }else {
            
            guard let url = URL(string: "https://wa.me/601165273417") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
    }
    
    //MARK:- web service methods
    
    func FaqApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForFaqDetail()
    {
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl =  strBaseURL + "instacashInformation"
            var parameters = [String: Any]()
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
            ]
            
            print(parameters)
            
            self.FaqApiPost(strURL: strUrl, parameters: [:], completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    let actualHTML = (responseObject?.value(forKey: "faq") as? NSDictionary)?.value(forKey: "discription") as? String
                    self.faqTextView.attributedText = actualHTML?.htmlToAttributedString
                    
                    self.emailAddress = (responseObject?.value(forKey: "contact_detail") as? NSDictionary)?.value(forKey: "email") as? String ?? ""
                    self.phoneNumber = (responseObject?.value(forKey: "contact_detail") as? NSDictionary)?.value(forKey: "phone") as? String ?? ""
                    
                }
                else
                {
                    Alert.showAlert(strMessage: "Seemd Conection loss from server", Onview: self)
                }
            })
            
        }
        else {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}


