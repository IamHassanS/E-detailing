//
//  MyDayPlanCalenderView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/02/24.
//

import Foundation
import UIKit
import FSCalendar
class MyDayPlanCalenderView: UIView, FSCalendarDelegate, FSCalendarDataSource ,FSCalendarDelegateAppearance {
    
 let tourPlanCalander = FSCalendar()
    var selectedDate: Date?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupUI()
        //self.addCustomView()
      
        toLoadCalenderData()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // lineChartView.frame = self.bounds
        tourPlanCalander.frame = self.bounds
        self.addSubview(tourPlanCalander)
    }
    
    func toLoadCalenderData() {
      
        self.tourPlanCalander.register(MyDayPlanCalenderCell.self, forCellReuseIdentifier: "MyDayPlanCalenderCell")
        
        tourPlanCalander.scrollEnabled = false
        tourPlanCalander.calendarHeaderView.isHidden = true
        tourPlanCalander.headerHeight = 0 // this makes some extra spacing, but you can try 0 or 1
        //tourPlanCalander.daysContainer.backgroundColor = UIColor.gray
        tourPlanCalander.rowHeight =  tourPlanCalander.height / 5
        tourPlanCalander.layer.borderColor = UIColor.appSelectionColor.cgColor
        tourPlanCalander.calendarWeekdayView.weekdayLabels.forEach { label in
            label.setFont(font: .medium(size: .BODY))
            label.textColor = .appLightTextColor
        }
        tourPlanCalander.layer.borderWidth = 1
        tourPlanCalander.layer.cornerRadius = 5
        tourPlanCalander.clipsToBounds = true
        tourPlanCalander.placeholderType = .none
        tourPlanCalander.calendarWeekdayView.backgroundColor = .clear
        self.tourPlanCalander.scrollDirection = .horizontal
        self.tourPlanCalander.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        tourPlanCalander.adjustsBoundingRectWhenChangingMonths = true
        tourPlanCalander.delegate = self
        tourPlanCalander.dataSource = self
        tourPlanCalander.reloadData()
     //   mainDateLbl.text = toTrimDate(date: tourPlanCalander.currentPage , isForMainLabel: true)

    }
    
    func toTrimDate(date : Date, isForMainLabel: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isForMainLabel == true ? "MMMM yyyy" : "dd"
        return dateFormatter.string(from: date)
    }
}


extension MyDayPlanCalenderView  {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // let borderColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.25))
        let cell = calendar.dequeueReusableCell(withIdentifier: "MyDayPlanCalenderCell", for: date, at: position) as! MyDayPlanCalenderCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
    
      //  let toCompareDate = dateFormatter.string(from: date)
        cell.addedIV.isHidden = true

        
        
        
      
        let currentDate = date  // Replace this with your desired date
        let calendar = Calendar.current
      //  let components = calendar.dateComponents([.weekday], from: currentDate)


        
      //  cell.addedIV.isHidden = isExist || isForHoliday  ? false : true

        cell.customLabel.text = toTrimDate(date: date)
        cell.customLabel.textColor = .appTextColor
        cell.customLabel.setFont(font: .medium(size: .BODY))
        cell.customLabel.textColor = .appTextColor
       // cell.customLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.titleLabel.isHidden = true
        cell.shapeLayer.isHidden = true
    
        cell.layer.borderColor = UIColor.appSelectionColor.cgColor
          cell.layer.borderWidth = 0.5

        
        
        if selectedDate == date {
            cell.contentHolderView.backgroundColor = .appTextColor
            cell.customLabel.textColor = .appWhiteColor
        } else {
            cell.contentHolderView.backgroundColor = .clear
            cell.customLabel.textColor = .appTextColor
        }
        

        cell.addTap { [weak self] in
            guard let welf = self else {return}
            welf.selectedDate = date
        }
        
        return cell
    }
}
