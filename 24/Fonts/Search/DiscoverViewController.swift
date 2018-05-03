//
//  DiscoverViewController.swift
//  24
//
//  Created by sri on 17/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var backBtnOutlet: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var list: [Search] = []
    var searchParameters = [String: Any]()
    
    var id : Int!
    
    var userId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (searchTextField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        searchParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "search_keyword": txtAfterUpdate]
        searchRequests(dict: searchParameters)
        print("called")

        return true
    }
    
    func searchRequests(dict: [String: Any]){
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: dict, url: "https://api.my24space.com/v1/find_friends") { (isSucess, message, data) in
            let json = JSON.init(data)
            if isSucess{
                if let responseArray = json["users"].array{
                    self.list = responseArray.decode()
                }
            }else {
               // print(message)
            }
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell", for: indexPath) as! DiscoverTableViewCell
        
        let data = self.list[indexPath.row]
        cell.usernameLabel.text = data.username
        
        if data.profilePhotoUrl != ""{
            if let profileUrl = data.profilePhotoUrl {
                let url = "http://api.my24space.com/public/uploads/profile/" + "\(profileUrl)"
                loadImage(url, cell.profilePicImageView, activity: cell.activity, defaultImage: #imageLiteral(resourceName: "profilepicPlaceholder"))
            }
        }else{
            cell.profilePicImageView.image = #imageLiteral(resourceName: "profilepicPlaceholder")
        }
        
        
        if data.id == mydetails!.userId {
            print("----")
            print(data.username)
            print(data.id)
            print(mydetails!.userId)
            print("----")
            cell.addFollowBtnOutlet.isHidden = true
        } else {
            
            let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": data.id!] as [String : Any]
            
            if data.following_status == 1 {
                cell.addFollowBtnOutlet.setTitle("Following", for: .normal)
                cell.addFollowBtnOutlet.backgroundColor = .white
                cell.addFollowBtnOutlet.setTitleColor(UIColor(hex: "0066ff"), for: UIControlState.normal)
                cell.addFollowBtnOutlet.layer.borderWidth = 1.5
                cell.addFollowBtnOutlet.layer.borderColor =  UIColor(hex: "0066ff").cgColor
                
                
                // Unfollow
                cell.buttonAction = { (sender) in
                    print("follow")
                    
                    AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/un_following", completion: { (isSucess, message, data) in
                        if isSucess{
                            cell.addFollowBtnOutlet.setTitle("Follow", for: .normal)
                            cell.addFollowBtnOutlet.backgroundColor = UIColor(hex: "0066ff")
                            cell.addFollowBtnOutlet.setTitleColor(.white, for: UIControlState.normal)
                        }else {
                            
                        }
                    })
                }
            }else{
                
                cell.addFollowBtnOutlet.setTitle("Follow", for: .normal)
                cell.addFollowBtnOutlet.backgroundColor = UIColor(hex: "0066ff")
                cell.addFollowBtnOutlet.setTitleColor(.white, for: UIControlState.normal)
            //Follow
            cell.buttonAction = { (sender) in
                print("following")
                
                AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/add_following") { (isSucess, message, data) in
                    if isSucess{
                        cell.addFollowBtnOutlet.setTitle("Following", for: .normal)
                        cell.addFollowBtnOutlet.backgroundColor = .white
                        cell.addFollowBtnOutlet.setTitleColor(UIColor(hex: "0066ff"), for: UIControlState.normal)
                        cell.addFollowBtnOutlet.layer.borderWidth = 1.5
                        cell.addFollowBtnOutlet.layer.borderColor = UIColor(hex: "0066ff").cgColor
                        }else {
                          //  print(message)
                        }
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let data = self.list[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendProfileViewController") as! FriendProfileViewController
        controller.userId = data.id!
       // // // controller.signature = data.
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
}



extension DiscoverViewController {
    
    @IBAction func clickOnFollowButton(_ sender:UIButton) {
        guard let indexPath = viewIndexPathInTableView(sender, tableView: tableView) else {return}
        let object = list[indexPath.row]
        if object.following_status == 1{
            hitUnfollowAPI(object: object)
        }else{
            hitFollowAPI(object: object)
        }
    }
    

    func hitFollowAPI(object:Search) {
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": object.id!] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/add_following") { (isSucess, message, data) in
            let json = JSON.init(data)
            if isSucess{
                object.following_status = json["status"].intValue
                self.tableView.reloadData()
            }else {
                print(message)
            }
        }
        
    }
    
    
    func hitUnfollowAPI(object:Search) {
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": object.id!] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/un_following", completion: { (isSucess, message, data) in
            print(data)
            if isSucess{
                object.following_status = 0
                self.tableView.reloadData()
            }else {
                
            }
        })
    }
}
extension UITextField{
    
    func img(textField: UITextField, imgStr: String){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "\(imgStr)")
        imageView.image = image
        textField.leftView = imageView
        
    }
}

