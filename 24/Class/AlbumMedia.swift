//
//  AlbumMedia.swift
//  24
//
//  Created by sri on 16/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation

class AlbumMedia {
    
    var id : Int?
    var post_id : Int?
    var user_id : Int?
    var album_id : Int?
    var media_type : Int?
    var media : String?
    var profileImageUrl : String?
    var status : Int?
    var time : Int?
    var desc : String?
    var username: String?
    var postDate: String?
    var postTime: String?
    var albumName: String?
    
    
    init(dict:[String : Any]) {
        
        self.id = dict["id"] as? Int
        self.post_id = dict["post_id"] as? Int
        self.user_id = dict["user_id"] as? Int
        self.album_id = dict["album_id"] as? Int
        self.media_type = dict["media_type"] as? Int
        self.media = dict["media"] as? String
        self.profileImageUrl = dict["profile_photo"] as? String
        self.status = dict["status"] as? Int
//        self.time = dict["time"] as? Int
//        self.desc = dict["desc"] as? String
//        self.username = dict["user_name"] as? String
//        self.postDate = dict["createdat_formate2"] as? String
//        self.postTime = dict["createdat_formate1"] as? String
//        self.albumName = dict["album_name"] as? String
        
        
    }
}
