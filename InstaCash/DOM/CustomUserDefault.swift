//
//  CustomUserDefault.swift
//
//  Created by Prakhar on 06/12/17.
//

import UIKit
import SystemConfiguration


//For save and Get User Data in UserDefaults
extension UserDefaults {
    
    //Save language code
    func saveLanguageCode(langCode : String) {
        
        let defaults = UserDefaults.standard
        defaults.setValue(langCode, forKey: "langCode")
        defaults.synchronize()
    }
    
    //Get language code
    func getLanguageCode(key : String) -> String? {
        
        let defaults = UserDefaults.standard
        let langCODE = defaults.value(forKey: key)
        
        if langCODE != nil {
            return (langCODE as? String)!
        }
        
        defaults.synchronize()
        
        return nil
    }

    //Save Quotation Mode
    func saveQuotationMode(Mode : String) {
        
        let defaults = UserDefaults.standard
        defaults.setValue(Mode, forKey: "eventSource")
        defaults.synchronize()
    }
    
    //Get Quotation Mode
    func getQuotationMode(key : String) -> String? {
        
        let defaults = UserDefaults.standard
        let MODE = defaults.value(forKey: key)
        
        if MODE != nil {
            return (MODE as? String)!
        }
        
        defaults.synchronize()
        
        return nil
    }
    
}

class CustomUserDefault: NSObject {
    
    static  func setUserId(data : String)  {
        UserDefaults.standard.set(data, forKey: "UserId")
    }
    
    static  func getUserId()-> String  {
        return  UserDefaults.standard.object(forKey: "UserId") as? String ?? ""
    }
    
    static func removeUserId()
    {
        UserDefaults.standard.removeObject(forKey: "UserId")
    }
    
    static  func setUserEmail(data : String)  {
        UserDefaults.standard.set(data, forKey: "UserEmail")
    }
    
    static  func getUserEmail() -> String?  {
        if (UserDefaults.standard.object(forKey: "UserEmail") != nil){
            return  UserDefaults.standard.object(forKey: "UserEmail") as? String
        }
        else{
            return ""
        }
    }
    
    static func removeUserEmail()
    {
        UserDefaults.standard.removeObject(forKey: "UserEmail")
    }
    static  func setCityId(data : String)  {
        
        UserDefaults.standard.set(data, forKey: "CityId")
    }
    static  func getCityId()-> String  {
        if (UserDefaults.standard.object(forKey: "CityId") != nil){
            return  UserDefaults.standard.object(forKey: "CityId")as! String

        }
        else{
            return  ""

        }
    }
    static func removeCityId()
    {
        UserDefaults.standard.removeObject(forKey: "CityId")
    }
    
    static func setUserPinCode(data : String) {
        UserDefaults.standard.set(data, forKey: "orderPinCode")
    }
    static func removePinCode() {
        UserDefaults.standard.removeObject(forKey: "orderPinCode")
    }
    static func getUserPinCode() -> String? {
        if (UserDefaults.standard.object(forKey: "orderPinCode") != nil) {
            return  UserDefaults.standard.object(forKey: "orderPinCode") as? String
        }
        else{
            return "0"
        }
        
        /*
        if let pin = UserDefaults.standard.value(forKey: "orderPinCode") as? Int {
            return pin
        }else {
            return 0
        }*/
    }
    
    static  func setPhoneNumber(data : String)  {
        UserDefaults.standard.set(data, forKey: "phoneNumber")
    }
    
    static  func getPhoneNumber() -> String?  {
        if (UserDefaults.standard.object(forKey: "phoneNumber") != nil){
            return  UserDefaults.standard.object(forKey: "phoneNumber") as? String
        }
        else{
            return  ""
        }
    }
    
    static func removePhoneNumber()
    {
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
    }
    
    static  func setProductId(data : String)  {
        UserDefaults.standard.set(data, forKey: "ProductId")
    }
    
    static  func getProductId()-> String  {
        if (UserDefaults.standard.object(forKey: "ProductId") != nil){
            return  UserDefaults.standard.object(forKey: "ProductId")as! String
        }
        else{
            return  ""
        }
    }
    
