//
//  SettingsTableViewController.swift
//  project24
//
//  Created by sri on 17/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import AVFoundation
import MobileCoreServices

protocol SettingsTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    
    var delegate : SettingsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        navigationItem.title = "Edit Profile"
        
        fetchUser()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
    }

    func selectImage(){
        
        print("tapped")
        
        let actioncontroller = UIAlertController(title: "selectOne", message: "selectone", preferredStyle: UIAlertControllerStyle.actionSheet)
        let photoAction = UIAlertAction(title: "photo", style: UIAlertActionStyle.default) { action -> Void in
            let photo = UIImagePickerController()
            photo.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
            //photo.mediaTypes = ["public.image","public.movie"]
            photo.allowsEditing = true
            photo.delegate = self
            
            self.present(photo, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "camera", style: UIAlertActionStyle.default) { action -> Void in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actioncontroller.addAction(photoAction)
        actioncontroller.addAction(cameraAction)
        actioncontroller.addAction(cancel)
        self.present(actioncontroller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        profileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
    }
    
    func fetchUser() {
    
        FirebaseService.sharedInstance.observeCurrentUser { (user) in
            self.usernameTextfield.text = user.username
            self.emailTextfield.text = user.email
            if let photoUrl = URL(string: user.profileImageUrl!){
                self.profileImage.sd_setImage(with: photoUrl)
            }
        }
    }
    @IBAction func saveBtn(_ sender: Any) {
        if let profileImg = self.profileImage.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
        ProgressHUD.show("Waiting...")
        updateUserInfor(username: usernameTextfield.text!, email: emailTextfield.text!, imageData: imageData, onSuccess: {
            ProgressHUD.showSuccess("Success");
            self.delegate?.updateUserInfo()
        }, onError: { (errorMessage) in
            ProgressHUD.showError(errorMessage)
            })
        }
    }
    
    func updateUserInfor(username: String, email: String,imageData : Data ,onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        
        let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        
        let storageRef = Storage.storage().reference(forURL: "gs://project24-129e6.appspot.com").child("ProfileImages").child(uid!)
      
        currentUser?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
                print(error!.localizedDescription)
            }else {
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                    }
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    
                    self.updateDatabase(username: username, email: email, profileImageUrl: profileImageUrl!, onSuccess: onSuccess, onError: onError)
                }
            }
        })
    }
    
    func updateDatabase(username: String, email: String, profileImageUrl : String,onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        let dict = ["Username" : username, "Email" : email,"profileImageUrl":profileImageUrl]
        let currentUserId = FirebaseService.sharedInstance.currentUserId
    FirebaseService.sharedInstance.firebaseRef.child("Users").child(currentUserId!).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
        })
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        FirebaseService.sharedInstance.logout(onSuccess: { 
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPage")
            self.present(viewController, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
