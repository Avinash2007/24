//
//  HomeTableViewWebTextCell.swift
//  24
//
//  Created by sri on 28/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class HomeTableViewWebTextCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var scoreImageView: UIImageView!
    @IBOutlet weak var displayScoreLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headLineLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
//        headLineLabel.text = "108 survived the disaster that happened after the packed vessels were hit by strong winds."
//        descriptionLabel.text = "“Fourteen missing, 108 survived,” Mr. Mova, said in an email, after the two vessels sank in the river in the southwestern province of Mai-Ndombe.Local official Didace Pembe said many more people may have died."
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellViewAllignment(){
        
        
        
    }

}
