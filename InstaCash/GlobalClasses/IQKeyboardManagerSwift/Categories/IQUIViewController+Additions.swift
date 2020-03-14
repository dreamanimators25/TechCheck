

import UIKit


private var kIQLayoutGuideConstraint = "kIQLayoutGuideConstraint"


public extension UIViewController {

    /**
    To set customized distance from keyboard for textField/textView. Can't be less than zero
     
     @deprecated    Library is internally handling Safe Area (If you are using Safe Area from Xcode9 and iOS11) and there is no need to do any tweak if you already migrated to use Safe Area
    */
    @available(iOS, deprecated: 11.0)
    @IBOutlet public var IQLayoutGuideConstraint: NSLayoutConstraint? {
        get {
            
            return objc_getAssociatedObject(self, &kIQLayoutGuideConstraint) as? NSLayoutConstraint
        }

        set(newValue) {
            objc_setAssociatedObject(self, &kIQLayoutGuideConstraint, newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
