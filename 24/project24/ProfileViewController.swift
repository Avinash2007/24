//
//  profileViewController.swift
//  
//
//  Created by sri on 31/07/17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var user: User!
    var Posts : [Post] = []
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var sendMessageBtnOutlet: UIButton!
    @IBOutlet weak var followBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        myPosts()
        fetchUser()
        goToSetting()
        outlineBorder()
        roundedRectangleShape(button: sendMessageBtnOutlet)
        roundedRectangleShape(button: followBtnOutlet)
    }
    
    func outlineBorder(){
    
        sendMessageBtnOutlet.layer.borderWidth = 1/UIScreen.main.nativeScale
        sendMessageBtnOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func roundedRectangleShape(button : UIButton){
        
        button.layer.cornerRadius = 8
        
        let cornerRadius: CGFloat = 8
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = UIBezierPath(
            roundedRect: button.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath
        
        button.layer.mask = maskLayer
        
    }
    
    func goToSettingVC(){
    
        performSegue(withIdentifier: "ProfileSettingSegue", sender: nil)
        
    }
    
    func goToSetting(){
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettingVC))
        
    }

    
    
    func myPosts() {
    
        FirebaseService.sharedInstance.MYPOSTS.observe(.childAdded, with: { snapshot in
            
            FirebaseService.sharedInstance.MYFEED(postId: snapshot.key, completion: { post in

                self.Posts.append(post)

                self.tableview.reloadData()
            })
        })
    }
    
    func fetchUser() {
        
        FirebaseService.sharedInstance.observeCurrentUser { (user) in
            self.user = user
            self.profileNameLabel.text = user.username
            if let photoUrl = URL(string: user.profileImageUrl!){
                self.profileImage.sd_setImage(with: photoUrl)
            }

            self.tableview.reloadData()
        }
    }
    
    func followStatus(){
    
        if user?.isFollowing == true{
            
            self.followingBtnConfi()
            
        } else {
            
            self.followBtnConfi()
            
        }
        
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
            
            //            followBtnOutlet.setTitle("following", for: UIControlState.normal)
            //            followBtnOutlet.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
            
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
            
            //            followBtnOutlet.setTitle("follow", for: UIControlState.normal)
            //            followBtnOutlet.addTarget(self, action: #selector(follow), for: .touchUpInside)
            
            
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMyPostsCell", for: indexPath) as! ProfileTableViewCell
        
        let data = Posts[indexPath.row]
        cell.getData(data: data)
        
        return cell
    }
    
}
