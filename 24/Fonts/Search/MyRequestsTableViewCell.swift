//
//  MyRequestsTableViewCell.swift
//  
//
//  Created by sri on 03/02/18.
//

import UIKit

class MyRequestsTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    var accpetAction: ((_ sender: AnyObject) -> Void)?
    var rejectAction: ((_ sender: AnyObject) -> Void)?
 
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var accpetRequestOutlet: UIButton!
    @IBOutlet weak var rejectRequestOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func accpetRequestBtn(_ sender: Any) {
        self.accpetAction?(sender as AnyObject)
    }
    @IBAction func rejectRequestBtn(_ sender: Any) {
     self.rejectAction?(sender as AnyObject)
    }
    

}
