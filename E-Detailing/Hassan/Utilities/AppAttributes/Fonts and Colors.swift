//
//  Fonts and Colore.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/01/24.
//

import Foundation
import UIKit
class Themes: NSObject {
    static let externalBorderName = "externalBorder"
    static let appGreyColor = UIColor.init(red: 238, green: 238, blue: 238)
    static let appSelectionColor = UIColor.init(red: 40, green: 42, blue: 60).withAlphaComponent(0.1)
    static let appLightTextColor = UIColor.init(red: 40, green: 42, blue: 60).withAlphaComponent(0.65)
    static let appTextColor = UIColor.init(red: 40, green: 42, blue: 60)
    static let calenderMarkerColor = UIColor.init(red: 217, green: 246, blue: 237)

    static let appWhiteColor = UIColor.init(red: 255, green: 255, blue: 255)
    static let appDarkBlueColor = UIColor.init(red: 53, green: 57, blue: 77)
    static let appLightPink  = UIColor.init(red: 241, green: 83, blue: 110)
    
    static let appGreen = UIColor.init(red: 0, green: 198, blue: 137)

     static let appBrown = UIColor.init(red: 109, green: 84, blue: 113) //Activity. TP deviation
    static let appBlue = UIColor.init(red: 61, green: 165, blue: 244)
   
    static let appDeepBlue = UIColor.init(red: 20, green: 89, blue: 119) //rgba(20, 89, 119, 1)
    
    static let appDeepGreen = UIColor.init(red: 7, green: 97, blue: 61) //rgba(7, 97, 69, 0.15)
  
    
    static let appPink = UIColor.init(red: 199, green: 55, blue: 150)//rgba(7, 97, 69, 0.15)


    static let appViolet = UIColor.init(red: 128, green: 90, blue: 175)
    
    
    static let appYellow = UIColor.init(red: 254, green: 185, blue: 26)

static let appLightGrey = UIColor.init(red: 118, green: 139, blue: 160)
    
    static let appDeepBrown = UIColor.init(red: 149, green: 40, blue: 6) //Activity. TP deviation
    
    
}


extension UIColor {
  
    static var appGreyColor = Themes.appGreyColor
    static var appLightTextColor  = Themes.appLightTextColor
    static var appSelectionColor = Themes.appSelectionColor
    static var appTextColor = Themes.appTextColor
    static var appWhiteColor = Themes.appWhiteColor
    static var appLightPink = Themes.appLightPink
    static var calenderMarkerColor = Themes.calenderMarkerColor
    static var appGreen = Themes.appGreen
    static var appBrown = Themes.appBrown
    static var appBlue = Themes.appBlue
    static var appYellow = Themes.appYellow
    static var appViolet = Themes.appViolet
    static var appPink = Themes.appPink
    static var appDeepGreen = Themes.appDeepGreen
    static var appDeepBlue = Themes.appDeepBlue
    static var appLightGrey = Themes.appLightGrey
    static var appDeepBrown = Themes.appDeepBrown

}

extension UIColor {


    //MARK: hex Extention
    public  convenience init(hex : String?) {
        guard let hex = hex else {
            self.init()
            return }

        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension CGFloat {
    static let EXTRALARGE :CGFloat = 52
    static let LARGE :CGFloat = 35
    static let HEADER:CGFloat = 20
    static let SUBHEADER:CGFloat = 16
    static let BODY:CGFloat = 14
    static let SMALL:CGFloat = 12
    static let TINY:CGFloat = 10
}


enum CustomFont {
    case bold(size:CGFloat)
    case light(size:CGFloat)
    case medium(size:CGFloat)
    case regular(size:CGFloat)
    
    var instance:UIFont {
        switch self {
        case .bold(size: let size):
            return UIFont(name: Fonts.SATOSHI_BOLD, size: size)!
        case .light(size: let size):
            return UIFont(name: Fonts.SATOSHI_LIGHT, size: size)!
        case .medium(size: let size):
            return UIFont(name: Fonts.SATOSHI_MEDIUM, size: size)!
        case .regular(size: let size):
            return UIFont(name: Fonts.SATOSHI_REGULAR, size: size)!
        }
    }

}


class Fonts:NSObject{
    static let SATOSHI_BOLD = "Satoshi-Bold"
    static let SATOSHI_LIGHT = "Satoshi-Light"
    static let SATOSHI_MEDIUM = "Satoshi-Medium"
    static let SATOSHI_REGULAR = "Satoshi-Regular"
    
}

