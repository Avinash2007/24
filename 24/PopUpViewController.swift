//
//  PopUpViewController.swift
//  24
//
//  Created by sri on 05/02/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var okBtnOutlet: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorImageLabel: UIImageView!
    
    var errorMessage: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(errorMessage)
        errorMessageLabel.text = errorMessage
        
    }
    @IBAction func okBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
