//
//  ForgetPasswordViewController.swift
//  project24
//
//  Created by sri on 22/07/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var submitBtnOutlet: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonShape(button: submitBtnOutlet)
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
    
    @IBAction func submitBtnAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: self.emailTextfield.text!) { (error) in
            if error == nil {
                let alertController = UIAlertController(title: "Success", message: "Password reset link has been sent to your Email address", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
            else if self.emailTextfield.text == ""{
                let alertController = UIAlertController(title: "oops!!!", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }


        }
    }
    @IBAction func goBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
