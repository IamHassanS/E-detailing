//
//  UIStoryboard+Extensions.swift
//  E-Detailing
//
//  Created by SANEFORCE on 02/06/23.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    static var main : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
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
}


extension UIStoryboard {
    
    static var apiconfigNavigationVC:UINavigationController {
        guard let navigationVC = UIStoryboard.main.instantiateViewController(withIdentifier: "ConfigVC") as? UINavigationController else {
            fatalError("ConfigVC couldn't be found in Storyboard file")
        }
        return navigationVC
    }
    
    static var loginVC : LoginVC {
        guard let  loginVc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else{
            fatalError("Login couldn't be found in Storyboard file")
        }
        return loginVc
    }
    
//    static var homeVC : HomeVC {
//        guard let  homeVC = UIStoryboard.main.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else{
//            fatalError("HomeVC couldn't be found in Storyboard file")
//        }
//        return homeVC
//    }
    
    
    static var mainVC : MainVC {
        guard let  mainVC = UIStoryboard.Hassan.instantiateViewController(withIdentifier: "MainVC") as? MainVC else{
            fatalError("MainVC couldn't be found in Storyboard file")
        }
        return mainVC
    }
    
    static var masterSyncVC : MasterSyncVC {
        guard let  masterSyncVC = UIStoryboard.main.instantiateViewController(withIdentifier: "MasterSyncVC") as? MasterSyncVC else{
            fatalError("MasterSyncVC couldn't be found in Storyboard file")
        }
        return masterSyncVC
    }
    
    static var slideDownloadVC : SlideDownloadVC {
        guard let  SlideDownloadVC = UIStoryboard.main.instantiateViewController(withIdentifier: "SlideDownloadVC") as? SlideDownloadVC else{
            fatalError("SlideDownloadVC couldn't be found in Storyboard file")
        }
        return SlideDownloadVC
    }
    
    static var singleSelectionVC : SingleSelectionVC {
        guard let  singleSelectionVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "SingleSelectionVC") as? SingleSelectionVC else{
            fatalError("SingleSelectionVC couldn't be found in Storyboard file")
        }
        return singleSelectionVC
    }
    
    static var calenderVC : FSCalendarVC {
        guard let  calenderVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "FSCalenderVC") as? FSCalendarVC else{
            fatalError("FSCalenderVC couldn't be found in Storyboard file")
        }
        return calenderVC
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
    
//    static var productVC : ProductVC {
//        guard let  productVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "ProductVC") as? ProductVC else{
//            fatalError("ProductVC couldn't be found in Storyboard file")
//        }
//        return productVC
//    }
    
    static var multiSelectionVC : MultiSelectionVC {
        guard let  multiSelectionVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "MultiSelectionVC") as? MultiSelectionVC else{
            fatalError("MultiSelectionVC couldn't be found in Storyboard file")
        }
        return multiSelectionVC
    }
    
    static var singleSelectionRightVC : SingleSelectionRightVC {
        guard let  singleSelectionRightVC = UIStoryboard.activity.instantiateViewController(withIdentifier: "SingleSelectionRightVC") as? SingleSelectionRightVC else{
            fatalError("SingleSelectionRightVC couldn't be found in Storyboard file")
        }
        return singleSelectionRightVC
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


extension String {
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil) -> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = timeZone == nil ? TimeZone(abbreviation: "UTC") : timeZone
        return dateformatter.date(from: self) ?? Date()
    }
}

extension Date{
    func toString(format: String = "hh:mm a",  timeZone: TimeZone? = nil) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone == nil ? TimeZone(abbreviation: "UTC") : timeZone
        return formatter.string(from: self)
    }
}



class ShadowView: UIView {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 0.5 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}


class ShadowButton: UIButton {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}
