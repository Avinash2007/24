//
//  FirebaseService.swift
//  project24
//
//  Created by sri on 27/07/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import AVFoundation

private var firebaseInstance:FirebaseService! = FirebaseService()

class FirebaseService: NSObject {
    
    //MARK: Post Database Reference
    let firebaseRef = Database.database().reference()
    
    
    
    //MARK: Post Storage Reference
    let postStorageRef = Storage.storage().reference(forURL: "gs://project24-129e6.appspot.com").child("post")
    
    //MARK: Post Reference
    
    let postReference = Database.database().reference().child("post")
    
    //MARK: Current User
    
    let currentUser = Auth.auth().currentUser
    
    
    //MARK:CurrentUIserId
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    //MARK: PostId Reference
    
    let PostIdReference = Database.database().reference().childByAutoId().key
    
    //Posts Diaplaying On their NewsFeed
    let MYFEED = Database.database().reference().child("Feed").child((Auth.auth().currentUser?.uid)!)
    
    //Posts Displaying On My Profile
    let MYPOSTS = Database.database().reference().child("MyPosts").child((Auth.auth().currentUser?.uid)!)

    
    //Shout Diaplaying On their NewsFeed
    let MYSHOUTFEED = Database.database().reference().child("StoriesFeed").child((Auth.auth().currentUser?.uid)!)
    
    let MYSTORIESFEED = Database.database().reference().child("StoriesFeed").child((Auth.auth().currentUser?.uid)!)
    
    //Shout Displaying On My Profile
    let MYSHOUTS = Database.database().reference().child("Mystories").child((Auth.auth().currentUser?.uid)!)
    
    //OnBoard Diaplaying On their NewsFeed
    let MYONBOARDFEED = Database.database().reference().child("OnBoardFeed").child((Auth.auth().currentUser?.uid)!)
    
    //OnBoard Displaying On My Profile
    let MYONBOARD = Database.database().reference().child("MyOnBoard").child((Auth.auth().currentUser?.uid)!)

    
    
    //Other Profiles
    

    
    
    class var sharedInstance : FirebaseService {
        return firebaseInstance
    }
    
    override init() {
    }
    
    //Logout Services
    
    func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }    
    
    //Getting User Details
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        firebaseRef.child("Users").child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    
    //Getting Current Users Details
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let ref = Database.database().reference()
        ref.child("Users").child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    //Shouts displaying on their feed
    
