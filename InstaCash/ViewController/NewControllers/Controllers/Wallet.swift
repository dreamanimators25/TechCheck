//
//  Wallet.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 04/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class Wallet: UIViewController {
    
    var strPaymentProcessMode = "1"
    var QuatID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickOrder(_ sender: Any) {
        self.fetchOrderFromServer(isRefreshPrice: true)
    }
    
    //MARK:- webservice data
    
    func orderCreateApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(isRefreshPrice:Bool) {
       
        Alert.ShowProgressHud(Onview: self.view)
        
        var producdID = ""
        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
        }
        else {
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
        }
        
        
        var strValue = ""
        var userSelectedProductAppcodes = ""

        let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
        let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
        
        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
            strValue = "STON01,"
            
            userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
        }
        else {
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
            strValue = ""
            userSelectedProductAppcodes =  strValue + strQuestionAppCodes
        }
        
        let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
        let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
        
        
        var strGCMToken = ""
        if (userDefaults.value(forKey: "FCMToken") != nil) {
            strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
        }
        else {
            strGCMToken = ""
        }
        
        let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
        
        var strPromoterId = ""
        if userDefaults.value(forKey: "promoter_id") == nil {
            strPromoterId = ""
        }
        else {
            strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
        }
        
        //Sameer - 28/3/20
        if userDefaults.value(forKey: "promoterID") == nil {
            strPromoterId = ""
        }
        else{
            strPromoterId = userDefaults.value(forKey: "promoterID") as! String
        }
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "orderCreate"
        
        let smallParam = ["IMEINumber" : "869408047714972",
                          "name" : "Chocklingam",
                          "email" : "vigneshwar@gmail.com",
                          "mobile" : "9790122330",
                          "address1" : "No,276",
                          "address2" : "kalpakkam,Tamilnadu",
                          "pincode" : "603102",
                          "city" : "Kalpakkam",
                          "paymentType" : "NEFT",
                          "Account_Holders_Name" : "Chokalingam",
                          "Bank_Name" : "ICICI Bank",
                          "Account_Number" : "677501563360",
                          "Confirm_Account_Number" : "677501563360",
                          "IFSC" : "ICIC0006775",
                          "type" : "createOrder",
                          "isNewAddress" : "1",
                          "donateTo" : "NSS",
                          "donateAmount" : "31",
        ]
       
        var parametersHome : [String : Any] = [
            "userName" : apiAuthenticateUserName, //1
            "apiKey" : key, //1
            "mobile":CustomUserDefault.getPhoneNumber() ?? "", //1
            
            "name":CustomUserDefault.getUserName() ?? "", //1
            "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", //1
            
            "city":CustomUserDefault.getCityId(), //1
            
            ////////////////////////////////////////////////////////////
            "productId":producdID, //1
            "conditionString":converComaToSemocolumForProductValues, //1
            "diagnosisId":userDefaults.value(forKey: "diagnosisId") as! String, //1
            "processMode":self.strPaymentProcessMode, //1
            ////////////////////////////////////////////////////////////
            
            //"remark":"", //0
            "email":CustomUserDefault.getUserEmail() ?? "", //0
            //"productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String, //0
            //"GCMId":strGCMToken, //0
            "customerId":CustomUserDefault.getUserId(), //0
            //"landmark":"", //0
            "pincode":userDefaults.value(forKey: "orderPinCode") as! String, //1
            "isNewAddress":"1", //0
            
            "uniqueIdentifire":KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //1
            "paymentCode": "NEFT", //1
            
            "couponCode":userDefaults.value(forKey: "orderPromoCode") as? String ?? "", //1
            "couponAmount":couponAmount, //1
            "promoterId":strPromoterId, //0
            
            //"paymentDetails" : smallParam,
            "donateTo" : "NSS",
            "donationAmount" : "",
            
            "quotationId":QuatID, //0
            "preferredDate":"", //0
            "preferredTime":"", //0
            //"additionalInformation":"", //0
        ]
        
        if let addInfo = userDefaults.value(forKey: "additionalInfo") {
            parametersHome["additionalInformation"] = addInfo
        }
        
        print(parametersHome)
        
        self.orderCreateApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
         
            Alert.HideProgressHud(Onview: self.view)
            print("\(String(describing: responseObject) ) , \(String(describing: error))")
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                
                }
                else{
                    // failed
                    Alert.showAlert(strMessage: "oops,No data found", Onview: self)
                }
            }
            else{
                debugPrint(error as Any)
                Alert.showAlert(strMessage: "Seems connection loss from server", Onview: self)
            }
        })
        
    }
    
}
