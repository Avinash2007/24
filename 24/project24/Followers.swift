//
//  Followers.swift
//  project24
//
//  Created by sri on 29/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class Followers {
    
    var followerId : String?
    var followerUsername : String?
    var followerProfileImage : String?
    var numberOf_Folders: String?
    var id : String?

    
    static func transformFollowers(dict : [String : Any], key : String) -> Followers {
        
        let followers = Followers()
        
        followers.id = key
        followers.followerId = dict["FollowerId"] as? String
        followers.followerUsername = dict["Follower_Username"] as? String
        followers.followerProfileImage = dict["Follower_ProfileImage"] as? String
        followers.numberOf_Folders = dict["number_Of_Folder"]  as? String
        
        return followers
    }
    
   }
