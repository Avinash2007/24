//
//  TabBarViewController.swift
//  24
//
//  Created by sriVathsav on 2/10/1397 AP.
//  Copyright © 1397 sri. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var homeViewController: UIView!
    @IBOutlet weak var profileViewController: UIView!
    
    @IBOutlet weak var cameraBtnOutlet: UIButton!
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var profileBtnOutlet: UIButton!
    
    var cameraCenter:CGPoint!
    
    @IBOutlet weak var displayView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraCenter = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT - 4 - 28)
        homeBtnOutlet.isSelected = true
        profileViewController.isHidden = true
        homeViewController.isHidden = false
        addRoundedLightLayer(radius: 28, view: homeBtnOutlet)
        addRoundedLightLayer(radius: 28, view: cameraBtnOutlet)
        addRoundedLightLayer(radius: 28, view: profileBtnOutlet)
    }
  
    @IBAction func tabbarBtnAction(_ sender: Any) {
        
        let tag = (sender as AnyObject).tag!
        switch tag {
        case 0:
            print("home")
            profileViewController.isHidden = true
            homeViewController.isHidden = false
            homeBtnOutlet.isSelected = true
            profileBtnOutlet.isSelected = false
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NormalCameraViewController")
            self.present(controller, animated: false, completion: nil)
        case 2:
            print("profile")
            homeBtnOutlet.isSelected = false
            profileBtnOutlet.isSelected = true
            profileViewController.isHidden = false
            homeViewController.isHidden = true

        default:
            print("nill")
        }
    }

}
