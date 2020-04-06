//
//  Notification.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 05/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

class NotificationNew: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblViewNotifcation: UITableView!
    @IBOutlet weak var lblNotification: UILabel!
    
    var arrNotification = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewNotifcation.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notification")
        
    }
    
    func changeLanguageOfUI() {
        
        self.lblNotification.text = "Notifications".localized(lang: langCode)
        
        //self.btnProceed.setTitle("PROCEED".localized(lang: langCode), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeLanguageOfUI()
    }
    
    //MARK:- Tableview delegate/Source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "notification", for: indexPath) as! NotificationCell
        
        return cellHeader
    }
    
    @IBAction func onClickHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickOrdres(_ sender: Any) {
        let vc = MyOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        //let vc = Profile()
        let vc = UserAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
