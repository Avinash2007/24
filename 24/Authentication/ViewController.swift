//
//  ViewController.swift
//  24
//
//  Created by sri on 25/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit

var mydetails : myDetails?
struct myDetails : Codable{
    var userId : Int
    var signature : String
     var viewerId: Int 
    
    enum CodingKeys : String,CodingKey {
        case userId = "userId"
        case signature = "signature"
        case viewerId = "viewerId"
    }
}
struct registerDetails{
    static var username: String = ""
    static var email: String = ""
    static var password: String = ""
    static var countryId: String = ""
    static var phoneNumber: Int = 0
    
}

struct postDetails{
    static var groupId: String = ""
    static var albumId: Int = 0
}

struct newsFeedDetails{
    static var momentId: Int = 0
}

struct screenSize{
    static var width = UIScreen.main.bounds.width
    static var height = UIScreen.main.bounds.height
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UITextField{
    
    func underlined(selectColor: UIColor?){
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = selectColor?.cgColor
        //  border.borderColor?.alpha = 0.5
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width - 40, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIButton {
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    func topLine(selectColor: UIColor?){
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = selectColor?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width - 40, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIViewController{
    
    func navigateVc(idName: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: idName)
        self.present(controller, animated: false, completion: nil)
    }
    
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func img(textField: UITextField, imgStr: String){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 30, y: 0, width: 20, height: 20))
        let image = UIImage(named: "\(imgStr)")
        imageView.image = image
        textField.leftView = imageView
        
    }
}
extension UIViewController{
    
    func customActivityIndicatorView() -> UIView{
        
        let activityView = UIView()
        
       // let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
        
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
        activityView.backgroundColor = .black
        
       // activityView.addSubview(activityIndicatorView)
        
        //activityIndicatorView.startAnimating()
        
        return activityView
    }
    
    func navigationView() -> UIView{
        
        let navigationView = UIView()
        let leftBtn = UIButton()
        let rightBtn = UIButton()
        let TitleLabel = UILabel()
        
        navigationView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        rightBtn.frame = CGRect(x: screenSize.width - 50, y: 0, width: 50, height: 50)
        TitleLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        navigationView.backgroundColor = .white

        return navigationView
    }
}

