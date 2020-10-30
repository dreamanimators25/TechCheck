//
//  TechCheck
//
//  Created by Prakhar Gupta on 9/5/18.
//  Copyright © 2018 Prakhar Gupta. All rights reserved.
//

import UIKit
import Alamofire
class WebServies: NSObject {
    
        func postRequest(urlString: String, paramDict:Dictionary<String, AnyObject>? = nil,
                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
                    
        Alamofire.request(urlString, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
//                if let data = response.result.value{
//                    print(data)
//                }
                completionHandler(response.result.value as! NSDictionary?, nil)                
            case .failure(_):
//                if let data = response.result.value{
//                    print(data)
//                }
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
        }
        
    }
    
    /*
    func postRequest1(urlString: String, paramDict:Dictionary<String, AnyObject>? = nil,
                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        let head = ["application/json" : "Content-Type"]
        
        Alamofire.request(urlString, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: nil).responseString { (response:DataResponse<String>) in
            
            switch(response.result) {
            case .success(_):
                
                completionHandler(response.result.value as! NSDictionary?, nil)
            case .failure(_):
               
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
            
        }
        
        Alamofire.request(urlString, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: head).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                //                if let data = response.result.value{
                //                    print(data)
                //                }
                completionHandler(response.result.value as! NSDictionary?, nil)
            case .failure(_):
                //                if let data = response.result.value{
                //                    print(data)
                //                }
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
        }
        
    }*/

    
    func getRequest(urlString: String, paramDict:Dictionary<String, AnyObject>? = nil,
                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
       
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
          if response.response?.statusCode == 200
          {
            switch(response.result) {
            case .success(_):
                

                completionHandler(response.result.value as! NSDictionary?, nil)
                
            case .failure(_):
                
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
        }
            else
          {
            completionHandler(nil, response.result.error as NSError?)

            }
        }
    }
    
    func uploadImageWithParameter(urlString: String, image : UIImage , paramDict:Dictionary<String, AnyObject>? = nil,
                       completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        Manager.upload(multipartFormData: { (multipartFormData) in
            
            
            if let imageData = UIImageJPEGRepresentation(image, 0.2){
                
                        multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                    }
            
            
            for (key, value) in paramDict! {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }

        }, to: urlString , encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if response.result.isSuccess
                    {
                        if response.result.value != nil
                        {
                            completionHandler(response.result.value as! NSDictionary? , nil)
                        }
                    }
                    else if response.result.isFailure {
                        
                        completionHandler(nil , response.result.error as NSError?)
                    }
                    
                }
            case .failure( _):
                
                break
            }
        
        })
    }
    
    func uploadMultipleImageWithParameter(urlString: String, imageLicense : UIImage , imageTin : UIImage , paramDict:Dictionary<String, AnyObject>? = nil,
                                          completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        Manager.upload(multipartFormData: { (multipartFormData) in
            
            
                if  let imageData = UIImageJPEGRepresentation(imageLicense,1) {
                     multipartFormData.append(imageData, withName: "driving_liscence", fileName: "driving_liscence.png", mimeType: "image/png")
                }
            
           
                if  let imageData2 = UIImageJPEGRepresentation(imageTin,1) {
                   multipartFormData.append(imageData2, withName: "tin", fileName: "tin.png", mimeType: "image/png")
                }
            
            for (key, value) in paramDict! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: urlString , encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if response.result.isSuccess
                    {
                        if response.result.value != nil
                        {
                            completionHandler(response.result.value as! NSDictionary? , nil)
                        }
                    }
                    else if response.result.isFailure {
                        
                        completionHandler(nil , response.result.error as NSError?)
                    }
                    
                }
            case .failure( _):
                
                break
            }
            
        })
    }
    
    
    func uploadAddDriverApi(urlString: String, profileImg : UIImage, imageLicense : UIImage , imageTin : UIImage , paramDict:Dictionary<String, AnyObject>?,
                                          completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        Manager.upload(multipartFormData: { (multipartFormData) in
            
            
            if  let imageData = UIImageJPEGRepresentation(profileImg,1) {
                multipartFormData.append(imageData, withName: "profile_image", fileName: "profile_image.png", mimeType: "image/png")
            }
            
            if  let imageData = UIImageJPEGRepresentation(imageLicense,1) {
                multipartFormData.append(imageData, withName: "driving_liscence", fileName: "driving_liscence.png", mimeType: "image/png")
            }
            
            
            if  let imageData2 = UIImageJPEGRepresentation(imageTin,1) {
                multipartFormData.append(imageData2, withName: "tin", fileName: "tin.png", mimeType: "image/png")
            }
            for (key, value) in paramDict! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: urlString , encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if response.result.isSuccess
                    {
                        if response.result.value != nil
                        {
                            completionHandler(response.result.value as! NSDictionary? , nil)
                        }
                    }
                    else if response.result.isFailure {
                        
                        completionHandler(nil , response.result.error as NSError?)
                    }
                    
                }
            case .failure( _):
                
                break
            }
            
        })
    }
    
    
    func uploadeditDriverApi(urlString: String, profileImg : UIImage, paramDict:Dictionary<String, AnyObject>? = nil,
                            completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        Manager.upload(multipartFormData: { (multipartFormData) in
            
            
            if  let imageData = UIImageJPEGRepresentation(profileImg,1) {
                multipartFormData.append(imageData, withName: "profile_image", fileName: "profile_image.png", mimeType: "image/png")
            }
            for (key, value) in paramDict! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: urlString , encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in

                    
                    if response.result.isSuccess
                    {
                        if response.result.value != nil
                        {
                            completionHandler(response.result.value as! NSDictionary? , nil)
                        }
                    }
                    else if response.result.isFailure {
                        
                        completionHandler(nil , response.result.error as NSError?)
                    }
                    
                }
            case .failure( _):
                
                break
            }
            
        })
    }
    
    
}

