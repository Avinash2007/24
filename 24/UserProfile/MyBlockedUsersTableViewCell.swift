//
//  MyBlockedUsersTableViewCell.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class MyBlockedUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var blockBtnOutlet: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var activity: UIImageView!
    
    var buttonAction: ((_ sender: AnyObject) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellAllignment()
    }
    @IBAction func blockBtnAction(_ sender: Any) {
        
        self.buttonAction?(sender as AnyObject)
    }
    
    func cellAllignment(){
        
        profilePicImageView.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        usernameLabel.frame = CGRect(x: 65, y: 20, width: screenSize.width - 195, height: 30)
        blockBtnOutlet.frame = CGRect(x: screenSize.width - 115, y: 20, width: 100, height: 30)
        seperatorView.frame = CGRect(x: 65, y: 69, width: screenSize.width - 65, height: 1)
        
    }
}
