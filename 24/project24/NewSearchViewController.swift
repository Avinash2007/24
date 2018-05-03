//
//  NewSearchViewController.swift
//  
//
//  Created by sri on 19/09/17.
//
//

import UIKit

class NewSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var swipeView: UIView!
    
    @IBOutlet weak var usersViewLabel: UILabel!
    @IBOutlet weak var storiesViewLabel: UILabel!
    
    var swipeRightRec = UISwipeGestureRecognizer()
    var swipeLeftRec = UISwipeGestureRecognizer()
    
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    
    var swipedBool : Bool?
    
    @IBOutlet weak var homeViewTapped: UIImageView!
    @IBOutlet weak var messageViewTapped: UIImageView!
    @IBOutlet weak var searchViewTapped: UIImageView!
    @IBOutlet weak var notificationViewTapped: UIImageView!
    @IBOutlet weak var profileViewTapped: UIImageView!
    
    @IBOutlet weak var usersLocationView: UIView!
    @IBOutlet weak var storiesLocationView: UIView!
    @IBOutlet weak var swipeViewsOutlet: UIView!
    @IBOutlet weak var tabViewOutlet: UIView!
    
    @IBOutlet weak var nearByUserCollectionView: UICollectionView!
    @IBOutlet weak var recomendedCollectionView: UICollectionView!
    @IBOutlet weak var topUsersCollectionView: UICollectionView!
    
    @IBOutlet weak var nearByStoriesCollectionView: UICollectionView!
    @IBOutlet weak var popularPlacesCollectionView: UICollectionView!
    @IBOutlet weak var trendingStoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gesture()
        messageViewTap()
        homeViewTap()
        notificationViewTap()
        profileViewTap()
        
        nearByUserCollectionView.delegate = self
        nearByUserCollectionView.dataSource = self
        
        recomendedCollectionView.delegate = self
        recomendedCollectionView.dataSource = self
        
        topUsersCollectionView.delegate = self
        topUsersCollectionView.dataSource = self
        
        storiesLocationView.isHidden = true
        usersLocationView.isHidden = false

        swipedBool = false
        
        usersViewLabel.textColor = .black
        storiesViewLabel.textColor = UIColor.lightGray
        
        swipeViewShape()
        
        //swipeViewsOutlet.setGradientBackground(colourOne: Colors.color27, colourTwo: Colors.color28)
       
    }
    
    func collectionViewCellLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        nearByUserCollectionView!.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.nearByUserCollectionView){
        return 10
        } else if(collectionView == self.recomendedCollectionView){
        return 20
        } else if(collectionView == self.topUsersCollectionView){
        return 30
        } else if(collectionView == self.nearByStoriesCollectionView){
            return 10
        } else if(collectionView == self.popularPlacesCollectionView){
            return 20
        } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.nearByUserCollectionView){
            let nearByUserCollectionViewCell  =  nearByUserCollectionView.dequeueReusableCell(withReuseIdentifier: "NearbyUsersCollectionViewCellIdentifier", for: indexPath) as? NearbyUsersCollectionViewCell
            
            return nearByUserCollectionViewCell!
        } else if(collectionView == self.recomendedCollectionView){
            let recomendedCollectionViewCell  =  recomendedCollectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedUsersCollectionViewCellIdentifier", for: indexPath) as? RecommendedUsersCollectionViewCell
            return recomendedCollectionViewCell!
        } else if(collectionView == self.topUsersCollectionView){
            let topUsersCollectionViewCell  =  topUsersCollectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedUsersCollectionViewCellIdentifier", for: indexPath) as? TopRatedUsersCollectionViewCell
            return topUsersCollectionViewCell!
        }else if(collectionView == self.nearByStoriesCollectionView){
            let nearByStoriesCollectionViewCell  =  nearByStoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "nearByStoriesCollectionViewCellIdentifier", for: indexPath) as? NearByStoriesCollectionViewCell
            return nearByStoriesCollectionViewCell!
        } else if(collectionView == self.popularPlacesCollectionView){
            let popularPlacesCollectionViewCell  =  popularPlacesCollectionView.dequeueReusableCell(withReuseIdentifier: "popularPlacesCollectionViewCellIdentifier", for: indexPath) as? PopularPlacesCollectionViewCell
            return popularPlacesCollectionViewCell!
        }else {
            let trendingStoriesCollectionViewCell  =  trendingStoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "trendingStoriesCollectionViewCellIdentifier", for: indexPath) as? TrendingStoriesCollectionViewCell
            return trendingStoriesCollectionViewCell!
        }
    }
    
    func swipeViewShape(){
    
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.swipeViewsOutlet.frame
        rectShape.position = self.swipeViewsOutlet.center
        rectShape.path = UIBezierPath(roundedRect: self.swipeViewsOutlet.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        
        self.swipeViewsOutlet.layer.mask = rectShape
        
        
        
    }
}

extension NewSearchViewController {

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
    func notificationViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationTap))
        notificationViewTapped.addGestureRecognizer(tapGesture)
        notificationViewTapped.isUserInteractionEnabled = true
        
    }
    func profileViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        profileViewTapped.addGestureRecognizer(tapGesture)
        profileViewTapped.isUserInteractionEnabled = true
        
    }
    
    func gesture(){
        
        swipeRight.addTarget(self, action: #selector(self.swipedViewRight) )
        swipeRight.direction = .right
        self.swipeView!.addGestureRecognizer(swipeRight)
        
        
        swipeLeft.addTarget(self, action: #selector(self.swipedViewLeft) )
        swipeLeft.direction = .left
        self.swipeView!.addGestureRecognizer(swipeLeft)
        
        swipeRightRec.addTarget(self, action: #selector(self.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(self.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        
    }
    
    func swipedViewRight() {
        
        if swipedBool == true{
            
            usersViewLabel.textColor = .black
            storiesViewLabel.textColor = UIColor.lightGray
            
            storiesLocationView.isHidden = true
            usersLocationView.isHidden = false
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [],
                           animations: {
                            self.usersViewLabel.center.x += 50
                            self.storiesViewLabel.center.x += 50
            },
                           completion: {_ in
                            
            })
            
            print("yup, you swiped right")
            swipedBool = false
        
        }
        

        
    }
    func swipedViewLeft() {
        
        if swipedBool == false {
            
            usersViewLabel.textColor = UIColor.lightGray
            storiesViewLabel.textColor = .black
            
            storiesLocationView.isHidden = false
            usersLocationView.isHidden = true
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [],
                           animations: {
                            self.usersViewLabel.center.x -= 50
                            self.storiesViewLabel.center.x -= 50
            },
                           completion: {_ in
            })
            
            print("yup, you swiped left")
            
            swipedBool = true
        
        }
        

    }

    
    func swipedRight() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped right")
        
    }
    func swipedLeft() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped left")
    }
    
    func messageTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func homeTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func notificationTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func profileTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
        self.present(viewController, animated: false, completion: nil)
    }
}
