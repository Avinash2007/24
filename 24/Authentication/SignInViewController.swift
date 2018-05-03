//
//  SignInViewController.swift
//  24
//
//  Created by sri on 04/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtnOutlet: UIButton!
    @IBOutlet weak var forgetPasswordBtnOutlet: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var registerLabel: UILabel!
    
    var errorTitle: String!
    var errorDescription: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "kondasri98@yahoo.com"
        passwordTextField.text = "111111"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityView.isHidden = true
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
        
//        keyboardView()
     attributedText()
        labelTapGesture()
    }
    
    func attributedText(){
        
        let normalString = "Don't have an account? Create one."
        let attributedText = NSMutableAttributedString(string: normalString)
        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 15)!], range: getRangeOfSubString(subString: "Don't have an account?", fromString: normalString))

        self.registerLabel.attributedText = attributedText
        
        let normalDescString = "Let's Login right now.                                                      Just put your Email & password."
        let attributedDescText = NSMutableAttributedString(string: normalDescString)
        attributedDescText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.purple, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 18)!], range: getRangeOfSubString(subString: "Login", fromString: normalDescString))
        attributedDescText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.purple, NSAttributedStringKey.font: UIFont(name: "QuickSand-Bold", size: 18)!], range: getRangeOfSubString(subString: "Email & password.", fromString: normalDescString))
        
        self.descLabel.attributedText = attributedDescText
        
    }
    
    func labelTapGesture(){
        
        let addPhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveTosignUp))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(addPhotoTapGestureRecognizer)
    }
    
    @objc func moveTosignUp(){
        self.navigateVc(idName: "SignUpViewController")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyboardView(){
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

        @IBAction func signInBtnAction(_ sender: Any) {
            ActivityIndicator.sharedInstance.startAnimating(view: activityView)

            if Connectivity.sharedInstance.isConnectedToNetwork() {
                print("connected")
            }else {
                print("no")
            }
            
            if emailTextField.text != "" && passwordTextField.text != "" {
                
                let parameters = ["username": emailTextField.text!, "password": passwordTextField.text!] as? [String: Any]
                print(parameters)
                Credits.sharedInstance.loginUserRequest(dict: parameters!) { (isSucess, errorMessage) in
                    print(parameters)
                    var isSucess: Bool = isSucess
                    self.errorDescription = errorMessage
                    self.errorTitle = "Error"
                    
                    if isSucess == true {
                        ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)

                    self.navigateVc(idName: "TabBarVC")

                    }else {

                        ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                        CustomNotification.sharedInstance.notificationBanner(message: "\(errorMessage)", style: .danger)
                    }
                }
                
            }else {

                ActivityIndicator.sharedInstance.stopAnimating(view: self.activityView)
                self.errorDescription = "Please Enter Email and Password"
                self.errorTitle = "Error"
                CustomNotification.sharedInstance.notificationBanner(message: "Please Enter Email and Password", style: .danger)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "goToPopUpVc"{
//            let previewVc = segue.destination as! PopUpViewController
//            previewVc.errorMessage = errorDescription
//        }
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    }
}

extension SignInViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)

        view.frame = CGRect(x: 0, y: -keyboardHeight + 20, width: screenSize.width, height: screenSize.height)
    }
    
    @objc func keyboardWillHide(notification: Notification) {

        view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
}
