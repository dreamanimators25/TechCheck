//
//  LiveOfferVC.swift
//  InstaCash
//
//  Created by InstaCash on 19/11/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class LiveOfferVC: UIViewController {
    
    @IBOutlet weak var btnCancelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAgreeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var refreshDataActivity: UIActivityIndicatorView!
    @IBOutlet weak var activityCancel: UIActivityIndicatorView!
    @IBOutlet weak var activityAgree: UIActivityIndicatorView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblLiveOfferPrice: UILabel!
    @IBOutlet weak var lblCurrentOfferPrice: UILabel!
    @IBOutlet weak var lblOldOfferedPrice: UILabel!
    @IBOutlet weak var btnRefresh: UIButton!
    
    let reachability: Reachability? = Reachability()
    var strGetConditionString = ""
    var strGetDiagnosisID = ""
    var strOfferID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRefresh.layer.borderWidth = 1.0
        btnRefresh.layer.borderColor = navColor.cgColor
        let swipeAgreeButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnSwipeToAgree))
        swipeAgreeButton.direction = .right
        self.btnAgree.addGestureRecognizer(swipeAgreeButton)
        let swipeCancelButton = UISwipeGestureRecognizer(target: self, action: #selector(self.btnSwipteToCancelPressed))
        swipeCancelButton.direction = .right
        self.btnCancel.addGestureRecognizer(swipeCancelButton)
        fireWebServiceForRefreshData()
    }

    @IBAction func btnRefreshPressed(_ sender: UIButton) {
        fireWebServiceForRefreshData()
    }
    
    @objc func btnSwipeToAgree(_ sender: UIButton) {
        btnCancel.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.btnAgree.frame.size.width = 40
            self.btnAgree.frame.size.height = 40
            self.btnAgreeWidthConstraint.constant = 40
            self.btnAgree.frame.origin.x = self.view.frame.size.width/2 - 18
            self.btnAgree.layer.cornerRadius = self.btnAgree.frame.height/2
            self.btnAgree.clipsToBounds = true
            self.btnAgree.setTitle("", for: .normal)
            
        }) { (_) in
            //self.rotateLeft(btnType: self.btnAgree)
            //self.rotate360Degrees()
            self.activityAgree.startAnimating()
            self.fireWebServiceForLiveAgreePrice(isforCancel: false)
        }
    }
    
    @objc func btnSwipteToCancelPressed(_ sender: UIButton) {
        btnAgree.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.btnCancel.frame.size.width = 40
            self.btnCancelWidthConstraint.constant = 40
            self.btnCancel.frame.size.height = 40
            self.btnCancel.frame.origin.x = self.view.frame.size.width/2 - 18
            self.btnCancel.layer.cornerRadius = self.btnCancel.frame.height/2
            self.btnCancel.clipsToBounds = true
            self.btnCancel.setTitle("", for: .normal)
            
            
        }) { (_) in
            //self.rotateLeft(btnType: self.btnAgree)
            //self.rotate360Degrees()
            self.activityCancel.startAnimating()
            self.fireWebServiceForLiveAgreePrice(isforCancel: true)
        }
    }
    
    //MARK:- APi for verification code
    func livePost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForLiveAgreePrice(isforCancel:Bool)
    {
        if reachability?.connection.description != "No Connection"{
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            if isforCancel{
                strUrl = strBaseURL + "updateOfferStatus"
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "offerId": strOfferID,
                    "status":"failed",
                    "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
                ]
                
                print(parameters)
            }
            else{
                strUrl = strBaseURL + "updateOfferStatus"
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "offerId": strOfferID,
                    "status":"success",
                    "orderItemId":userDefaults.value(forKey: "ChangeModeOrderId") as! String
                ]

                print(parameters)
            }
            self.livePost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                print(responseObject ?? [:])
                
                if error == nil {
                    if isforCancel{
                        self.activityCancel.stopAnimating()
                    }
                    else{
                        self.activityAgree.stopAnimating()
                    }
                    
                    if responseObject?["status"] as! String == "Success"{
                        var mesasge  = ""
                        self.btnAgree.isUserInteractionEnabled = true
                        self.btnCancel.isUserInteractionEnabled = true
                        if isforCancel{
                            mesasge = "Order successfully Canceled!"
                        }
                        else{
                            mesasge = "Order successfully updated!"
                        }
                        //userDefaults.removeObject(forKey: "ChangeModeOrderId")
                        let alertController = UIAlertController(title: "InstaCash", message:mesasge, preferredStyle: .alert)
                        let sendButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup"{
                                if isforCancel{
                                    obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                }
                                else{
                                    DispatchQueue.main.async {
                                        let vc = UploadIDVC()
                                        let nav = UINavigationController(rootViewController: vc)
                                        nav.navigationBar.isHidden = true
                                        self.present(nav, animated: true, completion: nil)
                                    }

                                }
                            }
                            else{
                                   obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
                                
                            }
                        })
                        alertController.addAction(sendButton)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        
                        self.setButtonFrame(isforCancelDone: isforCancel)
                        
                        //Alert.showAlert(strMessage:responseObject?["status"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    self.setButtonFrame(isforCancelDone: isforCancel)
                    
                    Alert.showAlert(strMessage: "Seems connection loss from server", Onview: self)
                    
                }
            })
            
        }
        else
        {
            self.setButtonFrame(isforCancelDone: isforCancel)
            
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
        
    }
    
    func setButtonFrame(isforCancelDone:Bool){
        self.btnAgree.isUserInteractionEnabled = true
        self.btnCancel.isUserInteractionEnabled = true
        if isforCancelDone{
            self.btnCancel.frame.size.width = 260
            self.btnCancelWidthConstraint.constant = 260
            self.btnCancel.frame.size.height = 40
            self.btnCancel.frame.origin.x = self.view.frame.size.width/2 - 130
            self.btnCancel.layer.cornerRadius = 0
            self.btnCancel.clipsToBounds = true
            self.btnCancel.setTitle("Swipe Here To Cancel This Order", for: .normal)
        }
        else{
            self.btnAgree.frame.size.width = 260
            self.btnAgreeWidthConstraint.constant = 260
            self.btnAgree.frame.size.height = 40
            self.btnAgree.frame.origin.x = self.view.frame.size.width/2 - 130
            self.btnAgree.layer.cornerRadius = 0
            self.btnAgree.clipsToBounds = true
            self.btnAgree.setTitle("Swipe Here To Agree With Price", for: .normal)
        }
    }
    
    func fireWebServiceForRefreshData()
    {
        if reachability?.connection.description != "No Connection"{
            refreshDataActivity.startAnimating()
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
                strUrl = strBaseURL + "getMOfferData"
                parameters  = [
                    "userName" : apiAuthenticateUserName,
                    "apiKey" : key,
                    "offerId":strOfferID
                ]
            
            print(parameters)
            
            self.livePost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                self.refreshDataActivity.stopAnimating()
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        self.lblOldOfferedPrice.text = CustomUserDefault.getCurrency() + (responseObject?["payOriginalOFPAmount"] as! String)
                        self.lblCurrentOfferPrice.text = CustomUserDefault.getCurrency() + (responseObject?["payOriginalOFPAmount"] as! String)
                        self.lblLiveOfferPrice.text = CustomUserDefault.getCurrency() + (responseObject?["payManualOfferAmount"] as! String)
                        
                    }
                    else{
                    }
                    
                }
                else
                {
                    
                    
                }
            })
            
        }
        else
        {
           
        }
        
    }
    
}
