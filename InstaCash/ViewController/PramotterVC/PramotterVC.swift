//
//  PramotterVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/02/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class PramotterVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtID: UITextField!
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        btnSend.layer.cornerRadius = CGFloat(btnCornerRadius)
        btnSend.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(PramotterVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }

    @IBAction func btnSendPressed(_ sender: UIButton) {
        self.txtID.resignFirstResponder()
        if (txtID.text?.isEmpty)!{
           Alert.showAlert(strMessage: "Please enter ID", Onview: self)
        }
        else{
            fireWebServiceForPromotersVerify()
            }
        

    }
    
    //MARK:- web service methods
    func ApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    
    func fireWebServiceForPromotersVerify()
    {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = "https://exchange.getinstacash.in/store/api/v1/public/getPromoterOTP"//userDefaults.value(forKey: "baseURL") as! String
            let strUrlFinal = strBaseURL + ""
            var parametersFinal = [String: Any]()
                parametersFinal  = [
                    "userName" : promoterUserName,
                    "apiKey" : promoterKey,
                    "agentUserName": txtID.text!
                ]
            
        self.ApiPost(strURL: strUrlFinal, parameters: parametersFinal as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        let vc = PromoterOTPVC()
                        vc.strGetUserName = self.txtID.text!
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    //MARK:- uitextfield delegate methpds
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if (textField.text?.utf8CString.count)! > 20
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

}
