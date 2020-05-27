//
//  ProcessPaymentPopUpVC.swift
//  InstaCash
//
//  Created by InstaCash on 23/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class ProcessPaymentPopUpVC: UIViewController {
    
    @IBOutlet weak var activityRefresh: UIActivityIndicatorView!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var viewMiddle: UIView!
    @IBOutlet weak var lblTransactionId: UILabel!
    let reachability: Reachability? = Reachability()
    
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTrnId: UILabel!
    @IBOutlet weak var lblTrnAmount: UILabel!
    @IBOutlet weak var btnCompleteOrder: UIButton!
    @IBOutlet weak var btnRefreshStatus: UIButton!
   
    var getVerificationCode = ""
    var strGetTransactionId = ""
    var strGetPaymentStatus = ""
    var strGetPaymentAmount = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblStatus.text = "Payment processed!".localized(lang: langCode)
        self.lblTrnId.text = "Transaction id".localized(lang: langCode)
        self.lblTrnAmount.text = "Transaction amount".localized(lang: langCode)
        
        self.btnCompleteOrder.setTitle("Complete Order".localized(lang: langCode), for: UIControlState.normal)
        self.btnRefreshStatus.setTitle("Refresh Status".localized(lang: langCode), for: UIControlState.normal)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewMiddle.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewMiddle.clipsToBounds = true
        self.lblStatus.text = strGetPaymentStatus
        self.lblTransactionId.text = strGetTransactionId
        self.lblAmount.text = strGetPaymentAmount
    }

    @IBAction func btnRefreshStatusPressed(_ sender: UIButton) {
        fireWebService()
    }
    
    @IBAction func btnCompletePressed(_ sender: UIButton) {
        let vc = RatingVC()
        vc.getTrsactID = self.strGetTransactionId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- APi for verification code
    func verificationPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebService()
    {
        if reachability?.connection.description != "No Connection"{
            activityRefresh.startAnimating()
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "paymentProcess"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "appModeCode": getVerificationCode,
                "amount":"",
                "paymentCode":"",
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            print(parameters)
            
            self.verificationPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                self.activityRefresh.stopAnimating()
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        if responseObject?["paymentStatus"] as! String == "Payment Successful" {
                            let vc = RatingVC()
                            vc.getTrsactID = self.strGetTransactionId
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                       // self.lblStatus.text = responseObject?["paymentStatus"] as! String
                    }
                    else{
                        let alertController = UIAlertController(title: "InstaCash".localized(lang: langCode), message:(responseObject?["msg"] as! String), preferredStyle: .alert)
                        
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
