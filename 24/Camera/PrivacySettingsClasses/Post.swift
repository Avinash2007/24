//
//  Post.swift
//  24
//
//  Created by sri on 09/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
import Alamofire

//private let sharedPostInstance = Post()
//
//class Post {
//    
//    class var sharedInstance: Post {
//        return sharedPostInstance
//    }
//    
//    var postParameters = ["user_id": "", "signature": "", "description": "", "web_link": "", "tag_friends": "", "latitude": "", "longitude": "", "status": "", "post_type": ""] as? [String: Any]
//    var uploadPhotoParameters = ["user_id": "", "signature": "", "post_id": "", "photo": "", "album_id": ""] as? [String: Any]
//    var uploadVideoParameters = ["user_id": "", "signature": "", "post_id": "", "video": "", "album_id": ""] as? [String: Any]
//    
//    func createPost(completion: @escaping () -> ()){
//        
//        Alamofire.request("https://api.my24space.com/v1/create_post", method: .post, parameters: postParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            
//            if let data = response.result.value as? [String: AnyObject] {
//                print(data)
//                let status : NSNumber = (data["status"]) as! NSNumber
//                if status == 0 {
//                    let message : String = (data["message"]) as! String
//                }else {
//                    print("sucess")
////                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
////                    self.present(viewController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//    
//    func uploadPhoto(){
//        
//        Alamofire.request("https://api.my24space.com/v1/upload_photo", method: .post, parameters: uploadPhotoParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            
//            if let data = response.result.value as? [String: AnyObject] {
//                print(data)
//                let status : NSNumber = (data["status"]) as! NSNumber
//                if status == 0 {
//                    let message : String = (data[""]) as! String
//                }else {
//                    print("sucess")
//
//                }
//            }
//        }
//    }
//    
//    func uploadVideo(){
//        
//        Alamofire.request("https://api.my24space.com/v1/upload_video", method: .post, parameters: uploadVideoParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            
//            if let data = response.result.value as? [String: AnyObject] {
//                print(data)
//                let status : NSNumber = (data["status"]) as! NSNumber
//                if status == 0 {
//                    let message : String = (data[""]) as! String
//                }else {
//                    print("sucess")
//                    
//                }
//            }
//        }
//    }
//    
//}

