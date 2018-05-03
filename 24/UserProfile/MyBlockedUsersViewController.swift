//
//  MyBlockedUsersViewController.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class MyBlockedUsersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var blockedUsersNavigationView: UIView!
    @IBOutlet weak var blockedUsersLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var navigationBarSeperatorView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var blockedUsersList  = [MyBlockedUsers]()
    var parameters = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
        tableView.dataSource = self
        
        myBlockedUsersRequest()
        navigationViewAllignments()
        tableView.frame =  CGRect(x:0, y:  75, width: screenSize.width, height: screenSize.height - 75)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBlockedUsersTableViewCell", for: indexPath) as! MyBlockedUsersTableViewCell
        let data = blockedUsersList[indexPath.row]
        cell.usernameLabel.text = data.username
        cell.buttonAction = { (sender) in
            self.myUnBlockUsersRequest()
            
        }
        return cell
    }
    
    func navigationViewAllignments(){
        blockedUsersNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        blockedUsersLabel.frame = CGRect(x: (blockedUsersNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
        backBtnOutlet.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
        navigationBarSeperatorView.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
    
    func myBlockedUsersRequest(){
        
        parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/my_blocked_users") { (isSucess, message, data) in
            if isSucess {
                if let responseArray = data["blocked_users"] as? [[String:Any]] {
                    
                    for dict in responseArray {
                        let myBlockedUsersList = MyBlockedUsers(dict: dict)
                        self.blockedUsersList.append(myBlockedUsersList)
                    }
                }
            }else {
                
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func clickOnBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func myUnBlockUsersRequest(){
        
        parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature,"follower_id": "35"]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }
    }
    
    
}
