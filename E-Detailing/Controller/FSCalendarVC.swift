//
//  FSCalendarVC.swift
//  E-Detailing
//
//  Created by SANEFORCE on 18/07/23.
//

import Foundation
import UIKit
import FSCalendar


typealias SelectedDateCallBack = (_ selectedDat : Date) -> Void

class FSCalendarVC : UIViewController {
    
    
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    
    var completion : SelectedDateCallBack?
    
    var minDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.4))
        
        let headerColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(1.0))
        
        let borderColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.25))
        
        self.viewCalendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.viewCalendar.appearance.todayColor = UIColor.clear
        self.viewCalendar.appearance.weekdayTextColor = headerColor
        self.viewCalendar.appearance.headerTitleColor = headerColor
        
        self.viewCalendar.appearance.headerTitleFont = UIFont(name: "Satoshi-Medium", size: 20)
        self.viewCalendar.appearance.weekdayFont = UIFont(name: "Satoshi-Medium", size: 18)
        self.viewCalendar.appearance.subtitleFont = UIFont(name: "Satoshi-Medium", size: 18)
        
        self.viewCalendar.appearance.borderDefaultColor = borderColor
        self.viewCalendar.appearance.borderRadius = 0
        
    //    self.viewCalendar.register(fsCalendarCell.self, forCellReuseIdentifier: "fsCell")
        
    //    self.viewCalendar.appearance.accessibilityFrame.size = CGSize(width: 100, height: 100)
        
        self.viewCalendar.appearance.calendar.visibleCells()
       
    }
    
    func didSelectCompletion (callback : @escaping SelectedDateCallBack) {
        self.completion = callback
    }
}


extension FSCalendarVC : FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "fsCell", for: date, at: position)
//
//        return cell
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateString = date.toString(format: "yyyy-MM-dd")
        print(dateString)
        
        if let completion = self.completion {
            completion(date)
        }
        
        self.dismiss(animated: true)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.minDate ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let color = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.65))
        
        return color
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.viewCalendar.frame.size.height = bounds.height
        self.viewCalendar.frame.size.width = bounds.width
    }
    
    
}



//class fsCalendarCell : FSCalendarCell {
//
//
//    override init!(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init!(coder aDecoder: NSCoder!) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.imageView.contentMode = .scaleAspectFit
//        self.imageView.setWidth(width: 50)
//        self.imageView.setHeight(height: 50)
//        self.imageView.center = CGPoint(x: self.titleLabel.center.x, y: self.titleLabel.center.y + 18)
//        self.contentView.insertSubview(self.imageView, belowSubview: self.titleLabel)
//    }
//
//
//}


//extension UIView {
//    var width:      CGFloat { return self.frame.size.width }
//    var height:     CGFloat { return self.frame.size.height }
//    var size:       CGSize  { return self.frame.size}
//
//    var origin:     CGPoint { return self.frame.origin }
//    var x:          CGFloat { return self.frame.origin.x }
//    var y:          CGFloat { return self.frame.origin.y }
//    var centerX:    CGFloat { return self.center.x }
//    var centerY:    CGFloat { return self.center.y }
//
//    var left:       CGFloat { return self.frame.origin.x }
//    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
//    var top:        CGFloat { return self.frame.origin.y }
//    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
//    var YMax:       CGFloat { return self.y + self.height }
//    var XMax:       CGFloat { return self.x + self.width }
//
//
//    func setX(x:CGFloat) {
//        var frame:CGRect = self.frame
//        frame.origin.x = x
//        self.frame = frame
//    }
//
//    func setY(y:CGFloat) {
//        var frame:CGRect = self.frame
//        frame.origin.y = y
//        self.frame = frame
//    }
//
//    func setWidth(width:CGFloat) {
//        var frame:CGRect = self.frame
//        frame.size.width = width
//        self.frame = frame
//    }
//
//    func setHeight(height:CGFloat) {
//        var frame:CGRect = self.frame
//        frame.size.height = height
//        self.frame = frame
//    }
//
//    func setShadow(){
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 4
//    }
//}
