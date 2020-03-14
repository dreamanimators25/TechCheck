//
//  IMEIVC.swift
//  InstaCash
//
//  Created by InstaCash on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class IMEIVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var imeiEditText: UITextField!
    var myDeviceDict = NSMutableDictionary()
    var arrMyCurrentDeviceGet = [HomeModel]()

    var isComingForProcessmode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
//        Alert.showAlert(strMessage: "IMEI number is required to identifying a device,Dial *#06# from the device to get the IMEI number of the device.", Onview: self)
        // Do any additional setup after loading the view.
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = ""
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(IMEIVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- button action methods
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        if (imeiEditText.text?.isEmpty)!{
            let alertController = UIAlertController(title: "InstaCash", message: "IMEI of your device will be required to identify device at the time of order pickup, so it will be synced with our server.", preferredStyle: .alert)
            
            let sendButton = UIAlertAction(title: "Agree", style: .default, handler: { (action) -> Void in
                if self.imeiEditText.text?.count == 15{

                    if self.isIMEIValid(imeiNumber: self.imeiEditText.text!){
                        userDefaults.setValue(self.imeiEditText.text!, forKey: "imei_number")
                        if self.isComingForProcessmode == true{
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            userDefaults.setValue("No", forKey: "DisagreeIMEI")
                            let vc  = DeviceInfoVC()
                            vc.arrMyCurrentDeviceGetInfo = self.arrMyCurrentDeviceGet
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        Alert.showAlert(strMessage: "Invalid IMEI Number Entered.", Onview: self)
                    }
                }else{
                    Alert.showAlert(strMessage: "Please Enter a valid 15-digit IMEI Number", Onview: self)
                    
                }
                
            })
            
            let cancelButton = UIAlertAction(title: "Disagree", style: .cancel, handler: { (action) -> Void in
                userDefaults.removeObject(forKey: "DisagreeIMEI")
                userDefaults.setValue("Yes", forKey: "DisagreeIMEI")
                if self.isComingForProcessmode == true{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    let vc  = DeviceInfoVC()
                    vc.arrMyCurrentDeviceGetInfo = self.arrMyCurrentDeviceGet
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
            
            
            alertController.addAction(sendButton)
            alertController.addAction(cancelButton)
            
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }
        else{
        if imeiEditText.text?.count == 15{
            if isIMEIValid(imeiNumber: imeiEditText.text!){
                userDefaults.setValue(imeiEditText.text!, forKey: "imei_number")
                if isComingForProcessmode == true{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                let vc  = DeviceInfoVC()
                vc.arrMyCurrentDeviceGetInfo = arrMyCurrentDeviceGet
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                Alert.showAlert(strMessage: "Invalid IMEI Number Entered.", Onview: self)
            }
        }else{
            Alert.showAlert(strMessage: "Please Enter a valid 15-digit IMEI Number", Onview: self)

        }
        }
    }
    
    func isIMEIValid(imeiNumber: String) -> Bool {
        var sum = 0;
        for i in (0..<15){
            var number = Int(imeiNumber.substring(fromIndex: i, toIndex: i))
            if ((i+1)%2==0){
                number = number!*2;
                number = number!/10+number!%10;
            }
            sum=sum+number!
        }
        if(sum%10 == 0) {
            return true
        }else{
            return false
        }
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func substring(fromIndex: Int, toIndex:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
        let endIndex = self.index(startIndex, offsetBy: toIndex-fromIndex)
        
        return String(self[startIndex...endIndex])
    }
}
