//
//  UserPostsCollectionViewCell.swift
//  project24
//
//  Created by sri on 22/09/17.
//  Copyright © 2017 sri. All rights reserved.
//
import UIKit
import SDWebImage

class UserPostsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var folderNameLabel: UILabel!
    
    var storiesId : String?
    var userId : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func getData(data : Folders){
        
        folderNameLabel.text = data.folderName
        print("foldername@@\(data.folderName!)")
        if let photoUrl = URL(string: data.folderImageUrl!){
            photoImageView.sd_setImage(with: photoUrl)
        }
        
        
    }
    
        func getStories(data : Stories){
            
            folderNameLabel.text = data.caption
            print("foldername@@\(data.folderName!)")
            if let photoUrl = URL(string: data.photoUrl!){
                photoImageView.sd_setImage(with: photoUrl)
            }
    }

}
