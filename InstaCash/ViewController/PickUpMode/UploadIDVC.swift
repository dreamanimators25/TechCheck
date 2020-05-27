//
//  UploadIDVC.swift
//  InstaCash
//
//  Created by InstaCash on 22/10/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit

class UploadIDVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var titleInfoLbl: UILabel!
    @IBOutlet weak var btnUploadIdImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguageOfUI()
    }
    
    func changeLanguageOfUI() {
        
        self.titleInfoLbl.text = "Press the button below to upload image of a valid Id Proof of the customer.".localized(lang: langCode)
        
        self.btnUploadIdImage.setTitle("Upload ID proof".localized(lang: langCode), for: UIControlState.normal)
    }

    // MARK:- navigation bar setup.
    func setNavigationBar() -> Void
    {
        self.title = "UPLOAD Document".localized(lang: langCode)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = navColor
        let btnMenu = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 25, height: 25)))
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        btnMenu.setImage(UIImage(named: "back"), for: .normal)
        btnMenu.addTarget(self, action: #selector(UploadIDVC.btnSideMenuPressed), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- button action methods
    @objc func btnSideMenuPressed() -> Void {
        self.dismiss(animated: true, completion: nil)
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
        let image = UIImagePickerController()
        image.delegate = self
        
        if src == "Photo Library" {
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if src == "Camera" {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                image.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                print("not select")
            }
        }
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // code
        }
    }
    
    //MARK:- image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.3)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
       // self.strImageSendToServer = strBase64
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            let vc =  SignatureVC()
            vc.strGetUploadBill = strBase64
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnUploadIDPressed(_ sender: UIButton) {
        SetActionSetForMoreOptionAttachment()
    }
    

}
