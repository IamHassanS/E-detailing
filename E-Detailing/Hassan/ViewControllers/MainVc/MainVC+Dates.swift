//
//  MainVC+Dates.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/06/24.
//

import Foundation
import CoreData
import UIKit
extension MainVC {
    
    func toLoadCalenderData() {

        self.tourPlanCalander.register(MyDayPlanCalenderCell.self, forCellReuseIdentifier: "MyDayPlanCalenderCell")
        
        tourPlanCalander.scrollEnabled = false
        tourPlanCalander.calendarHeaderView.isHidden = true
        tourPlanCalander.headerHeight = 0 // this makes some extra spacing, but you can try 0 or 1
        tourPlanCalander.rowHeight =  tourPlanCalander.height / 5
        tourPlanCalander.layer.borderColor = UIColor.appSelectionColor.cgColor
        tourPlanCalander.calendarWeekdayView.weekdayLabels.forEach { label in
            label.setFont(font: .medium(size: .BODY))
            label.textColor = .appLightTextColor
        }
        tourPlanCalander.placeholderType = .none
        tourPlanCalander.calendarWeekdayView.backgroundColor = .clear
        self.tourPlanCalander.scrollDirection = .horizontal
        self.tourPlanCalander.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        tourPlanCalander.adjustsBoundingRectWhenChangingMonths = true
        
        self.returnWeeklyoffDates()
        
         self.tourPlanCalander.delegate = self
         self.tourPlanCalander.dataSource = self
         self.tourPlanCalander.reloadData()
        
      
            self.tourPlanCalander.setCurrentPage(currentPage, animated: true)
        

    }
    
