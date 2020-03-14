//
//  DeiceSwitchOnVC.swift
//  InstaCash
//
//  Created by InstaCash on 19/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import  Firebase
class DeiceSwitchOnVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var colectionViewDevice: UICollectionView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblQuestionType: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    var getProductID = ""
    let reachability: Reachability? = Reachability()
    var arrSpecification = NSMutableArray()
    var arrCondition = NSMutableArray()
    var arrSpecificationValueData = NSMutableArray()
    var countSpecification = -1
    var countContition = -1
    var strNavTitle = ""
    var selected = -1


    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("start_diagnosis_test", parameters: [
            "event_category":"start diagnosis",
            "event_action":"start diagnosis with screen test",
            "event_label":"screen test"
            ])
        
        setNavigationBar()
        userDefaults.removeObject(forKey: "otherProductDeviceID")
        userDefaults.setValue(getProductID, forKey: "otherProductDeviceID")
        userDefaults.set("", forKey: "question_firstQuestion")
        userDefaults.set("", forKey: "question_firstAnswer")
        userDefaults.set("", forKey: "question_firstAnswerCode")
         colectionViewDevice.register(UINib(nibName: "QuestionCardTypeCell", bundle: nil), forCellWithReuseIdentifier: "questionCardTypeCell")
        if reachability?.connection.description != "No Connection"{
           fetchQuestionFromServer()
        }
        else{
            self.lblMessage.isHidden = false
            self.lblMessage.text = "No Connection found"
            self.imgLogo.isHidden = false
        }

        // Do any additional setup after loading the view.
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(DeiceSwitchOnVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSpecificationValueData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let dict = arrSpecificationValueData[indexPath.row] as? NSDictionary
        cell.lblTitle.text = dict?.value(forKey: "value") as? String
        if selected == indexPath.row{
            cell.backgroundColor = navColor
            cell.lblTitle.textColor = UIColor.white
        }
        else{
            cell.backgroundColor = UIColor.white
            cell.lblTitle.textColor = UIColor.black
        }
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 20, height:50)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = navColor
        let dict = arrSpecificationValueData[indexPath.row] as? NSDictionary
        userDefaults.set(lblQuestionType.text, forKey: "question_firstQuestion")
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_firstAnswer")
        userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_firstAnswerCode")

        let appConfig = AppConfig()
        let vc = DisplayAndTouchScreenVC()
        vc.strNavTitleGet = self.title!
        vc.arrConditionGet = arrCondition
        vc.arrSpecificationGet = arrSpecification
        appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- web service methods
    
      func questionFlowApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
     func fetchQuestionFromServer() {
        Alert.ShowProgressHud(Onview: self.view)
        //"https://getinstacash.com.my/instaCash/api/v5/public/"
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "productModifiers"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "productId":getProductID
        ]
        print(parametersHome)
        self.questionFlowApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            
            print("\(String(describing: responseObject) ) , \(String(describing: error))")
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    let dictQuestion = responseObject?["msg"] as! NSDictionary
                    self.viewTop.isHidden = false
                    self.title = dictQuestion.value(forKey: "name") as? String
                    let arrQuestion = dictQuestion.value(forKey: "questions") as! NSArray
                    for index in 0..<arrQuestion.count {
                        let dictSpecification = arrQuestion[index] as! NSDictionary
                        if (dictSpecification.value(forKey: "type") as! String).contains("specification"){
                            self.countSpecification = self.countSpecification + 1
                            self.arrSpecification.insert(dictSpecification, at: self.countSpecification)
                        }
                        
                    }
                    let dictSpecificationFinal = self.arrSpecification[0] as! NSDictionary
                        self.lblQuestionType.text = dictSpecificationFinal.value(forKey: "specificationName") as? String
                        let arrSpecificationValue = dictSpecificationFinal.value(forKey: "specificationValue") as! NSArray
                        for obj in 0..<arrSpecificationValue.count{
                            let dictSpecificationValue = arrSpecificationValue[obj] as? NSDictionary
                            self.arrSpecificationValueData.insert(dictSpecificationValue!, at: obj)
                        }
                    
                    
                    self.colectionViewDevice.reloadData()
                    for obj in 0..<arrQuestion.count {
                        let dictSpecification = arrQuestion[obj] as! NSDictionary
                        if (dictSpecification.value(forKey: "type") as! String).contains("condition"){
                            print(dictSpecification)
                            self.countContition = self.countContition + 1
                            self.arrCondition.insert(dictSpecification, at: self.countContition)
                        }
                        
                    }
                    print(self.arrCondition)
                    print(self.arrSpecification)

                }
                else{
                    // failed
                
                }
                
            }
            else{
                
            }
            
        })
        
        
    }

}
