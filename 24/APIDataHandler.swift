//
//  API.swift
//  24
//
//  Created by sri on 22/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration
import NVActivityIndicatorView
import NotificationBannerSwift


private let sharedCustomNotificationInstance = CustomNotification()
private let sharedActivityIndicatorInstance = ActivityIndicator()
private let sharedCreditsInstance = Credits()
private let sharedPostInstance = Post()
private let sharedConnectivityInstance = Connectivity()
private let sharedAlamofireRequestInstance = AlamofireRequest()

private var url = "https://api.my24space.com/v1/upload_photo"

class Credits {
    
    class var sharedInstance: Credits {
        return sharedCreditsInstance
    }
    
    func registerUserRequest(dict: [String: Any], completion: @escaping (_ isSucess:Bool,_ errorMessage: String) -> Void){
        
        Alamofire.request("https://api.my24space.com/v1/register", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: AnyObject] {
                print(data)
                let status : NSNumber = (data["status"]) as! NSNumber
                if status == 0 {
                    
                    let message : String = (data["message"]) as! String
                    completion(false, message)
                }else {
                    
                    print("sucess")
                    completion(true, "Sucess")
                    let userId : Int = (data["userid"]) as! Int
                    let signature : String = (data["signature"]) as! String
                    mydetails = myDetails(userId: userId, signature: signature, viewerId: 29)
                    do{
                        let encodedobject = try JSONEncoder().encode(mydetails)
                        UserDefaults.standard.setValue(encodedobject, forKey: "UserInformation")
                        UserDefaults.standard.synchronize()
                    }
                    catch{
                        
                    }
//                    mydetails!.userId = userId
//                    mydetails!.signature = signature
                    
                    //                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    //                    UserDefaults.standard.set(userId, forKey: "userId")
                    //                    UserDefaults.standard.set(signature, forKey: "signature")
                    //                    UserDefaults.standard.synchronize()
                }
            }
        }
        
        
   /*
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        manager.request("https://api.my24space.com/v1/register", method: .post, parameters: dict)
            .responseJSON {
                response in
                switch (response.result) {
                case .success:
                    
                    if let data = response.result.value as? [String: AnyObject] {
                        print(data)
                        let status : NSNumber = (data["status"]) as! NSNumber
                        if status == 0 {
                            
                            let message : String = (data["message"]) as! String
                            completion(false, message)
                        }else {
                            
                            print("sucess")
                            completion(true, "Sucess")
                            let userId : Int = (data["userid"]) as! Int
                            let signature : String = (data["signature"]) as! String
                            mydetails!.userId = userId
                            mydetails!.signature = signature
                            
                            //                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            //                    UserDefaults.standard.set(userId, forKey: "userId")
                            //                    UserDefaults.standard.set(signature, forKey: "signature")
                            //                    UserDefaults.standard.synchronize()
                        }
                    }
                    
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        completion(false, "Request TimesOut. Try again")
                    }
                    completion(false, "\n\nAuth request failed with error:\n \(error)")
                    print("\n\nAuth request failed with error:\n \(error)")
                    break
                }
        }
 */
    }

    func loginUserRequest(dict: [String: Any], completion: @escaping (_ isSuccess:Bool, _ errorMessage: String) -> Void){

//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 20
//
//        manager.request("https://api.my24space.com/v1/register", method: .post, parameters: dict)
//            .responseJSON {
//                response in
//                switch (response.result) {
//                case .success:
//
//                    if let data = response.result.value as? [String: AnyObject] {
//                          print(data)
//                        let status : NSNumber = (data["status"]) as! NSNumber
//                        if status == 0 {
//                            let errorMessage : String = (data["message"]) as! String
//
//                            completion(false, errorMessage)
//                        }else {
//
//                            if let responseArray = data["data"] as? [String:Any] {
        
//                                let userId : Int = (responseArray["userid"]) as! Int
//                                let signature : String = (responseArray["signature"]) as! String
//
//                                mydetails!.userId = userId
//                                mydetails!.signature = signature
//
//                                //                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                                //                        UserDefaults.standard.set(userId, forKey: "userId")
//                                //                        UserDefaults.standard.set(signature, forKey: "signature")
//                                //                        UserDefaults.standard.synchronize()
//
//                                completion(true, "")
//                                print("sucess")
//
//                            }
//                        }
//                    }
//
//                    break
//                case .failure(let error):
//                    if error._code == NSURLErrorTimedOut {
//                        completion(false, "Request TimesOut. Try again")
//                    }
//                    completion(false, "\n\nAuth request failed with error:\n \(error)")
//                    print("\n\nAuth request failed with error:\n \(error)")
//                    break
//                }
//        }
        
        
//        
//        
//        
        Alamofire.request("https://api.my24space.com/v1/login", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in

            if let data = response.result.value as? [String: AnyObject] {
              //  print(data)
                let status : NSNumber = (data["status"]) as! NSNumber
                if status == 0 {
                    let errorMessage : String = (data["message"]) as! String
                    
                    completion(false, errorMessage)
                }else {
                    print(data)
                    if let responseArray = data["data"] as? [String:Any] {
                    
                        let userId : Int = (responseArray["userid"]) as! Int
                        let signature : String = (responseArray["signature"]) as! String
                        
                        mydetails = myDetails(userId: userId, signature: signature, viewerId: 29)
//                        mydetails!.userId = userId
//                        mydetails!.signature = signature
                        
                        do{
                        let encodedobject = try JSONEncoder().encode(mydetails)
                            UserDefaults.standard.setValue(encodedobject, forKey: "UserInformation")
                            UserDefaults.standard.synchronize()
                        }
                        catch{
                            
                        }
//                        print(mydetails!.userId)
//                        print(mydetails!.signature)
//                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                        UserDefaults.standard.set(userId, forKey: "userId")
//                        UserDefaults.standard.set(signature, forKey: "signature")
//                        UserDefaults.standard.synchronize()
                        
                        completion(true, "")
                        print("sucess")
                    
                    }
                }
            }
        }
    }
    
    func uploadImageRequest(dict: [String: Any], image: UIImage, fileName: String, url: String, parameterName: String,completion: @escaping (_ isSucess:Bool,_ errorMessage: String) -> Void){
        
        let imgData = UIImageJPEGRepresentation(image, 1.0)!
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        for key in dict.keys {
                            let name = String(key)
                            if let val = dict[name] as? String {
                                multipartFormData.append(val.data(using: .utf8)!, withName: name)
                            }
                        }
                        
                        multipartFormData.append(imgData, withName: parameterName, fileName: "\(fileName).jpg", mimeType: "image/jpeg")
                },
                    to: url,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            
                            upload.uploadProgress(closure: { (progress) in
                                print("Upload Progress: \(progress.fractionCompleted)")
                            })
                            
                            upload.responseJSON { response in
                                print(response.result.value!)
                                
                                if let data = response.result.value as? [String: AnyObject] {
                                    
                                    let status : NSNumber = (data["status"]) as! NSNumber
                                    if status == 0 {
                                        let errorMessage : String = (data["message"]) as! String
                                        completion(false, "\(errorMessage)")
                                    }else {
                                       completion(true, "Uploding Sucess")
                                    }
                                }
                            }
                            
                        case .failure(let encodingError):
                         
                        completion(false, "Please check your internet connection.")
                            print(encodingError)
                        }
                })
        }
    
    func uploadVideoRequest(dict: [String: Any], videoData: Data, fileName: String, url: String, parameterName: String,completion: @escaping (_ isSucess:Bool,_ errorMessage: String) -> Void){
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for key in dict.keys {
                    let name = String(key)
                    if let val = dict[name] as? String {
                        multipartFormData.append(val.data(using: .utf8)!, withName: name)
                    }
                }
                
                multipartFormData.append(videoData, withName: parameterName, fileName: "\(fileName).mp4", mimeType: "mp4")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        print(response.result.value)
                        
                        if let data = response.result.value as? [String: AnyObject] {
                            
                            let status : NSNumber = (data["status"]) as! NSNumber
                            if status == 0 {
                                let errorMessage : String = (data["message"]) as! String
                                completion(false, "\(errorMessage)")
                            }else {
                                completion(true, "Uploding Sucess")
                            }
                        }
                    }
                    
                case .failure(let encodingError):
                    completion(false, "Please check your internet connection.")
                    print(encodingError)
                }
        })
    }
    
    func getImageRequest(imageUrl: URL, completion: @escaping (_ isSucess:Bool,_ errorMessage: String,_ image: UIImage) -> Void){
        
        Alamofire.request(imageUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    completion(true, "Sucess", UIImage(data: data)!)
                }
            }else {
                
            }
        }
    }
}

