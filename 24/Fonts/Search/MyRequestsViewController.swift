//
//  MyRequestsViewController.swift
//  24
//
//  Created by sri on 03/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class MyRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myRequestsNavigationView: UIView!
    @IBOutlet weak var myRequestsLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var navigationBarSeperatorView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var list: [MyRequests] = []
    var parameters = [String: Any]()
    var wallRequestParameters = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        
        myWallRequests()
        navigationViewAllignments()
        
        tableView.frame = CGRect(x: 0, y: 75, width: screenSize.width, height: screenSize.height - 75)
    }
    
    func navigationViewAllignments(){
        myRequestsNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        myRequestsLabel.frame = CGRect(x: (myRequestsNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
        backBtnOutlet.frame = CGRect(x: 15, y: 10, width: 50, height: 30)
        navigationBarSeperatorView.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
    
    func myWallRequests(){
        
        parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/my_wall_requests") { (isSucess, message, data) in
            if isSucess{
                if let responseArray = data["requests"] as? [[String:Any]] {
                    print(responseArray)
                    for dict in responseArray {
                        let mdl = MyRequests(dict: dict)
                        self.list.append(mdl)
                        print(self.list)
                        }
                    }
                }else {
                print(message)
            }
            self.tableView.reloadData()
        }
    }
    
    func wallRequestAction(userId: Int, action: Int){
        
        wallRequestParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": userId, "action": action] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/wall_request_action") { (isSucess, message, data) in
            if isSucess{
                    print(message)
                }else {
                    print(message)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRequestsTableViewCell", for: indexPath) as! MyRequestsTableViewCell
        
        let data = self.list[indexPath.row]
        cell.usernameLabel.text = data.username
        
        cell.accpetAction = { (sender) in
            self.wallRequestAction(userId: data.id!, action: 2)
        }
        
        cell.rejectAction = {(sender) in
            self.wallRequestAction(userId: data.id!, action: 3)
        }

        return cell
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
