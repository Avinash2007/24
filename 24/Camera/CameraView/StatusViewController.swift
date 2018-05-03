//
//  StatusViewController.swift
//  24
//
//  Created by sri on 12/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class StatusViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var statusDescriptionTextView: UITextView!
    @IBOutlet weak var postBtnOutlet: UIButton!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var clearBtnOutlet: UIButton!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var errorMessage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*****************StatusViewController*****************")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //statusDescriptionTextView.becomeFirstResponder()
        statusDescriptionTextView.delegate = self
        statusDescriptionTextView.text = "Got something to share? Well share it!"
        statusDescriptionTextView.textColor = UIColor.lightGray
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        if navigationController?.popViewController(animated: true) == nil {
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if statusDescriptionTextView.text == "Got something to share? Well share it!"{
            statusDescriptionTextView.text = ""
            statusDescriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if statusDescriptionTextView.text == "" {
            
            statusDescriptionTextView.text = "Got something to share? Well share it!"
            statusDescriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func postBtnAction(_ sender: Any) {
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
        
        self.activityIndicatorView.addSubview(activityIndicator)
        
        activityIndicatorView.isHidden = false
        statusDescriptionTextView.resignFirstResponder()
        
        activityIndicator.startAnimating()
        
        let postParameters = ["user_id": mydetails!.userId, "signature": mydetails!.signature, "description": statusDescriptionTextView.text!, "web_link": "", "tag_friends": "", "latitude": "", "longitude": "", "post_type": "1", "group_id": "\(postDetails.groupId)"] as? [String: Any]
        
        Post.sharedInstance.createPost(dict: postParameters!) { (response, errorMessage, postId) in
            
            let errorMessage: String = errorMessage
            let postId: Int = postId
            
          let mediaParameters = ["user_id": "\(mydetails!.userId)", "signature": mydetails!.signature, "post_id": String(postId), "album_id":  "\(postDetails.albumId)", "media_type": "4", "media": self.statusDescriptionTextView.text!] as [String : Any]
            if response {
                
                AlamofireRequest.sharedInstance.alamofireRequest(dict: mediaParameters, url: "https://api.my24space.com/v1/add_media", completion: { (isSucess, message, data) in
                    if isSucess {
                        activityIndicator.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.statusDescriptionTextView.text = "Got something to share? Well share it!"
                        self.statusDescriptionTextView.textColor = UIColor.lightGray
                        self.navigateVc(idName: "TabBarVC")
                    }else {
                        activityIndicator.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.errorMessage = "Error"
                        self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
                    }
                })
            }else {
                self.errorMessage = "Something gone wrong"
                self.activityIndicatorView.isHidden = true
                activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
                print("not uploaded")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPopUpVc"{
            let previewVc = segue.destination as! PopUpViewController
            previewVc.errorMessage = errorMessage
        }
    }

    @IBAction func clearBtnAction(_ sender: Any) {
        statusDescriptionTextView.text = ""
    }
}

extension StatusViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        postBtnOutlet.frame = CGRect(x: screenSize.width - 120, y: screenSize.height - (keyboardHeight + 45), width: 100, height: 35)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
       postBtnOutlet.frame = CGRect(x: screenSize.width - 120, y: screenSize.height - 55, width: 100, height: 35)
        
    }
}
