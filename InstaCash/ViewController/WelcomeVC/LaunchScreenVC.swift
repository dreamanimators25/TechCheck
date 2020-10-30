//
//  LaunchScreenVC.swift
//  TechCheck
//
//  Created by sameer khan on 05/10/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import WebKit

class LaunchScreenVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var deadPixelInfoImage: UIImageView!
    @IBOutlet weak var viewForWeb: UIView!

    var webView: WKWebView!
    var isComeFrom: String?
    var loadableUrlStr: String?
    var nav : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //DispatchQueue.main.async {
            //self.deadPixelInfoImage.loadGif(name: "splash_loader")
            
            /*
            // Load GIF In Image view
            let jeremyGif = UIImage.gifImageWithName("splash_loader")
            self.deadPixelInfoImage.image = jeremyGif
            self.deadPixelInfoImage.stopAnimating()
            self.deadPixelInfoImage.startAnimating()
            */
            
            self.LoadWebView()
        //}
        
        // Sameer 5/10/20
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if userDefaults.value(forKey: "baseURL") == nil {
                self.setRootViewController()
            }
            else{
                if CustomUserDefault.getCityId().isEmpty {
                    self.setRootViewController()
                }else {
                    self.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false, strAppCodeGet:"")
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Custom Methods
    func LoadWebView() {
        webView = self.addWKWebView(viewForWeb: viewForWeb)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //let myURL = URL(string: loadableUrlStr ?? "")
        //let myRequest = URLRequest(url: myURL!)
        //webView.load(myRequest)
        
        let url = Bundle.main.url(forResource: "splash_loader", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: NSURL() as URL)
        
        //add observer to get estimated progress value
        //self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func addWKWebView(viewForWeb:UIView) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: viewForWeb.frame, configuration: webConfiguration)
        webView.frame.origin = CGPoint.init(x: 0, y: 0)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame.size = viewForWeb.frame.size
        //webView.center = viewForWeb.center
        viewForWeb.addSubview(webView)
        return webView
    }
    
    //MARK:- Set root view
    func setRootViewController() {
        
        //if UIDevice.current.model.hasPrefix("iPad") {
            //let vc = IPadVC()
            //nav = UINavigationController.init(rootViewController: vc)
            //self.window?.rootViewController = nav
            //self.window?.makeKeyAndVisible()
        //}else {
            
            //nav = UINavigationController.init(rootViewController: vc)
            //nav?.navigationBar.isHidden = true
            let vc = CountryVC()
            self.navigationController?.pushViewController(vc, animated: true)
        
            //self.window?.rootViewController = nav
            //self.window?.makeKeyAndVisible()
        //}
        
    }
    
    func setRotControllersWithSideMenu(sendMyOrderArray:[HomeModel], sendBrandArray:[HomeModel], SendPupularDevoice:[HomeModel], SendMyCurrentDevice:[HomeModel], isComingFromWelcome:Bool, strAppCodeGet:String) {
        let vc = HomeVC()
        vc.arrMyOderGetData = sendMyOrderArray
        vc.arrBrandDeviceGetData = sendBrandArray
        vc.arrPopularDeviceGetData = SendPupularDevoice
        vc.arrMyCurrentDeviceSend = SendMyCurrentDevice
        vc.isComingFromWelcomeScreen = isComingFromWelcome
        //let leftVC:UIViewController = SideMenuVC()
        
        //let navVC:UINavigationController = UINavigationController(rootViewController: vc)
        //navVC.navigationBar.isHidden = true
        //let vc = MyOrderVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        //navVC.navigationBar.tintColor = navColor
        //let sideMenu:MFSideMenuContainerViewController = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: leftVC, rightMenuViewController: nil)
        //self.window?.rootViewController = navVC
        //self.window?.makeKeyAndVisible()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