    func getCurrentFormattedDateString(selecdate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: selecdate)
    }
    func getCurrentMonth(from selectedDate: Date) -> Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedDate)
        return month
    }
    
    
    func getAllDatesInCurrentMonth(date: Date) -> [String] {
        let calendar = Calendar.current
        
        // Get the current date
        let currentDate = date
        
        // Get the date components for the current month
        let currentMonthComponents = calendar.dateComponents([.year, .month], from: currentDate)
        
        // Create the start date of the current month
        guard let startOfMonth = calendar.date(from: currentMonthComponents) else {
            return []
        }
        
        // Get the range of dates for the current month
        guard let rangeOfDates = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        
        // Generate all the dates in the current month
        var allDatesInCurrentMonth: [String] = []
        
        for day in rangeOfDates {
            if let date = calendar.date(bySetting: .day, value: day, of: startOfMonth) {
                allDatesInCurrentMonth.append(date.toString(format: "yyyy-MM-dd"))
            }
        }
        
        return allDatesInCurrentMonth
    }
    
    
    func getNonExistingDatesInCurrentMonth(selectedDate: Date, completion: @escaping(String?) -> ())  {
        
        let calendar = Calendar.current

        _ = calendar.component(.month, from: selectedDate)
        _ = getCurrentMonth(from: selectedDate)
        // Get all dates in the current month
        let allDatesInCurrentMonth = getAllDatesInCurrentMonth(date: self.currentPage ?? Date())
        
        // Filter dates that are not present in homeDataArr
        let nonExistingDates = allDatesInCurrentMonth.filter { date in
            let isDateInHomeDataArr = homeDataArr.contains { dateObject in
                guard let dateObjectDate = dateObject.dcr_dt?.toDate(format: "yyyy-MM-dd") else { return false }
                return calendar.isDate(date.toDate(format: "yyyy-MM-dd"), inSameDayAs: dateObjectDate)
            }
            return !isDateInHomeDataArr
        }

        if selectedDate == nonExistingDates.first?.toDate(format: "yyyy-MM-dd") {
            completion(nil)
        } else {
            completion(nonExistingDates.first)
        }
        
      
        
        
    }
    /// function that merges date with no time into date with current time
    /// - Parameter selectedDate: of type Date
    /// - Returns: Date with current time
    func toMergeDate(selectedDate: Date) -> Date? {
        var yetToReturnDate : Date?
        // Assume selectedDate is a Date object without time component
        let selectedDate = selectedDate
        let systemDate = Date()

        let calendar = Calendar.current

        // Extract the date components from selectedDate
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)

        // Extract the time components from systemDate
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: systemDate)

        // Combine the date and time components
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second

        // Create the new merged date object
        if let mergedDate = calendar.date(from: mergedComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            print("Merged DateTime: \(dateFormatter.string(from: mergedDate))")
            yetToReturnDate = mergedDate
        } else {
            print("Failed to create merged date")
        }
        return yetToReturnDate
    }
    
    func toTrimDate(date : Date, isForMainLabel: Bool = false) -> String {
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isForMainLabel == true ? "MMMM yyyy" : "d"
        return dateFormatter.string(from: date)
    }
    
    func toSetDataSource() {
        var dates = [Date]()
        homeDataArr.forEach { aHomeData in
            dates.append(aHomeData.dcr_dt?.toConVertStringToDate() ?? Date())
        }
    }
    
    func separateDatesByMonth(_ dates: [Date]) -> [Int: [Date]] {
        var result: [Int: [Date]] = [:]
        
        let calendar = Calendar.current
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            
            if result[month] == nil {
                result[month] = [date]
            } else {
                result[month]?.append(date)
            }
        }
        
        return result
    }
    
    func toExtractWorkDetails(date: Date) -> HomeData? {

        let dateString = date.toString(format: "yyyy-MM-dd")
        
        print(dateString)
        
        let filteredDetails =  homeDataArr.filter { $0.dcr_dt ?? "" == dateString}
        
        if !filteredDetails.isEmpty {
            return filteredDetails.filter { $0.fw_Indicator != nil && $0.fw_Indicator != ""  }.first
        } else {
            return nil
        }
        
    }
    
    ///Fetch saved dcr dates from CoreData, convert and append it to `homeDataArr`
    ///
    ///>  if `isToUpdateDate` param is true currently planning date is set from ``DcrDates`` Array fetched from core data
    ///
    ///if below condition satisfieed then it is users current planning date
    ///
    ///```Swift
    /// $0.flag == "0" && $0.tbname == "dcr" && !$0.isDateAdded
    ///```
    ///
    ///if currently planning date exists then app flow continues based up on ``isSequentialDCRenabled`` Variable
    /// - Parameters:
    ///   - isToUpdateDate: Boolean is true App date gets updated
    ///   - completion: empty completion
    
    func togetDCRdates(isToUpdateDate: Bool, completion: @escaping () -> ()) {
        CoreDataManager.shared.fetchDcrDates { [weak self]  savedDcrDates in
            guard let welf = self else {return}
            let notAddedDates = savedDcrDates.filter { $0.isDateAdded == false }
            for dcrDate in notAddedDates {
                CoreDataManager.shared.context.refresh(dcrDate, mergeChanges: true)
                // Now, the data is loaded for all properties
                welf.responseDcrDates.append(dcrDate)
                if !dcrDate.isDateAdded {
                    welf.toAppendDCRtoHomeData(date: dcrDate.date ?? "", flag: dcrDate.flag ?? "", tbName: dcrDate.tbname ?? "", editFlag: dcrDate.editFlag ?? "")
                    print("Sf_Code: \(dcrDate.sfcode ?? ""), Date: \(dcrDate.date ?? ""), Flag: \(dcrDate.flag ?? ""), Tbname: \(dcrDate.tbname ?? "")")
                }
            }
            
         
            if isToUpdateDate {
                let planDates = savedDcrDates.filter { $0.flag == "0" && $0.tbname == "dcr" && !$0.isDateAdded }
                 
                 guard !planDates.isEmpty, let currentDate = planDates.first  else {
                     
                     if isSequentialDCRenabled {
                         welf.setDCRdates {[weak self] sequenceDate  in
                             guard let welf = self else {return}
                             if let sequenceDate = sequenceDate {
                                 let mergedDate = welf.toMergeDate(selectedDate: sequenceDate.rejectedDate) ?? Date()
                                 welf.callDayPLanAPI(date: mergedDate, isFromDCRDates: true) {
                                     welf.toSetParams(date: mergedDate, isfromSyncCall: true) {
                                         welf.refreshUI(date: mergedDate, rejectionReason: sequenceDate.rejectionReason.isEmpty ? nil : sequenceDate.rejectionReason,  SegmentType.workPlan) {
                                             welf.toCreateNewDayStatus()
                                             completion()
                                         }
                                     }
                                 }
                             }
                         }
                     } else {

                         welf.refreshUI(date: welf.selectedToday, welf.segmentType[welf.selectedSegmentsIndex]) {}
                     }

                   completion()
                     return
                 }
                
                 guard let toDayDate = currentDate.date?.toDate(format: "yyyy-MM-dd") else {
                     
                     completion()
                     return
                 }
                
                
                
            let mergedDate = welf.toMergeDate(selectedDate: toDayDate) ?? Date()
                
                welf.callDayPLanAPI(date: mergedDate, isFromDCRDates: true) {
                    welf.toSetParams(date: mergedDate, isfromSyncCall: true) {
                        welf.refreshUI(date: mergedDate, SegmentType.workPlan) {
                            welf.toCreateNewDayStatus()
                            completion()
                        }
                    }
                }
          
            } else {
                completion()
            }

        }
        
    }
    
    
    
    func toAppendDCRtoHomeData(date: String, flag: String, tbName:String, editFlag: String) {
        
            print("<------Day exists----->")
           self.homeDataArr.removeAll { $0.dcr_dt == date }
        

            if let entityDescription = NSEntityDescription.entity(forEntityName: "HomeData", in: context) {
                let entityHomedata = HomeData(entity: entityDescription, insertInto: context)

                entityHomedata.dcr_dt = date
                entityHomedata.fw_Indicator =  (flag == "1"  &&  tbName == "missed") ?  "M" : (flag == "1"  &&  tbName == "leave") ? "LAP" : (flag == "2"  &&  tbName == "dcr") ? "R" : (flag == "3"  &&  tbName == "dcr") ? "RE" : ""
                
                self.homeDataArr.append(entityHomedata)
            }
    }
    
    func returnWeeklyoffDates() {
        
        
        let weeklyoffSetupArr : [Weeklyoff]? = DBManager.shared.getWeeklyOff()

        guard let  weeklyoffSetupArr = weeklyoffSetupArr, !weeklyoffSetupArr.isEmpty else {return}
        var weekoffIndex : [Int] = []
        //(weeklyOff?.holiday_Mode ?? "0") ?? 0
        weeklyoffSetupArr.forEach({ aWeeklyoff in
            weekoffIndex.append(Int(aWeeklyoff.holiday_Mode ?? "0") ?? 0)
        })
        var weekoffDates : [Date] = []
        let monthIndex : [Int] = [-2 , -1, 0]
        weekoffIndex.forEach { weeklyoffIndex in
            weekoffDates.append(contentsOf: getWeekoffDates(forMonths: monthIndex, weekoffday: weeklyoffIndex))
        }
        

        let dcrWeeklyoffDateStrArr: [String] = {
            var dateStrings = [String]()
            
            weekoffDates.forEach { date in
                let modifiedDateStr = toModifyDate(date: date, isForHoliday: true)
                dateStrings.append(modifiedDateStr)
            }
            
            return dateStrings
        }()
        
        var  homeDataWeekoffEntities = [HomeData]()
        
        for aWeeklyoffDate in dcrWeeklyoffDateStrArr {
            if let entityDescription = NSEntityDescription.entity(forEntityName: "HomeData", in: context) {
                let entityHomedata = HomeData(entity: entityDescription, insertInto: context)
                
                
                entityHomedata.anslNo = ""
                entityHomedata.custCode =  String()
                entityHomedata.custName = String()
                entityHomedata.custType = String()
                entityHomedata.dcr_dt = aWeeklyoffDate
                entityHomedata.dcr_flag = String()
                entityHomedata.fw_Indicator = "W"
                entityHomedata.index = Int16()
                entityHomedata.isDataSentToAPI = String()
                entityHomedata.mnth = String()
                entityHomedata.month_name = String()
                entityHomedata.rejectionReason = String()
                entityHomedata.sf_Code = String()
                entityHomedata.town_code = String()
                entityHomedata.town_name = String()
                entityHomedata.trans_SlNo = String()
                entityHomedata.yr = String()
                
                homeDataWeekoffEntities.append(entityHomedata)
            }
        }
        self.homeDataArr.append(contentsOf: homeDataWeekoffEntities)
        
        
        
        
    }
    
    func getWeekoffDates(forMonths months: [Int], weekoffday: Int) -> [Date] {
        let currentDate = getFirstDayOfCurrentMonth() ?? Date()
        let calendar = Calendar.current

        var weeklyoffDays: [Date] = []

        // Map weekoffday: 0 (Sunday) to 1, 1 (Monday) to 2, ..., 6 (Saturday) to 7
        let mappedWeekoffday = (weekoffday == 0) ? 1 : (weekoffday + 1)
        
        for monthOffset in months {
            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
                continue
            }

            let monthRange = calendar.range(of: .day, in: .month, for: targetDate)!

            for day in monthRange.lowerBound..<monthRange.upperBound {
                guard let date = calendar.date(bySetting: .day, value: day, of: targetDate) else {
                    continue
                }
                if calendar.component(.weekday, from: date) == mappedWeekoffday {
                    weeklyoffDays.append(date)
                }
            }
        }

        return weeklyoffDays
    }
    
