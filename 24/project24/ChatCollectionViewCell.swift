//
//  ChatCollectionViewCell.swift
//  project24
//
//  Created by sri on 11/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import AVFoundation

class ChatCollectionViewCell: UICollectionViewCell {
    
    var chatViewController : ChatViewController?
    
    var message: Messages?
    
    let activityIndicatorView: UIActivityIndicatorView = {
    
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    let playButton: UIButton = {
    
        let button = UIButton(type: .system)
        button.setTitle("playVideo", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handelPlay), for: .touchUpInside)
        
        return button
        
    }()
    
    var playerLayer : AVPlayerLayer?
    var player: AVPlayer?
    
    func handelPlay(){
        
        if let videoUrl = message?.videoUrl , let url = NSURL(string: videoUrl) {
            player = AVPlayer(url: url as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView : UITextView = {
        
        let tv = UITextView()
        tv.text = ""
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        
        return tv
        
    }()
    
    let bubbleView : UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137, blue: 249, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
        
    }()
    
    let messageImageView: UIImageView = {
    
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoomTap)))

        return imageView
    }()
    
    func handelZoomTap(tapGesture:UITapGestureRecognizer){
        
        if message?.videoUrl != nil{
        return
        }
        let imageView = tapGesture.view as? UIImageView
        self.chatViewController?.performZoomInForStartingImageView(startingImageView: imageView!)
        
    }
    
        static let blueColor = UIColor(red: 0, green: 137, blue: 249, alpha: 0.5)
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint?
    var bubbleViewleftAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        
        bubbleView.addSubview(messageImageView)
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        messageImageView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor)
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor)
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageImageView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor)
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor)
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor , constant: -8)
        bubbleViewleftAnchor =  bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor , constant: 8)
        //bubbleViewleftAnchor?.isActive = false
        bubbleViewRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
    }
    
}
