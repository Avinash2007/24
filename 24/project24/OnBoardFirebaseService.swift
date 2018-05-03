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


private var onBoardFirebaseServiceInstance:OnBoardFirebaseService! = OnBoardFirebaseService()

class OnBoardFirebaseService: NSObject {
    
    let firebaseRef = Database.database().reference()
    
    let storiesStorageRef = Storage.storage().reference(forURL: "gs://project24-129e6.appspot.com").child("OnBoard")
    
    let onBoardReference = Database.database().reference().child("OnBoard_")
    
    let currentUser = Auth.auth().currentUser
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    let onBoardIdReference = Database.database().reference().childByAutoId().key
    
    let ONBOARD_FEED = Database.database().reference().child("OnBoardFeed_").child((Auth.auth().currentUser?.uid)!)
    
    
    
    class var sharedInstance : OnBoardFirebaseService {
        return onBoardFirebaseServiceInstance
    }
    
    override init() {
    }
    
    func ONBOARD_FEED(onBoardId id: String, completion: @escaping (OnBoard) -> Void){
        
        onBoardReference.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let onBoard = OnBoard.transformBoard(dict: dict, key: snapshot.key)
                completion(onBoard)
            }
        })
    }
    
    func onBoard (onBoardImage:UIImage,onBoardDetails:NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
        
        // OnBoard
        self.imageUploadToFirebase(onBoardImage: onBoardImage, completionOnBoardUpload: { (urlStr) in
            print(urlStr)
            
            //MARK: Shout Reference
            let uid = Database.database().reference().childByAutoId().key
            
            let currentUserUid = Auth.auth().currentUser?.uid
            
            onBoardDetails["PhotoUrl"] = urlStr
            onBoardDetails["Uid"] = currentUserUid
            
            //MARK: Shout Reference
            
            self.onBoardReference.child(uid).setValue(onBoardDetails, withCompletionBlock: { (error, refer) in
                completionBlock(true)
                
            })
            self.firebaseRef.child("MyOnBoard").child(currentUserUid!).child(uid).setValue(true)
            self.ONBOARD_FEED.child(currentUserUid!).child(uid).setValue(true)
            
        })
    }
    
    
    func imageUploadToFirebase(onBoardImage:UIImage,completionOnBoardUpload:@escaping (_ onBoardPhotoUrl:String)->Void){
        
        //Auto Genarated key
        storiesStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(onBoardImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let onBoardPhotoUrl = metadata?.downloadURL()?.absoluteString
            completionOnBoardUpload(onBoardPhotoUrl!)
        })
    }
}
