//
//  UploadDocumentVC.swift
//  InstaCash
//
//  Created by InstaCash on 12/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import Photos
import FirebaseAnalytics

protocol UpdateOrderListDelegate {
    func updateOrderList()
}

class UploadDocumentVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let reachability: Reachability? = Reachability()

    @IBOutlet weak var imgViewPhoneFront: UIImageView!
    @IBOutlet weak var imgViewPhoneBack: UIImageView!
    @IBOutlet weak var imgViewPhoneBill: UIImageView!
    
    @IBOutlet weak var lblUploadImages: UILabel!
    @IBOutlet weak var lblUploadImage: UILabel!
    @IBOutlet weak var lblPhoneImage: UILabel!
    @IBOutlet weak var lblPhoneFrontImage: UILabel!
    @IBOutlet weak var lblPhoneBackImage: UILabel!
    @IBOutlet weak var lblBillImage: UILabel!
    @IBOutlet weak var lblPhoneBillImage: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnProceed: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    
    var delegate:UpdateOrderListDelegate?
    var referenceType = String()
    var orderAmount = ""
    var strOrderItemId = ""
    var strImageSendToServer = ""
    var btnTap = 0
    var selectedImage = UIImage()
    var imageTitle = String()
    
    var frontImage = ""
    var backImage = ""
    var billImage = ""
    
    ////////////////////////////////
    var strPaymentProcessMode = "1"
    
    var getFinalPrice5 = 0
    var pickUpChargeGet5 = 0
    var finalPriceSet5 = 0
    var strProductName5 = ""
    var strProductImg5 = ""
    var quatationId5 = String()
    var userDetails5 = [String:Any]()
    var arrDictPaymentMode5 = [NSDictionary]()
    var selectePaymentType5 = String()
    var donation5 = String()
    var bankDETAILS = [String:Any]()
    var skipOrder = false
    ///////////////////////
    var placedOrderId = String()
    
    let jsonObject : NSMutableDictionary = NSMutableDictionary()
    var arrJsonObject : NSMutableArray = NSMutableArray()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblUploadImages.text = "Upload Images".localized(lang: langCode)
        self.lblUploadImage.text = "Upload Image".localized(lang: langCode)
        self.lblPhoneImage.text = "Phone Image".localized(lang: langCode)
        self.lblPhoneFrontImage.text = "Upload Your phone front  Image".localized(lang: langCode)
        self.lblPhoneBackImage.text = "Upload Your phone back  Image".localized(lang: langCode)
        self.lblBillImage.text = "Bill Image".localized(lang: langCode)
        self.lblPhoneBillImage.text = "Upload Your phone bill  Image".localized(lang: langCode)
        
        self.btnSkip.setTitle("SKIP".localized(lang: langCode), for: UIControlState.normal)
        self.btnProceed.setTitle("PROCEED".localized(lang: langCode), for: UIControlState.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //btnUpload.isEnabled = false //s.
        //btnUpload.alpha = 0.2 //s.
        //setNavigationBar() //s.
        
        self.checkPermission()
        imagePicker.delegate = self
        
        if skipOrder {
            //self.setPaymentDetailsFromServer()
            self.fetchOrderFromServer(isRefreshPrice: true)
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("access is granted by user.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                print("status is \(newStatus)")
                
                if newStatus == PHAuthorizationStatus.authorized {
                    print("success")
                }
                
            }
        default:
            print("user has denied the request.")
        }
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "UPLOAD BILL".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(UploadDocumentVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenGallaryPressed(_ sender: UIButton) {
        SetActionSetForMoreOptionAttachment()
    }
    
    @IBAction func btnUploadPressed(_ sender: UIButton) {
        fireWebServiceForConvertToOrder()
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPhoneFrontImagePressed(_ sender: UIButton) {
        btnTap = 1
        SetActionSetForMoreOptionAttachment()
    }
    
    @IBAction func btnPhoneBackImagePressed(_ sender: UIButton) {
        btnTap = 2
        SetActionSetForMoreOptionAttachment()
    }
    
    @IBAction func btnPhoneBillImagePressed(_ sender: UIButton) {
        btnTap = 3
        SetActionSetForMoreOptionAttachment()
    }
    
    @IBAction func btnSkipPressed(_ sender: UIButton) {
        
        let vc = OrderFinalVC()
        vc.orderID = placedOrderId
        vc.finalPrice = self.getFinalPrice5
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnOrderCreatePressed(_ sender: UIButton) {
        guard self.frontImage == "Phone Front Image".localized(lang: langCode) || self.backImage == "Phone Back Image".localized(lang: langCode) || self.billImage == "Phone Bill Image".localized(lang: langCode) else {
            
            Alert.showAlertWithTitle(strTitle: "", strMessage: "Please add at least one image to processed.".localized(lang: langCode) as NSString, Onview: self)
            
            return
        }
        
        self.fireWebServiceForConvertToOrder()
        
    }
    
    //MARK:- action sheet method
    
    func SetActionSetForMoreOptionAttachment()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized(lang: langCode), style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.importImageFromGallery(src: "Camera")
        })
        
        let galleryiAction = UIAlertAction(title: "Gallery".localized(lang: langCode), style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.importImageFromGallery(src: "Photo Library")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(lang: langCode), style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryiAction)
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func importImageFromGallery(src:String) {
        
        if src == "Photo Library" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if src == "Camera" {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                
            }
        }
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true) {
            // code
        }
    }
    
    //MARK:- image picker delegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.25)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        self.strImageSendToServer = strBase64
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            print(asset?.value(forKey: "filename") ?? "")
            imageTitle = asset?.value(forKey: "filename") as? String ?? ""
        }
        
        self.selectedImage = image
       
        switch self.btnTap {
        case 1:
            imageTitle = "Phone Front Image"
            frontImage = "Phone Front Image".localized(lang: langCode)
            self.imgViewPhoneFront.image = self.selectedImage
        case 2:
            imageTitle = "Phone Back Image"
            backImage = "Phone Back Image".localized(lang: langCode)
            self.imgViewPhoneBack.image = self.selectedImage
        default:
            imageTitle = "Phone Bill Image"
            billImage = "Phone Bill Image".localized(lang: langCode)
            self.imgViewPhoneBill.image = self.selectedImage
        }
        
        if strOrderItemId == "" {
            referenceType = "other"
        }else{
            referenceType = "order"
        }
        
        jsonObject["refType"] = referenceType
        jsonObject["refValue"] = strOrderItemId
        jsonObject["fileType"] = "jpg"
        jsonObject["tag"] = imageTitle
        jsonObject["content"] = strImageSendToServer
        
        
        arrJsonObject.add(jsonObject)
        
        
        //self.fireWebServiceForConvertToOrder() //s.
        
        //btnUpload.isEnabled = true //s.
        //btnUpload.alpha = 1.0 //s.
        
        //dismiss(animated: true, completion: nil) //s.
        dismiss(animated: true) {
            //self.fireWebServiceForConvertToOrder()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- web service methods
    func DocumentApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForConvertToOrder()
    {
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            
            let strUrl =  strBaseURL + "uploadDocuments"
            var st = String()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: arrJsonObject, options: [])
                
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(jsonString)
                    st = jsonString
                }
                
            } catch {
                print(error)
            }
            
            let parametersHome : [String : Any] = [
                "apiKey" : key,
                "userName" : apiAuthenticateUserName,
                "data" : st
            ]
            
            print(parametersHome)
            
            self.DocumentApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                Alert.HideProgressHud(Onview: self.view)
                
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    if responseObject?["status"] as! String == "Success" {
                        
                        self.delegate?.updateOrderList()
                        
                        let alert = UIAlertController(title: "Success".localized(lang: langCode), message: "Documents Upload".localized(lang: langCode),         preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK".localized(lang: langCode), style: UIAlertActionStyle.default, handler: { _ in
                            
                            let vc = OrderFinalVC()
                            vc.finalPrice = self.getFinalPrice5
                            vc.orderID = self.placedOrderId
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        Alert.showAlert(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                    
                }
                else
                {
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                    
                    /*
                    self.delegate?.updateOrderList()
                    let alertController = UIAlertController(title: "Upload Bill", message: "Successfully!", preferredStyle: .alert)
                    
                    let sendButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertController.addAction(sendButton)
                    
                    self.navigationController!.present(alertController, animated: true, completion: nil)
                    */
                }
            })
            
        }
        else
        {
            Alert.showAlertWithError(strMessage: "No connection found".localized(lang: langCode) as NSString, Onview: self)
        }
    }
    
    
    //MARK:- webservice Set Payment detaisl
    
    func setPaymentDetailsApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func setPaymentDetailsFromServer() {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var jsonString = ""
            
            if selectePaymentType5 == "NEFT" || selectePaymentType5 == "IMPS" {
                
                let info = ["Account_Holders_Name":bankDETAILS["Account_Holders_Name"] ?? "",
                    "Bank_Name":bankDETAILS["Bank_Name"] ?? "",
                    "Account_Number":bankDETAILS["Account_Number"] ?? "",
                    "IFSC":bankDETAILS["IFSC"] ?? "",
                    "Bank_Branch":bankDETAILS["Bank_Branch"] ?? ""]
                
                let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
            }else {
                
                let info = [userDetails5["mobile"] ?? ""]
                
                let jsonData = try! JSONSerialization.data(withJSONObject: info, options:[])
                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
            }
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "setPaymentDetails"
            
            let parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
                "customerId":CustomUserDefault.getUserId(),
                "orderItemId" : self.quatationId5,
                "paymentInformation" : jsonString,
                "isOffer" : "1",
                "paymentCode": selectePaymentType5,
            ]
            
            self.setPaymentDetailsApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        self.fetchOrderFromServer(isRefreshPrice: true) //Scenario Change
                        
                    }
                    else{
                        // failed
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    
    //MARK:- webservice orderCreate
    
    func orderCreateApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>),
                        completionHandler: completionHandler)
    }
    
    func fetchOrderFromServer(isRefreshPrice:Bool) {
        
        if reachability?.connection.description != "No Connection" {
            
            Alert.ShowProgressHud(Onview: self.view)
            
            var producdID = ""
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
            }
            
            var strValue = ""
            var userSelectedProductAppcodes = ""
            
            let strFailedTest = userDefaults.value(forKeyPath: "failedDiagnosData") as! String
            let strQuestionAppCodes =  userDefaults.value(forKey: "Final_AppCodes") as! String
            
            if userDefaults.value(forKeyPath: "OrderPlaceFordiagnosis") as! Bool  == true {
                producdID = CustomUserDefault.getProductId()
                strValue = "STON01,"
                
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes + "," + strFailedTest
            }
            else {
                producdID = userDefaults.value(forKey: "otherProductDeviceID") as! String
                strValue = ""
                userSelectedProductAppcodes =  strValue + strQuestionAppCodes
            }
            
            let strFinalCodeValues = userSelectedProductAppcodes.replacingOccurrences(of: ",,", with: ",")
            let converComaToSemocolumForProductValues = strFinalCodeValues.replacingOccurrences(of: ",", with: ";")
            
            
            var strGCMToken = ""
            if (userDefaults.value(forKey: "FCMToken") != nil) {
                strGCMToken = userDefaults.value(forKey: "FCMToken") as! String
            }
            else {
                strGCMToken = ""
            }
            
            let couponAmount = String(format: "%d", (userDefaults.value(forKeyPath: "couponCodePrice") as? Int)!)
            
            var strPromoterId = ""
            if userDefaults.value(forKey: "promoter_id") == nil {
                strPromoterId = ""
            }
            else {
                strPromoterId = userDefaults.value(forKey: "promoter_id") as! String
            }
            
            //Sameer - 28/3/20
            if userDefaults.value(forKey: "promoterID") == nil {
                strPromoterId = ""
            }
            else{
                strPromoterId = userDefaults.value(forKey: "promoterID") as! String
            }
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl = strBaseURL + "orderCreate"
            
            var smallParam = ["IMEINumber" : KeychainWrapper.standard.string(forKey: "UUIDValue") ?? "",
                              "name" : userDetails5["name"] ?? "",
                              "email" : userDetails5["email"] ?? "",
                              "mobile" : userDetails5["mobile"] ?? "",
                              "address1" : userDetails5["address1"] ?? "",
                              "address2" : userDetails5["address1"] ?? "",
                              "pincode" : userDetails5["pincode"] ?? "",
                              "city" : userDetails5["city"] ?? "",
                              "paymentType" : selectePaymentType5,
                              ]
            
            
            smallParam["Account_Holders_Name"] = bankDETAILS["Account_Holders_Name"] ?? ""
            smallParam["Bank_Name"] = bankDETAILS["Bank_Name"] ?? ""
            smallParam["Account_Number"] = bankDETAILS["Account_Number"] ?? ""
            smallParam["Confirm_Account_Number"] = bankDETAILS["Account_Number"] ?? ""
            smallParam["IFSC"] = bankDETAILS["IFSC"] ?? ""
            
            
            smallParam["type"] = "createOrder"
            smallParam["isNewAddress"] = "1"
            //smallParam["donateTo"] = "NSS"
            //smallParam["donateAmount"] = "31"
            
            if donation5 == "" {
                smallParam["donateTo"] = ""
                smallParam["donationAmount"] = ""
            }else {
                //smallParam["donateTo"] = "NSS"
                //smallParam["donateAmount"] = donation5
                
                smallParam["donateTo"] = "NSS"
                smallParam["donationAmount"] = donation5
            }
            
            var parametersHome : [String : Any] = [
                "userName" : apiAuthenticateUserName, //1
                "apiKey" : key, //1
                "mobile":CustomUserDefault.getPhoneNumber() ?? "",
                "name":CustomUserDefault.getUserName() ?? "",
                "address":userDefaults.value(forKey: "placeOrderAddress") as? String ?? "", //1
                
                "city":CustomUserDefault.getCityId(), //1
                
                ////////////////////////////////////////////////////////////
                "productId":producdID, //1
                "conditionString":converComaToSemocolumForProductValues, //1
                "diagnosisId":userDefaults.value(forKey: "diagnosisId") as! String, //1
                "processMode":self.strPaymentProcessMode, //1
                ////////////////////////////////////////////////////////////
                
                //"remark":"", //0
                "email":CustomUserDefault.getUserEmail() ?? "", //0
                //"productImage":userDefaults.value(forKey: "otherProductDeviceImage") as! String, //0
                //"GCMId":strGCMToken, //0
                "customerId":CustomUserDefault.getUserId(), //0
                //"landmark":"", //0
                "pincode":userDefaults.value(forKey: "orderPinCode") as? String ?? "", //1
                "isNewAddress":"1", //0
                
                "uniqueIdentifire":KeychainWrapper.standard.string(forKey: "UUIDValue")! + "~" + KeychainWrapper.standard.string(forKey: "UUIDValue")!, //1
                "paymentCode": selectePaymentType5, //1
                
                "couponCode":userDefaults.value(forKey: "orderPromoCode") as? String ?? "", //1
                "couponAmount":couponAmount, //1
                "promoterId":strPromoterId, //0
                
                //"paymentDetails" : smallParam,
                "donateTo" : "NSS",
                "donationAmount" : donation5,
                
                
                "quotationId":quatationId5, //0
                "preferredDate":"", //0
                "preferredTime":"", //0
                //"additionalInformation":"", //0
            ]
            
            if let addInfo = userDefaults.value(forKey: "additionalInfo") {
                parametersHome["additionalInformation"] = addInfo
            }
            
            print(strUrl)
            print(parametersHome)
            
            self.orderCreateApiPost(strURL: strUrl, parameters: parametersHome as NSDictionary, completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                print("\(String(describing: responseObject) ) , \(String(describing: error))")
                
                if error == nil {
                    if responseObject?["status"] as! String == "Success" {
                        
                        /*
                         UIViewController().showAlert("InstaCash", message: "Your order has been successfully placed.", alertButtonTitles: ["OK"], alertButtonStyles: [.default], vc: self
                         , completion: { (ind) in
                         
                         //let vc = HomeVC()
                         //self.navigationController?.pushViewController(vc, animated: true)
                         })
                         */
                        
                        //Sameer 2/6/2020
                        Analytics.logEvent("purchase", parameters: ["currency" : CustomUserDefault.getCurrency(),
                                                                      "item_id" : CustomUserDefault.getProductId(),
                                                                      "item_name" : self.strProductName5 ])
                        
                        
                        self.placedOrderId = responseObject?["msg"] as? String ?? ""
 
                        
                        /*
                        //let itemID = responseObject?["itemId"] as! String
                        if let orderID = responseObject?["orderId"] as? String {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = orderID
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            let vc = UploadDocumentVC()
                            vc.strOrderItemId = ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        */
                        
                    }
                    else{
                        // failed
                        Alert.showAlertWithError(strMessage: responseObject?["msg"]  as! NSString, Onview: self)
                    }
                }
                else{
                    debugPrint(error as Any)
                    Alert.showAlertWithError(strMessage: "Seems connection loss from server".localized(lang: langCode) as NSString, Onview: self)
                }
            })
            
        }else{
            Alert.showAlertWithError(strMessage: "No Connection Found".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    
}
