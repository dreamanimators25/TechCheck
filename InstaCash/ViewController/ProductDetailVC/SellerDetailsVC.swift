//
//  SellerDetailsVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 19/12/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SellerDetailsVC: UIViewController,UITextFieldDelegate {
    
    var getFinalPrice1 = 0
    var pickUpChargeGet1 = 0
    var finalPriceSet1 = 0
    
    var strProductName1 = ""
    var strProductImg1 = ""
    let reachability: Reachability? = Reachability()
    var quatationId1 = String() //s.
    var totalNumberCount1 = 0
    var totalNumberCount2 = 0
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDevicePrice: UILabel!
    @IBOutlet weak var imgVCDevice: UIImageView!
    
    @IBOutlet weak var txtViewName: UIView!
    @IBOutlet weak var txtViewEmail: UIView!
    @IBOutlet weak var txtViewMobile: UIView!
    
    @IBOutlet weak var lblUserDetail: UILabel!
    @IBOutlet weak var lblYourDetail: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            txtCountryCode.text = "+91"
            totalNumberCount1 = 10
            totalNumberCount2 = 10
        }else if CustomUserDefault.getCurrency() == "RM" {
            txtCountryCode.text = "+60"
            totalNumberCount1 = 8
            totalNumberCount2 = 12
        }else if CustomUserDefault.getCurrency() == "SG$" {
            txtCountryCode.text = "+65"
            totalNumberCount1 = 8
            totalNumberCount2 = 11
        }else {
            txtCountryCode.text = "+886"
            totalNumberCount1 = 8
            totalNumberCount2 = 12
        }
        
        //txtCountryCode.delegate = self
        txtMobile.delegate = self
        
        
        let imgURL = URL.init(string: self.strProductImg1)
        self.imgVCDevice.sd_setImage(with: imgURL)
        self.lblDeviceName.text = self.strProductName1
        //self.lblDevicePrice.text = "\(self.getFinalPrice1)"
        
        self.lblDevicePrice.text = "Device quoted is: ".localized(lang: langCode) + CustomUserDefault.getCurrency() + getFinalPrice1.formattedWithSeparator //s.
        
        let borderWidth = CGFloat(0.5)
        let borderColor = UIColor.darkGray.cgColor
        txtViewName.layer.borderWidth = borderWidth
        txtViewName.layer.borderColor = borderColor
        
        txtViewEmail.layer.borderWidth = borderWidth
        txtViewEmail.layer.borderColor = borderColor
        
        txtCountryCode.layer.borderWidth = borderWidth
        txtCountryCode.layer.borderColor = borderColor
        
        txtViewMobile.layer.borderWidth = borderWidth
        txtViewMobile.layer.borderColor = borderColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = CustomUserDefault.getUserName() {
            self.txtName.text = name
        }
        
        if let email = CustomUserDefault.getUserEmail() {
            self.txtEmail.text = email
        }
        
        if let number = CustomUserDefault.getPhoneNumber() {
            self.txtMobile.text = number
        }
        
        self.changeLanguageOfUI()
        
        //Sameer 2/6/2020
        var sourceValue = ""
        if let savedMode = userDefaults.getQuotationMode(key: "eventSource") {
            if savedMode == "true" {
                sourceValue = "diagnosis"
            }else {
                sourceValue = "modifiers"
            }
            print(savedMode,sourceValue)
            
        }else {
        
        }
        
        //Sameer 2/6/2020
        Analytics.logEvent("begin_checkout", parameters: ["currency" : CustomUserDefault.getCurrency(),
                                                          "price" : getFinalPrice1,
                                                          "Source" : sourceValue,
                                                          "item_id" : CustomUserDefault.getProductId()])
        
    }
    
    func changeLanguageOfUI() {
       
        self.lblUserDetail.text = "User Detail".localized(lang: langCode)
        self.lblYourDetail.text = "Your details".localized(lang: langCode)
        self.txtName.placeholder = "Enter Name".localized(lang: langCode)
        self.txtEmail.placeholder = "Enter Email Id".localized(lang: langCode)
        self.txtMobile.placeholder = "Enter Mobile Number".localized(lang: langCode)
        self.btnNext.setTitle("NEXT".localized(lang: langCode), for: UIControlState.normal)
        
    }

    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaymentModePressed() {

        if Validation() {
            
            let userInfo = ["name" : txtName.text ?? "",
                            "email" : txtEmail.text ?? "",
                            "countryCode" : txtCountryCode.text ?? "",
                            "mobile" : txtMobile.text ?? "",
            ] as [String : Any]
            
            
            //let vc = PromoCodeVC()
            let vc = PlaceOrderVC()
            vc.strProductImg2 = self.strProductImg1
            vc.strProductName2 = self.strProductName1
            vc.getFinalPrice2 = self.getFinalPrice1
            vc.pickUpChargeGet2 = self.pickUpChargeGet1
            vc.quatationId2 = quatationId1
            vc.userPersonalDetails = userInfo
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    
    func Validation()->Bool
    {
        if txtName.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter name".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtEmail.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter E-mail address".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if(!Alert.isValidEmail(testStr: txtEmail.text!))
        {
            //Alert.showAlertWithError(strMessage: "Please Enter Correct Email Address".localized(lang: langCode) as NSString, Onview: self)
            Alert.showAlertWithError(strMessage: "Invalid email-id".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtMobile.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter mobile number".localized(lang: langCode) as NSString, Onview: self)
            return false
        }else if txtMobile.text?.count ?? 0 < totalNumberCount1 || txtMobile.text?.count ?? 0 > totalNumberCount2 {
            Alert.showAlertWithError(strMessage: "Please enter valid mobile number".localized(lang: langCode) as NSString, Onview: self)
            
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // YOU SHOULD FIRST CHECK FOR THE BACKSPACE. IF BACKSPACE IS PRESSED ALLOW IT
        
        if string == "" {
            return true
        }
        
        if let characterCount = textField.text?.count {
            // CHECK FOR CHARACTER COUNT IN TEXT FIELD
            if characterCount == totalNumberCount2 {
                // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                return textField.resignFirstResponder()
            }
        }
        return true
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCountryCode {
            let maxLength = 3
            let currentString : NSString = textField.text! as NSString
            let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCountryCode {
            txtMobile.becomeFirstResponder()
        }
    }*/
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
