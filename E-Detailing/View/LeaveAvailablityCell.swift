//
//  LeaveAvailablityCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 17/07/23.
//

import Foundation
import UIKit
import UICircularProgressRing


class LeaveAvailablityCell : UICollectionViewCell{
    
    @IBOutlet weak var lblLeaveTypeName: UILabel!
    
    @IBOutlet weak var circularView: UICircularProgressRing!
    
    @IBOutlet weak var lblValue: UILabel!
    
    
    @IBOutlet weak var viewLop: UIView!
    
    @IBOutlet weak var lblLop: UILabel!
    
    var leaveStatus : LeaveStatus! {
        didSet {
            self.lblLeaveTypeName.text = leaveStatus.leaveTypeCode
            
            self.circularView.startAngle = -90.0
            self.circularView.isClockwise = true
            self.circularView.font = UIFont(name: "Satoshi-Bold", size: 24)!
            self.circularView.fontColor = .white
            self.circularView.outerRingColor = UIColor.lightGray
            
            
            let color = [UIColor(red: CGFloat(241.0/255.0), green: CGFloat(83.0/255.0), blue: CGFloat(110.0/255.0), alpha: CGFloat(0.8)),UIColor(red: CGFloat(61.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(244.0/255.0), alpha: CGFloat(0.8)),UIColor(red: CGFloat(0.0/255.0), green: CGFloat(198.0/255.0), blue: CGFloat(137.0/255.0), alpha: CGFloat(0.8)),UIColor(red: CGFloat(128.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(128.0/255.0), alpha: CGFloat(0.7))].randomElement()
            
            
            self.circularView.innerRingColor = color ?? UIColor.systemPink
            self.circularView.style = .bordered(width: 0.0, color: .black)
            self.circularView.outerRingWidth = 5.0
            
            if let n = NumberFormatter().number(from: leaveStatus.eligibility) {
                self.circularView.maxValue = CGFloat(truncating: n)
            }
            
            if let avail = NumberFormatter().number(from: leaveStatus.available) {
                self.circularView.startProgress(to: CGFloat(truncating: avail), duration: 2)
            }
            
            let textValue = leaveStatus.available + "/" + leaveStatus.eligibility
            self.lblLop.text = leaveStatus.taken
            
            let availLength = leaveStatus.available.count
            
            let eligiLength = leaveStatus.eligibility.count + 1
            
            let text = NSMutableAttributedString(
              string: textValue,
              attributes: [.font: UIFont(name: "Satoshi-Bold", size: 28) as Any])
            text.addAttributes([.font: UIFont(name: "Satoshi-Regular", size: 20) as Any], range: NSMakeRange(availLength,eligiLength))
            self.lblValue.attributedText = text
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


//    private func progressView() {
//
//        [viewCl,viewPl,viewSl].forEach({view in
//
//            view?.startAngle = -90.0
//            view?.isClockwise = true
//            view?.font = UIFont(name: "Satoshi-Bold", size: 24)!
//            view?.fontColor = .blue
//            view?.outerRingWidth = 5.0
//            view?.style = .bordered(width: 0.0, color: .red)
//            view?.innerRingColor = UIColor.random()
//            view?.outerRingColor = UIColor.lightGray // UIColor(rgb: 10855845)
//        })
//
//        viewCl.maxValue = 125
//        viewCl.startProgress(to: 75, duration: 2.0) {
//            // Details...
//        }
//
//        viewPl.maxValue = 10
//        viewPl.startProgress(to: 5, duration: 2.0) {
//            // Details...
//        }
//
//        viewSl.maxValue = 10
//        viewSl.startProgress(to: 8, duration: 2.0) {
//            // Details...
//        }
//
//
//
//    }
