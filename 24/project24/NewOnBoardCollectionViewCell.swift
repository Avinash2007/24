//
//  NewOnBoardCollectionViewCell.swift
//  project24
//
//  Created by sri on 26/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import SDWebImage

class NewOnBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    
    var postId : String?
    var userId : String?
    
    func getData(data : OnBoard){
        
        if let photoUrl = URL(string: data.photoUrl!){
            image.sd_setImage(with: photoUrl)
        }
        postId = data.id
        userId = data.uid
    }
    
}
