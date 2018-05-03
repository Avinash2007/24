//
//  OnBoard.swift
//  project24
//
//  Created by sri on 09/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class OnBoard {
    
    var photoUrl : String?
    var uid : String?
    var username : String?
    var id : String?
    var currentDate : String?
    var deleteDate : String?
    var isViewed : Bool?
    
    static func transformBoard(dict : [String : Any], key : String) -> OnBoard {
        
        let onBoard = OnBoard()
        
        onBoard.id = key
        onBoard.photoUrl = dict["photoUrl"] as? String
        onBoard.uid = dict["uid"] as? String
        onBoard.username = dict["Username"] as? String
        onBoard.currentDate = dict["currentDate"] as? String
        onBoard.deleteDate = dict["deleteDate"] as? String
        
        return onBoard
    }
}
