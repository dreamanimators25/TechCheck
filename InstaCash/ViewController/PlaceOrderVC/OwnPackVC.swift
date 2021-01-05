//
//  OwnPackVC.swift
//  InstaCash
//
//  Created by sameer khan on 23/12/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class OwnPackVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var arrOption = ["Print your own pack","Either print your own pack using our free shipping label via Royal Mail, or request a repaid sales pack",]
    var arrOption1 = ["Option 1","Tracked Returns Up to ¢100 Cover","Post at your nearest post office and obtain a proof of posting receipt. The receipt will include a 15 character reference which can be used to track your parcel on www.royalmail.com","Estimated time of delivery 1-3 Working days","Cost FREE (Postage is prepaid by us)","Royal Mail loss or damage cover Up to 100","Maximum no. of phones per parcel Up to 2"]
    var arrOption2 = ["Option 2","Special Delivery Up to ¢250 Cover","Post at your nearest post office via Special Delivery and obtain a reference which can be used to proof of posting receipt. The receipt will include a 13 character track your parcel on www.royalmail.com","Estimated time of delivery 1 Working day","Cost Approx. 7.20","Royal Mail loss or damage cover Up to 250","Maximum no. of phones per parcel Up to 5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.register(UINib(nibName: "OwnPackTVCell", bundle: nil), forCellReuseIdentifier: "OwnPackTVCell")
        self.detailTableView.register(UINib(nibName: "SeperatorTVCell", bundle: nil), forCellReuseIdentifier: "SeperatorTVCell")
        
        DispatchQueue.main.async {
            self.backButton.layer.cornerRadius = 5.0
        }
    }

    //MARK: IBActions
    @IBAction func onClickBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITableView DataSource & Delegates
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOption.count + arrOption1.count + arrOption2.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let OwnPackTVCell = tableView.dequeueReusableCell(withIdentifier: "OwnPackTVCell", for: indexPath) as! OwnPackTVCell
        let SeperatorTVCell = tableView.dequeueReusableCell(withIdentifier: "SeperatorTVCell", for: indexPath) as! SeperatorTVCell
        
        switch indexPath.row {
        case 0:
            OwnPackTVCell.lblText.text = arrOption[indexPath.row]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .left
        case 1:
            OwnPackTVCell.lblText.text = arrOption[indexPath.row]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .left
        case 2,10:
            return SeperatorTVCell
        case 3:
            OwnPackTVCell.lblText.text = arrOption1[indexPath.row - 3]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .center
        case 4,5,6,7,8,9:
            OwnPackTVCell.lblText.text = arrOption1[indexPath.row - 3]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .center
        case 11:
            OwnPackTVCell.lblText.text = arrOption2[indexPath.row - 11]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .center
        default:
            OwnPackTVCell.lblText.text = arrOption2[indexPath.row - 11]
            OwnPackTVCell.lblText.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            OwnPackTVCell.lblText.textAlignment = .center
        }        
        
        return OwnPackTVCell
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
