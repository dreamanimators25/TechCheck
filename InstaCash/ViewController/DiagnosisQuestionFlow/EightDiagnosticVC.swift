//
//  EightDiagnosticVC.swift
//  InstaCash
//
//  Created by InstaCash on 26/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
class EightDiagnosticVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var resultJSON = JSON()

    @IBOutlet weak var collectionViewEight: UICollectionView!
    @IBOutlet weak var lblQuestionName: UILabel!
    var arrConditionValueDataHardWare = NSMutableArray()
    var arrShowQuestionEight = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        collectionViewEight.register(UINib(nibName: "DisplayAndTouchScreenCell", bundle: nil), forCellWithReuseIdentifier: "displayAndTouchScreenCell")
        let dict = arrShowQuestionEight[7]
        lblQuestionName.text = dict.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let model = ModelButtonApplicable()
            model.isSelected = false
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueDataHardWare.insert(dict!, at: obj)
        }
        userDefaults.set("", forKey: "question_eightAnswer")
        userDefaults.set(lblQuestionName.text, forKey: "question_eightQuestion")
        userDefaults.set("", forKey: "question_eightCode")
        collectionViewEight.reloadData()
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
        btnBack.addTarget(self, action: #selector(EightDiagnosticVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- collection view delegate / data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrConditionValueDataHardWare.count
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
        let dict = arrConditionValueDataHardWare[indexPath.row] as? NSDictionary
        cell.lblTitle.text = dict?.value(forKey: "value") as? String
        let imgURL = URL(string:(dict?.value(forKey: "image") as? String)!)
        cell.imgLogo.sd_setImage(with: imgURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 10, height:110)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = navColor
        let dict = arrConditionValueDataHardWare[indexPath.row] as? NSDictionary
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_eightAnswer")
        userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_eightCode")
        print(dict?.value(forKey: "appCode") as? String ?? "")
        userDefaults.setValue("STON01", forKey: "isDiagnosisForSTONValue")
        
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") == nil{
        let vc = ProductDetailVC()
        vc.returnJson = self.resultJSON
        vc.isComingFromOnPhoneDiagnostic = true
        self.navigationController?.pushViewController(vc, animated: true)
        }
    else{                                                                                                                                                                                                                                                                                                                                                                                            
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup"{
            let vc = MisMatchVC()
            vc.resultJSONGet = self.resultJSON
            self.present(vc, animated: true, completion: nil)
        }
        else{
        let vc = ProductDetailVC()
        vc.returnJson = self.resultJSON
        vc.isComingFromOnPhoneDiagnostic = true
        self.navigationController?.pushViewController(vc, animated: true)
        }
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
