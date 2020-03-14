//
//  InstaCash
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

enum ColorPalette: String {
    case red = "#e55934"
    case orange = "#DFFFF"
    case green = "#9bc53d"
    case blue = "#5BC0EB"
    case gray = "#SDSD"
}


class AppConfig {
    var userID:Int
    var userName:String
    var companyID:Int
    var API_Key = ""
    var strController = ""

    init() {
        userID = -1
        userName = ""
        companyID = -1
    }
    
    func initlizeKeys() -> Void {

    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func hextConverter(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF)) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func getSeqNo() -> Int {
        var i = 0
        if let seqno = UserDefaults.standard.value(forKey: "seqno") as? Int {
            i = seqno + 1
            UserDefaults.standard.set(i, forKey: "seqno")
        } else {
            i = 1
            UserDefaults.standard.set(i, forKey: "seqno")
        }
        return i
    }
    
    
    func convertStringToDateThenDateToString() -> String {
       
        return ""
    }
    

    func pushControllerWithAnimationEffect(getController:UIViewController,PushWhichController:UIViewController){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        getController.navigationController?.view.layer.add(transition, forKey: nil)
        getController.navigationController?.pushViewController(PushWhichController, animated: false)
    }
    
    func popControllerWithAnimationEffect(getController:UIViewController){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        getController.navigationController?.view.layer.add(transition, forKey: nil)
        getController.navigationController?.popViewController(animated: false)
    }
    
}
