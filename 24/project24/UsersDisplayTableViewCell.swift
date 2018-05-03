//
//  UsersDisplayTableViewCell.swift
//  project24
//
//  Created by sri on 26/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UsersDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundViewColor: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userInfoLabel: UILabel!
    
    var storiesCount : String?
    
    var user_Id :String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view()
    }
    
    func view(){
        backgroundViewColor.backgroundColor = UIColor(red: 190, green: 100, blue: 100, alpha: 1)
    }
    
    var user : User?{
        didSet{
            Users()
        }
    }

   // var user : User?
    
    func Users(){
        usernameLabel.text = user?.username
        
        if user?.isFollowing == true{
            
            self.followingBtnConfig()
            
        } else {
            
          //  self.followBtnConfig()
            
        }
    }
    
    func follow(){
        
      //  if user?.isFollowing == false {

            let currentUserId = Auth.auth().currentUser?.uid
    
        
        StoriesFirebaseService.sharedInstance.firebaseRef.child("Stories_").queryOrdered(byChild: "Uid").queryEqual(toValue: user_Id).observe(.value, with: { (snapshot) in
            
            for stories in snapshot.children{
                
                if let dict = (stories as! DataSnapshot).value as? [String : Any] {

                    let storiesId : NSMutableArray = []
                    storiesId.add(dict.keys)
                    print("storiesId@\(storiesId.count)")
                    
                    let count : Int = storiesId.count
                    self.storiesCount = String(count)
                }
            }
            
            if self.storiesCount ==  nil{
                self.storiesCount = "0"
            }
            let array : NSMutableDictionary = ["Current_User_Id":currentUserId!,"FollowerId":self.user?.id,"Follower_Username":self.user?.username,"Follower_ProfileImage":self.user?.profileImageUrl ?? nil,"number_Of_Folder" : self.storiesCount]
            
            SearchFirebaseService.sharedInstance.followers(details: array)
            // SearchFirebaseService.sharedInstance.following(details: array1)
            
            self.followButton.setTitle("following", for: UIControlState.normal)
            self.followButton.addTarget(self, action: #selector(self.unfollow), for: .touchUpInside)
            
            self.followingBtnConfig()
            self.user?.isFollowing = true
  
        })
    }

    func unfollow(){
        
        //if user?.isFollowing == true {

            SearchFirebaseService.sharedInstance.unFollower(details: "")
            SearchFirebaseService.sharedInstance.unFollowing(details: "")
            
            followButton.setTitle("follow", for: UIControlState.normal)
            followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
            
            
         //   followBtnConfig()
            
            user?.isFollowing = false
   //     }
        

    }
    
    func followingBtnConfig(){
        
        // self.followBtnOutlet.layer.borderColor = UIColor.black as! CGColor
        //self.followBtnOutlet.layer.borderWidth = 1
        self.followButton.clipsToBounds = true
        self.followButton.layer.cornerRadius = 5
        self.followButton.setTitleColor(.black, for: .normal)
        self.followButton.backgroundColor = .clear
        self.followButton.setTitle("Following", for: UIControlState.normal)
        self.followButton.addTarget(self, action: #selector(self.unfollow), for: .touchUpInside)
        
    }
    
    func followBtnConfig(userId: String){
        
        // self.followBtnOutlet.layer.borderColor = UIColor.black as! CGColor
        //self.followBtnOutlet.layer.borderWidth = 1
        self.followButton.clipsToBounds = true
        self.followButton.layer.cornerRadius = 5
        self.followButton.setTitleColor(.white, for: .normal)
        self.followButton.backgroundColor = .black
        self.user_Id = userId
        self.followButton.setTitle("Follow", for: UIControlState.normal)
        self.followButton.addTarget(self, action: #selector(self.follow), for: .touchUpInside)
    }

    


}
