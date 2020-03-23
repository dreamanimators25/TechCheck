//
//  PickUpItemsVC.swift
//  InstaCash
//
//  Created by InstaCash on 23/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class PickUpItemsVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var viewDevice: UIView!
    @IBOutlet weak var btnDevice: UIButton!
    
    @IBOutlet weak var viewValidBill: UIView!
    @IBOutlet weak var btnValidBill: UIButton!
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var btnBox: UIButton!
    
    @IBOutlet weak var viewEarPhones: UIView!
    @IBOutlet weak var btnEarPhones: UIButton!
    
    @IBOutlet weak var viewOriginalCharger: UIView!
    @IBOutlet weak var btnOriginalCharger: UIButton!
    
    @IBOutlet weak var itemHeightConstraint: NSLayoutConstraint! //s.
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewTopLbl: UILabel!
    
    
    //@IBOutlet weak var yesBtn: UIButton!
    //@IBOutlet weak var txtYes: UITextField! //s.
    //@IBOutlet weak var btnOriginalCharger: UIButton! //s.
    //@IBOutlet weak var viewEarPhones: UIView! //s.
    //@IBOutlet weak var viewOriginalCharger: UIView! //s.
    
    
    let reachability: Reachability? = Reachability()
    var strGetAccountNumber = ""
    var strGetPaymentAmount = ""
    var strGetPaymentMode = ""
    var isAllreadyFire = false

    var totalButton = 1
    var totalSelectedButton = 0
    var isDeviceSelected = true
    var isValidBillSelected = true
    var isBoxSelected = true
    var isEarphoneSelected = true
    var isChargerSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickYes(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.viewTopLbl.addGestureRecognizer(tapGesture)
        
        //self.txtYes.delegate = self //s.
        
        //let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector)  //Tap function will call when user tap on button
        //tapGesture.numberOfTapsRequired = 1
        //viewTopLbl.addGestureRecognizer(tapGesture)
        
        viewTop.alpha = 0
        viewTop.isUserInteractionEnabled = true
        self.itemHeightConstraint.constant = 65
        
        //setNavigationBar() //s.
        
        showViewDynamically()
        
        viewDevice.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewDevice.clipsToBounds = true
        viewDevice.layer.borderWidth = 1.0
        viewDevice.layer.borderColor = UIColor.black.cgColor
        
        
        viewValidBill.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewValidBill.clipsToBounds = true
        viewValidBill.layer.borderWidth = 1.0
        viewValidBill.layer.borderColor = UIColor.black.cgColor
        
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
        
        
        //viewTop.layer.cornerRadius = CGFloat(btnCornerRadius)
        //viewTop.clipsToBounds = true
        //viewTop.layer.borderWidth = 1.0
        //viewTop.layer.borderColor = UIColor.black.cgColor
        
        //txtYes.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged) //s.

    }
    
    func showViewDynamically(){
        
        isDeviceSelected = false
        viewDevice.isHidden = false
        
        if userDefaults.value(forKey: "isShowValidBill") as! Bool == true{
            //viewValidBill.backgroundColor = UIColor.white
            btnValidBill.isUserInteractionEnabled = true
            viewValidBill.alpha = 1.0
            
            viewValidBill.isHidden = false
            isValidBillSelected = false
            totalButton += 1
        }
        else{
            //viewValidBill.backgroundColor = UIColor.lightGray
            btnValidBill.isUserInteractionEnabled = false
            viewValidBill.alpha = 0.4
            
            viewValidBill.isHidden = true
            isValidBillSelected = true
        }
        
        if userDefaults.value(forKey: "isShowBox") as! Bool == true{
            //viewBox.backgroundColor = UIColor.white
            btnBox.isUserInteractionEnabled = true
            viewBox.alpha = 1.0
            
            viewBox.isHidden = false
            isBoxSelected = false
            totalButton += 1
        }
        else{
            //viewBox.backgroundColor = UIColor.lightGray
            btnBox.isUserInteractionEnabled = false
            viewBox.alpha = 0.4
            
            viewBox.isHidden = true
            isBoxSelected = true
        }
        
        if userDefaults.value(forKey: "isShowEarPhone") as! Bool == true{
            //viewEarPhones.backgroundColor = UIColor.white
            btnEarPhones.isUserInteractionEnabled = true
            viewEarPhones.alpha = 1.0
            
            viewEarPhones.isHidden = false
            isEarphoneSelected = false
            totalButton += 1
        }
        else{
            //viewEarPhones.backgroundColor = UIColor.lightGray
            btnEarPhones.isUserInteractionEnabled = false
            viewEarPhones.alpha = 0.4
            
            viewEarPhones.isHidden = true
            isEarphoneSelected = true
        }
        
        if userDefaults.value(forKey: "isShowCharger") as! Bool == true{
            //viewOriginalCharger.backgroundColor = UIColor.white
            btnOriginalCharger.isUserInteractionEnabled = true
            viewOriginalCharger.alpha = 1.0
            
            viewOriginalCharger.isHidden = false
            isChargerSelected = false
            totalButton += 1
        }
        else{
            //viewOriginalCharger.backgroundColor = UIColor.lightGray
            btnOriginalCharger.isUserInteractionEnabled = false
            viewOriginalCharger.alpha = 0.4
            
            viewOriginalCharger.isHidden = true
            isChargerSelected = true
        }
        
        
        switch totalButton {
        case 1:
            self.itemHeightConstraint.constant = 50
        case 2:
            self.itemHeightConstraint.constant = 100
        case 3:
            self.itemHeightConstraint.constant = 155
        case 4:
            self.itemHeightConstraint.constant = 210
        default:
            self.itemHeightConstraint.constant = 265
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
            //viewDevice.backgroundColor = UIColor.white
            
            totalSelectedButton -= 1
            viewTop.alpha = 0
            viewTop.isUserInteractionEnabled = false
            //viewTop.backgroundColor = UIColor.white
        }
        else{
            sender.isSelected = true
            isDeviceSelected = true
            //viewDevice.backgroundColor = navColor
            
            totalSelectedButton += 1
            
            if totalSelectedButton == totalButton {
                viewTop.alpha = 1
                viewTop.isUserInteractionEnabled = true
            }
            
            //viewTop.backgroundColor = navColor
        }
        //validateandCallAPI()
    }
    
    @IBAction func btnValidBillPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            //viewValidBill.backgroundColor = UIColor.white
            
            totalSelectedButton -= 1
            viewTop.alpha = 0
            viewTop.isUserInteractionEnabled = false
        }
        else{
            sender.isSelected = true
            //viewValidBill.backgroundColor = navColor
            
            totalSelectedButton += 1
            
            if totalSelectedButton == totalButton {
                viewTop.alpha = 1
                viewTop.isUserInteractionEnabled = true
            }
            
        }
        //validateandCallAPI()
    }
    
    @IBAction func btnBoxPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            //viewBox.backgroundColor = UIColor.white
            
            totalSelectedButton -= 1
            viewTop.alpha = 0
            viewTop.isUserInteractionEnabled = false
        }
        else{
            sender.isSelected = true
            //viewBox.backgroundColor = navColor
            
            totalSelectedButton += 1
            
            if totalSelectedButton == totalButton {
                viewTop.alpha = 1
                viewTop.isUserInteractionEnabled = true
            }
            
        }
        //validateandCallAPI()
    }
    
    @IBAction func btnEarPhonePressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            //viewEarPhones.backgroundColor = UIColor.white
            
            totalSelectedButton -= 1
            viewTop.alpha = 0
            viewTop.isUserInteractionEnabled = false
        }
        else{
            sender.isSelected = true
            //viewEarPhones.backgroundColor = navColor
            
            totalSelectedButton += 1
            
            if totalSelectedButton == totalButton {
                viewTop.alpha = 1
                viewTop.isUserInteractionEnabled = true
            }
            
        }
        // validateandCallAPI()
    }
    
    @IBAction func btnOriginolChargerPressed(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            //viewOriginalCharger.backgroundColor = UIColor.white
            
            totalSelectedButton -= 1
            viewTop.alpha = 0
            viewTop.isUserInteractionEnabled = false
        }
        else{
            sender.isSelected = true
            //viewOriginalCharger.backgroundColor = navColor
            
            totalSelectedButton += 1
            
            if totalSelectedButton == totalButton {
                viewTop.alpha = 1
                viewTop.isUserInteractionEnabled = true
            }
            
        }
       // validateandCallAPI()
    }
    
    @IBAction func btnYesClicked(_ sender: UIButton) {
        self.fireWebServiceForOrderPlaced()
    }
    
    @objc func clickYes(sender:UITapGestureRecognizer){
        // ...
        self.fireWebServiceForOrderPlaced()
    }
    
    /*
    func validateandCallAPI() {
        if txtYes.text?.count == 3 {
            if txtYes.text == "YES" {
                if isDeviceSelected == true {
                    txtYes.resignFirstResponder()
                    self.fireWebServiceForOrderPlaced()
                }
                else {
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
    */
    
    
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
            
            print(parameters)
            
            self.pickItemPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                
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

                        Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                        
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
