//
//  ProfileTableViewCell.swift
//  project24
//
//  Created by sri on 31/07/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getData(data : Post){
        captionLabel.text = data.caption
        if let photoUrl = URL(string: data.photoUrl!){
            postImage.sd_setImage(with: photoUrl)
        }
    }

}
