//
//  PeopleViewController.swift
//  project24
//
//  Created by sri on 01/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth

//class PeopleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource , PeopleViewControllerDelegate ,  PeopleProfileViewControllerDelegate2 ,  PeopleProfileViewControllerDelegate3 , PeopleProfileViewControllerDelegate4

class PeopleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
//    func goToProfileUserVC(userId: String) {
//       performSegue(withIdentifier: "ProfileSegue", sender: userId)
//        print("hello this is th euserId : \(userId)")
//    }
//    
//    func goToProfileUserVC2(userId: String) {
//        performSegue(withIdentifier: "ProfileSegue", sender: userId)
//        print("hello this is th euserId : \(userId)")
//    }
//    
//    func goToProfileUserVC3(userId: String) {
//        performSegue(withIdentifier: "ProfileSegue", sender: userId)
//        print("hello this is th euserId : \(userId)")
//    }

    var users: [User] = []

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        fetchUsers()
        }
    
    func fetchUsers(){
        
        FirebaseService.sharedInstance.firebaseRef.child("Users").observe(.childAdded, with: { (snapshot) in
            let dict = snapshot.value as? [String:Any]
            let user = User.transformUser(dict: dict!, key: snapshot.key)
            print(user)
            self.isFollowing(userId: user.id!, completion: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableview.reloadData()
            })
        })
    }
    
//    func IsFollowing (userId : String , completion : @escaping (Bool) -> Void){
//    isFollowing(userId: userId, completion: completion)
//    }
//    
    func isFollowing(userId : String, completion: @escaping(Bool)->Void){
         let currentUserId = Auth.auth().currentUser?.uid
        FirebaseService.sharedInstance.firebaseRef.child("followers").child(userId).child(currentUserId!).observeSingleEvent(of: .value, with: { snapshot in
        
            if let _ = snapshot.value as? NSNull {
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! PeopleProfileViewController
            let userId = sender  as! String
            profileVC.userId = userId
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let user = users[indexPath.row]
        cell.user = user
      //  cell.delegate = self
        
        return cell
    }
}
