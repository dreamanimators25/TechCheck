//
//  AppDelegate.swift
//  InstaCash
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore
import GoogleSignIn
import Firebase
import MFSideMenu
import UserNotifications
import TrueSDK
import LocalAuthentication
import Crashlytics
//import Fabric
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window : UIWindow?
    var nav : UINavigationController?
    var sideController : MFSideMenuContainerViewController?
    var getDeviceToken : Data?

    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    //MARK:- Set root view
    func setRootViewController(){
        let vc = CountryVC()
        nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    //When need to navigate to HomeVC
    func setRootVCNavigateToHomeVC() {
        let vc = HomeVC()
        nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func setRotControllersWithSideMenu(sendMyOrderArray:[HomeModel],sendBrandArray:[HomeModel],SendPupularDevoice:[HomeModel],SendMyCurrentDevice:[HomeModel],isComingFromWelcome:Bool,strAppCodeGet:String)
    {
        
        let vc = HomeVC()
        vc.arrMyOderGetData = sendMyOrderArray
        vc.arrBrandDeviceGetData = sendBrandArray
        vc.arrPopularDeviceGetData = SendPupularDevoice
        vc.arrMyCurrentDeviceSend = SendMyCurrentDevice
        vc.isComingFromWelcomeScreen = isComingFromWelcome
        //let leftVC:UIViewController = SideMenuVC()
        let navVC:UINavigationController = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = true
        //navVC.navigationBar.tintColor = navColor
        //let sideMenu:MFSideMenuContainerViewController = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: leftVC, rightMenuViewController: nil)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
    
    func setRootWithMrnuForPlaceOreder(isComingFrom:Bool){
        let vc = PlaceOrderVC()
        vc.isComingFromLogin = isComingFrom
        let leftVC:UIViewController = SideMenuVC()
        let navVC:UINavigationController = UINavigationController(rootViewController: vc)
        UINavigationBar.appearance().barTintColor = navColor
        let sideMenu:MFSideMenuContainerViewController = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: leftVC, rightMenuViewController: nil)
        self.window?.rootViewController = sideMenu;
        self.window?.makeKeyAndVisible()
    }
    
    //MARK:- register APNS
    func registerAPNS(application:UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self


        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
     
    }
    @objc func tokenRefreshNotificaiton(notification: NSNotification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
            } else if let result = result {
                UserDefaults.standard.set("\(result.token)", forKey: "FCMToken")
            }
        }
        
//        if let fcmToken = InstanceID.instanceID().token() {
//            UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
//            print("Registration to Firebase Successful!: ", fcmToken)
//        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
    }
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
            } else {
            }
        }
    }
  
    // custom notification
    func sendNotification(name: String, message: String) -> Void {
        
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
        //
        //        })
        //
        let content = UNMutableNotificationContent()
        content.title = "InstaCash Message"
        content.subtitle = name
        content.body = message
        content.sound = UNNotificationSound.default()
        //content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "InstaCashMessage", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
            }
        }
        return nil
    }
    //MARK:- firebase delegates methods
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print(fcmToken)
//    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        if let dict = remoteMessage.appData as NSDictionary? as! [String:Any]? {
            if let dictionary = dict["message"]  {
                let dictFinal = convertToDictionary(text: dictionary as! String)
                if dictFinal!["type"] != nil{
                    if dictFinal!["type"] as! String == "big"{
                        let strMessage = dictFinal!["msg"] as! String
                        let strBigMessage = dictFinal!["bigmsg"] as! String
                        sendNotification(name: strMessage, message: strBigMessage)
                    }
                }
            }
        }
    }
    
    //MARK:- APNS delegate methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        getDeviceToken  = deviceToken
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print(deviceTokenString)
//        UserDefaults.standard.set(deviceTokenString as String, forKey: "FCMToken")

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        NSLog("Prakhar3")
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    
    //MARK:- openUrl method for social integration
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("Welcome")
        let isFBOpenUrl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
//        if (url.path == "/re.php") {
//            print(url.absoluteString)
//            guard let referrer = url["utm_term"] else {
//                print("No utm_term parameter")
//                return false
//            }
//            userDefaults.removeObject(forKey: "Utm_Term_Value")
//            userDefaults.setValue(referrer, forKey: "Utm_Term_Value")
//            return true
//        }
        
    
//        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let path = components.path, let query = components.query {
//            if path == "/re.php" {
//                // Pass the profile ID from the URL to the view controller.
//                print(url.absoluteString)
//                guard let referrer = url["utm_term"] else {
//                    print("No utm_term parameter")
//                    return false
//                }
//                userDefaults.removeObject(forKey: "Utm_Term_Value")
//                userDefaults.setValue(referrer, forKey: "Utm_Term_Value")
//                return true
//            }
//        }
        
        if isFBOpenUrl { return true }
        if isGoogleOpenUrl { return true }
        return false
        
    }
    
   
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//        print("url \(url)")
//        print("url host :\(url.host!)")
//        print("url path :\(url.path)")
//        
//        let urlPath : String = url.path as! String
//        let urlHost : String = url.host as! String
//        
//        if(urlHost != "swiftdeveloperblog.com")
//        {
//            print("Host is not correct",urlHost)
//            return false
//        }
//        
//        if(urlPath == "Home"){
//        } else if (urlPath == "/about"){
//            
//        }
//     
//        return true
//
//    }
    //MARK:- true caller active method
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            guard let referrer = url["utm_term"] else {
                print("No utm_term parameter")
                return TCTrueSDK.sharedManager().application(application, continue: userActivity, restorationHandler: restorationHandler)
            }
            userDefaults.removeObject(forKey: "Utm_Term_Value")
            userDefaults.setValue(referrer, forKey: "Utm_Term_Value")
            print(referrer)
            //handle url and open whatever page you want to open.
            return true

        }
        else{
        return TCTrueSDK.sharedManager().application(application, continue: userActivity, restorationHandler: restorationHandler)
        }
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
//    func queryParameters(from url: URL) -> [String: String] {
//        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
//        var queryParams = [String: String]()
//        for queryItem: URLQueryItem in (urlComponents?.queryItems)! {
//            if queryItem.value == nil {
//                continue
//            }
//            queryParams[queryItem.name] = queryItem.value
//        }
//        return queryParams
//    }
    
   
    
    //MARK:- App lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
