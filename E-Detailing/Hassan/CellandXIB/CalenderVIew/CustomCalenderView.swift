//
//  CustomCalenderView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/07/23.
//

import Foundation
import UIKit
import FSCalendar

protocol CustomCalenderViewDelegate: AnyObject {
    func didSelectDate(selectedDate : Date, isforFrom: Bool)
}
//typealias SelectedDateCallBack = (_ selectedDat : Date) -> Void

class CustomCalenderView : UIView {
    
    @IBOutlet var viewCalendar: FSCalendar!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var dateInfoLbl: UILabel!
    var isFromReportsFilter: Bool = false
    @IBAction func didTapPrevBtn(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }
    
    @IBAction func didTapCalNextBtn(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
    }
    var completion : CustomCalenderViewDelegate?
  
    var selectedFromDate: Date?
    var selectedToDate: Date?
    var isForFrom: Bool = false
    var isPastDaysAllowed: Bool = false
    var isFromReports :Bool = false
    var today: Date = Date()
    
  
    var currentPage: Date?
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1


        if moveUp {
            
            if let nextMonth = calendar.date(byAdding: .month, value: 1 , to: self.currentPage ?? today) {
                print("Next Month:", nextMonth)
                self.currentPage = nextMonth
                if !isFromReportsFilter {
                    if today == self.currentPage {
                        toDisableNextPrevBtn(enableprevBtn: isFromReports ? true : false, enablenextBtn: true)
                    } else {
                        toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
                    }
                }
            }
 
        } else if !moveUp{

            
            if let previousMonth = calendar.date(byAdding: .month, value: -1 , to:  self.currentPage ?? self.today) {
                print("Previous Month:", previousMonth)
                self.currentPage = previousMonth
                if !isFromReportsFilter {
                    if today == self.currentPage {
                        toDisableNextPrevBtn(enableprevBtn:  isFromReports ? true : false, enablenextBtn: true)
                    } else {
                        toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
                    }
                }

            }
            



        }
        
        self.viewCalendar.setCurrentPage(self.currentPage!, animated: true)
        //  monthWiseSeperationofSessions(self.currentPage ?? Date())
    }
    
    func toDisableNextPrevBtn(enableprevBtn: Bool, enablenextBtn: Bool) {
        
        if enableprevBtn && enablenextBtn {
            prevBtn.alpha = 1
            prevBtn.isUserInteractionEnabled = true
            
            btnNext.alpha = 1
            btnNext.isUserInteractionEnabled = true
        } else  if enableprevBtn {
            prevBtn.alpha = 1
            prevBtn.isUserInteractionEnabled = true
            
            btnNext.alpha = 0.3
            btnNext.isUserInteractionEnabled = false
            
        } else if enablenextBtn {
            prevBtn.alpha = 0.3
            prevBtn.isUserInteractionEnabled = false
            
            btnNext.alpha = 1
            btnNext.isUserInteractionEnabled = true
        }
        
        
    }
    
    func setupUI(isPastDaysAllowed: Bool) {
        
        self.layer.cornerRadius = 5
        dateInfoLbl.text = toTrimDate(date: today , isForMainLabel: true)
 
        toDisableNextPrevBtn(enableprevBtn:  self.isFromReports ? false : true, enablenextBtn: true)
        self.isPastDaysAllowed = isPastDaysAllowed
        //toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
        self.viewCalendar.register(MyDayPlanCalenderCell.self, forCellReuseIdentifier: "MyDayPlanCalenderCell")
            
        viewCalendar.scrollEnabled = false
        viewCalendar.calendarHeaderView.isHidden = true
        viewCalendar.headerHeight = 0 // this makes some extra spacing, but you can try 0 or 1
            //tourPlanCalander.daysContainer.backgroundColor = UIColor.gray
        viewCalendar.rowHeight =  viewCalendar.height / 5
        viewCalendar.layer.borderColor = UIColor.appSelectionColor.cgColor
            //  tourPlanCalander.calendarWeekdayView.weekdayLabels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        viewCalendar.calendarWeekdayView.weekdayLabels.forEach { label in
                label.setFont(font: .medium(size: .BODY))
                label.textColor = .appLightTextColor
            }

        viewCalendar.placeholderType = .none
        viewCalendar.calendarWeekdayView.backgroundColor = .clear
            self.viewCalendar.scrollDirection = .horizontal
            self.viewCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        viewCalendar.adjustsBoundingRectWhenChangingMonths = true
        
        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        viewCalendar.reloadData()
    }
    


}


extension CustomCalenderView : FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    func toTrimDate(date : Date, isForMainLabel: Bool = false) -> String {
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isForMainLabel == true ? "MMMM yyyy" : "d"
        return dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // let borderColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.25))
        let cell = calendar.dequeueReusableCell(withIdentifier: "MyDayPlanCalenderCell", for: date, at: position) as! MyDayPlanCalenderCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        cell.addedIV.backgroundColor = .clear
        //  let toCompareDate = dateFormatter.string(from: date)
        cell.addedIV.isHidden = false
        cell.customLabel.text = toTrimDate(date: date)
        cell.customLabel.textColor = .appTextColor
        
        
        cell.contentHolderView.backgroundColor = .appWhiteColor
        
        if let selectedFromDate = self.selectedFromDate, let selectedToDate = self.selectedToDate {
              if date >= selectedFromDate && date <= selectedToDate {
                  cell.contentHolderView.backgroundColor = .appTextColor
                  cell.customLabel.textColor = .appWhiteColor
                  
              }
          } else {
              if let selectedFromDate = self.selectedFromDate {
                  if Calendar.current.isDate(selectedFromDate, inSameDayAs: date) {
                      cell.contentHolderView.backgroundColor = .appTextColor
                      cell.customLabel.textColor = .appWhiteColor
                  }
              }
              
              if let selectedToDate = self.selectedToDate {
                  if Calendar.current.isDate(selectedToDate, inSameDayAs: date) {
                      cell.contentHolderView.backgroundColor = .appTextColor
                      cell.customLabel.textColor = .appWhiteColor
                  }
              }
          }
        if !self.isPastDaysAllowed {
            if date <= today {
                cell.customLabel.textColor = .appLightTextColor
            }
        }

      
        cell.customLabel.setFont(font: .medium(size: .BODY))
        // cell.customLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.titleLabel.isHidden = true
        cell.shapeLayer.isHidden = true
        
        cell.layer.borderColor = UIColor.appSelectionColor.cgColor
        cell.layer.borderWidth = 0.5

        
        cell.addTap {
            if !self.isPastDaysAllowed  {
                if date <= self.today {
                    self.toCreateToast("Leave can be applied only for future dates!")
                    return
                }
            }
            if self.isForFrom {
                self.selectedFromDate = date
            } else {
                self.selectedToDate = date
            }
            
            
            self.completion?.didSelectDate(selectedDate: date, isforFrom: self.isForFrom)
            
            
            
            
        }
        
        return cell
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print(calendar.currentPage)
        dateInfoLbl.text = toTrimDate(date: calendar.currentPage , isForMainLabel: true)
    
    }
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return self.minDate ?? Date()
//    }
    

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        guard let selectedFromDate = selectedFromDate, let selectedToDate = selectedToDate else {
            return nil
        }

        if date >= selectedFromDate && date <= selectedToDate {
            return .appTextColor
        }

        return nil
    }
    
    
}

