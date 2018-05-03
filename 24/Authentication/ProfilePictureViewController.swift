//
//  ProfilePictureViewController.swift
//  24
//
//  Created by sri on 02/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class ProfilePictureViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadPictureBtnOutlet: UIButton!
    
    @IBOutlet weak var sucessView: UIView!
    @IBOutlet weak var sucessImageView: UIImageView!
    @IBOutlet weak var sucessTitleLabel: UILabel!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tapPictureLabel: UILabel!
    @IBOutlet weak var uploadPictureLabel: UILabel!
    
    var username: String!
    var errorDescription: String!
    var pickedImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = "Hello, \(registerDetails.username)"
        sucessView.isHidden = true
        activityView.isHidden = true
        addPhotoTapGesture()
        uploadPictureLabel.text = "Please Upload your Display Picture"
        uploadPictureLabel.isHidden = false
        tapPictureLabel.text = "Please Upload your Display Picture"
        tapPictureLabel.isHidden = false
        uploadPictureBtnOutlet.setTitle("Upload", for: .normal)
        uploadPictureBtnOutlet.isHidden = false
    }
    
    func addPhotoTapGesture(){
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(addPhotoTapGestureRecognizer)
    }
    
    @objc func addPhoto(){
        print("tapped image")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = image
        pickedImage = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPictureBtnAction(_ sender: Any) {
        ActivityIndicator.sharedInstance.startAnimating(view: activityView)
        if pickedImage != nil{
            let params = ["userid": "\(mydetails!.userId)", "signature": mydetails!.signature] as [String : Any]
//            self.showLoader()
            Credits.sharedInstance.uploadImageRequest(dict: params, image: pickedImage, fileName: randomString(), url: "http://api.my24space.com/v1/update_profile_image", parameterName: "profile_photo", completion: { (isSucess, message) in
//                self.hideLoader()
                if isSucess {
                    ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                    self.sucessView.isHidden = false
                }else {
                    ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                    CustomNotification.sharedInstance.notificationBanner(message: "\(message)", style: .danger)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToPopUpVc"{
//            let previewVc = segue.destination as! PopUpViewController
//            previewVc.errorMessage = errorDescription
//        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        self.navigateVc(idName: "TabBarVC")
    }
    
}