//        var isUniversalLinkClick: Bool = false
//        if (launchOptions?[UIApplicationLaunchOptionsKey.userActivityDictionary] != nil) {
//            let activityDictionary = launchOptions?[UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
//            let activity = activityDictionary[UIApplicationLaunchOptionsKey.userActivityType] as? NSUserActivity ?? NSUserActivity()
//            if activity != nil {
//                isUniversalLinkClick = true
//            }
//        }
//        if isUniversalLinkClick {
//            // app opened via clicking a universal link.
//        } else {
//            // set the initial viewcontroller
//        }
        
        
//        let powerInformation =  EEPowerInformation()
//        let str = NSString(format: "%f", powerInformation.batteryHealth)
//        print(str)
//        let strMax = NSString(format: "%ld", powerInformation.batteryMaximumCapacity)
//        print(strMax)
//        let strMin = NSString(format: "%ld", powerInformation.batteryRawLevel)
//        print(strMin)

        if userDefaults.value(forKey: "isLaterForConfirmOrder") != nil{
            if userDefaults.value(forKey: "isLaterForConfirmOrder") as! Bool == true{
                userDefaults.setValue(true, forKey: "isShowUIOnHomeForOrder")
            }
            if userDefaults.value(forKey: "priceDate_quote") != nil{
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let dateStart = formatter.string(from: date)
                let endDate = userDefaults.value(forKey: "priceDate_quote") as! String
                let startDatefinal:NSDate = formatter.date(from: dateStart)! as NSDate
                let endDateFinal:NSDate = formatter.date(from: endDate)! as NSDate
                let numberOfDays = daysBetweenDates(startDate: endDateFinal as Date, endDate: startDatefinal as Date)
                if numberOfDays >= 7{
                    userDefaults.set(false, forKey: "isShowUIOnHomeForOrder")
                }
            }
        }
        else{
            if userDefaults.value(forKey: "priceDate_quote") != nil{
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let dateStart = formatter.string(from: date)
                let endDate = userDefaults.value(forKey: "priceDate_quote") as! String
                let startDatefinal:NSDate = formatter.date(from: dateStart)! as NSDate
                let endDateFinal:NSDate = formatter.date(from: endDate)! as NSDate
                
                let numberOfDays = daysBetweenDates(startDate: endDateFinal as Date, endDate: startDatefinal as Date)
                if numberOfDays >= 7{
                    userDefaults.set(false, forKey: "isShowUIOnHomeForOrder")
                }
                
            }
        }
//        for familyName in UIFont.familyNames {
//            print("\n-- \(familyName) \n")
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
//                print(fontName)
//            }
//        }
        IQKeyboardManager.sharedManager().enable = true
        SDKSettings.enableLoggingBehavior(.appEvents)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //Setup TruecallerSDK
        if TCTrueSDK.sharedManager().isSupported() {
            userDefaults.setValue(true, forKey: "isTrueCallerSupported")
            TCTrueSDK.sharedManager().setup(withAppKey: "rxTUE321d2c69bd2348b2aaa74f5a6d7e6274", appLink: "https://sia8a5da3b48514399a537579338390933.truecallerdevs.com")
        }
        else{
            userDefaults.setValue(false, forKey: "isTrueCallerSupported")
        }
        FirebaseApp.configure()
        
        //Fabric.with([Crashlytics.self])
        
        //Regester APNS
        registerAPNS(application: application)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        //configure for social media integration
        GIDSignIn.sharedInstance().clientID = "923206721363-bt9d6f1vq711p02hkppqhc7q5itj8of4.apps.googleusercontent.com"
        
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // set status bar color
        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbar.backgroundColor = UIColor.init(red: 0.0/255.0, green: 127.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        }
        //UIApplication.shared.statusBarStyle = .lightContent

        // Override point for customization after application launch.
        //sleep(3)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        if userDefaults.value(forKey: "baseURL") == nil{
            setRootViewController()
        }
        else{
            if CustomUserDefault.getCityId().isEmpty {
                setRootViewController()
            }else {
                setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false, strAppCodeGet:"")
            }
        }
        connectToFcm()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension URL {
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        if let parameters = url.queryItems {
            return parameters.first(where: { $0.name == queryParam })?.value
        } else if let paramPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&") {
            for pair in paramPairs where pair.contains(queryParam) {
                return pair.components(separatedBy: "=").last
            }
            return nil
        } else {
            return nil
        }
    }
}
