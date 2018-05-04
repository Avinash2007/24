//
//  HomeTableViewCell.swift
//  24
//
//  Created by sri on 29/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import Alamofire

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var diaplayNameLabel: UILabelX!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var momentNameLabel: UILabel!
    @IBOutlet weak var scoreimageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentimageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareimageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var moveTowallOutlet: UIButton!
    @IBOutlet weak var displayView: UIView!
    
    /// show indicator while loading profile image.
    @IBOutlet weak var profileIndicator: UIActivityIndicatorView!
    /// show indicator while loading story image.
    @IBOutlet weak var storyImageIndicator: UIActivityIndicatorView!
    
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?

    var isMoved = false
    
    var profileVC:ProfileViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        moveTowallOutlet.isHidden = true
        sharedLabel.isHidden = true
        
        scoreimageView.isHidden = true
        scoreLabel.isHidden = true
        commentimageView.isHidden = true
        commentLabel.isHidden = true
        shareimageView.isHidden = true
        shareLabel.isHidden = true

        storyImageView?.isUserInteractionEnabled = true
        let action = #selector(handleTap(tap:))
        let tap = UITapGestureRecognizer.init(target: self, action: action)
        storyImageView?.addGestureRecognizer(tap)
        addRoundedLightLayer(radius: 5.0, view: displayView)
    }
    
    @IBAction func moveToWallAction(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    @objc func handleTap(tap:UITapGestureRecognizer) {
        print("handleTap")
        profileVC?.tap(sender: tap)
    }
    
    
    func loadCell(post:NewsFeed) {
        if post.profileImageUrl != "" && post.profileImageUrl != nil {
            let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(post.profileImageUrl!)"
            let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
            loadImage(profileUrl, profileImageView, activity: profileIndicator, defaultImage: #imageLiteral(resourceName: "profilepicPlaceholder"))
        }
        
        self.diaplayNameLabel.text = post.username
        self.timeStampLabel.text = post.postTime
        
        let storyUrlString = "http://api.my24space.com/public/uploads/media/" + "\(post.media!)"
        let storyUrl = storyUrlString.replacingOccurrences(of: " ", with: "%20")
        loadImage(storyUrl, storyImageView, activity: storyImageIndicator, defaultImage: nil)
        if post.album_id == 0 {
            self.momentNameLabel.isHidden = true
        }else if post.album_id != 0{
            self.momentNameLabel.isHidden = false
            self.momentNameLabel.text = post.albumName
        }
        
    }
    
}


