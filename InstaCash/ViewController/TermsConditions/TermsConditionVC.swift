//
//  TermsConditionVC.swift
//  InstaCash
//
//  Created by InstaCash on 29/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class TermsConditionVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webViewTermCondition: UIWebView!
    let reachability: Reachability? = Reachability()
    var strURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        let getURL = URL(string:strURL)
        if reachability?.connection.description != "No Connection" {
            Alert.ShowProgressHud(Onview: self.view)
            let req = NSURLRequest(url: getURL!)
            webViewTermCondition.loadRequest(req as URLRequest)
        }
        else
        {
            Alert.showAlert(strMessage: "No internet conection".localized(lang: langCode) as NSString, Onview: self)
        }
        
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void {
        self.title = "Terms & Conditions".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(TermsConditionVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    //MARK:- webview delegates methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Alert.HideProgressHud(Onview: self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Alert.ShowProgressHud(Onview: self.view)
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
