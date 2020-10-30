//
//  QuestionFlowModel.swift
//  TechCheck
//
//  Created by TechCheck on 19/09/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import Foundation
import UIKit

class QuestionFlowModel{
    
var strProductName:String?
var strProductId:String?
var arrQuestionList = NSArray()

init(questionsDict: [String: Any]) {
    
    self.strProductId = questionsDict["id"] as? String
    self.strProductName = questionsDict["city"] as? String
    self.arrQuestionList = questionsDict["questions"] as! NSArray

}


}
