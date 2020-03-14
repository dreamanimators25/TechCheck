//
//  DiagnosticTestResultVC.swift
//  InstaCash
//
//  Created by InstaCash on 25/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftyJSON

class ModelCompleteDiagnosticFlow: NSObject {
    var priority = 0
    var strTestType = ""
    var strSucess = ""
}

class DiagnosticTestResultVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lblTests: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var tblViewTest: UITableView!
    var arrFailedAndSkipedTest = [ModelCompleteDiagnosticFlow]()
    var arrFunctionalTest = [ModelCompleteDiagnosticFlow]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var section = [""]
    var resultJSON = JSON()
    let reachability: Reachability? = Reachability()
    
    @IBOutlet weak var heightOftbl: NSLayoutConstraint!
    
    @IBOutlet weak var btnPlaceOrder: shadowCornerButton!
    
    override func viewDidLoad() {
    
        //self.btnPlaceOrder.setTitle("Place order at \(CustomUserDefault.getCurrency())\(350) instead", for:.normal)
        
        self.btnPlaceOrder.setTitle("Place order", for:.normal)
        
        super.viewDidLoad()
        userDefaults.removeObject(forKey: "Diagnosis_DataSave")
        tblViewTest.register(UINib(nibName: "TestResultCell", bundle: nil), forCellReuseIdentifier: "testResultCell")
        self.didPullToRefresh()
        lblPhone.text = UIDevice.current.modelName
        
    }
    
    func didPullToRefresh(){
        //get home data
        if reachability?.connection.description != "No Connection"{
            Alert.ShowProgressHud(Onview: self.view)
            HomeModel.fetchHomeData(isInterNet:true,isappModeCode:"",getController: self) { (arrBrandDeviceGetData,arrPopularDeviceGetData,arrMyOderGetData,arrMyCurrentDeviceSend,strAppModeCode) in
                Alert.HideProgressHud(Onview: self.view)
                
                self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                
                if arrMyCurrentDeviceSend.count > 0 {
                    
                    let imgURL = URL(string:arrMyCurrentDeviceSend[0].strCurrentDeviceImage!)
                    self.imgPhone.sd_setImage(with: imgURL)
                    let strAmount = String(format: "%d", arrMyCurrentDeviceSend[0].currentDeviceMaximumTotal!)
                    
                    /*//S.
                    /////////////////////////////////////////////////
                    //To show price in currencyFormat
                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.usesGroupingSeparator = true
                    currencyFormatter.numberStyle = .currency
                    //localize to your grouping and decimal separator
                    
                    let selectedCurrency = CustomUserDefault.getCurrency()
                    var symbole = ""
                    if selectedCurrency == "₹ " {
                        symbole = "en_IN"
                    }else if selectedCurrency == "RM " {
                        symbole = "ms_MY"
                    }else if selectedCurrency == "SG$ " {
                        symbole = "en_SG"
                    }
                    /*
                    else if selectedCurrency == "php" {
                        symbole = "en_PH"
                    }*/
                    
                    currencyFormatter.locale = Locale.init(identifier: symbole) //Locale.current
                    
                    let priceString = currencyFormatter.string(from: NSNumber.init(value: Int.init(strAmount) ?? 0))
                    self.lblPrice.text = priceString
                    /////////////////////////////////////////////////
                    */
                    
                    self.lblPrice.text = CustomUserDefault.getCurrency()  + strAmount
                    
                    
                    //self.btnPlaceOrder.setTitle("Place order at \(CustomUserDefault.getCurrency())\(strAmount) instead", for:.normal)
                    self.btnPlaceOrder.setTitle("I'm done", for:.normal)
                    //self.btnPlaceOrder.setTitle("Place order at \(priceString ?? "") instead", for: .normal) //s.
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        arrFailedAndSkipedTest.removeAll()
        arrFunctionalTest.removeAll()
        
        if userDefaults.value(forKey: "screen")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 1
            model.strTestType = "Screen"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Screen"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "rotation")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 2
            model.strTestType = "Rotation"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Rotation"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "proximity")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 3
            model.strTestType = "Proximity"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Proximity"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "volume") as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 4
            model.strTestType = "Volume"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Volume"
            arrFunctionalTest.append(model)
        }
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
        
        //if (userDefaults.value(forKey: "countryName") as! String).contains("India"){
            
            if userDefaults.value(forKey: "earphone")  as! Bool == false{
                let model = ModelCompleteDiagnosticFlow()
                model.priority = 5
                model.strTestType = "Earphone"
                arrFailedAndSkipedTest.append(model)
            }
            else{
                let model = ModelCompleteDiagnosticFlow()
                model.priority = 0
                model.strTestType = "Earphone"
                arrFunctionalTest.append(model)
            }
            
            if userDefaults.value(forKey: "charger")  as! Bool == false{
                let model = ModelCompleteDiagnosticFlow()
                model.priority = 6
                model.strTestType = "Charger"
                arrFailedAndSkipedTest.append(model)
            }
            else{
                let model = ModelCompleteDiagnosticFlow()
                model.priority = 0
                model.strTestType = "Charger"
                arrFunctionalTest.append(model)
            }
        }
        
        if userDefaults.value(forKey: "camera")  as? Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 7
            model.strTestType = "Camera"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Camera"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "fingerprint")  as! Bool == false {
            if self.resultJSON["Fingerprint Scanner"].int != 0  {
                
                if self.resultJSON["Fingerprint Scanner"].int != -2 {
                    let model = ModelCompleteDiagnosticFlow()
                    model.priority = 8
                    model.strTestType = "FingerPrint"
                    arrFailedAndSkipedTest.append(model)
                }
                
            }
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "FingerPrint"
            arrFunctionalTest.append(model)
        }
        //        if CustomUserDefault.isUserIdExit(){
        //            let model = ModelCompleteDiagnosticFlow()
        //            model.priority = 0
        //            model.strTestType = "Phone Number Verification"
        //            arrFunctionalTest.append(model)
        //        }
        //        else{
        //            let model = ModelCompleteDiagnosticFlow()
        //            model.priority = 9
        //            model.strTestType = "Phone Number Verification"
        //            arrFailedAndSkipedTest.append(model)
        //        }
        
        if UIDevice.current.modelName == "iPhone 4" ||  UIDevice.current.modelName == "iPhone 4s" ||  UIDevice.current.modelName == "iPhone 5" ||  UIDevice.current.modelName == "iPhone 5c" ||  UIDevice.current.modelName == "iPhone 5s"
        {
            //            let model = ModelCompleteDiagnosticFlow()
            //            model.priority = 10
            //            model.strTestType = "NFC"
            //            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "NFC"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "GSM")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 11
            model.strTestType = "GSM"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "GSM"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "Bluetooth")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 12
            model.strTestType = "Bluetooth"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Bluetooth"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "Storage")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 13
            model.strTestType = "Storage"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Storage"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "GPS")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 14
            model.strTestType = "GPS"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "GPS"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "Battery")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 15
            model.strTestType = "Battery"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "Battery"
            arrFunctionalTest.append(model)
        }
        
        if userDefaults.value(forKey: "WIFITest")  as! Bool == false{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 16
            model.strTestType = "WIFI"
            arrFailedAndSkipedTest.append(model)
        }
        else{
            let model = ModelCompleteDiagnosticFlow()
            model.priority = 0
            model.strTestType = "WIFI"
            arrFunctionalTest.append(model)
        }
        
        /* //s.
        let model = ModelCompleteDiagnosticFlow()
        model.priority = 0
        model.strTestType = "Speaker"
        arrFunctionalTest.append(model)
        
        let model1 = ModelCompleteDiagnosticFlow()
        model1.priority = 0
        model1.strTestType = "Microphone"
        arrFunctionalTest.append(model1)
        */ //s.
        
        
        if arrFailedAndSkipedTest.count > 0 {
            section = ["Failed and Skipped Tests", "Functional Checks"]
        }
        else{
            section = ["Functional Checks"]
        }
        
        if CustomUserDefault.getCurrency() == "₹ " || CustomUserDefault.getCurrency() == "₹" {
            self.lblTests.text = "Your device passed \(arrFunctionalTest.count)/15 tests!"
        }else {
            self.lblTests.text = "Your device passed \(arrFunctionalTest.count)/13 tests!"
        }
        
        
        //self.tblViewTest.contentSize = CGSize(width: self.tblViewTest.frame.width, height: ((CGFloat(arrFunctionalTest.count+arrFailedAndSkipedTest.count)) * 60))
        
        self.heightOftbl.constant = (CGFloat(arrFunctionalTest.count+arrFailedAndSkipedTest.count + 2) * 60) + 100
        
        tblViewTest.reloadData()
    }
    
    //MARK:- tableview Delegates methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if arrFailedAndSkipedTest.count > 0 {
                return  arrFailedAndSkipedTest.count
            }
            else {
                return arrFunctionalTest.count
            }
        }
        else {
           return arrFunctionalTest.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if arrFailedAndSkipedTest.count > 0{
        if indexPath.section == 0{
            let cellfailed = tableView.dequeueReusableCell(withIdentifier: "testResultCell", for: indexPath) as! TestResultCell
            cellfailed.imgReTry.image = UIImage(named: "unverified")
            cellfailed.lblName.text = arrFailedAndSkipedTest[indexPath.row].strTestType
            cellfailed.imgReTry.isHidden = true
            cellfailed.lblReTry.isHidden = false

            return cellfailed
        }
        else{
            let cellFunction = tableView.dequeueReusableCell(withIdentifier: "testResultCell", for: indexPath) as! TestResultCell
            cellFunction.imgReTry.image = UIImage(named: "rightGreen")
            cellFunction.lblName.text = arrFunctionalTest[indexPath.row].strTestType
            cellFunction.imgReTry.isHidden = false
            cellFunction.lblReTry.isHidden = true


            return cellFunction
        }
        }
          else{
            let cellFunction = tableView.dequeueReusableCell(withIdentifier: "testResultCell", for: indexPath) as! TestResultCell
            cellFunction.imgLogo.image = UIImage(named: "rightGreen")
            cellFunction.lblName.text = arrFunctionalTest[indexPath.row].strTestType
            //cellFunction.imgReTry.isHidden = true
            //cellFunction.lblReTry.isHidden = true


            return cellFunction
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrFailedAndSkipedTest.count > 0{
            if indexPath.section == 0{
            if arrFailedAndSkipedTest[indexPath.row].strTestType == "Screen" {
                let vc  = ScreenTestingVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
                
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Rotation"{
                let vc  = RotationVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON

                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Proximity"{
                let vc  = SensorReadVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON

                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Volume"{
                let vc  = VolumeCheckerVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Earphone"{
                let vc  = EarPhoneVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON

                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Charger"{
                let vc  = DeviceChargerVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON

                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Camera"{
                let vc  = CameraVC()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON

                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "FingerPrint"{
                let vc  = FingerPrintDevice()
                vc.isComingFromTestResult = true
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if  arrFailedAndSkipedTest[indexPath.row].strTestType == "Bluetooth" ||  arrFailedAndSkipedTest[indexPath.row].strTestType == "WIFI" ||  arrFailedAndSkipedTest[indexPath.row].strTestType == "GPS" ||  arrFailedAndSkipedTest[indexPath.row].strTestType == "GSM"{
                let vc  = BlueToothTestingVC()
                vc.resultJSON = self.resultJSON
                self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        // Prepare the popup assets
        let title = "Quit Diagnosis"
        let message = "Are you sure you want to quit?"
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message,buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal :false)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Yes") {
            DispatchQueue.main.async() {
                obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
            }
        }
        
        let buttonTwo = DefaultButton(title: "No") {
            //Do Nothing
            popup.dismiss(animated: true, completion: nil)
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        popup.dismiss(animated: true, completion: nil)
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Medium", size: 20)!
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 16)!
        
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.opacity         = 0.7
        ov.color           = .black
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)

    }
    
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        
        if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") == nil {
            let vc = QuriesVC()
            vc.resultJSON = self.resultJSON
            let nav = UINavigationController(rootViewController: vc)
            //UINavigationBar.appearance().barTintColor = navColor
            nav.navigationBar.isHidden = true
            self.present(nav, animated: true, completion: nil)
        }
        else{
            if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Diagnosis" {
                let vc = MisMatchVC()
                vc.resultJSONGet = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else if userDefaults.value(forKey: "ChangeModeComingFromDiadnosis") as! String == "Pickup"{
                let vc = MisMatchVC()
                vc.resultJSONGet = self.resultJSON
                self.present(vc, animated: true, completion: nil)
            }
            else{
                let vc = QuriesVC()
                vc.resultJSON = self.resultJSON
                let nav = UINavigationController(rootViewController: vc)
                //UINavigationBar.appearance().barTintColor = navColor
                nav.navigationBar.isHidden = true
                self.present(nav, animated: true, completion: nil)
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
