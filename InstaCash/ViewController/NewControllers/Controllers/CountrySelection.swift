//
//  CountrySelection.swift
//  TechCheck
//
//  Created by CULT OF PERSONALITY on 06/10/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class CountrySelection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionForCountry: UICollectionView!
    
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    var arrCityData = [CityModel]()
    var states = [String]()
    var cities = [String]()
    let reachability: Reachability? = Reachability()
    var isSelectedIndex = -1
    var stateSelection = 0
    var selectedState = "England"
    
    func changeLanguageOfUI() {
        
        self.lblArea.text = "Areas we serve".localized(lang: langCode)
        //self.btnNext.setTitle("Next".localized(lang: langCode), for: UIControlState.normal)
        self.btnNext.setTitle("Type your city".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionForCountry.register(UINib(nibName: "CountrySelectionCell", bundle: nil), forCellWithReuseIdentifier: "countryCell")
        
        if reachability?.connection.description != "No Connection" {
            CityModel.fetchCityFromServer(isInterNet:true,getController: self) { (arrCityData) in
                
                for item in arrCityData {
                    print(item.strCityName ?? "CityName")
                    print(item.strStateName ?? "StateName")
                    print(item.strCityCode ?? "PinCode")
                }
                
                
                if arrCityData.count > 0{
                    self.arrCityData = arrCityData
                    
                    if !CustomUserDefault.getCityId().isEmpty {
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
                            }
                        }
                    }else{
                        
                        //Sameer 3/5/2020
                        if CustomUserDefault.getCurrency() == "NT$" {
                            let twArr = ["Choose Country".localized(lang: langCode),"Taiwan".localized(lang: langCode)]
                            
                            for item in twArr {
                                self.states.append(item)
                            }
                            
                        }else {
                            
                            for city in arrCityData{
                                let state = city.strStateName ?? ""
                                
                                if self.states.contains(state){
                                    //do nothing
                                }else{
                                    self.states.append(state)
                                }
                            }
                            
                        }
                        
                    }
                    
                    
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
                    
                    DispatchQueue.main.async {
                        self.collectionForCountry.reloadData()
                    }
                    
                    /*
                    self.collectionForCountry.reloadData()
                    
                    if (self.isSelectedIndex > -1){
                        var pos = 0
                        for ind in 0..<self.cities.count{
                            if(self.cities[ind] == arrCityData[self.isSelectedIndex].strCityName){
                                pos = ind
                            }
                        }
                    }
                    */
                    
                }
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(stateSelection != 0)
        {
            return cities.count
        }
        else
        {
            return states.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:self.collectionForCountry.frame.width/2, height:self.collectionForCountry.frame.height/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionForCountry.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath as IndexPath) as! CountrySelectionCell
        
        if(stateSelection != 0)
        {
            cell.lblCountry.text = self.cities[indexPath.row]
        }
        else
        {
            cell.lblCountry.text = self.states[indexPath.row]
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(stateSelection != 0)
        {
            isSelectedIndex = indexPath.row
            
            var cityIds = [String]()
            var pins = [String]()
            for city in arrCityData{
                
                if cities.contains(city.strCityName ?? ""){
                    cityIds.append(city.strCityId ?? "0")
                    pins.append(city.strCityCode ?? "")
                }
            }
            
            var citySelected = ""
            if indexPath.row < cities.count {
                
                DispatchQueue.main.async {
                    citySelected = self.cities[indexPath.row]
                    CustomUserDefault.setCityName(data: citySelected)
                }
                
            }
            
            if cityIds.count > indexPath.row {
                DispatchQueue.main.async {
                    let cityId = cityIds[indexPath.row]
                    CustomUserDefault.setCityId(data: cityId)
                    
                    let pinCode = pins[indexPath.row] //Sameer 26/4/20
                    CustomUserDefault.setUserPinCode(data: pinCode) //Sameer 26/4/20
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            if CustomUserDefault.getCurrency() == "SG$" {
                
                let model = self.arrCityData[0]
                CustomUserDefault.setCityName(data: model.strCityName ?? "")
                CustomUserDefault.setCityId(data: model.strCityId ?? "")
                CustomUserDefault.setUserPinCode(data: model.strCityCode ?? "") //Sameer 26/4/2020
                
                self.dismiss(animated: true, completion: nil)
                
            }else {
                self.stateSelection = indexPath.row
                self.selectedState = states[indexPath.row]
                self.cities.removeAll()
                
                //Sameer 3/5/2020
                if CustomUserDefault.getCurrency() == "NT$" {
                    
                    for city in arrCityData {
                        
                        if city.strCityName != "Choose State" {
                            self.cities.append(city.strCityName ?? "")
                        }
                        
                    }
               
                }else {
                    
                    for city in arrCityData{
                        let state = city.strStateName ?? ""
                        
                        if self.selectedState == state {
                            self.cities.append(city.strCityName ?? "")
                        }
                    }
                    
                }
                
                print(cities)
            }
            
            self.collectionForCountry.reloadData()
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        
        if(stateSelection == 0)
        {
            Toast(text:"Please select state".localized(lang: langCode)).show()
        }
        else
        {
            if CustomUserDefault.getCityId().isEmpty {
                Toast(text:"Please select city".localized(lang: langCode)).show()
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
