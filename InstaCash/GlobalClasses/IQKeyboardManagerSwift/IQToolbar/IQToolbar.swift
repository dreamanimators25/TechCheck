

import UIKit

/** @abstract   IQToolbar for IQKeyboardManager.    */
open class IQToolbar: UIToolbar , UIInputViewAudioFeedback {

    private static var _classInitialize: Void = classInitialize()
    
    private class func classInitialize() {
        
        let  appearanceProxy = self.appearance()

        appearanceProxy.barTintColor = nil
        
        let positions : [UIBarPosition] = [.any,.bottom,.top,.topAttached];

        for position in positions {

            appearanceProxy.setBackgroundImage(nil, forToolbarPosition: position, barMetrics: .default)
            appearanceProxy.setShadowImage(nil, forToolbarPosition: .any)
        }

        //Background color
        appearanceProxy.backgroundColor = nil
    }
    
    /**
     Previous bar button of toolbar.
     */
    private var privatePreviousBarButton: IQBarButtonItem?
    open var previousBarButton : IQBarButtonItem {
        get {
            if privatePreviousBarButton == nil {
                privatePreviousBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
                privatePreviousBarButton?.accessibilityLabel = "Toolbar Previous Button"
            }
            return privatePreviousBarButton!
        }
        
        set (newValue) {
            privatePreviousBarButton = newValue
        }
    }
    
    /**
     Next bar button of toolbar.
     */
    private var privateNextBarButton: IQBarButtonItem?
    open var nextBarButton : IQBarButtonItem {
        get {
            if privateNextBarButton == nil {
                privateNextBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
                privateNextBarButton?.accessibilityLabel = "Toolbar Next Button"
            }
            return privateNextBarButton!
        }
        
        set (newValue) {
            privateNextBarButton = newValue
        }
    }
    
    /**
     Title bar button of toolbar.
     */
    private var privateTitleBarButton: IQTitleBarButtonItem?
    open var titleBarButton : IQTitleBarButtonItem {
        get {
            if privateTitleBarButton == nil {
                privateTitleBarButton = IQTitleBarButtonItem(title: nil)
                privateTitleBarButton?.accessibilityLabel = "Toolbar Title Button"
            }
            return privateTitleBarButton!
        }
        
        set (newValue) {
            privateTitleBarButton = newValue
        }
    }
    
    /**
     Done bar button of toolbar.
     */
    private var privateDoneBarButton: IQBarButtonItem?
    open var doneBarButton : IQBarButtonItem {
        get {
            if privateDoneBarButton == nil {
                privateDoneBarButton = IQBarButtonItem(title: nil, style: .done, target: nil, action: nil)
                privateDoneBarButton?.accessibilityLabel = "Toolbar Done Button"
            }
            return privateDoneBarButton!
        }
        
        set (newValue) {
            privateDoneBarButton = newValue
        }
    }

    override init(frame: CGRect) {
        _ = IQToolbar._classInitialize
        super.init(frame: frame)
        
        sizeToFit()
        autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.isTranslucent = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        _ = IQToolbar._classInitialize
        super.init(coder: aDecoder)

        sizeToFit()
        autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.isTranslucent = true
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }

    override open var tintColor: UIColor! {
        
        didSet {
            if let unwrappedItems = items {
                for item in unwrappedItems {
                    item.tintColor = tintColor
                }
            }
        }
    }
    
    override open var barStyle: UIBarStyle {
        didSet {
            
            if barStyle == .default {
                titleBarButton.selectableTextColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
            } else {
                titleBarButton.selectableTextColor = UIColor.yellow
            }
        }
    }
    
