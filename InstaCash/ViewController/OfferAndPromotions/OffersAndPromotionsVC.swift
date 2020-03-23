//
//  OffersAndPromotionsVC.swift
//  InstaCash
//
//  Created by Sameer Khan on 23/03/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class OffersAndPromotionsVC: UIViewController {
    
    @IBOutlet weak var oppoImgView: UIImageView!
    @IBOutlet weak var homeCreditImgView: UIImageView!
    
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fireWebServiceForOfferAndPromotions()
    }
    
    //MARK : IBActions
    @IBAction func btnBackPressed(_ sender:UIButton){
        _ = self.navigationController?.popViewController(animated: true)
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
                        
                        //let oppoImgUrl = imgArray[0]["image"] as! String
                        //let homeCreditImgUrl = imgArray[1]["image"] as! String
                        
                        if let imgURL1 = URL(string: (imgArray[0]["image"] as? String) ?? "") {
                            self.oppoImgView.sd_setImage(with: imgURL1)
                        }
                        
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
