//
//  CityVC.swift
//  TechCheck
//
//  Created by TechCheck on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class CityVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var collectionViewCity: UICollectionView!

    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblPleaseEnter: UILabel!
    @IBOutlet weak var txtPinCode: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblValidateMssg: UILabel!
    
    
    var arrCityData = [CityModel]()
    var states = [String]()
    var cities = [String]()
    let reachability: Reachability? = Reachability()
    var isSelectedIndex = -1
    var stateSelection = 0
    var selectedState = "England"
    
    //Mark:- notfify method when internet off
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            btnCancel.isHidden = true
            
        } else {
            btnCancel.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // notify internet is avaible or not
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            
        }
        
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
      
        self.lblMessage.text = "No Cities Found".localized(lang: langCode)
        self.lblPleaseEnter.text = "Please Enter Your Pincode".localized(lang: langCode)
        self.lblValidateMssg.text = "Select city *".localized(lang: langCode)
        self.txtPinCode.placeholder = "Enter Post Code".localized(lang: langCode)
        
        self.btnOk.setTitle("OK".localized(lang: langCode), for: UIControlState.normal)
        self.btnCancel.setTitle("CANCEL".localized(lang: langCode), for: UIControlState.normal)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewBg.layer.cornerRadius = CGFloat(btnCornerRadius)
        viewBg.clipsToBounds = true
        self.cityPicker.delegate = self
        self.cityPicker.dataSource = self
        cityPicker.selectRow(0, inComponent: 0, animated: false)

        if reachability?.connection.description != "No Connection" {
            CityModel.fetchCityFromServer(isInterNet:true,getController: self) { (arrCityData) in
                
                print(arrCityData.count,arrCityData[0])
                
                if arrCityData.count > 0 {
                    
                    self.arrCityData = arrCityData
                    self.lblMessage.isHidden = true
                    self.btnCancel.isHidden = true
                    
                    if !CustomUserDefault.getCityId().isEmpty {
                        
                        //Sameer 3/5/2020
                        if CustomUserDefault.getCurrency() == "NT$" {
                            
                            let twArr = ["Choose Country".localized(lang: langCode),"Taiwan".localized(lang: langCode)]
                            
                            for item in twArr {
                                self.states.append(item)
                            }
                            
                            for index in 0..<arrCityData.count {
                                let strCityId = arrCityData[index].strCityId
                                if strCityId == CustomUserDefault.getCityId(){
                                    self.isSelectedIndex = index
                                    self.selectedState = arrCityData[index].strStateName ?? ""
                                    self.stateSelection = 1 //self.states.firstIndex(of: self.selectedState) ?? 0
                                    self.lblValidateMssg.isHidden = true
                                    self.txtPinCode.text = arrCityData[index].strCityCode
                                }
                            }
                            
                        }else {
                            
                            for index in 0..<arrCityData.count {
                                
                                let state = arrCityData[index].strStateName ?? ""
                                if self.states.contains(state){
                                    //do nothing
                                }else{
                                    self.states.append(state)
                                }
                                
                                
                                let strCityId = arrCityData[index].strCityId
                                if strCityId == CustomUserDefault.getCityId(){
                                    self.isSelectedIndex = index
                                    self.selectedState = arrCityData[index].strStateName ?? ""
                                    self.stateSelection = self.states.firstIndex(of: self.selectedState) ?? 0
                                    self.lblValidateMssg.isHidden = true
                                    self.txtPinCode.text = arrCityData[index].strCityCode
                                }
                                
                            }
                        }
                    }else{
                        
                        // Sameer 4/10/20
                        if let pin = arrCityData[0].strCityCode {
                            self.txtPinCode.text = pin
                            CustomUserDefault.setUserPinCode(data: pin)
                            CustomUserDefault.setCityName(data: arrCityData[0].strCityName ?? "")
                            CustomUserDefault.setCityId(data: arrCityData[0].strCityId ?? "")
                        }
                        
                        for city in arrCityData {
                            let state = city.strStateName ?? ""
                            
                            if self.states.contains(state){
                                //do nothing
                            }else{
                                self.states.append(state)
                            }
                        }
                        
                    }
                    
                    //Sameer 3/5/2020
                    if CustomUserDefault.getCurrency() == "NT$" {
                        self.cities.removeAll()
                        if (self.selectedState == ""){
                            self.selectedState = self.states[0]
                        }
                        
                        
                        for city in arrCityData {
                            self.cities.append(city.strCityName ?? "")
                        }
                        
                    }else {
                        self.cities.removeAll()
                        if (self.selectedState == ""){
                            self.selectedState = self.states[0]
                        }
                        
                        for city in arrCityData{
                            let state = city.strStateName ?? ""
                            
                            if (self.selectedState == state){
                                self.cities.append(city.strCityName ?? "")
                            }
                        }
                    }
                    
                    
                    
                    self.cityPicker.reloadAllComponents()
                    self.cityPicker.selectRow(self.stateSelection, inComponent: 0, animated: false)
                    
                    if (self.isSelectedIndex > -1){
                        var pos = 0
                        for ind in 0..<self.cities.count{
                            if(self.cities[ind] == arrCityData[self.isSelectedIndex].strCityName){
                                pos = ind
                            }
                        }
                        self.cityPicker.selectRow(pos, inComponent: 1, animated: false)
                    }
                    
                }
                else{
                    self.lblMessage.isHidden = false
                }
                
            }
        }
        else{
           self.btnCancel.isHidden = false
        }
    }

    @IBAction func btnOkPressed(_ sender: UIButton) {
        if CustomUserDefault.getCityId().isEmpty{
            lblValidateMssg.isHidden = false
        }
        else{
            lblValidateMssg.isHidden = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Uitextfield delegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)!{
            
            for index in 0..<arrCityData.count {
                let strCodeget = arrCityData[index].strCityCode
                if strCodeget == textField.text {
                    selectedState = arrCityData[index].strStateName ?? "England"
                    for counter in 0..<states.count{
                        if self.selectedState == states[counter]{
                            self.stateSelection = counter
                        }
                    }
                    
                    self.cities.removeAll()
                    var pins = [String]()
                    for city in arrCityData {
                        let state = city.strStateName ?? ""
                        
                        if self.selectedState == state {
                            self.cities.append(city.strCityName ?? "")
                            pins.append(city.strCityCode ?? "")
                        }
                    }
                    
                    self.cityPicker.selectRow(self.stateSelection, inComponent: 0, animated: true)
                    for i in 0..<pins.count {
                        if strCodeget == pins[i] {
                            self.cityPicker.selectRow(i, inComponent: 1, animated: true)
                        }
                    }
                    
                    lblValidateMssg.isHidden = true
                    CustomUserDefault.setCityName(data: arrCityData[index].strCityName!)
                    CustomUserDefault.setCityId(data: arrCityData[index].strCityId!)
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return states.count
        case 1:
            print(cities.count)
            return cities.count
        default:
            return states.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch component {
        case 0:
    
            self.stateSelection = row
            self.selectedState = states[row]
            self.cities.removeAll()
            
            //Sameer 3/5/2020
            if CustomUserDefault.getCurrency() == "NT$" {
                
                if self.selectedState == "Taiwan" {
                    for city in arrCityData {
                        if city.strCityName != "Choose State" {
                            self.cities.append(city.strCityName ?? "")
                        }
                    }
                }else {
                    self.cities.append("Choose State")
                }
                
            }else {
                
                for city in arrCityData{
                    let state = city.strStateName ?? ""
                    
                    if self.selectedState == state {
                        self.cities.append(city.strCityName ?? "")
                    }
                }
            }
                
                print(selectedState)
                self.cityPicker.reloadComponent(1)
            
            break
        case 1:
            isSelectedIndex = row
            
            var cityIds = [String]()
            var pins = [String]()
            
            for city in arrCityData {
               
                if cities.contains(city.strCityName ?? "") {
                    cityIds.append(city.strCityId ?? "0")
                    pins.append(city.strCityCode ?? "")
                }
            }
            
            var citySelected = ""
            if row < cities.count {
                citySelected = cities[row]
                CustomUserDefault.setCityName(data: citySelected)
            }
            
            if cityIds.count > row {
                let cityId = cityIds[row]
                CustomUserDefault.setCityId(data: cityId)
                
                let pincode = pins[row] //Sameer 26/4/2020
                CustomUserDefault.setUserPinCode(data: pincode)
            }
            
            if pins.count > row {
                let pincode = pins[row]
                lblValidateMssg.isHidden = true
                txtPinCode.text = pincode
                CustomUserDefault.setUserPinCode(data: pincode) //Sameer 26/4/2020
            }
            
            break
            
        default:
            self.stateSelection = row
            self.selectedState = states[row]
            self.cityPicker.reloadComponent(1)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return self.states[row]
        case 1:
            isSelectedIndex = row
            print(self.cities[row])
            return self.cities[row]
        default:
            return self.states[row]
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
