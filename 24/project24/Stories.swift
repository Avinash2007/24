//
//  Stories.swift
//  project24
//
//  Created by sri on 25/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class Stories {
    
    var caption : String?
    var photoUrl : String?
    var uid : String?
    var username : String?
    var id : String?
    var uploadTime :Int?
    var deleteTime : Int?
    var folderName : String?
    var folderId : String?
    
    static func transformStories(dict : [String : Any], key : String) -> Stories {
        
        let stories = Stories()
        
        stories.id = key
        stories.caption = dict["Caption"] as? String
        stories.photoUrl = dict["PhotoUrl"] as? String
        stories.uid = dict["Uid"] as? String

        stories.uploadTime = dict["UploadTime"] as? Int
        stories.deleteTime = dict["DeleteTime"] as? Int
        stories.folderName = dict["FolderName"] as? String
        stories.folderId = dict["FolderId"] as? String
        
        return stories
    }
}
