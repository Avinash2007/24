//
//  NearByTableViewCell.swift
//  project24
//
//  Created by sri on 19/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class NearByTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!

    
    var user : User?{
        didSet{
            Users()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func Users(){
        usernameLabel.text = user?.username
        if let photoUrl = URL(string: (user?.profileImageUrl!)!){
            self.profileImage.sd_setImage(with: photoUrl)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
