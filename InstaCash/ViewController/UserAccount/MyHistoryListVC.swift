//
//  MyHistoryListVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyHistoryListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var historyListTableView: UITableView!
    @IBOutlet weak var lblMyHistory: UILabel!
    
    let reachability: Reachability? = Reachability()
    var arrHistoryList = [HistoryModel]()
    
    func changeLanguageOfUI() {
        
        self.lblMyHistory.text = "My History".localized(lang: langCode)
        
        //self.searchBarProduct.placeholder = "Search for your Device...".localized(lang: langCode)
        //self.btnSeeOrderStatus.setTitle("SEE ORDER STATUS".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.changeLanguageOfUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        historyListTableView.register(UINib(nibName: "HistoryListTblCell", bundle: nil), forCellReuseIdentifier: "HistoryListTblCell")
        
        historyListTableView.register(UINib(nibName: "HistoryCollabsableCell", bundle: nil), forCellReuseIdentifier: "historyCollabsableCell")
        
        if reachability?.connection.description != "No Connection" {
            HistoryModel.fetchHistoryListFromServer(isInterNet:true,getController: self) { (arrHistoryList) in
                
                if arrHistoryList.count > 0 {
                    self.arrHistoryList = arrHistoryList
                    
                    self.historyListTableView.reloadData()
                }
                else{
                    Alert.showAlertWithError(strMessage:"No Data Found!".localized(lang: langCode) as NSString , Onview: self)
                }
            }
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    //MARK: IBActions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableView Datasource & Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = arrHistoryList[section]
        if model.isCollapsable == true {
            return 2
        }else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let historyListCell = tableView.dequeueReusableCell(withIdentifier: "HistoryListTblCell", for: indexPath) as! HistoryListTblCell
            
            let modelOrder = arrHistoryList[indexPath.section]
            
            if let imgURL = URL(string:modelOrder.strOrderImageURL ?? "") {
                historyListCell.imgViewPhone.sd_setImage(with: imgURL)
            }
            
            historyListCell.lblPhoneName.text = modelOrder.strOrderName
            historyListCell.lblDate.text = modelOrder.orderDate
            historyListCell.lblSeeDetail.text = "See Detail".localized(lang: langCode)
            
            let amount = Int(modelOrder.strOrderAmount!)
            let strAmount = amount!.formattedWithSeparator
            historyListCell.lblPhonePrice.text = CustomUserDefault.getCurrency() + " \(strAmount)"
            
            return historyListCell
            
        }
        else{
            let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "historyCollabsableCell", for: indexPath) as! HistoryCollabsableCell
            
            let modelOrder = arrHistoryList[indexPath.section]
            
            //let data = Data(modelOrder.strSumaryHistory!.utf8)
            
            //if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                //cellOrderHeader.lblTitle.attributedText = attributedString
            //}
            
            let data = Data(modelOrder.strSumaryHistory!.utf8)
            
            let options = [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                ] as [NSAttributedString.DocumentReadingOptionKey : Any]
            
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                cellOrderHeader.lblTitle.attributedText = attributedString
            }
            
            //cellOrderHeader.lblAnswer.text = modelOrder.strSumary?.htmlToString
            return cellOrderHeader
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let model = arrHistoryList[indexPath.section]
            
            if model.isCollapsable == true{
                model.isCollapsable = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
            else {
                model.isCollapsable = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
        
        if  arrHistoryList.count - 1 == indexPath.section {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item:0, section: indexPath.section)
                self.historyListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
