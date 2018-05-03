//
//  HomeTableViewVideoCell.swift
//  24
//
//  Created by sri on 04/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class HomeTableViewVideoCell: UITableViewCell {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var diaplayNameLabel: UILabelX!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var momentNameLabel: UILabel!
    @IBOutlet weak var scoreimageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var moveToWallOutlet: UIButton!
    @IBOutlet weak var displayView: UIView!
    
    /// show indicator while loading profile image.
    @IBOutlet weak var profileIndicator: UIActivityIndicatorView!
    /// show indicator while loading story image.
    @IBOutlet weak var shareImageIndicator: UIActivityIndicatorView!
    /// show indicator while loading play image.
    @IBOutlet weak var playImageIndicator: UIActivityIndicatorView!
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var isMoved: Bool = false
    var profileVC:ProfileViewController?
    var isPlaying = true

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        playerLayer.frame = videoView.bounds
        addPhotoTapGesture()
        sharedLabel.isHidden = true
        moveToWallOutlet.isHidden = true
        
        scoreimageView.isHidden = true
        scoreLabel.isHidden = true
        commentImageView.isHidden = true
        commentLabel.isHidden = true
        shareImageView.isHidden = true
        shareLabel.isHidden = true
        if displayView != nil {
            addRoundedLightLayer(radius: 5.0, view: displayView)
        }
    }
    
    func playVideo(url: URL){
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
    }
    
    func addPhotoTapGesture(){
        
        let videoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideoUrl(tap:)))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(videoTapGestureRecognizer)
        
    }

    @IBAction func moveToWallAction(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    override func layoutSubviews() {
        playerLayer.frame = videoView.bounds
    }

    @objc func playVideoUrl(tap:UITapGestureRecognizer){
        profileVC?.tap(sender: tap)
        /*if isPlaying == true{
            player.play()
            playImageView.isHidden = true
            isPlaying = false
        }else if isPlaying != true {
        player.pause()
            playImageView.isHidden = false
            isPlaying = true
        }*/
    }
 /*
    func viewAllignment(){
        
        profileImageView.frame = CGRect (x: 20, y: 10, width: 40, height: 40)
        diaplayNameLabel.frame = CGRect (x: profileImageView.frame.origin.x + 55, y: 15, width: 150, height: 30)
        timeStampLabel.frame = CGRect (x: screenSize.width - 140, y: 15, width: 120, height: 30)
        videoView.frame = CGRect (x: 15, y: profileImageView.frame.origin.y + 50, width: screenSize.width - 30, height: 265)
        momentNameLabel.frame = CGRect (x: 30, y: profileImageView.frame.origin.y + 65, width: 100, height: 25)
        videoView.frame = CGRect (x: 20, y: videoView.frame.origin.y + 280 , width: 20, height: 20)
        scoreLabel.frame = CGRect (x: scoreimageView.frame.origin.x + 30, y: scoreimageView.frame.origin.y, width: 50, height: 20)
//        commentImageView.frame = CGRect (x: scoreLabel.frame.origin.y + 60, y: scoreimageView.frame.origin.y, width: 20, height: 20)
//        commentLabel.frame = CGRect (x: commentImageView.frame.origin.y + 30, y: scoreimageView.frame.origin.y, width: 20, height: 20)
//        shareLabel.frame = CGRect (x: screenSize.width - 5, y: scoreimageView.frame.origin.y, width: 30, height: 20)
//        shareImageView.frame = CGRect (x: shareLabel.frame.origin.x - 30, y: scoreimageView.frame.origin.y, width: 20, height: 20)

    }
 */
    
    
    func loadCell(post:NewsFeed) {
        if post.profileImageUrl != ""{
            let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(post.profileImageUrl!)"
            let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
            loadImage(profileUrl, profileImageView, activity: profileIndicator, defaultImage: #imageLiteral(resourceName: "profilepicPlaceholder"))
        }
        self.diaplayNameLabel.text = post.username
        self.timeStampLabel.text = post.postTime
        
        if post.album_id == 0 {
            self.momentNameLabel.isHidden = true
        }else if post.album_id != 0{
            self.momentNameLabel.isHidden = false
            self.momentNameLabel.text = post.albumName
        }
        let videoUrlString = "http://api.my24space.com/public/uploads/media/" + "\(post.media!)"
        let videoUrl = videoUrlString.replacingOccurrences(of: " ", with: "%20")
        let storyVideoURL = URL(string: videoUrl)
        self.playVideo(url: storyVideoURL!)
    }
}
