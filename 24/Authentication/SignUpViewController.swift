//
//  SignUpViewController.swift
//  24
//
//  Created by sri on 04/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var signInLabel: UILabel!
    
    var errorTitle: String!
    var errorDescription: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityView.isHidden = true
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
//        keyboardView()
        attributedText()
        labelTapGesture()
    }
    
    func keyboardView(){
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func signUpViewAllignment(){
        titleLabel.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        descLabel.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        emailTextField.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        rePasswordTextField.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        usernameTextField.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        signUpBtnOutlet.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        
    }
    
    func attributedText(){
        
        let normalString = "I already have an account. Login"
        let attributedText = NSMutableAttributedString(string: normalString)
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 15)!], range: getRangeOfSubString(subString: "I already have an account.", fromString: normalString))
        
        self.signInLabel.attributedText = attributedText
        
        let normalDescString = "To create an account                                         use your phone no. or email."
        let attributedDescText = NSMutableAttributedString(string: normalDescString)
        attributedDescText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 18)!], range: getRangeOfSubString(subString: "phone no.", fromString: normalDescString))
        attributedDescText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 18)!], range: getRangeOfSubString(subString: "email.", fromString: normalDescString))
        
        self.descLabel.attributedText = attributedDescText
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func labelTapGesture(){
        
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveTosignIn))
        signInLabel.isUserInteractionEnabled = true
        signInLabel.addGestureRecognizer(addPhotoTapGestureRecognizer)
    }
    
    @objc func moveTosignIn(){
        self.navigateVc(idName: "SignInViewController")
    }

    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        ActivityIndicator.sharedInstance.startAnimating(view: activityView)
            
            if Connectivity.sharedInstance.isConnectedToNetwork() {
                print("connected")
            }else {
                print("no")
            }
            
            if emailTextField.text != "" && passwordTextField.text != "" && usernameTextField.text != "" && rePasswordTextField.text != "" && rePasswordTextField.text == passwordTextField.text {
                
                let parameters = ["email_id": emailTextField.text!, "password": passwordTextField.text!, "user_name": usernameTextField.text!] as? [String: Any]
                
                Credits.sharedInstance.registerUserRequest(dict: parameters!) { (response, errorMessage) in
                    var isSucess: Bool = response
                    self.errorDescription = errorMessage
                    self.errorTitle = "Error"
                    if isSucess == true{
                        
                        ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                        
                        registerDetails.username = self.usernameTextField.text!
                        registerDetails.password = self.passwordTextField.text!
                        registerDetails.email = self.emailTextField.text!
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PhoneNumberVerificationViewController") as! PhoneNumberVerificationViewController
                        self.present(controller, animated: false, completion: nil)

                    }else{
                        ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                        CustomNotification.sharedInstance.notificationBanner(message: "\(self.errorDescription)", style: .danger)
                        
                        print("error")
                    }
                }
                
            } else{
                errorDescription = "Please fill the details"
                CustomNotification.sharedInstance.notificationBanner(message: "\(self.errorDescription)", style: .danger)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "goToPopUpVc"{
//            let previewVc = segue.destination as! PopUpViewController
//            previewVc.errorMessage = errorDescription
//        }
    }
}

extension SignUpViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        view.frame = CGRect(x: 0, y: -180, width: screenSize.width, height: screenSize.height)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
}

