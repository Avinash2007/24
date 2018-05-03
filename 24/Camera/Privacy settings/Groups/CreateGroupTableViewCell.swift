//
//  CreateGroupTableViewCell.swift
//  24
//
//  Created by sri on 20/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class CreateGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkCircleImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellAllignment()
    }

    func getFollowingData(data: MyFollowing) {
        usernameLabel.text = data.username
    }
    
    func cellAllignment(){
        
        checkCircleImageView.frame = CGRect(x: 15, y: 20, width: 30, height: 30)
        profilePictureImageView.frame = CGRect(x: 60, y: 15, width: 40, height: 40)
        usernameLabel.frame = CGRect(x: 115, y: 20, width: screenSize.width - 160, height: 30)
        seperatorView.frame = CGRect(x: 115, y: 69, width: screenSize.width - 130, height: 1)
    }

}
