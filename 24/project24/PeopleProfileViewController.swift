//
//  PeopleProfileViewController.swift
//  project24
//
//  Created by sri on 17/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth



class PeopleProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User!
    var Posts : [Post] = []
    var userId = ""
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        myPosts()
        fetchUser()
        print("the userId is : \(userId)")
    }
    
    func myPosts() {
        
        FirebaseService.sharedInstance.firebaseRef.child("MyPosts").child(userId).observe(.childAdded, with: { snapshot in
            
            FirebaseService.sharedInstance.MYFEED(postId: snapshot.key, completion: { post in
                self.Posts.append(post)
                self.tableview.reloadData()
            })
        })
    }
    
    func goToSettingVC(){
        
        performSegue(withIdentifier: "ProfileUserSettingSegue", sender: nil)
        
    }
    
    func fetchUser() {
        
        if userId == Auth.auth().currentUser?.uid {
         navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettingVC))
        }else{
        navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        
        FirebaseService.sharedInstance.observeUser(withId: userId) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            print("the user name is :\(user.username)")
            self.tableview.reloadData()
        }
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
