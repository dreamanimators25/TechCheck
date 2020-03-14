//
//  PickUpItemsVC.swift
//  InstaCash
//
//  Created by InstaCash on 23/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class PickUpItemsVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnEarPhones: UIButton!
    @IBOutlet weak var btnOriginalCharger: UIButton!
    @IBOutlet weak var btnBox: UIButton!
    @IBOutlet weak var viewBox: UIView!
    
    @IBOutlet weak var btnValidBill: UIButton!
    @IBOutlet weak var txtYes: UITextField!
    @IBOutlet weak var viewEarPhones: UIView!
    @IBOutlet weak var viewOriginalCharger: UIView!
    @IBOutlet weak var viewValidBill: UIView!
    @IBOutlet weak var viewTop: UIView!
    var isDeviceSelected = false
    let reachability: Reachability? = Reachability()
    var strGetAccountNumber = ""
    var strGetPaymentAmount = ""
    var strGetPaymentMode = ""
    var isAllreadyFire = false



    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        showViewDynamically()
        viewBox.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewBox.clipsToBounds = true
        viewBox.layer.borderWidth = 1.0
        viewBox.layer.borderColor = UIColor.black.cgColor
        
        viewEarPhones.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewEarPhones.clipsToBounds = true
        viewEarPhones.layer.borderWidth = 1.0
        viewEarPhones.layer.borderColor = UIColor.black.cgColor
        
        viewOriginalCharger.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewOriginalCharger.clipsToBounds = true
        viewOriginalCharger.layer.borderWidth = 1.0
        viewOriginalCharger.layer.borderColor = UIColor.black.cgColor
        
        viewValidBill.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewValidBill.clipsToBounds = true
        viewValidBill.layer.borderWidth = 1.0
        viewValidBill.layer.borderColor = UIColor.black.cgColor
        
        viewTop.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewTop.clipsToBounds = true
        viewTop.layer.borderWidth = 1.0
        viewTop.layer.borderColor = UIColor.black.cgColor
        txtYes.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        // Do any additional setup after loading the view.
    }
    
    func showViewDynamically(){
        if userDefaults.value(forKey: "isShowValidBill") as! Bool == true{
            viewValidBill.backgroundColor = UIColor.white
            btnValidBill.isUserInteractionEnabled = true
            viewValidBill.alpha = 1.0
        }
        else{
            viewValidBill.backgroundColor = UIColor.lightGray
            viewValidBill.alpha = 0.4
            btnValidBill.isUserInteractionEnabled = false
        }
        if userDefaults.value(forKey: "isShowEarPhone") as! Bool == true{
            viewEarPhones.backgroundColor = UIColor.white
            btnEarPhones.isUserInteractionEnabled = true
            viewEarPhones.alpha = 1.0
        }
        else{
            viewEarPhones.backgroundColor = UIColor.lightGray
            viewEarPhones.alpha = 0.4
            btnEarPhones.isUserInteractionEnabled = false
        }
        
        if userDefaults.value(forKey: "isShowCharger") as! Bool == true{
            viewOriginalCharger.backgroundColor = UIColor.white
            btnOriginalCharger.isUserInteractionEnabled = true
            viewOriginalCharger.alpha = 1.0
        }
        else{
            viewOriginalCharger.backgroundColor = UIColor.lightGray
            viewOriginalCharger.alpha = 0.4
            btnOriginalCharger.isUserInteractionEnabled = false
        }
        
        if userDefaults.value(forKey: "isShowBox") as! Bool == true{
            viewBox.backgroundColor = UIColor.white
            btnBox.isUserInteractionEnabled = true
            viewBox.alpha = 1.0
        }
        else{
            viewBox.backgroundColor = UIColor.lightGray
            viewBox.alpha = 0.4
            btnBox.isUserInteractionEnabled = false
        }
        
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
        btnMenu.addTarget(self, action: #selector(PickUpItemsVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Button action Methods
    
    @IBAction func btnDevicePressed(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            isDeviceSelected = false
            viewTop.backgroundColor = UIColor.white

        }
        else{
            sender.isSelected = true
            isDeviceSelected = true
            viewTop.backgroundColor = navColor

        }
        //validateandCallAPI()

    }
    
    @IBAction func btnValidBillPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            viewValidBill.backgroundColor = UIColor.white
            
        }
        else{
            sender.isSelected = true
            viewValidBill.backgroundColor = navColor
            
        }
        //validateandCallAPI()

    }
    
    @IBAction func btnBoxPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            viewBox.backgroundColor = UIColor.white
            
        }
        else{
            sender.isSelected = true
            viewBox.backgroundColor = navColor
            
        }
        //validateandCallAPI()

    }
    
    @IBAction func btnOriginolChargerPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            viewOriginalCharger.backgroundColor = UIColor.white
            
        }
        else{
            sender.isSelected = true
            viewOriginalCharger.backgroundColor = navColor
            
        }
       // validateandCallAPI()

    }
    @IBAction func btnEarPhonePressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            viewEarPhones.backgroundColor = UIColor.white
            
        }
        else{
            sender.isSelected = true
            viewEarPhones.backgroundColor = navColor
            
        }
   // validateandCallAPI()
    }
    
    func validateandCallAPI(){
        if txtYes.text?.count == 3{
            if txtYes.text == "YES"{
                if isDeviceSelected == true{
                    txtYes.resignFirstResponder()
                    self.fireWebServiceForOrderPlaced()
                    
                }
                else{
                    Alert.showAlert(strMessage: "Select Device", Onview: self)
                }
                
            }
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        if textField.text?.count == 3{
            if textField.text == "YES"{
                if isDeviceSelected == true{
                    isAllreadyFire = true
                    txtYes.resignFirstResponder()
                    self.fireWebServiceForOrderPlaced()
                }
                else{
                    Alert.showAlert(strMessage: "Select Device", Onview: self)
                }
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 3{
            if textField.text == "YES"{
                if isDeviceSelected == true{
                    txtYes.resignFirstResponder()
                    if isAllreadyFire == false{
                        self.fireWebServiceForOrderPlaced()
                    }
                    
                }
                else{
                    Alert.showAlert(strMessage: "Select Device", Onview: self)
                }
                
            }
        }

    }
    
    
    
    //MARK:- APi for verification code
    func pickItemPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForOrderPlaced()
    {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "pickupComplete"
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
            ]
            
            self.pickItemPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success"{
                        
                        let alertController = UIAlertController(title: "Order Complete!", message:"Pickup is complete now.Continue to Process the payment", preferredStyle: .alert)
                        
                        let sendButton = UIAlertAction(title: "Pocess Payment", style: .default, handler: { (action) -> Void in
                            
                            let vc = ProceedPaymentVC()
                            vc.getAmount = self.strGetPaymentAmount
                            vc.getAccountNumber = self.strGetAccountNumber
                            vc.getAcountMode = self.strGetPaymentMode

                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        })
                        alertController.addAction(sendButton)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else{
                        self.isAllreadyFire = false

                        //Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                        
                    }
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "InstaCash", message:"Seems connection loss from server", preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                        
                    })
                    alertController.addAction(sendButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        else
        {
            let alertController = UIAlertController(title: "InstaCash", message:"No connection found", preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                
            })
            alertController.addAction(sendButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
}
