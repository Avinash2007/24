//
//  SearchViewController.swift
//  24
//
//  Created by sri on 29/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import DTPagerController


class SearchViewController: DTPagerController {

    public let kOffset:CGFloat = 0.120772946859903
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  view.setGradientBackground(colourOne: Colors.color2, colourTwo: Colors.color1)
        
        let viewController1 = self.storyboard!.instantiateViewController(withIdentifier: "NearByUsersViewController") as! NearByUsersViewController
        
        viewController1.title = "NearByUsers"
        
        
        let viewController2 = self.storyboard!.instantiateViewController(withIdentifier:"SuggestedUsersViewController") as! SuggestedUsersViewController
        
        viewController2.title = "SuggestedUsers"
        
        
        let viewController3 = self.storyboard!.instantiateViewController(withIdentifier:"NearByPostsViewController") as! NearByPostsViewController
        
        viewController3.title = "NearByPosts"
        
        
        self.viewControllers =  [viewController1, viewController2, viewController3]
        
        
        // Change the height of segmented control
        self.preferredSegmentedControlHeight = 80
        
        // Change normal font of each segmented control
        //self.font = UIFont.systemFont(ofSize: 15)
        self.font = UIFont.boldSystemFont(ofSize: 15)
        
        // Change selected font of each segmented control
        self.selectedFont = UIFont.boldSystemFont(ofSize: 15)
        
        // Change normal text color of each segmented control
        self.textColor = UIColor.black
        
        // Change selected text color of each segmented control
        self.selectedTextColor = UIColor.black
        
        // Change scroll indicator height
        self.perferredScrollIndicatorHeight = 1.0
        self.scrollIndicator.backgroundColor = .white
        
        self.pageSegmentedControl.contentHorizontalAlignment = .left
        self.pageSegmentedControl.contentMode = .left
        
        print( 50.0 / self.view.frame.size.width)
        
        
        
        self.pageSegmentedControl.setContentOffset(CGSize(width: 75, height:self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 65), forSegmentAt: 0)
        self.pageSegmentedControl.setContentOffset(CGSize(width: 75, height:self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 65), forSegmentAt: 1)
        self.pageSegmentedControl.setContentOffset(CGSize(width: 75, height:self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 65), forSegmentAt: 2)
        
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        
        let vw = UIView()
        vw.frame = CGRect(x: 30, y: self.scrollIndicator.frame.size.height + self.scrollIndicator.frame.origin.y - 1, width: 75, height: 10)
        
        vw.backgroundColor = UIColor.black
        
        self.view.addSubview(vw)
        self.view.sendSubview(toBack: vw)
        self.view.bringSubview(toFront: self.scrollIndicator)
        
    }
    
}


