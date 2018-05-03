//
//  Messages.swift
//  project24
//
//  Created by sri on 07/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
import FirebaseAuth

class Messages {
    
    var message : String?
    var toId : String?
    var fromId : String?
    var msgId : String?
    var timeStamp : NSNumber?
    var imageUrl : String?
    var imageWidht : NSNumber?
    var imageHeight : NSNumber?
    var videoUrl : String?
    
    
    static func transformMessage(dict : [String : Any], key : String) -> Messages {
        
        let message = Messages()
        
        message.msgId = key
        message.message = dict["message"] as? String
        message.fromId = dict["fromId"] as? String
        message.toId = dict["toId"] as? String
        message.timeStamp = dict["timeStamp"] as? NSNumber
        message.imageUrl = dict["imageUrl"] as? String
        message.imageWidht = dict["imageWidth"] as? NSNumber
        message.imageHeight = dict["imageHeight"] as? NSNumber
        message.videoUrl  = dict["videoUrl"]  as? String
        
        return message
    }
    
     func chatPatnerId()-> String?{
    
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        
    }
    
}
