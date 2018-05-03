//
//  SearchViewController.swift
//  24
//
//  Created by sri on 30/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import DTPagerController


class SearchViewController: DTPagerController {

    public let kOffset:CGFloat = 0.120772946859903
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.setGradientBackground(colourOne: Colors.color2, colourTwo: Colors.color1)
        
        let viewController1 = self.storyboard!.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        viewController1.title = "Sign In"
        
        
        let viewController2 = self.storyboard!.instantiateViewController(withIdentifier:"SignUpViewController") as! SignUpViewController
        
        viewController2.title = "Sign up"
        
        
        self.viewControllers =  [viewController1, viewController2]
        
        
        // Change the height of segmented control
        self.preferredSegmentedControlHeight = 80
        
        // Change normal font of each segmented control
        //self.font = UIFont.systemFont(ofSize: 15)
        self.font = UIFont.boldSystemFont(ofSize: 15)
        
        // Change selected font of each segmented control
        self.selectedFont = UIFont.boldSystemFont(ofSize: 15)
        
        // Change normal text color of each segmented control
        self.textColor = UIColor.white
        
        // Change selected text color of each segmented control
        self.selectedTextColor = UIColor.white
        
        // Change scroll indicator height
        self.perferredScrollIndicatorHeight = 1.0
        self.scrollIndicator.backgroundColor = .white
        
        self.pageSegmentedControl.contentHorizontalAlignment = .left
        self.pageSegmentedControl.contentMode = .left
        
        print( 50.0 / self.view.frame.size.width)
        
        
        
        self.pageSegmentedControl.setContentOffset(CGSize(width: -self.view.frame.size.width * kOffset, height:self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 65), forSegmentAt: <#T##Int#>)
        self.pageSegmentedControl.setContentOffset(CGSize(width: -self.view.frame.size.width * kOffset, height:self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 65), forSegmentAt: 1)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        
        let vw = UIView()
        vw.frame = CGRect(x: 30, y: self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 1, width: self.view.frame.size.width - 60, height: 10)
        
        vw.backgroundColor = UIColor.black
        
        self.view.addSubview(vw)
        self.view.sendSubview(toBack: vw)
        self.view.bringSubview(toFront: self.scrollIndicator)
        
    }
    
}


