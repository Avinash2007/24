//
//  User.swift
//  project24
//
//  Created by sri on 01/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class User {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
    var password: String?
    var latitude: Double?
    var longitude: Double?
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        
        let user = User()
        
        user.email = dict["Email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["Username"] as? String
        user.password = dict["Password"] as? String
      //  user.latitude = dict["latitude"] as? Double
      //  user.longitude = dict["longitude"] as? Double
        user.id = key
        
        return user
    }    
}
