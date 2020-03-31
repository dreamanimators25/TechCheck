//
//  SearchProductVC.swift
//  InstaCash
//
//  Created by InstaCash on 16/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import FacebookCore
import Firebase

class SearchProductVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var searchBarProduct: UISearchBar!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    let reachability: Reachability? = Reachability()
    var arrSearchData = [SearchProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
         collectionViewProduct.register(UINib(nibName: "SearchProductCell", bundle: nil), forCellWithReuseIdentifier: "searchProductCell")
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "InstaCash"
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(SearchProductVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellSearchProduct = collectionView.dequeueReusableCell(withReuseIdentifier: "searchProductCell", for: indexPath) as! SearchProductCell
        cellSearchProduct.lblProductName.text = arrSearchData[indexPath.row].strProductName
        cellSearchProduct.lblSmartPhone.text = arrSearchData[indexPath.row].strSmartPhone
        cellSearchProduct.lblProductBrand.text = arrSearchData[indexPath.row].strproductBrandName
        let imgURL = URL(string:arrSearchData[indexPath.row].strProductImage!)
        cellSearchProduct.imgProduct.sd_setImage(with: imgURL)
        return cellSearchProduct
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-5, height:220)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if  CustomUserDefault.getProductId() == arrSearchData[indexPath.row].strProductId{
//            let imei = UserDefaults.standard.string(forKey: "imei_number")
//            if (imei?.count == 15){
//                //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
//                //            vc.IMEINumber = imei!
//                //            self.present(vc, animated: true, completion: nil)
//                //            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
//                //            //            self.present(vc, animated: true, completion: nil)
//            }else{
//                // if arrMyCurrentDeviceSend.count > 0{
//                let vc = IMEIVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//                //                    }
//                //                    else{
//                //                        Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
//                //                    }
//            }
//        }
//        else{
        
            userDefaults.removeObject(forKey: "otherProductDeviceID")
            userDefaults.removeObject(forKey: "otherProductDeviceImage")
            userDefaults.setValue(arrSearchData[indexPath.row].strProductImage, forKey: "otherProductDeviceImage")
            userDefaults.setValue(arrSearchData[indexPath.row].strProductId!, forKey: "otherProductDeviceID")
//        userDefaults.set(arrSearchData[indexPath.row].strProductId!.formattedWithSeparator, forKey: "Product_UpToPrice")
            // if arrMyCurrentDeviceSend.count > 0{
            let vc = ProductConditionVC()
            vc.strProductIdGet = arrSearchData[indexPath.row].strProductId!
            self.navigationController?.pushViewController(vc, animated: true)
            //                }
            //                else{
            //                    Alert.showAlert(strMessage: "Device is not map,Please try later", Onview: self)
            //
            //                }
            
       // }
    }

    //MARK:- scrool view deleage
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarProduct.resignFirstResponder()
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
            if reachability?.connection.description != "No Connection"{
            SearchProduct.fetchProductSearchListFromServer(isInterNet: true, getController: self, getStrSearchString: searchBar.text!, completion: {(arrSearchData) in
                if arrSearchData.count > 0 {
                AppEventsLogger.log(searchBar.text!)
                    
                    Analytics.logEvent(AnalyticsEventSearch, parameters: [
                        AnalyticsParameterSearchTerm: searchBar.text!
                        ])
                self.arrSearchData.removeAll()
                self.arrSearchData = arrSearchData
                    self.collectionViewProduct.isHidden = false
                    self.lblMessage.isHidden = true

                    self.collectionViewProduct.reloadData()
                }
                else{
                    self.collectionViewProduct.isHidden = true
                    self.lblMessage.isHidden = false
                    self.lblMessage.text = "No Record Found"
                }
            })
            
            }
            else{
                
            }
        }
        else{
            self.collectionViewProduct.isHidden = true
            self.lblMessage.isHidden = false
            self.lblMessage.text = "Type at least three charachers to better search"

        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
           
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
