//
//  SearchViewController.swift
//  project24
//
//  Created by sri on 16/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol TagPeopleDelegate {
    func tagPeople(userDetails: String)
}

class SearchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , PeopleViewControllerDelegate {
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "PeopleProfileViewControllerSegue", sender: userId)
    }

    @IBOutlet var tableview: UITableView!
    
    var delegate : TagPeopleDelegate?
    var searchbar = UISearchBar()
    var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        print("no. of users : \(users.count)")
            
            searchbar.searchBarStyle = .minimal
            searchbar.placeholder = "search"
            searchbar.delegate = self
            searchbar.frame.size.width = view.frame.size.width - 60
            
            let searchItem = UIBarButtonItem(customView: searchbar)
            self.navigationItem.rightBarButtonItem = searchItem
        doSearch()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PeopleProfileViewControllerSegue" {
            let profileVC = segue.destination as! PeopleProfileViewController
            let userId = sender  as! String
            profileVC.userId = userId
        }
    }

    
    func doSearch (){
        
        if let searchText = searchbar.text?.lowercased() {
            self.users.removeAll()
            self.tableview.reloadData()
            queryUsers(withText: searchText, completion: { (user) in
                self.IsFollowing(userId: user.id!, completion: { (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    
                    self.tableview.reloadData()
                    print("no. of users : \(self.users.count)")
                })
            })
        }
    }
    
    func queryUsers(withText text: String, completion: @escaping (User) -> Void) {
        Database.database().reference().child("Users").queryOrdered(byChild: "Username").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    func IsFollowing (userId : String , completion : @escaping (Bool) -> Void){
        isFolowing(userId: userId, completion: completion)
    }
    
    func isFolowing(userId : String, completion: @escaping(Bool)->Void){
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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        if let username = user.username{
        delegate?.tagPeople(userDetails: username)
        }
        dismiss(animated: true, completion: nil)
    }


}
