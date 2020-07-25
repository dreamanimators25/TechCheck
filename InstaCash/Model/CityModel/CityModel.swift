//
//  CityModel.swift
//  InstaCash
//
//  Created by InstaCash on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit
class CityModel{
   
    var strCityCode:String?
    var strCityName:String?
    var strStateName:String?
    var strCityId:String?
    var strImageUrl:String?
    var isSelected = false
    
    var strName:String?
    init(cityCode:String,cityName:String,cityId:String,imageUrl:String,isSelected:Bool,name:String,stateName:String){
        self.strCityCode = cityCode
        self.strCityName = cityName
        self.strCityId = cityId
        self.strImageUrl = imageUrl
        self.isSelected = isSelected
        self.strStateName = stateName
    }
    
    init(cityDict: [String: Any]) {
        self.strCityCode = cityDict["defaultPincode"] as? String
        self.strCityId = cityDict["cityId"] as? String
        //self.strImageUrl = cityDict["imageUrl"] as? String
        self.strCityName = cityDict["cityName"] as? String
        self.isSelected = false
        self.strStateName = cityDict["state"] as? String
    }
    //MARK:- web service methods
    
    static  func cityApiPost(strURL : String , parameters:Dictionary<String, AnyObject>, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters ), completionHandler: completionHandler)
    }
    
    static func fetchCityFromServer(isInterNet:Bool,getController:UIViewController,completion: @escaping ([CityModel]) -> Void ) {
        DispatchQueue.main.async {
            Alert.ShowProgressHud(Onview: getController.view)
        }
        var cityList = [CityModel]()

        let strBaseURL = userDefaults.value(forKey: "baseURL") as? String ?? ""
        let strUrl = strBaseURL + "getAllCity"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "version" : "v2"
        ]
        self.cityApiPost(strURL: strUrl, parameters: parametersHome as Dictionary<String, AnyObject>, completionHandler: {responseObject , error in
            
            DispatchQueue.main.async {
                Alert.HideProgressHud(Onview: getController.view)
            }
            
            if error == nil {
                if responseObject?["status"] as! String == "Success" {
                    
                    let msg = responseObject?["msg"] as! NSArray
                    for msgCount in 0..<msg.count {
                        let stateObj = msg[msgCount] as! Dictionary<String, AnyObject>
                        let stateName = stateObj["name"]
                        let cityArr = stateObj["city"] as! NSArray
                        
                        for obj in 0..<cityArr.count{
                                var dict = cityArr[obj] as! Dictionary<String, AnyObject>
                                dict["state"] = stateName
                                let memberItem = CityModel(cityDict: dict as [String : Any])
                                cityList.append(memberItem)
                            }
                            
                         }
                    DispatchQueue.main.async {
                        completion(cityList)
                    }
                }
                else{
                    // failed
                    DispatchQueue.main.async {
                        completion(cityList)
                    }
                }
                
            }
            else{
                
            }
            
        })
        
        
    }
    
}
