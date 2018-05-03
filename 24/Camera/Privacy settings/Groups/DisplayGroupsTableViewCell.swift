//
//  DisplayGroupsTableViewCell.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DisplayGroupsTableViewCell: UITableViewCell {

  //  var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
//    @IBOutlet weak var deleteGroupBtnOutlet: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellAllignment()
    }
//    @IBAction func deleteGroupBtn(_ sender: Any) {
//        self.buttonAction?(sender as AnyObject)
//    }
    
    func cellAllignment(){
        
        groupImageView.frame = CGRect(x: 20, y: 15, width: 40, height: 40)
        groupNameLabel.frame = CGRect(x: 80, y: 20, width: screenSize.width - 175, height: 30)
       // deleteGroupBtnOutlet.frame = CGRect(x: screenSize.width - 85, y: 20, width: 70, height: 30)
        seperatorView.frame = CGRect(x: 80, y: 69, width: screenSize.width - 80, height: 1)
    }
    
}
