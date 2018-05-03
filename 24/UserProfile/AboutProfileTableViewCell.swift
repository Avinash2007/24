//
//  AboutProfileTableViewCell.swift
//  
//
//  Created by sri on 18/01/18.
//

import UIKit

class AboutProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followBtnOutlet: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followBtnOutlet.isHidden = true
        cellAllignment()
    }

//    func getFollowingData(data: MyFollowing) {
//        usernameLabel.text = data.username
//    }
//
//    func getFollowersData(data: MyFollowers) {
//        usernameLabel.text = data.username
//    }
//
//    func getFriendsData(data: MyFriends) {
//        usernameLabel.text = data.username
//    }
    
    func cellAllignment(){
        
        profilePicImageView.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        usernameLabel.frame = CGRect(x: 65, y: 20, width: screenSize.width - 195, height: 30)
        followBtnOutlet.frame = CGRect(x: screenSize.width - 115, y: 20, width: 100, height: 30)
        seperatorView.frame = CGRect(x: 65, y: 69, width: screenSize.width - 65, height: 1)
    }
}
