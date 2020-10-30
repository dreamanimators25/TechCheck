//
//  BrandModelTypeModel.swift
//  TechCheck
//
//  Created by TechCheck on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit

class BrandTypeModel{
var strBrandModeName:String?
var strBrandModelId:String?
var strBrandModeImageUrl:String?

var strName:String?

init(brandModeName:String,brandModelId:String,brandModeImageUrl:String){
    self.strBrandModeName = brandModeName
    self.strBrandModelId = brandModelId
    self.strBrandModeImageUrl = brandModeImageUrl
   
}

init(brandModelDict: [String: Any]) {
    self.strBrandModeName = brandModelDict["model"] as? String
    self.strBrandModelId = brandModelDict["id"] as? String
    //self.strImageUrl = cityDict["imageUrl"] as? String
    self.strBrandModeImageUrl = brandModelDict["image"] as? String
}
//MARK:- web service methods

static  func brandApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    let web = WebServies()
    web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
}

    static func fetchBrandModelFromServer(isInterNet:Bool,strBrandId:String,getController:UIViewController,completion: @escaping ([BrandTypeModel]) -> Void ) {
    Alert.ShowProgressHud(Onview: getController.view)
    var arrBrandModel = [BrandTypeModel]()
    
    let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
    let strUrl = strBaseURL + "productListFromManufacturerID"
    
    let parametersHome : [String : Any] = [
        "apiKey" : key,
        "userName" : apiAuthenticateUserName,
        "manufacturerId":strBrandId,
        "page":"0",
        "limit":"-1"
        
    ]
    self.brandApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
        Alert.HideProgressHud(Onview: getController.view)
        if error == nil {
            if responseObject?["status"] as! String == "Success"{
                
                let arrCity = responseObject?["msg"] as! NSArray
                
                
                for obj in 0..<arrCity.count{
                    let dict = arrCity[obj] as! NSDictionary
                    let memberItem = BrandTypeModel(brandModelDict: dict as! [String : Any])
                    arrBrandModel.append(memberItem)
                }
                
                DispatchQueue.main.async {
                    completion(arrBrandModel)
                }
            }
            else{
                // failed
                DispatchQueue.main.async {
                    completion(arrBrandModel)
                }
            }
            
        }
        else{
            
        }
        
    })
    
    
}
}
