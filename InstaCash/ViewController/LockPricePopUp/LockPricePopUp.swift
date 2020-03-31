//
//  LockPricePopUp.swift
//  InstaCash
//
//  Created by InstaCash on 22/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

protocol UpdateUIForOrderDelegate {
    func updateUIAndPushToNextController()
}

class LockPricePopUp: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    
    var arrBrandDeviceGetData = [HomeModel]()
    var arrMyOderGetData = [HomeModel]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var arrPopularDeviceGetData = [HomeModel]()
    var arrBrandModelType = [HomeModel]()
    
    let reachability: Reachability? = Reachability()
    
    var delegate:UpdateUIForOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPrice.text = CustomUserDefault.getCurrency()
        didPullToRefresh()
        
    }
    
    func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection"{
            //Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode) in
                
                self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                
                if arrMyCurrentDeviceSend.count > 0 {
                    
                    let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                    self.imgPhone.sd_setImage(with: imgURL)
                    let strAmount  = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                    self.lblPrice.text = CustomUserDefault.getCurrency() + strAmount
                    
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .currency
                    // localize to your grouping and decimal separator
                    currencyFormatter.locale = Locale.current
                    
                    self.lblPrice.text = currencyFormatter.number(from:strAmount)?.stringValue
                }
            }
        }
    }

    @IBAction func btnOkayPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.updateUIAndPushToNextController()

    }
    
    @IBAction func onClickBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
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
