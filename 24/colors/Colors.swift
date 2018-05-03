//
//  Colors.swift
//  
//
//  Created by sri on 30/09/17.
//
//

import Foundation
import UIKit

struct Colors {
  
//    
//    static let color1 = UIColor(hex: "1A237E")
//    static let color2 = UIColor(hex: "B388FF")
    
    static let color1 = UIColor(hex: "cc2b5e")
    static let color2 = UIColor(hex: "753a88")
    
    static let color3 = UIColor(hex: "17EAD9")
    static let color4 = UIColor(hex: "6078EA")
    
    static let color5 = UIColor(hex: "622774")
    static let color6 = UIColor(hex: "C53364")
    
    static let color7 = UIColor(hex: "7117EA")
    static let color8 = UIColor(hex: "EA6060")
    
    static let color9 = UIColor(hex: "5B247A")
    static let color10 = UIColor(hex: "1BCEDF")
    
    static let color11 = UIColor(hex: "184E68")
    static let color12 = UIColor(hex: "57CA85")
    
    static let color13 = UIColor(hex: "65799B")
    static let color14 = UIColor(hex: "5E2563")
    
    static let color15 = UIColor(hex: "F02FC2")
    static let color16 = UIColor(hex: "6094EA")
    
    //login screen red shade
    static let color17 = UIColor(hex: "f857a6")
    static let color18 = UIColor(hex: "ff5858")

    //18+19
    
    //login screen blue shade()Pinot Noir
    static let color19 = UIColor(hex: "4b6cb7")
    static let color20 = UIColor(hex: "182848")
    
    //047 Fly High
    static let color21 = UIColor(hex: "48c6ef")
    static let color22 = UIColor(hex: "6f86d6")
    
    //073 Love Kiss
    static let color23 = UIColor(hex: "ff0844")
    static let color24 = UIColor(hex: "ffb199")
    
    //097 Amour Amour
    static let color25 = UIColor(hex: "f77062")
    static let color26 = UIColor(hex: "fe5196")
    
    //Blue skies good
    static let color27 = UIColor(hex: "56CCF2")
    static let color28 = UIColor(hex: "2F80ED")
    
    //blush
    static let color29 = UIColor(hex: "B24592")
    static let color30 = UIColor(hex: "F15F79")
    
    //transfile good
    static let color31 = UIColor(hex: "16BFFD")
    static let color32 = UIColor(hex: "CB3066")
    
    //cherry
    static let color33 = UIColor(hex: "EB3349")
    static let color34 = UIColor(hex: "F45C43")
    
}



extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