class Post {
    
    class var sharedInstance: Post {
        return sharedPostInstance
    }
    
    func createPost(dict: [String: Any], completion: @escaping (_ isSuccess:Bool, _ errorMessage: String, _ postId: Int) -> Void){
        
        Alamofire.request("https://api.my24space.com/v1/create_post", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: AnyObject] {
                print(data)
                let status : NSNumber = (data["status"]) as! NSNumber
                if status == 0 {
                    let message : String = (data["message"]) as! String
                    completion(false, message, 0)

                }else {
                    let postId : Int = (data["post_id"]) as! Int
                    completion(true, "", postId)
                    print("sucess")
                }
            }
        }
    }
}

class Connectivity {
    
    class var sharedInstance: Connectivity {
        return sharedConnectivityInstance
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}

class AlamofireRequest {
    
    class var sharedInstance: AlamofireRequest {
        return sharedAlamofireRequestInstance
    }
    
    func alamofireRequest(dict: [String: Any], url : String, completion: @escaping (_ isSucess:Bool,_ errorMessage: String,_ responseDict: [String: Any]) -> Void){
        
        Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: Any] {

                if let status = data["status"] as? Int, let message = data["message"] as? String {
                    if status == 1{
                        print("sucess")
                        completion(true, message, data)
                    }else {
                        print("not")
                        completion(false, message, data)
                    }
                }
            }
        }
    }
    
    func alamofireGetRequest(url : String, completion: @escaping (_ responseDict: [String: Any]) -> Void){
        
        request(url).responseJSON { response in
            if let data = response.result.value as? [String: Any]{
                completion(data)
            }
        }
    }
}

class CustomNotification {
    
    class var sharedInstance: CustomNotification {
        return sharedCustomNotificationInstance
    }
    
    func notificationBanner (message: String, style: BannerStyle){
        let banner = StatusBarNotificationBanner(title: message, style: style)
        banner.show()
    }
}
class ActivityIndicator {
    
    class var sharedInstance: ActivityIndicator {
        return sharedActivityIndicatorInstance
    }
    
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
    
    func startAnimating(view: UIView){
        view.addSubview(activityIndicatorView)
        view.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating(view: UIView){
        
        view.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
}


