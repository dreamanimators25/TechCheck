//
//  OfferPromotionPopUpVC.swift
//  InstaCash
//
//  Created by Sameer Khan on 27/03/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class OfferPromotionPopUpVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var isComeFromVC : String?
    var promoterId = ""
    var additionalInfo = ""
    
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.promoTextField.delegate = self

        if isComeFromVC == "oppoMode" {
            self.promoTextField.placeholder = "IMEI of new Phone"
        }else {
            self.promoTextField.placeholder = "Agent ID"
        }
    
    }
    
    //MARK: IBActions
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        print(promoTextField.text ?? "")
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            self.cancelBtn.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.cancelBtn.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.submitBtn.titleLabel?.textColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.submitBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        print(promoTextField.text ?? "")
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            self.cancelBtn.titleLabel?.textColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.cancelBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.submitBtn.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.submitBtn.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
        }
        
        if isComeFromVC == "oppoMode" {
            if (promoTextField.text?.count ?? 0) < 15 || (promoTextField.text == "") {
                Alert.showAlert(strMessage: "Please Enter Valid IMEI", Onview: self)
            }else {
                self.fireWebServiceForPromotionInformation()
            }
        }else {
            if (promoTextField.text == "") {
                Alert.showAlert(strMessage: "Please Enter Valid Agent ID", Onview: self)
            }else {
                self.fireWebServiceForPromotionInformation()
            }
        }
        
    }
    

    //MARK:- APi for offer and promotions
    func promoterInformationPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForPromotionInformation()
    {
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "promoterInformation"
            
            //strUrl = "https://sbox.getinstacash.in/ic-web/instaCash/api/v5/public/" + "promoterInformation"
            //strUrl = "https://getinstacash.in/instaCash/api/v5/public/promoterInformation"
            print(strUrl)
            
            var jsonST = String()
            
            if isComeFromVC == "oppoMode" {
                //let param = ["tradeupIMEI" : KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!] as [String:Any]
                
                let param = ["tradeupIMEI" : promoTextField.text ?? ""] as [String:Any]
                
                //let param = ["tradeupIMEI" : "862194041595479"] as [String:Any]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
                    if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                        print(jsonString)
                        jsonST = jsonString as String
                    }
                } catch {
                    print(error)
                }
                
                userDefaults.set(jsonST, forKey: "additionalInfo")
                
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "promoterId" : promoterId,
                    "tradeInIMEI" : KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!,
                    "data" : jsonST,
                ]
            }else {
                let param = ["employeeId" : promoTextField.text ?? ""] as [String:Any]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
                                        
                    if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                        print(jsonString)
                        jsonST = jsonString as String
                    }
                } catch {
                    print(error)
                }
                
                userDefaults.set(jsonST, forKey: "additionalInfo")
                
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "promoterId" : promoterId,
                    "tradeInIMEI" : KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!,
                    "data" : jsonST,
                ]
            }
            
            print(parameters)
            
            self.promoterInformationPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let dict = responseObject?["msg"] as! [String:Any]
                        
                        DispatchQueue.main.async {
                            userDefaults.set("Offer&Promotions", forKey: "promoter")
                            
                            if dict["couponCode"] as? String != "" {
                                userDefaults.set("\(dict["couponCode"] as? String ?? "")", forKey: "promotionCouponCode")
                            }
                                                        
                            let vc = Sell1()
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    }else {
                        Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                    }
                }
                else
                {
                    Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                }
            })
        }
        else {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
    }
    
    //MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
