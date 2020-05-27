//
//  BlueToothTestingVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import Luminous
import INTULocationManager
import SwiftGifOrigin
import SwiftSpinner
import SwiftyJSON
import CoreBluetooth

import Foundation
import SystemConfiguration.CaptiveNetwork


class BlueToothTestingVC: UIViewController,CBCentralManagerDelegate {
    
    @IBOutlet weak var internalImageView: UIImageView!
    @IBOutlet weak var lblPlease: UILabel!
    @IBOutlet weak var btnBegin: UIButton!
    
    
    var location = CLLocation()
    var wifiSSID = String()
    var mcc = String()
    var mnc = String()
    var networkName = String()
    var connection = false
    var resultJSON = JSON()
    var blueToothManager:CBCentralManager!
    var wifiManager:CBPeripheralManager!
    var iscomingFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sameer 14/4/2020
        userDefaults.removeObject(forKey: "bluetooth_complete")
        userDefaults.setValue(false, forKey: "bluetooth_complete")
        
        if iscomingFromHome == true {
            userDefaults.removeObject(forKey: "bluetooth_complete")
            userDefaults.setValue(false, forKey: "bluetooth_complete")
        }

        blueToothManager   = CBCentralManager()
        blueToothManager.delegate = self
        userDefaults.setValue(false, forKey: "GSM")
        userDefaults.setValue(false, forKey: "Bluetooth")
        userDefaults.setValue(false, forKey: "Storage")
        userDefaults.setValue(false, forKey: "GPS")
        userDefaults.setValue(false, forKey: "Battery")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblPlease.text = "Please make sure Bluetooth, GPS and Wifi are enabled on your device and press begin to start the tests.".localized(lang: langCode)
        
