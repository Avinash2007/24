//
//  PrivacySettingsViewController.swift
//  24
//
//  Created by sri on 05/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import PickerView

class PrivacySettingsViewController: UIViewController {
    
    @IBOutlet weak var locationOffBtnOutlet: UIButton!
    @IBOutlet weak var locationAutoBtnOutlet: UIButton!
    
    @IBOutlet weak var locationOffLabel: UILabel!
    @IBOutlet weak var locationAutoLabel: UILabel!
    
    
    @IBOutlet weak var messageAnyOneBtnOutlet: UIButton!
    @IBOutlet weak var messageNoneBtnOutlet: UIButton!
    @IBOutlet weak var messageOnlyFriendsBtnOutlet: UIButton!
    @IBOutlet weak var messageOnlyFollowersBtnOutlet: UIButton!
    @IBOutlet weak var messageFollowingBtnOutlet: UIButton!
    @IBOutlet weak var messageBothBtnOutlet: UIButton!
    
    @IBOutlet weak var messageAnyOneLabel: UILabel!
    @IBOutlet weak var messageNoneLabel: UILabel!
    @IBOutlet weak var messageOnlyFriendsLabel: UILabel!
    @IBOutlet weak var messageOnlyFollowersLabel: UILabel!
    @IBOutlet weak var messageFollowingLabel: UILabel!
    @IBOutlet weak var messageBothLabel: UILabel!

    var locationStatus: Int?
    var messageStatus: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }

    
  
    
    @IBAction func updateBtnAction(_ sender: Any) {
        
        let locationParameter = ["userid": "\(mydetails!.userId)", "signature": "\(mydetails!.signature)", "location": locationStatus!] as [String: Any]
        let messageParameter = ["userid": "\(mydetails!.userId)", "signature": "\(mydetails!.signature)", "message": messageStatus!] as [String: Any]
        
        print(locationStatus)
        print(messageStatus)
        AlamofireRequest.sharedInstance.alamofireRequest(dict: locationParameter, url: "https://api.my24space.com/v1/location_settings") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }

        AlamofireRequest.sharedInstance.alamofireRequest(dict: locationParameter, url: "https://api.my24space.com/v1/message_settings") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }

        }
    }
    
    @IBAction func locationBtnAction(_ sender: Any) {
        locationStatus = (sender as AnyObject).tag
        print(locationStatus)
        switch (sender as AnyObject).tag {
        case 0:
            locationAutoBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            locationOffBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
        case 1:
            locationAutoBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            locationOffBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
        default:
            break
        }
    }
    
    @IBAction func messageBtnAction(_ sender: Any) {
        messageStatus = (sender as AnyObject).tag
        print(messageStatus)
        switch (sender as AnyObject).tag {
        case 0:
            
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            
        case 1:
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            
        case 2:
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
        case 3:
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
        case 4:
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
        case 5:
            messageAnyOneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageNoneBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFriendsBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageOnlyFollowersBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageFollowingBtnOutlet.setImage(#imageLiteral(resourceName: "uncheckedBtn"), for: .normal)
            messageBothBtnOutlet.setImage(#imageLiteral(resourceName: "checkedBtn"), for: .normal)
        default:
            break
        }
    }
    
    
}

