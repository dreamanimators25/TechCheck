//
//  RatingVC.swift
//  InstaCash
//
//  Created by InstaCash on 23/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class RatingVC: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var lblTransactionId: UILabel!
    
    @IBOutlet weak var lblPaymentProcessed: UILabel!
    @IBOutlet weak var lblHowWas: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblPleaseTake: UILabel!
    @IBOutlet weak var lblIfYou: UILabel!
    
    
    let reachability: Reachability? = Reachability()
    var getTrsactID = ""
    var ratingCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
      
        self.lblPaymentProcessed.text = "Payment Processed".localized(lang: langCode)
        self.lblHowWas.text = "How was your experience with us?".localized(lang: langCode)
        
        self.btnSubmit.setTitle("Done".localized(lang: langCode), for: UIControlState.normal)
        
        self.lblPleaseTake.text = "Please take your SIM card out of the phone if it is present in this device".localized(lang: langCode)
        self.lblIfYou.text = "If you’d like to get your phone erased in front of you, please ask our executive to do a factory reset.".localized(lang: langCode)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRating.delegate = self
        viewRating.type = .halfRatings
        
        lblTransactionId.text = "Transaction Id :".localized(lang: langCode)  + getTrsactID
    }

    @IBAction func btnContinuePressed(_ sender: UIButton) {
        obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
    }
        
    func rating(){
        guard let url = URL(string: "https://itunes.apple.com/in/app/instacash-sell-used-phone/id1310320724?mt=8") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        
        if viewRating.rating != 0.00 {
            obj_app.setRotControllersWithSideMenu(sendMyOrderArray: [HomeModel](), sendBrandArray: [HomeModel](), SendPupularDevoice: [HomeModel](), SendMyCurrentDevice: [HomeModel](), isComingFromWelcome: false,strAppCodeGet:"")
        }
    }
    
}
