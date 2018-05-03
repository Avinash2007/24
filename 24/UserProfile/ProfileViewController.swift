//
//  ProfileViewController.swift
//  24
//
//  Created by sri on 13/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var liveBtnOutlet: UIButton!
    @IBOutlet weak var wallBtnOutlet: UIButton!
    @IBOutlet weak var optionSeperatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsBtnOutlet: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    var list: [NewsFeed] = []
    
    var normalString = ""
    
//    var albumId: Int?
//    var albumName: String?
    
    var albumId: Int?
    var albumName: String?
    var webPageUrl : String?
    var webPageTitle: String?
    
    
    var zoomedImgView:UIImageView!
    var videoPan:UIPanGestureRecognizer!
    
    lazy var videoPreview:VideoPlayerView = {
        let view = VideoPlayerView.init(frame: self.view.frame)
        view.delegate = self
        return view
    }()
    
    lazy var bgView:UIView = {
        let view = UIView.init(frame: self.view.frame)
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsRequests()
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //appDelegate.homeTabVC?.cameraButton.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
       // appDelegate.homeTabVC?.cameraButton.isHidden = false
        allignment()
        //postsRequests()
        myProfileRequest()
        labelTapGesture()
        
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(postsRequests), name: NSNotification.Name(rawValue: "RefreshData"), object: nil)

        tableView.reloadData()
        //wallBtnOutlet.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // appDelegate.homeTabVC?.cameraButton.isHidden = true
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name(rawValue: "RefreshData"), object: nil)
    }
    
    func labelTapGesture(){
        
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewFollowers))
        followLabel.isUserInteractionEnabled = true
        followLabel.addGestureRecognizer(addPhotoTapGestureRecognizer)
    }
    
    @objc func viewFollowers(){
        
        print("labelTapped")
        mydetails!.viewerId = 0
        self.navigateVc(idName: "AboutProfileVc")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewTextCell") as! HomeTableViewTextCell
        let webCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebCell") as! HomeTableViewWebCell
        let webTextCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebTextCell") as! HomeTableViewWebTextCell
        let webVideoCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebVideoCell") as! HomeTableViewWebVideoCell
        
        let data = list[indexPath.row]
        
        if data.media_type == 1{
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
            imageCell.profileVC = self
            imageCell.loadCell(post: data)
            //tapPhoto.momentId = data.album_id!
            return imageCell
        } else if data.media_type == 2{
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewVideoCell") as! HomeTableViewVideoCell
            videoCell.profileVC = self
            videoCell.loadCell(post: data)
            return videoCell
        } else if data.media_type == 3{
            
            if data.profileImageUrl == ""{
                
            } else {
                let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
                let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                let profileImageURL = URL(string: profileUrl)
                
                //                imageCell.profileImageView.kf.setImage(with: profileImageURL!)
                webCell.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
                    
                })
            }
            
            webCell.diaplayNameLabel.text = data.username
            webCell.timeStampLabel.text = data.postTime
            
            if data.album_id == 0 {
                // webCell.momentNameLabel.isHidden = true
            }else if data.album_id != 0{
                //webCell.momentNameLabel.isHidden = false
                //webCell.momentNameLabel.text = data.albumName
            }
            
            DispatchQueue.global(qos: .background).async {
                let webUrlString = "https://preview1.talkback.pk/api/extractor/extract?url=\(data.media!)"
                AlamofireRequest.sharedInstance.alamofireGetRequest(url: webUrlString) { (data) in
                    if let responseData = data["Data"] as? [String: Any]{
                        let data =  UrlData(dict: responseData)
                        
                        webCell.descriptionLabel.text = data.description!
                        webCell.TitleLabel.text = data.title!
                        
                        let storyUrlString = "\(data.imageUrl!)"
                        let storyUrl = storyUrlString.replacingOccurrences(of: " ", with: "%20")
                        let storyImageURL = URL(string: storyUrl)
                        
                        webCell.webImageView.sd_setImage(with: storyImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
                            
                        })
                    }
                }
            }
            let tapWebPage = MyTapGesture(target: self, action: #selector(tappedWebPage))
            webCell.webImageView.isUserInteractionEnabled = true
            webCell.webImageView.addGestureRecognizer(tapWebPage)
            tapWebPage.webUrl = data.media!
            //tapWebPage.webTitle = data.title!
            
            return webCell
        }
        
        if data.profileImageUrl == ""{
            
        } else {
            let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
            let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
            let profileImageURL = URL(string: profileUrl)
            
            textCell.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
            })
        }
        
        
        textCell.diaplayNameLabel.text = data.username
        textCell.timeStampLabel.text = data.postTime
        textCell.statusLabel.text = data.media
        
        return textCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = list[indexPath.row]
        if data.media_type == 1{
            return 465
        } else if data.media_type == 2{
            return 465
        } else if data.media_type == 3{
            return 510
        }
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = list[indexPath.row]
        if data.media_type == 1{
            return 465
        } else if data.media_type == 2{
            return 465
        } else if data.media_type == 3{
            return 510
        }
        return 170
    }
    
    @objc func tap(sender : UITapGestureRecognizer) {
        guard let tappedView = sender.view else {return}
        guard let indexPath = viewIndexPathInTableView(tappedView, tableView: tableView) else {return}
        let post = list[indexPath.row]
        let frame = tappedView.convert(tappedView.frame, to: self.view)
        let imge = UIImageView.init(frame: frame)
        imge.layer.cornerRadius = 5
        imge.clipsToBounds = true
        
        if post.media_type == 1{
            //Image Cell
            
            let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
            /*imge.image = cell.storyImageView.image
             self.showFullImage(imageView: imge)*/
            
            if cell.storyImageView.image == nil {return}
            
            let image = LightboxImage.init(image: cell.storyImageView.image!, text: "", videoURL: nil)
            let vc = LightboxController.init(images: [image], startIndex: 0)
            vc.dynamicBackground = true
            self.present(vc, animated: false, completion: nil)
            
        }else if post.media_type == 2{
            // Video Cell
            
            let videoUrlString = "http://api.my24space.com/public/uploads/media/" + "\(post.media!)"
            let videoUrl = videoUrlString.replacingOccurrences(of: " ", with: "%20")
            self.showVideoPlayer(url: videoUrl)
        }
    }
    
    
    @objc func tappedWebPage(sender : MyTapGesture) {
        webPageUrl = sender.webUrl
        //webPageTitle = sender.webTitle
        let vc = WebViewController.instance()
        vc.url = webPageUrl
        present(vc, animated: true, completion: nil)
    }
    
    @objc func postsRequests(){
        self.showLoader()
        self.list.removeAll()
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "page": "1"] as [String : Any]
        print(parameters)
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/my24postlist_new") { (isSucess, message, data) in
            self.hideLoader()
            let json = JSON.init(data)
            print(json)
            if isSucess {
                if let responseArray = data["posts"] as? [[String:Any]] {
                    print(responseArray)
                    for dict in responseArray {
                        let mdl = NewsFeed(dict: dict)
                        self.list.append(mdl)
                    }
                }
            }else {
                print(message)
            }
             self.tableView.reloadData()
        }
    }
    
    func wallPostsRequests(){
        
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/myWallPostList") { (isSucess, message, data) in
            print(data)
            if isSucess {
                if let responseArray = data["posts"] as? [[String:Any]] {
                    print(responseArray)
                    for dict in responseArray {
                        let mdl = NewsFeed(dict: dict)
                        self.list.append(mdl)
                    }
                }
            }else {
                print(message)
            }
            self.tableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    @IBAction func liveBtnAction(_ sender: Any) {
        
        liveBtnOutlet.titleLabel?.textColor = UIColor.black
       // postsRequests()
        //UIColor(hex: "cccccc")
        let color : UIColor = UIColor(hex: "4C4C4C")
        wallBtnOutlet.setTitleColor(.lightGray, for: .normal)
        
        UIView.animate(withDuration: 0.1) {
            self.optionSeperatorView.frame = CGRect(x: 15, y: 30, width: 50, height: 2)
        }
    }
    
    @objc func handleRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func wallBtnAction(_ sender: Any) {
        
        wallBtnOutlet.titleLabel?.textColor = UIColor.black
       // wallPostsRequests()
        let color : UIColor = UIColor(hex: "4C4C4C")
        liveBtnOutlet.setTitleColor(.lightGray, for: .normal)
        
        UIView.animate(withDuration: 0.1) {
            self.optionSeperatorView.frame = CGRect(x: 95, y: 30, width: 50, height: 2)
        }
    }
    
    func allignment(){

        liveBtnOutlet.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        wallBtnOutlet.frame = CGRect(x: 80, y: 0, width: 80, height: 30)
        optionSeperatorView.frame = CGRect(x: 15, y: 30, width: 50, height: 2)

        
    }
    
    func myProfileRequest(){
        let parameter = ["userid": mydetails!.userId, "signature": mydetails!.signature] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameter, url: "https://api.my24space.com/v1/my_profile") { (isSucess, message, data) in
            if isSucess{
                
                if let responseArray = data["settings"] as? [String:Any] {
                    print(responseArray)
                    let data = MyProfileInfo(dict: responseArray)
                    self.usernameLabel.text = data.username!
                    
                    self.normalString = "Followers \(data.followerCount!)  Following \(data.followingCount!)  Friends \(data.friendsCount!) "
                    
                    print("Followers \(data.followerCount!)  Following \(data.followingCount!)  Friends \(data.friendsCount!) ")
                    
                    let attributedText = NSMutableAttributedString(string: self.normalString)
                    
                    attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range: self.getRangeOfSubString(subString: "Followers", fromString: self.normalString))
                    attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range: self.getRangeOfSubString(subString: "Following", fromString: self.normalString))
                    attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range: self.getRangeOfSubString(subString: "Friends", fromString: self.normalString))
                    
                    self.followLabel.attributedText = attributedText
                    
                    if data.profilePhoto != nil {
                        
                        let profileUrl = "http://api.my24space.com/public/uploads/profile/" + "\(data.profilePhoto!)"
                        let profileImageURL = URL(string: profileUrl)
                        print(profileImageURL!)
                        
                        Credits.sharedInstance.getImageRequest(imageUrl: profileImageURL!, completion: { (isSucess, message, image) in
                            if isSucess {
                                self.profilePictureImageView.image = image
                            }
                        })
                    }
                }
            }else {
                
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//class MyTapGesture: UITapGestureRecognizer {
//    var momentId = Int()
//    var momentName = String()
//    
//    var webUrl = String()
//    var webTitle = String()
//}
extension UIViewController{
    func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)!
        let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
        let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
}





