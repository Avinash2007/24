//
//  DiscoverTableViewCell.swift
//  24
//
//  Created by sri on 17/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
     var labelTapAction: ((_ sender: AnyObject) -> Void)?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var addFollowBtnOutlet: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        openUserProfile()
    }
    
    override func prepareForReuse() {
        profilePicImageView.image = nil
    }
    
    func openUserProfile(){
        
        /*let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(addPhotoTapGestureRecognizer)*/
    }
    
    @objc func labelTapped(_ sender: Any){
        
        print("tapped label")
        self.labelTapAction?(sender as AnyObject)

    }
    
    @IBAction func addFollowBtn(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
}
