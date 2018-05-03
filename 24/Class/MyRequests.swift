//
//  MyRequests.swift
//  24
//
//  Created by sri on 03/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class MyRequests {
    
    var id: Int?
    var username: String?
    
    init(dict:[String: Any]){
        
        self.id = dict["id"] as? Int
        self.username = dict["user_name"] as? String
    }
    
}

