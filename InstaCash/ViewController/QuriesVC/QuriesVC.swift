//
//  QuriesVC.swift
//  InstaCash
//
//  Created by InstaCash on 26/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuriesVC: UIViewController {
    
    @IBOutlet weak var lblAlmostDone: UILabel!
    @IBOutlet weak var lblPleaseTellUs: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var resultJSON = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.lblAlmostDone.text = "Almost Done!!".localized(lang: langCode)
        self.lblPleaseTellUs.text = "Please tell us about a few physical details of your phone.".localized(lang: langCode)
        
        self.btnContinue.setTitle("CONTINUE".localized(lang: langCode), for: UIControlState.normal)
    }
    
    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "Physical condition related quries".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let btnBack = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(QuriesVC.btnBackPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- button action methods
    
    @objc func btnBackPressed() -> Void {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- button action methods
    
    @IBAction func onClickBack(_ sender: Any) {
        //_ = self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        //let vc = FirstDiagnosisQuestionVC()
        let vc = DiagnosisQuestionFlowVC()
        vc.resultJSON = self.resultJSON
        self.navigationController?.pushViewController(vc, animated: true)
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
