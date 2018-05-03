//
//  Folders.swift
//  project24
//
//  Created by sri on 30/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
class Folders {
    
    var folderId : String?
    var folderName : String?
    var folderImageUrl : String?
    var id: String?
    
    
    static func transformFolder(dict : [String : Any], key : String) -> Folders {
        
        let folders = Folders()
        
        folders.id = key
        folders.folderId = dict["FolderId"] as? String
        folders.folderName = dict["FolderName"] as? String
        folders.folderImageUrl = dict["FolderImageUrl"] as? String
        
        return folders
    }
    
}
