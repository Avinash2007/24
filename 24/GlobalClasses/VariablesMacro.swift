//
//  VariablesMacro.swift
//  MyswaasthERP
//


import Foundation
import UIKit
import MobileCoreServices


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let keyWindow  = UIApplication.shared.keyWindow

let themeColor = #colorLiteral(red: 0.1724793911, green: 0.4061612487, blue: 0.2182481289, alpha: 1)
let boldTextColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
let lightTextColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)

let seperatorColor = #colorLiteral(red: 0.8312992454, green: 0.8314195275, blue: 0.8312730193, alpha: 1)
let popupBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
let notificationColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

let notificationDescColor  = #colorLiteral(red: 0.06274509804, green: 0.5411764706, blue: 0.6941176471, alpha: 1)

let shortTimeFormat = "yyyy-MM-dd"
let longTimeFormat = "yyyy-MM-dd hh:mm:ss"
let longDateFormat = "yyyy-MM-dd hh:mm:ss a"
let TimeFormat = "yyyy-MM-dd hh:mm:ss a"
let widthFactor = SCREEN_WIDTH/320.0
let heightFactor = SCREEN_HEIGHT/580.0

extension String {
    func underline() ->NSAttributedString{
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        var underlineAttributedString = NSMutableAttributedString(string: self, attributes: underlineAttribute)
        underlineAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, underlineAttributedString.length))
        return  underlineAttributedString
    }
    
    func utf8EncodedString()-> String? {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text
    }
}


extension UIButton {
    
    func addLoader() {
        self.isUserInteractionEnabled = false
        let activity = UIActivityIndicatorView.init(frame: self.frame)
        activity.color = .black
        activity.hidesWhenStopped = true
        activity.center = self.center
        activity.startAnimating()
        self.bringSubview(toFront: activity)
        self.addSubview(activity)
    }
    
    func removeLoader() {
        self.isUserInteractionEnabled = true
        for subView in self.subviews {
            if subView.isKind(of: UIActivityIndicatorView.self) {
               let activity = subView as! UIActivityIndicatorView
                activity.stopAnimating()
                activity.removeFromSuperview()
            }
        }
    }
}


