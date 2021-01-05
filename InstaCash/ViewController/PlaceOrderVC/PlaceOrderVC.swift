//
//  PlaceOrderVC.swift
//  TechCheck
//
//  Created by TechCheck on 20/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FacebookCore
import DropDown

class PlaceOrderVC: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnPickUp: UIButton!
    @IBOutlet weak var btnDropOff: UIButton!
    @IBOutlet weak var btnPostIt: UIButton!
  
    @IBOutlet weak var allBtnView: UIView!
    @IBOutlet weak var UIView1: UIView!
    @IBOutlet weak var UIView2: UIView!
    @IBOutlet weak var UIView3: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var dropOffView: UIView!
    @IBOutlet weak var innerDropOffView: UIView!
    @IBOutlet weak var postItView: UIView!
    //@IBOutlet weak var innerPostItView: UIView!

    var strPaymentProcessMode = "1"
    var strGetAppCodes = ""
    
    @IBOutlet weak var lblLocation: UILabel!
    //@IBOutlet weak var lblPickUpDetail: UILabel!
    @IBOutlet weak var lblWeCome: UILabel!
    @IBOutlet weak var btnGetMyLocation: UIButton!
    @IBOutlet weak var txtAddressLin1: UITextField!
    @IBOutlet weak var txtAddressLine2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var btnPaymentMode: UIButton!
    @IBOutlet weak var btnGetMyLocationHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var streetView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var postCodeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var dropOffSubView1: UIView!
    @IBOutlet weak var dropOffSubView2: UIView!
    @IBOutlet weak var dropOffSubView3: UIView!
    @IBOutlet weak var dropOffLocationView: UIView!
    @IBOutlet weak var dropOffDateView: UIView!
    @IBOutlet weak var dropOffTimeView: UIView!
    @IBOutlet weak var txtDateDropOff: UITextField!
    @IBOutlet weak var txtTimeDropOff: UITextField!
    @IBOutlet weak var lblDropOffAddress: UILabel!

    var selectedAddressIndex = -1
    var segmentIndex = 0
    var selectedAddress = ""
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var txtSearchDevice: UITextField!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var heightOftbl: NSLayoutConstraint!
    
    
    //@IBOutlet weak var txtMobileNumber: UITextField! //s.
    //@IBOutlet weak var txtEmail: UITextField! //s.
    //@IBOutlet weak var txtName: UITextField! //s.
    
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let reachability: Reachability? = Reachability()

    var isComingFromLogin = false
    var isMatchPincode = false
    var strMessage = String()
    
    var arrAddress = [String]()
    
    //S.
    var getFinalPrice2 = 0
    var pickUpChargeGet2 = 0
    var finalPriceSet2 = 0
    var strProductName2 = ""
    var strProductImg2 = ""
    var quatationId2 = String()
    var userPersonalDetails = [String:Any]()
    
    var totalNumberCount = 0
    
    let timeDropDown = DropDown()
    let timeDropOffDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDropOffAddressByAPI()
        
        self.addressTableView.register(UINib(nibName: "DropOffAddTVCell", bundle: nil), forCellReuseIdentifier: "DropOffAddTVCell")
        
        self.setStatusBarColor()
        self.txtDate.text = self.convertDateFormatter()
        self.txtDateDropOff.text = self.convertDateFormatter()
        
        DispatchQueue.main.async {
            self.btnPickUp.roundCorners([.topLeft,.bottomLeft], radius: 10.0)
            self.btnPostIt.roundCorners([.topRight,.bottomRight], radius: 10.0)
            
            self.allBtnView.roundCorners([.topLeft,.topRight], radius: 10.0)
            
            self.pickUpView.roundCorners([.bottomLeft,.bottomRight], radius: 10.0)
            self.dropOffView.roundCorners([.bottomLeft,.bottomRight], radius: 10.0)
            self.postItView.roundCorners([.bottomLeft,.bottomRight], radius: 10.0)
        }
       
        setNavigationBar()
        
        if CustomUserDefault.getCurrency() == "£" {
            totalNumberCount = 6
            
            self.isMatchPincode = true
            self.txtPincode.text = CustomUserDefault.getUserPinCode()
            
        }else if CustomUserDefault.getCurrency() == "NT$" {
            totalNumberCount = 3
            self.isMatchPincode = true
            
            DispatchQueue.main.async {
                self.btnGetMyLocationHeightConstraint.constant = 0
                self.txtPincode.text = CustomUserDefault.getUserPinCode()
            }
        }else {
            totalNumberCount = 5
        }
        
