//
//  ApiManager.swift
//  VideoChat
//
//  Created by preeti rani on 06/03/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire

extension JSON{
    func isKeyPresent()->Bool {
        if self == nil || self.null != nil{
            return false
        }
        return true
    }
}

let api_manager = ApiManager.sharedInstance

public protocol JSONDecodable{
    init(json:JSON)
}

extension Collection where Iterator.Element == JSON {
    func decode<T:JSONDecodable>() -> [T] {
        return map({T(json:$0)})
    }
}

class ApiManager {
    static let sharedInstance = ApiManager.init()
    
    func POSTApi(_ url: String, param: [String: Any]?, header : [String : String]?,  completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        
        print("Header------>>>>>",header ?? "")
        _ =  Alamofire.request(url, method: .post, parameters: param , encoding: JSONEncoding.default, headers: header).responseJSON{ (dataResponse) in
            
            debugPrint(dataResponse.timeline)
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POSTApi Error : ",error )
                completion(nil , error , nil)
                return
            }
            if dataResponse.result.value != nil{
                let json = JSON.init(dataResponse.result.value!)
                DispatchQueue.main.async {
                    
                }
                completion(json , nil, dataResponse.response?.statusCode)
            }else{
                DispatchQueue.main.async {
                    
                }
                completion(nil , nil,dataResponse.response?.statusCode)
            }
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    func POSTStringApi(_ url: String, param: [String: Any]?, header : [String : String]?,  completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        
        print("Header------>>>>>",header ?? "")
        _ =  Alamofire.request(url, method: .post, parameters: param , encoding: JSONEncoding.default, headers: header).responseString{ (dataResponse) in
            
            debugPrint(dataResponse.timeline)
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POSTApi Error : ",error )
                completion(nil , error , nil)
                return
            }
            if dataResponse.result.value != nil{
                let json = JSON.init(dataResponse.result.value!)
                DispatchQueue.main.async {
                    
                }
                completion(json , nil, dataResponse.response?.statusCode)
            }else{
                DispatchQueue.main.async {
                    
                }
                completion(nil , nil,dataResponse.response?.statusCode)
            }
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    func GETApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        Alamofire.request(url, method: .get, parameters: param, encoding:JSONEncoding.default, headers: header)
            .responseJSON { (dataResponse) in
                debugPrint(dataResponse.timeline)
                guard dataResponse.result.isSuccess else {
                    let error = dataResponse.result.error!
                    print("GETApi Error : ",error )
                    completion(nil , error, dataResponse.response?.statusCode)
                    return
                }
                if dataResponse.result.value != nil{
                    let json = JSON.init(dataResponse.result.value!)
                    DispatchQueue.main.async {
                        
                    }
                    completion(json , nil,dataResponse.response?.statusCode)
                }else{
                    DispatchQueue.main.async {
                        
                    }
                    completion(nil , nil,dataResponse.response?.statusCode)
                }
                print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
      }
   
    
    func PUTApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        Alamofire.request(url, method: .put, parameters: param, encoding:JSONEncoding.default, headers: header)
            .responseJSON { (dataResponse) in
                debugPrint(dataResponse.timeline)
                guard dataResponse.result.isSuccess else {
                    let error = dataResponse.result.error!
                    print("PUTApi Error : ",error )
                    DispatchQueue.main.async {
                        
                    }
                    completion(nil , error, dataResponse.response?.statusCode)
                    return
                }
                if dataResponse.result.value != nil{
                    let json = JSON.init(dataResponse.result.value!)
                    DispatchQueue.main.async {
                        
                    }
                    completion(json , nil,dataResponse.response?.statusCode)
                }else{
                    DispatchQueue.main.async {
                        
                    }
                    completion(nil , nil,dataResponse.response?.statusCode)
                }
                print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    func DELETEApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        Alamofire.request(url, method: .delete, parameters: param, encoding:JSONEncoding.default, headers: header)
            .responseJSON { (dataResponse) in
                debugPrint(dataResponse.timeline)
                guard dataResponse.result.isSuccess else {
                    let error = dataResponse.result.error!
                    print("GETApi Error : ",error )
                    DispatchQueue.main.async {
                        
                    }
                    
                    completion(nil , error, dataResponse.response?.statusCode)
                    return
                }
                if dataResponse.result.value != nil{
                    let json = JSON.init(dataResponse.result.value!)
                    DispatchQueue.main.async {
                        
                    }
                    completion(json , nil,dataResponse.response?.statusCode)
                }else{
                    DispatchQueue.main.async {
                        
                    }
                    completion(nil , nil,dataResponse.response?.statusCode)
                }
                print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
}

