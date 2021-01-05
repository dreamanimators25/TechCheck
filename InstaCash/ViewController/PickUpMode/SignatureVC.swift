//
//  SignatureVC.swift
//  TechCheck
//
//  Created by TechCheck on 22/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class SignatureVC: UIViewController,YPSignatureDelegate {

    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var signatureBaseView: UIView!
    
    @IBOutlet weak var lblCustomerSignature: UILabel!
    @IBOutlet weak var lblPleaseAsk: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    
    let reachability: Reachability? = Reachability()
    var strGetUploadBill = ""
    
    override func viewWillAppear(_ animated: Bool) {
        //self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        //self.lblCustomerSignature.text = "Customer Signature".localized(lang: langCode)
        self.lblCustomerSignature.text = "Please add Signature".localized(lang: langCode)
        self.lblPleaseAsk.text = "Please ask the customer to sign on the screen and press save".localized(lang: langCode)
        
        self.btnClear.setTitle("Clear".localized(lang: langCode), for: UIControlState.normal)
        //self.btnUpload.setTitle("Upload".localized(lang: langCode), for: UIControlState.normal)
        self.btnUpload.setTitle("Save".localized(lang: langCode), for: UIControlState.normal)
    }

    
    override func viewDidLoad() {
        
        self.setStatusBarColor()
        
        DispatchQueue.main.async {
            self.signatureBaseView.layer.borderWidth = 1.0
            self.signatureBaseView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        
        super.viewDidLoad()
        
        //setNavigationBar()
        signatureView.delegate = self
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "Signature".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(SignatureVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    @IBAction func btnSave(_ sender: UIButton) {
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
           // UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            let imageData:NSData = UIImageJPEGRepresentation(signatureImage, 0.3)! as NSData
            let strBase64Signature = imageData.base64EncodedString(options: .lineLength64Characters)
            DispatchQueue.main.async {
                self.fireWebServiceForMetchingDataForPickUp(signatureData: strBase64Signature)
            }
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
        }
        else{
            Alert.showAlert(strMessage: "Signature on white screen then click on save.".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    @IBAction func btnClear(_ sender: UIButton) {
        self.signatureView.clear()
    }
    
    // MARK: - Delegate Methods
    func didStart(_ view : YPDrawSignatureView) {
        
    }
    
    // didFinish() is called rigth after the last touch of a gesture is registered in the view.
    // Can be used to enabe scrolling in a scroll view if it has previous been disabled.
    func didFinish(_ view : YPDrawSignatureView) {
        
    }
    
    //MARK:- APi for verification code
    func signaturePost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForOrderPlacedMalasiya(getAmount:String,getAccountNumber:String,getStatusMode:String)
    {
        if reachability?.connection.description != "No Connection"{
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "pickupComplete"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            print(parameters)
            
            self.signaturePost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success"{
                        
                        let alertController = UIAlertController(title: "Order Complete!".localized(lang: langCode), message:"Pickup is complete now.Continue to Process the payment".localized(lang: langCode), preferredStyle: .alert)
                        
                        let sendButton = UIAlertAction(title: "Pocess Payment".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                            
                            let vc = ProceedPaymentVC()
                            vc.getAmount = getAmount
                            vc.getAccountNumber = getAccountNumber
                            vc.getAcountMode = getStatusMode
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        })
                        alertController.addAction(sendButton)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else{
                        Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                        
                    })
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        else
        {
            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    
    func fireWebServiceForMetchingDataForPickUp(signatureData:String)
    {
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "pickupDeclaration"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "idProofImage": "(" + self.strGetUploadBill + "," + signatureData,
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            print(parameters)
            
            self.signaturePost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
               
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                    
                if CustomUserDefault.getCurrency() == "£" {
                    
                    Alert.HideProgressHud(Onview: self.view)
                }
                else{
                    
                }
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success"{
                        DispatchQueue.main.async {
                            
                            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                                
                            if CustomUserDefault.getCurrency() == "£" {
                                
                                let vc = PickUpItemsVC()
                                vc.strGetAccountNumber = responseObject?["accountNumber"] as! String
                                let amount = responseObject?["paymentAmount"] as! Int64
                                vc.strGetPaymentAmount = String(format: "%d", amount)
                                vc.strGetPaymentMode = responseObject?["paymentMode"] as! String
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else {
                                let amount = responseObject?["paymentAmount"] as! Int64
                                self.fireWebServiceForOrderPlacedMalasiya(getAmount: String(format: "%d", amount), getAccountNumber: responseObject?["accountNumber"] as! String, getStatusMode: responseObject?["paymentMode"] as! String)
                            }
                        }
                       
                    }
                    else{
                        Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"Seems connection loss from server".localized(lang: langCode), preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                        
                    })
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        else
        {
            let alertController = UIAlertController(title: "TechCheck".localized(lang: langCode), message:"No connection found".localized(lang: langCode), preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok".localized(lang: langCode), style: .default, handler: { (action) -> Void in
                
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
}
