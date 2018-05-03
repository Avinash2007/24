//
//  SignInViewController.swift
//  
//
//  Created by sri on 22/07/17.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Lottie

class SignInViewController: UIViewController {

    @IBOutlet weak var signUpBtnOutlet: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var signinBtnOutlet: UIButton!
    @IBOutlet var forgetPasswordBtnOutlet: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttonShape(button: signinBtnOutlet)
        buttonShape(button: signUpBtnOutlet)

    }
    

    
    func buttonShape(button : UIButton){
        
        button.layer.cornerRadius = 8
        
        let cornerRadius: CGFloat = 8
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = UIBezierPath(
            roundedRect: button.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath
        
        button.layer.mask = maskLayer
        
    }
    
    
    @IBAction func signinBtnAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextfield.text!) { (user, error) in
            if error == nil {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
                self.present(viewController, animated: true, completion: nil)
            }
            else if self.emailTextField.text == ""{
                let alertController = UIAlertController(title: "oops!!!", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
                self.present(viewController, animated: true, completion: nil)
            }
            else if self.passwordTextfield.text == "" {
                let alertController = UIAlertController(title: "oops!!!", message: "Please enter Password", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
