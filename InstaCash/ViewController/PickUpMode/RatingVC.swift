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
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblTransactionId: UILabel!
    let reachability: Reachability? = Reachability()
    var getTrsactID = ""

    var ratingCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRating.delegate = self
        viewRating.type = .halfRatings
        
        lblTransactionId.text = "Transaction Id :"  + getTrsactID
        // Do any additional setup after loading the view.
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
