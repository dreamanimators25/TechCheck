//
//  LanguagePopUpVC.swift
//  TechCheck
//
//  Created by Sameer Khan on 04/04/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class LanguagePopUpVC: UIViewController {
    
    @IBOutlet weak var engView: UIView!
    @IBOutlet weak var hindiView: UIView!
    @IBOutlet weak var chinaView: UIView!
    
    @IBOutlet weak var engImgView: UIImageView!
    @IBOutlet weak var hindiImgView: UIImageView!
    @IBOutlet weak var chinaImgView: UIImageView!
    
    @IBOutlet weak var engLbl: UILabel!
    @IBOutlet weak var hindiLbl: UILabel!
    @IBOutlet weak var chinaLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var selectedLanguage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeLanguageOfUI()
        self.setModifiedUI()
    }
    
    //MARK: Custom Methods
    func changeLanguageOfUI() {
        
        selectedLanguage = userDefaults.getLanguageCode(key: "langCode") ?? "en"
        langCode = selectedLanguage
        
        self.engLbl.text = "English".localized(lang: langCode)
        self.hindiLbl.text = "Hindi".localized(lang: langCode)
        self.chinaLbl.text = "Chinese".localized(lang: langCode)
        
        self.cancelBtn.setTitle("Cancel".localized(lang: langCode), for: UIControlState.normal)
        self.saveBtn.setTitle("Save".localized(lang: langCode), for: UIControlState.normal)
        
    }
    
    func setModifiedUI() {
        
        switch self.selectedLanguage {
        case "en":
            self.btnEnglishLanguagePressed(UIButton())
        case "hi":
            self.btnHindiLanguagePressed(UIButton())
        default:
            self.btnChineseLanguagePressed(UIButton())
        }
        
        
        //English Language
        self.engView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.engView.layer.borderWidth = 0.8
        
        //Hindi Language
        self.hindiView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.hindiView.layer.borderWidth = 0.8
        
        //Chinese Language
        self.chinaView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.chinaView.layer.borderWidth = 0.8
        
    }

    //MARK: IBActions
    @IBAction func btnEnglishLanguagePressed(_ sender: UIButton) {
       
        self.selectedLanguage = "en"
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.engImgView.image = #imageLiteral(resourceName: "Selected")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "unCheck")
    }
    
    @IBAction func btnHindiLanguagePressed(_ sender: UIButton) {
       
        self.selectedLanguage = "hi"
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.engImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "Selected")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "unCheck")
    }
    
    @IBAction func btnChineseLanguagePressed(_ sender: UIButton) {
        
        self.selectedLanguage = "zh-Hans"
        
        //English Language
        self.engView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.engLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.engImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Hindi Language
        self.hindiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.hindiLbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.hindiImgView.image = #imageLiteral(resourceName: "unCheck")
        
        //Chinese Language
        self.chinaView.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.06274509804, blue: 0.568627451, alpha: 1)
        self.chinaLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.chinaImgView.image = #imageLiteral(resourceName: "Selected")
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSavePressed(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            userDefaults.saveLanguageCode(langCode: self.selectedLanguage)
            langCode = self.selectedLanguage
            //self.changeLanguageOfUI()
            
            if let chng = changeLanguage {
                chng()
            }
            
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
