//
//  AboutProfileViewController.swift
//  24
//
//  Created by sri on 18/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import Alamofire

class AboutProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var peopleNavigationView: UIView!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var navigationSeperator: UIView!
    
    @IBOutlet weak var toogleOptionsView: UIView!
    @IBOutlet weak var friendsBtnOutlet: UIButton!
    @IBOutlet weak var followersBtnOutlet: UIButton!
    @IBOutlet weak var followingBtnOutlet: UIButton!
    @IBOutlet weak var toogleBarView: UIView!
//
//    var followingList = [MyFollowing]()
//    var followersList = [MyFollowers]()
//    var friendsList  = [MyFriends]()
    
    var list: [MyFollowing] = []
    
    var isTapped : Int?
    
    var myFollowingParameters = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        
        isTapped = 0
        
        myFollowingParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "viewer_id": mydetails!.viewerId]
        
        selectedRequest()
        
        navigationViewAllignments()
        profileAllignments()
        
        tableView.frame =  CGRect(x: 0, y: 130, width: screenSize.width, height: screenSize.height - 130)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func selectedRequest(){
        print(isTapped!)
        if isTapped == 0 {
            myFriendsRequests()
        }else if isTapped == 1 {
            myFollowersRequests()
        }else if isTapped == 2 {
            myFollowingRequests()
        }
    }
    
    func navigationViewAllignments(){
        peopleNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        peopleLabel.frame = CGRect(x: (peopleNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
        backBtnOutlet.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
        navigationSeperator.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
    
    func profileAllignments(){
        
        
        toogleOptionsView.frame = CGRect(x: 20, y: peopleNavigationView.frame.height + 25, width: screenSize.width - 40, height: 50)
        friendsBtnOutlet.frame = CGRect(x: 0, y: 0, width: (toogleOptionsView.frame.width / 3), height: 40)
        followersBtnOutlet.frame = CGRect(x: friendsBtnOutlet.frame.width, y: 0, width: (toogleOptionsView.frame.width / 3), height: 40)
        followingBtnOutlet.frame = CGRect(x: friendsBtnOutlet.frame.width * 2, y: 0, width: (toogleOptionsView.frame.width / 3), height: 40)
        toogleBarView.frame = CGRect(x: 0, y: friendsBtnOutlet.frame.height + (((20 * toogleOptionsView.frame.height) / 200) - 1), width: (toogleOptionsView.frame.width / 3), height: 2)
    }
    
    @IBAction func toogleViewAction(_ sender: Any) {
        
        print((sender as AnyObject).tag)
        switch (sender as AnyObject).tag {
        case 0:
            print((sender as AnyObject).tag)
            isTapped = 0
            friendsListTapped()
            myFriendsRequests()
        case 1:
            isTapped = 1
            print((sender as AnyObject).tag)
            print(isTapped!)
            followersListTapped()
            myFollowersRequests()
        case 2:
            isTapped = 2
            print((sender as AnyObject).tag)
            followingListTapped()
            myFollowingRequests()
        default:
            print("--")
        }
    }
    
    func friendsListTapped(){
        UIView.animate(withDuration: 0.2) {
            self.toogleBarView.frame = CGRect(x: 0, y: self.friendsBtnOutlet.frame.height + (((20 * self.toogleOptionsView.frame.height) / 200) - 1), width: (self.toogleOptionsView.frame.width / 3), height: 2)
            self.friendsBtnOutlet.setTitleColor(.black, for: .normal)
            self.followersBtnOutlet.setTitleColor(.darkGray, for: .normal)
            self.followingBtnOutlet.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    func followersListTapped(){
        
        UIView.animate(withDuration: 0.2) {
            self.toogleBarView.frame = CGRect(x: (self.toogleOptionsView.frame.width / 3), y: self.friendsBtnOutlet.frame.height + (((20 * self.toogleOptionsView.frame.height) / 200) - 1), width: (self.toogleOptionsView.frame.width / 3), height: 2)
            self.friendsBtnOutlet.setTitleColor(.darkGray, for: .normal)
            self.followersBtnOutlet.setTitleColor(.black, for: .normal)
            self.followingBtnOutlet.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    func followingListTapped(){
        
        UIView.animate(withDuration: 0.2) {
            self.toogleBarView.frame = CGRect(x: (self.toogleOptionsView.frame.width / 3) * 2, y: self.friendsBtnOutlet.frame.height + (((20 * self.toogleOptionsView.frame.height) / 200) - 1), width: (self.toogleOptionsView.frame.width / 3), height: 2)
            self.friendsBtnOutlet.setTitleColor(.darkGray, for: .normal)
            self.followersBtnOutlet.setTitleColor(.darkGray, for: .normal)
            self.followingBtnOutlet.setTitleColor(.black, for: .normal)
        }
    }

    func myFollowingRequests(){
        self.list.removeAll()
        Alamofire.request("https://api.my24space.com/v1/my_followings", method: .post, parameters: myFollowingParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: Any] {
                print(data)
                if let responseArray = data["followings"] as? [[String:Any]] {
                    for dict in responseArray {
                        let myFollowingList = MyFollowing(dict: dict)
                        self.list.append(myFollowingList)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func myFollowersRequests(){
        self.list.removeAll()
        Alamofire.request("https://api.my24space.com/v1/my_followers", method: .post, parameters: myFollowingParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: Any] {
                print(data)
                if let responseArray = data["followers"] as? [[String:Any]] {
                    for dict in responseArray {
                        let myFollowersList = MyFollowing(dict: dict)
                        self.list.append(myFollowersList)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func myFriendsRequests(){
        self.list.removeAll()
        Alamofire.request("https://api.my24space.com/v1/my_wall_viewers", method: .post, parameters: myFollowingParameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if let data = response.result.value as? [String: Any] {
                print(data)
                if let responseArray = data["requests"] as? [[String:Any]] {
                    for dict in responseArray {
                        let myFriendsList = MyFollowing(dict: dict)
                        self.list.append(myFriendsList)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutProfileTableViewCell", for: indexPath) as! AboutProfileTableViewCell
        
        let data = self.list[indexPath.row]
        cell.usernameLabel.text = data.username
        if data.profilePhotoUrl != nil && data.profilePhotoUrl != ""{
            let profilePictureUrlString = "http://api.my24space.com/public/profile/media/" + "\(data.profilePhotoUrl!)"
            let profilePictureUrl = profilePictureUrlString.replacingOccurrences(of: " ", with: "%20")
            loadImage(profilePictureUrl, cell.profilePicImageView, activity: cell.activity, defaultImage: #imageLiteral(resourceName: "profilepicPlaceholder"))
        }else{
           cell.profilePicImageView.image = #imageLiteral(resourceName: "profilepicPlaceholder")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
        let data = self.list[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendProfileViewController") as! FriendProfileViewController
        controller.userId = data.id
        self.present(controller, animated: true, completion: nil)

    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

