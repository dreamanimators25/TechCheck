//
//  HistoryModel.swift
//  InstaCash
//
//  Created by InstaCash on 28/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit
class HistoryModel{
    
    
    var strOrderId:String?
    var orderDate:String?
    var strOrderName:String?
    var strOrderAmount:String?
    var strOrderImageURL:String?
    var strSumaryHistory:String?
    var isCollapsable = false
    init(historyListDict: [String: Any]) {
        self.strOrderId = historyListDict["productId"] as? String
        self.orderDate = historyListDict["orderDate"] as? String
        self.strOrderName = historyListDict["name"] as? String
       // let amount = historyListDict["amount"] as? Int
        self.strOrderAmount = historyListDict["amount"] as? String
        self.strOrderImageURL = historyListDict["image"] as? String
        self.strSumaryHistory = historyListDict["summary"] as? String

        self.isCollapsable = false
    }
    //MARK:- web service methods
    
    static  func historyApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    static func fetchHistoryListFromServer(isInterNet:Bool,getController:UIViewController,completion: @escaping ([HistoryModel]) -> Void ) {
        Alert.ShowProgressHud(Onview: getController.view)
        var historyList = [HistoryModel]()
        var mobileNumber = ""
        if CustomUserDefault.isUserIdExit(){
            mobileNumber = CustomUserDefault.getPhoneNumber() ?? ""
        }
        else{
            mobileNumber = "-1"
        }
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "userHistory"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "mobile":mobileNumber,
            "page":"",
            "limit":"-1"
        ]
        self.historyApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: getController.view)
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    let arrCity = responseObject?.value(forKeyPath: "msg")as! NSArray
                    
                    for obj in 0..<arrCity.count{
                        let dict = arrCity[obj] as! NSDictionary
                        let memberItem = HistoryModel(historyListDict: dict as! [String : Any])
                            historyList.append(memberItem)
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(historyList)
                    }
                }
                else{
                    // failed
                    DispatchQueue.main.async {
                        completion(historyList)
                    }
                }
                
            }
            else{
                
            }
            
        })
        
        
    }
    
}
