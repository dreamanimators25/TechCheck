//
//  BrandModelTypeVC.swift
//  TechCheck
//
//  Created by TechCheck on 18/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FacebookCore
import Firebase

class BrandModelTypeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    //@IBOutlet weak var tblViewSelectBrand: UITableView! //s.
    @IBOutlet weak var collectionViewSelectModel: UICollectionView! //s.
    @IBOutlet weak var collectionViewModel: UICollectionView!
    
    @IBOutlet weak var lblSellAnotherDevice: UILabel!
    @IBOutlet weak var searchBarBrand: UISearchBar!
    @IBOutlet weak var lblSelectBrand: UILabel!
    @IBOutlet weak var lblSelectModel: UILabel!
    
    var strGetBrandId = ""
    var arrBrand = [HomeModel]()
    var arrBrandTemp = [HomeModel]()
    var arrBrandModelType = [BrandTypeModel]()
    var arrBrandSearch = [String]()
    var arrBrandModelTypeSearch = [NSDictionary]()
    var isComingMore = false
    var isSearch = false
    var listView = true
    var selectedIndex = -1
    var selectedIndexTemp = -1

    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        arrBrandTemp = arrBrand
        selectedIndexTemp = selectedIndex
        collectionViewModel.register(UINib(nibName: "SelectBrandCell", bundle: nil), forCellWithReuseIdentifier: "selectBrandCell")
        
        collectionViewSelectModel.register(UINib(nibName: "GridViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridViewCollectionViewCell") //s.
        collectionViewSelectModel.register(UINib(nibName: "ListViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListViewCollectionViewCell") //s.
        
        //s.
        //let nib = UINib(nibName: "SelectModelCell", bundle: nil)
        //self.tblViewSelectBrand.register(nib, forCellReuseIdentifier: "selectModelCell")
        
        if !isComingMore{
            DispatchQueue.main.async {
                self.collectionViewModel.scrollToItem(at:IndexPath(item: self.selectedIndex, section: 0), at: .left, animated: false)
            }
            callApi(withBrandId:strGetBrandId)
        }
        else{
            lblSelectModel.isHidden = true
        }

    }
    
    func changeLanguageOfUI() {
        
        self.lblSellAnotherDevice.text = "Sell Another Device".localized(lang: langCode)
        self.lblSelectBrand.text = "Select Brand".localized(lang: langCode)
        self.lblSelectModel.text = "Select Model".localized(lang: langCode)
        self.searchBarBrand.placeholder = "Search Here...".localized(lang: langCode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isSearch = false
        
        self.changeLanguageOfUI()
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleBtnClicked(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = !sender.isSelected
        }else {
            sender.isSelected = !sender.isSelected
        }
        
        listView = !sender.isSelected
        self.collectionViewSelectModel.reloadData()
    }
    
    func callApi(withBrandId:String){
        if reachability?.connection.description != "No Connection"{
            BrandTypeModel.fetchBrandModelFromServer(isInterNet:true,strBrandId:withBrandId,getController: self) { (arrBrandModelType) in
                if arrBrandModelType.count > 0{
                    self.isSearch = false
                    self.lblSelectModel.isHidden = false
                    self.arrBrandModelType = arrBrandModelType
                    //self.tblViewSelectBrand.reloadData() //s.
                    self.collectionViewSelectModel.reloadData() //s.
                }
                else{
                }
                
            }
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
            
        }
    }
    
    //MARK:- button action methods
    @objc func btnBackPressed() -> Void {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return arrBrand.count //s.
        
        if collectionView == collectionViewModel {
            return arrBrand.count
        }else {
            if self.isSearch == false {
                return arrBrandModelType.count
            }
            else{
                return arrBrandModelTypeSearch.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewModel {
            let cellCity = collectionView.dequeueReusableCell(withReuseIdentifier: "selectBrandCell", for: indexPath) as! SelectBrandCell
            cellCity.lblBrandName.text = arrBrand[indexPath.row].strBrandName
            let imgURL = URL(string:arrBrand[indexPath.row].strBrandLogo!)
            cellCity.imgMobile.sd_setImage(with: imgURL)
            
            if selectedIndex == indexPath.row{
                cellCity.backgroundColor = navColor
                cellCity.lblBrandName.textColor = UIColor.white
            }
            else{
                cellCity.backgroundColor = UIColor.init(red: 235.0/255.0, green:  235.0/255.0, blue:  235.0/255.0, alpha: 1.0)
                cellCity.lblBrandName.textColor = UIColor.black
                
            }
            return cellCity
        }else {
            
            if listView {
                let cellList = collectionView.dequeueReusableCell(withReuseIdentifier: "ListViewCollectionViewCell", for: indexPath) as! ListViewCollectionViewCell
                
                if self.isSearch == false {
                    cellList.List_lblMobileName.text = arrBrandModelType[indexPath.row].strBrandModeName
                }
                else{
                    //search
                    let dict = arrBrandModelTypeSearch[indexPath.row]
                    cellList.List_lblMobileName.text = dict.value(forKey: "name") as? String
                    
                }
                
                return cellList
            }else {
                
                let cellGrid = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCollectionViewCell", for: indexPath) as! GridViewCollectionViewCell
                
                if self.isSearch == false {
                    cellGrid.Grid_lblMobileName.text = arrBrandModelType[indexPath.row].strBrandModeName
                }
                else{
                    //search
                    let dict = arrBrandModelTypeSearch[indexPath.row]
                    cellGrid.Grid_lblMobileName.text = dict.value(forKey: "name") as? String
                    
                }
                
                return cellGrid
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 100, height:100.0) //s.
        
        if collectionView == collectionViewModel {
            return CGSize(width: 100, height:100.0)
        }else {
            if listView {
                return CGSize(width: self.collectionViewSelectModel.frame.size.width, height: 50.0)
            }else {
                return CGSize(width: self.collectionViewSelectModel.frame.size.width/2, height:self.collectionViewSelectModel.frame.size.width/4)
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewModel {
            // if self.isSearch == false{
            callApi(withBrandId: arrBrand[indexPath.row].strBrandId!)
            selectedIndex = indexPath.row
            collectionView.reloadData()
        }else {
            if self.isSearch == false {
                userDefaults.removeObject(forKey: "otherProductDeviceImage")
                userDefaults.setValue(self.arrBrandModelType[indexPath.row].strBrandModeImageUrl, forKey: "otherProductDeviceImage")
                let idPoduct = self.arrBrandModelType[indexPath.row].strBrandModelId
                // facebook analysis event
                
                var currency = ""
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                if CustomUserDefault.getCurrency() == "£" {
                    currency = "INR"
                }
                //else if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                else if CustomUserDefault.getCurrency() == "MY" {
                    currency = "MYR"
                }
                else{
                    currency = "SGD"
                }
                AppEventsLogger.log(
                    .addedToCart(
                        contentType: self.arrBrandModelType[indexPath.row].strBrandModeName,
                        contentId: idPoduct,
                        currency: currency))
                
                /* //Sameer 2/6/2020
                // analysis event
                Analytics.logEvent("diagnosfromquestion_tapped", parameters: [
                    "event_category":"Diagnosis From Question Button Click",
                    "event_action":"Diagnosis From Question Button Click Action",
                    "event_label":"Diagnosis From Question Button Test"
                    ])*/
                
                /* //Sameer 2/6/2020
                Analytics.logEvent(AnalyticsEventViewItem, parameters: [
                    AnalyticsParameterItemID: idPoduct!,
                    AnalyticsParameterItemName: self.arrBrandModelType[indexPath.row].strBrandModeName ?? "",
                    AnalyticsParameterCurrency:currency
                    ])*/
                
                
                let vc = OtherDeviceQuestionFlow()
                vc.strGetProductID = idPoduct!
                // vc.getProductID = strProductIdGet
                //  vc.isComingFrom = "Not Diagnosis"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else {
                let dict = self.arrBrandModelTypeSearch[indexPath.row] as NSDictionary
                let strBrandID = dict.value(forKey: "id") as! String
                
                // let vc = DeiceSwitchOnVC()
                let vc = OtherDeviceQuestionFlow()
                vc.strGetProductID = strBrandID
                // vc.getProductID = strProductIdGet
                //  vc.isComingFrom = "Not Diagnosis"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
       
    }
    
    //MARK:- table view delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch == false {
            return arrBrandModelType.count
        }
        else {
            return arrBrandModelTypeSearch.count
        }
    }
    
    func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = _tableView.dequeueReusableCell(withIdentifier: "selectModelCell",for: indexPath) as! SelectModelCell
        if self.isSearch == false{
            cell.lblMobileName.text = arrBrandModelType[indexPath.row].strBrandModeName
        }
        else{
            //search
            let dict = arrBrandModelTypeSearch[indexPath.row]
            cell.lblMobileName.text = dict.value(forKey: "name") as? String

        }
//        let imgURL = URL(string:arrBrandModelType[indexPath.row].strBrandModeImageUrl!)
//        cell.imgMobile.sd_setImage(with: imgURL)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
//        if  CustomUserDefault.getProductId() == arrBrandModelType[indexPath.row].strBrandModelId{
//            let imei = UserDefaults.standard.string(forKey: "imei_number")
//            if (imei?.count == 15){
//            }else{
//                let vc = IMEIVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//        else{
            if self.isSearch == false{
                userDefaults.removeObject(forKey: "otherProductDeviceImage")
            userDefaults.setValue(arrBrandModelType[indexPath.row].strBrandModeImageUrl, forKey: "otherProductDeviceImage")
            let idPoduct = arrBrandModelType[indexPath.row].strBrandModelId
                // facebook analysis event
                
                var currency = ""
                //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
                
                if CustomUserDefault.getCurrency() == "£" {
                    currency = "INR"
                }
                //else if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                else if CustomUserDefault.getCurrency() == "MY" {
                    currency = "MYR"
                }
                else{
                    currency = "SGD"
                }
                AppEventsLogger.log(
                    .addedToCart(
                        contentType: arrBrandModelType[indexPath.row].strBrandModeName,
                        contentId: idPoduct,
                        currency: currency))
                
                /* //Sameer 2/6/2020
                // analysis event
                Analytics.logEvent("diagnosfromquestion_tapped", parameters: [
                    "event_category":"Diagnosis From Question Button Click",
                    "event_action":"Diagnosis From Question Button Click Action",
                    "event_label":"Diagnosis From Question Button Test"
                    ])*/
                
                /* //Sameer 2/6/2020
                Analytics.logEvent(AnalyticsEventViewItem, parameters: [
                    AnalyticsParameterItemID: idPoduct!,
                    AnalyticsParameterItemName: arrBrandModelType[indexPath.row].strBrandModeName ?? "",
                    AnalyticsParameterCurrency:currency
                    ])*/
                
                let vc = OtherDeviceQuestionFlow()
                vc.strGetProductID = idPoduct!
                // vc.getProductID = strProductIdGet
                //  vc.isComingFrom = "Not Diagnosis"
                self.navigationController?.pushViewController(vc, animated: true)
                
//            let vc = DeiceSwitchOnVC()
//            vc.getProductID = idPoduct!
//            self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let dict = arrBrandModelTypeSearch[indexPath.row] as NSDictionary
                let strBrandID = dict.value(forKey: "id") as! String
                
                // let vc = DeiceSwitchOnVC()
                let vc = OtherDeviceQuestionFlow()
                vc.strGetProductID = strBrandID
                // vc.getProductID = strProductIdGet
                //  vc.isComingFrom = "Not Diagnosis"
                self.navigationController?.pushViewController(vc, animated: true)
                
//                //Search
//                let vc = DeiceSwitchOnVC()
//                vc.getProductID = strBrandID
//                self.navigationController?.pushViewController(vc, animated: true)
            }
       // }
        
    }
    
    //MARK:- Search bar delegates
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (searchBar.text?.utf8CString.count)! > 50
        {
            if (isBackSpace == -92) {
                return true
            }
            else
            {
                //Alert.showAlert(strMessage: "10 characters are allowed", Onview: self)
                return false
            }
        }
        else
        {
            return true
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count)! > 2{
            searchBar.resignFirstResponder()
            fireWebServiceForSearchMobileModel()
        }
        else{
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearch = false
            arrBrand.removeAll()
            arrBrand = arrBrandTemp
            selectedIndex = -1
            arrBrandModelTypeSearch.removeAll()
            arrBrandModelType.removeAll()
            collectionViewModel.reloadData()
            //tblViewSelectBrand.reloadData() //s.
            self.collectionViewSelectModel.reloadData() //s.
        }
    }
   
    //MARK:- scrool view deleage
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarBrand.resignFirstResponder()
    }
    
    
    //MARK:- web service methods
    func mobileApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForSearchMobileModel()
    {
        if reachability?.connection.description != "No Connection"{
            searchActivityIndicator.startAnimating()
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "productSearch"
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "str": searchBarBrand.text!,
                "page":"",
                "limit":"-1"
            ]
            self.mobileApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                self.searchActivityIndicator.stopAnimating()
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        self.isSearch = true
                        if let arrSearchList = ((responseObject?["msg"])){
                            if arrSearchList is NSArray{
                                self.arrBrandModelTypeSearch.removeAll()
                                self.arrBrandSearch.removeAll()
                                self.arrBrandSearch.removeAll()
                                let arrFinalSearchList = arrSearchList as! NSArray
                                var count  = -1
                                for index in 0..<arrFinalSearchList.count{
                                    let dict = arrFinalSearchList[index] as! NSDictionary
                                    self.arrBrandModelTypeSearch.insert(dict, at: index)
                                    for obj in 0..<self.arrBrand.count{
                                        let model = self.arrBrand[obj] as HomeModel
                                        if dict.value(forKey: "brandId") as? String == model.strBrandId{
                                            print(count)
                                           count  = count + 1
                                            self.arrBrandSearch.insert((dict.value(forKey: "brandId") as? String)!, at: count)
                                        }
                                    }
                                }
                                
                                if self.arrBrandModelTypeSearch.count > 0{
                                    AppEventsLogger.log(self.searchBarBrand.text!)

                                    //self.tblViewSelectBrand.reloadData() //s.
                                    self.collectionViewSelectModel.reloadData() //s.
                                }
                                
                                if self.arrBrandSearch.count > 0{
                                    let unique = Array(Set(self.arrBrandSearch))
                                    var count = -1
                                    self.arrBrand.removeAll()
                                    for j in 0..<unique.count{
                                        let strId = unique[j]
                                    for ob in 0..<self.arrBrandTemp.count{
                                        let model = self.arrBrandTemp[ob] as HomeModel
                                        self.selectedIndex = -1
                                        if strId == model.strBrandId{
                                            count = count + 1
                                             self.arrBrand.insert(model, at:count)
                                        }
                                    }
                                    }
                                   // self.arrBrand = self.arrBrandSearch
                                    self.collectionViewModel.reloadData()
                                }
                            }
                        }
                        
                    }
                    else{
                        Alert.showAlertWithError(strMessage: responseObject?["msg"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    Alert.showAlertWithError(strMessage: "Seems Connection Found".localized(lang: langCode) as NSString, Onview: self)

                }
            })
            
        }
        else
        {
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
