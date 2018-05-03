//
//  PreviewCameraViewController.swift
//  24
//
//  Created by sri on 03/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import IGColorPicker
import NVActivityIndicatorView
import NotificationBannerSwift

class PreviewCameraViewController: UIViewController, CloseViewDelegate {

    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBOutlet weak var doodleBtnOutlet: UIButton!
    @IBOutlet weak var textBtnOutlet: UIButton!
    @IBOutlet weak var filterBtnOutlet: UIButton!
    @IBOutlet weak var stickersBtnOutlet: UIButton!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    
    @IBOutlet weak var editToolsViewOutlet: UIView!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var locationBtnOutlet: UIButton!
    @IBOutlet weak var groupBtnOutlet: UIButton!
    @IBOutlet weak var momentBtnOutlet: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var clearBtnOutlet: UIButton!
    
    @IBOutlet weak var binImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionDoneBtn: UIButton!
    @IBOutlet weak var descriptionClearBtn: UIButton!
    
    @IBOutlet weak var groupsView: UIView!
    
    var capturedImage : UIImage?
    
    var isDrawing: Bool = false{
        didSet{
            if self.swipeLeft != nil {
                if isDrawing == true{
                   self.view.removeGestureRecognizer(swipeLeft)
                }else{
                   self.view.addGestureRecognizer(swipeLeft)
                }
            }
            if self.swipeRight != nil {
                if isDrawing == true{
                    self.view.removeGestureRecognizer(swipeRight)
                }else{
                    self.view.addGestureRecognizer(swipeRight)
                }
            }
        }
    }
    
    var lastPoint: CGPoint!
    var swiped = false
    var bottomSheetIsVisible = false
    var drawColor: UIColor = UIColor.black
    var opacity: CGFloat = 1.0
    var textColor: UIColor = UIColor.black
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?
    var lastPanPoint: CGPoint?
    
    var errorDescription : String!
    var keyBoard_Height : CGFloat?
    var tag : Int!
    var momentId: Int!
    var textView: UITextView?
    var senderVC:NormalCameraViewController?
    var filterTitleList: [String]!
    var filterNameList: [String]!
    var selctedImage: UIImage!
    var index = 0
    var timer = Timer()

