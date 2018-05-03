//
//  SelectGroupViewController.swift
//  24
//
//  Created by sri on 01/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

protocol CloseViewDelegate{
    func closeGroupSelectionView()
}

class SelectGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate : CloseViewDelegate!
    
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtnOutlet: UIButton!

    var groupsList = [GroupsDetails]()
    
    var selectedGroups = [Int]()
    var selectedGroupsString: String?

    let section = ["", "Only to"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        displayUserGroupsRequests()
    }

    func displayUserGroupsRequests(){
        self.groupsList.removeAll()
        let displayUserGroupsParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature] as? [String: Any]
        
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
            self.tableView?.reloadData()
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return groupsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupTableViewCell", for: indexPath) as! SelectGroupTableViewCell
        let data = groupsList[indexPath.row]
        cell.groupNameLabel.text = data.group_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SelectGroupTableViewCell
        
        let data = self.groupsList[indexPath.row]
        if self.selectedGroups.contains(data.id!) {
            self.selectedGroups.remove(at: self.selectedGroups.index(of: data.id!)!)
            print("remove")
        } else {
            self.selectedGroups.append(data.id!)
            cell.checkCircleImageView.image = #imageLiteral(resourceName: "30x30 3x tick in blue")
            print("add")
        }
        //tableView.reloadData()
        print(selectedGroups)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        delegate.closeGroupSelectionView()

    }
    @IBAction func addGroupBtnAction(_ sender: Any) {
        
        for element in selectedGroups {
            if selectedGroupsString == nil{
                selectedGroupsString = String(element)
            } else {
                selectedGroupsString = selectedGroupsString! + "," + String(element)
            }
            postDetails.groupId = selectedGroupsString!
            print(selectedGroupsString)
            print(postDetails.groupId)
        }
        delegate.closeGroupSelectionView()

    }
}
