//
//  ViewController.swift
//  project24
//
//  Created by sri on 19/07/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var LoginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let viewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
            self.present(viewController , animated: true, completion: nil)
        }
    }

    @IBAction func signInBtn(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.LoginView.frame.origin.y += 185
        }, completion: nil)
    }
    func hi(completionBlock:@escaping (Bool)->Void){
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpPage")
        self.present(viewController, animated: true, completion: nil)
    completionBlock(true)
    }
    @IBOutlet weak var signUpBtn: UIButton!
}

