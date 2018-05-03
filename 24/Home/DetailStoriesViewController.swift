//
//  DetailStoriesViewController.swift
//  24
//
//  Created by sri on 29/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import AVFoundation

class DetailStoriesViewController: UIViewController {

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var momentNameLabel: UILabel!
    @IBOutlet weak var videoView: UIView!

    var albumId: Int?
    var list: [AlbumMedia] = []
    var mediaArray: [String] = []
    var mediaType: [Int] = []
    var mediaId: [Int] = []
    var index: Int?
    var momentName: String?
    var url: URL?
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        index = 0
        //playVideo(url: url!)
        getMedia()
        print(momentName)
        momentNameLabel.text = momentName
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func playVideo(url: URL){

        self.player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        
    }
    
    func getMedia(){
            
            let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "album_id": albumId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/get_album_media") { (isSucess, message, data) in
            if isSucess {
                
                if let responseArray = data["media"] as? [[String:Any]] {
                            
                            for dict in responseArray {
                                let mdl = AlbumMedia(dict: dict)
                                self.list.append(mdl)
                                self.mediaArray.append(mdl.media!)
                                self.mediaType.append(mdl.media_type!)
                                self.mediaId.append(mdl.id!)
                            }
                        }
                    let mediaUrlString = "http://api.my24space.com/public/uploads/media/" + "\(self.mediaArray[self.index!])"
                    print(mediaUrlString)
                    let mediaUrl = mediaUrlString.replacingOccurrences(of: " ", with: "%20")
                    let mediaURL = URL(string: mediaUrl)
                    
                    if self.mediaType[self.index!] == 1{
                        
                        self.videoView.isHidden = true
                        self.storyImageView.isHidden = false
                        
                        Credits.sharedInstance.getImageRequest(imageUrl: mediaURL!, completion: { (isSucess, message, image) in
                            self.storyImageView.image = image
                        })
                    } else if self.mediaType[self.index!] == 2{
                        
                        self.videoView.isHidden = false
                        self.storyImageView.isHidden = true
                        self.playVideo(url: mediaURL!)
                        self.player.play()
                    }
            }else {
             print(message)
            }
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion : nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
            print(position.x)
            
            
            if position.x >= 100 {
                print(index!)
                if index! >= mediaArray.count - 1{
                    print("limit exceded")
                }else {
                    let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "media_id": "\(self.mediaId[index!])"] as [String : Any]
                    
                    AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "http://api.my24space.com/v1/mark_as_read", completion: { (isSucess, message, data) in
                        if isSucess {
                            print(message)
                        }else {
                            print(message)
                        }
                    })
                    
                    index = index! + 1
                    print(index)
                    print(self.mediaArray[index!])
                    let mediaUrlString = "http://api.my24space.com/public/uploads/media/" + "\(self.mediaArray[index!])"
                   
                    let mediaUrl = mediaUrlString.replacingOccurrences(of: " ", with: "%20")
                    let mediaURL = URL(string: mediaUrl)
                    
                    
                    if self.mediaType[self.index!] == 1{
                        
                        self.videoView.isHidden = true
                        self.storyImageView.isHidden = false
                        
                        Credits.sharedInstance.getImageRequest(imageUrl: mediaURL!, completion: { (isSucess, message, image) in
                            if isSucess {
                            self.storyImageView.image = image
                            }else {
                                print(message)
                            }
                        })
                    } else if self.mediaType[self.index!] == 2{
                        
                        self.videoView.isHidden = false
                        self.storyImageView.isHidden = true
                        self.playVideo(url: mediaURL!)
                        self.player.play()
                    }
                }
            } else {
                
                if index! <= 0{
                    
                }else {
                    index = index! - 1
                    print(index)
                    
                    let mediaUrlString = "http://api.my24space.com/public/uploads/media/" + "\(self.mediaArray[index!])"
                    print(mediaUrlString)
                    let mediaUrl = mediaUrlString.replacingOccurrences(of: " ", with: "%20")
                    let mediaURL = URL(string: mediaUrl)
                    
                    if self.mediaType[self.index!] == 1{
                        
                        self.videoView.isHidden = true
                        self.storyImageView.isHidden = false
                        
                        Credits.sharedInstance.getImageRequest(imageUrl: mediaURL!, completion: { (isSucess, message, image) in
                            if isSucess {
                                self.storyImageView.image = image
                            }else {
                                print(message)
                            }
                        })
                    } else if self.mediaType[self.index!] == 2{
                        self.videoView.isHidden = false
                        self.storyImageView.isHidden = true
                        
                        self.playVideo(url: mediaURL!)
                        self.player.play()
                    }
                }
            }
        }
    }
    
    func displayMedia(){
        
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
