//
//  WelcomeVC.swift
//  InstaCash
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import MFSideMenu

class WelcomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pageControllerWelcome: UIPageControl!
    @IBOutlet weak var collectionViewWelcome: UICollectionView!
    
    var arrImages = [UIImage]()
    var arrTitle = [String]()
    var arrDescription = [String]()
    var pageCount = 0
    var arrPopularDeviceDataSend = [HomeModel]()
    var arrBrandDeviceDataSend = [HomeModel]()
    var arrMyOrderSend = [HomeModel]()
    var arrMyCurrentDeviceSend = [HomeModel]()
    var strAppModeCodeGet = ""
    var isWelcomeSend = false


    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    let reachability: Reachability? = Reachability()

    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register collectionview cell
         collectionViewWelcome.register(UINib(nibName: "WelcomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "welcomeCollectionViewCell")
        
        //Set navigation Bar
        setNavBar()
        
        //Set array static values
        arrTitle = ["Product","Diagnose","Value","Pickup","Payment"]
        arrDescription = ["Select the Product and conditions you wish to sell","Diagnose your device for any functional issues","Get immediate price for it","Quick pickup of the device from your doorstep","Get paid for the device Immediately after pickup"]
        arrImages = [UIImage(named: "welcome1"),UIImage(named: "welcome2"),UIImage(named: "welcome3"),UIImage(named: "welcome4"),UIImage(named: "welcome5")] as! [UIImage]
        
        //get home data
        if reachability?.connection.description != "No Connection"{
            HomeModel.fetchHomeData(isInterNet:true, isappModeCode:"",getController: self) { (arrBrandDeviceDataSend,arrPopularDeviceDataSend,arrMyOrderSend,arrMyCurrentDeviceSend,strAppModeCodeGet) in
                Alert.HideProgressHud(Onview: self.view)
                if arrBrandDeviceDataSend.count > 0{
                    self.strAppModeCodeGet = strAppModeCodeGet
                    self.arrPopularDeviceDataSend = arrPopularDeviceDataSend
                    self.arrBrandDeviceDataSend = arrBrandDeviceDataSend
                    self.arrMyOrderSend = arrMyOrderSend
                    self.arrMyCurrentDeviceSend = arrMyCurrentDeviceSend
                    self.isWelcomeSend = true
                }
                else{
                    self.isWelcomeSend = false
                }
            }
        }
        else{
           
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Disable gesture pop to controller
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    //MARK: set nav bar
    func setNavBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "welcomeCollectionViewCell", for: indexPath) as! WelcomeCollectionViewCell
        //Fill statck values according to array
            cell.lblTitle.text = arrTitle[indexPath.row].localized(lang: langCode)
            cell.lblDescription.text = arrDescription[indexPath.row].localized(lang: langCode)
            cell.imgLogo.image = arrImages[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height:collectionView.frame.height)
    }
    
     func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1

        }
    }
    //MARK:- Button Action Methods
    @IBAction func btnDonePressed(_ sender: UIButton) {

        obj_app.setRotControllersWithSideMenu(sendMyOrderArray: arrMyOrderSend, sendBrandArray: arrBrandDeviceDataSend, SendPupularDevoice: arrPopularDeviceDataSend, SendMyCurrentDevice: arrMyCurrentDeviceSend, isComingFromWelcome: isWelcomeSend, strAppCodeGet: self.strAppModeCodeGet)

    }
    @IBAction func btnArrowPressed(_ sender: UIButton) {
        btnArrow.isUserInteractionEnabled = false
        let collectionBounds = collectionViewWelcome.bounds
        let contentOffset = CGFloat(floor(collectionViewWelcome.contentOffset.x + collectionBounds.size.width))
        moveCollectionFrameToRight(contentOffset: contentOffset)
        let currentIndex:CGFloat = collectionViewWelcome.contentOffset.x / collectionViewWelcome.frame.size.width
        pageControllerWelcome.currentPage = Int(currentIndex) + 1
        pageCount = Int(currentIndex + 1)
        hideUnhideArrowAndDoneButton(withPageCount: pageCount)

    }
    
    //MARK:- Method to scroll collection view
    func moveCollectionFrameToRight(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : collectionViewWelcome.contentOffset.y ,width : collectionViewWelcome.frame.width,height : collectionViewWelcome.frame.height)
        collectionViewWelcome.scrollRectToVisible(frame, animated: true)
       
    }
    
    //MARK:- scrool view delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex:CGFloat = collectionViewWelcome.contentOffset.x / collectionViewWelcome.frame.size.width
        pageControllerWelcome.currentPage = Int(currentIndex)
        pageCount = Int(currentIndex)
        hideUnhideArrowAndDoneButton(withPageCount: pageCount)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        btnArrow.isUserInteractionEnabled = true
    }
    
    //MARK:- method to hide/UnHide
    func hideUnhideArrowAndDoneButton(withPageCount:Int){
        if withPageCount == 4{
            btnDone.isHidden = false
            btnDone.isUserInteractionEnabled = true
            btnArrow.isHidden = true
            btnArrow.isUserInteractionEnabled = false
        }
        else{
            btnDone.isHidden = true
            btnDone.isUserInteractionEnabled = false
            btnArrow.isHidden = false
            //btnArrow.isUserInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
