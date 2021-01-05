//
//  SalesPackVC.swift
//  InstaCash
//
//  Created by sameer khan on 23/12/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import CoreLocation

class SalesPackVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtStreet1: UITextField!
    @IBOutlet weak var txtStreet2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPincode: UITextField!
    
    @IBOutlet weak var streetView1: UIView!
    @IBOutlet weak var streetView2: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var postCodeView: UIView!
    
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let reachability: Reachability? = Reachability()
    var isMatchPincode = false
    var strMessage = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }*/
        
        self.setLocation()

        // Set border
        let borderWidth = CGFloat(1.0)
        let borderColor = UIColor.lightGray.cgColor
        
        streetView1.layer.borderWidth = borderWidth
        streetView1.layer.borderColor = borderColor
        
        streetView2.layer.borderWidth = borderWidth
        streetView2.layer.borderColor = borderColor
        
        cityView.layer.borderWidth = borderWidth
        cityView.layer.borderColor = borderColor
        
        countryView.layer.borderWidth = borderWidth
        countryView.layer.borderColor = borderColor
        
        postCodeView.layer.borderWidth = borderWidth
        postCodeView.layer.borderColor = borderColor
        
        self.txtPincode.text = CustomUserDefault.getUserPinCode()
        self.txtCity.text = CustomUserDefault.getCityName()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtPincode.delegate = self
    }
    
    //MARK: IBActions
    @IBAction func onClickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: IBActions
    @IBAction func onClickContinue(_ sender: UIButton) {
        
    }
    
    //MARK:- textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPincode {
            if (txtPincode.text?.isEmpty)!{
                Alert.showAlertWithError(strMessage: "Enter valid Code".localized(lang: langCode) as NSString, Onview: self)
            }
            else{
                //self.lblPincodeMatchMessage.isHidden = true
                matchCityByAPI()
            }
        }
    }
    
    //MARK:- validation Method
    func Validation()->Bool
    {
        if txtStreet1.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter address line 1" as NSString, Onview: self)
            return false
        }
        else if txtPincode.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter pincode" as NSString, Onview: self)
            return false
        }
        else if isMatchPincode == false {
            Alert.showAlertWithError(strMessage: "Pincode not match with your city." as NSString, Onview: self)
            self.strMessage = "Pincode not match with your city."
            return false
        }
        
        return true
    }
    
    func cityMatchiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func matchCityByAPI() {
        
        //activityPincode.startAnimating()
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getCity"
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "pincode":txtPincode.text!
        ]
        
        print(parametersHome)
        
        self.cityMatchiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            //self.activityPincode.stopAnimating()
           
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    if CustomUserDefault.getCityId() == responseObject?.value(forKeyPath: "msg.cityId") as! String {
                        
                        self.isMatchPincode = true
                    }
                    else{
                        
                        self.strMessage = "Pincode not match with your city.".localized(lang: langCode)
                        self.isMatchPincode = false
                        
                        Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                    }
                  
                }
                else{
                    // failed
                    self.strMessage = (responseObject?["msg"] as! String)
                    Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        
    }
    
    //MARK:- func setLocation Framework
        func setLocation(){
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            
            // Here you can check whether you have allowed the permission or not.
            if CLLocationManager.locationServicesEnabled()
            {
                switch(CLLocationManager.authorizationStatus())
                {
                case .authorizedAlways, .authorizedWhenInUse:
                    if (self.locationManager.location != nil){
                    let latitude: CLLocationDegrees = (self.locationManager.location?.coordinate.latitude)!
                    let longitude: CLLocationDegrees = (self.locationManager.location?.coordinate.longitude)!
                    let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                        if error != nil {
                            return
                        }else if let country = placemarks?.first?.country,
                            let city = placemarks?.first?.locality, let _ = placemarks?.first?.name, let _ = placemarks?.first?.subLocality {
                            
                            DispatchQueue.main.async {
                                
                                if CustomUserDefault.getCityName() == "" {
                                    self.txtCity.text = city
                                }else {
                                    self.txtCity.text = CustomUserDefault.getCityName()
                                }
                                
                                self.txtStreet1.text = placemarks?.first?.addressDictionary?["SubLocality"] as? String
                                self.txtStreet2.text = placemarks?.first?.addressDictionary?["Street"] as? String
                                self.txtCity.text = placemarks?.first?.addressDictionary?["State"] as? String
                                self.txtCountry.text = placemarks?.first?.addressDictionary?["Country"] as? String
                                self.txtPincode.text = placemarks?.first?.addressDictionary?["ZIP"] as? String
                                
                                
                                if let placemark = placemarks?.last
                                {
                                    if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
                                    {
                                        //self.txtAddressLin1.text =  addrList.joined(separator: ", ") //s.
                                        
                                        //self.txtAddressLin1.text = addrList[0]
                                        //self.txtAddressLine2.text = addrList[1]
                                        
                                        //let arrStr1 : [String?] = addrList[2].components(separatedBy: ",")
                                        
                                        //self.txtPincode.text = arrStr1[1]
                                        self.matchCityByAPI()
                                        
                                    }
                                }
                            }
                            

                            
                           // self.txtAddressLin1.text = name + "," + subLocality + "," + city + "," + country
                            
                        }
                        else {
                        }
                    })
                }
                    break
                    
                case .notDetermined:
                    print("Not determined.")
                    break
                    
                case .restricted:
                    print("Restricted.")
                    break
                    
                case .denied:
                    print("Denied.")
                }
            }
            else{
                
            }
        }
        
        //MARK:- location update delegate
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.first else { return }
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if error != nil {
                    return
                }else if let country = placemarks?.first?.country,
                    let city = placemarks?.first?.locality, let _ = placemarks?.first?.name, let _ = placemarks?.first?.subLocality {
                    
                    DispatchQueue.main.async {
                        
                        if CustomUserDefault.getCityName() == "" {
                            self.txtCity.text = city
                        }else {
                            self.txtCity.text = CustomUserDefault.getCityName()
                        }

                        self.txtStreet1.text = placemarks?.first?.addressDictionary?["SubLocality"] as? String
                        self.txtStreet2.text = placemarks?.first?.addressDictionary?["Street"] as? String
                        self.txtCity.text = placemarks?.first?.addressDictionary?["State"] as? String
                        self.txtCountry.text = placemarks?.first?.addressDictionary?["Country"] as? String
                        self.txtPincode.text = placemarks?.first?.addressDictionary?["ZIP"] as? String
                        
                        if let placemark = placemarks?.last
                        {
                            if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String?]
                            {
                                //self.txtAddressLin1.text =  addrList.joined(separator: ", ") //s.
                                
                                //self.txtAddressLin1.text = addrList[0] ?? ""
                                //self.txtAddressLine2.text = addrList[1] ?? ""
                                
                                //let arrStr1 : [String?] = addrList[2]?.components(separatedBy: ",") ?? [""]
                                
                                //self.txtPincode.text = arrStr1[1] ?? ""
                                //self.txtPincode.text = "306401"
                                self.matchCityByAPI()
                                
                                self.locationManager.stopUpdatingLocation()
                                //self.locationManager = nil
                            }
                        }
                    }
                    
                  //  self.txtAddressLin1.text = name + "," + subLocality + "," + city + "," + country
                    
                }
    //            guard let currentLocPlacemark = placemarks?.first else { return }
    //            print(currentLocPlacemark.country ?? "No country found")
                //if self.isChangeLocation == true{
              
                }
        }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
