//
//  MyBlockedUsers.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class MyBlockedUsers{
    
    var username : String?
    var id : Int?
    // var profilePhotoUrl :String?
    
    
    init(dict:[String : Any]) {
        
        self.username = dict["user_name"] as? String
        self.id = dict["id"] as? Int
        //self.profilePhotoUrl = dict["profile_photo"] as? String
        
    }

}
