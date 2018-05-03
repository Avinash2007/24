//
//  TabBarVC.swift
//  24
//
//  Created by Nivedita Chauhan on 18/04/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    lazy var cameraButton:UIButton = {
        let height = self.tabBar.frame.size.height
        let frame = CGRect.init(x: SCREEN_WIDTH/3, y:SCREEN_HEIGHT - height , width: SCREEN_WIDTH/3, height: height)
        let button = UIButton.init(frame: frame)
        button.addTarget(self, action: #selector(clickOnCameraButton), for: .touchUpInside)
        //button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  appDelegate.homeTabVC = self
        keyWindow?.addSubview(cameraButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func clickOnCameraButton() {
        navigateVc(idName: "NormalCameraViewController")
        self.cameraButton.isHidden = true
    }
    
}