//        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
//            txtIMEI.text = userDefaults.value(forKey: "imei_number") as? String
//        }
//        else{
//            txtIMEI.text = ""
//        }
        
        //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
            
        if CustomUserDefault.getCurrency() == "£" {
            //btnPaymentMode.setTitle("PICK PAYMENT MODE", for: .normal) //s.
        }
        else {
            //btnPaymentMode.setTitle("PLACE ORDER", for: .normal) //s.
        }

        //txtName.text = CustomUserDefault.getUserName() //s.
        //txtEmail.text = CustomUserDefault.getUserEmail() //s.
        //txtMobileNumber.text = CustomUserDefault.getPhoneNumber() //s.
        
        txtCity.text = CustomUserDefault.getCityName()
        // Do any additional setup after loading the view.
        
        if CustomUserDefault.getCurrency() == "NT$" {
            
        }else {
            
            //Sameer 4/10/20
            /*
            //Check for Location Services
            if (CLLocationManager.locationServicesEnabled()) {
                
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }*/
            
        }
     
        
        // Set border
        let borderWidth = CGFloat(1.0)
        let borderColor = UIColor.lightGray.cgColor
        
        streetView.layer.borderWidth = borderWidth
        streetView.layer.borderColor = borderColor
        
        cityView.layer.borderWidth = borderWidth
        cityView.layer.borderColor = borderColor
        
        stateView.layer.borderWidth = borderWidth
        stateView.layer.borderColor = borderColor
        
        countryView.layer.borderWidth = borderWidth
        countryView.layer.borderColor = borderColor
        
        postCodeView.layer.borderWidth = borderWidth
        postCodeView.layer.borderColor = borderColor
        
        dateView.layer.borderWidth = borderWidth
        dateView.layer.borderColor = borderColor
        
        timeView.layer.borderWidth = borderWidth
        timeView.layer.borderColor = borderColor

        innerDropOffView.layer.borderWidth = borderWidth
        innerDropOffView.layer.borderColor = borderColor
        
        //innerPostItView.layer.borderWidth = borderWidth
        //innerPostItView.layer.borderColor = borderColor
        
        dropOffLocationView.layer.borderWidth = borderWidth
        dropOffLocationView.layer.borderColor = borderColor
        
        dropOffDateView.layer.borderWidth = borderWidth
        dropOffDateView.layer.borderColor = borderColor
        
        dropOffTimeView.layer.borderWidth = borderWidth
        dropOffTimeView.layer.borderColor = borderColor
        
        
        
        //self.arrAddress = ["Brixton 49 Brixton Station Rd, Brixton London-NW789","Brixton 49 Brixton Station Rd, Brixton London-NW123","Brixton 49 Brixton Station Rd, Brixton London-NW456"]
        //self.addressTableView.reloadData()
        //self.heightOftbl.constant = self.addressTableView.contentSize.height + (self.arrAddress.count * 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtPincode.delegate = self
        
        // Initialization code
        timeDropDown.anchorView = self.txtTime
        timeDropDown.dataSource = ["10 AM to 1 PM","1 PM to 4 PM","4 PM to 7 PM"]
        timeDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        timeDropOffDropDown.anchorView = self.txtTimeDropOff
        timeDropOffDropDown.dataSource = ["10 AM to 1 PM","1 PM to 4 PM","4 PM to 7 PM"]
        timeDropOffDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        //self.changeLanguageOfUI()
        
        self.txtTime.addTarget(self, action: #selector(tapTimeField), for: .allEditingEvents)
        self.txtTimeDropOff.addTarget(self, action: #selector(tapTimeFieldDropOff), for: .allEditingEvents)
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        txtDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        let datePickerViewDropOff = UIDatePicker()
        datePickerViewDropOff.datePickerMode = .date
        txtDateDropOff.inputView = datePickerViewDropOff
        datePickerViewDropOff.addTarget(self, action: #selector(handleDatePickerDropOff(sender:)), for: .valueChanged)
        
    }
    
    func convertDateFormatter() -> String {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy" // change format as per needs
      let result = formatter.string(from: date)
      return result
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDatePickerDropOff(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtDateDropOff.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func tapTimeField() {
        
        self.view.endEditing(true)
        
        // Drop Down on pickUp time field
        timeDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtTime.text = item
        }

        timeDropDown.width = self.txtTime.bounds.width
        timeDropDown.bottomOffset = CGPoint(x: 0, y:(timeDropDown.anchorView?.plainView.bounds.height)!)
        timeDropDown.show()
    }
    
    @objc func tapTimeFieldDropOff() {
        
        self.view.endEditing(true)
        
        // Drop Down on Drop off time field
        timeDropOffDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.txtTimeDropOff.text = item
        }

        timeDropOffDropDown.width = self.txtTimeDropOff.bounds.width
        timeDropOffDropDown.bottomOffset = CGPoint(x: 0, y:(timeDropDown.anchorView?.plainView.bounds.height)!)
        timeDropOffDropDown.show()
    }

    func changeLanguageOfUI() {
     
        self.lblLocation.text = "Location".localized(lang: langCode)
        //self.lblPickUpDetail.text = "Pick up details".localized(lang: langCode)
        //self.lblPickUpDetail.text = "Collection details".localized(lang: langCode)
        self.lblWeCome.text = "We will come to you and collect your phone.Once we have confirmed the TechCheck payment will be processed immediately.".localized(lang: langCode)
        self.btnGetMyLocation.setTitle("GET MY LOCATION".localized(lang: langCode), for: UIControlState.normal)
        self.txtAddressLin1.placeholder = "Address Line 1".localized(lang: langCode)
        self.txtAddressLine2.placeholder = "Address Line 2".localized(lang: langCode)
        self.txtCity.placeholder = "City".localized(lang: langCode)
        self.txtPincode.placeholder = "Pincode".localized(lang: langCode)
        self.btnPaymentMode.setTitle("Next".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Place Order".localized(lang: langCode)
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        if isComingFromLogin {
            btnBack.setImage(UIImage(named: "sideMenu"), for: .normal)
        }
        else{
            btnBack.setImage(UIImage(named: "back"), for: .normal)
        }
        
        btnBack.addTarget(self, action: #selector(PlaceOrderVC.btnBackPressed), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @IBAction func nearMeClickAction(_ sender: Any) {
    
    }
    
    @IBAction func printYourOwnPack(_ sender: Any) {
        
    }
    
    @IBAction func printYourOwnPackMoreInfo(_ sender: Any) {
        DispatchQueue.main.async {
            let vc = OwnPackVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func requestSalesPack(_ sender: Any) {
        DispatchQueue.main.async {
            let vc = SalesPackVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func requestSalesPackMoreInfo(_ sender: Any) {
        DispatchQueue.main.async {
            let vc = SalesPackVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickAction(_ sender: Any) {
        let btn = sender as! UIButton
        
        if(btn == btnPickUp)
        {
            segmentIndex = 0
            self.dropOffSubView1.isHidden = false
            self.dropOffSubView2.isHidden = false
            self.dropOffSubView3.isHidden = true
            
            btnPickUp.setTitleColor(UIColor().gradientTechCheckFirstColor(), for: .normal)
            btnDropOff.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnPostIt.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            self.UIView1.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            self.UIView2.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            self.UIView3.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            
            self.pickUpView.isHidden = false
            self.dropOffView.isHidden = true
            self.postItView.isHidden = true
           
        }
        else if(btn == btnDropOff)
        {
            segmentIndex = 1
            
            btnPickUp.setTitleColor(UIColor().gradientTechCheckFirstColor(), for: .normal)
            btnDropOff.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnPostIt.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            self.UIView1.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            self.UIView2.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            self.UIView3.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            
            self.pickUpView.isHidden = true
            self.dropOffView.isHidden = false
            self.postItView.isHidden = true
            
        }
        else
        {
            segmentIndex = 2
            self.dropOffSubView1.isHidden = false
            self.dropOffSubView2.isHidden = false
            self.dropOffSubView3.isHidden = true
            
            btnPickUp.setTitleColor(UIColor().gradientTechCheckFirstColor(), for: .normal)
            btnDropOff.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            btnPostIt.setTitleColor(UIColor().HexToColor(hexString:"C7C7C7"), for: .normal)
            
            self.UIView1.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            self.UIView2.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            self.UIView3.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
            
            self.pickUpView.isHidden = true
            self.dropOffView.isHidden = true
            self.postItView.isHidden = false
            
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        
        if isComingFromLogin{
            self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
            })
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func btnBackPressed() -> Void {
        if isComingFromLogin {
            self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
            })
        }
         else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnGetLocationPressed(_ sender: UIButton) {
        self.setLocation()
    }
    
    @IBAction func btnPickUpPressed(_ sender: UIButton) {
        
        if segmentIndex == 1 {
            self.lblDropOffAddress.text = self.selectedAddress
            
            self.dropOffSubView1.isHidden = true
            self.dropOffSubView2.isHidden = true
            self.dropOffSubView3.isHidden = false
        }else {
            
            if Validation() {
                userDefaults.setValue(txtPincode.text!, forKey: "orderPinCode")
                userDefaults.set(txtAddressLin1.text, forKey: "placeOrderAddress")
                //userDefaults.setValue(txtIMEI.text!, forKey: "orderOtherIMEINumber")
                //  if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
                //CustomUserDefault.setPhoneNumber(data: txtMobileNumber.text!) //s.
                //CustomUserDefault.setUserNmae(data: txtName.text!) //s.
                //CustomUserDefault.setUserEmail(data: txtEmail.text!) //s.
                //            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                //                userDefaults.setValue(self.txtIMEI.text!, forKey: "imei_number")
                //            }
                
                //let vc = PaymentTypeVC() //s.
                //vc.strLandMark = "" //s.
                //self.navigationController?.pushViewController(vc, animated: true) //s.
                
                self.getProcessPaymentMode()
            }
            
        }
    }
    
    @IBAction func btnHomePressed(_ sender: UIButton) {
        setLocation()
    }
    
    //MARK:- validation Method
    func Validation()->Bool
    {
        if txtAddressLin1.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter address line 1".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if txtPincode.text!.isEmpty
        {
            Alert.showAlertWithError(strMessage: "Please enter pincode".localized(lang: langCode) as NSString, Onview: self)
            return false
        }
        else if isMatchPincode == false {
            Alert.showAlertWithError(strMessage: "Pincode not match with your city.".localized(lang: langCode) as NSString, Onview: self)
            self.strMessage = "Pincode not match with your city.".localized(lang: langCode)
            return false
        }
        
        return true
    }
    
    //MARK:- web service methods
    func getAddressPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func getDropOffAddressByAPI() {
                
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getDropOffAddress"
        
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName
        ]
        
        print(parametersHome)
        
      self.getAddressPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
        
        print(responseObject ?? [:])
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    let arrAddressData = responseObject?["msg"] as? NSArray
                    
                    for index in 0..<arrAddressData!.count {
                        let dict = arrAddressData![index] as? NSDictionary
                        
                        let addStr1 = (dict?["address"] as? String ?? "") + "\n" + (dict?["addressHead"] as? String ?? "") + "\n"
                        
                        let addStr2 = (dict?["city"] as? String ?? "") + "\n" + (dict?["pincode"] as? String ?? "")
                        
                        let addressStr = addStr1 + addStr2
                        
                        self.arrAddress.append(addressStr)
                        
                    }
                    
                    self.addressTableView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.heightOftbl.constant = (self.addressTableView.contentSize.height)
                    }
                    
                    
                  //self.arrAddress = ["Brixton 49 Brixton Station Rd, Brixton London-NW789","Brixton 49 Brixton Station Rd, Brixton London-NW123","Brixton 49 Brixton Station Rd, Brixton London-NW456"]
                  //self.addressTableView.reloadData()
                  //self.heightOftbl.constant = self.addressTableView.contentSize.height + (self.arrAddress.count * 10)
                }
                else{
                    // failed
                    self.strMessage = (responseObject?["msg"] as! String)
                    Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        
    }
    
    func cityMatchiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func matchCityByAPI() {
        
        //activityPincode.startAnimating()
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getCity"
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "pincode":txtPincode.text!
        ]
        print(parametersHome)
      self.cityMatchiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            //self.activityPincode.stopAnimating()
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    
                    if CustomUserDefault.getCityId() == responseObject?.value(forKeyPath: "msg.cityId") as! String {
                        
                        self.isMatchPincode = true
                    }
                    else{
                        
                        self.strMessage = "Pincode not match with your city.".localized(lang: langCode)
                        self.isMatchPincode = false
                        
                        Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                    }
                  
                }
                else{
                    // failed
                    self.strMessage = (responseObject?["msg"] as! String)
                    Alert.showAlertWithError(strMessage: self.strMessage as NSString, Onview: self)
                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        
    }
    
    //MARK: UITableView DataSource & Delegates
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DropOffAddTVCell = tableView.dequeueReusableCell(withIdentifier: "DropOffAddTVCell", for: indexPath) as! DropOffAddTVCell
        DropOffAddTVCell.lblAddress.text = arrAddress[indexPath.row]
        
        if self.selectedAddressIndex == indexPath.row {
            DropOffAddTVCell.imgViewCircle.image = #imageLiteral(resourceName: "testPass")
        }else {
            DropOffAddTVCell.imgViewCircle.image = #imageLiteral(resourceName: "unchk")
        }
        
        return DropOffAddTVCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAddressIndex = indexPath.row
        self.selectedAddress = self.arrAddress[indexPath.row]
        self.addressTableView.reloadData()
    }
    
    //MARK:- textfield delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPincode {
            if (txtPincode.text?.isEmpty)!{
                Alert.showAlertWithError(strMessage: "Enter valid Code".localized(lang: langCode) as NSString, Onview: self)
            }
            else{
                //self.lblPincodeMatchMessage.isHidden = true
                matchCityByAPI()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPincode {
            // YOU SHOULD FIRST CHECK FOR THE BACKSPACE. IF BACKSPACE IS PRESSED ALLOW IT
            
            if string == "" {
                return true
            }
            
            if let characterCount = textField.text?.count {
                // CHECK FOR CHARACTER COUNT IN TEXT FIELD
                if characterCount == totalNumberCount {
                    // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                    return textField.resignFirstResponder()
                }
            }
        }
            return true
            
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txtIMEI{
//        if (textField.text?.utf8CString.count)! > 15
//        {
//            let  char = string.cString(using: String.Encoding.utf8)!
//            let isBackSpace = strcmp(char, "\\b")
//            if (isBackSpace == -92) {
//                return true
//            }
//            else
//            {
//                return false
//            }
//        }
//        else
//        {
//            return true
//
//        }
//        }
        
        if textField == txtMobileNumber {
            //if (userDefaults.value(forKey: "countryName") as? String)?.contains("India") != nil {
        if CustomUserDefault.getCurrency() == "£" {
                if (textField.text?.utf8CString.count)! > 10
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }
            else{
                if (textField.text?.utf8CString.count)! > 11
                {
                    let  char = string.cString(using: String.Encoding.utf8)!
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    return true
                }
            }

        }
        else{
            return true

        }
    }*/ //s.
    
    //MARK:- func setLocation Framework
    func setLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Here you can check whether you have allowed the permission or not.
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                if (self.locationManager.location != nil){
                let latitude: CLLocationDegrees = (self.locationManager.location?.coordinate.latitude)!
                let longitude: CLLocationDegrees = (self.locationManager.location?.coordinate.longitude)!
                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    }else if let country = placemarks?.first?.country,
                        let city = placemarks?.first?.locality, let _ = placemarks?.first?.name, let _ = placemarks?.first?.subLocality {
                        
                        DispatchQueue.main.async {
                            
                            if CustomUserDefault.getCityName() == "" {
                                self.txtCity.text = city
                            }else {
                                self.txtCity.text = CustomUserDefault.getCityName()
                            }
                            
                            self.txtAddressLin1.text = placemarks?.first?.addressDictionary?["SubLocality"] as? String
                            self.txtAddressLine2.text = placemarks?.first?.addressDictionary?["Street"] as? String
                            self.txtState.text = placemarks?.first?.addressDictionary?["State"] as? String
                            self.txtCity.text = placemarks?.first?.addressDictionary?["Country"] as? String
                            self.txtPincode.text = placemarks?.first?.addressDictionary?["ZIP"] as? String
                            
                            
                            if let placemark = placemarks?.last
                            {
                                if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
                                {
                                    //self.txtAddressLin1.text =  addrList.joined(separator: ", ") //s.
                                    
                                    //self.txtAddressLin1.text = addrList[0]
                                    //self.txtAddressLine2.text = addrList[1]
                                    
                                    //let arrStr1 : [String?] = addrList[2].components(separatedBy: ",")
                                    
                                    //self.txtPincode.text = arrStr1[1]
                                    self.matchCityByAPI()
                                    
                                }
                            }
                        }
                        

                        
                       // self.txtAddressLin1.text = name + "," + subLocality + "," + city + "," + country
                        
                    }
                    else {
                    }
                })
            }
                break
                
            case .notDetermined:
                print("Not determined.")
                break
                
            case .restricted:
                print("Restricted.")
                break
                
            case .denied:
                print("Denied.")
            }
        }
        else{
            
        }
    }
    
    //MARK:- location update delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                return
            }else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality, let _ = placemarks?.first?.name, let _ = placemarks?.first?.subLocality {
                
                DispatchQueue.main.async {
                    
                    if CustomUserDefault.getCityName() == "" {
                        self.txtCity.text = city
                    }else {
                        self.txtCity.text = CustomUserDefault.getCityName()
                    }

                    self.txtAddressLin1.text = placemarks?.first?.addressDictionary?["SubLocality"] as? String
                    self.txtAddressLine2.text = placemarks?.first?.addressDictionary?["Street"] as? String
                    self.txtState.text = placemarks?.first?.addressDictionary?["State"] as? String
                    self.txtCity.text = placemarks?.first?.addressDictionary?["Country"] as? String
                    self.txtPincode.text = placemarks?.first?.addressDictionary?["ZIP"] as? String
                    
                    if let placemark = placemarks?.last
                    {
                        if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String?]
                        {
                            //self.txtAddressLin1.text =  addrList.joined(separator: ", ") //s.
                            
                            //self.txtAddressLin1.text = addrList[0] ?? ""
                            //self.txtAddressLine2.text = addrList[1] ?? ""
                            
                            //let arrStr1 : [String?] = addrList[2]?.components(separatedBy: ",") ?? [""]
                            
                            //self.txtPincode.text = arrStr1[1] ?? ""
                            //self.txtPincode.text = "306401"
                            self.matchCityByAPI()
                            
                            self.locationManager.stopUpdatingLocation()
                            //self.locationManager = nil
                        }
                    }
                }
                
              //  self.txtAddressLin1.text = name + "," + subLocality + "," + city + "," + country
                
            }
