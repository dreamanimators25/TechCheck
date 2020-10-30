//  GradientView.swift
//  DoctorPatient
//  Created by Fusion Admin on 02/06/18.
//  Copyright © 2018 Raj Oriya. All rights reserved.

import UIKit

@IBDesignable class GradientView: UIView {

    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [UIColor().gradientGreenFirstColor().cgColor, UIColor().gradientGreenSecondColor().cgColor]
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}


@IBDesignable class shadowCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            
            self.layer.masksToBounds = false
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = 1
            
            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
            
            setNeedsLayout()
        }
    }
}


@IBDesignable class GradientViewNew: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [UIColor().HexToColor(hexString:"#00848D").cgColor, UIColor().HexToColor(hexString:"#75559E").cgColor]
        
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

@IBDesignable class GradientButton: UIButton {
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as! CAGradientLayer
        self.gradientLayer.colors = [UIColor().gradientGreenSecondColor().cgColor, UIColor().gradientGreenThirdColor().cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

@IBDesignable class cornerImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

@IBDesignable class cornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
}

@IBDesignable class shadowCornerButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
//    @IBInspectable var shadowRadius: CGFloat = 0 {
//        didSet {
//
//            self.layer.masksToBounds = false
//            self.layer.shadowOffset = CGSize(width: 0, height: 3)
//            self.layer.shadowColor = UIColor.lightGray.cgColor
//            self.layer.shadowRadius = shadowRadius
//            self.layer.shadowOpacity = 1
//
//            let backgroundCGColor = backgroundColor?.cgColor
//            backgroundColor = nil
//            layer.backgroundColor =  backgroundCGColor
//
//            setNeedsLayout()
//        }
//    }
}

extension UIColor
{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor
    {
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    func intFromHexString(hexStr: String) -> UInt32
    {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    
    func gradientTechCheckFirstColor() -> UIColor
    {
        return UIColor().HexToColor(hexString:"591091")
    }
    
    
    func gradientGreenFirstColor() -> UIColor
    {
        return UIColor().HexToColor(hexString:"73DC95")
    }
    
    func gradientGreenSecondColor() -> UIColor
    {
        return UIColor().HexToColor(hexString:"28B03D")
    }
    
    func gradientGreenThirdColor() -> UIColor
    {
        return UIColor().HexToColor(hexString:"179A2B")
    }
    
    func colorGreen() -> UIColor
    {
        return UIColor().HexToColor(hexString:"189B2C")
    }
}