//    func MYSHOUTFEED(shoutId id: String, completion: @escaping (Shout) -> Void){
//        
//        firebaseRef.child("Stories").child(id).observeSingleEvent(of: .value, with: { snapshot in
//            if let dict = snapshot.value as? [String : Any]{
//                let shout = Shout.transformShout(dict: dict, key: snapshot.key)
//                completion(shout)
//            }
//        })
//    }
    
    
    func MYSHOUTFEED(shoutId id: String, completion: @escaping (Stories) -> Void){
        
        firebaseRef.child("Stories").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let stories = Stories.transformStories(dict: dict, key: snapshot.key)
                completion(stories)
            }
        })
    }

    //OnBoard displaying on their feed
    
    func MYONBOARDFEED(shoutId id: String, completion: @escaping (OnBoard) -> Void){
        
        firebaseRef.child("OnBoard").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let onBoard = OnBoard.transformBoard(dict: dict, key: snapshot.key)
                completion(onBoard)
            }
        })
    }

    
    //Posts displaying on their Newsfeed
    func MYFEED(postId id: String, completion: @escaping (Post) -> Void){
        
        firebaseRef.child("Posts").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let post = Post.transformPost(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    //Sharing Posts
    
    func SHAREPOSTS(postId: String, completion: @escaping () -> ()){
    
        FirebaseService.sharedInstance.firebaseRef.child("SharedPosts").child(currentUserId!).child(postId).setValue("true")
        completion()
    
    }
    
    //Getting Shared Posts To Feeds
    
    func FEEDSHAREPOSTS(postId: String){
        
        FirebaseService.sharedInstance.firebaseRef.child("Feed").child(currentUserId!).child(postId).setValue("true")
        
    }
    
    
    // ONBOARD
    
    func onBoard (onBoardImage:UIImage,onBoardDetails:NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
        
        // OnBoard
        self.imageUploadToFirebase(postImage: onBoardImage, completionPostUpload: { (urlStr) in
            print(urlStr)
            
            //MARK: Shout Reference
            let uid = Database.database().reference().childByAutoId().key
            
            let currentUserUid = Auth.auth().currentUser?.uid
            
            onBoardDetails["photoUrl"] = urlStr
            onBoardDetails["uid"] = currentUserUid
            
            //MARK: Shout Reference
            
            self.firebaseRef.child("OnBoard").child(uid).setValue(onBoardDetails, withCompletionBlock: { (error, refer) in
                completionBlock(true)
                
            })
            self.firebaseRef.child("MyOnBoard").child(currentUserUid!).child(uid).setValue(true)
            self.firebaseRef.child("OnBoardFeed").child(currentUserUid!).child(uid).setValue(true)
            
        })
    }
    
    //PostStories
    
    
    func stories(storiesImage:UIImage,storiesDetails:NSMutableDictionary,completionBlock:@escaping (_ StoriesId:String)->Void){
    
        self.imageUploadToFirebase(postImage: storiesImage) { (urlStr) in
            
            let StoriesId = Database.database().reference().childByAutoId().key

            let FolderId = Database.database().reference().childByAutoId().key
            
            storiesDetails["photoUrl"] = urlStr
            storiesDetails["uid"] = Auth.auth().currentUser?.uid
            storiesDetails["FolderId"] = FolderId
            
            self.firebaseRef.child("Stories").child(StoriesId).setValue(storiesDetails, withCompletionBlock: { (error, refer) in
                completionBlock(StoriesId)
            })
            
            self.firebaseRef.child("MyStories").child((Auth.auth().currentUser?.uid)!).child(StoriesId).setValue(true)
            self.firebaseRef.child("StoriesFeed").child((Auth.auth().currentUser?.uid)!).child(StoriesId).setValue(true)
            
        }

    }
    
    func MYSTORIESFEED(storiesId id : String, completion: @escaping(Stories) -> Void){
    
        firebaseRef.child("Stories").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String : Any]{
            
                let stories = Stories.transformStories(dict: dict, key: snapshot.key)
                completion(stories)
                
            }
        })
     
    }
    

    
    
    // Post Shout
    
    func shout (shoutImage:UIImage,shoutDetails:NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
        
        // shout
        self.storiesImageUploadToFirebase(postImage: shoutImage, completionPostUpload: { (urlStr) in
            print(urlStr)
            
            //MARK: Shout Reference
            let shoutId = Database.database().reference().childByAutoId().key
            let FolderId = Database.database().reference().childByAutoId().key
            
            let currentUserUid = Auth.auth().currentUser?.uid
            
            
            shoutDetails["photoUrl"] = urlStr
            shoutDetails["uid"] = Auth.auth().currentUser?.uid
            shoutDetails["FolderId"] = FolderId

            
            //MARK: Shout Reference
            
            self.firebaseRef.child("Stories").child(shoutId).setValue(shoutDetails, withCompletionBlock: { (error, refer) in
                completionBlock(true)
                
            })
            self.firebaseRef.child("MyStories").child(currentUserUid!).child(shoutId).setValue(true)
            self.firebaseRef.child("StoriesFeed").child(currentUserUid!).child(shoutId).setValue(true)

        })
    }
