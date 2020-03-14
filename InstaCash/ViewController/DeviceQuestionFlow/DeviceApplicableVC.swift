//
//  DeviceApplicableVC.swift
//  InstaCash
//
//  Created by InstaCash on 19/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
class ModelButtonApplicable: NSObject {
    var isSelected = false
    
}
class DeviceApplicableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblViewApllicable: UITableView!
    @IBOutlet weak var lblQuestionName: UILabel!
    var strNavTitleGetAplicable  = ""
    var arrConditionGetAplicable = NSMutableArray()
    var arrConditionValueDataAplicable  = NSMutableArray()
    var acceButtonAplicable  = [ModelButtonApplicable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
        tblViewApllicable.register(UINib(nibName: "FunctionalQuestionCell", bundle: nil), forCellReuseIdentifier: "functionalQuestionCell")
        let dict = arrConditionGetAplicable[2] as? NSDictionary
        lblQuestionName.text = dict?.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict?.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let model = ModelButtonApplicable()
            model.isSelected = false
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueDataAplicable.insert(dict!, at: obj)
            acceButtonAplicable.insert(model, at: obj)
        }
        userDefaults.set("", forKey: "question_FifthAnswer")
        userDefaults.set(lblQuestionName.text, forKey: "question_FifthQuestion")
        userDefaults.set("", forKey: "question_FifthCode")
        tblViewApllicable.reloadData()
        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = strNavTitleGetAplicable
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(DeviceApplicableVC.btnBackPressed), for: .touchUpInside)
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
        
        for obj in 0..<arrConditionValueDataAplicable.count{
            let model = acceButtonAplicable[obj]
            let dict = arrConditionValueDataAplicable[obj] as? NSDictionary
            let strAppCode = dict?.value(forKey: "appCode") as? String
            let strAnswer = dict?.value(forKey: "value") as? String
            
            if model.isSelected{
                strSaveAppcode = strSaveAppcode + strAppCode! + ","
                strSaveAppAnswer = strSaveAppAnswer + strAnswer! + ","
            }
        }
        if !strSaveAppcode.isEmpty{
            userDefaults.set(strSaveAppAnswer, forKey: "question_FifthAnswer")
            userDefaults.set(strSaveAppcode, forKey: "question_FifthCode")
        }
        let appConfig = AppConfig()
        let vc = OldDEviceVC()
        vc.strNavTitleGetOld = self.title!
        vc.arrConditionGetOld = arrConditionGetAplicable
        appConfig.pushControllerWithAnimationEffect(getController: self, PushWhichController: vc)
    }
    //MARK:- Tableview delegate/Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrConditionValueDataAplicable.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "functionalQuestionCell", for: indexPath) as! FunctionalQuestionCell
        if indexPath.row != arrConditionValueDataAplicable.count {
            
            let dict = arrConditionValueDataAplicable[indexPath.row] as? NSDictionary
            cell.lbltitle.text = dict?.value(forKey: "value") as? String
            
            let model = acceButtonAplicable[indexPath.row]
            if model.isSelected{
                cell.viewBg.backgroundColor = navColor
                cell.lbltitle.textColor = UIColor.white
            }
            else{
                cell.viewBg.backgroundColor = UIColor.white
                cell.lbltitle.textColor = UIColor.black
            }
        }
        else{
            cell.lbltitle.text = "Not Applicable"
            cell.viewBg.backgroundColor = UIColor.white
            cell.lbltitle.textColor = UIColor.black
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != arrConditionValueDataAplicable.count {
            let model = acceButtonAplicable[indexPath.row]
            if model.isSelected{
                model.isSelected = false
            }
            else{
                model.isSelected = true
                
            }
            tableView.reloadData()
        }
        else{
            userDefaults.set("", forKey: "question_FifthAnswer")
            userDefaults.set("", forKey: "question_FifthCode")
            let appConfig = AppConfig()
            let vc = OldDEviceVC()
            vc.strNavTitleGetOld = self.title!
            vc.arrConditionGetOld = arrConditionGetAplicable
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
