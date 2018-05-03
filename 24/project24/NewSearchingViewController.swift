//
//  NewSearchingViewController.swift
//  project24
//
//  Created by sri on 26/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class NewSearchingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var usersDisplayTableView: UITableView!
    @IBOutlet weak var searchOutlet: UISearchBar!
    
     var users: [User] = []
    
    var user_Id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersDisplayTableView.delegate = self
        usersDisplayTableView.dataSource = self
        
        fetchUsers()


    }
    
    func fetchUsers(){
    
        FirebaseService.sharedInstance.firebaseRef.child("Users").observe(.childAdded, with: { (snapshot) in
            let dict = snapshot.value as? [String:Any]
            let user = User.transformUser(dict: dict!, key: snapshot.key)
            print(user)
            self.users.append(user)
            self.usersDisplayTableView.reloadData()
        })
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersDisplayTableView.dequeueReusableCell(withIdentifier: "UsersDisplayTableViewCell", for: indexPath) as? UsersDisplayTableViewCell
        
        let user = users[indexPath.row]
        cell?.user = user
        print(users.count)
        cell?.followBtnConfig(userId: user.id!)
        
        //cell?.userId = user_Id
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        user_Id = user.id


    }
    
}

