//
//  FriendProfileViewController.swiftFriendProfileViewController
//  24
//
//  Created by sri on 06/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
   
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var followBtnOutlet: UIButton!
    
    var list: [NewsFeed] = []
    
    var isFollowing = false
    
    var normalString = ""
    
    var userId: Int!
    var signature: String!
    var isFriend = false
    
    var parameters = [String : Any]()
    
    var albumId: Int?
    var albumName: String?
    var webPageUrl : String?
    var webPageTitle: String?
    
    var profileData:UserProfileInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsRequests()
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
       // followLabelTapped()
        labelTapGesture()
        followBtnAllignment()
        viewProfile()
        //allignment()
        //postsRequests()
        
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(postsRequests), name: NSNotification.Name(rawValue: "RefreshData"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name(rawValue: "RefreshData"), object: nil)
        if isFollowing == true{
            addFollowing(userId: userId)
        }else {
            unFollowing(userId: userId)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let textCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewTextCell") as! HomeTableViewTextCell
        let webCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebCell") as! HomeTableViewWebCell
        let webTextCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebTextCell") as! HomeTableViewWebTextCell
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewVideoCell") as! HomeTableViewVideoCell
        let webVideoCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewWebVideoCell") as! HomeTableViewWebVideoCell
        
        
        
        let data = list[indexPath.row]
        
        if data.media_type == 1{
            
            if data.profileImageUrl == ""{
                
            } else {
                let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
                let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                let profileImageURL = URL(string: profileUrl)
                
                imageCell.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
                    
                })
            }
            
            imageCell.diaplayNameLabel.text = data.username
            imageCell.timeStampLabel.text = data.postTime
            
            let storyUrlString = "http://api.my24space.com/public/uploads/media/" + "\(data.media!)"
            let storyUrl = storyUrlString.replacingOccurrences(of: " ", with: "%20")
            let storyImageURL = URL(string: storyUrl)
            
            //imageCell.profileImageView.kf.setImage(with: storyImageURL!)
            imageCell.storyImageView.sd_setImage(with: storyImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
                
            })
            
            if data.album_id == 0 {
                imageCell.momentNameLabel.isHidden = true
            }else if data.album_id != 0{
                imageCell.momentNameLabel.isHidden = false
                imageCell.momentNameLabel.text = data.albumName
                
                //self.performSegue(withIdentifier: "goToAlbumPhotos", sender: nil)
            }
            
            let tapPhoto = MyTapGesture(target: self, action: #selector(tap))
            imageCell.storyImageView.isUserInteractionEnabled = true
            imageCell.storyImageView.addGestureRecognizer(tapPhoto)
            tapPhoto.momentId = data.album_id!
            if data.albumName == nil{
                
            }else {
                tapPhoto.momentName = data.albumName!
            }
            return imageCell
            
        } else if data.media_type == 2{
            
            if data.profileImageUrl == ""{
                
            } else {
                let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
                let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                let profileImageURL = URL(string: profileUrl)
                
                videoCell.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
                    
                })
            }
            
            videoCell.diaplayNameLabel.text = data.username
            videoCell.timeStampLabel.text = data.postTime
            
            if data.album_id == 0 {
                videoCell.momentNameLabel.isHidden = true
            }else if data.album_id != 0{
                videoCell.momentNameLabel.isHidden = false
                videoCell.momentNameLabel.text = data.albumName
                
            }
            
            let videoUrlString = "http://api.my24space.com/public/uploads/media/" + "\(data.media!)"
            let videoUrl = videoUrlString.replacingOccurrences(of: " ", with: "%20")
            print(videoUrl)
            let storyVideoURL = URL(string: videoUrl)
            print(storyVideoURL)
            
            videoCell.playVideo(url: storyVideoURL!)
            
            let tapVideo = MyTapGesture(target: self, action: #selector(tap))
            videoCell.videoView.isUserInteractionEnabled = true
            videoCell.videoView.addGestureRecognizer(tapVideo)
            tapVideo.momentId = data.album_id!
            
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
    
    @objc func tap(sender : MyTapGesture) {
        print("tapVideo")
        print(sender.momentId)
        
        if sender.momentId == 0{
            print("no moment")
        }else {
            
            albumId = sender.momentId
            albumName = sender.momentName
            self.performSegue(withIdentifier: "goToAlbumPhotos", sender: nil)
            
            print("tapppedddddddd")
        }
    }
    
    @objc func tappedWebPage(sender : MyTapGesture) {
        
        webPageUrl = sender.webUrl
        //webPageTitle = sender.webTitle
        self.performSegue(withIdentifier: "goToWebPage", sender: nil)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    @objc func postsRequests(){
        self.list.removeAll()
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "page": "1","viewer_id": userId!] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/my24postlist_new") { (isSucess, message, data) in
            if isSucess{
                if let responseArray = data["posts"] as? [[String:Any]] {
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func liveBtnAction(_ sender: Any) {
        
        liveBtnOutlet.titleLabel?.textColor = UIColor.black
        // wallBtnOutlet.setTitleColor(UIColorFromRGB(rgbValue: "4C4C4C"), for: .Normal)
        
        UIView.animate(withDuration: 0.1) {
            self.optionSeperatorView.frame = CGRect(x: 15, y: 30, width: 50, height: 2)
        }
    }
    
    @IBAction func wallBtnAction(_ sender: Any) {
        
        wallBtnOutlet.titleLabel?.textColor = UIColor.black
        //liveBtnOutlet.setTitleColor(UIColorFromRGB(rgbValue: "4C4C4C"), for: .Normal)
        
        UIView.animate(withDuration: 0.1) {
            self.optionSeperatorView.frame = CGRect(x: 95, y: 30, width: 50, height: 2)
        }
    }
    
    func allignment(){
        liveBtnOutlet.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        wallBtnOutlet.frame = CGRect(x: 80, y: 0, width: 80, height: 30)
        optionSeperatorView.frame = CGRect(x: 15, y: 30, width: 50, height: 2)
        
        
    }
    
    func labelTapGesture(){
        
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewFollowers))
        followLabel.isUserInteractionEnabled = true
        followLabel.addGestureRecognizer(addPhotoTapGestureRecognizer)
    }
    
    @objc func viewFollowers(){
        
        print("labelTapped")
        mydetails!.viewerId = userId
        self.navigateVc(idName: "AboutProfileVc")
        
        
    }

    @IBAction func followBtnAction(_ sender: Any) {
        guard let pofile = profileData else {return}
        if isFollowing == true {
            pofile.followingCount = pofile.followingCount! - 1
            self.followBtnOutlet.setTitle( "Follow", for: .normal)
            isFollowing = false
            //unFollowing(userId: userId)
        }else {
            //addFollowing(userId: userId)
            pofile.followingCount = pofile.followingCount! + 1
            self.followBtnOutlet.setTitle( "Following", for: .normal)
            isFollowing = true
        }
        updateFollowStatus(data: pofile)
    }

     func followBtnAllignment(){
        
        followBtnOutlet.clipsToBounds = true
        followBtnOutlet.layer.borderWidth = 1.0
        followBtnOutlet.layer.borderColor = UIColor.darkGray.cgColor
        followBtnOutlet.layer.cornerRadius = 15
    }
    
    func addFollowing(userId: Int){
        self.followBtnOutlet.addLoader()
        parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": userId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/add_following") { (isSucess, message, data) in
            self.followBtnOutlet.removeLoader()
            if isSucess {
                /*print(message)
                self.followBtnOutlet.setTitle( "Followimg", for: .normal)
                self.viewProfile()*/
            }else {
                print(message)
            }
        }
    }
    
    func unFollowing(userId: Int){
        self.followBtnOutlet.addLoader()
        parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": userId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/un_following") { (isSucess, message, data) in
            self.followBtnOutlet.removeLoader()
            if isSucess {
                /*self.followBtnOutlet.setTitle( "Follow", for: .normal)
                self.viewProfile()
                print(message)*/
            }else {
                print(message)
            }
        }
    }
    
    func requestWall(userId: Int){

        parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "following_id": userId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/request_wall") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }
    }
    
    func viewProfile(){

        let parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature, "profile_user_id": userId!] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/view_profile") { (isSucess, message, data) in
            if isSucess {
                
                if let response = data["profile"] as? [String: Any]{
                    let json = JSON.init(data)
                    print(json)
                    
                    let data =  UserProfileInfo(dict: response)
                    self.profileData = data
                    self.usernameLabel.text = data.username
                    
                    let profileUrl = "http://api.my24space.com/public/uploads/profile/" + "\(data.profilePhoto!)"
                    let profileImageURL = URL(string: profileUrl)
                    
                    
                    Credits.sharedInstance.getImageRequest(imageUrl: profileImageURL!, completion: { (isSucess, message, image) in
                        if isSucess {
                            self.profilePictureImageView.image = image
                        }
                    })
                    self.updateFollowStatus(data: data)
                    if data.followingStatus == 1{
                        self.isFollowing = true
                        self.followBtnOutlet.setTitle( "Following", for: .normal)
                    } else{
                        self.isFollowing = false
                        self.followBtnOutlet.setTitle( "Follow", for: .normal)
                    }
                }
                print("sucess")
            }else {
                print(message)
            }
        }
    }
    
    func updateFollowStatus(data:UserProfileInfo) {
        self.normalString = "Followers \(data.followerCount!)  Following \(data.followingCount!)  Friends \(data.friendsCount!) "
        
        let attributedText = NSMutableAttributedString(string: self.normalString)
        
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range: self.getRangeOfSubString(subString: "Followers", fromString: self.normalString))
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range: self.getRangeOfSubString(subString: "Following", fromString: self.normalString))
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Medium", size: 12)!], range:self.getRangeOfSubString(subString: "Friends", fromString: self.normalString))
        self.followLabel.attributedText = attributedText
    }
}
