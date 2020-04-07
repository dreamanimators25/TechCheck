//
//  OrderDetail.swift
//  InstaCash
//
//  Created by CULT OF PERSONALITY on 05/11/19.
//  Copyright © 2019 Prakhar Gupta. All rights reserved.
//

import UIKit

var summaryStr = ""

class OrderDetail: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var imgPhone: UIImageView?
    @IBOutlet weak var lblPrice: UILabel?
    @IBOutlet weak var lblColor: UILabel?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblAddress: UILabel?
    @IBOutlet weak var lblPhoneName: UILabel?
    
    @IBOutlet weak var img1: UIImageView?
    @IBOutlet weak var img2: UIImageView?
    @IBOutlet weak var img3: UIImageView?
    
    @IBOutlet weak var lblDate1: UILabel?
    @IBOutlet weak var lblDate2: UILabel?
    @IBOutlet weak var lblDate3: UILabel?
    
    @IBOutlet weak var orderFinalStatusView: UIView?
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint?
    
    @IBOutlet weak var lblOrderPlaced: UILabel?
    @IBOutlet weak var lblInProgress: UILabel?
    @IBOutlet weak var lblOrderFinalStatus: UILabel?
    @IBOutlet weak var btnDeviceInfo: UIButton?
    @IBOutlet weak var btnCustomerSupprt: UIButton?

    
    let reachability: Reachability? = Reachability()
    var orderDetail = OrderListModel.init(orderListDict: [String : Any](), strOrderIdGet: "", strRefrenceNumber: "", strOrderDate: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lblPrice.text = "Quoted price:  \(CustomUserDefault.getCurrency())"
        
        let imgURL = URL.init(string: orderDetail.strProductImageURL ?? "")
        self.imgPhone?.sd_setImage(with: imgURL)
        self.lblPhoneName?.text = orderDetail.strProductName
        let txt = "Quoted price:".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) "
        let price = Int(orderDetail.strProductAmount ?? "")?.formattedWithSeparator
        self.lblPrice?.text = txt + (price ?? "")
        self.lblName?.text = orderDetail.strPaymentName
        
        let date =  CustomUserDefault.strinToDateConvertor(strGetDate:(orderDetail.orderDate ?? ""))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: " IST-5:00") //Current time zone
        //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date)
        
        self.lblDate1?.text = "Pick up: ".localized(lang: langCode) + newDate
        self.lblDate2?.text = "Pick up schedule for ".localized(lang: langCode) + newDate
        self.lblDate3?.text = "Cashed out".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) \(Int(orderDetail.strProductAmount ?? "")?.formattedWithSeparator ?? "")" + " on ".localized(lang: langCode) + newDate
        
        DispatchQueue.main.async {
            self.btnDeviceInfo?.layer.cornerRadius = 5.0
            //self.btnCustomerSupprt?.layer.cornerRadius = (self.btnCustomerSupprt?.frame.size.height ?? 2)/2
            self.orderFinalStatusView?.isHidden = true
            self.stackViewHeight?.constant = 140
        }
        
        self.fireWebServiceForOrderDetail()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblOrderPlaced?.text = "Order placed".localized(lang: langCode)
        self.lblInProgress?.text = "In Progress".localized(lang: langCode)
        self.lblOrderFinalStatus?.text = "Order placed".localized(lang: langCode)
        
        self.btnDeviceInfo?.setTitle("   Device Information   ".localized(lang: langCode), for: UIControlState.normal)
        self.btnCustomerSupprt?.setTitle("Contact Customer Support".localized(lang: langCode), for: UIControlState.normal)
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCustomSupport(_ sender: Any) {
        let vc = CustomerSupportVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickDeviceInfo(_ sender: Any) {
        
        let vc = OrderDetailSummaryVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //MARK:- web service methods
    
    func CovertApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForOrderDetail()
    {
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl =  strBaseURL + "orderStatus"
            var parameters = [String: Any]()
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "orderNumber": orderDetail.strRefrenceNumber ?? ""
            ]
            
            print(parameters)
            
            self.CovertApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        let dictDetail = responseObject?["msg"] as! NSArray
                        let itemDetail = dictDetail[0] as? NSDictionary
                        //let itemDetail = dictDetail.lastObject as? NSDictionary
                        let item = itemDetail?.value(forKey: "itemDetails") as? NSArray
                        //let finalItem = item?[0] as? NSDictionary
                        let finalItem = item?.lastObject as? NSDictionary
                        
                        
                        if let imagURL = URL.init(string: finalItem?.value(forKey: "productImage") as? String ?? "") {
                            self.imgPhone?.sd_setImage(with: imagURL)
                        }
                        
                        self.lblPhoneName?.text = finalItem?.value(forKey: "productName") as? String ?? ""
                        
                        let txt = "Quoted price:".localized(lang: langCode) + " \(CustomUserDefault.getCurrency()) "
                        
                        if let amount = Int(finalItem?.value(forKey: "amount") as? String ?? "") {
                            let price = amount.formattedWithSeparator
                            self.lblPrice?.text = txt + (price)
                        }
                        
                        //let price = Int(finalItem?.value(forKey: "amount") as? String ?? "")?.formattedWithSeparator
                        //self.lblPrice?.text = txt + (price ?? "0")
                        
                        let str = "\(itemDetail?.value(forKey: "customerName") as? String ?? "") \n\(itemDetail?.value(forKey: "mobile") as? String ?? "")"
                        self.lblName?.text = str
                        
                        self.lblAddress?.text = "\(itemDetail?.value(forKey: "address") as? String ?? "") \(itemDetail?.value(forKey: "city") as? String ?? "")"
                                                
                        let orderCurrentStatus = finalItem?.value(forKey: "status") as? String ?? ""
                        print(orderCurrentStatus)
                        
                        /*
                        case "Complete":
                        case "Rejected":
                        case "Pacman cancelled":
                        case "pending Payment":
                         
                        case "Unverified":
                        case "Verified":
                        case "Out for pickup":
                        case "User cancelled":
                        */
                        
                        if orderCurrentStatus == "Completed" || orderCurrentStatus == "Rejected" || orderCurrentStatus == "Pacman cancelled" || orderCurrentStatus == "Pending Payment" {
                            self.orderFinalStatusView?.isHidden = false
                            self.stackViewHeight?.constant = 210
                            self.lblOrderFinalStatus?.text = orderCurrentStatus.localized(lang: langCode)
                            self.img2?.image = #imageLiteral(resourceName: "smallRight")
                        }else {
                            let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                            rotation.toValue = Double.pi * 2
                            rotation.duration = 5.25 // or however long you want ...
                            rotation.isCumulative = true
                            rotation.repeatCount = Float.greatestFiniteMagnitude
                            self.img2?.layer.add(rotation, forKey: "rotationAnimation")
                        }
                        
                        summaryStr = (finalItem?.value(forKey: "summaryText") as? String ?? "")
                        
                    }
                    else{
                        Alert.showAlert(strMessage: "Ooops Something went wrong.".localized(lang: langCode) as NSString, Onview: self)
                    }
                }
                else
                {
                    Alert.showAlert(strMessage: "Seemd Conection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }
        else {
            Alert.showAlert(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    
    
}
