//
//  PhoneNumberVerificationViewController.swift
//  24
//
//  Created by sri on 06/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import CountryList
import NVActivityIndicatorView
import NotificationBannerSwift

class PhoneNumberVerificationViewController: UIViewController, CountryListDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var activityView: UIView!
    
    var countryList = CountryList()
    var countryCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        
        countryList.delegate = self
        
        let countryCodeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCountryCode))
        countryCodeLabel.isUserInteractionEnabled = true
        countryCodeLabel.addGestureRecognizer(countryCodeTapGestureRecognizer)
        
        activityView.isHidden = true
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)

        
    }
    
    @objc func selectCountryCode(){
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func selectedCountry(country: Country) {
        countryCodeLabel.text = "\(country.phoneExtension)"
        countryCode = country.phoneExtension
        registerDetails.countryId = country.countryCode
        print("\(country.flag!) \(country.name!), \(country.countryCode), \(country.phoneExtension)")
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
        activityView.addSubview(activityIndicatorView)

        activityView.isHidden = false
        activityIndicatorView.startAnimating()
        
        if countryCodeLabel.text != "Select Country code" && phoneNumberTextField.text != "" {
            otpRequest()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            controller.phoneNumber = "\(self.phoneNumberTextField.text!)"
            controller.countryCode = "\(self.countryCodeLabel.text!)"
            
            self.present(controller, animated: false, completion: nil)
            self.activityView.isHidden = true
            activityIndicatorView.stopAnimating()
        }else{
            print("error")
            self.activityView.isHidden = true
            activityIndicatorView.stopAnimating()
            self.notificationBanner(message: "Please fill the details.", style: .danger)
            
        }
    }
    
    
    func notificationBanner (message: String, style: BannerStyle){
        let banner = StatusBarNotificationBanner(title: message, style: style)
        banner.show()
    }
    
    func otpRequest(){
        let finalNumber = "\(countryCode!)\(phoneNumberTextField.text!)"
            print(finalNumber)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://control.msg91.com/api/sendotp.php?authkey=205305Am7zWWg45ab3c25e&message=your%20verification%20code%20is%20%23%23OTP%23%23&sender=SENDOTP&mobile=\(finalNumber)")! as URL,
                                         cachePolicy: .useProtocolCachePolicy,
                                         timeoutInterval: 10.0)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                print("sucess")
                
            }
        })
        dataTask.resume()
    }
}

