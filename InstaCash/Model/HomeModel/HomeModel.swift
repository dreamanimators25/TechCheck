//
//  HomeModel.swift
//  InstaCash
//
//  Created by InstaCash on 11/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import Alamofire
import GBDeviceInfo

class HomeModel{
    var strBrandId:String?
    var strBrandName:String?
    var strBrandLogo:String?
    
    var strPopularId:String?
    var strPopularName:String?
    var strPopularImage:String?
    var maximumTotal:Int?
    var strMedianTotal:String?
    var strCategoryId:String?

    var strMyOrderId:String?
    var strMyOrderDate = ""
    
    var strCurrentDeviceId:String?
    var strCurrentDeviceName:String?
    var strCurrentDeviceImage:String?
    var currentDeviceMaximumTotal:Int?
    var currentDeviceMedianTotal:Int?
    var arrMyOrderItemList = NSArray()


    init(deviceMyOrderDict: [String: Any]) {
        self.strMyOrderId = deviceMyOrderDict["brandLogo"] as? String
        if let arr = deviceMyOrderDict["orderItem"]{
            if arr is NSArray{
                self.arrMyOrderItemList = deviceMyOrderDict["orderItem"] as! NSArray
            }
        }
        self.strMyOrderDate = deviceMyOrderDict["orderDate"] as! String
    }
    init(deviceBrandDict: [String: Any]) {
        self.strBrandLogo = deviceBrandDict["brandLogo"] as? String
        self.strBrandId = deviceBrandDict["id"] as? String
        self.strBrandName = deviceBrandDict["brandName"] as? String
    }
    init(devicePopularDict: [String: Any]) {
        self.strPopularId = devicePopularDict["id"] as? String
        self.strPopularName = devicePopularDict["name"] as? String
        self.strPopularImage = devicePopularDict["image"] as? String
        self.maximumTotal = devicePopularDict["maximumTotal"] as? Int
        self.strMedianTotal = devicePopularDict["medianTotal"] as? String
        self.strCategoryId = devicePopularDict["categoryId"] as? String
        
    }
    init(currentDeviceDict: [String: Any]) {
        self.strCurrentDeviceId = currentDeviceDict["id"] as? String
        CustomUserDefault.removeProductId()
        CustomUserDefault.setProductId(data: self.strCurrentDeviceId ?? "")
        self.strCurrentDeviceName = currentDeviceDict["name"] as? String
        self.strCurrentDeviceImage = currentDeviceDict["image"] as? String
        self.currentDeviceMaximumTotal = currentDeviceDict["maximumTotal"] as? Int
        self.currentDeviceMedianTotal = currentDeviceDict["medianTotal"] as? Int
    }
    
