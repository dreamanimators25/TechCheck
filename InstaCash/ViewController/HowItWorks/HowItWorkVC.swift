//
//  HowItWorkVC.swift
//  TechCheck
//
//  Created by TechCheck on 27/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class HowItWorkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        self.setStatusBarColor()
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "TechCheck"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "sideMenu"), for: .normal)
        btnMenu.addTarget(self, action: #selector(HowItWorkVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        
        self.menuContainerViewController.toggleLeftSideMenuCompletion({() -> Void in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
