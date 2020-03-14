//
//  Alert.swift
//
//  InstaCash
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//


// class to show alets , progress bar , set email regex and paddword regex

import UIKit
import MBProgressHUD
import SystemConfiguration

class Alert: NSObject {

    // function to set show alert
    class func showAlert( strMessage : NSString , Onview : UIViewController)
    {
        if Onview.navigationController != nil {
            
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "InstaCash" as String, message: strMessage as String, preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                Onview.present(alertController, animated: true, completion: nil)
            }
        }else {
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "InstaCash" as String, message: strMessage as String, preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                
                Onview.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // function to set show alert with title

    class func showAlertWithTitle(strTitle : NSString  , strMessage : NSString , Onview : UIViewController)
    {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: strTitle as String, message: strMessage as String, preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            Onview.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // called method when show processing symbol
    
    class func ShowProgressHud(Onview : UIView)
    {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: Onview, animated: true)
            hud.mode = .customView
            let imageView = UIImageView(image: UIImage(named: "appLogo"))
            imageView.frame = CGRect(x: 0, y: 0, width: 77, height: 77)
            hud.customView  = imageView
            hud.backgroundView.backgroundColor = UIColor.clear
            hud.bezelView.backgroundColor = UIColor.clear
            hud.customView?.backgroundColor = UIColor.clear
            hud.backgroundView.style = .solidColor
            //MBProgressHUD.showAdded(to: Onview, animated: true)
        }
        
    }
    
    class  func ShowProgressHudwith(Onview:UIView,message:String)
    {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: Onview, animated: true)
            hud.label.text = message
            hud.isUserInteractionEnabled = false
        }
        
    }
    
    // called method when hide processing symbol

    class func HideProgressHud(Onview : UIView)
    {
        DispatchQueue.main.async {
            
            MBProgressHUD.hide(for: Onview, animated: true)
            
        }
        
    }
    
    // check email is in correct format or not like (abcd@zyc.com)
    
   class func isValidEmail(testStr:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: testStr)
    }
    
    
    // check password strongness is in correct format or not like (one numarical , one charater , one special symbol and min 8 charater)
    
   class func isValidPassword(testPass : String) -> Bool
    {
//        let passRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
//        return NSPredicate(format: "SELF MATCHES %@", passRegex).evaluate(with: testPass)
        
        return true
        
    }
    
 class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
    
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showaAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(_ title: String, message: String, alertButtonTitles: [String], alertButtonStyles: [UIAlertAction.Style], vc: UIViewController, completion: @escaping (Int)->Void) -> Void
    {
        let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        
        for title in alertButtonTitles {
            let actionObj = UIAlertAction(title: title,
                                          style: alertButtonStyles[alertButtonTitles.index(of: title)!], handler: { action in
                                            completion(alertButtonTitles.index(of: action.title!)!)
            })
            
            alert.addAction(actionObj)
        }
        
        // alert.view.tintColor = Utility.themeColor
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
    
}
