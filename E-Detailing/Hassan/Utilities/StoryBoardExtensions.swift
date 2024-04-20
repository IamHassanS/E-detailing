//
//  StoryBoardExtensions.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/11/23.
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
//