extension ProfileViewController:VideoPlayerViewDelegate{
    func showFullImage(imageView:UIImageView) {
        zoomedImgView = imageView
        imageView.isUserInteractionEnabled = true
        let selector = #selector(handlePan(pan:))
        let pan = UIPanGestureRecognizer.init(target: self, action: selector)
        imageView.addGestureRecognizer(pan)
        imageView.contentMode = .scaleAspectFit
        keyWindow?.addSubview(bgView)
        keyWindow?.addSubview(imageView)
        imageView.frame = self.view.frame
        imageView.alpha = 0
        imageView.layer.cornerRadius = 0
        UIView.animate(withDuration: 0.33) {
            imageView.alpha = 1
            self.bgView.alpha = 1
        }
    }
    
    @objc func handlePan(pan:UIPanGestureRecognizer) {
        if pan.state == .began || pan.state == .changed{
            let translation = pan.translation(in: self.view)
            pan.view?.center = CGPoint.init(x: (pan.view?.center.x)! + translation.x, y: (pan.view?.center.y)! + translation.y)
            pan.setTranslation(CGPoint.zero, in: self.view)
            let y = pan.view!.center.y - view.center.y
            let alpha = 1-abs(y/SCREEN_HEIGHT)
            self.bgView.alpha = alpha
        }else if pan.state == .ended{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
                self.bgView.alpha = 0
                let centerY:CGFloat = self.view.center.y
                let currentY:CGFloat = (pan.view?.center.y)!
                if centerY > currentY{
                    // upper
                    let upperCenter = CGPoint.init(x: self.view.center.x, y: -SCREEN_HEIGHT / 2)
                    self.zoomedImgView.center = upperCenter
                }else{
                    // lower
                    let lowerCenter = CGPoint.init(x: self.view.center.x, y: SCREEN_HEIGHT + SCREEN_HEIGHT / 2)
                    self.zoomedImgView.center = lowerCenter
                }
            }, completion: {(comleted) in
                self.zoomedImgView.removeFromSuperview()
                self.zoomedImgView = nil
                self.bgView.removeFromSuperview()
            })
        }
    }
    
    func showVideoPlayer(url:String){
        guard let videoUrl = URL.init(string: url) else {return}
        keyWindow?.addSubview(bgView)
        self.bgView.alpha = 0
        self.videoPreview.alpha = 0
        self.videoPreview.removePlayer()
        self.videoPreview.center = self.view.center
        let selector = #selector(handleVideoPan(pan:))
        videoPan = UIPanGestureRecognizer.init(target: self, action: selector)
        videoPreview.addGestureRecognizer(videoPan)
        keyWindow?.addSubview(videoPreview)
        self.videoPreview.playVideo(url: videoUrl)
        UIView.animate(withDuration: 0.33, animations: {
            self.bgView.alpha = 1
            self.videoPreview.alpha = 1
        }) { (isCompleted) in
        }
    }
    
    func didFinishPlayingVideo() {
        self.videoPreview.removeGestureRecognizer(videoPan)
        UIView.animate(withDuration: 0.33, animations: {
            self.bgView.alpha = 0
            self.videoPreview.alpha = 0
        }) { (isCompleted) in
            self.videoPreview.removeFromSuperview()
        }
    }
    
    @objc func handleVideoPan(pan:UIPanGestureRecognizer) {
        if pan.state == .began || pan.state == .changed{
            let translation = pan.translation(in: self.view)
            pan.view?.center = CGPoint.init(x: (pan.view?.center.x)! + translation.x, y: (pan.view?.center.y)! + translation.y)
            pan.setTranslation(CGPoint.zero, in: self.view)
            let y = pan.view!.center.y - view.center.y
            let alpha = 1-abs(y/SCREEN_HEIGHT)
            self.bgView.alpha = alpha
        }else if pan.state == .ended{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.4, options: .curveLinear, animations: {
                self.bgView.alpha = 0
                let centerY:CGFloat = self.view.center.y
                let currentY:CGFloat = (pan.view?.center.y)!
                print(centerY,currentY)
                if centerY > currentY{
                    // upper
                    let centerGap = centerY - currentY
                    if centerGap < 200 {
                        self.videoPreview.center = self.view.center
                    }else{
                        let upperCenter = CGPoint.init(x: self.view.center.x, y: -SCREEN_HEIGHT / 2)
                        self.videoPreview.center = upperCenter
                    }
                }else{
                    // lower
                    let centerGap = abs(centerY - currentY)
                    if centerGap < 200 {
                        self.videoPreview.center = self.view.center
                    }else{
                        let lowerCenter = CGPoint.init(x: self.view.center.x, y: SCREEN_HEIGHT + SCREEN_HEIGHT / 2)
                        self.videoPreview.center = lowerCenter
                    }
                }
            }, completion: {(comleted) in
                if self.videoPreview.center == self.view.center {return}
                self.videoPreview.removeFromSuperview()
                self.videoPreview.removePlayer()
                self.bgView.removeFromSuperview()
            })
        }
    }
}
