//
//  MyFollowers.swift
//  24
//
//  Created by sri on 18/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class MyFollowers {
    
    var username : String?
    var id : Int?
    var profilePhotoUrl :String?
    
    
    init(dict:[String : Any]) {
        
        self.username = dict["user_name"] as? String
        self.id = dict["id"] as? Int
        self.profilePhotoUrl = dict["profile_photo"] as? String
        
    }
}
