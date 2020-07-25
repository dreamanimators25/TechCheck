//
//  CountryModel.swift
//  InstaCash
//
//  Created by InstaCash on 11/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class CountryModel{
    
    var strCountryCode:String?
    var strCurrency:String?
    var strEndPoint:String?
    var strCurrencySymbole:String?
    var strImageUrl:String?
    var isEnabled = false
    var isSelected = false

    var strName:String?
    init(countryCode:String,currency:String,endPoint:String,currencySymbole:String,imageUrl:String,isEnabled:Bool,isSelected:Bool,name:String){
        self.strCountryCode = countryCode
        self.strCurrency = currency
        self.strEndPoint = endPoint
        self.strCurrencySymbole = currencySymbole
        self.strImageUrl = imageUrl
        self.isEnabled  = isEnabled
        self.strName = name
        self.isSelected = isSelected
    }
        
        init(countryDict: [String: Any]) {
            self.strCountryCode = countryDict["countryCode"] as? String
            self.strCurrency = countryDict["currency"] as? String
            self.strEndPoint = countryDict["endPoint"] as? String
            self.strCurrencySymbole = countryDict["currencySymbole"] as? String
            self.strImageUrl = countryDict["imageUrl"] as? String
            self.isEnabled = countryDict["isEnabled"] as? Bool ?? false
            self.isSelected = false
            self.strName = countryDict["name"] as? String
        }
    
    static func fetchCountryFromFireBase(isInterNet:Bool,getController:UIViewController,completion: @escaping ([CountryModel]) -> Void ) {
        
        Alert.ShowProgressHud(Onview: getController.view)
        //let ref = Database.database().reference(withPath: "countries") //Sameer 23/4/2020 Live
        let ref = Database.database().reference(withPath: "countries_sandbox") //Sameer 23/4/2020 Testing
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            let tempArr = snapshot.value as! NSArray
            var countryList = [CountryModel]()

            for index in 0..<tempArr.count {

                let dict = tempArr[index] as! NSDictionary
                if dict.value(forKey: "isEnabled") as! Bool == true{
                    let memberItem = CountryModel(countryDict: dict as! [String : Any])
                        countryList.append(memberItem)
                }
            }
            DispatchQueue.main.async {
                completion(countryList)
            }
            
        })
        
        
    }

    
}