//            guard let currentLocPlacemark = placemarks?.first else { return }
//            print(currentLocPlacemark.country ?? "No country found")
            //if self.isChangeLocation == true{
          
            }
    }
    
    func isIMEIValid(imeiNumber: String) -> Bool {
        var sum = 0;
        for i in (0..<15){
            var number = Int(imeiNumber.substring(fromIndex: i, toIndex: i))
            if ((i+1)%2==0){
                number = number!*2;
                number = number!/10+number!%10;
            }
            sum=sum+number!
        }
        if(sum%10 == 0) {
            return true
        }else{
            return false
        }
    }
    
    //MARK:- web service methods
    
    func apiPayment(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func getProcessPaymentMode() {
        
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        let strUrl = strBaseURL + "getServices"
        let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            "categoryId":"15",
            "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "" //110011
        ]
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            if error == nil {
                if responseObject?["status"] as! String == "Success" {
                    //let strProcess = responseObject?.value(forKeyPath: "msg.process") as? String //s.
                    //let badchar = CharacterSet(charactersIn: "[]") //s.
                    //let cleanedstring = strProcess!.components(separatedBy: badchar).joined() //s.
                    //self.strPaymentProcessMode = cleanedstring //s.
                    //self.lockAndPlaceOrderApiForMalasiya() //s.
                    
                    
                    self.userPersonalDetails["address1"] = self.txtAddressLin1.text
                    self.userPersonalDetails["address2"] = self.txtAddressLine2.text
                    self.userPersonalDetails["city"] = self.txtCity.text
                    self.userPersonalDetails["pincode"] = self.txtPincode.text
                     
                     
                     let vc = PromoCodeVC()
                     vc.strProductImg = self.strProductImg2
                     vc.strProductName = self.strProductName2
                     vc.getFinalPrice = self.getFinalPrice2
                     vc.pickUpChargeGet = self.pickUpChargeGet2
                     vc.quatationId = self.quatationId2
                     vc.userDetails = self.userPersonalDetails
                     self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    // failed
                    Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                }
                
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
            }
            
        })
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    func lockAndPlaceOrderApiForMalasiya() {
        
        if reachability?.connection.description != "No Connection" {

        let strValue = "STON01,"
        var userSelectedProductAppcodes = ""
        var producdID = ""
        
        // var imEINumber = ""
            
        if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
            producdID = CustomUserDefault.getProductId()
          //  imEINumber = userDefaults.value(forKey: "imei_number") as! String
            let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
            let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
        }
        else{
            producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
          //  imEINumber = userDefaults.value(forKey: "orderOtherIMEINumber") as! String
            let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
                userSelectedProductAppcodes = strValue +  strQuestionAppCodes
        }
        
        let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
        let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
        
        let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
        var strUrl = ""
        if userDefaults.value(forKey: "isPlaceOrder") as! Bool == true{
            strUrl = strBaseURL + "orderCreate"
        }
        else{
            strUrl = strBaseURL + "priceLock"
        }
        var strGCMToken = ""
        if (userDefaults.value(forKey: "FCMToken") != nil){
            strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            
        }
        else{
            strGCMToken = ""
        }
            var strPromoterId = ""
            if userDefaults.value(forKey: "promoter_id") == nil {
                strPromoterId = ""
            }
            else{
                strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
            }
        let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
        //let finalAmount = String(format: "%d", (userDefaults.value(forKeyPath: "productPriceFromAPI") as? Int)!)
        
            let parametersHome : [String : Any] = [
            "apiKey" : key,
            "userName" : apiAuthenticateUserName,
            //"mobile":txtMobileNumber.text!,
            //"name":txtName.text!,
            "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "",
            "city":CustomUserDefault.getCityId(),
            "productId": producdID,
            "conditionString":converComaToSemocolumForProductValues,
            "remark" : "",
            //"email" : txtEmail.text!,
            "productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String,
            "GCMId":strGCMToken,
            "pincode":userDefaults.value(forKey: "orderPinCode") as! String,
            "customerId":CustomUserDefault.getUserId(),
            "landmark": "",
            "isNewAddress":"1",
            "diagnosisId" : userDefaults.value(forKey: "diagnosisId") as! String,
            "uniqueIdentifire" :KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!,// + "~" + imEINumber,
            "paymentCode":"BANK",
            "processMode":self.strPaymentProcessMode,
            "couponCode":userDefaults.value(forKey: "orderPromoCode") as! String,
            "couponAmount": couponAmount,
            "promoterId":strPromoterId
            
            //userDefaults.value(forKeyPath: "orderPinCode") as? String ?? ""
        ]
            
        self.apiPayment(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
            Alert.HideProgressHud(Onview: self.view)
            
            if error == nil {
                if responseObject?["status"] as! String == "Success"{
                    // firebase analytics event
                    var currency = ""
                    //if (userDefaults.value(forKey: "countryName") as? String)?.contains("Malaysia") != nil {
                    
                    if CustomUserDefault.getCurrency() == "MY" {
                        currency = "MYR"
                    }
                    else{
                        currency = "SGD"
                    }
                    var productName = ""

                    if userDefaults.value(forKey: "productName") != nil{
                        productName = userDefaults.value(forKey: "productName") as? String ?? ""
                    }
                    else{
                        productName = ""
                    }
                  //  let amount = Double(responseObject?.value(forKey: "msg") as! String)
                   
                    
//                    AppEventsLogger.log(
//                        .addedToCart(
//                            contentType: productName,
//                            contentId: producdID,
//                            currency: currency))
                    
                    /* //Sameer 2/6/2020
                    Analytics.logEvent("order_placed", parameters: [
                        "event_category":"order placed for malasiya",
                        "event_action":"order placed for malasiya Click Action",
                        "event_label":"order placed for malasiya Test"
                        ])*/
                    
                    /* //Sameer 2/6/2020
                    Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
                        AnalyticsParameterItemID: producdID,
                        AnalyticsParameterItemName: productName,
                        AnalyticsParameterCurrency:currency
                        ])*/
                    
                    if userDefaults.value(forKey: "isShowUIOnHomeForOrder") != nil{
                    userDefaults.setValue(false, forKey: "isShowUIOnHomeForOrder")
                    userDefaults.setValue(false, forKey: "isLaterForConfirmOrder")

                    }
                    let vc  = FillDetailLater()
                    vc.strGetUserID = responseObject?.value(forKey: "msg") as? String ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    // failed
                    Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                }
            }
            else{
                Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                
            }
            
        })
        }
        else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)

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
