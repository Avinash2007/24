//
//  Post.swift
//  project24
//
//  Created by sri on 29/07/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class Post {
    
    var caption : String?
    var photoUrl : String?
    var uid : String?
    var username : String?
    var id : String?
    var currentTime :Int?
    var deleteTime : Int?
    var imageCount : Int?
    var photoUrl2 : String?
    var photoUrl3 : String?
    var photoUrl4 : String?

    static func transformPost(dict : [String : Any], key : String) -> Post {
        
        let post = Post()
        
        post.id = key
        post.caption = dict["Caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.username = dict["Username"] as? String
        post.currentTime = dict["time"] as? Int
        post.deleteTime = dict["DeletTime"] as? Int
        post.imageCount = dict["imageCount"] as? Int
        post.photoUrl2 = dict["photoUrl2"] as? String
        post.photoUrl3 = dict["photoUrl3"] as? String
        post.photoUrl4 = dict["photoUrl4"] as? String

        
        return post
    }
}
