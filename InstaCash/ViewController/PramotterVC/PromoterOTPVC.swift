//
//  PromoterOTPVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/02/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class PromoterOTPVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnResendPromoters: UIButton!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblInvalidOTPMessage: UILabel!
    @IBOutlet weak var txtOTP: UITextField!
    var strGetUserName = ""
    var counter = 30
    var timer = Timer()
    let reachability: Reachability? = Reachability()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.btnResendPromoters.alpha = 0.2
        self.btnResendPromoters.isEnabled = false
        btnSend.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnSend.clipsToBounds = true
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(PromoterOTPVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- update timer
    @objc func updateCounter() {
        if(counter > 0) {
            counter = counter - 1
            lblCounter.text = "Resend OTP will active in " + String(counter) + " Seconds"
        }
        else{
            timer.invalidate()
            btnResendPromoters.alpha = 1.0
            btnResendPromoters.isEnabled = true
            lblCounter.isHidden = true
        }
    }
    //MARK:- uitextfield delegate methpds
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if (textField.text?.utf8CString.count)! > 6
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

    //MARK:- button action methods
    
    @IBAction func btnSendPressed(_ sender: UIButton) {
        self.txtOTP.resignFirstResponder()
        self.lblInvalidOTPMessage.isHidden = true
        if (txtOTP.text?.isEmpty)!{
            Alert.showAlert(strMessage: "Please enter otp", Onview: self)
        }
        else{
                fireWebServiceForPromotersWithOtp()
        }
    }
    @IBAction func btnResendOtpSend(_ sender: Any) {
        self.txtOTP.resignFirstResponder()
        self.lblInvalidOTPMessage.isHidden = true
            fireWebServiceForResendOTP()
    }

    //MARK:- web service methods
    func ApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    func fireWebServiceForPromotersWithOtp()
    {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = "https://exchange.getinstacash.in/store/api/v1/public/"//userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            strUrl = strBaseURL + "promoterLogin"
            let parameters:[String: Any]  = [
                "userName" : promoterUserName,
                "apiKey" : promoterKey,
                "agentUserName": strGetUserName,
                "otp":txtOTP.text!
                ]
            
            self.ApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    print("\(String(describing: responseObject) ) , \(String(describing: error))")
                    if responseObject?["status"] as! String == "Success"{
                        self.txtOTP.resignFirstResponder()
                        if userDefaults.value(forKey: "DeviceNameForPromoters") == nil{
                         Alert.showAlertWithError(strMessage: "Device not mapped", Onview: self)
                        }
                        else{
                            let deviceName = userDefaults.value(forKey: "DeviceNameForPromoters") as! String
                            let deviceImg = userDefaults.value(forKey: "ImageNameForPromoters") as! String
                            userDefaults.set(deviceImg, forKey: "otherProductDeviceImage")
                            userDefaults.set(deviceName, forKey: "productName")
                            let promoterId =  responseObject?["promoterId"] as! String
                            let promoterName =  responseObject?.value(forKeyPath: "promoterExtra.promoterName") as! String

                            userDefaults.removeObject(forKey: "promoter_id")
                            userDefaults.removeObject(forKey: "promoter_Name")
                            userDefaults.setValue(promoterName, forKey: "promoter_Name")
                            userDefaults.setValue(promoterId, forKey: "promoter_id")
                            let vc = ScreenTestingVC()
                            vc.modalPresentationStyle = .fullScreen
                            self.navigationController?.present(vc, animated: true, completion: nil)
                        }
                    
                        
                    }
                    else{
                        Alert.showAlert(strMessage: responseObject!["msg"] as! NSString, Onview: self)
                    }
                    
                }
                else
                {
                    
                }
            })
            
        }
        else
        {
            Alert.showAlertWithError(strMessage: "No connection found", Onview: self)

        }
        
    }
    
    func fireWebServiceForResendOTP()
    {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = "https://exchange.getinstacash.in/store/api/v1/public/"//userDefaults.value(forKey: "baseURL") as! String
            let strUrlFinal = strBaseURL + "getPromoterOTP"
            var parametersFinal = [String: Any]()
            parametersFinal  = [
                "userName" : promoterUserName,
                "apiKey" : promoterKey,
                "agentUserName": self.strGetUserName
            ]
            
            self.ApiPost(strURL: strUrlFinal, parameters: parametersFinal as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        Alert.showAlert(strMessage: "OTP send", Onview: self)
                    }
                    else{
                        Alert.showAlert(strMessage: responseObject?["msg"] as! NSString, Onview: self)
                    }
                    
                }
                else
                {
                    
                }
            })
        }
        else{
            
        }
        
        
    }


}
