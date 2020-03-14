//
//  FingerPrintVC.swift
//  InstaCash
//
//  Created by InstaCash on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class FingerPrintVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewFinger: UICollectionView!
    @IBOutlet weak var lblQuestionName: UILabel!
    var strNavTitleGetDevicefingerPrint = ""
    var arrConditionDevicefingerPrint = NSMutableArray()
    var arrConditionValueDatafingerPrint = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        collectionViewFinger.register(UINib(nibName: "QuestionCardTypeCell", bundle: nil), forCellWithReuseIdentifier: "questionCardTypeCell")
        let dict = arrConditionDevicefingerPrint[11] as? NSDictionary
        lblQuestionName.text = dict?.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict?.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueDatafingerPrint.insert(dict!, at: obj)
        }
        userDefaults.set("", forKey: "question_FourtheenAnswer")
        userDefaults.set(lblQuestionName.text, forKey: "question_FourtheenQuestion")
        userDefaults.set("", forKey: "question_FourtheenCode")
        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = strNavTitleGetDevicefingerPrint
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(FingerPrintVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrConditionValueDatafingerPrint.count
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
        let dict = arrConditionValueDatafingerPrint[indexPath.row] as? NSDictionary
        cell.lblTitle.text = dict?.value(forKey: "value") as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 10, height:50)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = navColor
        let dict = arrConditionValueDatafingerPrint[indexPath.row] as? NSDictionary
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_FourtheenAnswer")
        userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_FourtheenCode")
        let appConfig = AppConfig()
        let vc = PhoneLockVC()
        vc.strNavTitleGetDevicePhoneLock = self.title!
        vc.arrConditionDevicePhoneLock = arrConditionDevicefingerPrint
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
