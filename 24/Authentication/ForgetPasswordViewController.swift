//
//  ForgetPasswordViewController.swift
//  24
//
//  Created by sri on 26/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var signInBtnOutlet: UIButton!
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
                view.setGradientBackground(colourOne: Colors.color2, colourTwo: Colors.color1)
        submitBtnOutlet.layer.borderColor = UIColor.white.cgColor
        emailTextField.underlined(selectColor: .white)
        
        
        img(textField: emailTextField, imgStr: "email.png")
        
       // self.hideKeyboardWhenTappedAround()
        self.hideKeyboard()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.allignment()

    }
    
    

//    func img(textField: UITextField, imgStr: String){
//        textField.leftViewMode = UITextFieldViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image = UIImage(named: "\(imgStr)")
//        imageView.image = image
//        textField.leftView = imageView
//        
//    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
    }
    
    @IBAction func signBtn(_ sender: Any) {
    }
    
}

//Functions
extension ForgetPasswordViewController{
    
    
   func allignment(){
        

    imageView.frame = CGRect(x: (self.view.frame.width / 2 ) - 100 , y: 40, width: 200, height: 200)
        forgetPasswordLabel.frame = CGRect(x: 30, y: imageView.center.y + 140, width: screenWidth - 60 , height: 30)
    messageLabel.frame = CGRect(x: 30, y: forgetPasswordLabel.center.y + 30, width: screenWidth - 60 , height: 45)
    emailTextField.frame = CGRect(x: 30, y: messageLabel.center.y + 62, width: screenWidth - 60, height: 30)
    submitBtnOutlet.frame = CGRect(x: 30, y: emailTextField.center.y + 65, width: screenWidth - 60, height: 40)
    signInBtnOutlet.frame =  CGRect(x: (screenWidth / 2) - 25, y: screenHeight - 40, width: 50 , height: 30)
        
        
    }
    
    
}


extension ForgetPasswordViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        
        
        imageView.frame = CGRect(x: (self.view.frame.width / 2 ) - 50 , y: 40, width: 100, height: 100)
        forgetPasswordLabel.frame = CGRect(x: 30, y: imageView.center.y + 60, width: screenWidth - 60 , height: 30)
        messageLabel.frame = CGRect(x: 30, y: forgetPasswordLabel.center.y + 40, width: screenWidth - 60 , height: 45)
        emailTextField.frame = CGRect(x: 30, y: messageLabel.center.y + 62, width: screenWidth - 60, height: 30)
        submitBtnOutlet.frame = CGRect(x: 30, y: emailTextField.center.y + 65, width: screenWidth - 60, height: 40)
        signInBtnOutlet.frame =  CGRect(x: (screenWidth / 2) - 25, y: screenHeight - keyboardHeight - 40 , width: 50 , height: 30)
        
        
        
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        
        allignment()
        
        
    }
}

