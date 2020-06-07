//
//  SearchProduct.swift
//  InstaCash
//
//  Created by InstaCash on 16/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit

class SearchProduct {
    
    var strProductId:String?
    var strProductName:String?
    var strProductImage:String?
    var strproductBrandName:String?
    var strSmartPhone:String?

    init(searchProductListDict: [String: Any]) {
        self.strProductId = searchProductListDict["id"] as? String
        self.strProductName = searchProductListDict["name"] as? String
        self.strProductImage = searchProductListDict["image"] as? String
        self.strproductBrandName = searchProductListDict["brandName"] as? String
        self.strSmartPhone = searchProductListDict["categoryName"] as? String        
    }
    
    //MARK:- web service methods
    
    static  func searchApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    static func fetchProductSearchListFromServer(isInterNet:Bool,getController:UIViewController,getStrSearchString:String,completion: @escaping ([SearchProduct]) -> Void ) {
        Alert.ShowProgressHud(Onview: getController.view)
        var productSearchList = [SearchProduct]()
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "productListFromQueryString"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "str":getStrSearchString,
            "page":"",
            "limit":"-1"
        ]
        
        self.searchApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: getController.view)
            if error == nil {
                
                if responseObject?["status"] as! String == "Success"{
                    let arrSearchProduct = responseObject?.value(forKeyPath: "msg")as! NSArray
                        for index in 0..<arrSearchProduct.count{
                            let dictOrderItem = arrSearchProduct[index] as? [String : Any]
                            let memberItem = SearchProduct(searchProductListDict: dictOrderItem!)
                                productSearchList.append(memberItem)
                        }
                    
                    DispatchQueue.main.async {
                        completion(productSearchList)
                    }
                }
                else{
                    // failed
                    DispatchQueue.main.async {
                        completion(productSearchList)
                    }
                }
                
            }
            else{
                
            }
            
        })
        
        
    }
    
}
