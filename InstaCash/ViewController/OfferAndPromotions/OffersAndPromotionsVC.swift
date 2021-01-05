//
//  OffersAndPromotionsVC.swift
//  TechCheck
//
//  Created by Sameer Khan on 23/03/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class OffersAndPromotionsVC: UIViewController {
    
    @IBOutlet weak var oppoImgView: UIImageView!
    @IBOutlet weak var homeCreditImgView: UIImageView!
    @IBOutlet weak var lblOfferPromotions: UILabel!
    
    let reachability: Reachability? = Reachability()
    
    var oppoPromoterId = ""
    var homeCreditPromoterId = ""
    
    var oppoAddInfo = ""
    var homeCreditAddInfo = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()

        self.fireWebServiceForOfferAndPromotions()
    }
    
    func changeLanguageOfUI() {
        self.lblOfferPromotions.text = "Offers and Promotions".localized(lang: langCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeLanguageOfUI()
    }
    
    //MARK : IBActions
    @IBAction func btnBackPressed(_ sender:UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOppo(_ sender:UIButton){
        
        DispatchQueue.main.async {
            let vc = OfferPromotionPopUpVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            
            guard self.oppoPromoterId != "" else {
                return
            }
            
            userDefaults.set((self.oppoPromoterId), forKey: "promoterID")
            
            vc.isComeFromVC = "oppoMode"
            vc.promoterId = self.oppoPromoterId
            vc.additionalInfo = self.oppoAddInfo
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func clickHomeCredit(_ sender:UIButton){
        
        DispatchQueue.main.async {
            let vc = OfferPromotionPopUpVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true

            guard self.homeCreditPromoterId != "" else {
                return
            }
            
            userDefaults.set((self.homeCreditPromoterId), forKey: "promoterID")
            
            vc.isComeFromVC = "homeCreditMode"
            vc.promoterId = self.homeCreditPromoterId
            vc.additionalInfo = self.homeCreditAddInfo
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- APi for offer and promotions
    func offerAndPromotionsPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForOfferAndPromotions()
    {
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "promoterList"
            
            print(strUrl)
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
            ]
            
            print(parameters)
            
            self.offerAndPromotionsPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let imgArray = responseObject?["msg"] as! [[String:Any]]
                        
                        //userDefaults.set((imgArray[0]["promoterId"] as? String ?? ""), forKey: "promoterID") // Sameer 27/4/2020
                        
                        // Oppo
                        self.oppoPromoterId = imgArray[0]["promoterId"] as? String ?? ""
                        self.oppoAddInfo = imgArray[0]["additionalInformation"] as? String ?? ""
                        if let imgURL1 = URL(string: (imgArray[0]["image"] as? String) ?? "") {
                            self.oppoImgView.sd_setImage(with: imgURL1)
                        }
                        
                        // Home Credit
                        self.homeCreditPromoterId = imgArray[1]["promoterId"] as? String ?? ""
                        self.homeCreditAddInfo = imgArray[1]["additionalInformation"] as? String ?? ""
                        if let imgURL2 = URL(string: (imgArray[1]["image"] as? String) ?? "") {
                            self.homeCreditImgView.sd_setImage(with: imgURL2)
                            self.homeCreditImgView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                            self.homeCreditImgView.layer.borderWidth = 1.0
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
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