    var swipeRight:UISwipeGestureRecognizer!
    var swipeLeft:UISwipeGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*****************PreviewCameraViewController*****************")
        groupBtnOutlet.layer.cornerRadius = 0
        groupBtnOutlet.applyGradient([#colorLiteral(red: 0.05809741467, green: 0.1176805422, blue: 0.2381041646, alpha: 0),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], locations: [0.23,0.92])
        momentBtnOutlet.layer.cornerRadius = 0
        momentBtnOutlet.applyGradient([#colorLiteral(red: 0.05809741467, green: 0.1176805422, blue: 0.2381041646, alpha: 0),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], locations: [0.23,0.92])
        
        groupsView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height - 150)
        
       
        let controller = storyboard?.instantiateViewController(withIdentifier: "SelectGroupViewController") as! SelectGroupViewController
        controller.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        
        activityView.isHidden = true
        
        locationBtnOutlet.isHidden = true
        
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.isSelectedColorTappable = false
        colorPickerView.style = .circle
        colorPickerView.selectionStyle = .check
        colorPickerView.backgroundColor = .clear
        
        capturedImageView.image = self.capturedImage
        
        doneBtnOutlet.isHidden = true
        clearBtnOutlet.isHidden = true
        colorPickerView.isHidden = true
        deleteView.isHidden = true
        
        //momentBtnOutlet.isHidden = true
        
        filterBtnOutlet.isHidden = false
        stickersBtnOutlet.isHidden = true
        
        cameraViewAllignments()
        descriptionViewAllignment()
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowing(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiding(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        descriptionTextView.delegate = self
        descriptionTextView.text = "Got something to share? Well share it!"
        descriptionTextView.textColor = UIColor.lightGray
        
        self.imageFilterActions()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //It will show the status bar again after dismiss
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func closeGroupSelectionView() {
        UIView.animate(withDuration: 0.5) {
            self.groupsView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height - 150)
        }
    }
    
    
    func notificationBanner (message: String, style: BannerStyle){
        let banner = StatusBarNotificationBanner(title: message, style: style)
        banner.show()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        doneBtnOutlet.isHidden = false
        clearBtnOutlet.isHidden = true
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        doneBtnOutlet.isHidden = true
        clearBtnOutlet.isHidden = false
        hideToolbar(hide: false)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
//                self.colorPickerView.frame = CGRect(x: 0, y: screenSize.height - 80, width: screenSize.width, height: 50)
//               // self.colorPickerViewBottomConstraint?.constant = 0.0
            } else {
//                self.colorPickerView.frame = CGRect(x: 0, y: (endFrame?.size.height)!, width: screenSize.width, height: 50)
               // self.colorPickerViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        //clear drawing
       // capturedImage.image = image
        tempImageView.image = nil
        //clear stickers and textviews
        for subview in tempImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func descriptionDoneBtnAction(_ sender: Any) {

        
        self.descriptionTextView.resignFirstResponder()
        descriptionView.frame = CGRect(x: 20, y: screenSize.height + 20, width: screenSize.width - 40, height: 300)
    }
    
    @IBAction func descriptionClearBtnAction(_ sender: Any) {
        self.descriptionTextView.text = ""
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {

        clearBtnOutlet.isHidden = false
        groupBtnOutlet.isHidden = false
        momentBtnOutlet.isHidden = false
        switch tag {
        case 0:
            //Doodle
            print(tag)
            view.endEditing(true)
            isDrawing = false
            tempImageView.isUserInteractionEnabled = true
            doneBtnOutlet.isHidden = true
            clearBtnOutlet.isHidden = false
            colorPickerView.isHidden = true
            hideToolbar(hide: false)
            
        case 1:
            //Text
            print(tag)

            view.endEditing(true)
            isDrawing = false
            tempImageView.isUserInteractionEnabled = true
            doneBtnOutlet.isHidden = true
            clearBtnOutlet.isHidden = false
            colorPickerView.isHidden = true
            hideToolbar(hide: false)

        case 2:
            //Filters
            print(tag)
            
        case 3:
            //Emoji
            print(tag)

            
        default:
            print("nill")
        }
    }

    
    func hideToolbar(hide:  Bool){
        editToolsViewOutlet.isHidden = hide
        backBtnOutlet.isHidden = hide
    }
    
    
    @IBAction func editImageBtnAction(_ sender: Any) {

      tag = (sender as AnyObject).tag!
        switch tag {
        case 0:
            //Doodle
            print(tag)
            doodleBtnOutlet.setImage(#imageLiteral(resourceName: "DoodleSelected"), for: .normal)
            textBtnOutlet.setImage(#imageLiteral(resourceName: "TextUnselected"), for: .normal)
            filterBtnOutlet.setImage(#imageLiteral(resourceName: "AddDescription"), for: .normal)
            stickersBtnOutlet.setImage(#imageLiteral(resourceName: "Emoji"), for: .normal)
            
            isDrawing = true
            tempImageView.isUserInteractionEnabled = false
            doneBtnOutlet.isHidden = false
            clearBtnOutlet.isHidden = true
            colorPickerView.isHidden = false
            groupBtnOutlet.isHidden = true
            momentBtnOutlet.isHidden = true
            hideToolbar(hide: true)
            
            colorPickerView.frame = CGRect(x: 0, y: screenSize.height - 80, width: screenSize.width, height: 50)
            
        case 1:
            //Text
            print(tag)
            
            doneBtnOutlet.isHidden = false
            clearBtnOutlet.isHidden = true
            groupBtnOutlet.isHidden = true
            momentBtnOutlet.isHidden = true
            
            doodleBtnOutlet.setImage(#imageLiteral(resourceName: "DoodleUnselected"), for: .normal)
            textBtnOutlet.setImage(#imageLiteral(resourceName: "TextSelected"), for: .normal)
            filterBtnOutlet.setImage(#imageLiteral(resourceName: "AddDescription"), for: .normal)
            stickersBtnOutlet.setImage(#imageLiteral(resourceName: "Emoji"), for: .normal)
            
            textView = UITextView(frame: CGRect(x: 0, y: tempImageView.center.y,
                                                    width: UIScreen.main.bounds.width, height: 30))
            
            //Text Attributes
            textView?.textAlignment = .center
            textView?.font = UIFont(name: "Quicksand-Bold", size: 30)
            textView?.textColor = textColor
            textView?.layer.shadowColor = UIColor.black.cgColor
            textView?.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
            textView?.layer.shadowOpacity = 0.2
            textView?.layer.shadowRadius = 1.0
            textView?.layer.backgroundColor = UIColor.clear.cgColor
            //
            textView?.autocorrectionType = .no
            textView?.isScrollEnabled = false
            textView?.delegate = self as! UITextViewDelegate
            self.tempImageView.addSubview(textView!)
            addGestures(view: textView!)
            textView?.becomeFirstResponder()
            
            self.colorPickerView.frame = CGRect(x: 0, y: screenSize.height - (self.keyBoard_Height! + 60), width: screenSize.width, height: 50)
        
        case 2:
            //Filters
            print(tag)
            doodleBtnOutlet.setImage(#imageLiteral(resourceName: "DoodleUnselected"), for: .normal)
            textBtnOutlet.setImage(#imageLiteral(resourceName: "TextUnselected"), for: .normal)
            filterBtnOutlet.setImage(#imageLiteral(resourceName: "AddDescription"), for: .normal)
            stickersBtnOutlet.setImage(#imageLiteral(resourceName: "Emoji"), for: .normal)
            
            doneBtnOutlet.isHidden = true
            
            self.descriptionTextView.becomeFirstResponder()
            descriptionView.frame = CGRect(x: 20, y: screenSize.height - (keyBoard_Height! + 310), width: screenSize.width - 40, height: 300)
        case 3:
            //Emoji
            print(tag)
            doodleBtnOutlet.setImage(#imageLiteral(resourceName: "DoodleUnselected"), for: .normal)
            textBtnOutlet.setImage(#imageLiteral(resourceName: "TextUnselected"), for: .normal)
            filterBtnOutlet.setImage(#imageLiteral(resourceName: "AddDescription"), for: .normal)
            stickersBtnOutlet.setImage(#imageLiteral(resourceName: "Emoji"), for: .normal)
            
        default:
            print("nill")
        }
    }
    
    @IBAction func openGroupBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            self.groupsView.frame = CGRect(x: 0, y: 150, width: screenSize.width, height: screenSize.height - 150)
        }
   // self.navigateVc(idName: "selectGroupVc")
    }
    
    @IBAction func sendImageBtnAction(_ sender: Any) {
        
        locationBtnOutlet.isHidden = true
        groupBtnOutlet.isHidden = true
        momentBtnOutlet.isHidden = true
        clearBtnOutlet.isHidden = true
        doneBtnOutlet.isHidden = true
        backBtnOutlet.isHidden = true
        editToolsViewOutlet.isHidden = true
        
        guard let image = image(with: self.view) else {return}
        print(image)
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
        self.activityView.addSubview(activityIndicatorView)

        activityView.isHidden = false
        activityIndicatorView.startAnimating()
        
        print("sending")

        let postParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "description": descriptionTextView.text!, "web_link": "", "tag_friends": "", "latitude": "", "longitude": "", "post_type": "1", "group_id": "\(postDetails.groupId)"] as? [String: Any]
        
        print("----\(postDetails.groupId)")
        
        Post.sharedInstance.createPost(dict: postParameters!) { (response, errorMessage, postId) in
            
            let errorMessage: String = errorMessage
            let postId: Int = postId
            
            if response {
                
                self.activityView.isHidden = true
                activityIndicatorView.stopAnimating()
                
                self.notificationBanner(message: "Uploading...", style: .warning)
                self.dismiss(animated: false, completion: nil)
                self.senderVC?.dismiss(animated: false, completion: nil)
                
                let parameters = ["user_id": "\(mydetails!.userId)", "signature": mydetails!.signature, "post_id": String(postId), "album_id":  "\(self.momentId)", "media_type": "1"] as [String : Any]
                
                Credits.sharedInstance.uploadImageRequest(dict: parameters, image: image, fileName: self.randomString(), url: "http://api.my24space.com/v1/add_media", parameterName: "media", completion: { (isSucess, message) in
                    if isSucess {
                        
                        self.descriptionTextView.text = "Got something to share? Well share it!"
                        self.descriptionTextView.textColor = UIColor.lightGray
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshData"), object: nil)
                        print("sucess")
                        self.activityView.isHidden = true
                        self.notificationBanner(message: "Uploaded...", style: .success)
                    }else {
                        self.notificationBanner(message: "please check you internet", style: .danger)
                        self.errorDescription = "please check you internet"
                        self.activityView.isHidden = true
                    }
                })
                
            }else {
                self.notificationBanner(message: "Something gone wrong", style: .danger)
                self.errorDescription = "Something gone wrong"
                self.activityView.isHidden = true
               // activityIndicatorView.stopAnimating()
               // self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
                print("not uploaded")
               
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "goToPopUpVc"{
//            let previewVc = segue.destination as! PopUpViewController
//            previewVc.errorMessage = errorDescription
//        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func momentBtnAction(_ sender: Any) {
        
    }
    
    func imageFilterActions(){
        self.filterTitleList = ["none" ,"Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
        
        self.filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
        
            self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(swipeRight)
            
            self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            self.view.addGestureRecognizer(swipeLeft)
            
            self.selctedImage = capturedImageView.image
        

       ////// filterLabel.text = ""
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                index -= 1
                if index < 0 {
                    index = 8
                    applyFilter(selectedFilterIndex: index)
                    filterLabelAnimation(index: index)
                }else {
                    applyFilter(selectedFilterIndex: index)
                    filterLabelAnimation(index: index)
                }
            case UISwipeGestureRecognizerDirection.left:
                index += 1
                if index > 8{
                    index = 0
                    applyFilter(selectedFilterIndex: index)
                    filterLabelAnimation(index: index)
                } else {
                    applyFilter(selectedFilterIndex: index)
                    filterLabelAnimation(index: index)
                }
            default:
                break
            }
        }
    }
    
    func filterLabelAnimation(index: Int){
        timer.invalidate()
        //////self.filterLabel.text = self.filterTitleList[self.index]
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideFilterLabel), userInfo: nil, repeats: false)
    }
    
    @objc func hideFilterLabel(){
      //////  self.filterLabel.text = ""
    }

    
    func applyFilter(selectedFilterIndex filterIndex: Int) {
        
        if filterIndex == 0 {
            self.capturedImageView.image = self.selctedImage
            return
        }
        guard let cgImage = self.selctedImage.cgImage else {return}
        
        let sourceImage = CIImage.init(cgImage: cgImage)//CIImage(image: self.selctedImage)
        
        let myFilter = CIFilter(name: self.filterNameList[filterIndex])
        myFilter?.setDefaults()
        
        myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        if let output = myFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let filteredImage = UIImage.init(ciImage: output)
            self.capturedImageView.image = filteredImage
        }
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PreviewCameraViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(PreviewCameraViewController.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                            action:#selector(PreviewCameraViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PreviewCameraViewController.tapGesture))
        view.addGestureRecognizer(tapGesture)
        
    }
    
}

extension PreviewCameraViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if descriptionTextView.text == "Got something to share? Well share it!"{
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
        
        lastTextViewTransform =  textView.transform
        lastTextViewTransCenter = textView.center
        lastTextViewFont = textView.font!
        activeTextView = textView
        textView.superview?.bringSubview(toFront: textView)
        if textView != descriptionTextView {
            textView.font = UIFont(name: "Quicksand-Bold", size: 30)
        }
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        }, completion: nil)
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        if descriptionTextView.text == "" {
            
            descriptionTextView.text = "Got something to share? Well share it!"
            descriptionTextView.textColor = UIColor.lightGray
        }
        
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
            else {
                return
        }
        activeTextView = nil
        textView.font = self.lastTextViewFont!
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = self.lastTextViewTransform!
                        textView.center = self.lastTextViewTransCenter!
        }, completion: nil)
    }
    
}

extension PreviewCameraViewController {
    //MARK: Pencil
    
    override public func touchesBegan(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            //            self.view.bringSubview(toFront: tempImageView)
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.tempImageView)
            }
        }
            //Hide BottomSheet if clicked outside it
        else if bottomSheetIsVisible == true {
            if let touch = touches.first {
                let location = touch.location(in: self.view)
//                if !bottomSheetVC.view.frame.contains(location) {
//                    removeBottomSheetView()
//                }
            }
        }
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            // 6
            swiped = true
            if let touch = touches.first {
                let currentPoint = touch.location(in: tempImageView)
                drawLineFrom(lastPoint, toPoint: currentPoint)
                
                // 7
                lastPoint = currentPoint
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>,
                                      with event: UIEvent?){
        if isDrawing {
            if !swiped {
                // draw a single point
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
        }
        
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(capturedImageView.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: capturedImageView.frame.size.width, height: capturedImageView.frame.size.height))
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            // 3
            context.setLineCap( CGLineCap.round)
            context.setLineWidth(4)
            context.setStrokeColor(drawColor.cgColor)
            context.setBlendMode( CGBlendMode.normal)
            // 4
            context.strokePath()
            // 5
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
}

extension PreviewCameraViewController : UIGestureRecognizerDelegate  {
    //Translation is moving object
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                //Tap only on visible parts on the image
                if recognizer.state == .began {
                    for imageView in subImageViews(view: tempImageView) {
                        let location = recognizer.location(in: imageView)
                        let alpha = capturedImageView.alphaAtPoint(location)
                        if alpha > 0 {
                            imageViewToPan = capturedImageView
                            break
                        }
                    }
                }
                if imageViewToPan != nil {
                    moveView(view: imageViewToPan!, recognizer: recognizer)
                }
            } else {
                moveView(view: view, recognizer: recognizer)
            }
        }
    }
    
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if view is UITextView {
                let textView = view as! UITextView
                let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                textView.font = font
                
                let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                             height:CGFloat.greatestFiniteMagnitude))
                
                textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                              height: sizeToFit.height)
                
                textView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }
    
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                //Tap only on visible parts on the image
                for imageView in subImageViews(view: tempImageView) {
                    let location = recognizer.location(in: imageView)
                    let alpha = capturedImageView.alphaAtPoint(location)
                    if alpha > 0 {
                        scaleEffect(view: imageView)
                        break
                    }
                }
            } else {
                scaleEffect(view: view)
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !bottomSheetIsVisible {
              //  addBottomSheetView()
            }
        }
    }
    
    func scaleEffect(view: UIView) {
        view.superview?.bringSubview(toFront: view)
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
                        }
        })
    }
    
    func moveView(view: UIView, recognizer: UIPanGestureRecognizer)  {
        
        hideToolbar(hide: true)
        deleteView.isHidden = false
        
        view.superview?.bringSubview(toFront: view)
        let pointToSuperView = recognizer.location(in: self.view)
        //
        view.center = CGPoint(x: view.center.x + recognizer.translation(in: tempImageView).x,
                              y: view.center.y + recognizer.translation(in: tempImageView).y)
        
        //        let point = recognizer.location(in: tempImageView)
        //        view.center = point
        
        recognizer.setTranslation(CGPoint.zero, in: tempImageView)
        
        if let previousPoint = lastPanPoint {
            //View is going into deleteView
            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                    view.center = recognizer.location(in: self.tempImageView)
                })
            }
                //View is going out of deleteView
            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
                //Scale to original Size
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 4, y: 4)
                    view.center = recognizer.location(in: self.tempImageView)
                })
            }
        }
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            imageViewToPan = nil
            lastPanPoint = nil
            hideToolbar(hide: false)
            deleteView.isHidden = true
            let point = recognizer.location(in: self.view)
            
            if deleteView.frame.contains(point) { // Delete the view
                view.removeFromSuperview()
                if #available(iOS 10.0, *) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            } else if !tempImageView.bounds.contains(view.center) { //Snap the view back to tempimageview
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.tempImageView.center
                })
                
            }
        }
    }
    
    func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        for imageView in view.subviews {
            if imageView is UIImageView {
                imageviews.append(imageView as! UIImageView)
            }
        }
        return imageviews
    }
}

