//
//  MessagePeopleTableViewCell.swift
//  
//
//  Created by sri on 05/08/17.
//
//

import UIKit
import FirebaseAuth

class MessagePeopleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func getData(data : User){
      textLabel?.text = data.username
        detailTextLabel?.text = data.email
        /*if let photoUrl = URL(string: data.profileImageUrl!){
            imageView?.sd_setImage(with: photoUrl)
        }*/
        imageView?.image = UIImage(named : "logo")

        
    }
 
    
    
    func username(){
        
        if let userId = Auth.auth().currentUser?.uid{
            FirebaseService.sharedInstance.firebaseRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:Any]{
                    let user = User.transformUser(dict: dict, key: snapshot.key)
                    self.textLabel?.text = user.username
                }
            })
        }
    }
    

}