    override open func layoutSubviews() {

        super.layoutSubviews()

        //If running on Xcode9 (iOS11) only then we'll validate for iOS version, otherwise for older versions of Xcode (iOS10 and below) we'll just execute the tweak
#if swift(>=3.2)

        if #available(iOS 11, *) {
            return
        } else if let customTitleView = titleBarButton.customView {
            var leftRect = CGRect.null
            var rightRect = CGRect.null
            var isTitleBarButtonFound = false
            
            let sortedSubviews = self.subviews.sorted(by: { (view1 : UIView, view2 : UIView) -> Bool in
                
                let x1 = view1.frame.minX
                let y1 = view1.frame.minY
                let x2 = view2.frame.minX
                let y2 = view2.frame.minY
                
                if x1 != x2 {
                    return x1 < x2
                } else {
                    return y1 < y2
                }
            })
            
            for barButtonItemView in sortedSubviews {
                
                if isTitleBarButtonFound == true {
                    rightRect = barButtonItemView.frame
                    break
                } else if barButtonItemView === customTitleView {
                    isTitleBarButtonFound = true
                    //If it's UIToolbarButton or UIToolbarTextButton (which actually UIBarButtonItem)
                } else if barButtonItemView.isKind(of: UIControl.self) == true {
                    leftRect = barButtonItemView.frame
                }
            }
            
            let titleMargin : CGFloat = 16

            let maxWidth : CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
            let maxHeight = self.frame.height
            
            let sizeThatFits = customTitleView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            
            var titleRect : CGRect
            
            if sizeThatFits.width > 0 && sizeThatFits.height > 0 {
                let width = min(sizeThatFits.width, maxWidth)
                let height = min(sizeThatFits.height, maxHeight)
                
                var x : CGFloat

                if (leftRect.isNull == false) {
                    x = titleMargin + leftRect.maxX + ((maxWidth - width)/2)
                } else {
                    x = titleMargin
                }
                
                let y = (maxHeight - height)/2
                
                titleRect = CGRect(x: x, y: y, width: width, height: height)
            } else {
                
                var x : CGFloat
                
                if (leftRect.isNull == false) {
                    x = titleMargin + leftRect.maxX
                } else {
                    x = titleMargin
                }

                let width : CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
                
                titleRect = CGRect(x: x, y: 0, width: width, height: maxHeight)
            }
            
            customTitleView.frame = titleRect
        }
    
#else
        if let customTitleView = titleBarButton.customView {
            var leftRect = CGRect.null
            var rightRect = CGRect.null
            var isTitleBarButtonFound = false
            
            let sortedSubviews = self.subviews.sorted(by: { (view1 : UIView, view2 : UIView) -> Bool in
                
                let x1 = view1.frame.minX
                let y1 = view1.frame.minY
                let x2 = view2.frame.minX
                let y2 = view2.frame.minY
                
                if x1 != x2 {
                    return x1 < x2
                } else {
                    return y1 < y2
                }
            })
            
            for barButtonItemView in sortedSubviews {
                
                if isTitleBarButtonFound == true {
                    rightRect = barButtonItemView.frame
                    break
                } else if barButtonItemView === titleBarButton.customView {
                    isTitleBarButtonFound = true
                    //If it's UIToolbarButton or UIToolbarTextButton (which actually UIBarButtonItem)
                } else if barButtonItemView.isKind(of: UIControl.self) == true {
                    leftRect = barButtonItemView.frame
                }
            }
            
            let titleMargin : CGFloat = 16
            let maxWidth : CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
            let maxHeight = self.frame.height
            
            let sizeThatFits = customTitleView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            
            var titleRect : CGRect

            if sizeThatFits.width > 0 && sizeThatFits.height > 0 {
                let width = min(sizeThatFits.width, maxWidth)
                let height = min(sizeThatFits.height, maxHeight)
                
                var x : CGFloat
                
                if (leftRect.isNull == false) {
                    x = titleMargin + leftRect.maxX + ((maxWidth - width)/2)
                } else {
                    x = titleMargin
                }

                let y = (maxHeight - height)/2
                
                titleRect = CGRect(x: x, y: y, width: width, height: height)
            } else {
                
                var x : CGFloat
                
                if (leftRect.isNull == false) {
                    x = titleMargin + leftRect.maxX
                } else {
                    x = titleMargin
                }

                let width : CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
                
                titleRect = CGRect(x: x, y: 0, width: width, height: maxHeight)
            }
            
            customTitleView.frame = titleRect
        }
#endif
    }
    
    open var enableInputClicksWhenVisible: Bool {
        return true
    }
}
