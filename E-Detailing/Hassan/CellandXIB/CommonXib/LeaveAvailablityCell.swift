//
//  LeaveAvailablityCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 17/07/23.
//

import Foundation
import UIKit
import UICircularProgressRing


class LeaveAvailablityCell : UICollectionViewCell{
    
    @IBOutlet weak var lblLeaveTypeName: UILabel!
    
    @IBOutlet weak var viewChart: UICircularProgressRing!
    
    @IBOutlet var viewLeavetype: UIView!
    
    
    @IBOutlet weak var viewLop: UIView!
    
    @IBOutlet weak var lblLop: UILabel!
    
    @IBOutlet var wholeLbl: UILabel!
    @IBOutlet var partLbl: UILabel!
    @IBOutlet var slashLbl: UILabel!
    
    var leaveStatus : LeaveStatus! {
        didSet {

                switch leaveStatus.leaveCode {
                case "247":
                    //cl
                    viewLeavetype.isHidden = false
                    viewLop.isHidden = true
                    self.lblLeaveTypeName.text = "Casual Leave"
                    self.viewChart.startAngle = -90.0
                    self.viewChart.isClockwise = true
                    self.viewChart.font = UIFont(name: "Satoshi-Medium", size: 14)!
                    self.viewChart.fontColor = .appWhiteColor
                    self.viewChart.outerRingColor = .appLightTextColor.withAlphaComponent(0.2)
                    
                    self.viewChart.innerRingColor = .appGreen
                    self.viewChart.innerRingWidth = 3.0
                    self.viewChart.style = .bordered(width: 0.0, color: .appLightTextColor.withAlphaComponent(0.2))
                    self.viewChart.outerRingWidth = 3.0
                    
                
                     
                    if let wholeString = leaveStatus.eligibility, let whole = NumberFormatter().number(from: wholeString) ,
                       let partString = leaveStatus.taken, let part = NumberFormatter().number(from: partString) {
                        
                        let percentage = (Double(truncating: part) / (Double(truncating: whole))) * 100
                        print(percentage) // This will give you the percentage
                        self.viewChart.startProgress(to: CGFloat(truncating: percentage as NSNumber), duration: 0)
                        partLbl.text = partString
                        slashLbl.text = "/"
                        wholeLbl.text = wholeString
                    } else {
                        print("Invalid input")
                    }
                    
                    self.viewChart.maxValue = CGFloat(truncating: 100)
           
                   
                case "248":
                    //pl
                    viewLeavetype.isHidden = false
                    viewLop.isHidden = true
                    self.lblLeaveTypeName.text = "Paid Leave"
                    self.viewChart.startAngle = -90.0
                    self.viewChart.isClockwise = true
                    self.viewChart.font = UIFont(name: "Satoshi-Medium", size: 14)!
                    self.viewChart.fontColor = .appWhiteColor
                    self.viewChart.outerRingColor = .appLightTextColor.withAlphaComponent(0.2)
                    
                    self.viewChart.innerRingColor = .appBlue
                    self.viewChart.innerRingWidth = 3.0
                    self.viewChart.style = .bordered(width: 0.0, color: .appLightTextColor.withAlphaComponent(0.2))
                    self.viewChart.outerRingWidth =  3.0
                    
             
                     
                    if let wholeString = leaveStatus.eligibility, let whole = NumberFormatter().number(from: wholeString) ,
                       let partString = leaveStatus.taken, let part = NumberFormatter().number(from: partString) {
                        
                        let percentage = (Double(truncating: part) / (Double(truncating: whole))) * 100
                        print(percentage) // This will give you the percentage
                        self.viewChart.startProgress(to: CGFloat(truncating: percentage as NSNumber), duration: 0)
                        partLbl.text = partString
                        slashLbl.text = "/"
                        wholeLbl.text = wholeString
                    } else {
                        print("Invalid input")
                    }
                    
                    self.viewChart.maxValue = CGFloat(truncating: 100)
        
                case "249":
                    //sl
                    viewLeavetype.isHidden = false
                    viewLop.isHidden = true
                    self.lblLeaveTypeName.text = "Sick Leave"
             
                    self.viewChart.startAngle = -90.0
                    self.viewChart.isClockwise = true
                    self.viewChart.font = UIFont(name: "Satoshi-Medium", size: 14)!
                    self.viewChart.fontColor = .appWhiteColor
                    self.viewChart.outerRingColor = .appLightTextColor.withAlphaComponent(0.2)
                    
                    self.viewChart.innerRingColor = .appLightPink
                    self.viewChart.innerRingWidth = 3.0
                    self.viewChart.style = .bordered(width: 0.0, color: .appLightTextColor.withAlphaComponent(0.2))
                    self.viewChart.outerRingWidth =  3.0
                    
                  
                     
                    if let wholeString = leaveStatus.eligibility, let whole = NumberFormatter().number(from: wholeString) ,
                       let partString = leaveStatus.taken, let part = NumberFormatter().number(from: partString) {
                        
                        let percentage = (Double(truncating: part) / (Double(truncating: whole))) * 100
                        print(percentage) // This will give you the percentage
                        self.viewChart.startProgress(to: CGFloat(truncating: percentage as NSNumber), duration: 0)
                        partLbl.text = partString
                        slashLbl.text = "/"
                        wholeLbl.text = wholeString
                    } else {
                        print("Invalid input")
                    }
                    
                    self.viewChart.maxValue = CGFloat(truncating: 100)
            
                case "250":
                    //LOP
                    viewLeavetype.isHidden = true
                    viewLop.isHidden = false
                    lblLop.text = leaveStatus.taken
                    self.lblLeaveTypeName.text = "LOP days"
                default:
                 print("Yet to implement")
                }
            
            
            

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblLeaveTypeName.setFont(font: .medium(size: .BODY))
        lblLeaveTypeName.textColor = .appLightTextColor
        lblLop.setFont(font: .bold(size: .HEADER))
        lblLop.textColor = .appTextColor
        
        
        partLbl.setFont(font: .bold(size: .HEADER))
        partLbl.textColor = .appTextColor
        
        wholeLbl.setFont(font: .medium(size: .BODY))
        wholeLbl.textColor = .appLightTextColor
        
        slashLbl.setFont(font: .medium(size: .BODY))
        slashLbl.textColor = .appLightTextColor
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
