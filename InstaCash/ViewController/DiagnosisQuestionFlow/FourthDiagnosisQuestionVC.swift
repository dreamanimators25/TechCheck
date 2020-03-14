//
//  FourthDiagnosisQuestionVC.swift
//  InstaCash
//
//  Created by InstaCash on 26/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON

class FourthDiagnosisQuestionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblViewFourth: UITableView!
    @IBOutlet weak var lblName: UILabel!
    var arrConditionValueDataAOld = NSMutableArray()
    var arrShowQuestionFourth = [NSDictionary]()
    var resultJSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tblViewFourth.register(UINib(nibName: "DeviceOldVC", bundle: nil), forCellReuseIdentifier: "deviceOldVC")
        let dict = arrShowQuestionFourth[3]
        lblName.text = dict.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueDataAOld.insert(dict!, at: obj)
        }
        
        userDefaults.set("", forKey: "question_FourthAnswer")
        userDefaults.set(lblName.text, forKey: "question_FourthQuestion")
        userDefaults.set("", forKey: "question_FourthCode")
      
        tblViewFourth.reloadData()
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
        btnBack.addTarget(self, action: #selector(FourthDiagnosisQuestionVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Tableview delegate/Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrConditionValueDataAOld.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceOldVC", for: indexPath) as! DeviceOldVC
        let dict = arrConditionValueDataAOld[indexPath.row] as? NSDictionary
        cell.lbltitle.text = dict?.value(forKey: "value") as? String
        let imgURL = URL(string:(dict?.value(forKey: "image") as? String)!)
        cell.imgLogo.sd_setImage(with: imgURL)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = arrConditionValueDataAOld[indexPath.row] as? NSDictionary
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = navColor
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_FourthAnswer")
        userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_FourthCode")
        print(dict?.value(forKey: "appCode") as? String ?? "")
        let appConfig = AppConfig()
        let vc = FifthDiagnosisQuestionVC()
        vc.resultJSON = self.resultJSON
        vc.arrShowQuestionFifth = arrShowQuestionFourth
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
