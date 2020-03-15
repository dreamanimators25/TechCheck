//
//  PickUpQuestionVC.swift
//  InstaCash
//
//  Created by InstaCash on 30/11/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON

class PickUpQuestionVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var tblViewPickUpQuestion: UITableView!
    var arrQuestionForPickUp = [PickUpQuestionModel]()
    var resultJSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        //Register tableview cell
        tblViewPickUpQuestion.register(UINib(nibName: "QuestionPickUpCell", bundle: nil), forCellReuseIdentifier: "questionPickUpCell")
        self.tblViewPickUpQuestion.rowHeight = UITableViewAutomaticDimension
        self.tblViewPickUpQuestion.estimatedRowHeight = 170
        
        if (userDefaults.value(forKeyPath: "PickUpQuestions") != nil) {
            
            let recovedUserJsonData = UserDefaults.standard.object(forKey: "PickUpQuestions")
            let arrQuestion = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data) as! NSArray
            
            if arrQuestion.count > 0 {
                for index in 0..<arrQuestion.count{
                    let modelQuestion = PickUpQuestionModel()
                    var arrQuestionValue = [PickUpQuestionTypesModel]()
                    let dict = arrQuestion[index] as! NSDictionary
                    modelQuestion.strViewType = dict.value(forKey: "viewType") as! String
                    modelQuestion.strAppViewType = dict.value(forKey: "appViewType") as! String
                    
                    // put questionvalue here
                    var  arrQuestionValues = NSArray()
                    if dict.value(forKey: "type") as! String == "specification"{
                        arrQuestionValues = dict.value(forKey: "specificationValue") as! NSArray
                        modelQuestion.strQuestionName = dict.value(forKey: "specificationName") as! String
                    }
                    else{
                        arrQuestionValues = dict.value(forKey: "conditionValue") as! NSArray
                        modelQuestion.strQuestionName = dict.value(forKey: "conditionSubHead") as! String
                    }
                    
                    if arrQuestionValues.count > 0 {
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
                    arrQuestionForPickUp.insert(modelQuestion, at: index)
                }
                
                if arrQuestionForPickUp.count > 0 {
                    for i in 0..<arrQuestionForPickUp.count{
                        if arrQuestionForPickUp[i].strViewType == "checkbox"{
                            let modelQuestionAddValueFromOurSide = PickUpQuestionTypesModel()
                            if arrQuestionForPickUp[i].arrQuestionTypes.count == 1{
                                //add not aplicable
                                modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                modelQuestionAddValueFromOurSide.strQuestionValue = "Not Applicable"
                                modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                modelQuestionAddValueFromOurSide.isSelected = false
                                arrQuestionForPickUp[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)

                            }
                            else if arrQuestionForPickUp[i].arrQuestionTypes.count > 1{
                              //add none of these
                                modelQuestionAddValueFromOurSide.strQuestionValueAppCodde = ""
                                modelQuestionAddValueFromOurSide.strQuestionValue = "None Of These"
                                modelQuestionAddValueFromOurSide.strQuestionValueImage = ""
                                modelQuestionAddValueFromOurSide.isSelected = false
                                arrQuestionForPickUp[i].arrQuestionTypes.append(modelQuestionAddValueFromOurSide)
                            }
                            else{
                                
                            }
                        }
                    }
                    tblViewPickUpQuestion.reloadData()
                    
                }
            }
            
        }
        else{
            
        }
        
        
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
        btnBack.addTarget(self, action: #selector(PickUpQuestionVC.btnBackPressed), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func btnBackPressed() -> Void {
       obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
    }
    
    //MARK:- tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuestionForPickUp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionPickUpCell", for: indexPath) as! QuestionPickUpCell
        cell.collectionViewQuestionValues.delegate = self
        cell.collectionViewQuestionValues.dataSource = self
        cell.collectionViewQuestionValues.tag = indexPath.row
        cell.collectionViewQuestionValues.reloadData()
        cell.lblQuestion.text = arrQuestionForPickUp[indexPath.row].strQuestionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 2 {
            return 250.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 2 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 4 {
            return 350.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 4 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 6 {
            return 450.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 6 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 8 {
            return 550.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 8 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 10 {
            return 650.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 10 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 12 {
            return 750.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 12 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 14 {
            return 850.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 14 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 16 {
            return 950.0
        }
        else if arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count > 16 && arrQuestionForPickUp[indexPath.row].arrQuestionTypes.count <= 18 {
            return 1050.0
        }
        else{
            return 1150.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- collectionview delegates methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrQuestionForPickUp[collectionView.tag].arrQuestionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickUpQuestionCollectionViewCell", for: indexPath as IndexPath) as! PickUpQuestionCollectionViewCell
        cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        
        if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage.isEmpty{
            cell.imgValues.image = UIImage(named: "phonePlaceHolder")
        }
        else{
            let imgURL = URL(string:arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValueImage)
            cell.imgValues.sd_setImage(with: imgURL)
        }
        
        cell.lblValues.text  = arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue
        if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
            cell.viewMain.backgroundColor = navColor
            cell.lblValues.textColor = UIColor.white
        }
        else{
            cell.viewMain.backgroundColor = UIColor.init(red: 218.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            cell.lblValues.textColor = UIColor.black
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 5, height:120)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (arrQuestionForPickUp[collectionView.tag].strViewType == "checkbox") &&  (arrQuestionForPickUp[collectionView.tag].arrQuestionTypes.count > 2 ) {
            if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
            }
            else{
                if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].strQuestionValue == "None Of These"{
                for k in 0..<arrQuestionForPickUp[collectionView.tag].arrQuestionTypes.count{
                    arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[k].isSelected = false
                }
            }
                else{
                    for k in 0..<arrQuestionForPickUp[collectionView.tag].arrQuestionTypes.count{
                        if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[k].strQuestionValue == "None Of These"{
                            arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[k].isSelected = false

                        }
                    }
                }
                arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true

            }
          //  collectionView.reloadItems(at: [indexPath])
            collectionView.reloadData()
            //            if arrQuestionForPickUp.count != collectionView.tag + 1{
            //                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
            //                self.tblViewPickUpQuestion.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            //            }
        }
        else{
            if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected == true{
                arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = false
            }
            else{
                for index in 0..<arrQuestionForPickUp[collectionView.tag].arrQuestionTypes.count{
                    if arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[index].isSelected == true{
                        arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                    else{
                        arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[index].isSelected = false
                    }
                }
                arrQuestionForPickUp[collectionView.tag].arrQuestionTypes[indexPath.row].isSelected = true
            }
            if arrQuestionForPickUp.count == collectionView.tag + 1{
                collectionView.reloadData()
            }
            else{
                collectionView.reloadItems(at: [indexPath])
            }
            if arrQuestionForPickUp.count != collectionView.tag + 1{
                let indexPath = NSIndexPath(row: collectionView.tag + 1, section: 0)
                self.tblViewPickUpQuestion.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
        
    }
    
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        
        var strSaveAppcode = ""
        //var arrAppCode = [String]()
        var arrSelectedCountWithIndex = [Int]()
        
        for obj in 0..<arrQuestionForPickUp.count {
            for index in 0..<arrQuestionForPickUp[obj].arrQuestionTypes.count {
                if arrQuestionForPickUp[obj].arrQuestionTypes[index].isSelected == true {
                //                    arrAppCode.insert(arrQuestionForPickUp[obj].arrQuestionTypes[index].strQuestionValueAppCodde, at: index)
                    strSaveAppcode = strSaveAppcode + arrQuestionForPickUp[obj].arrQuestionTypes[index].strQuestionValueAppCodde + ";"
                    arrSelectedCountWithIndex.insert(obj, at: obj)
                    
                }
                else{
                }
                
            }
        }
        
        let unique = Array(Set(arrSelectedCountWithIndex))
        if unique.count == arrQuestionForPickUp.count{
            //Done
            var strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;;", with: ";")
             strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;;", with: ";")
             strFinalCodeValues = strSaveAppcode.replacingOccurrences(of: ";;", with: ";")            
            
            let vc = MisMatchVC()
            vc.resultJSONGet = self.resultJSON
            vc.strAppCodes = strFinalCodeValues
            self.present(vc, animated: true, completion: nil)
        }
        else{
            Alert.showAlert(strMessage: "Select All values", Onview: self)
        }
        
    }
    
}
