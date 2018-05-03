//
//  HomeTableViewWebVideoCell.swift
//  24
//
//  Created by sri on 11/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import WebKit

class HomeTableViewWebVideoCell: UITableViewCell {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var diaplayNameLabel: UILabelX!
    @IBOutlet weak var timeStampLabel: UILabel!
    //@IBOutlet weak var momentNameLabel: UILabel!
    @IBOutlet weak var scoreimageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentimageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareimageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getVideo(videoCode: String){
        let url = URL(string: "http://www.youtube.com/embed/\(videoCode)")
        webView.load(URLRequest(url: url!))
    }

}
