//
//  OrderListModel.swift
//  InstaCash
//
//  Created by InstaCash on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit

class OrderListModel {
    
    var strOrderItemId:String?
    var strOrderId:String?
    var strRefrenceNumber:String?
    var orderDate:String?
    var strProductName:String?
    var strProductAmount:String?
    var strProductImageURL:String?
    var isCollapsable = false
    var strStatus:String?
    var strQuantity:String?
    var strSummay:String?
    var strPaymentName:String?
    var strPaymentImage:String?
    var strProcessMode:String?
    var isPaymentDetailsRequired = false
    var isActivePricelock = false
    var strBillRequired:String?
    var strActivePricelock:String?
 
    init(orderListDict: [String: Any],strOrderIdGet:String, strRefrenceNumber:String, strOrderDate:String) {
        
        self.strOrderId = strOrderIdGet
        self.strRefrenceNumber = strRefrenceNumber
        self.orderDate = strOrderDate
        self.strOrderItemId = orderListDict["orderItemId"] as? String
        self.strProductName = orderListDict["productName"] as? String
        let amount = orderListDict["productAmount"] as? Int
        self.strProductAmount = String(format: "%d", amount ?? 0)
        self.strProductImageURL = orderListDict["productImage"] as? String
        self.strStatus = orderListDict["status"] as? String
        self.strQuantity = orderListDict["quantity"] as? String
        self.strSummay = orderListDict["summary"] as? String
        self.strPaymentName = orderListDict["paymentName"] as? String
        self.strPaymentImage = orderListDict["paymentImage"] as? String
        self.strProcessMode = orderListDict["processMode"] as? String
        self.strActivePricelock = orderListDict["strActivePricelock"] as? String
        self.isCollapsable = false
        self.isPaymentDetailsRequired = (orderListDict["isPaymentDetailsRequired"] as? Bool ?? false)
        self.isActivePricelock = (orderListDict["activePricelock"] as? Bool ?? false)
        self.strBillRequired = orderListDict["isBillRequired"] as? String
    }
    
    //MARK:- web service methods
    static  func cityApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    static func fetchOrderListFromServer(isInterNet:Bool,getController:UIViewController,completion: @escaping ([OrderListModel]) -> Void ) {
        
        Alert.ShowProgressHud(Onview: getController.view)
        var orderList = [OrderListModel]()
        var customerID = ""
        if CustomUserDefault.isUserIdExit(){
            customerID = CustomUserDefault.getUserId()
        }
        else {
            customerID = "-1"
        }
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "orderList"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "customerId" : customerID
        ]
        
        self.cityApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: getController.view)
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    let arrCity = responseObject?.value(forKeyPath: "msg")as! NSArray
                    for obj in 0..<arrCity.count{
                        let dict = arrCity[obj] as! NSDictionary
                        let strOrderId = dict.value(forKeyPath: "orderId") as? String
                        let strRefrencenumber = dict.value(forKeyPath: "referenceNumber") as? String
                        let strDate = dict.value(forKeyPath: "orderDate") as? String
                        let arrOrderItem = dict.value(forKeyPath: "orderItem") as! NSArray
                        for index in 0..<arrOrderItem.count{
                            let dictOrderItem = arrOrderItem[index] as? [String : Any]
                            let memberItem = OrderListModel(orderListDict: dictOrderItem! , strOrderIdGet: strOrderId!, strRefrenceNumber: strRefrencenumber!, strOrderDate: strDate!)//OrderListModel(orderListDict: dict as! [String : Any],)
                            orderList.append(memberItem)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(orderList)
                    }
                }
                else{
                    // failed
                    DispatchQueue.main.async {
                        completion(orderList)
                    }
                }
                
            }
            else{
                
            }
            
        })
        
    }
    
}
