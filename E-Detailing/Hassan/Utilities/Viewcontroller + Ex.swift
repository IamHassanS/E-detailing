//
//  Viewcontroller + Ex.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/02/24.
//
import UIKit
import Foundation

enum XIBs: String {
    case changePasswordView = "ChangePasswordView"
    case homeCheckinView = "HomeCheckinView"
    case homeCheckinDetailsView = "HomeCheckinDetailsView"
    case tpDeviateReasonView = "TPdeviateReasonView"
    case dcrfiltersView = "DCRfiltersView"
    case jfwView = "JfwView"
    case customerCheckinVIew = "CustomerCheckinView"
    case customerCheckoutView = "CustomerCheckoutView"
    var nib: UINib {
        return UINib(nibName: self.rawValue, bundle: nil)
    }
}

extension UIViewController {
     func loadCustomView(nibname: XIBs) -> UIView? {
        // Load the XIB
         let nib = nibname.nib
        if let customView = nib.instantiate(withOwner: nil, options: nil).first as? UIView {
            // Configure your custom view if needed
            return customView
        }

        // Return a default view if loading fails
        return nil
    }
}
