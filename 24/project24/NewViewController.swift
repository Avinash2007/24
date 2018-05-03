//
//  NewViewController.swift
//  project24
//
//  Created by sri on 29/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    
    @IBOutlet weak var signInOutlet: UIButton!
    @IBOutlet weak var signUpOutlet: UIButton!
    
    @IBOutlet weak var openSignUpView: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    
    @IBOutlet weak var alreadyHaveAnAccount: UILabel!
    @IBOutlet weak var openSignInView: UIButton!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var forgetPasswordSubmitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.openSignUpView.isHidden = true
        self.dontHaveAccountLabel.isHidden = true
        self.openSignInView.isHidden = true
        self.alreadyHaveAnAccount.isHidden = true
        
//        view.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
//        signInOutlet.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
//        signUpOutlet.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
//        loginButtonOutlet.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
//        signupButtonOutlet.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
//        forgetPasswordSubmitButton.setGradientBackground(colourOne: Colors.color20, colourTwo: Colors.color19)
        
        view.setGradientBackground(colourOne: Colors.color29, colourTwo: Colo)
        signInOutlet.setGradientBackground(colourOne: Colors.color29, colourTwo: Colors.color30)
        signUpOutlet.setGradientBackground(colourOne: Colors.color29, colourTwo: Colors.color30)
        loginButtonOutlet.setGradientBackground(colourOne: Colors.color29, colourTwo: Colors.color30)
        signupButtonOutlet.setGradientBackground(colourOne: Colors.color29, colourTwo: Colors.color30)
        forgetPasswordSubmitButton.setGradientBackground(colourOne: Colors.color29, colourTwo: Colors.color30)

    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    @IBAction func mainViewSignUpaction(_ sender: Any) {
        print("mainViewSignUpaction")
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.mainView.center.y += 155
                        self.loginView.center.y -= 272
                        self.signupView.center.y += 175
                        self.loginView.alpha = 1.0
                        self.signupView.alpha = 0.5
        },
                       completion: {_ in
                        self.openSignUpView.isHidden = false
                        self.dontHaveAccountLabel.isHidden = false
                        self.openSignInView.isHidden = true
                       // self.openSignInView.isEnabled = false
                        //self.openSignUpView.isEnabled = true
                        self.alreadyHaveAnAccount.isHidden = true
        })
    }

    @IBAction func mainViewSignInaction(_ sender: Any) {
        print("mainViewSignInaction")
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.mainView.center.y += 155
                        self.signupView.center.y -= 272
                        self.loginView.center.y += 155
                        self.signupView.alpha = 1.0
                        self.loginView.alpha = 0.75
        },
                       completion: {_ in
                        
                        self.openSignUpView.isHidden = true
                      //  self.openSignUpView.isEnabled = false
                        //self.openSignInView.isEnabled = true
                        self.dontHaveAccountLabel.isHidden = true
                        self.openSignInView.isHidden = false
                        self.alreadyHaveAnAccount.isHidden = false

                        
        })
    }
    
    @IBAction func openSignupViewBtnAction(_ sender: Any) {
        print("openSignupViewBtnAction")
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.loginView.center.y += 427
                        self.signupView.center.y -= 449
                        self.signupView.alpha = 1.0
                        self.loginView.alpha = 0.75

        },
                       completion: {_ in
                        self.openSignUpView.isHidden = true
                       // self.openSignUpView.isEnabled = false
                        //self.openSignInView.isEnabled = true
                        self.dontHaveAccountLabel.isHidden = true
                        self.openSignInView.isHidden = false
                        self.alreadyHaveAnAccount.isHidden = false
        })
    }

    @IBAction func openSigninViewBtnAction(_ sender: Any) {
        print("openSigninViewBtnAction")
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.loginView.center.y -= 427
                        //
                        self.signupView.center.y += 449
                        self.signupView.alpha = 0.5
                        self.loginView.alpha = 1.0

        },
                       completion: {_ in
                        self.openSignUpView.isHidden = false
                        self.dontHaveAccountLabel.isHidden = false
                        //self.openSignInView.isEnabled = true
                        //self.openSignUpView.isEnabled = true
                        self.openSignInView.isHidden = true
                        self.alreadyHaveAnAccount.isHidden = true
        })
        
    }
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.loginView.center.y += 407
                        self.openSignUpView.isHidden = true
                        self.dontHaveAccountLabel.isHidden = true
                        self.forgetPasswordView.center.x -= 365
                        
        },
                       completion: {_ in

                        

                        self.loginView.alpha = 0.75
                        
        })
    }
    
    @IBAction func forgetPasswordSubmitBtnAction(_ sender: Any) {
        
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        
                        self.loginView.center.y -= 427
                        self.forgetPasswordView.center.x += 365
                        
        },
                       completion: {_ in
                        
                        
                        self.openSignUpView.isHidden = false
                        self.dontHaveAccountLabel.isHidden = false
                        self.loginView.alpha = 1.0
                        
        })
        

        
    }
    
    
}
