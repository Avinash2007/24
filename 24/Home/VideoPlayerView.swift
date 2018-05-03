//
//  VideoPlayerView.swift
//  24
//
//  Created by Irshad Ahmad on 22/04/18.
//  Copyright © 2018 sri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import NVActivityIndicatorView

@objc protocol VideoPlayerViewDelegate {
    @objc optional func didFinishPlayingVideo()
}

class VideoPlayerView: UIView {
    
    var player:AVPlayer?
    var previewLayer:AVPlayerLayer?
    var delegate:VideoPlayerViewDelegate?
    
    lazy var activityVieww:NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), type: .ballClipRotateMultiple, color: .white, padding: 20)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playVideo(url:URL) {
        self.player = AVPlayer.init(url: url)
        let interval = CMTime.init(value: 1, timescale: 2)
        self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (time) in
            if self.player != nil {
                let loaded = CMTimeGetSeconds(time)
                let totalTime = CMTimeGetSeconds(self.player!.currentItem!.duration)
                if loaded == totalTime {
                    self.delegate?.didFinishPlayingVideo?()
                }
            }
        }
        player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.previewLayer = AVPlayerLayer.init(player: self.player!)
        self.previewLayer?.frame = self.bounds
        self.layer.insertSublayer(previewLayer!, at: 0)
        self.activityVieww.center = self.center
        self.addSubview(activityVieww)
        self.player?.play()
    }
    
    func removePlayer() {
        self.previewLayer?.removeFromSuperlayer()
        self.player?.pause()
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if keyPath == "status" {
            self.activityVieww.removeFromSuperview()
        }
    }
}
