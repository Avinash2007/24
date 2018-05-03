//
//  DisplayGroupsViewController.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DisplayGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var editGroupNavigationView: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var navigationBarSeperatorView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var groupsList = [GroupsDetails]()
    var groupId : Int?
    var groupName : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        
        displayUserGroupsRequests()
        navigationViewAllignments()
        
        tableView.frame = CGRect(x: 0, y: 75, width: screenSize.width, height: screenSize.height - 75)
    }

    func navigationViewAllignments(){
        editGroupNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        groupLabel.frame = CGRect(x: (editGroupNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
        backBtnOutlet.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        navigationBarSeperatorView.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "DisplayGroupsTableViewCell", for: indexPath) as! DisplayGroupsTableViewCell
        
        let data = groupsList[indexPath.row]
        print(data.id)
        cell.groupNameLabel.text = data.group_name
//        cell.buttonAction = { (sender) in
//            print(data.id!)
//            self.deleteUserGroupsRequests(group_id: data.id!)
//        }
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = groupsList[indexPath.row]
        groupId = data.id
        groupName = data.group_name
        print(data.id)
        performSegue(withIdentifier: "goToDisplayGroupMembersVC", sender: nil)
        print(data.group_name)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        
        let data = groupsList[indexPath.row]
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.groupId = data.id!
            self.groupName = data.group_name!
            self.performSegue(withIdentifier: "goToDisplayGroupMembersVC", sender: nil)
            print("edit button tapped")
        }
        edit.backgroundColor = UIColor.lightGray
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, index in
            self.deleteUserGroupsRequests(group_id: data.id!)
            print("delete button tapped")
        }
        remove.backgroundColor = UIColor.red
        
        return [remove, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDisplayGroupMembersVC"{
            let vc = segue.destination as! DisplayGroupMembersViewController
            vc.groupId = groupId
            vc.groupName = groupName
        }
    }
    
    func displayUserGroupsRequests(){
  // // //
        self.groupsList.removeAll()
    let displayUserGroupsParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature,] as? [String: Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: displayUserGroupsParameters!, url: "https://api.my24space.com/v1/user_groups") { (isSucess, message, data) in
            if isSucess {
                    if let responseArray = data["data"] as? [[String:Any]] {
                        print(responseArray)
                        for dict in responseArray {
                            let groupListDetails = GroupsDetails(dict: dict)
                            self.groupsList.append(groupListDetails)
                        }
                    }
            }else {
                print(message)
            }
            self.tableView.reloadData()
        }
    }
    
    func deleteUserGroupsRequests(group_id: Int){
        
        let deleteGroupParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_id": group_id] as? [String: Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: deleteGroupParameters!, url: "https://api.my24space.com/v1/delete_group") { (isSucess, message, data) in
        
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }
        self.displayUserGroupsRequests()
    }
}
