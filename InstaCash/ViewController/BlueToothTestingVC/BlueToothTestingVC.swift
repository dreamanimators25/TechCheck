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

class BlueToothTestingVC: UIViewController,CBCentralManagerDelegate {
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

    @IBOutlet weak var internalImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
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

        // Do any additional setup after loading the view.
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
        userDefaults.setValue(true, forKey: "bluetooth_complete")
        SwiftSpinner.show(progress: 0.2, title: "Checking Network...")
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
            
            SwiftSpinner.show(progress: 0.2, title: "Checking Bluetooth...")
            UserDefaults.standard.set(self.connection, forKey: "connection")
            SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                SwiftSpinner.show(progress: 0.35, title: "Checking GPS...")
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
                    SwiftSpinner.show(progress: 0.85, title: "Checking WiFi...")
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        SwiftSpinner.show("Tests Complete!", animated: false)
                        UserDefaults.standard.set(self.connection, forKey: "connection")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            //SwiftSpinner.show("Finalising Tests...")
                            //self.modifiersAPI()
                            SwiftSpinner.hide()
                            DispatchQueue.main.async {
                              //  SwiftSpinner.hide()
                                let vc = DiagnosticTestResultVC()
                                vc.resultJSON = self.resultJSON
                                self.present(vc, animated: true, completion: nil)
                            }
                          
                            
                        }
                    }
                }
            }
        }
    }
    
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
