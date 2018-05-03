//
//  GroupUsers.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class GroupUsers {
    
    var userId : Int?
    var userName : String?
    var profilePictureUrl : String?
    init(dict:[String : Any]) {
        
        self.userName = dict["user_name"] as? String
        self.profilePictureUrl = dict["profile_photo"] as? String
        self.userId = dict["member_id"] as? Int
        
    }
}
