//
//  MyAddresses.swift
//  InstaCash
//
//  Created by InstaCash on 28/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class MyAddresses: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblViewAddresses: UITableView!
    var arrAddress = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        getAddress()
        tblViewAddresses.estimatedRowHeight = 80
        tblViewAddresses.rowHeight = UITableViewAutomaticDimension
        tblViewAddresses.register(UINib(nibName: "MyAddressesCell", bundle: nil), forCellReuseIdentifier: "myAddressesCell")

        
        // Do any additional setup after loading the view.
    }
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "My Addresses"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(MyAddresses.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        
    self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tableview delegate/Source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cellOrderHeader = tableView.dequeueReusableCell(withIdentifier: "myAddressesCell", for: indexPath) as! MyAddressesCell
            let dict = arrAddress[indexPath.row]
            cellOrderHeader.lblAddress.text = dict.value(forKey: "address")  as? String
            cellOrderHeader.lblLandMark.text = dict.value(forKey: "landmark")  as? String
            cellOrderHeader.lblPincode.text = dict.value(forKey: "pincode")  as? String

        
            return cellOrderHeader
        
    }
    
    //MARK:- web service methods
    
    func apiAddress(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    func getAddress() {
        
        Alert.ShowProgressHud(Onview: self.view)
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getAddress"
        var customerID = ""
        if CustomUserDefault.isUserIdExit(){
            customerID = CustomUserDefault.getUserId()
        }
        else{
            customerID = "-1"
        }
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "customerId":customerID
       
        ]
        self.apiAddress(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    let arrPaymentTypeData = responseObject?["msg"] as! NSArray
                    for index in 0..<arrPaymentTypeData.count{
                        let dict = arrPaymentTypeData[index] as? NSDictionary
                        self.arrAddress.insert(dict!, at: index)
                    }
                    if self.arrAddress.count > 0{
                        self.lblMessage.isHidden = true
                    }
                    else{
                        self.lblMessage.isHidden = false

                    }
                    self.tblViewAddresses.reloadData()
                    
                }
                else{
                    // failed
                    //Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    self.lblMessage.isHidden = false

                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server", Onview: self)
            }
            
        })
        
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
