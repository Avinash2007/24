//
//  OTPViewController.swift
//  24
//
//  Created by sri on 23/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

class OTPViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var activityView: UIView!
    
    var phoneNumber: String?
    var countryCode: String?
    var otp: String?
    var errorDescription: String?
    
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white, padding: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        phoneNumberLabel.text = "We have sent an OTP on your number +\(countryCode!) \(phoneNumber!)"
        
        activityView.isHidden = true
        activityView.frame = CGRect(x: (screenSize.width / 2) - 50, y: (screenSize.height / 2) - 50, width: 100, height: 100)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goPrevious), name: NSNotification.Name(rawValue: "deletePressed"), object: nil)
        
        activityView.addSubview(activityIndicatorView)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf1.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField{
            case tf1 :
                tf2.becomeFirstResponder()
            case tf2 :
                tf3.becomeFirstResponder()
            case tf3 :
                tf4.becomeFirstResponder()
            case tf4 :
                otp = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)"
                tf4.resignFirstResponder()
                verifyOTP()
                
            default:
                break
            }
        }else {
            
        }
    }
    
    func verifyOTP(){
        
        activityView.isHidden = false
        activityIndicatorView.startAnimating()
    
        let request = NSMutableURLRequest(url: NSURL(string: "http://control.msg91.com/api/verifyRequestOTP.php?authkey=205305Am7zWWg45ab3c25e&mobile=\(countryCode!)\(phoneNumber!)&otp=\(otp!)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print(error)
            guard let jsonresponse = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]else{return
            }
            if let type = jsonresponse!["type"] as? String{
                if type == "error"{
                    self.activityIndicatorView.stopAnimating()
//                    self.notificationBanner(message: "Please check OTP.", style: .danger)
                    DispatchQueue.main.async {
                        CustomNotification.sharedInstance.notificationBanner(message: "Please check OTP.", style: .danger)
                        self.activityView.isHidden = true
                        self.tf1.text = ""
                        self.tf2.text = ""
                        self.tf3.text = ""
                        self.tf4.text = ""
                        self.tf1.becomeFirstResponder()
                    }
                }
                else{
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    print("sucess")
                    
                    let parameters = ["userid": "\(mydetails!.userId)", "signature": mydetails!.signature, "country_id": "+\(self.countryCode!)", "user_mobile": "\(self.phoneNumber)"] as [String : Any]
                    
                    AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/update_profile") { (isSucess, message, data) in
                        if isSucess {
                            print(message)
                        }else {
                            print(message)
                        }
                    }
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "ProfilePictureViewController") as! ProfilePictureViewController
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func notificationBanner (message: String, style: BannerStyle){
        let banner = StatusBarNotificationBanner(title: message, style: style)
        banner.show()
    }
    
    @objc func goPrevious() {
        print("goPrevious")
        if tf2.isFirstResponder {
            tf1.becomeFirstResponder()
        } else if tf3.isFirstResponder {
            tf2.becomeFirstResponder()
        } else if tf4.isFirstResponder {
            tf3.becomeFirstResponder()
        }
    }    
    
    @IBAction func resendOTPBtnAction(_ sender: Any) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://control.msg91.com/api/retryotp.php?authkey=205305Am7zWWg45ab3c25e&mobile=\(countryCode!)\(phoneNumber!)")! as URL,
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
                print("Re-sucess")
            }
        })
        dataTask.resume()
    }
}

class DigitField: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deletePressed"), object: nil)
    }
}
