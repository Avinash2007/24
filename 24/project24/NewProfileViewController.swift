//
//  NewProfileViewController.swift
//  
//
//  Created by sri on 19/09/17.
//
//

import UIKit

class NewProfileViewController: UIViewController {
    
    let swipeRightRec = UISwipeGestureRecognizer()
    
    @IBOutlet weak var homeViewTapped: UIImageView!
    @IBOutlet weak var messageViewTapped: UIImageView!
    @IBOutlet weak var searchViewTapped: UIImageView!
    @IBOutlet weak var notificationViewTapped: UIImageView!
    @IBOutlet weak var profileViewTapped: UIImageView!

    @IBOutlet weak var photoDisplayView: UIView!
    @IBOutlet weak var infoDisplayView: UIView!
    
    @IBOutlet weak var infoDisplayViewTapped: UIImageView!
    @IBOutlet weak var photoDisplayViewTapped: UIImageView!
    
    @IBOutlet weak var infoTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        gestur()
        messageViewTap()
        searchViewTap()
        homeViewTap()
        notificationViewTap()
        
        photoViewTap()
        infoViewTap()
        
    }
}
extension NewProfileViewController {

    func messageViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageTap))
        messageViewTapped.addGestureRecognizer(tapGesture)
        messageViewTapped.isUserInteractionEnabled = true
        
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
    
    func photoViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoTap))
        photoDisplayViewTapped.addGestureRecognizer(tapGesture)
        photoDisplayViewTapped.isUserInteractionEnabled = true
        
    }
    func infoViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTap))
        infoDisplayViewTapped.addGestureRecognizer(tapGesture)
        infoDisplayViewTapped.isUserInteractionEnabled = true
        
    }

    func gestur(){
        
        swipeRightRec.addTarget(self, action: #selector(self.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
    }
    
    func swipedRight() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped right")
    }
    
    func messageTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
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
    func photoTap() {
        
        photoDisplayViewTapped.image = UIImage(named: "albumselected")
        infoDisplayViewTapped.image = UIImage(named: "more")
        
        photoDisplayView.isHidden = false
        infoDisplayView.isHidden = true

    }
    func infoTap() {
        photoDisplayViewTapped.image = UIImage(named: "album")
        infoDisplayViewTapped.image = UIImage(named: "moreselected")
        
        photoDisplayView.isHidden = true
        infoDisplayView.isHidden = false

    }

}
