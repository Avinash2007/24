//
//  TabbarViewController.swift
//  24
//
//  Created by sri on 17/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class TabbarViewController1: UIViewController {

    @IBOutlet weak var homeBtnoutlet: UIButton!
    @IBOutlet weak var cameraBtnOutlet: UIButton!
    @IBOutlet weak var profileBtnOutlet: UIButton!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var displayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     print(mydetails!.userId)
    print(mydetails!.signature)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        homeBtnoutlet.setImage(#imageLiteral(resourceName: "homeIconSelected"), for: .normal)
        cameraBtnOutlet.setImage(#imageLiteral(resourceName: "cameraIconUnselected"), for: .normal)
        profileBtnOutlet.setImage(#imageLiteral(resourceName: "ProfileIconUnselected"), for: .normal)
        
        add(asChildViewController: homeViewController)
        remove(asChildViewController: profileViewController)
        
    }
    
    private lazy var homeViewController: HomeViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! HomeViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var cameraViewController: NormalCameraViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "NormalCameraViewController") as! NormalCameraViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var profileViewController: ProfileViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        displayView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = displayView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    

    @IBAction func tabbarBtnAction(_ sender: Any) {
        
       let tag = (sender as AnyObject).tag!
        switch tag {
        case 0:
            print("home")
            homeBtnoutlet.setImage(#imageLiteral(resourceName: "homeIconSelected"), for: .normal)
            cameraBtnOutlet.setImage(#imageLiteral(resourceName: "cameraIconUnselected"), for: .normal)
            profileBtnOutlet.setImage(#imageLiteral(resourceName: "ProfileIconUnselected"), for: .normal)
            
            add(asChildViewController: homeViewController)
            remove(asChildViewController: profileViewController)
            
        case 1:
            print("camera")
//            cameraBtnOutlet.setImage(#imageLiteral(resourceName: "cameraIconSelected"), for: .normal)
//            homeBtnoutlet.setImage(#imageLiteral(resourceName: "homeIconUnselected"), for: .normal)
//            profileBtnOutlet.setImage(#imageLiteral(resourceName: "ProfileIconUnselected"), for: .normal)
            
            navigateVc(idName: "NormalCameraViewController")
            
           
        case 2:
            print("profile")
            
            profileBtnOutlet.setImage(#imageLiteral(resourceName: "ProfileIconSelected"), for: .normal)
            homeBtnoutlet.setImage(#imageLiteral(resourceName: "homeIconUnselected"), for: .normal)
            cameraBtnOutlet.setImage(#imageLiteral(resourceName: "cameraIconUnselected"), for: .normal)
            
            remove(asChildViewController: homeViewController)
            add(asChildViewController: profileViewController)
        default:
            
            print("nill")
        }
    }
    
}