    static func removeProductId(){
        UserDefaults.standard.removeObject(forKey: "ProductId")
    }
    
    static  func setCityName(data : String) {
        UserDefaults.standard.set(data, forKey: "CityName")
    }
    
    static  func getCityName()-> String  {
        return  UserDefaults.standard.object(forKey: "CityName") as? String ?? ""
    }
    
    static func removeCityName() {
        UserDefaults.standard.removeObject(forKey: "CityName")
    }
    
    static func removeCurrency() {
        UserDefaults.standard.removeObject(forKey: "currency")
    }
    static  func setCurrency(data : String)  {
        
        UserDefaults.standard.set(data, forKey: "currency")
    }
    static  func getCurrency()-> String  {
        return  UserDefaults.standard.object(forKey: "currency") as? String ?? ""
    }
    
    static func isUserIdExit() -> Bool {
        if (UserDefaults.standard.object(forKey: "UserId") != nil) {
            return true
        }else {
            return false
        }
    }
    
    static  func setUserName(data : String)  {
        UserDefaults.standard.set(data, forKey: "UserName")
    }
    
    static  func getUserName() -> String? {
        return  UserDefaults.standard.object(forKey: "UserName") as? String
    }
    
    static func removeUserName() {
        UserDefaults.standard.removeObject(forKey: "UserName")
    }
    
    static func setApiToken(data:String) {
        UserDefaults.standard.set(data, forKey: "apiToken")
    }
    
    static func getApiToken()-> String {
        if  self.isUserProfileExit() {
            return UserDefaults.standard.object(forKey: "apiToken") as! String
        }
        else
        {
            return ""
        }
    }
    
    static  func setUserProfile(data : NSDictionary)
    {
        UserDefaults.standard.set(data, forKey: "userProfile")
    }
    static  func getUserProfile()-> NSDictionary
    {
        return  UserDefaults.standard.object(forKey: "userProfile")as! NSDictionary
    }
    static func removeUserProfile()
    {
        UserDefaults.standard.removeObject(forKey: "userProfile")
    }
    
    static  func setUserProfileImage(data : String)
    {
        if (UserDefaults.standard.object(forKey: "userProfileImage") != nil){
            UserDefaults.standard.set(data, forKey: "userProfileImage")
        }
        else{
            UserDefaults.standard.set("", forKey: "userProfileImage")
        }
    }
    static  func getUserProfileImage() -> String?  {
        if (UserDefaults.standard.object(forKey: "userProfileImage") != nil){
            return  UserDefaults.standard.object(forKey: "userProfileImage") as? String
        }
        else{
            return ""
        }
    }
    static func removeUserProfileImage()
    {
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
    }
    
//    static func setDeviceToken(data:String)
//    {
//        UserDefaults.standard.set(data, forKey: DeviceToken)
//    }
//    
//    static func getDeviceToken()-> String
//    {
//        if  self.isUserProfileExit()
//        {
//            return UserDefaults.standard.object(forKey: DeviceToken) as! String
//        }
//        else
//        {
//            return ""
//       }
//    }
    
    
    
    
    
    static func removeApiToken()
    {
        UserDefaults.standard.removeObject(forKey: "apiToken")
    }
    
    static func isUserProfileExit() -> Bool
    {
        if (UserDefaults.standard.object(forKey: "userProfile") != nil)
        {
            return true
        }else
        {
            return false
        }
    }
    
    static func strinToDateConvertor(strGetDate:String) -> Date{
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "YYYY-MM-DD HH:MM:SS" //s. //Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "IST +5:00") //Current time zone
        //according to date format your date string
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //s.
        let date = dateFormatter.date(from: strGetDate)
        return date ?? Date()
    }
    
    static func dateToStringConvertor(strGetDate:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:MM"
        dateFormatter.timeZone = TimeZone(abbreviation: " IST-5:00") //Current time zone
//Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: strGetDate) //pass Date here
        return newDate
    }
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
