//
//  HistoryVC.swift
//  InstaCash
//
//  Created by InstaCash on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblViewHistory: UITableView!

    let reachability: Reachability? = Reachability()
    var arrHistoryList = [HistoryModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblMessage.text = "No History Found".localized(lang: langCode)
        
        //self.btnAll.setTitle("ALL".localized(lang: langCode), for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        tblViewHistory.register(UINib(nibName: "OrderHeaderCell", bundle: nil), forCellReuseIdentifier: "orderHeaderCell")
        tblViewHistory.register(UINib(nibName: "HistoryCollabsableCell", bundle: nil), forCellReuseIdentifier: "historyCollabsableCell")
       
        if reachability?.connection.description != "No Connection"{
            HistoryModel.fetchHistoryListFromServer(isInterNet:true,getController: self) { (arrHistoryList) in
                if arrHistoryList.count > 0{
                    self.arrHistoryList = arrHistoryList
                    self.lblMessage.isHidden = true
                    
                    self.tblViewHistory.reloadData()
                }
                else{
                    self.lblMessage.isHidden = false
                    
                }
                
            }
        }
        else{
            Alert.showAlert(strMessage: "No Connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "History".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(HistoryVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    //MARK:- Tableview delegate/Source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = arrHistoryList[section]
        if model.isCollapsable == true {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
        }
        else{
            return  UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "orderHeaderCell", for: indexPath) as! OrderHeaderCell
            let modelOrder = arrHistoryList[indexPath.section]
            
            if modelOrder.isCollapsable == true{
                cellOrderHeader.downArrow.image = UIImage(named: "upArrow")
            }
            else{
                cellOrderHeader.downArrow.image = UIImage(named: "downArrow")
            }
            
            cellOrderHeader.lblDate.text = modelOrder.orderDate
            let amount = Int(modelOrder.strOrderAmount!)

            let strAmount = amount!.formattedWithSeparator
            cellOrderHeader.lblPrice.text = CustomUserDefault.getCurrency() + strAmount
            
           // cellOrderHeader.lblPrice.text = CustomUserDefault.getCurrency() + modelOrder.strOrderAmount!
            cellOrderHeader.phoneName.text = modelOrder.strOrderName
            let imgURL = URL(string:modelOrder.strOrderImageURL!)
            cellOrderHeader.imgPhone.sd_setImage(with: imgURL)
            return cellOrderHeader
        }
        else{
            let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "historyCollabsableCell", for: indexPath) as! HistoryCollabsableCell
            let modelOrder = arrHistoryList[indexPath.section]
            let data = Data(modelOrder.strSumaryHistory!.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                cellOrderHeader.lblTitle.attributedText = attributedString
            }
            //cellOrderHeader.lblAnswer.text = modelOrder.strSumary?.htmlToString
            return cellOrderHeader
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            let model = arrHistoryList[indexPath.section]
            
            if model.isCollapsable == true{
                model.isCollapsable = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
            else{
                model.isCollapsable = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
        
        if  arrHistoryList.count - 1 == indexPath.section{
            DispatchQueue.main.async {
                let indexPath = IndexPath(item:0, section: indexPath.section)
                self.tblViewHistory.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