        self.btnBegin.setTitle("Begin Tests".localized(lang: langCode), for: UIControlState.normal)
    }
    
    //MARK:- bluetooth delegates methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.resultJSON["Bluetooth"].int = 1
            userDefaults.setValue(true, forKey: "Bluetooth")
            break
        case .poweredOff:
            self.resultJSON["Bluetooth"].int = -1
            userDefaults.setValue(false, forKey: "Bluetooth")
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            break
        default:
            break
        }
    }

    @IBAction func btnBeginTestPressed(_ sender: UIButton) {
        //userDefaults.setValue(true, forKey: "bluetooth_complete") // sameer 14/4/2020
        
        SwiftSpinner.show(progress: 0.2, title: "Checking Network...".localized(lang: langCode))
        SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            self.resultJSON["GSM"].int = 0
            userDefaults.setValue(false, forKey: "GSM")
            switch self.blueToothManager.state {
            case .poweredOn:
                self.resultJSON["Bluetooth"].int = 1
                userDefaults.setValue(true, forKey: "Bluetooth")
                break
            case .poweredOff:
                self.resultJSON["Bluetooth"].int = -1
                userDefaults.setValue(false, forKey: "Bluetooth")
                break
            case .resetting:
                break
            case .unauthorized:
                break
            case .unsupported:
                break
            case .unknown:
                break
            default:
                break
            }

         
            self.resultJSON["Storage"].int = 1
            userDefaults.setValue(true, forKey: "Storage")

            self.resultJSON["GPS"].int = 0
            userDefaults.setValue(false, forKey: "GPS")

            self.resultJSON["Battery"].int = 1
            userDefaults.setValue(true, forKey: "Battery")

            if Luminous.System.Carrier.mobileCountryCode != nil{
                self.mcc = Luminous.System.Carrier.mobileCountryCode!
                self.connection = true
                self.resultJSON["GSM"].int = 1
                userDefaults.setValue(true, forKey: "GSM")

            }
            if Luminous.System.Carrier.mobileNetworkCode != nil {
                self.mnc = Luminous.System.Carrier.mobileNetworkCode!
                self.connection = true
                self.resultJSON["GSM"].int = 1
                userDefaults.setValue(true, forKey: "GSM")

            }
//            if Luminous.System.Carrier.name != nil {
//                self.networkName = Luminous.System.Carrier.name!
//                self.connection = true
//                self.resultJSON["GSM"].int = 1
//                userDefaults.setValue(true, forKey: "GSM")
//            }
            
            SwiftSpinner.show(progress: 0.2, title: "Checking Bluetooth...".localized(lang: langCode))
            UserDefaults.standard.set(self.connection, forKey: "connection")
            SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                SwiftSpinner.show(progress: 0.35, title: "Checking GPS...".localized(lang: langCode))
                SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
                let locationManager = INTULocationManager.sharedInstance()
                locationManager.requestLocation(withDesiredAccuracy: .city,
                                                timeout: 10.0,
                                                delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                                    if (status == INTULocationStatus.success) {
                                                        self.connection = self.connection && true
                                                        // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                        // currentLocation contains the device's current location
                                                        self.location = currentLocation!
                                                        self.resultJSON["GPS"].int = 1
                                                        userDefaults.setValue(true, forKey: "GPS")

                                                    }
                                                    else if (status == INTULocationStatus.timedOut) {
                                                        self.connection = false
                                                        // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                        // However, currentLocation contains the best location available (if any) as of right now,
                                                        // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                                    }
                                                    else {
                                                        
                                                        self.connection = false
                                                        // An error occurred, more info is available by looking at the specific status returned.
                                                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    SwiftSpinner.show(progress: 0.85, title: "Checking WiFi...".localized(lang: langCode))
                    SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
                  
                    if Luminous.System.Network.isConnectedViaWiFi{
                        self.wifiSSID = Luminous.System.Network.SSID
                        self.connection = self.connection && true
                        self.resultJSON["WIFI"].int = 1
                        userDefaults.setValue(true, forKey: "WIFITest")

                    }
                    else{
                        self.resultJSON["WIFI"].int = -1
                        userDefaults.setValue(false, forKey: "WIFITest")
                        
                    }
                    
                    // sameer 14/4/2020
                    userDefaults.setValue(true, forKey: "bluetooth_complete")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        SwiftSpinner.show("Tests Complete!".localized(lang: langCode), animated: false)
                        UserDefaults.standard.set(self.connection, forKey: "connection")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            //SwiftSpinner.show("Finalising Tests...")
                            //self.modifiersAPI()
                            SwiftSpinner.hide()
                            DispatchQueue.main.async {
                              //  SwiftSpinner.hide()
                                let vc = DiagnosticTestResultVC()
                                vc.resultJSON = self.resultJSON
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                          
                            
                        }
                    }
                }
            }
        }
    }

    /*
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    func isWifiEnabled() -> Bool {
        var addresses = [String]()

        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return false }
        guard let firstAddr = ifaddr else { return false }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString: ptr.pointee.ifa_name))
        }

        freeifaddrs(ifaddr)
        return addresses.contains("awdl0")
    }
    
    func isWifiEnabled1() -> Bool {
        var addresses = [String]()

        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return false }
        guard let firstAddr = ifaddr else { return false }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString: ptr.pointee.ifa_name))
        }

        var counts:[String:Int] = [:]

        for item in addresses {
            counts[item] = (counts[item] ?? 0) + 1
        }

        freeifaddrs(ifaddr)
        guard let count = counts["awdl0"] else { return false }
        return count > 1
    }
    
    func isWIFIActive() -> Bool {
        guard let interfaceNames = CWWiFiClient.interfaceNames() else {
            return false
        }

        for interfaceName in interfaceNames {
            let interface = CWWiFiClient.shared().interface(withName: interfaceName)

            if interface?.ssid() != nil {
                return true
            }
        }
        return false
    }
    
    func isWiFiOn() -> Bool {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                //defer { ptr = ptr.memory.ifa_next }
                //let interface = ptr.memory
                //let addrFamily = interface?.ifa_addr.memory.sa_family
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name = String.init(cString: (interface?.ifa_name)!), let name1 = "awd10" {
                        if((Int32?(interface?.ifa_flags) && IFF_UP) == IFF_UP) {
                            return true
                        }else {
                            return false
                        }
                    }
                }
                
                /*
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let name = String.fromCString(interface.ifa_name), name == "awdl0" {
                        if((Int32(interface.ifa_flags) & IFF_UP) == IFF_UP) {
                            return(true)
                        }
                        else {
                            return(false)
                        }
                    }
                }*/
                
            }
            freeifaddrs(ifaddr)
        }
        return (false)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
