//
//  CreateGroupViewController.swift
//  24
//
//  Created by sri on 19/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol HidePopUpViewDelegate:class {
    
    func HideGroupView()
    
}

class CreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    weak var dele : HidePopUpViewDelegate? = nil
    
    @IBOutlet weak var newGroupNavigationView: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var navigationBarSeperatorView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var enterGroupNameView: UIView!
    @IBOutlet weak var enterGroupNameTextField: UITextField!
    @IBOutlet weak var newGroupLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var createBtnOutlet: UIButton!
    
    var createGroupParameters = [String: Any]()
    var addGroupMembersParameters = [String: Any]()
    var myFollowingParameters = [String: Any]()
    
    var followingList = [MyFollowing]()
    var addGroupMemberId : String?
    var createdGroupId : Int?
    
    var selectedMembers = [Int]()
    var selectedMembersString: String?
    
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myFollowingParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.allowsMultipleSelection = true
        
        myFollowingRequests()
        
        navigationViewAllignments()
        
        newgroupAllignment()
        
        tableView.frame = CGRect(x: 0, y: 75, width: screenSize.width, height: screenSize.height - 75)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTableViewCell", for: indexPath) as! CreateGroupTableViewCell
        let data = self.followingList[indexPath.row]
        cell.getFollowingData(data: data)
        cell.selectionStyle = .none
        
        let profileUrl = "http://api.my24space.com/public/uploads/profile/" + "\(data.profilePhotoUrl!)"
        let profileImageURL = URL(string: profileUrl)
        
        Credits.sharedInstance.getImageRequest(imageUrl: profileImageURL!) { (isSucess, message, image) in
            if isSucess {
                cell.profilePictureImageView.image = image
            }else {
                print(message)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CreateGroupTableViewCell
        
        let data = self.followingList[indexPath.row]
        if self.selectedMembers.contains(data.id!) {
            self.selectedMembers.remove(at: self.selectedMembers.index(of: data.id!)!)
            print("remove")
            cell.checkCircleImageView.image = #imageLiteral(resourceName: "UncheckCircle")
        } else {
            self.selectedMembers.append(data.id!)
            print("add")
            cell.checkCircleImageView.image = #imageLiteral(resourceName: "30x30 3x tick in blue")
        }
        tableView.reloadData()
        print(selectedMembers)
    }
    
    @IBAction func createGroupBtnAction(_ sender: Any) {
        
        createGroupParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_name": enterGroupNameTextField.text]
        
        createGroupRequests()
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //dele?.HideGroupView()
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        self.enterGroupNameTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToPopUpVc"{
            let previewVc = segue.destination as! PopUpViewController
            previewVc.errorMessage = errorMessage
        }
    }
    
    func createGroupRequests(){
        
        createGroupParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_name": enterGroupNameTextField.text]
    
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 55, y: 0, width: 40, height: 40), type: .ballClipRotateMultiple, color: UIColor.white, padding: 15)
        createBtnOutlet.setTitle("", for: UIControlState.normal)
        self.createBtnOutlet.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: createGroupParameters, url: "https://api.my24space.com/v1/create_user_group") { (isSucess, message, data) in
            if isSucess {
                let groupId = data["groupId"] as? Int
                self.addGroupMembersRequests(groupId: groupId!)
                
                activityIndicatorView.stopAnimating()
                self.createBtnOutlet.setTitle("Create", for: UIControlState.normal)
                self.enterGroupNameTextField.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }else {
                activityIndicatorView.stopAnimating()
                self.enterGroupNameTextField.resignFirstResponder()
                self.errorMessage = "Error"
                // Create Group Crash
                self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
            }
        }
    }
    
    func addGroupMembersRequests(groupId: Int){
        
        for element in selectedMembers {
            if selectedMembersString == nil{
                selectedMembersString = String(element)
            } else {
                selectedMembersString = selectedMembersString! + "," + String(element)
            }
            print(selectedMembersString)
        }
        
        addGroupMembersParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "group_id": groupId, "member_ids": selectedMembersString]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: addGroupMembersParameters, url: "https://api.my24space.com/v1/add_group_members") { (isSucess, message, data) in
            if isSucess{
                print(message)
            }else {
                print(message)
            }
        }
    }
    func myFollowingRequests(){
        self.followingList.removeAll()
        myFollowingParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "viewer_id": mydetails!.userId]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: myFollowingParameters, url: "https://api.my24space.com/v1/my_followings") { (isSucess, message, data) in
            if isSucess{
                if let responseArray = data["followings"] as? [[String:Any]] {
                    print(responseArray)
                    for dict in responseArray {
                        let myFollowingList = MyFollowing(dict: dict)
                        self.followingList.append(myFollowingList)
                    }
                }
            }else {
                print(message)
            }
            self.tableView.reloadData()
        }
    }
}

extension CreateGroupViewController {
    
    func newgroupAllignment(){
        
        enterGroupNameView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        newGroupLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        seperatorView.frame = CGRect(x: 0, y: 50, width: screenSize.width, height: 1)
        enterGroupNameTextField.frame = CGRect(x: 20, y: 75, width: screenSize.width - 40, height: 30)
        createBtnOutlet.frame = CGRect(x: (screenSize.width / 2) - 75, y: 130, width: 150, height: 40)
        
    }
    
    func navigationViewAllignments(){
        newGroupNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        groupLabel.frame = CGRect(x: (newGroupNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
        nextBtnOutlet.frame = CGRect(x: newGroupNavigationView.frame.width - 75, y: 10, width: 60, height: 30)
        backBtnOutlet.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        navigationBarSeperatorView.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
}

extension CreateGroupViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animate(withDuration: 1) {
            self.enterGroupNameView.frame = CGRect(x: 0, y: screenSize.height - (keyboardHeight + 180), width: screenSize.width, height: 180)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 1) {
            self.enterGroupNameView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        }
    }
}