extension UIImageView {
    
    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        
        context.translateBy(x: -point.x, y: -point.y);
        
        layer.render(in: context)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }
}
extension PreviewCameraViewController: ColorPickerViewDelegate, ColorPickerViewDelegateFlowLayout{
    
    // MARK: - ColorPickerViewDelegate
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
       
        drawColor = colorPickerView.colors[indexPath.item]
        textColor = colorPickerView.colors[indexPath.item]
        textView?.textColor = textColor
    }
    
    
    // MARK: - ColorPickerViewDelegateFlowLayout
    
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}

extension PreviewCameraViewController {
    
    func cameraViewAllignments(){
        capturedImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        tempImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        backBtnOutlet.frame = CGRect(x: 5, y: 15, width: 50, height: 50)
        doneBtnOutlet.frame = CGRect(x: screenSize.width - 65, y: 30, width: 50, height: 30)
        clearBtnOutlet.frame = CGRect(x: screenSize.width - 65, y: 30, width: 50, height: 30)
        deleteView.frame = CGRect(x: (screenSize.width / 2) - 25, y: screenSize.height - 100, width: 50, height: 50)
        binImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        
        editToolsViewOutlet.frame = CGRect(x: 20, y: screenSize.height - 65, width: screenSize.width - 40, height: 50)
        doodleBtnOutlet.frame = CGRect(x: 15, y: 3, width: 44, height: 44)
        textBtnOutlet.frame = CGRect(x: 74, y: 3, width: 44, height: 44)
        filterBtnOutlet.frame = CGRect(x: 133, y: 3, width: 44, height: 44)
        stickersBtnOutlet.frame = CGRect(x: 192, y: 3, width: 44, height: 44)
        sendBtnOutlet.frame = CGRect(x: editToolsViewOutlet.frame.width - 60, y: 5, width: 40, height: 40)
       // locationBtnOutlet.frame = CGRect(x: screenSize.width - 65, y: doneBtnOutlet.frame.origin.y + 115, width: 50, height: 50)
        groupBtnOutlet.frame = CGRect(x: screenSize.width - 65, y: doneBtnOutlet.frame.origin.y + 160, width: 40, height: 40)
        momentBtnOutlet.frame = CGRect(x: screenSize.width - 65, y: groupBtnOutlet.frame.origin.y + 60, width: 40, height: 40)
        colorPickerView.frame = CGRect(x: 0, y: screenSize.height - 80, width: screenSize.width, height: 50)
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
    }
    
    func descriptionViewAllignment(){
        descriptionView.frame = CGRect(x: 20, y: screenSize.height + 20, width: screenSize.width - 40, height: 300)
        descriptionTextView.frame = CGRect(x: 10, y: 10, width: descriptionView.frame.width - 20, height: 235)
        descriptionDoneBtn.frame = CGRect(x: descriptionView.frame.width - 80, y: descriptionView.frame.height - 40, width: 60, height: 30)
        descriptionClearBtn.frame = CGRect(x: 20, y: descriptionView.frame.height - 40, width: 60, height: 30)
        applyPlaceholderStyle(aTextview: descriptionTextView!, placeholderText: "Enter Description...")
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
    }
}

extension PreviewCameraViewController{
    
    @objc func keyboardWillShowing(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        self.keyBoard_Height = keyboardHeight
        
//        self.colorPickerView.frame = CGRect(x: 0, y: screenSize.height - (self.keyBoard_Height + 60), width: screenSize.width, height: 50)

    }
    
    @objc func keyboardWillHiding(notification: Notification) {
        
        colorPickerView.frame = CGRect(x: 0, y: screenSize.height + 80, width: screenSize.width, height: 50)
    }
}

extension UIViewController{
    func randomString(length: Int = 15) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
