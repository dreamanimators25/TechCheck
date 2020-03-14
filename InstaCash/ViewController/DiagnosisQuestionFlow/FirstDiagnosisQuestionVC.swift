//
//  FirstDiagnosisQuestionVC.swift
//  InstaCash
//
//  Created by InstaCash on 26/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
class FirstDiagnosisQuestionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewFirstquestion: UICollectionView!
    @IBOutlet weak var lblQuestionName: UILabel!
    @IBOutlet weak var viewTop: UIView!
    var arrSpecificationValueData = NSMutableArray()
    var resultJSON = JSON()
    var strproductName = ""
    var arrShowQuestion = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFirstquestion.register(UINib(nibName: "DisplayAndTouchScreenCell", bundle: nil), forCellWithReuseIdentifier: "displayAndTouchScreenCell")
        userDefaults.set("", forKey: "question_firstQuestion")
        userDefaults.set("", forKey: "question_firstAnswer")
        userDefaults.set("", forKey: "question_firstAnswerCode")
        setNavigationBar()
        fetchQuestionFromServer()
        // Do any additional setup after loading the view.
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "Physical condition related quries"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(QuriesVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
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
        let strUrl =  strBaseURL + "productModifiers"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "productId":CustomUserDefault.getProductId()
        ]
        print(parametersHome)
        self.questionFlowApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            
            print("\(String(describing: responseObject) ) , \(String(describing: error))")
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                  var count = -1
                    let arrData = responseObject?.value(forKeyPath: "msg.questions") as! NSArray
                    for index in 0..<arrData.count{
                        let dict = arrData[index] as? NSDictionary
                        if dict?.value(forKeyPath: "isInput") as! String == "1"{
                            count = count + 1
                            self.arrShowQuestion.insert(dict!, at: count)
                            
                        }
                        
                    }
                    let dict = self.arrShowQuestion[0]
                    self.lblQuestionName.text = dict.value(forKey: "specificationName") as? String
                    let arrSpecification = dict.value(forKey: "specificationValue") as! NSArray
                    for obj in 0..<arrSpecification.count{
                        let dict = arrSpecification[obj] as? NSDictionary
                        self.arrSpecificationValueData.insert(dict!, at: obj)
                    }
                    self.viewTop.isHidden = false
                    self.collectionViewFirstquestion.reloadData()
                    print(self.arrShowQuestion.count)
                    
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
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSpecificationValueData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let dict = arrSpecificationValueData[indexPath.row] as? NSDictionary
        cell.lblTitle.text = dict?.value(forKey: "value") as? String
        let imgURL = URL(string:(dict?.value(forKey: "image") as? String)!)
        cell.imgLogo.sd_setImage(with: imgURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 20, height:110)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = navColor
        let dict = arrSpecificationValueData[indexPath.row] as? NSDictionary
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_firstAnswer")
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as? String == "Pickup"{
            if self.resultJSON["Dead Pixels"].int == 1 && self.resultJSON["Screen"].int == 1{
                userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_firstAnswerCode")
            }
        }
        else{
            userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_firstAnswerCode")

        }
        userDefaults.set(self.lblQuestionName.text!, forKey: "question_firstQuestion")

        print(dict?.value(forKey: "appCode") as? String ?? "")
        let appConfig = AppConfig()
        let vc = SecondDiagnosisQuestionVC()
        vc.resultJSON = self.resultJSON
        vc.arrShowQuestionSecond = arrShowQuestion
        appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
        
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
