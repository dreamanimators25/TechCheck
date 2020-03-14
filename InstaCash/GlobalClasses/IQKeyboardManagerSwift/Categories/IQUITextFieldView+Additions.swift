

import Foundation
import UIKit

/**
Uses default keyboard distance for textField.
*/
public let kIQUseDefaultKeyboardDistance = CGFloat.greatestFiniteMagnitude

private var kIQKeyboardDistanceFromTextField = "kIQKeyboardDistanceFromTextField"
private var kIQIgnoreSwitchingByNextPrevious = "kIQIgnoreSwitchingByNextPrevious"

/**
UIView category for managing UITextField/UITextView
*/
public extension UIView {

    /**
     To set customized distance from keyboard for textField/textView. Can't be less than zero
     */
    public var keyboardDistanceFromTextField: CGFloat {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQKeyboardDistanceFromTextField) as? CGFloat {
                return aValue
            } else {
                return kIQUseDefaultKeyboardDistance
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQKeyboardDistanceFromTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     If shouldIgnoreSwitchingByNextPrevious is true then library will ignore this textField/textView while moving to other textField/textView using keyboard toolbar next previous buttons. Default is false
     */
    public var ignoreSwitchingByNextPrevious: Bool {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

