//
//  HomeTableViewWebCell.swift
//  24
//
//  Created by sri on 09/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class HomeTableViewWebCell: UITableViewCell {
    
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var diaplayNameLabel: UILabelX!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var momentNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var scoreimageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentimageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareimageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    
    @IBOutlet weak var displayView: UIView!
   

    /// show indicator while loading profile image.
    @IBOutlet weak var profileIndicator: UIActivityIndicatorView!
    /// show indicator while loading web image.
    @IBOutlet weak var webImageIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreimageView.isHidden = true
        scoreLabel.isHidden = true
        commentimageView.isHidden = true
        commentLabel.isHidden = true
        shareimageView.isHidden = true
        sharedLabel.isHidden = true
        shareLabel.isHidden = true
        addRoundedLightLayer(radius: 5.0, view: displayView)
    }

}
