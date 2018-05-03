//
//  EXViewController.swift
//  24
//
//  Created by sri on 29/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

class EXViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Good Evening! \n Update your status here"
        label.numberOfLines = 0
        
    }

}
