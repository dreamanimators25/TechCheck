//
//  MyOrderVC.swift
//  InstaCash
//
//  Created by InstaCash on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UpdateOrderListDelegate {
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnProgress: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    //@IBOutlet weak var lblMessages: UILabel!
    
    @IBOutlet weak var tblViewOrderLust: UITableView!
    var arrOrderList = [OrderListModel]()
    var arrOrderListCopy = [OrderListModel]() //s.
    var iscomingFromMyAccount = false
    let reachability: Reachability? = Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBar()
        tblViewOrderLust.register(UINib(nibName: "OrderHeaderCell", bundle: nil), forCellReuseIdentifier: "orderHeaderCell")
        tblViewOrderLust.register(UINib(nibName: "OrderListCollapsableCell", bundle: nil), forCellReuseIdentifier: "orderListCollapsableCell")
       
        if iscomingFromMyAccount {
            if arrOrderList.count > 0 {
                //lblMessages.isHidden = true
            }
            else{
                //lblMessages.isHidden = false
            }
        }
        else{
            if reachability?.connection.description != "No Connection" {
                OrderListModel.fetchOrderListFromServer(isInterNet:true,getController: self) { (arrOrderList) in
                    
                    if arrOrderList.count > 0 {
                        self.arrOrderList = arrOrderList
                        self.arrOrderListCopy = arrOrderList //s.
                        //self.lblMessages.isHidden = true
                        
                        self.tblViewOrderLust.reloadData()
                    }
                    else{
                        //self.lblMessages.isHidden = false
                    }
                }
            }
            else{
                Alert.showAlert(strMessage: "No Connection found", Onview: self)
            }
        }
    }
    
    //MARK:- custom delegate
    func updateOrderList(){
        if reachability?.connection.description != "No Connection"{
            self.arrOrderList.removeAll()
            OrderListModel.fetchOrderListFromServer(isInterNet:true,getController: self) { (arrOrderList) in
                if arrOrderList.count > 0{
                    self.arrOrderList = arrOrderList
                    self.arrOrderListCopy = arrOrderList //s.
                    //self.lblMessages.isHidden = true
                    
                    self.tblViewOrderLust.reloadData()
                }
                else{
                    //self.lblMessages.isHidden = false
                    
                }
                
            }
        }
        else{
            Alert.showAlert(strMessage: "No Connection found", Onview: self)
        }
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "My Order"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(MyOrderVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- button action methods
    
    @IBAction func onClickHome(_ sender: Any) {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = NotificationNew()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        //let vc = Profile()
        let vc = UserAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSideMenuPressed() -> Void {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    @IBAction func onClickAction(_ sender: Any) {
        let btn = sender as! UIButton
        
        if(btn == btnAll)
        {
            btnAll.setTitleColor(UIColor().gradientGreenFirstColor(), for: .normal)
            btnProgress.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnCompleted.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            lbl1.backgroundColor = UIColor().gradientGreenFirstColor()
            lbl2.backgroundColor = UIColor.white
            lbl3.backgroundColor = UIColor.white
            
            self.arrOrderList = self.arrOrderListCopy //s.
            self.tblViewOrderLust.reloadData() //s.
        }
        else if(btn == btnProgress)
        {
            btnProgress.setTitleColor(UIColor().gradientGreenFirstColor(), for: .normal)
            btnAll.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnCompleted.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            lbl2.backgroundColor = UIColor().gradientGreenFirstColor()
            lbl1.backgroundColor = UIColor.white
            lbl3.backgroundColor = UIColor.white
            
            //s.
            /*
            let arrProgress = self.arrOrderListCopy.filter{
                $0.strStatus == "Unverified" || $0.strStatus == "Verified" || $0.strStatus == "Out for pickup"
            }*/
            
            let arrProgress = self.arrOrderListCopy.filter { demo in
                return demo.strStatus == "Unverified" || demo.strStatus == "Verified" || demo.strStatus == "Out for pickup" || demo.strStatus == "Pending Payment"
            }
            
            self.arrOrderList = arrProgress
            self.tblViewOrderLust.reloadData()
            
        }
        else
        {
            btnCompleted.setTitleColor(UIColor().gradientGreenFirstColor(), for: .normal)
            btnAll.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnProgress.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            lbl3.backgroundColor = UIColor().gradientGreenFirstColor()
            lbl2.backgroundColor = UIColor.white
            lbl1.backgroundColor = UIColor.white
            
            //s.
            /*
            let arrComplete = self.arrOrderListCopy.filter{
                $0.strStatus == "Rejected" || $0.strStatus == "Complete" || $0.strStatus == "pacman Cancel"
            }*/
            
            let arrComplete = self.arrOrderListCopy.filter { demo in
                return demo.strStatus == "Completed" || demo.strStatus == "Rejected" || demo.strStatus == "Pacman cancelled" || demo.strStatus == "User cancelled"
            }
            
            self.arrOrderList = arrComplete
            self.tblViewOrderLust.reloadData()

        }
    }

    //MARK:- Tableview delegate/Source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOrderList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = arrOrderList[section]
        if model.isCollapsable == true {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if indexPath.row == 0{
            return 50
        }
        else{
            return  UITableViewAutomaticDimension
        }*/
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if indexPath.row == 0 {
        
        let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "orderHeaderCell", for: indexPath) as! OrderHeaderCell
        let modelOrder = arrOrderList[indexPath.section]
        
        let date =  CustomUserDefault.strinToDateConvertor(strGetDate:modelOrder.orderDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: " IST-5:00") //Current time zone
        //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        
        //let strFinalDate  = CustomUserDefault.dateToStringConvertor(strGetDate: date)
        
        cellOrderHeader.lblDate.text = "Order date: " + newDate
        //cellOrderHeader.lblOrderID.text = modelOrder.strRefrenceNumber
        
        let amount = Int(modelOrder.strProductAmount!)
        let strAmount = amount!.formattedWithSeparator
        cellOrderHeader.lblPrice.text = "Quoted price: " + CustomUserDefault.getCurrency() + strAmount
        
        // cellOrderHeader.lblPrice.text = CustomUserDefault.getCurrency() + modelOrder.strProductAmount!
        
        cellOrderHeader.lblVerified.text = modelOrder.strStatus
        //print(modelOrder.strStatus ?? "")
        
        switch modelOrder.strStatus {
        case "Unverified":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)
        case "Verified":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.5333333333, blue: 0.8980392157, alpha: 1)
        case "Out for pickup":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.6901960784, blue: 0.2392156863, alpha: 1)
        case "pending Payment":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case "Complete":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.368627451, blue: 0.1254901961, alpha: 1)
        case "Rejected":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.7176470588, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        case "Pacman cancelled":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
        case "User cancelled":
            cellOrderHeader.lblVerified.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
        default:
            print("no color")
        }
        
        
        cellOrderHeader.phoneName.text = modelOrder.strProductName
        cellOrderHeader.lblPaymentMode.text = "Payment Mode: " + (modelOrder.strPaymentName ?? "") //s.
        //cellOrderHeader.lblOrderID.text = "Order ID: " + (modelOrder.strOrderId ?? "") //s.
        cellOrderHeader.lblOrderID.text = "Order ID: " + (modelOrder.strRefrenceNumber ?? "") //s.
        let imgURL = URL(string:modelOrder.strProductImageURL!)
        cellOrderHeader.imgPhone.sd_setImage(with: imgURL)
        //let imgURLBank = URL(string:modelOrder.strPaymentImage!)
        //cellOrderHeader.imgBank.sd_setImage(with: imgURLBank)
        
        return cellOrderHeader
        
        /*}
         else{
         let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "orderListCollapsableCell", for: indexPath) as! OrderListCollapsableCell
         let modelOrder = arrOrderList[indexPath.row - 1]
         let data = Data(modelOrder.strSummay!.utf8)
         if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
         cellOrderHeader.lblAnswer.attributedText = attributedString
         }
         //cellOrderHeader.lblAnswer.text = modelOrder.strSummay?.htmlToString
         return cellOrderHeader
         }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = OrderDetail()
        let model = arrOrderList[indexPath.section]
        vc.orderDetail = model
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*if indexPath.row == 0 {
            let model = arrOrderList[indexPath.section]

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

        if  arrOrderList.count - 1 == indexPath.section{
            DispatchQueue.main.async {
                let indexPath = IndexPath(item:0, section: indexPath.section)
                self.tblViewOrderLust.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }*/
    
    }
    
    @objc func btnDocumentUpLoadPressed(sender:UIButton) {
        let model = self.arrOrderList[sender.tag]
        let vc = UploadDocumentVC()
        vc.delegate = self
        vc.strOrderItemId = model.strOrderItemId!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnBankDetailPressed(sender:UIButton) {
        let model = self.arrOrderList[sender.tag]
        let vc = BankDetailVC()
        vc.isComingFromOrderList = true
        vc.getIdFromOrderList = model.strOrderItemId!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnConvertToOrderPressed(sender:UIButton) {
        let alertController = UIAlertController(title: "Place Order!", message: "You are converting this Price Lock to a new Order.The price locked is subject to the conditions provided at the time of locking the price.In case of any mismatch in the conditions,a new price will be quoted. ", preferredStyle: .alert)
        
        let sendButton = UIAlertAction(title: "PLACE ORDER", style: .default, handler: { (action) -> Void in
            let model = self.arrOrderList[sender.tag]
            self.fireWebServiceForConvertToOrder(getModel: model)
        })
        
        let cancelButton = UIAlertAction(title: "MAYBE LATER", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(sendButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
    }

    //MARK:- web service methods
    
    func CovertApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForConvertToOrder(getModel:OrderListModel)
    {
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl =  strBaseURL + "priceLocktoNeworder"
            var parameters = [String: Any]()
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "orderItemId": getModel.strOrderItemId!
            ]
            self.CovertApiPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        getModel.isActivePricelock = false
                        self.tblViewOrderLust.reloadData()
                        Alert.showAlert(strMessage: "Place Order successfully", Onview: self)

                    }
                    else{
                        Alert.showAlert(strMessage:responseObject?["msg"] as! NSString , Onview: self)
                    }
                }
                else
                {
                    Alert.showAlert(strMessage: "Seemd Conection loss from server", Onview: self)
                }
            })
            
        }
        else {
            Alert.showAlert(strMessage: "No connection found", Onview: self)
        }
        
    }

}
