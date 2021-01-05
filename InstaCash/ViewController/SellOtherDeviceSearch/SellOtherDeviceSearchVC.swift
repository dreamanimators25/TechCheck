//
//  SellOtherDeviceSearchVC.swift
//  TechCheck
//
//  Created by Sameer's MacBook Pro on 15/12/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAnalytics

class SellOtherDeviceSearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableViewProduct: UITableView!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblSellAnother: UILabel!
    @IBOutlet weak var searchBarProduct: UISearchBar!
    
    let reachability: Reachability? = Reachability()
    var arrSearchProduct = [SearchProduct]()
    
    func changeLanguageOfUI() {
        
        self.lblSellAnother.text = "Sell Another Device".localized(lang: langCode)
        self.searchBarProduct.placeholder = "Search for your Device...".localized(lang: langCode)
        
        //self.btnSeeOrderStatus.setTitle("SEE ORDER STATUS".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.changeLanguageOfUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
        
        let nib = UINib(nibName: "SelectModelCell", bundle: nil)
        self.tableViewProduct.register(nib, forCellReuseIdentifier: "selectModelCell")
        
        self.fireWebServiceForSearchMobileModel()
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- table view delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchProduct.count
    }
    
    func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = _tableView.dequeueReusableCell(withIdentifier: "selectModelCell",for: indexPath) as! SelectModelCell
            cell.lblMobileName.text = arrSearchProduct[indexPath.row].strProductName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        userDefaults.removeObject(forKey: "otherProductDeviceID")
        userDefaults.removeObject(forKey: "otherProductDeviceImage")
        userDefaults.setValue(arrSearchProduct[indexPath.row].strProductImage, forKey: "otherProductDeviceImage")
        userDefaults.setValue(arrSearchProduct[indexPath.row].strProductId, forKey: "otherProductDeviceID")

        let vc = ProductConditionVC()
        vc.strProductIdGet = arrSearchProduct[indexPath.row].strProductId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        if (searchBar.text?.count)! > 2 {
            searchBar.resignFirstResponder()
            fireWebServiceForSearchMobileModel()
        }
        else{
            fireWebServiceForSearchMobileModel()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            //arrSearchProduct.removeAll()
            //tableViewProduct.reloadData()
        }
    }
    
    //MARK:- scrool view deleage
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarProduct.resignFirstResponder()
    }
    
    //MARK:- web service methods
    func mobileApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForSearchMobileModel()
    {
        if reachability?.connection.description != "No Connection"{
            //searchActivityIndicator.startAnimating()
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            var strUrl = ""
            var parameters = [String: Any]()
            strUrl = strBaseURL + "productSearch"
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "str": searchBarProduct.text!,
                "page":"",
                "limit":"-1"
            ]
            
            print(parameters)
            
            self.mobileApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                //self.searchActivityIndicator.stopAnimating()

                Alert.HideProgressHud(Onview: self.view)
                //print(responseObject ?? [:])
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        if let arrSearchList = ((responseObject?["msg"])){
                            if arrSearchList is NSArray {
                                
                                self.arrSearchProduct.removeAll()
                                let arrFinalSearchList = arrSearchList as! NSArray
                                
                                for index in 0..<arrFinalSearchList.count{
                                    let dictOrderItem = arrFinalSearchList[index] as? [String : Any]
                                    let memberItem = SearchProduct(searchProductListDict: dictOrderItem!)
                                    self.arrSearchProduct.append(memberItem)
                                    
                                    //Sameer 2/6/2020
                                    Analytics.logEvent("view_search_results", parameters: ["search_term" : "\((self.arrSearchProduct[0].strproductBrandName ?? "") + " + " + (self.arrSearchProduct[0].strProductName ?? ""))"
                                    ])
                                    
                                }
                                
                                self.tableViewProduct.reloadData()
                                
                            }
                        }
                        
                    }
                    else{
                        Alert.showAlert(strMessage: responseObject?["msg"] as! NSString , Onview: self)
                    }
                    
                }
                else
                {
                    Alert.showAlertWithError(strMessage: "Seems Connection Found", Onview: self)
                    
                }
            })
            
        }
        else
        {
            Alert.showAlertWithError(strMessage: "No Connection Found", Onview: self)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
