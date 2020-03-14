

import Foundation

///-----------------------------------
/// MARK: IQLayoutGuidePosition
///-----------------------------------

/**
`IQLayoutGuidePositionNone`
If there are no IQLayoutGuideConstraint associated with viewController

`IQLayoutGuidePositionTop`
If provided IQLayoutGuideConstraint is associated with with viewController topLayoutGuide

`IQLayoutGuidePositionBottom`
If provided IQLayoutGuideConstraint is associated with with viewController bottomLayoutGuide
*/
enum IQLayoutGuidePosition : Int {
    case none
    case top
    case bottom
}
