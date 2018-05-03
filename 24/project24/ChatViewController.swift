//
//  ChatViewController.swift
//  project24
//
//  Created by sri on 05/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import AVFoundation
import MobileCoreServices

class ChatViewController: UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var enterMessageTextView: UITextField!
    
    var user : User!
    var message : Messages!
    var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView.alwaysBounceVertical = true

        navigationItem.title = user.username
        observeMessages()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupKeyboardObservers()

    }
    

    
    func setupKeyboardObservers(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(sender: NSNotification) {
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = 0
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-65)
            }
            else {
                
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 65
            }
            else {
                
            }
        }
    }
    
    func observeMessages()  {
        
        guard let uid = Auth.auth().currentUser?.uid , let toId = user.id else {
            return
        }
        
        let reference = Database.database().reference().child("User-Messages").child(uid).child(toId)
        reference.observe(.childAdded, with: { (snapshot) in
            
            let msgId = snapshot.key
            let msgReference = Database.database().reference().child("Messages").child(msgId)
            msgReference.observe(.value, with: { (snapshot) in
                
                guard let dict = snapshot.value as? [String : AnyObject] else{
                return
                }
                self.message = Messages.transformMessage(dict: dict, key: snapshot.key)
                
                if self.message.chatPatnerId() == self.user?.id {
                    self.messages.append(self.message)

                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                 }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    @IBAction func sendPhotos(_ sender: Any) {
        
            let photo = UIImagePickerController()
            photo.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
            photo.allowsEditing = true
            photo.delegate = self
        self.present(photo, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
            handleVideoSelectForUrl(url: videoUrl)
        } else {
            handleImageselectedForInfo(info: info as [String : AnyObject])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func handleVideoSelectForUrl(url :NSURL){
    
        let filename = NSUUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("video_messages").child(filename).putFile(from: url as URL, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                return
            }
            if let videoUrl = metadata?.downloadURL()?.absoluteString{
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url){
                    
                    self.uploadImageToFirebase(image: thumbnailImage, completion: { (imageUrl) in
                      
                        let properties: [String: AnyObject] = ["imageUrl":imageUrl as AnyObject,"imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject,"videoUrl": videoUrl as AnyObject]
                        self.sendMessage(properties: properties)
                    })
                }
            }
        })
        uploadTask.observe(.progress) { (snapshot) in
            
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl : NSURL) -> UIImage?{
    
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage : thumbnailCGImage)
        }catch let err {
            
        }
        return nil
    }
    
    
    
    private func handleImageselectedForInfo(info : [String: AnyObject]){
    
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            uploadImageToFirebase(image: selectedImage, completion: {(imageUrl) in
                
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            
            })
        }
    }
    
    private func uploadImageToFirebase(image : UIImage, completion: @escaping (_ imageUrl: String) -> ()){
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
        
            ref.putData(uploadData, metadata : nil,completion :{(metadata,error) in
                
                if error != nil {
                return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    
                    completion(imageUrl)

                    //let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
                    //self.sendMessageWithImageUrl(imageUrl, image: image)
                }
            })
        }
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        self.sendMessage(properties: properties)    }
    
    
    
    private func sendMessage(properties: [String: AnyObject]){
        
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = Int(Date().timeIntervalSince1970)

        //var values = ["toId" : toId , "fromId" : fromId, "timeStamp" : timeStamp,"imageUrl" : imageUrl ,"imageWidth":image.size.width,"imageHeight":image.size.height] as [String : Any]
        
        var values = ["toId" : toId , "fromId" : fromId, "timeStamp" : timeStamp] as [String : Any]
        
        properties.forEach({values[$0] = $1})

        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("error")
                return
            }
            self.enterMessageTextView.text = nil
            
            let fromIdRef =  Database.database().reference().child("User-Messages").child(fromId!).child(toId).updateChildValues([childRef.key : true])
            
            let toIdRef =  Database.database().reference().child("User-Messages").child(toId).child(fromId!).updateChildValues([childRef.key : true])
            
        }

    
    }


    @IBAction func backButton(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sendMessageBtn(_ sender: Any) {
        
        
        
    /*    let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        
        let values = ["message" : enterMessageTextView.text , "toId" : toId , "fromId" : fromId, "timeStamp" : timeStamp] as [String : Any] */
        
        let values = ["message" : enterMessageTextView.text] as [String : Any]
        
        sendMessage(properties: values as [String : AnyObject])

       /* childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
            print("error")
                return
            }
            self.enterMessageTextView.text = nil
            
            
            let fromIdRef =  Database.database().reference().child("User-Messages").child(fromId!).child(toId).updateChildValues([childRef.key : true])

           let toIdRef =  Database.database().reference().child("User-Messages").child(toId).child(fromId!).updateChildValues([childRef.key : true])
        
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        
        let  message = messages[indexPath.item]
        if let text = message.message{
            
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidht?.floatValue , let imageHeight = message.imageHeight?.floatValue {
        
            height = CGFloat(imageHeight / imageWidth * 200)
            
        
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
    
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionViewCell", for: indexPath) as! ChatCollectionViewCell
        
        cell.chatViewController = self
        
        let message = messages[indexPath.item]
        cell.textView.text = message.message

        cell.message = message
        
        setUpCell(cell: cell, message: message)
        
        if let text = message.message{
        
            cell.textView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.message!).width  + 32
            
        }else if message.imageUrl != nil {
        
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 200
            
        }
              cell.playButton.isHidden = message.videoUrl == nil

        return cell
        
    }
    
    private func setUpCell(cell: ChatCollectionViewCell , message:Messages){

        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatCollectionViewCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewleftAnchor?.isActive = false
            
        }
        else{
            cell.bubbleView.backgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewleftAnchor?.isActive = true
            
        }
      /*  if let messageImageUrl = URL(string: message.imageUrl!){
            cell.messageImageView.sd_setImage(with: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        }*/
        /*else{
            cell.messageImageView.isHidden = true
        }*/
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    var startingFrame : CGRect?
    var blackBackgroundView : UIView?
    var startingImageView : UIImageView?
    
    func performZoomInForStartingImageView(startingImageView:UIImageView){
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
    
        startingFrame = (startingImageView.superview?.convert(startingImageView.frame ,to:nil))!
         let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: startingFrame!)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            
        keyWindow.addSubview(zoomingImageView)
 
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let height = (self.startingFrame?.height)! / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: { (completed) in
                
            })
        }
    }
    
    func handelZoomOut(tapGesture: UITapGestureRecognizer){
        
        if let zoomOutImageview = tapGesture.view{
            
            zoomOutImageview.layer.cornerRadius = 16
            zoomOutImageview.clipsToBounds = true
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                zoomOutImageview.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed) in
                 zoomOutImageview.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}
