//
//  NewNotificationViewController.swift
//  
//
//  Created by sri on 19/09/17.
//
//

import UIKit

class NewNotificationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    @IBOutlet weak var homeViewTapped: UIImageView!
    @IBOutlet weak var messageViewTapped: UIImageView!
    @IBOutlet weak var searchViewTapped: UIImageView!
    @IBOutlet weak var notificationViewTapped: UIImageView!
    @IBOutlet weak var profileViewTapped: UIImageView!
    
    @IBOutlet weak var backgroundViewColor: UIView!

    @IBOutlet weak var onBoardCollectionView: UICollectionView!
    
    @IBOutlet weak var bigImageView: UIView!
    @IBOutlet weak var bigImage: UIImageView!
    
    var swipeDownRec = UISwipeGestureRecognizer()
    
    var OnBoard : [OnBoard] = []
    
    var height : Int?
    var width : Int?
    
    var step : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height = 72
        width = 72
        
        step = 1

        gestur()
        messageViewTap()
        searchViewTap()
        homeViewTap()
        profileViewTap()
        
        //backgroundViewColor.layer.borderColor = UIColor.red.cgColor
        //backgroundViewColor.layer.borderWidth = 5.0
        
        onBoardCollectionView.delegate = self
        onBoardCollectionView.dataSource = self
        
        fetchShouts()
        
        pinchGesture()
        
        swipeDownGestur()
        
        collectionViewCellLayout()
        
        bigImageView.isHidden = true

    }
    
    func  pinchGesture(){
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        pinchGesture.isEnabled = true
        pinchGesture.delegate = self
        onBoardCollectionView?.addGestureRecognizer(pinchGesture)
        onBoardCollectionView?.isUserInteractionEnabled = true
        
    }
    
    func handlePanGesture(gesture: UIPinchGestureRecognizer) {
        
        if (gesture.scale > 1.0 && gesture.scale < 5.5) {
            
            print("zoomout")
            if gesture.state == UIGestureRecognizerState.ended{
                if step! <= 4 {
                    if step != 4{
                        step = step!+1
                        print("zoomoutended")
                    }
                }
                
            }
            
        }else {
            
            print("zoomin")
            if gesture.state == UIGestureRecognizerState.ended{
                if step! >= 1{
                    if step != 1{
                        step = step!-1
                        print("zoominended")
                    }
                    
                }
            }
        }
        onBoardCollectionView?.reloadData()
    }

    func collectionViewCellLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 2, bottom: 10, right: 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        onBoardCollectionView!.collectionViewLayout = layout
        
    }
    
    func swipeDownGestur(){
        swipeDownRec.addTarget(self, action: #selector(self.swipedDown) )
        swipeDownRec.direction = .down
        self.bigImageView!.addGestureRecognizer(swipeDownRec)
    }
    
    func swipedDown() {
        self.bigImageView.isHidden = true
        print("yup, you swiped down")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = OnBoard[indexPath.row]
        data.isViewed = true
        self.OnBoard[indexPath.row] = data
        self.bigImageView.isHidden = false
        
        if let photoUrl = URL(string: data.photoUrl!){
            bigImage.sd_setImage(with: photoUrl)
        }
        onBoardCollectionView.reloadData()
        
        
    }
    
    func fetchShouts(){
        
        OnBoardFirebaseService.sharedInstance.ONBOARD_FEED.observe(.childAdded, with: { snapshot in
            OnBoardFirebaseService.sharedInstance.ONBOARD_FEED(onBoardId: snapshot.key, completion: { onBoard in
                
                let currentDate = Date()
                let deleteDate = (onBoard.deleteDate)!
                onBoard.isViewed = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                dateFormatter.timeZone = NSTimeZone.local
                let currentTimeStamp = dateFormatter.string(from: currentDate as Date)
                
                print("current\(currentTimeStamp)")
                print("delete\(deleteDate)")
                
                //return currentTimeStamp > timeStamp ? print("eb r") : self.Shouts.append(post)
                
                if currentTimeStamp > deleteDate{
                    print("the posts are deleted")
                }else  {
                    self.OnBoard.append(onBoard)
                }
                self.onBoardCollectionView.reloadData()
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if step == 1{
            
            return CGSize(width: width!, height: height!)
        }
        else if step == 2{
            
            switch indexPath.item % 2{
            case 0:
                return CGSize(width: 220, height: 220)
            case 1:
                return CGSize(width: 147, height: 220)
            default:
                return CGSize(width: 122.33, height: 122.33)
            }
        }
        else if step == 3{
            
            switch indexPath.item % 9{
            case 0:
                return CGSize(width: 371, height: 246.66)
            case 1:
                return CGSize(width: 122.33, height: 122.33)
            case 2:
                return CGSize(width: 122.33, height: 122.33)
            case 3:
                return CGSize(width: 122.33, height: 122.33)
            case 4:
                return CGSize(width: 184.5, height: 246.66)
            case 5:
                return CGSize(width: 184.5, height: 246.66)
            default:
                return CGSize(width: 122.33, height: 122.33)
            }
        } else if step == 4 {
            
            switch indexPath.item % 5{
            case 0:
                return CGSize(width: 371, height: 246.66)
            case 1:
                return CGSize(width: 184.5, height: 184.5)
            case 2:
                return CGSize(width: 184.5, height: 184.5)
            case 3:
                return CGSize(width: 184.5, height: 184.5)
            case 4:
                return CGSize(width: 184.5, height: 184.5)
            default:
                return CGSize(width: 122.33, height: 122.33)
            }
        } else{
            return CGSize(width: width!, height: height!)
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onBoardCollectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardCollectionViewCellIdentifier", for: indexPath) as! NewOnBoardCollectionViewCell
        
        let data = OnBoard[indexPath.row]
        cell.getData(data: data)

        
        if data.isViewed == false {
            cell.contentView.layer.borderColor = UIColor.red.cgColor
            cell.contentView.layer.borderWidth = 1.0
        } else {
            cell.contentView.layer.borderWidth = 0
        }
        return cell
    }
}
extension NewNotificationViewController {

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
    func profileViewTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        profileViewTapped.addGestureRecognizer(tapGesture)
        profileViewTapped.isUserInteractionEnabled = true
        
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

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(viewController, animated: false, completion: nil)
        print("yup, you swiped right")
        
    }
    func swipedLeft() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
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
    func searchTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    func profileTap() {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FifthViewController")
        self.present(viewController, animated: false, completion: nil)
    }

}
