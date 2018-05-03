//
//  UrlData.swift
//  24
//
//  Created by sriVathsav on 1/7/1397 AP.
//  Copyright © 1397 sri. All rights reserved.
//

import Foundation
class UrlData {
    
    var description : String?
    var title : String?
    var imageUrl :String?
    var linkType : Int?
    var url : String?
    
    
    init(dict:[String : Any]) {
        
        self.description = dict["Description"] as? String
        self.title = dict["Title"] as? String
        self.imageUrl = dict["ImageUrl"] as? String
        self.linkType = dict["LinkType"] as? Int
        self.url = dict["Url"] as? String
    }
}
