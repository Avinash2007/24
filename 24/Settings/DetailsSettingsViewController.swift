//
//  DetailsSettingsViewController.swift
//  24
//
//  Created by sri on 24/01/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class DetailsSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var backBtnOutlet: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var phoneNumberTextField: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickedImage: UIImage!
    var gender = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateView.isHidden = true
        genderPicker.isHidden = true
        datePicker.isHidden = true
        
        getProfile()
        addPhotoTapGesture()
        self.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    
    @IBAction func saveBtnActio(_ sender: Any) {
        
//        if pickedImage != nil {
//
//            let parameters = ["userid": "\(mydetails!.userId)", "signature": mydetails!.signature] as [String : Any]
//
//            Credits.sharedInstance.uploadImageRequest(dict: parameters, image: pickedImage!, fileName: self.randomString(), url: "http://api.my24space.com/v1/update_profile_image", parameterName: "profile_photo", completion: { (isSucess, message) in
//                if isSucess {
//                    print(message)
//                }else {
//                    print(message)
//                }
//            })
//        }else {
//            print("no photo")
//        }
        
        let parameters = ["userid": "\(mydetails!.userId)", "signature": mydetails!.signature, "user_name" : "\(usernameTextField.text!)", "dob" : "\(dateOfBirthLabel.text)", "gender": "\(genderLabel.text)", "country_id": "+91", "user_mobile": "\(phoneNumberTextField.text)"] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/update_profile") { (isSucess, message, data) in
            print("cool1")
            if isSucess {
                print(message)
                print("cool")
                self.getProfile()
                CustomNotification.sharedInstance.notificationBanner(message: "Sucessfully changed.", style: .success)
                self.dismiss(animated: true, completion: nil)
            }else {
                print(message)
                print("cool2")
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addPhotoTapGesture(){
        
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(addPhotoTapGestureRecognizer)
        
        let dateLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(datePickerViewAction))
        dateOfBirthLabel.isUserInteractionEnabled = true
        dateOfBirthLabel.addGestureRecognizer(dateLabelTapGestureRecognizer)
        
        let genderLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(genderPickerViewAction))
        genderLabel.isUserInteractionEnabled = true
        genderLabel.addGestureRecognizer(genderLabelTapGestureRecognizer)
        
        let changePasswordLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePasswordAction))
        changePasswordLabel.isUserInteractionEnabled = true
        changePasswordLabel.addGestureRecognizer(changePasswordLabelTapGestureRecognizer)
    }
    
    @objc func changePasswordAction(){
        
        navigateVc(idName: "ChangePasswordViewController")
        
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
        print("\(image)------------")
        profileImageView.image = image
        pickedImage = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerViewAction(){
        
        dateView.isHidden = false
        datePicker.isHidden = false
        genderPicker.isHidden = true
    }
    
    @objc func genderPickerViewAction(){
        
        dateView.isHidden = false
        datePicker.isHidden = true
        genderPicker.isHidden = false
    }
    
    @IBAction func dateViewChangeBtn(_ sender: Any) {
        dateView.isHidden = true
        datePicker.isHidden = true
        genderPicker.isHidden = true
        
//        datePicker.date
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = gender[row]
    }
    
    
    func getProfile() {
        
        let parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature] as [String: Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/my_profile") { (isSucess, message, data) in
            if isSucess {
                if let details = data["settings"] as? [String: Any] {
                    let data = MyProfileInfo(dict: details)
                    
                    self.usernameTextField.text = data.username
                    self.emailTextFeild.text = data.userEmail
                    if data.userMobileNumber != nil {
                        self.phoneNumberTextField.text = String(describing: data.userMobileNumber!)
                    }else {
                        self.phoneNumberTextField.text = "Not updated"
                    }
                    
                    if data.gender != nil {
                        self.genderLabel.text = data.gender
                    }else {
                        self.genderLabel.text = "Not updated"
                    }
                    
                    if data.dateOfBirth != nil {
                        self.dateOfBirthLabel.text = String(describing: data.dateOfBirth)
                    }else {
                        self.dateOfBirthLabel.text = "Not updated"
                    }
                    
                    let profileUrlString = "http://api.my24space.com/public/uploads/profile/" + "\(data.profilePhoto!)"
                    let profileUrl = profileUrlString.replacingOccurrences(of: " ", with: "%20")
                    let profileImageURL = URL(string: profileUrl)
                    
                    Credits.sharedInstance.getImageRequest(imageUrl: profileImageURL!, completion: { (isSucess, message, image) in
                        self.profileImageView.image = image
                    })
                }
            }else {
                print(message)
            }
        }
    }
}
