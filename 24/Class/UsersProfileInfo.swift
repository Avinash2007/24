//
//  UsersProfileInfo.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class UserProfileInfo {
    
    var username: String?
    var userMobileNumber: Int?
    var userEmail: String?
    var dateOfBirth: Int?
    var gender: String?
    var profilePhoto: String?
    var lattitude: Int?
    var longitude: Int?
    var countryId: Int?
    var userId: Int?
    var followingCount: Int?
    var followerCount: Int?
    var friendsCount: Int?
    var followingStatus: Int?
    var followerStatus: Int?
    var friendsStatus: Int?
    
    init(dict:[String: Any]){
        
        self.username = dict["user_name"] as? String
        self.userEmail = dict["user_email"] as? String
        self.userMobileNumber = dict["user_mobile"] as? Int
        self.dateOfBirth = dict["dob"] as? Int
        self.gender = dict["gender"] as? String
        self.profilePhoto = dict["profile_photo"] as? String
        self.lattitude = dict["cur_lat"] as? Int
        self.longitude = dict["cur_longi"] as? Int
        self.countryId = dict["country_id"] as? Int
        self.userId = dict["uid"] as? Int
        self.followingCount = dict["following_count"] as? Int
        self.followerCount = dict["follower_count"] as? Int
        self.friendsCount = dict["wall_request_count"]as? Int
        self.followingStatus = dict["following_status"] as? Int
        self.followerStatus = dict["follower_status"] as? Int
        self.friendsStatus = dict["wall_request_status"]as? Int
        
    }
    
}
