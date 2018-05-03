//
//  NewMessageViewController.swift
//  
//
//  Created by sri on 19/09/17.
//
//

import UIKit
import ProgressHUD

class NewMessageViewController: UIViewController {
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    @IBOutlet weak var homeViewTapped: UIImageView!
    @IBOutlet weak var messageViewTapped: UIImageView!
    @IBOutlet weak var searchViewTapped: UIImageView!
    @IBOutlet weak var notificationViewTapped: UIImageView!
    @IBOutlet weak var profileViewTapped: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        gestur()
        profileViewTap()
        searchViewTap()
        homeViewTap()
        notificationViewTap()
    }
    @IBAction func logoutBtn(_ sender: Any) {
        
        FirebaseService.sharedInstance.logout(onSuccess: {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPage")
            self.present(viewController, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
    }
}
extension NewMessageViewController{

    func profileViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        profileViewTapped.addGestureRecognizer(tapGesture)
        profileViewTapped.isUserInteractionEnabled = true
        
    }
    func homeViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(homeTap))
        homeViewTapped.addGestureRecognizer(tapGesture)
        homeViewTapped.isUserInteractionEnabled = true
        
    }
    func searchViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTap))
        searchViewTapped.addGestureRecognizer(tapGesture)
        searchViewTapped.isUserInteractionEnabled = true
        
    }
    func notificationViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationTap))
        notificationViewTapped.addGestureRecognizer(tapGesture)
        notificationViewTapped.isUserInteractionEnabled = true
        
    }
    
    func gestur(){
        
        swipeRightRec.addTarget(self, action: #selector(self.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        
        swipeLeftRec.addTarget(self, action: #selector(self.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        
    }

    func swipedRight() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped right")
        
    }
    func swipedLeft() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped left")
    }

    func profileTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func homeTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func searchTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func notificationTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    
}
