//
//  SearchDetails.swift
//  24
//
//  Created by sri on 17/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class Search:JSONDecodable {
    
    var username : String?
    var id : Int?
    var profilePhotoUrl :String?
    var following_status : Int?
    var follower_status : Int?
    
    required init(json: JSON) {
        self.username = json["user_name"].stringValue
        self.id = json["id"].intValue
        self.following_status = json["following_status"].intValue
        self.follower_status = json["follower_status"].intValue
        self.profilePhotoUrl = json["profile_photo"].stringValue
    }
}

