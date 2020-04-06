//
//  SendAppLinkPopUp.swift
//  InstaCash
//
//  Created by InstaCash on 24/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class SendAppLinkPopUp: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblLineCountryCode: UILabel!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var activitySendLink: UIActivityIndicatorView!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnSendLink: UIButton!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewPopUp: UIView!
    
    var isAndroidPhone = false
    let reachability: Reachability? = Reachability()
    var getProductName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        viewPopUp.layer.cornerRadius = 10.0
        viewPopUp.clipsToBounds = true
        btnSendLink.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnSendLink.clipsToBounds = true
        if (getProductName.contains("iPhone")){
            btnSendLink.setImage(UIImage(named: "sendAppLink"), for: .normal)
        }
        else{
            btnSendLink.setImage(UIImage(named: "googlePlay"), for: .normal)
        }
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            txtEmailAddress.isHidden = true
            txtMobileNumber.isHidden = false
            txtCountryCode.isHidden = false
            lblLineCountryCode.isHidden = false

        }
        else{
            txtEmailAddress.isHidden = false
            txtMobileNumber.isHidden = true
            txtCountryCode.isHidden = true
            lblLineCountryCode.isHidden = true

        }
        
        if userDefaults.value(forKey: "countryCode") == nil {
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                txtCountryCode.text = "+91"
            }
            //else if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
            else if CustomUserDefault.getCurrency() == "MY" {
                txtCountryCode.text = "+60"
            }
            else{
                txtCountryCode.text = "+65"
            }
        }
        else{
            txtCountryCode.text = (userDefaults.value(forKey: "countryCode") as! String)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func showAlertMessage(strMessage:String){
        let alertController = UIAlertController(title: "InstaCash", message: strMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func btnSendAppLink(_ sender: UIButton) {
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            
            if (txtMobileNumber.text?.count)! < 10 {
                showAlertMessage(strMessage: "Enter valid mobile number")
            }
            else{
                if reachability?.connection.description != "No Connection" {
                    sendLinkAppService()
                }
                else{
                    showAlertMessage(strMessage: "No connection found")
                }
            }
        }
        else{
            
             if txtEmailAddress.text!.isEmpty
            {
                showAlertMessage(strMessage: "Please enter E-mail address")
            }
            else if(!Alert.isValidEmail(testStr: txtEmailAddress.text!))
            {
                showAlertMessage(strMessage: "Please Enter Correct Email Address")

            }
             else{
                if reachability?.connection.description != "No Connection"{
                    sendLinkAppService()
                }
                else{
                    showAlertMessage(strMessage: "No connection found")
                }

            }

        }
    }
    @IBAction func btnSharePressed(_ sender: UIButton) {
        var strUrl = ""
        if isAndroidPhone{
            strUrl = "https://play.google.com/store/apps/details?id=in.co.zerowaste.instacash&hl=en_IN"
        }
        else{
             strUrl = "https://itunes.apple.com/in/app/instacash-sell-used-phone/id1310320724?mt=8"

        }
        let vc = UIActivityViewController(activityItems: [strUrl], applicationActivities: [])
        present(vc, animated: true)
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
//        
//    }
    @IBAction func btnClosedTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if textField == txtMobileNumber{
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
            if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
                
                if (textField.text?.utf8CString.count)! > 10
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
            else{
                if (textField.text?.utf8CString.count)! > 11
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
            
        }
        else{
            return true
        }
    }
    
    //MARK:- webservice data
    func sendLinkApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func sendLinkAppService(){
        activitySendLink.startAnimating()
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "sendAppLink"
        var senderId = ""
        var strType = ""

        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            senderId = txtMobileNumber.text!
            strType = "sms"
        }
        else{
            senderId = txtEmailAddress.text!
            strType = "email"
        }
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "senderId" : senderId,
            "type" : strType
            
        ]
        self.sendLinkApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            self.activitySendLink.stopAnimating()
            if error == nil {
                if responseObject?["status"] as! String == "success"{
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    // failed
                    self.showAlertMessage(strMessage: "oops,something went wrong")

                }
                
            }
            else{
                self.showAlertMessage(strMessage: "Seems connection loss from server")
            }
            
        })
    }
    
}
