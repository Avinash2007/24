//
//  HomeViewController.swift
//  
//
//  Created by sri on 27/12/17.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class HomeViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet weak var textViewOutlet: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMessage:UIButton!
    private var gradient: CAGradientLayer!
    var isMoved = false
    var list: [NewsFeed] = []
    var urlDataList : [UrlData] = []
    
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
    
    lazy var headerView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 100.0))
        view.backgroundColor = .red
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        applyShadow(view: textViewOutlet, radius: 30)
        self.tableView.addSubview(self.refreshControl)
//        self.tableView.tableHeaderView = self.headerView
        
        btnMessage.layer.cornerRadius = 10.0
        btnMessage.layer.shadowColor = UIColor.black.cgColor
        btnMessage.layer.shadowOpacity = 0.5
        btnMessage.layer.shadowOffset = CGSize.zero
        btnMessage.layer.shadowRadius = 5
        
      
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: self.view.frame.size.height-50, width: self.view.frame.size.width, height: 50)
        layer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        view.layer.addSublayer(layer)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //appDelegate.homeTabVC?.cameraButton.isHidden = false
        appDelegate.homeVC = self
        //check device connection state
        if isOnline(){
            showLoader()
            postsRequests()
        }else{
            // fetch saved posts
            guard let data = DefaultManager.shared.getHomeData() else {return}
            guard let savedJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {return}
            if let responseArray = savedJSON as? [[String:Any]] {
                print(responseArray)
                for dict in responseArray {
                    let mdl = NewsFeed(dict: dict)
                    self.list.append(mdl)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  appDelegate.homeTabVC?.cameraButton.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(postsRequests), name: NSNotification.Name(rawValue: "RefreshData"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name(rawValue: "RefreshData"), object: nil)
    }
    
    
    
    
    // MARK: - UITableViewDelegate
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
            
            if data.profileImageUrl != "" && data.profileImageUrl != nil {
                let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
                let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                loadImage(profileUrl, imageCell.profileImageView, activity: imageCell.profileIndicator, defaultImage: nil)
            }
            imageCell.diaplayNameLabel.text = data.username
            imageCell.timeStampLabel.text = data.postTime
            
            let storyUrlString = "http://api.my24space.com/public/uploads/media/" + "\(data.media!)"
            let storyUrl = storyUrlString.replacingOccurrences(of: " ", with: "%20")
            loadImage(storyUrl, imageCell.storyImageView, activity: imageCell.storyImageIndicator, defaultImage: nil)
            if data.album_id == 0 {
                imageCell.momentNameLabel.isHidden = true
            }else if data.album_id != 0{
                imageCell.momentNameLabel.isHidden = false
                imageCell.momentNameLabel.text = data.albumName
                
                //self.performSegue(withIdentifier: "goToAlbumPhotos", sender: nil)
            }
            
            imageCell.buttonAction = { (sender) in
                if self.isMoved != true {
                    self.moveToWallRequest(albumId: data.album_id!)
                    imageCell.moveTowallOutlet.setImage(#imageLiteral(resourceName: "movedToWall.png"), for: .normal)
                } else if self.isMoved == true {
                    self.removeFromWallRequest(albumId: data.album_id!)
                    imageCell.moveTowallOutlet.setImage(#imageLiteral(resourceName: "moveToWall.png"), for: .normal)
                }
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
            if data.profileImageUrl != ""{
                let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
                let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                loadImage(profileUrl, videoCell.profileImageView, activity: nil, defaultImage: nil)
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
            print("Video URL----->>>>>>>>",videoUrl)
            let storyVideoURL = URL(string: videoUrl)
            videoCell.playVideo(url: storyVideoURL!)
            
            videoCell.buttonAction = { (sender) in
                if self.isMoved != true {
                    self.moveToWallRequest(albumId: data.album_id!)
                    videoCell.moveToWallOutlet.setImage(#imageLiteral(resourceName: "movedToWall.png"), for: .normal)
                } else if self.isMoved == true {
                    self.removeFromWallRequest(albumId: data.album_id!)
                    videoCell.moveToWallOutlet.setImage(#imageLiteral(resourceName: "moveToWall.png"), for: .normal)
                }
            }
            
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
        
        if data.profileImageUrl != nil && data.profileImageUrl != ""{
            let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profileImageUrl!)"
            let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
            let profileImageURL = URL(string: profileUrl)
            
            textCell.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, SDImageCacheTypeMemory, url) in
            })
        } else {
           textCell.profileImageView.image = #imageLiteral(resourceName: "profilepicPlaceholder")
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
    
    //handle tap on image..
    @objc func tap(sender : MyTapGesture) {
        
        guard let tappedView = sender.view else {return}
        guard let indexPath = viewIndexPathInTableView(tappedView, tableView: tableView) else {return}
        print(indexPath.row)
        let post = list[indexPath.row]
        let frame = tappedView.convert(tappedView.frame, to: self.view)
        let imge = UIImageView.init(frame: frame)
        imge.layer.cornerRadius = 5
        imge.clipsToBounds = true
        
        
        if post.media_type == 1{
           //Image Cell
            
            let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell

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
       self.performSegue(withIdentifier: "goToWebPage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAlbumPhotos"{
            let previewVc = segue.destination as! DetailStoriesViewController
            previewVc.albumId = self.albumId
            previewVc.momentName = self.albumName
        }else if segue.identifier == "goToWebPage"{
            let previewVc = segue.destination as! WebViewController
                previewVc.url = self.webPageUrl
        }
    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        navigateVc(idName:"NormalCameraViewController")
    }
    @IBAction func userProfileBtnAction(_ sender: Any) {
        navigateVc(idName:"ProfileViewController")
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
   navigateVc(idName:"DiscoverViewController")
    }
    
    @objc func postsRequests(){
        
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "page": "1"] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/news_feed_new") { (isSucess, message, data) in
            self.list.removeAll()
            self.hideLoader()
            if isSucess {
                if let responseArray = data["posts"] as? [[String:Any]] {
                    print(responseArray)
                    for dict in responseArray {
                        let mdl = NewsFeed(dict: dict)
                        self.list.append(mdl)
                    }
                    // Save posts into device
                 let jsonData = try? JSONSerialization.data(withJSONObject: responseArray, options: .prettyPrinted)
                 DefaultManager.shared.setHomeData(data: jsonData)
                }
            }else {
              print(message)
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func moveToWallRequest(albumId: Int){
        
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "album_id": albumId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/moveToWall") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }
    }
    
    func removeFromWallRequest(albumId: Int){
        
        let parameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "album_id": albumId] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/RemoveFromWall") { (isSucess, message, data) in
            if isSucess {
                print(message)
            }else {
                print(message)
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        postsRequests()
        refreshControl.beginRefreshing()
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var momentId = Int()
    var momentName = String()

    var webUrl = String()
    var webTitle = String()
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            UIView.animate(withDuration: 0.20, animations: {
//                self.textViewOutlet.alpha = 1
            })
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            UIView.animate(withDuration: 0.33, animations: {
//                self.textViewOutlet.alpha = 0
            })
        }
    }
}



extension HomeViewController:VideoPlayerViewDelegate{
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

