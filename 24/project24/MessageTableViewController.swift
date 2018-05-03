//
//  MessageTableViewController.swift
//  project24
//
//  Created by sri on 05/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessageTableViewController: UITableViewController {
    
    var user : User!
    var Users = [User]()
    var messages : [Messages] = []
    var messageDictionary = [String : Messages]()
    //var chatPatnerId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username()
        observeMessages()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        
        if let chatPatnerId = message.chatPatnerId(){
            
            Database.database().reference().child("UserMessages").child(uid).child(chatPatnerId).removeValue(completionBlock: { (error, ref) in
            if error != nil {
            return
            }
            self.messageDictionary.removeValue(forKey: chatPatnerId)
            self.attemptReloadOfTable()
            })
        }
    }
    
    func observeMessages(){
        
        let currentUserId = Auth.auth().currentUser?.uid
        
        
       let ref =  FirebaseService.sharedInstance.firebaseRef.child("User-Messages").child(currentUserId!)
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            
            let userId = snapshot.key
            
            Database.database().reference().child("User-Messages").child(currentUserId!).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                
                let messageReference = Database.database().reference().child("Messages").child(messageId)
                messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dict = snapshot.value as? [String : Any]{
                        let message = Messages.transformMessage(dict: dict, key: snapshot.key)
                        
                        if let chatPatnerId = message.chatPatnerId(){
                            
                            self.messageDictionary[chatPatnerId] = message
                            
                            self.messages = Array(self.messageDictionary.values)
                            self.messages.sort(by: { (message1, message2) -> Bool in
                                
                                let message1TP = (message1.timeStamp?.intValue)!
                                let message2TP = (message2.timeStamp?.intValue)!
                                
                                return message1TP > message2TP
                            })
                        }
                        self.handelReloadTable()
                        //self.attemptReloadOfTable()
//                        DispatchQueue.main.async(execute: {
//                            self.tableView.reloadData()
//                        })
                    }
                }, withCancel: nil)
                
                //self.fetchMessageWithMessageId(messageId: messageId)
            }, withCancel: nil)
            return
        })
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId : String){
    
//        let messageReference = Database.database().reference().child("Messages").child(messageId)
//        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dict = snapshot.value as? [String : Any]{
//                let message = Messages.transformMessage(dict: dict, key: snapshot.key)
//
//                if let chatPatnerId = message.chatPatnerId(){
//                    
//                    self.messageDictionary[chatPatnerId] = message
//                }
//                self.attemptReloadOfTable()
//            }
//        }, withCancel: nil)
    
    }
    
    private func  attemptReloadOfTable(){
    
        self.timer?.invalidate()
        self.timer =  Timer.init(timeInterval: 0.01, target: self, selector: #selector(self.handelReloadTable), userInfo: nil, repeats: false)

    
    }
    
    var timer : Timer?
    
    func handelReloadTable(){
        
//        self.messages = Array(self.messageDictionary.values)
//        self.messages.sort(by: { (message1, message2) -> Bool in
//            
//            let message1TP = (message1.timeStamp?.intValue)!
//            let message2TP = (message2.timeStamp?.intValue)!
//            
//            return message1TP > message2TP
//        })
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    @IBAction func peopleBtn(_ sender: Any) {
        
        let messageController = MessagePeopleTableViewController()
        messageController.message = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        let messageData = messages[indexPath.row]
        cell.getMessages(messageData: messageData)

        if let msgUserId = messageData.chatPatnerId() {
            
            print("this is toId : \(msgUserId)")
            Database.database().reference().child("Users").child(msgUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                print("this is snapshot : \(snapshot)")
                
                if let dict = snapshot.value as? [String : AnyObject]{
                    cell.usernameLabel.text = dict["Username"] as? String
                }
            }, withCancel: nil)
        }
        return cell
    }
    
    var messageController : MessagePeopleTableViewController?

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let message = messages[indexPath.row]

        guard let chatPatnerId = message.chatPatnerId() else {
        return
        }
        let ref = Database.database().reference().child("Users").child(chatPatnerId)
        ref.observeSingleEvent(of: .value , with: { (snapshot) in

            guard let dict = snapshot.value as? [String : AnyObject] else{
            return
            }

            self.user = User.transformUser(dict: dict, key: chatPatnerId)
            self.showChatForUsers(user: self.user)
 
        }, withCancel: nil)
    }
    
    func showChatForUsers(user : User){

        performSegue(withIdentifier: "MessagesTochatViewcontroller", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessagesTochatViewcontroller" {
            
            let destinationVC = segue.destination as? ChatViewController
            destinationVC?.user = User()
            destinationVC?.user = user
        }
    }
    
    func username(){
        
        if let userId = Auth.auth().currentUser?.uid{
            FirebaseService.sharedInstance.firebaseRef.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:Any]{
                    let user = User.transformUser(dict: dict, key: snapshot.key)
                    self.navigationItem.title = user.username
                    
                }
            })
        }
    }
}
