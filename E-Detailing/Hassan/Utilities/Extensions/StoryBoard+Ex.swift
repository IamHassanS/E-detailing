//
//  StoryBoardExtensions.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/01/24.
//

import Foundation
import UIKit

extension UIViewController: ReusableView { }

extension UIStoryboard {
    
    static var Main : UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var Hassan : UIStoryboard{
        return UIStoryboard(name: "Hassan", bundle: nil)
    }
    
    static var activity : UIStoryboard {
        return UIStoryboard(name: "Activity", bundle: nil)
    }
    static var sideMenu : UIStoryboard {
        return UIStoryboard(name: "SideMenu", bundle: nil)
    }
    static var Tagging : UIStoryboard {
        return UIStoryboard(name: "Tagging", bundle: nil)
    }
    
    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }

    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
    
}

//MARK:- Extensions
protocol ReusableView: AnyObject {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
  
}

extension UIStoryboard {
    
    static var apiconfigNavigationVC:UINavigationController {
        guard let navigationVC = UIStoryboard.Main.instantiateViewController(withIdentifier: "ConfigVC") as? UINavigationController else {
            fatalError("ConfigVC couldn't be found in Storyboard file")
        }
        return navigationVC
    }
    

    
    static var mainVC : MainVC {
        guard let  mainVC = UIStoryboard.Hassan.instantiateViewController(withIdentifier: "MainVC") as? MainVC else{
            fatalError("MainVC couldn't be found in Storyboard file")
        }
        return mainVC
    }
    

    static var callVC : CallVC {
        guard let  callVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "CallVC") as? CallVC else{
            fatalError("CallVC couldn't be found in Storyboard file")
        }
        return callVC
    }
    
    static var preCallVC : PreCallVC {
        guard let  preCallVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "PreCallVC") as? PreCallVC else{
            fatalError("PreCallVC couldn't be found in Storyboard file")
        }
        return preCallVC
    }
    
    

    static var leaveVC : LeaveApplicationVC {
        guard let  leaveVC = UIStoryboard.sideMenu.instantiateViewController(withIdentifier: "LeaveApplicationVC") as? LeaveApplicationVC else{
            fatalError("LeaveApplicationVC couldn't be found in Storyboard file")
        }
        return leaveVC
    }
    
    static var nearMeVC : NearMeVC {
        guard let  nearMeVC = UIStoryboard.Tagging.instantiateViewController(withIdentifier: "NearMe") as? NearMeVC else{
            fatalError("nearMeVC couldn't be found in Storyboard file")
        }
        return nearMeVC
    }
    
    static var taggingListVC : TaggingListVC {
        guard let  taggingListVC = UIStoryboard.Tagging.instantiateViewController(withIdentifier: "TaggingListVC") as? TaggingListVC else{
            fatalError("TaggingListVC couldn't be found in Storyboard file")
        }
        return taggingListVC
    }
    
    static var tagVC : TagVC {
        guard let  tagVC = UIStoryboard.Tagging.instantiateViewController(withIdentifier: "TagVC") as? TagVC else{
            fatalError("TagVC couldn't be found in Storyboard file")
        }
        return tagVC
    }
    
    static var tagViewVC : TagViewVC {
        guard let  tagViewVC = UIStoryboard.Tagging.instantiateViewController(withIdentifier: "TagViewVC") as? TagViewVC else{
            fatalError("TagViewVC couldn't be found in Storyboard file")
        }
        return tagViewVC
    }
    
}
