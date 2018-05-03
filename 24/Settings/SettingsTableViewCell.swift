//
//  SettingsTableViewCell.swift
//  24
//
//  Created by sri on 24/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
