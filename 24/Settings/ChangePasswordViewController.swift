//
//  ChangePasswordViewController.swift
//  24
//
//  Created by srisai devineni on 3/20/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func updatePasswordBtnAction(_ sender: Any) {
        if newPasswordTextField.text == reEnterPasswordTextField.text {
            let parameters = ["userId": mydetails!.userId, "signature": mydetails!.signature, "old_pswd": currentPasswordTextField.text!, "new_pswd": reEnterPasswordTextField.text!] as [String : Any]
            
            AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/change_password", completion: { (isSucess, message, data) in
                if isSucess {
                    self.dismiss(animated: true, completion: nil)
                    print(message)
                }else {
                 print(message)
                }
            })
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
