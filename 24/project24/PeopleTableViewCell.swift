//
//  PeopleTableViewCell.swift
//  project24
//
//  Created by sri on 01/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol PeopleViewControllerDelegate {
    func goToProfileUserVC(userId : String)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var followBtnOutlet: UIButton!
    
    var PeopleViewController : PeopleViewController?
    
    var delegate : PeopleViewControllerDelegate?
    
    var user : User?{
        didSet{
        Users()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        usernameLabel.addGestureRecognizer(tapGesture)
        usernameLabel.isUserInteractionEnabled = true
    }
    
    
    
    func nameLabel_TouchUpInside() {

        if let id = user?.id {
            
            delegate?.goToProfileUserVC(userId: id)
            print("the user id is : \(user?.id)")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Users(){
        usernameLabel.text = user?.username
        
        if user?.isFollowing == true{
            
            self.followingBtnConfi()
            
        } else {
            
            self.followBtnConfi()
            
        }
        
//        PeopleViewController?.isFollowing(userId: (user?.id)!, completion: { (value) in
//            if value == true {
//                print(value)
//self.followingBtnConfi()
//            } else{
//            print(value)
//self.followBtnConfi()
//            }
//        })
    }
    
    func follow(){
        
        if user?.isFollowing == false {
        
            let currentUserId = Auth.auth().currentUser?.uid
            FirebaseService.sharedInstance.firebaseRef.child("MyPosts").child((user?.id)!).observeSingleEvent(of: .value, with: { snapshot in
                let dict = snapshot.value as? [String : Any]
                for key in (dict?.keys)! {
                    
                    FirebaseService.sharedInstance.firebaseRef.child("Feed").child(currentUserId!).child(key).setValue(true)
                    
                }
            })
            FirebaseService.sharedInstance.firebaseRef.child("followers").child((user?.id)!).child(currentUserId!).setValue(true)
            FirebaseService.sharedInstance.firebaseRef.child("following").child(currentUserId!).child((user?.id)!).setValue(true)
            
            followBtnOutlet.setTitle("following", for: UIControlState.normal)
            followBtnOutlet.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
            
            followingBtnConfi()
            
            user?.isFollowing = true
        
        }
        
    }
    func unfollow(){
        
        if user?.isFollowing == true {
            
            let currentUserId = Auth.auth().currentUser?.uid
            FirebaseService.sharedInstance.firebaseRef.child("MyPosts").child((user?.id)!).observeSingleEvent(of: .value, with: { snapshot in
                let dict = snapshot.value as? [String : Any]
                for key in (dict?.keys)! {
                    
                    FirebaseService.sharedInstance.firebaseRef.child("Feed").child(currentUserId!).child(key).setValue(NSNull())
                }
            })
            FirebaseService.sharedInstance.firebaseRef.child("followers").child((user?.id)!).child(currentUserId!).setValue(NSNull())
            FirebaseService.sharedInstance.firebaseRef.child("following").child(currentUserId!).child((user?.id)!).setValue(NSNull())
            
            followBtnOutlet.setTitle("follow", for: UIControlState.normal)
            followBtnOutlet.addTarget(self, action: #selector(follow), for: .touchUpInside)
            

            followBtnConfi()
            
            user?.isFollowing = false
        
        }
    }

    func followingBtnConfi(){
        
        // self.followBtnOutlet.layer.borderColor = UIColor.black as! CGColor
        //self.followBtnOutlet.layer.borderWidth = 1
        self.followBtnOutlet.clipsToBounds = true
        self.followBtnOutlet.layer.cornerRadius = 5
        self.followBtnOutlet.setTitleColor(.black, for: .normal)
        self.followBtnOutlet.backgroundColor = .clear
        self.followBtnOutlet.setTitle("Following", for: UIControlState.normal)
        self.followBtnOutlet.addTarget(self, action: #selector(self.unfollow), for: .touchUpInside)
        
    }
    
    func followBtnConfi(){
        
        // self.followBtnOutlet.layer.borderColor = UIColor.black as! CGColor
        //self.followBtnOutlet.layer.borderWidth = 1
        self.followBtnOutlet.clipsToBounds = true
        self.followBtnOutlet.layer.cornerRadius = 5
        self.followBtnOutlet.setTitleColor(.white, for: .normal)
        self.followBtnOutlet.backgroundColor = .black
        self.followBtnOutlet.setTitle("Follow", for: UIControlState.normal)
        self.followBtnOutlet.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
    }
}
