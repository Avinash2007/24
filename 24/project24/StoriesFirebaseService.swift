//
//  StoriesFirebaseService.swift
//  project24
//
//  Created by sri on 28/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


private var storiesFirebaseServiceInstance:StoriesFirebaseService! = StoriesFirebaseService()

class StoriesFirebaseService: NSObject {
    
    let firebaseRef = Database.database().reference()
    
    let storiesStorageRef = Storage.storage().reference(forURL: "gs://project24-129e6.appspot.com").child("Stories")
    
    let folderImageStorageRef = Storage.storage().reference(forURL: "gs://project24-129e6.appspot.com").child("Folder_Images")
    
    let storiesReference = Database.database().reference().child("Stories_")
    
    let currentUser = Auth.auth().currentUser
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    let storiesIdReference = Database.database().reference().childByAutoId().key

    let STORIES_FEED = Database.database().reference().child("StoriesFeed_").child((Auth.auth().currentUser?.uid)!)
    
    let MY_STORIES = Database.database().reference().child("MyStories_").child((Auth.auth().currentUser?.uid)!)

   // let STORIES_FOLDERID = Database.database().reference().child("StoriesFolderId_")
    
    //let USER_STORIES_FOLDERID = Database.database().reference().child("User_StoriesFolderId_")
    
    
    class var sharedInstance : StoriesFirebaseService {
        return storiesFirebaseServiceInstance
    }
    
    override init() {
    }
    
    
    

    func STORIES_FEED(storiesId id: String, completion: @escaping (Stories) -> Void){
        
        firebaseRef.child("Stories_").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let stories = Stories.transformStories(dict: dict, key: snapshot.key)
                completion(stories)
            }
        })
    }
    
    
    
    

    
    func stories(storiesImage:UIImage,folderImage:UIImage,storiesDetails:NSMutableDictionary,completionBlock:@escaping (_ StoriesId:String,  _ folderImageUrl : String,_ folderId:String)->Void){
        
        self.imageUploadToFirebase(storiesImage: storiesImage) { (urlStr) in
            
            self.folderImageUploadToFirebase(FolderImage: folderImage, completionFolderImageUpload: { (folderImageUrlStr) in
              
                let folderIdReference = Database.database().reference().childByAutoId().key
                
                storiesDetails["PhotoUrl"] = urlStr
                storiesDetails["Uid"] = Auth.auth().currentUser?.uid
                storiesDetails["FolderId"] = folderIdReference
                storiesDetails["FolderImageUrl"] = folderImageUrlStr
                
                self.storiesReference.child(self.storiesIdReference).setValue(storiesDetails, withCompletionBlock: { (error, refer) in
                    completionBlock(self.storiesIdReference, folderImageUrlStr, folderIdReference)
                })
                
                self.MY_STORIES.child(self.storiesIdReference).setValue(true)
                self.STORIES_FEED.child(self.storiesIdReference).setValue(true)
//                self.STORIES_FOLDERID.child(folderIdReference).child(self.storiesIdReference).setValue(true)
//                self.USER_STORIES_FOLDERID.child((Auth.auth().currentUser?.uid)!).child(folderIdReference).setValue(true)

                
            })
        }
    }

    func imageUploadToFirebase(storiesImage:UIImage,completionStoriesUpload:@escaping (_ storiesPhotoUrl:String)->Void){
        
        //Auto Genarated key
        storiesStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(storiesImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let storiesPhotoUrl = metadata?.downloadURL()?.absoluteString
            completionStoriesUpload(storiesPhotoUrl!)
        })
    }
    func folderImageUploadToFirebase(FolderImage:UIImage,completionFolderImageUpload:@escaping (_ folderImagePhotoUrl:String)->Void){
        
        //Auto Genarated key
        folderImageStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(FolderImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let folderImagePhotoUrl = metadata?.downloadURL()?.absoluteString
            completionFolderImageUpload(folderImagePhotoUrl!)
        })
    }
}
