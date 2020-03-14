//
//  OldDEviceVC.swift
//  InstaCash
//
//  Created by InstaCash on 19/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class OldDEviceVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tblViewDevice: UITableView!
    @IBOutlet weak var lblQuestionName: UILabel!
    var strNavTitleGetOld  = ""
    var arrConditionGetOld = NSMutableArray()
    var arrConditionValueDataAOld  = NSMutableArray()
    var acceButtonOld  = [ModelButtonApplicable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tblViewDevice.register(UINib(nibName: "DeviceOldVC", bundle: nil), forCellReuseIdentifier: "deviceOldVC")
        let dict = arrConditionGetOld[3] as? NSDictionary
        lblQuestionName.text = dict?.value(forKey: "conditionSubHead") as? String
        let arrConditions = dict?.value(forKey: "conditionValue") as! NSArray
        for obj in 0..<arrConditions.count{
            let model = ModelButtonApplicable()
            model.isSelected = false
            let dict = arrConditions[obj] as? NSDictionary
            arrConditionValueDataAOld.insert(dict!, at: obj)
        }
        userDefaults.set("", forKey: "question_sixthAnswer")
        userDefaults.set(lblQuestionName.text, forKey: "question_sixthQuestion")
        userDefaults.set("", forKey: "question_sixthCode")
        tblViewDevice.reloadData()

        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = strNavTitleGetOld
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
        userDefaults.set(dict?.value(forKey: "value") as? String, forKey: "question_sixthAnswer")
        userDefaults.set(dict?.value(forKey: "appCode") as? String, forKey: "question_sixthCode")
            let appConfig = AppConfig()
            let vc = DeiviceBodyVC()
            vc.strNavTitleGetBody = self.title!
            vc.arrConditionGetBody = arrConditionGetOld
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