//    func getWeekoffDates(forMonths months: [Int], weekoffday: Int) -> [Date] {
//        let currentDate = getFirstDayOfCurrentMonth() ?? Date()
//        let calendar = Calendar.current
//        
//        var saturdays: [Date] = []
//        
//        for monthOffset in months {
//            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
//                continue
//            }
//            
//            let monthRange = calendar.range(of: .day, in: .month, for: targetDate)!
//            
//            for day in monthRange.lowerBound..<monthRange.upperBound {
//                guard let date = calendar.date(bySetting: .day, value: day, of: targetDate) else {
//                    continue
//                }
//                
//                if calendar.component(.weekday, from: date)  == (weekoffday == 0 ? 1 : weekoffday) { // Sunday is represented as 1, so Saturday is 7
//                    saturdays.append(date)
//                }
//            }
//        }
//        
//        return saturdays
//    }
    
    func getFirstDayOfCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Get the components (year, month, day) of the current date
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        // Create a new date using the components for the first day of the current month
        if let firstDayOfMonth = calendar.date(from: components) {
            return firstDayOfMonth
        } else {
            return nil
        }
    }
    
    func toModifyDate(date: Date, isForHoliday: Bool? = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (isForHoliday ?? false) ? "yyyy-MM-dd" : "d MMMM yyyy"
        return dateFormatter.string(from: date )
    }
    
    func isFurureDate(date : Date) -> Bool {
        let currentDate = Date() // current date

        // Create another date to compare (for example, one day ahead)
        let futureDate = date

      
            if futureDate.compare(currentDate) == .orderedDescending {
                // futureDate is greater than currentDate
                print("futureDate is greater than currentDate")
            return true
            } else {
                // futureDate is not greater than currentDate
                print("futureDate is not greater than currentDate")
                return false
            }
      
    }
}
