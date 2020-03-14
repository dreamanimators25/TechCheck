//
//  OrderDetailSummaryVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 10/01/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class OrderDetailSummaryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    
    var summaryString = ""
    var arrKey = [String]()
    var arrValue = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryTableView.register(UINib(nibName: "ProductSummaryTblViewCell", bundle: nil), forCellReuseIdentifier: "ProductSummaryTblViewCell")
        
        
        let arrSummaryString : [String?] = summaryStr.components(separatedBy: ";")
        
        for item in arrSummaryString {
            
            if item != "" {
                let arrStr1 : [String?] = item?.components(separatedBy: "->") ?? [""]
                
                if arrStr1.count > 1 {
                    self.arrKey.append(arrStr1[0] ?? "")
                    self.arrValue.append(arrStr1[1] ?? "")
                }
                
            }
        }
        
        self.summaryTableView.contentSize = CGSize(width: self.summaryTableView.frame.width, height: ((CGFloat(self.arrKey.count)) * 50))
        self.ViewHeight.constant = (CGFloat(self.arrKey.count) * 50) + 40
        self.summaryTableView.reloadData()

    }
    
    @IBAction func onClickDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- tableview Delegates methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTestResult = tableView.dequeueReusableCell(withIdentifier: "ProductSummaryTblViewCell", for: indexPath) as! ProductSummaryTblViewCell
        cellTestResult.lblQuateName.text = arrKey[indexPath.row]
        cellTestResult.lblQuateValue.text = arrValue[indexPath.row]
        
        return cellTestResult
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
