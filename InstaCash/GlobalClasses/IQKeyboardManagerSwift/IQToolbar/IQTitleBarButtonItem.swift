
import Foundation
import UIKit

open class IQTitleBarButtonItem: IQBarButtonItem {
   
    open var titleFont : UIFont? {
    
        didSet {
            if let unwrappedFont = titleFont {
                _titleButton?.titleLabel?.font = unwrappedFont
            } else {
                _titleButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }

    override open var title: String? {
        didSet {
                _titleButton?.setTitle(title, for: UIControlState())
        }
    }
    
    /**
     selectableTextColor to be used for displaying button text when button is enabled.
     */
    open var selectableTextColor : UIColor? {
        
        didSet {
            if let color = selectableTextColor {
                _titleButton?.setTitleColor(color, for:UIControlState())
            } else {
                _titleButton?.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for:UIControlState())
            }
        }
    }

    /**
     Customized Invocation to be called on title button action. titleInvocation is internally created using setTitleTarget:action: method.
     */
    override open var invocation : (target: AnyObject?, action: Selector?) {

        didSet {
            
            if (invocation.target == nil || invocation.action == nil)
            {
                self.isEnabled = false
                _titleButton?.isEnabled = false
                _titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
            }
            else
            {
                self.isEnabled = true
                _titleButton?.isEnabled = true
                _titleButton?.addTarget(invocation.target, action: invocation.action!, for: .touchUpInside)
            }
        }
    }

    fileprivate var _titleButton : UIButton?
    fileprivate var _titleView : UIView?

    override init() {
        super.init()
    }
    
    convenience init(title : String?) {

        self.init(title: nil, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clear
        
        _titleButton = UIButton(type: .system)
        _titleButton?.isEnabled = false
        _titleButton?.titleLabel?.numberOfLines = 3
        _titleButton?.setTitleColor(UIColor.lightGray, for:.disabled)
        _titleButton?.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for:UIControlState())
        _titleButton?.backgroundColor = UIColor.clear
        _titleButton?.titleLabel?.textAlignment = .center
        _titleButton?.setTitle(title, for: UIControlState())
        titleFont = UIFont.systemFont(ofSize: 13.0)
        _titleButton?.titleLabel?.font = self.titleFont
        _titleView?.addSubview(_titleButton!)
        
#if swift(>=3.2)
        if #available(iOS 11, *) {
            
            var layoutDefaultLowPriority : UILayoutPriority
            var layoutDefaultHighPriority : UILayoutPriority

            #if swift(>=4.0)
                let layoutPriorityLowValue = UILayoutPriority.defaultLow.rawValue-1
                let layoutPriorityHighValue = UILayoutPriority.defaultHigh.rawValue-1
                layoutDefaultLowPriority = UILayoutPriority(rawValue: layoutPriorityLowValue)
                layoutDefaultHighPriority = UILayoutPriority(rawValue: layoutPriorityHighValue)
            #else
                layoutDefaultLowPriority = UILayoutPriorityDefaultLow-1
                layoutDefaultHighPriority = UILayoutPriorityDefaultHigh-1
            #endif
            
            _titleView?.translatesAutoresizingMaskIntoConstraints = false
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)
            
            _titleButton?.translatesAutoresizingMaskIntoConstraints = false
            _titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            _titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            _titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            _titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)

            let top = NSLayoutConstraint.init(item: _titleButton!, attribute: .top, relatedBy: .equal, toItem: _titleView, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint.init(item: _titleButton!, attribute: .bottom, relatedBy: .equal, toItem: _titleView, attribute: .bottom, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint.init(item: _titleButton!, attribute: .leading, relatedBy: .equal, toItem: _titleView, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint.init(item: _titleButton!, attribute: .trailing, relatedBy: .equal, toItem: _titleView, attribute: .trailing, multiplier: 1, constant: 0)
            
            _titleView?.addConstraints([top,bottom,leading,trailing])
        } else {
            _titleView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            _titleButton?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        }
#else
    _titleView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    _titleButton?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
#endif

        customView = _titleView
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
