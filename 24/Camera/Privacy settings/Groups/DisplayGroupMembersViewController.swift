//
//  DisplayGroupMembersViewController.swift
//  24
//
//  Created by sri on 04/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DisplayGroupMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var editGroupNavigationView: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var addBtnOutlet: UIButton!
    @IBOutlet weak var navigationBarSeperatorView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var changeGroupNameLabel: UILabel!
    @IBOutlet weak var changeGroupNameView: UIView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var updateGroupNameBtnOutlet: UIButton!
    
    var groupId : Int?
    var groupName : String?
    var errorMessage: String?
    
    var groupUsers: [GroupUsers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        
        groupLabel.text = groupName
        print(groupId)
        displayGroupUserRequests(groupId: groupId!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        groupLabel.isUserInteractionEnabled = true
        groupLabel.addGestureRecognizer(tap)
        
        createGroupViewAllignment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func createGroupViewAllignment(){
        
        changeGroupNameView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        changeGroupNameLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        seperatorView.frame = CGRect(x: 0, y: 50, width: screenSize.width, height: 1)
        groupNameTextField.frame = CGRect(x: 20, y: 75, width: screenSize.width - 40, height: 30)
        updateGroupNameBtnOutlet.frame = CGRect(x: (screenSize.width / 2) - 75, y: 130, width: 150, height: 40)
        
    }
    
    @IBAction func updateGroupNameBtn(_ sender: Any) {
        updateUserGroup()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.groupNameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayGroupMembersTableViewCell", for: indexPath) as! DisplayGroupMembersTableViewCell
        let data = groupUsers[indexPath.row]
        cell.usernameLabel.text = String(describing: data.userName!)
        print(data.userId)
        cell.buttonAction = {(sender)in
            self.deleteGroupUsersRequests(groupMemberId: data.userId!)
        }
        
        let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profilePictureUrl!)"
        let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
        let profileImageURL = URL(string: profileUrl)
        
        Credits.sharedInstance.getImageRequest(imageUrl: profileImageURL!) { (isSucess, message, image) in
            cell.profileImageView.image = image
        }
        return cell
    }
    
    @objc func tapFunction() {
        self.groupNameTextField.becomeFirstResponder()
    }
    
    func updateUserGroup(){
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 55, y: 0, width: 40, height: 40), type: .ballClipRotateMultiple, color: UIColor.white, padding: 15)
        updateGroupNameBtnOutlet.setTitle("", for: UIControlState.normal)
        self.updateGroupNameBtnOutlet.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        print(groupName!)
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_id": groupId!, "group_name": groupNameTextField.text] as [String: Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "http://api.my24space.com/v1/update_user_group") { (isSucess, message, data) in
            if isSucess {
                activityIndicatorView.stopAnimating()
                
                self.groupLabel.text = self.groupNameTextField.text
                self.groupNameTextField.text = ""
                self.updateGroupNameBtnOutlet.setTitle("Create", for: UIControlState.normal)
                self.groupNameTextField.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }else {
                activityIndicatorView.stopAnimating()
                self.groupNameTextField.resignFirstResponder()
                self.errorMessage = "Error"
                self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
            }
        }
    }
    
    func displayGroupUserRequests(groupId: Int){
        
        self.groupUsers.removeAll()
        let displayGroupUsersParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature,"group_id": groupId] as [String: Any]

        AlamofireRequest.sharedInstance.alamofireRequest(dict: displayGroupUsersParameters, url: "https://api.my24space.com/v1/user_group_members") { (isSucess, message, data) in
            if isSucess {
                if let responseArray = data["data"] as? [[String:Any]] {
                    
                    for dict in responseArray {
                        let groupListDetails = GroupUsers(dict: dict)
                        self.groupUsers.append(groupListDetails)
                    }
                }
            }else {
            print(message)
            }
            self.tableView.reloadData()
        }
    }
    
    func deleteGroupUsersRequests(groupMemberId: Int){
        
        let deleteGroupMembersParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_id": groupId, "member_ids": groupMemberId] as [String: Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: deleteGroupMembersParameters, url: "https://api.my24space.com/v1/delete_group_members") { (isSucess, message, data) in
            if isSucess {
                self.displayGroupUserRequests(groupId: self.groupId!)
            }else {
                print(message)
            }
        }
    }
}

extension DisplayGroupMembersViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animate(withDuration: 1) {
            self.changeGroupNameView.frame = CGRect(x: 0, y: screenSize.height - (keyboardHeight + 180), width: screenSize.width, height: 180)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 1) {
            self.changeGroupNameView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        }
    }
}
