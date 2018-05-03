//
//  SettingsViewController.swift
//  24
//
//  Created by sri on 24/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    
   // @IBOutlet weak var settingsNavigationView: UIView!
   // @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    //@IBOutlet weak var settingsBarSeperatorView: UIView!
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false

        navigationViewAllignments()
        
    }
    
    func navigationViewAllignments(){
//        backBtnOutlet.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
//        settingsNavigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
//        settingsLabel.frame = CGRect(x: (settingsNavigationView.frame.width / 2) - 65, y: 10, width: 130, height: 30)
//        settingsBarSeperatorView.frame = CGRect(x: 0, y: 49, width: screenSize.width, height: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        index = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.settingNameLabel.text = "Profile"
            cell.settingsImageView.image = #imageLiteral(resourceName: "profile")
        case 1:
            cell.settingNameLabel.text = "Advance Settings"
            cell.settingsImageView.image = #imageLiteral(resourceName: "advanceSettings")
        case 2:
            cell.settingNameLabel.text = "Controls"
            cell.settingsImageView.image = #imageLiteral(resourceName: "control")
        case 3:
            cell.settingNameLabel.text = "Support"
            cell.settingsImageView.image = #imageLiteral(resourceName: "support")
        case 4:
            cell.settingNameLabel.text = "Logout"
            cell.settingNameLabel.textColor = UIColor.red
            cell.settingsImageView.image = #imageLiteral(resourceName: "logout")
        default:
            print("")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            navigateVc(idName: "DetailSettingsVc")
        case 1:
            navigateVc(idName: "PrivacySettingsViewController")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
//            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//            UserDefaults.standard.set("", forKey: "userId")
//            UserDefaults.standard.set("", forKey: "signature")
//            UserDefaults.standard.synchronize()UserDefaults.standard.setValue(encodedobject, forKey: "UserInformation")
            UserDefaults.standard.removeObject(forKey: "UserInformation")
            UserDefaults.standard.synchronize()
            navigateVc(idName: "ViewController")
        default:
            print("nil error")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
