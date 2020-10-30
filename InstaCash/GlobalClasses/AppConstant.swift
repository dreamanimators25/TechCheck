import Foundation
import Alamofire
import UIKit
import SystemConfiguration

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
//let navColor = UIColor.init(red: 0.0/255.0, green: 127.0/255.0, blue: 66.0/255.0, alpha: 1.0) //s.
//let navColor = UIColor.init(red: 40.0/255.0, green: 176.0/255.0, blue: 61.0/255.0, alpha: 1.0) //s.
let navColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
let placeHolderColor = UIColor.white
let btnCornerRadius = 5.0
let viewCornerRadius = 2.0

//InstaCash
//let fontNameLight = "Roboto-Light"
//let fontNameMedium = "Roboto-Medium"
//let fontNameRegular = "Roboto-Regular"

//TechCheck
let fontNameLight = "Supply-Light"
let fontNameMedium = "Supply-Medium"
let fontNameRegular = "Supply-Regular"

let fontSizeHeading = UIScreen.main.bounds.height * 0.03
let fontSizeSubHeading = UIScreen.main.bounds.height * 0.025
let fontSizeSubHeadingListing = UIScreen.main.bounds.height * 0.022

let fontSizeSubHeadingSmall = UIScreen.main.bounds.height * 0.015
let fontSizeSubHeadingVerySmall = UIScreen.main.bounds.height * 0.02
let fontSizebuttons = screenSize.height * 0.032






let userDefaults = UserDefaults.standard
let obj_app = (UIApplication.shared.delegate! as! AppDelegate)
var key : String = "3614bc420a37b5a2b0bcd8aebb2a968d"
var apiAuthenticateUserName : String = "instantIOS"

var promoterKey : String = "a9095b192e2352b42733b6cb5c48195d"
var promoterUserName : String = "storeIOS"

//var key : String = "9207ff9e98ef1f5bd99b03922bb0e07b"
//var apiAuthenticateUserName : String = "testPrakhariOS"

//for live
//instantIOS
//3614bc420a37b5a2b0bcd8aebb2a968d

//Malasiya
//myinstacashios
//9781b4d29fc3ebdb3b46489f0d3f5396
//India
//9207ff9e98ef1f5bd99b03922bb0e07b
//testPrakhariOS
var mainURL : String = ""
public var Manager: Alamofire.SessionManager = {
    // Create the server trust policies
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "192.168.1.175": .disableEvaluation
    ]
    // Create custom manager
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    let manager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
    return manager
}()


func checkForNull(value : Any)->Any{
    
    if value is NSNull {
        return ""
    }
    else {
        return value
    }
}

func checkForNullDouble(value : Any)->Any{
    
    if value is NSNull {
        return 0.0
    }
    else {
        return value
    }
}

func checkForDictNull(value : Any)->Bool{
    
    if value is NSNull {
        return true
    }
    else {
        return false
    }
}


func checkForNullInt(value : Any)->Any{
    
    if value is NSNull {
        return 0
    }
    else {
        return value
    }
}


func isObjectNotNil(object:AnyObject!) -> Bool
{
    if let _:AnyObject = object
    {
        return true
    }
    
    return false
}


func validatePhoneNo(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}
