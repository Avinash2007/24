//
//  DisplayGroupMembersTableViewCell.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DisplayGroupMembersTableViewCell: UITableViewCell {

    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var deleteUserBtnOutlet: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellAllignment()
    }

    @IBAction func deleteUserBtn(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
    }
    
    func cellAllignment(){
        
        profileImageView.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        usernameLabel.frame = CGRect(x: 80, y: 20, width: screenSize.width - 140, height: 30)
        deleteUserBtnOutlet.frame = CGRect(x: screenSize.width - 70, y: 20, width: 60, height: 30)
        seperatorView.frame = CGRect(x: 80, y: 69, width: screenSize.width - 80, height: 1)
    }
    
}
