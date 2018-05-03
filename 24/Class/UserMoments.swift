//
//  UserMoments.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
class UserMoments {
    
    var momentId : Int?
    var momentName : String?

    init(dict:[String : Any]) {
        
        self.momentName = dict["album_name"] as? String
        self.momentId = dict["album_id"] as? Int
        
    }
}
