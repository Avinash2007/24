//
//  PreviewVideoViewController.swift
//  24
//
//  Created by sri on 02/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import NotificationBannerSwift

class PreviewVideoViewController: UIViewController {

    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var locationBtnOutlet: UIButton!
    @IBOutlet weak var groupsBtnOutlet: UIButton!
    @IBOutlet weak var momentsBtnOutlet: UIButton!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var momentId: Int!
    var videoURL: URL!
    var videoData: Data?
    var senderVC:NormalCameraViewController?
    
    var errorMessage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeAudioSession()
        perform(#selector(startVideo), with: nil, afterDelay: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func startVideo() {
        locationBtnOutlet.isHidden = true
        momentsBtnOutlet.isHidden = true
        activityIndicatorView.isHidden = true
        let videoURL = self.videoURL
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func activeAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        try? session.setActive(true)
    }
    
    @IBAction func locationBtnAction(_ sender: Any) {
    }
    
    @IBAction func momentsBtnAction(_ sender: Any) {
    }
    
    @IBAction func groupsBtncompletion(_ sender: Any) {
        self.navigateVc(idName: "selectGroupVc")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func notificationBanner (message: String, style: BannerStyle){
        let banner = StatusBarNotificationBanner(title: message, style: style)
        banner.show()
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
       // self.view.addSubview(activityIndicatorView)
        if videoURL != nil {
           let thumbnailImage = thumbnail(videoURL)
           print(thumbnailImage ?? "nil")
        }
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()

        print("sending")
        
        let postParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "description": "jello", "web_link": "sss", "tag_friends": "srii", "latitude": "13.22222", "longitude": "12.22222", "post_type": "2", "group_id": ""] as? [String: Any]
        
        Post.sharedInstance.createPost(dict: postParameters!) { (response, errorMessage, postId) in
            
            let errorMessage: String = errorMessage
            let postId: Int = postId

            if response {
                
                self.activityIndicatorView.isHidden = true
                activityIndicator.stopAnimating()
                
                self.notificationBanner(message: "Uploading...", style: .warning)
                self.dismiss(animated: false, completion: nil)
                self.senderVC?.dismiss(animated: false, completion: nil)
                let parameters = ["user_id": "\(mydetails!.userId)", "signature": mydetails!.signature, "post_id": String(postId), "album_id": "\(postDetails.albumId)", "media_type": "2"] as [String : Any]
                
                Credits.sharedInstance.uploadVideoRequest(dict: parameters, videoData: self.videoData!, fileName: self.randomString(), url: "http://api.my24space.com/v1/add_media", parameterName: "media", completion: { (isSucess, message) in
                    
                    if isSucess {
                        self.activityIndicatorView.isHidden = true
                        activityIndicator.stopAnimating()
                        self.notificationBanner(message: "Sucessfully Uploaded...", style: .success)
                        appDelegate.homeVC?.postsRequests()
                    }else {
                        self.notificationBanner(message: "please check you internet", style: .danger)
                        self.errorMessage = "please check you internet"
                        self.activityIndicatorView.isHidden = true
                        //self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
                        activityIndicator.stopAnimating()
                    }
                })
            }else {
                 self.notificationBanner(message: "Something gone wrong", style: .danger)
                self.errorMessage = "Something gone wrong"
                self.activityIndicatorView.isHidden = true
                activityIndicator.stopAnimating()
                //self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
                print("not uploaded")
            }
        }
    }
    
    func popToTabBarVC() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "goToPopUpVc"{
//            let previewVc = segue.destination as! PopUpViewController
//            previewVc.errorMessage = errorMessage
//        }
    }
}
