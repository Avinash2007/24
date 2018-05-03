//
//  OnBoardFirebaseService.swift
//  Pods
//
//  Created by sri on 28/09/17.
//
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


private var searchFirebaseServiceInstance:SearchFirebaseService! = SearchFirebaseService()

class SearchFirebaseService: NSObject {
    
    let firebaseRef = Database.database().reference()
    
    let followerReference = Database.database().reference().child("Followers_")
    
    let followingReference = Database.database().reference().child("Following_")
    
    let currentUser = Auth.auth().currentUser
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    //let followerIdReference = Database.database().reference().childByAutoId().key
    
    let followingIdReference = Database.database().reference().childByAutoId().key
    
    
    class var sharedInstance : SearchFirebaseService {
        return searchFirebaseServiceInstance
    }
    
    override init() {
    }
    
    func followers (details:NSMutableDictionary){
        let followerIdReference = Database.database().reference().childByAutoId().key
        self.followerReference.child(followerIdReference).setValue(details)
    }
    
    func following(details:NSMutableDictionary){
     self.followingReference.child(followingIdReference).setValue(details)
    }
    
    func unFollower(details:String){
    
      //  self.followerReference.child(followerIdReference).child(details).setValue(NSNull())
    }
    
    func unFollowing(details:String){
    self.followingReference.child(followingIdReference).child(details).setValue(NSNull())
    }

}
