//
//  AboutUsVC.swift
//  InstaCash
//
//  Created by Sameer's MacBook Pro on 18/02/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

var aboutHTML : String?
var aboutTitleHTML : String?
var tncHTML : String?
var tncTitleHTML : String?
var howitWorkHTML : String?
var howitWorkTitleHTML : String?
var faqHTML : String?
var faqTitleHTML : String?

class AboutVC: UIViewController,CAPSPageMenuDelegate {
    
    let reachability: Reachability? = Reachability()
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fireWebServiceForAboutPageDetail()
        self.setUpPageMenu()
    }

    func setUpPageMenu() {
        //////..........CSPAGEMENU........../////
        var controllerArray : [UIViewController] = []
        
        //let controller1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpcomingMeetingVC") as! UpcomingMeetingVC
        let controller1 = AboutPageVC()
        controller1.title = "ABOUT"
        controllerArray.append(controller1)
        
        let controller2 = TnCPageVC()
        controller2.title = "TERMS & CONDITIONS"
        controllerArray.append(controller2)
        
        let controller3 = HowItWorkPageVC()
        controller3.title = "HOW IT WORK"
        controllerArray.append(controller3)
        
        let controller4 = FaqPageVC()
        controller4.title = "FAQ"
        controllerArray.append(controller4)
        
        // Customize menu (Optional)
        let parameters  = [
            CAPSPageMenuOptionScrollMenuBackgroundColor : UIColor.clear,
            CAPSPageMenuOptionViewBackgroundColor : UIColor.clear,
            CAPSPageMenuOptionSelectionIndicatorColor : #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1),
            CAPSPageMenuOptionUnselectedMenuItemLabelColor:UIColor.gray,
            CAPSPageMenuOptionBottomMenuHairlineColor : UIColor.white,
            CAPSPageMenuOptionSelectedMenuItemLabelColor : #colorLiteral(red: 0.1581287384, green: 0.6885935664, blue: 0.237049073, alpha: 1),
            CAPSPageMenuOptionMenuItemFont : UIFont(name: "Roboto-Medium", size: 15.0)!,
            
            CAPSPageMenuOptionMenuItemWidthBasedOnTitleTextWidth : true,
            CAPSPageMenuOptionCenterMenuItems : true,
            CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap : true,
            
            CAPSPageMenuOptionMenuHeight : 40.0,
            CAPSPageMenuOptionMenuItemWidth : 150,
            CAPSPageMenuOptionUseMenuLikeSegmentedControl : false,
            CAPSPageMenuOptionSelectionIndicatorHeight : 2.0,
            CAPSPageMenuOptionMenuItemSeparatorWidth : 1.0,
            CAPSPageMenuOptionEnableHorizontalBounce : true
            ] as [String : Any]
        
        // Initialize scroll menu
        var topHeight:CGFloat = 64.0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                //print("iPhone X")
                topHeight = 84.0
            default:
                break
            }
        }
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: topHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - topHeight ), options: parameters)
        pageMenu?.delegate = self
        self.view.addSubview(self.pageMenu!.view)
        self.addChildViewController(self.pageMenu!)
        self.willMove(toParentViewController: self.pageMenu)
        
    }
    
    //MARK : CSPageMenu Delegates
    func willMove(toPage controller: UIViewController!, index: Int) {
        //print(controller,index)
    }
    
    func didMove(toPage controller: UIViewController!, index: Int) {
        //print(controller,index)
    }
    
    //MARK: IBActions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- web service methods
    
    func FaqApiPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForAboutPageDetail()
    {
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            
            let strBaseURL = userDefaults.value(forKey: "baseURL") as! String
            let strUrl =  strBaseURL + "instacashInformation"
            var parameters = [String: Any]()
            
            parameters  = [
                "userName" : apiAuthenticateUserName,
                "apiKey" : key,
            ]
            
            print(parameters)
            
            self.FaqApiPost(strURL: strUrl, parameters: [:], completionHandler: {responseObject , error in
                
                Alert.HideProgressHud(Onview: self.view)
                
                print(responseObject ?? [:])
                
                if error == nil {
                    
                    aboutHTML = (responseObject?.value(forKey: "about_page") as? NSDictionary)?.value(forKey: "discription") as? String
                    aboutTitleHTML = (responseObject?.value(forKey: "about_page") as? NSDictionary)?.value(forKey: "title") as? String
                    
                    tncHTML = (responseObject?.value(forKey: "terms_conditions") as? NSDictionary)?.value(forKey: "discription") as? String
                    tncTitleHTML = (responseObject?.value(forKey: "terms_conditions") as? NSDictionary)?.value(forKey: "title") as? String
                    
                    howitWorkHTML = (responseObject?.value(forKey: "how_it_work") as? NSDictionary)?.value(forKey: "discription") as? String
                    howitWorkTitleHTML = (responseObject?.value(forKey: "how_it_work") as? NSDictionary)?.value(forKey: "title") as? String
                    
                    faqHTML = (responseObject?.value(forKey: "faq") as? NSDictionary)?.value(forKey: "discription") as? String
                    faqTitleHTML = (responseObject?.value(forKey: "faq") as? NSDictionary)?.value(forKey: "title") as? String
                    
                    if let htm = aboutText {
                        htm(aboutTitleHTML ?? "" , aboutHTML ?? "")
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
