//
//  OtherDeviceQuestionFlow.swift
//  TechCheck
//
//  Created by TechCheck on 06/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
import  Firebase

class OtherDeviceQuestionFlow: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblViewOtherDeviceQuestions: UITableView!
    
    let reachability: Reachability? = Reachability()
    var arrQuestionForOtherDevices = [PickUpQuestionModel]()
    var resultJSON = JSON()
    var strNavTitle = ""
    var strGetProductID = ""
    var selectedId = String() //s.
    var selectedName = String() //s.
    var selectedImageUrl = String() //s.
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.btnSubmit.setTitle("Get Quote".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.isHidden = true
        setNavigationBar()
        
        /*
        //Register tableview cell
        Analytics.logEvent("start_diagnosis_test", parameters: [
            "event_category":"start diagnosis",
            "event_action":"start diagnosis with screen test",
            "event_label":"screen test" 
            ])*/
        
        userDefaults.removeObject(forKey: "otherProductDeviceID")
        userDefaults.setValue(strGetProductID, forKey: "otherProductDeviceID")
        tblViewOtherDeviceQuestions.register(UINib(nibName: "QuestionPickUpCell", bundle: nil), forCellReuseIdentifier: "questionPickUpCell")
        self.tblViewOtherDeviceQuestions.rowHeight = UITableViewAutomaticDimension
        self.tblViewOtherDeviceQuestions.estimatedRowHeight = 170
        self.fetchOtherDeviceQuestionFromServer()
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = strNavTitle
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(OtherDeviceQuestionFlow.btnBackPressed), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func btnBackPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuestionForOtherDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionPickUpCell", for: indexPath) as! QuestionPickUpCell
        cell.collectionViewQuestionValues.delegate = self
        cell.collectionViewQuestionValues.dataSource = self
        cell.collectionViewQuestionValues.tag = indexPath.row
        cell.collectionViewQuestionValues.reloadData()
        cell.lblQuestion.text = arrQuestionForOtherDevices[indexPath.row].strQuestionName //.localized(lang: langCode)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        if(arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 2 )
        {
            if arrQuestionForOtherDevices[indexPath.row].strQuestionName.count > 32 {
                return 190
            }else {
                return 170
            }
            
            //return 170
        }
        else
        {
            if arrQuestionForOtherDevices[indexPath.row].strQuestionName.count > 32 {
                return CGFloat(90 + (arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count * 50))
            }else {
                return CGFloat(70 + (arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count * 50))
            }
            
            //return CGFloat(70 + (arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count * 50))
        }
        
        /*if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 2 {
            return 170.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 2 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 4 {
            return 270.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count == 3  {
            return 220.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count == 4  {
            return 270.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count == 5  {
            return 320.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count == 6  {
            return 370.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 6 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 8 {
            return 550.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 8 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 10 {
            return 650.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 10 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count < 12 {
            return 870.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count == 12  {
            return 750.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 12 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 14 {
            return 1020.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 14 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 16 {
            return 1140.0
        }
        else if arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count > 16 && arrQuestionForOtherDevices[indexPath.row].arrQuestionTypes.count <= 18 {
            return 1260.0
        }
        else{
            return 1380.0
        }*/
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- collectionview delegates methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickUpQuestionCollectionViewCell", for: indexPath as IndexPath) as! PickUpQuestionCollectionViewCell
        //cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        
        DispatchQueue.main.async {
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.7
        }
        
        if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage.isEmpty {
            cell.imgValues.image = UIImage(named: "phonePlaceHolder")
        }
        else{
            let imgURL = URL(string:arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage)
            cell.imgValues.sd_setImage(with: imgURL)
        }
        
        cell.lblValues.text  = arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue //.localized(lang: langCode)
        
        if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
            cell.viewMain.backgroundColor = navColor
            cell.lblValues.textColor = UIColor.white
            
            cell.circleImageView.image = #imageLiteral(resourceName: "Selected")
        }
        else{
            //cell.viewMain.backgroundColor = UIColor.init(red: 218.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            cell.viewMain.backgroundColor = UIColor.clear
            cell.lblValues.textColor = UIColor.black
            
            cell.circleImageView.image = #imageLiteral(resourceName: "circle")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 5, height:40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (arrQuestionForOtherDevices[collectionView.tag].strViewType == "checkbox") &&  (arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes.count > 2 ) {
            if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
                arrQuestionForOtherDevices[collectionView.tag].strAnswerName = ""
                
            }
            else{
                if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue == "None Of These".localized(lang: langCode) {
                    for k in 0..<arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes.count{
                        arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[k].isSelected = false
                    }
                    arrQuestionForOtherDevices[collectionView.tag].strAnswerName = "None Of These".localized(lang: langCode)
                }
                else{
                    for k in 0..<arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes.count{
                        if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[k].strQuestionValue == "None Of These".localized(lang: langCode) {
                            if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[k].isSelected == true{
                                arrQuestionForOtherDevices[collectionView.tag].strAnswerName = ""
                                
                            }
                            arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[k].isSelected = false
                        }
                    }
                    arrQuestionForOtherDevices[collectionView.tag].strAnswerName =                  arrQuestionForOtherDevices[collectionView.tag].strAnswerName + "," + arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue
                }
                arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true
            }
            
            //  collectionView.reloadItems(at: [indexPath])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                collectionView.reloadData()
            }
            //collectionView.reloadData() // sam
            
            //            if arrQuestionForPickUp.count != collectionView.tag + 1{
            //                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
            //                self.tblViewPickUpQuestion.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            //            }
        }
        else{
            if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
                arrQuestionForOtherDevices[collectionView.tag].strAnswerName = ""
            }
            else{
                for index in 0..<arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes.count{
                    if arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[index].isSelected == true{
                        arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                    else{
                        arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                }
                arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true
                arrQuestionForOtherDevices[collectionView.tag].strAnswerName = arrQuestionForOtherDevices[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue
                
            }
            if arrQuestionForOtherDevices.count == collectionView.tag + 1 || arrQuestionForOtherDevices.count == collectionView.tag + 2 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    collectionView.reloadData()
                }
                //collectionView.reloadData() //sam
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    collectionView.reloadItems(at: [indexPath])
                }
                //collectionView.reloadItems(at: [indexPath]) //sam
            }
            
            if arrQuestionForOtherDevices.count != collectionView.tag + 1{
                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
                self.tblViewOtherDeviceQuestions.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
    }
    
    //MARK:- button submit method
    
    @IBAction func onClickBack(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        var strSaveAppcode = ""
        //var arrAppCode = [String]()
        var arrSelectedCountWithIndex = [Int]()
        var count = -1
        
        for obj in 0..<arrQuestionForOtherDevices.count {
            for index in 0..<arrQuestionForOtherDevices[obj].arrQuestionTypes.count{
                if arrQuestionForOtherDevices[obj].arrQuestionTypes[index].isSelected == true{
                    count = count + 1
                    //                    arrAppCode.insert(arrQuestionForPickUp[obj].arrQuestionTypes[index].strQuestionValueAppCodde, at: index)
                    strSaveAppcode = strSaveAppcode + arrQuestionForOtherDevices[obj].arrQuestionTypes[index].strQuestionValueAppCodde + ";"
                    arrSelectedCountWithIndex.insert(obj, at: count)
                    
                }
                else{
                }
                
            }
        }
        
        let unique = Array(Set(arrSelectedCountWithIndex))
        if unique.count == arrQuestionForOtherDevices.count{
            //Done
            var strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;;", with: ";")
            strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;", with: ";")
            strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;", with: ";")
            //let vc = ProductDetailDynamicVC()
            let vc = ProductDetailVewVC()
            userDefaults.set(self.title, forKey: "productName")
            vc.isComingFromOnPhoneDiagnostic = false
            
            //Sameer 2/6/2020
            userDefaults.saveQuotationMode(Mode: "false")
            
            vc.strGetFinalAppCodeValues = strFinalCodeValues
            vc.arrQuestionAndAnswerShow = arrQuestionForOtherDevices
            
            vc.deviceId = selectedId //s.
            vc.deviceName = selectedName //s.
            vc.deviceImageUrl = selectedImageUrl //s.
            
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else{
            Alert.showAlert(strMessage: "Select All values".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    //MARK:- web service methods
    func otherQuestionFlowApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fetchOtherDeviceQuestionFromServer() {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            //"https://getinstacash.com.my/instaCash/api/v5/public/"
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl =  strBaseURL + "productModifiers"
            let parametersHome : [String : Any] = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "productId": strGetProductID
            ]
            
            print(parametersHome)
            
            self.otherQuestionFlowApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print(responseObject ?? [])
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success"{
                        let dictQuestion = responseObject?["msg"] as! NSDictionary
                        self.title = dictQuestion.value(forKey: "name") as? String
                        
                        self.selectedId = dictQuestion.value(forKey: "id") as? String ?? ""
                        self.selectedName = dictQuestion.value(forKey: "name") as? String ?? ""
                        self.selectedImageUrl = dictQuestion.value(forKey: "image") as? String ?? ""

                        let arrData = responseObject?.value(forKeyPath: "msg.questions") as! NSArray
                        
                        for index in 0..<arrData.count{
                            let dict = arrData[index] as? NSDictionary
                            // self.arrShowQuestion.insert(dict!, at: count)
                            let modelQuestion = PickUpQuestionModel()
                            var arrQuestionValue = [PickUpQuestionTypesModel]()
                            modelQuestion.strViewType = dict?.value(forKey: "viewType") as! String
                            modelQuestion.strAppViewType = dict?.value(forKey: "appViewType") as! String
                            
                            // put questionvalue here
                            var  arrQuestionValues = NSArray()
                            if dict?.value(forKey: "type") as! String == "specification"{
                                arrQuestionValues = dict?.value(forKey: "specificationValue") as! NSArray
                                modelQuestion.strQuestionName = dict?.value(forKey: "specificationName") as! String
                            }
                            else{
                                arrQuestionValues = dict?.value(forKey: "conditionValue") as! NSArray
                                modelQuestion.strQuestionName = dict?.value(forKey: "conditionSubHead") as! String
                            }
                            
                            if arrQuestionValues.count > 0{
                                for obj in 0..<arrQuestionValues.count{
                                    let dictValue = arrQuestionValues[obj] as! NSDictionary
                                    let modelQuestionVal = PickUpQuestionTypesModel()
                                    modelQuestionVal.strQuestionValue = dictValue.value(forKey: "value") as! String
                                    modelQuestionVal.strQuestionValueImage = dictValue.value(forKey: "image") as! String
                                    modelQuestionVal.strQuestionValueAppCodde = dictValue.value(forKey: "appCode") as! String
                                    modelQuestionVal.isSelected = false
                                    arrQuestionValue.insert(modelQuestionVal, at: obj)
                                }
                            }
                            
                            modelQuestion.arrQuestionTypes = arrQuestionValue
                            self.arrQuestionForOtherDevices.insert(modelQuestion, at: index)
                            
                        }
                        
                        if self.arrQuestionForOtherDevices.count > 0 {
                            self.btnSubmit.isHidden = false
                            for i in 0..<self.arrQuestionForOtherDevices.count{
                                if self.arrQuestionForOtherDevices[i].strViewType == "checkbox" {
                                    let modelQuestionAddValueFromOurSide = PickUpQuestionTypesModel()
                                    if self.arrQuestionForOtherDevices[i].arrQuestionTypes.count == 1{
                                        //add not aplicable
                                        modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                        modelQuestionAddValueFromOurSide.strQuestionValue = "Not Applicable"
                                        modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                        modelQuestionAddValueFromOurSide.isSelected = false
                                        self.arrQuestionForOtherDevices[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)
                                        
                                    }
                                    else if self.arrQuestionForOtherDevices[i].arrQuestionTypes.count > 1{
                                        //add none of these
                                        modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                        modelQuestionAddValueFromOurSide.strQuestionValue = "None Of These".localized(lang: langCode)
                                        modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                        modelQuestionAddValueFromOurSide.isSelected = false
                                        self.arrQuestionForOtherDevices[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)
                                    }
                                    else{
                                        
                                    }
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                self.tblViewOtherDeviceQuestions.reloadData()
                            })
                            //self.tblViewOtherDeviceQuestions.reloadData()
                            
                        }
                        
                    }
                    else{
                        // failed
                        Alert.showAlertWithError(strMessage: responseObject?["msg"] as! String as NSString, Onview: self)
                    }
                    
                }
                else{
                    
                }
                
            })
        }
        else{
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    
}