    //MARK:- web service methods
  static  func homeApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }

    
    static func     fetchHomeData(isInterNet:Bool,isappModeCode:String,getController:UIViewController,completion: @escaping ([HomeModel],[HomeModel],[HomeModel],[HomeModel],String) -> Void ) {
        
        var strUudid = ""
        if (KeychainWrapper.standard.string(forKey: "UUIDValue") != nil){
            strUudid = KeychainWrapper.standard.string(forKey: "UUIDValue")!
        }
        else{
            let uuID = UIDevice.current.identifierForVendor!.uuidString
            _ = KeychainWrapper.standard.set(uuID, forKey: "UUIDValue")
            strUudid = uuID
        }
        
//        if userDefaults.value(forKey: "imei_number") != nil{
//            let strImei =  userDefaults.value(forKey: "imei_number") as! String
//            if !strImei.isEmpty{
//                strUudid = userDefaults.value(forKey: "imei_number") as! String
//            }
//        }
//        else{
//            
//        }
        
        //_ = KeychainWrapper.standard.set("Hello", forKey: "SecretMessage")

        let deviceName  = UIDevice.current.modelName  as String

        let strRam = ProcessInfo.processInfo.physicalMemory
        var strGCMToken = ""
        if (userDefaults.value(forKey: "FCMToken") != nil){
             strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
        }
        else{
             strGCMToken = ""
        }

//        let strFree = UIDevice.current.deviceRemainingFreeSpaceInBytes()
//        let str = ByteCountFormatter.string(fromByteCount: strFree!, countStyle: ByteCountFormatter.CountStyle.binary)
        
        let strRom = UIDevice.current.totalDiskSpace()
        var strCustomerId = ""
        if CustomUserDefault.isUserIdExit() {
            strCustomerId = CustomUserDefault.getUserId()
        }
        else {
            strCustomerId = "-1"
        }
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as? String ?? ""
        let strUrl = strBaseURL + "homeOpen"
        var strAppModeCode = ""
        //let strUrl = "https://sandbox.getinstacash.in/instaCash/api/v5/public/homeOpen"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "gcmId" : strGCMToken,
            "imei" : strUudid, //"355771078538334",
            "deviceBrand" : deviceName,
            "modelBrand" :deviceName,
            "device" : "iPhone",
            "model" : deviceName,
            "rom" : strRom,
            "ram" : "\(strRam)",
            "customerId":strCustomerId, //"100001261"
            "isCountryData" : "",
            "isManufactureData" : "",
            "isFrequentDevice" : "" ,
            "isCurrentDevice" : "",
            "isOrderData" : ""
            ]
        
        self.homeApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            if error == nil {
                
                if responseObject?["status"] as! String == "Success" {
                    strAppModeCode = responseObject?["appMode"] as! String
                    
                let dataDeviceBrand  = responseObject?["manufacturerList"]
                    var arrDevicePopular = [HomeModel]()
                    var arrDeviceBrand = [HomeModel]()
                    var arrMyOrder = [HomeModel]()
                    var arrMyCurrentDevice = [HomeModel]()

                if dataDeviceBrand is NSArray
                {
                    let arrDeviceByBrand = dataDeviceBrand as! NSArray

                    for index in 0..<arrDeviceByBrand.count{
                        let dict = arrDeviceByBrand[index] as! NSDictionary
                        let memberItem = HomeModel(deviceBrandDict: dict as! [String : Any])
                        arrDeviceBrand.append(memberItem)
                    }
                }
                    let dataPopularDevice  = responseObject?["mostFrequentSoldSmartPhone"]
                    if dataPopularDevice is NSArray
                    {
                        let arrDeviceByPopular = dataPopularDevice as! NSArray
                        
                        for obj in 0..<arrDeviceByPopular.count{
                            let dict = arrDeviceByPopular[obj] as! NSDictionary
                            let memberItem = HomeModel(devicePopularDict: dict as! [String : Any])
                            arrDevicePopular.append(memberItem)
                        }
                    }
                    let dataMyOrder  = responseObject?["customerOrder"]
                    if dataMyOrder is NSArray
                    {
                        let arrMyOrderData = dataMyOrder as! NSArray
                        
                        for obj in 0..<arrMyOrderData.count{
                            let dict = arrMyOrderData[obj] as! NSDictionary
                            let memberItem = HomeModel(deviceMyOrderDict: dict as! [String : Any])
                            arrMyOrder.append(memberItem)
                        }
                    }

                    let dataMyCurrentDevice  = responseObject?["currentDevice"]
                    if dataMyCurrentDevice is NSArray
                    {
                        let arrMyCurrentDeviceData = dataMyCurrentDevice as! NSArray
                        
                        for obj in 0..<arrMyCurrentDeviceData.count{
                            let dict = arrMyCurrentDeviceData[obj] as! NSDictionary
                            
                            let memberItem = HomeModel(currentDeviceDict: dict as! [String : Any])
                            arrMyCurrentDevice.append(memberItem)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(arrDeviceBrand,arrDevicePopular,arrMyOrder,arrMyCurrentDevice,strAppModeCode)
                    }

                }
                else{
                    // failed
                }
            }
            else{
                
            }
            
        })
        
    }
}
