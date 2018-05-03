//
//  HomeTableViewTextCell.swift
//  24
//
//  Created by sri on 09/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class HomeTableViewTextCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var diaplayNameLabel: UILabelX!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreimageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentimageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareimageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!

    @IBOutlet weak var displayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        scoreimageView.isHidden = true
        scoreLabel.isHidden = true
        commentimageView.isHidden = true
        commentLabel.isHidden = true
        shareimageView.isHidden = true
        sharedLabel.isHidden = true
        shareLabel.isHidden = true
        if displayView != nil {
           addRoundedLightLayer(radius: 5.0, view: displayView)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
