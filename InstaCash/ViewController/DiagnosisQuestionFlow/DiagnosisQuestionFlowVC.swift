//
//  DiagnosisQuestionFlowVC.swift
//  InstaCash
//
//  Created by InstaCash on 05/12/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON

class DiagnosisQuestionFlowVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblViewDiagnosisQuestion: UITableView!
    
    var arrQuestionForQuestion = [PickUpQuestionModel]()
    var resultJSON = JSON()
    let reachability: Reachability? = Reachability()
    var selectedId = String() //s.
    var selectedName = String() //s.
    var selectedImageUrl = String() //s.
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.btnSubmit.setTitle("SUBMIT".localized(lang: langCode), for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.isHidden = true
        //setNavigationBar() //s.
        //Register tableview cell
        tblViewDiagnosisQuestion.register(UINib(nibName: "QuestionPickUpCell", bundle: nil), forCellReuseIdentifier: "questionPickUpCell")
        self.tblViewDiagnosisQuestion.rowHeight = UITableViewAutomaticDimension
        self.tblViewDiagnosisQuestion.estimatedRowHeight = 170
        self.fetchQuestionFromServer()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false //s.
        
    }

    // MARK:- navigation bar setup.
    
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Physical condition related quries".localized(lang: langCode)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white] //s.
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(DiagnosisQuestionFlowVC.btnBackPressed), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func btnBackPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- web service methods
    
    func questionFlowApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fetchQuestionFromServer() {
        if reachability?.connection.description != "No Connection"{
        Alert.ShowProgressHud(Onview: self.view)
        //"https://getinstacash.com.my/instaCash/api/v5/public/"
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl =  strBaseURL + "productModifiers"
        
            let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "productId": CustomUserDefault.getProductId()
        ]
            
        print(parametersHome)
            
        self.questionFlowApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            
            Alert.HideProgressHud(Onview: self.view)
            print(responseObject ?? [:])
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    var count = -1
                    self.btnSubmit.isHidden = false
                    
                    //s.
                    let dictQuestion = responseObject?["msg"] as! NSDictionary
                    
                    self.selectedId = dictQuestion.value(forKey: "id") as? String ?? ""
                    self.selectedName = dictQuestion.value(forKey: "name") as? String ?? ""
                    self.selectedImageUrl = dictQuestion.value(forKey: "image") as? String ?? ""
                    //s.
                    
                    let arrData = responseObject?.value(forKeyPath: "msg.questions") as! NSArray
                    for index in 0..<arrData.count{
                        let dict = arrData[index] as? NSDictionary
                        if dict?.value(forKeyPath: "isInput") as! String == "1"{
                            count = count + 1
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
                            self.arrQuestionForQuestion.insert(modelQuestion, at: count)
                        }
                        
                    }
                    if self.arrQuestionForQuestion.count > 0{
                        for i in 0..<self.arrQuestionForQuestion.count{
                            if self.arrQuestionForQuestion[i].strViewType == "checkbox"{
                                let modelQuestionAddValueFromOurSide = PickUpQuestionTypesModel()
                                if self.arrQuestionForQuestion[i].arrQuestionTypes.count == 1{
                                    //add not aplicable
                                    modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                    modelQuestionAddValueFromOurSide.strQuestionValue = "Not Applicable"
                                    modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                    modelQuestionAddValueFromOurSide.isSelected = false
                                    self.arrQuestionForQuestion[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)
                                    
                                }
                                else if self.arrQuestionForQuestion[i].arrQuestionTypes.count > 1{
                                    //add none of these
                                    modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                    modelQuestionAddValueFromOurSide.strQuestionValue = "None Of These"
                                    modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                    modelQuestionAddValueFromOurSide.isSelected = false
                                    self.arrQuestionForQuestion[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)
                                }
                                else{
                                    
                                }
                            }
                        }
                        self.tblViewDiagnosisQuestion.reloadData()
                        
                    }
                 
                }
                else{
                    // failed
                    Alert.showAlert(strMessage: responseObject?["msg"] as! String as NSString, Onview: self)
                }
                
            }
            else{
                
            }
            
        })
    }
    else{
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
    }
        
    }

    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuestionForQuestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionPickUpCell", for: indexPath) as! QuestionPickUpCell
        cell.collectionViewQuestionValues.delegate = self
        cell.collectionViewQuestionValues.dataSource = self
        cell.collectionViewQuestionValues.tag = indexPath.row
        cell.collectionViewQuestionValues.reloadData()
        cell.lblQuestion.text = arrQuestionForQuestion[indexPath.row].strQuestionName.localized(lang: langCode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 2 )
        {
            return 170
        }
        else
        {
            return CGFloat(70 + (arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count * 50))
        }
        
        /*if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 2 {
            return 180.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 2 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 4 {
            return 270.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count == 3  {
            return 220.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 4 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 6 {
            return 400.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 6 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 8 {
            return 550.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 8 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 10 {
            return 650.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 10 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count < 12 {
            return 870.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count == 12  {
            return 810.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 12 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 14 {
            return 1020.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 14 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 16 {
            return 1140.0
        }
        else if arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count > 16 && arrQuestionForQuestion[indexPath.row].arrQuestionTypes.count <= 18 {
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
        return arrQuestionForQuestion[collectionView.tag].arrQuestionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickUpQuestionCollectionViewCell", for: indexPath as IndexPath) as! PickUpQuestionCollectionViewCell
        //cell.layer.cornerRadius = 5.0 //s.
        cell.layer.borderWidth = 0.5 //s.
        cell.layer.borderColor = UIColor.gray.cgColor //s.
        cell.clipsToBounds = true
        
        if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage.isEmpty{
            cell.imgValues.image = UIImage(named: "phonePlaceHolder")
        }
        else{
            let imgURL = URL(string:arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage)
            cell.imgValues.sd_setImage(with: imgURL)
        }
        
        cell.lblValues.text  = arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue.localized(lang: langCode)
        
        if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
            cell.viewMain.backgroundColor = navColor
            cell.lblValues.textColor = UIColor.white
            cell.circleImageView.isHidden = true //s.
        }
        else{
            //cell.viewMain.backgroundColor = UIColor.init(red: 218.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0) //s.
            cell.viewMain.backgroundColor = UIColor.white //s.
            cell.lblValues.textColor = UIColor.black
            cell.circleImageView.isHidden = false //s.
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 5, height:40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (arrQuestionForQuestion[collectionView.tag].strViewType == "checkbox") &&  (arrQuestionForQuestion[collectionView.tag].arrQuestionTypes.count > 2 ) {
            
            if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
                arrQuestionForQuestion[collectionView.tag].strAnswerName = ""

            }
            else{
                if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue == "None Of These"{
                    for k in 0..<arrQuestionForQuestion[collectionView.tag].arrQuestionTypes.count{
                        arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[k].isSelected = false
                    }
                    arrQuestionForQuestion[collectionView.tag].strAnswerName = "None Of These"
                }
                else{
                    for k in 0..<arrQuestionForQuestion[collectionView.tag].arrQuestionTypes.count{
                        if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[k].strQuestionValue == "None Of These"{
                            if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[k].isSelected == true{
                                arrQuestionForQuestion[collectionView.tag].strAnswerName = ""

                            }
                            arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[k].isSelected = false
                            
                        }
                    }
                     arrQuestionForQuestion[collectionView.tag].strAnswerName =                  arrQuestionForQuestion[collectionView.tag].strAnswerName + "," + arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue
                }
                arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true
            }
            //  collectionView.reloadItems(at: [indexPath])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                collectionView.reloadData()
            }
            //collectionView.reloadData()
            //            if arrQuestionForPickUp.count != collectionView.tag + 1{
            //                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
            //                self.tblViewPickUpQuestion.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            //            }
        }
        else{
            if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
                arrQuestionForQuestion[collectionView.tag].strAnswerName = ""
            }
            else{
                for index in 0..<arrQuestionForQuestion[collectionView.tag].arrQuestionTypes.count{
                    if arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[index].isSelected == true{
                        arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                    else{
                        arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                }
                arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true
                arrQuestionForQuestion[collectionView.tag].strAnswerName = arrQuestionForQuestion[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue

            }
            if arrQuestionForQuestion.count == collectionView.tag + 1 || arrQuestionForQuestion.count == collectionView.tag + 2
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    collectionView.reloadData()
                }
                //collectionView.reloadData()
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    collectionView.reloadItems(at: [indexPath])
                }
                //collectionView.reloadItems(at: [indexPath])
            }
            if arrQuestionForQuestion.count != collectionView.tag + 1{
                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
                self.tblViewDiagnosisQuestion.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
        
    }
    
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        var strSaveAppcode = ""
        //var arrAppCode = [String]()
        var arrSelectedCountWithIndex = [Int]()
        var count = -1
        
        for obj in 0..<arrQuestionForQuestion.count {
            for index in 0..<arrQuestionForQuestion[obj].arrQuestionTypes.count{
                if arrQuestionForQuestion[obj].arrQuestionTypes[index].isSelected == true{
                    count = count + 1
                    //                    arrAppCode.insert(arrQuestionForPickUp[obj].arrQuestionTypes[index].strQuestionValueAppCodde, at: index)
                    strSaveAppcode = strSaveAppcode + arrQuestionForQuestion[obj].arrQuestionTypes[index].strQuestionValueAppCodde + ";"
                    arrSelectedCountWithIndex.insert(obj, at: count)
                    
                }else {
                    print("")
                }
            }
        }
        
        let unique = Array(Set(arrSelectedCountWithIndex))
        
        if unique.count == arrQuestionForQuestion.count {
            
            //Done
            var strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;;", with: ";")
            strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;", with: ";")
            strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;", with: ";")
            let arrQuestionAnswerTemp = NSMutableArray()
            for index in 0..<arrQuestionForQuestion.count{
            let arrQuestionTypeTemp = NSMutableArray()
                
            let model  = arrQuestionForQuestion[index]
                let dict = NSMutableDictionary()
                dict.setValue(model.strQuestionName, forKey: "questionName")
                dict.setValue(model.strAppViewType, forKey: "appViewType")
                dict.setValue(model.strViewType, forKey: "viewType")
                dict.setValue(model.strAnswerName, forKey: "answerName")
                
            for obj in 0..<model.arrQuestionTypes.count {
                    let modelQuestionName = model.arrQuestionTypes[obj]
                    let dictQuestion = NSMutableDictionary()
                    dictQuestion.setValue(modelQuestionName.strQuestionValue, forKey: "questionValue")
                    dictQuestion.setValue(modelQuestionName.strQuestionValueImage, forKey: "questionValueImage")
                    dictQuestion.setValue(modelQuestionName.strQuestionValueAppCodde, forKey: "questionValueAppCode")
                    dictQuestion.setValue(modelQuestionName.isSelected, forKey: "isSelected")
                    arrQuestionTypeTemp.insert(dictQuestion, at: obj)
            }
            
                dict.setValue(arrQuestionTypeTemp, forKey: "arrayQuestion")
                arrQuestionAnswerTemp.insert(dict, at: index)

            }
            userDefaults.removeObject(forKey: "Diagnosis_DataSave_forConfirmOrder")
            userDefaults.setValue(self.resultJSON.rawString(), forKey: "Diagnosis_DataSave_forConfirmOrder")
            userDefaults.setValue(strFinalCodeValues, forKey: "Diagnosis_AppCode_forConfirmOrder")
            userDefaults.removeObject(forKey: "Diagnosis_AnserAndQuestionData_forConfirmOrder")
            let myData = NSKeyedArchiver.archivedData(withRootObject: arrQuestionAnswerTemp)
            userDefaults.set(myData, forKey: "Diagnosis_AnserAndQuestionData_forConfirmOrder")
            
           // let vc = ProductDetailDynamicVC()
            let vc = ProductDetailVewVC()
            vc.getReturnJson = self.resultJSON
            vc.strGetFinalAppCodeValues = strFinalCodeValues
            vc.isComingFromOnPhoneDiagnostic = true
            vc.arrQuestionAndAnswerShow = arrQuestionForQuestion
            
            vc.deviceId = selectedId //s.
            vc.deviceName = selectedName //s.
            vc.deviceImageUrl = selectedImageUrl //s.
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            Alert.showAlert(strMessage: "Select All values".localized(lang: langCode) as NSString, Onview: self)
        }
    }
}
