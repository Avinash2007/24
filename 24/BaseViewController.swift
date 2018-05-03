//
//  BaseViewController.swift
//  24
//
//  Created by Nivedita Chauhan on 19/04/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SystemConfiguration

class BaseViewController: UIViewController {

    lazy var activityVieww:NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), type: .ballClipRotateMultiple, color: .black, padding: 20)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    
    lazy var activityBGView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        view.center = self.view.center
        view.addSubview(activityVieww)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.27059, green: 0.27059, blue: 0.27059, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func hideTabBar() {
      //  appDelegate.homeTabVC?.tabBar.isHidden = true
    }
    
    func showTabBar() {
    //   appDelegate.homeTabVC?.tabBar.isHidden = false
    }

    func showLoader() {
        self.view.addSubview(activityVieww)
    }
    
    func hideLoader() {
        activityVieww.stopAnimating()
        activityVieww.removeFromSuperview()
        activityBGView.removeFromSuperview()
    }
    
    func isOnline()-> Bool{
        let reachablity = Reachability.init(hostname: "http://api.my24space.com/")
        return reachablity?.isReachable ?? false
    }
    
    func popVC() {
        if navigationController?.popViewController(animated: true) == nil{
            dismiss(animated: true, completion: nil)
        }
    }
}
