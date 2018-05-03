//
//  GroupsDetails.swift
//  24
//
//  Created by sri on 19/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class GroupsDetails {
    
    var id : Int?
    var user_id : Int?
    var group_name : String?
    var status : String?
    var created_at : String?
    
    init(dict:[String : Any]) {
        
        self.id = dict["id"] as? Int
        self.user_id = dict["user_id"] as? Int
        self.group_name = dict["group_name"] as? String
        self.status = dict["status"] as? String
        self.created_at = dict["created_at"] as? String

    }
}