//
    
    
//    // Post Shout
//    
//    func shout (shoutImage:UIImage,folderImage:UIImage,shoutDetails:NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
//        
//        // shout
//        self.storiesImageUploadToFirebase(postImage: shoutImage, completionPostUpload: { (urlStr) in
//            print(urlStr)
//            
//            self.storiesFolderImageUploadToFirebase(folderImage: folderImage, completionPostUpload: { (folderImageUrlString) in
//                
//                
//                //MARK: Shout Reference
//                let shoutId = Database.database().reference().childByAutoId().key
//                let FolderId = Database.database().reference().childByAutoId().key
//                
//                let currentUserUid = Auth.auth().currentUser?.uid
//                
//                shoutDetails["photoUrl"] = urlStr
//                shoutDetails["uid"] = self.currentUserId
//                shoutDetails["FolderId"] = urlStr
//                shoutDetails["FolderImageUrl"] = folderImageUrlString
//                
//                //MARK: Shout Reference
//                
//                self.firebaseRef.child("Stories").child(shoutId).setValue(shoutDetails, withCompletionBlock: { (error, refer) in
//                    completionBlock(true)
//                    
//                })
//                self.firebaseRef.child("MyStories").child(currentUserUid!).child(shoutId).setValue(true)
//                self.firebaseRef.child("StoriesFeed").child(currentUserUid!).child(shoutId).setValue(true)
//            })
//        })
//    }
    
    
    
    //MARK: Image Upload
    func storiesImageUploadToFirebase(postImage:UIImage,completionPostUpload:@escaping (_ photoUrl:String)->Void){
        
        //Auto Genarated key
        postStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(postImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let photoUrl = metadata?.downloadURL()?.absoluteString
            completionPostUpload(photoUrl!)
        })
    }

    //MARK: Image Upload
    func storiesFolderImageUploadToFirebase(folderImage:UIImage,completionPostUpload:@escaping (_ photoUrl:String)->Void){
        
        //Auto Genarated key
        postStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(folderImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let folderPhotoUrl = metadata?.downloadURL()?.absoluteString
            completionPostUpload(folderPhotoUrl!)
        })
    }
    
    
    
    
    
    //Post Image
    
    func post (postImage:UIImage,postDetails:NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
        
        // post Upload
        self.imageUploadToFirebase(postImage: postImage, completionPostUpload: { (urlStr) in
            print(urlStr)
            
            //MARK: Post Reference
            let uid = Database.database().reference().childByAutoId().key
            let currentUserUid = Auth.auth().currentUser?.uid
            
            
            postDetails["photoUrl"] = urlStr
            postDetails["uid"] = self.currentUserId
            
            //MARK: Post Reference
            
            self.firebaseRef.child("Posts").child(uid).setValue(postDetails, withCompletionBlock: { (error, refer) in
                completionBlock(true)
                
            })
            self.firebaseRef.child("MyPosts").child(currentUserUid!).child(uid).setValue(true)
            self.firebaseRef.child("Feed").child(currentUserUid!).child(uid).setValue(true)
            
        })
    }
    
    //MARK: Image Upload
    func imageUploadToFirebase(postImage:UIImage,completionPostUpload:@escaping (_ photoUrl:String)->Void){
        
        //Auto Genarated key
        postStorageRef.child(firebaseRef.childByAutoId().key).putData(UIImageJPEGRepresentation(postImage, 0.1)!, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                return
            }
            let photoUrl = metadata?.downloadURL()?.absoluteString
            completionPostUpload(photoUrl!)
        })
    }
    
    //MARK: Upload VideoReference To Database
    
    func postVideo(uploadVideoUrl: NSURL,properties: NSMutableDictionary,completionBlock:@escaping (Bool)->Void){
        
        let uid = Database.database().reference().childByAutoId().key
        let currentUserUid = Auth.auth().currentUser?.uid

        
        handleVideoSelectForUrl(uploadVideoUrl: uploadVideoUrl) { (properties) in
         
            self.firebaseRef.child("Stories").child(uid).setValue(properties, withCompletionBlock: { (error, refer) in
                completionBlock(true)
            })
            
            self.firebaseRef.child("MyStories").child(currentUserUid!).child(uid).setValue(true)
            self.firebaseRef.child("StoriesFeed").child(currentUserUid!).child(uid).setValue(true)
            
        }
    }
    
    //MARK: Upload video To Storage
    
    func handleVideoSelectForUrl(uploadVideoUrl: NSURL,completionBlock:@escaping (_ details:NSMutableDictionary)->Void){
        
        let filename = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("video_stories").child(filename).putFile(from: uploadVideoUrl as! URL, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                return
            }
            if let videoUrl = metadata?.downloadURL()?.absoluteString{
                
                if let thumbnailImage = FirebaseService.sharedInstance.thumbnailImageForFileUrl(fileUrl: uploadVideoUrl){
                    
                    FirebaseService.sharedInstance.uploadImageToFirebase(image: thumbnailImage, completion: { (thumbnailImageUrl) in
                        
                        let properties: [String: AnyObject] = ["thumbnailImageUrl":thumbnailImageUrl as AnyObject,"videoUrl": videoUrl as AnyObject]
                            completionBlock(properties as! NSMutableDictionary)
                    })
                }
            }
        })
    }
    
    
    //MARK: Gemerate Thumbnail Image
    
    func thumbnailImageForFileUrl(fileUrl : NSURL) -> UIImage?{
        
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage : thumbnailCGImage)
        }catch let err {
            
        }
        return nil
    }
    
    //MARK: Upload Thumbnail Image to Storage
    
    func uploadImageToFirebase(image : UIImage, completion: @escaping (_ thumbnailImageUrl: String) -> ()){
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("thumbnailImageUrl").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            
            ref.putData(uploadData, metadata : nil,completion :{(metadata,error) in
                
                if error != nil {
                    return
                }
                if let thumbnailImageUrl = metadata?.downloadURL()?.absoluteString{
                    
                    completion(thumbnailImageUrl)
                }
            })
        }
    }

}
