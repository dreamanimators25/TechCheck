//
//  SecondDiagnosisQuestionVC.swift
//  InstaCash
//
//  Created by InstaCash on 26/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
class ModelButtonAccessoriesDiagnosis: NSObject {
    var isSelected = false
    
}
class SecondDiagnosisQuestionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var collectionViewSecond: UICollectionView!
    @IBOutlet weak var lblQuestionName: UILabel!
    var acceButtonState = [ModelButtonAccessoriesDiagnosis]()
    var resultJSON = JSON()
    var productName = ""

    var arrShowQuestionSecond = [NSDictionary]()
    var arrConditionValueData = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
//          collectionViewSecond.register(UINib(nibName: "DisplayAndTouchScreenCell", bundle: nil), forCellWithReuseIdentifier: "displayAndTouchScreenCell")
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
        btnNext.isHidden = false
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            btnNext.layer.cornerRadius = btnNext.frame.size.height/2
            btnNext.clipsToBounds = true
            btnNext.isHidden = false
            collectionViewSecond.register(UINib(nibName: "DisplayAndTouchScreenCell", bundle: nil), forCellWithReuseIdentifier: "displayAndTouchScreenCell")
        }
        else{
            btnNext.isHidden = true
            
            collectionViewSecond.register(UINib(nibName: "QuestionCardTypeCell", bundle: nil), forCellWithReuseIdentifier: "questionCardTypeCell")
        }
        
        
        let dict = arrShowQuestionSecond[1]
        lblQuestionName.text = dict.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let model = ModelButtonAccessoriesDiagnosis()
            model.isSelected = false
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueData.insert(dict!, at: obj)
            acceButtonState.insert(model, at: obj)
        }
        userDefaults.set("", forKey: "question_secondAnswer")
        userDefaults.set(lblQuestionName.text, forKey: "question_secondQuestion")
        userDefaults.set("", forKey: "question_secondQuestionCode")
  
        collectionViewSecond.reloadData()
        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Physical condition related quries"
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(SecondDiagnosisQuestionVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextPressed(_ sender: UIButton) {
        var strSaveAppcode = ""
        var strSaveAppAnswer = ""
        
        for obj in 0..<arrConditionValueData.count{
            let model = acceButtonState[obj]
            let dict = arrConditionValueData[obj] as? NSDictionary
            let strAppCode = dict?.value(forKey: "appCode") as? String
            let strAnswer = dict?.value(forKey: "value") as? String
            
            if model.isSelected{
                strSaveAppcode = strSaveAppcode + strAppCode! + ","
                strSaveAppAnswer = strSaveAppAnswer + strAnswer! + ","
            }
        }
        if !strSaveAppcode.isEmpty{
            userDefaults.set(strSaveAppAnswer, forKey: "question_secondAnswer")
            userDefaults.set(strSaveAppcode, forKey: "question_secondQuestionCode")
        }
        print(strSaveAppcode)
        let appConfig = AppConfig()
        let vc = ThirdDiagnosisQuestionVC()
        vc.resultJSON = self.resultJSON

        vc.arrShowQuestionThird = arrShowQuestionSecond
        appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
    }
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            return arrConditionValueData.count + 1
        }
        else{
            return arrConditionValueData.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {            
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayAndTouchScreenCell", for: indexPath) as! DisplayAndTouchScreenCell
            cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            if indexPath.row != arrConditionValueData.count {
                
                let dict = arrConditionValueData[indexPath.row] as? NSDictionary
                cell.lblTitle.text = dict?.value(forKey: "value") as? String
                let imgURL = URL(string:(dict?.value(forKey: "image") as? String)!)
                cell.imgLogo.sd_setImage(with: imgURL)
                let model = acceButtonState[indexPath.row]
                if model.isSelected{
                    cell.backgroundColor = navColor
                    cell.lblTitle.textColor = UIColor.white
                }
                else{
                    cell.backgroundColor = UIColor.white
                    cell.lblTitle.textColor = UIColor.black
                }
            }
            else{
                cell.imgLogo.image = UIImage(named: "None")
                cell.lblTitle.text = "None of the above"
                cell.backgroundColor = UIColor.white
                cell.lblTitle.textColor = UIColor.black
                
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCardTypeCell", for: indexPath) as! QuestionCardTypeCell
            cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            let dict = arrConditionValueData[indexPath.row] as? NSDictionary
            cell.lblTitle.text = dict?.value(forKey: "value") as? String
            
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            
            return CGSize(width: collectionView.frame.size.width/2 - 10, height:110)
        }
        else{
            return CGSize(width: collectionView.frame.size.width/2 - 20, height:50)
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = navColor
        if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            
            if indexPath.row != arrConditionValueData.count {
                let model = acceButtonState[indexPath.row]
                if model.isSelected{
                    model.isSelected = false
                }
                else{
                    model.isSelected = true
                    
                }
                collectionView.reloadData()
            }
            else{
                userDefaults.set("", forKey: "question_secondAnswer")
                userDefaults.set("", forKey: "question_secondQuestionCode")
                let appConfig = AppConfig()
                let vc = ThirdDiagnosisQuestionVC()
                vc.resultJSON = self.resultJSON

                vc.arrShowQuestionThird = arrShowQuestionSecond
                appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
            }
        }
        else{
            let dict = arrConditionValueData[indexPath.row] as? NSDictionary
            userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_secondAnswer")
            userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_secondQuestionCode")
            let appConfig = AppConfig()
            let vc = NineDiagnosticQuestionVC()
            vc.resultJSON = self.resultJSON
            vc.strGetProductName = self.title!
            vc.arrShowQuestionNine = arrShowQuestionSecond
            appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
    }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
