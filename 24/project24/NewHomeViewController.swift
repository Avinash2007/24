//
//  NewHomeViewController.swift
//  
//
//  Created by sri on 19/09/17.
//
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()

    @IBOutlet weak var homeViewTapped: UIImageView!
    @IBOutlet weak var messageViewTapped: UIImageView!
    @IBOutlet weak var searchViewTapped: UIImageView!
    @IBOutlet weak var notificationViewTapped: UIImageView!
    @IBOutlet weak var profileViewTapped: UIImageView!
    
    @IBOutlet weak var userProfileCollectionView: UICollectionView!
    @IBOutlet weak var userPostsCollectionView: UICollectionView!

    
   // var Posts: [Post] = []
     //var userId : String?
    
    
    var stories: [Stories] = []
  //  var folderStories: [Stories] = []
    
    var folderId : [String] = []
    var stories_dict : [String : [Stories]] = [:]
    
     var followers : [Followers] = []
    var foldersModel : [Folders] = []
    
   // var folderData : [Stories] = []
  //  var sortedFolderIds : NSMutableArray = []
    
    //var postId : String?
    
    var height : CGFloat?
    var width : CGFloat?
    
    var folderTapped : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileCollectionView.dataSource = self
        userProfileCollectionView.delegate = self
        
        userPostsCollectionView.delegate = self
        userPostsCollectionView.dataSource = self
        
        callingAllGestureFunctions()
        
        fetchUsers()
        
        height = 120
        width = 80
        
        folderTapped  = false
        //fetchUsersStories()
        //fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchUsersStories()
        
        print("called")
    }
    
    
    func fetchfolders(){
        for temp : String in folderId{
        
            Database.database().reference().child("Folders").queryOrdered(byChild: "FolderId").queryEqual(toValue: temp).observe(.value, with: { (snapshot) in
                for user in snapshot.children{
                    if let dict = (user as! DataSnapshot).value as? [String : Any] {
                        let folders = Folders.transformFolder(dict: dict, key: snapshot.key)
                        self.foldersModel.append(folders)
                        
                    }
                }
                print("folderModel@\(self.foldersModel)")
                self.userPostsCollectionView.reloadData()
            })
        }
    }
    
    
    func fetchUsers(){
        
        Database.database().reference().child("Followers_").queryOrdered(byChild: "Current_User_Id").queryEqual(toValue: Auth.auth().currentUser?.uid).observe(.value, with: { (snapshot) in

            for user in snapshot.children{
                
                if let dict = (user as! DataSnapshot).value as? [String : Any] {
                
                    let followers = Followers.transformFollowers(dict: dict, key: snapshot.key)
                    
                    if Int(followers.numberOf_Folders!)! > 0{
                    
                    self.followers.append(followers)
                    }
                }
            }
            self.userProfileCollectionView.reloadData()
        })
    }
    
    func folders(followerUserId : String,completionBlock:@escaping ()->Void){
    
        self.stories = []
        
        Database.database().reference().child("Stories_").queryOrdered(byChild: "Uid").queryEqual(toValue: followerUserId).observe(.value, with: { (snapshot) in
            
            for posts in snapshot.children{
                
                if let dict = (posts as! DataSnapshot).value as? [String : Any] {

                    let stories = Stories.transformStories(dict: dict, key: snapshot.key)
                  //  self.folderStories.append(stories)
                    self.stories.append(stories)
                    self.folderId.append(stories.folderId!)
                    print(self.folderId)
                    self.folderId = self.removeDuplicatevalues(array: self.folderId)
                    self.sortStories()
                }
            }
            completionBlock()
            self.userPostsCollectionView.reloadData()
        })
    }
    
    func fetchStories(folderId: String){
    
        self.stories = [Stories]()
        
        Database.database().reference().child("Stories_").queryOrdered(byChild: "FolderId").queryEqual(toValue: folderId).observe(.value, with: { (snapshot) in
          
            for stories in snapshot.children{
                
                if let dict = (stories as! DataSnapshot).value as? [String : Any] {
                    
                    let stories = Stories.transformStories(dict: dict, key: snapshot.key)
                    self.stories.append(stories)
                }
            }
            self.height =  375
            self.width = 375
            self.userPostsCollectionView.reloadData()
        })
    }
    

       /////////////////////////////////////
    
    
    func removeDuplicatevalues(array : [String]) -> [String]{
        
        let arrayWithUniques = Array(Set(array))
        //  print(arrayWithUniques)
        return arrayWithUniques
    }
    
    func sortStories(){

        for temp : String in folderId{
            var array : [Stories] = []
            for obj : Stories in self.stories{
                
                if temp == obj.folderId {
                    
                    array.append(obj)
                    
                }
            }
            stories_dict.updateValue(array, forKey: temp)
        }
    }
    
    ///////////////////////////
    

    
    
   
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if(collectionView == self.userProfileCollectionView)
        {
        
            return self.followers.count

        }
        else{
            if folderTapped == true{
                return self.stories.count
            } else{
            
                return foldersModel.count
            }
            
        }
    
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.userProfileCollectionView)
        {
        let cell = userProfileCollectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCollectionViewCell", for: indexPath) as! UserProfileCollectionViewCell
            let data = self.followers[indexPath.row]
            cell.getData(data: data)
        
            return cell
        }
         else{
        
            let cell2 = userPostsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionViewCellId", for: indexPath) as! UserPostsCollectionViewCell
            
            if folderTapped == true {
                let data = stories[indexPath.row]
                cell2.getStories(data: data)
            } else{
                let data = foldersModel[indexPath.row]
                cell2.getData(data: data)
            }

            return cell2
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == self.userProfileCollectionView)
        {
            print("selected")
            let data = self.followers[indexPath.row]
            if let followerUserId = data.followerId {
                folders(followerUserId: followerUserId, completionBlock: { 
                    print("completed")
                    self.fetchfolders()
                    self.folderTapped = false
                })
            }
        }
        else{
            if folderTapped == false{
                let data = self.foldersModel[indexPath.row]
                folderTapped = true
                if let folderId = data.folderId{
                    self.fetchStories(folderId: folderId)

                }
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == userPostsCollectionView {
            
            if folderTapped == true{
            return CGSize(width: 375, height: 375)
            }else{
                return CGSize(width: 120, height: 120)
            }
        } else{
        return CGSize(width: 75, height: 75)
        }
    }

//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stories.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//            let cell = storiesImageTableView.dequeueReusableCell(withIdentifier: "StoriesViewTableViewCellIdentifier", for: indexPath) as! StoriesViewTableViewCell
//            let data = stories[indexPath.row]
//        print("stories@\(data.caption)")
//            cell.getData(data: data)
//
//        return cell
//
//    }
}

extension NewHomeViewController{
    
    func callingAllGestureFunctions(){
    
        gestur()
        messageViewTap()
        searchViewTap()
        notificationViewTap()
        profileViewTap()
        
    }

    func messageViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageTap))
        messageViewTapped.addGestureRecognizer(tapGesture)
        messageViewTapped.isUserInteractionEnabled = true
        
    }
    func searchViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTap))
        searchViewTapped.addGestureRecognizer(tapGesture)
        searchViewTapped.isUserInteractionEnabled = true
        
    }
    func notificationViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationTap))
        notificationViewTapped.addGestureRecognizer(tapGesture)
        notificationViewTapped.isUserInteractionEnabled = true
        
    }
    func profileViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        profileViewTapped.addGestureRecognizer(tapGesture)
        profileViewTapped.isUserInteractionEnabled = true
        
    }
    
    func gestur(){
        
        swipeLeftRec.addTarget(self, action: #selector(self.messageTap) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
    }
    func messageTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func searchTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func notificationTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func profileTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    
}
