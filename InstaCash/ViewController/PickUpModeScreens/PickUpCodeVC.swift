//
//  PickUpCodeVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 06/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import OTPTextField

class PickUpCodeVC: UIViewController {
    
    @IBOutlet weak var codeTitle_lbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var txtFPickUpCode: OTPTextField!
    
    var isComeFromVC : String?
    
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let strVC = isComeFromVC {
            if strVC == "pickupmode" {
                codeTitle_lbl.text = "Pickup Code"
            }else if strVC == "diagnosemode" {
                codeTitle_lbl.text = "Diagnose Code"
            }
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.cancelBtn.titleLabel?.textColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.cancelBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.submitBtn.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.submitBtn.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
    }
    
    //MARK: IBActions
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        print(txtFPickUpCode.text ?? "")
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
        print(txtFPickUpCode.text ?? "")
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            self.cancelBtn.titleLabel?.textColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
            self.cancelBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.submitBtn.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.submitBtn.backgroundColor = #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1)
        }
        
        if (txtFPickUpCode.text?.count ?? 0) < 8 {
            Alert.showAlert(strMessage: "Please Enter 8 digit Code", Onview: self)
        }else {
            
            if let strVC = isComeFromVC {
                if strVC == "diagnosemode" {
                    self.fireWebServiceForVerificationCode(strVerificationCode: txtFPickUpCode.text ?? "", withProcessCode: "diagnosemode")
                }else if strVC == "pickupmode" {
                    self.fireWebServiceForVerificationCode(strVerificationCode: txtFPickUpCode.text ?? "", withProcessCode: "pickupmode")
                }
            }
            
        }
        
    }
    
    //MARK:- APi for verification code
    func diagnosisPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForVerificationCode(strVerificationCode:String,withProcessCode:String)
    {
        if reachability?.connection.description != "No Connection" {
            var strAppCode = ""
            if withProcessCode == "diagnosemode" {
                strAppCode = "1"
            }
            else{
                strAppCode = "2"
            }
            var strUudid = ""
            
            if (KeychainWrapper.standard.string(forKey: "UUIDValue") != nil){
                strUudid = KeychainWrapper.standard.string(forKey: "UUIDValue")!
            }
            else{
                let uuID = UIDevice.current.identifierForVendor!.uuidString
                _ = KeychainWrapper.standard.set(uuID, forKey: "UUIDValue")
                strUudid = uuID
            }
            
            
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "appModeCode"
            
            print(strUrl)
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "appModeCode": strVerificationCode,
                "appMode":strAppCode,
                "customerId":CustomUserDefault.getUserId(),
                "uniqueIdentifire":strUudid + "~" + strUudid
            ]
            
            print(parameters)
            
            self.diagnosisPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        userDefaults.removeObject(forKey: "ChangeModeComingFromDiadnosis")
                        userDefaults.removeObject(forKey: "ChangeModeOrderId")
                        userDefaults.set(responseObject?["orderItemId"] as! String, forKey: "ChangeModeOrderId")
                        
                        if withProcessCode == "diagnosemode" {
                            //run flow of Diagnose Mode
                            
                            if CustomUserDefault.getProductId() == responseObject?["productId"] as? String {
                                
                                //DispatchQueue.main.async {
                                    userDefaults.set("Diagnosis", forKey: "ChangeModeComingFromDiadnosis")
                                
                                DispatchQueue.main.async {
                                    let vc =  ScreenTestingVC()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                                /*
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: false, completion: {
                                            let vc = ScreenTestingVC()
                                            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                                            navController?.pushViewController(vc, animated: true)
                                        })
                                    }*/
                                    
                                //}
                            }else {
                                Alert.showAlertWithTitle(strTitle: "InstaCash", strMessage: "Device doesn't Match! Please change your device, through which you place the order.", Onview: self)
                            }
                        }else {
                            //run flow of PickUp Mode
                            
                            if CustomUserDefault.getProductId() == responseObject?["productId"] as? String {
                                
                                //DispatchQueue.main.async {
                                    userDefaults.set("Pickup", forKey: "ChangeModeComingFromDiadnosis")
                                    
                                    //Set array for questions
                                    var arrPickUpQuestion = NSArray()
                                    arrPickUpQuestion = responseObject?["msg"] as! NSArray
                                    userDefaults.removeObject(forKey: "PickUpQuestions")
                                    let myData = NSKeyedArchiver.archivedData(withRootObject: arrPickUpQuestion)
                                    userDefaults.set(myData, forKey: "PickUpQuestions")
                                
                                DispatchQueue.main.async {
                                    let vc = ScreenTestPickUp()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                                /*
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: false, completion: {
                                            let vc = ScreenTestPickUp()
                                            let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                                            navController?.pushViewController(vc, animated: true)
                                        })
                                    }*/
                                  
                                //}
                            }else {
                                Alert.showAlertWithTitle(strTitle: "InstaCash", strMessage: "Device doesn't Match! Please change your device, through which you place the order.", Onview: self)
                            }
                        }
                    }else {
                        
                        if withProcessCode == "diagnosemode" {
                            Alert.showAlert(strMessage:"Invalid Diagnose Code" , Onview: self)
                        }else {
                            Alert.showAlert(strMessage:"Invalid Pickup Code" , Onview: self)
                        }
                        
                        //Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
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
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
}
