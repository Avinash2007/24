//
//  MessagePeopleTableViewController.swift
//  project24
//
//  Created by sri on 05/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagePeopleTableViewController: UITableViewController {
    
    var Users = [User]()
    var user :  User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let userId = Auth.auth().currentUser?.uid{
            FirebaseService.sharedInstance.firebaseRef.child("Users").observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                if let dict = snapshot.value as? [String:Any]{
                    let user = User.transformUser(dict: dict, key: snapshot.key)
                    self.Users.append(user)
                }
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            })
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return Users.count
    }
    
    var message : MessageTableViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
         user = self.Users[indexPath.row]
     
         showChatForUsers(user: user)

    }
    
    func showChatForUsers(user : User){
        performSegue(withIdentifier: "PeopleTochatViewcontroller", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PeopleTochatViewcontroller" {
            
             let destinationVC = segue.destination as? ChatViewController
                destinationVC?.user = User()
                destinationVC?.user = user
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagePeople", for: indexPath) as! MessagePeopleTableViewCell
        
        let data = Users[indexPath.row]
        cell.getData(data: data)
        return cell
    }

}
