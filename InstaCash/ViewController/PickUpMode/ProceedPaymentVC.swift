//
//  ProceedPaymentVC.swift
//  InstaCash
//
//  Created by InstaCash on 23/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class ProceedPaymentVC: UIViewController {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    
    let reachability: Reachability? = Reachability()
    
    
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var lblAccountNum: UILabel!
    @IBOutlet weak var lblAccountAmount: UILabel!
    

    var getAmount = ""
    var getAccountNumber = ""
    var getAcountMode = ""

    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
     
        self.lblPaymentMode.text = "Payment Mode: Bank".localized(lang: langCode)
        
        self.btnSwipe.setTitle("Swipe here to process payment".localized(lang: langCode), for: UIControlState.normal)
        
        self.lblAccountNum.text = "Account Number :".localized(lang: langCode)
        self.lblAccountAmount.text = "Amount :".localized(lang: langCode)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNavigationBar() //s.
        
        self.lblPaymentMode.text = "Payment Mode: ".localized(lang: langCode) + getAcountMode.localized(lang: langCode)
        //self.lblAccountNumber.text = "Account Number: " + getAccountNumber
        //self.lblAmount.text = "Payment Amount: " + getAmount
        
        self.lblAccountNumber.text = getAccountNumber
        self.lblAmount.text = getAmount

    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(ProceedPaymentVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSwipePressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Verification Code".localized(lang: langCode), message: "This mode can only be run if an order has been placed for this device.If you don't have a code yet please call our customer care tp get a new code.".localized(lang: langCode), preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Verification Code".localized(lang: langCode)
        }
        
        let saveAction = UIAlertAction(title: "OK".localized(lang: langCode), style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if !(firstTextField.text?.isEmpty)!{
                self.fireWebServiceForVerificationCode(strGetCode: firstTextField.text!)
            }
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized(lang: langCode), style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:- APi for verification code
    func verificationPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForVerificationCode(strGetCode:String)
    {
        
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "paymentProcess"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "appModeCode": strGetCode,
                "amount":"",
                "paymentCode":"",
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            print(parameters)
            
            self.verificationPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let vc = ProcessPaymentPopUpVC()
                        vc.getVerificationCode = strGetCode
                        vc.strGetPaymentAmount = self.getAmount
                        vc.strGetTransactionId = responseObject?["transactionId"] as! String
                        vc.strGetPaymentStatus = responseObject?["paymentStatus"] as! String

                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        let strMessage = responseObject?["msg"] as! String
                        let alertController = UIAlertController(title: "InstaCash".localized(lang: langCode), message:strMessage, preferredStyle: .alert)
                        
                        let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                            
                        })
                        alertController.addAction(sendButton)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "InstaCash".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                        
                    })
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        else
        {
            let alertController = UIAlertController(title: "InstaCash".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

}
