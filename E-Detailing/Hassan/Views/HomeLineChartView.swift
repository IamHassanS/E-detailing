//
//  HomeLineChartView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 04/01/24.
//

import Foundation
import UIKit
import Charts


class CustomValueFormatter:  IndexAxisValueFormatter {

    func numberOfDaysInMonth(for date: Date) -> Int? {
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return nil
    }


    var dateFormatter: DateFormatter
    var date: [Date]
    var valueArr : [Int]
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        date = [Date]()
        valueArr = [Int]()
        super.init()
    }


    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // Convert the value to a Date if needed
        guard let axis = axis else {
            return ""
        }

        // Get the entries (values) for the labels
        let entries = axis.entries

        // Find the index of the current value in the entries array
        if let currentIndex = entries.firstIndex(of: value) {
            if currentIndex % 2 == 0 {
                return "01st - 15th"
            } else {
                let count = numberOfDaysInMonth(for: date[currentIndex / 2])
                return "16th - \(count!)th"
                
            }

        }
      return ""

        }



}

protocol HomeLineChartViewDelegate: AnyObject {
    func didSetValues(values: [String], valueStr: String)
        
    
}


class HomeLineChartView: UIView, ChartViewDelegate {
    
    var viewController : UIViewController?
    let lineChartView = LineChartView()
    var values: [ChartDataEntry] = []
    var date = [Date]()
    var allListArr = [HomeData]()
    var dataSourceArr = [HomeData]()
    
    var  totalCalls : Int = 0
    var averageCalls: Int = 0
    var yRangeMax: Int = 0
    var yRangeMin: Int = 0
    var passesAvgCall : Int = 0
    weak var delegate: HomeLineChartViewDelegate?
    var monthDataArray = [MonthData]()
    var callsCount: [[Int]] = [[], [], [], [], [], []]
    var eacSectorCounrArr: [[Int]] = [[], [], [], [], [], []]
    var avgeacSectorCounrArr: [[Int]] = [[], [], [], [], [], []]
    var dayNumbersArray: [[Int]] = [[]]
    var avgdayNumbersArray: [[Int]] = [[]]
    var dcrCount : DcrCount!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupUI()
        // self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChartView.frame = self.bounds
        
        
    }
    
    func setupUI(_ dataSourceArr : [HomeData], avgCalls : Int) {
        
        if !dataSourceArr.isEmpty {
            self.addSubview(lineChartView)
            passesAvgCall = avgCalls
            self.dataSourceArr = dataSourceArr
            setupLineChart()
            
        } else {
            self.addSubview(lineChartView)
            setupLineChart()
            
            let cutterntMnthNoandDate = self.togetCurrentMonthNoDate()
             
            let (_, sampleCurrentMonthDate) = cutterntMnthNoandDate
             
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            var toDisplayDateString = ""
            
            toDisplayDateString = dateFormatter.string(from: sampleCurrentMonthDate)
            
            
            delegate?.didSetValues(values: [toDisplayDateString], valueStr: toDisplayDateString)
        }
        
        
    }
    
    func separateDatesByMonth(_ dates: [Date], in timeZone: TimeZone = TimeZone(identifier: "IST")!) -> [Int: [Date]] {
        var result: [Int: [Date]] = [:]
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone // Set the calendar's time zone
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            result[month, default: []].append(date)
        }
        
        return result
    }
    
    //    func separateDatesByMonth(_ dates: [Date]) -> [Int: [Date]] {
    //        var result: [Int: [Date]] = [:]
    //
    //        let calendar = Calendar.current
    //
    //        for date in dates {
    //            let month = calendar.component(.month, from: date)
    //
    //            if result[month] == nil {
    //                result[month] = [date]
    //            } else {
    //                // Use a Set to track unique dates for each month
    //                var uniqueDates = Set(result[month]!)
    //                uniqueDates.insert(date)
    //
    //                // Convert the Set back to an array and update the result
    //                result[month] = Array(uniqueDates)
    //            }
    //        }
    //
    //        return result
    //    }
    
    func filterDatesInRange(_ dates: [Date]) -> [Date] {
        let calendar = Calendar.current
        
        return dates.filter { date in
            let day = calendar.component(.day, from: date)
            
            if day >= 1 && day <= 15 {
                // Date is in the range 1st to 15th
                return true
            } else {
                // Check if the date is in the range 16th to the end of the month
                guard let lastDayOfMonth = calendar.range(of: .day, in: .month, for: date)?.upperBound else {
                    return false
                }
                return day >= 16 && day <= lastDayOfMonth
            }
        }
    }
    

    
    struct MonthData {
        let monthNumber: Int
        let dates: [Date]
    }
    
    
    func toCalculateAvgDate() {
        self.allListArr =  self.dataSourceArr.filter { aHomeData in
            aHomeData.fw_Indicator == "F"
            //&&  aHomeData.custType == "0"
        }
        
        var avgdates = [Date]()
        
        self.allListArr.forEach { aHomeData in
            avgdates.append(aHomeData.dcr_dt?.toConVertStringToDate() ?? Date())
        }
        
    
        
        
        let avgdatesFilteredByMonth = separateDatesByMonth(avgdates)
        
        
        
        var avgmonthAvgDataArray: [MonthData] = avgdatesFilteredByMonth.map { (monthNumber, dates) in
            return MonthData(monthNumber: monthNumber, dates: dates)
        }
        var targetMonthNumbers = [Int]()
        
        monthDataArray.forEach { aMonthData in
            targetMonthNumbers.append(aMonthData.monthNumber)
        }
        
       // Replace with the desired month numbers

         avgmonthAvgDataArray = avgmonthAvgDataArray.filter { targetMonthNumbers.contains($0.monthNumber) }
        
        
        
        avgmonthAvgDataArray.sort { (lhs, rhs) in
            if lhs.monthNumber == 1 {
                return false // January comes first
            } else if rhs.monthNumber == 1 {
                return true // January comes before other months
            } else {
                return lhs.monthNumber < rhs.monthNumber
            }
        }
        
        
        // Extract day numbers from dates array for each MonthData
        avgdayNumbersArray = avgmonthAvgDataArray.map { monthData in
            return monthData.dates.map { day in
                let components = Calendar.current.dateComponents([.day], from: day)
                return components.day ?? 0
            }
        }
        
        avgdayNumbersArray.enumerated().forEach { dayNumbersIndex, dayNumbers in
            var modifiedDayNumbers: [Int] = []
            
            switch dayNumbersIndex {
            case 0:
                // Filter days in the range 0 to 15
                var daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                daysInRange0to15 = Array(Set(daysInRange0to15))
                
                if !daysInRange0to15.isEmpty {
                    
                  
                    avgeacSectorCounrArr[0].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                    
                 
                    modifiedDayNumbers.append(15)
                    
                 
                } else {
                
                    avgeacSectorCounrArr[0].insert(contentsOf: [], at: 0)
                 
                 
                }
                
                // Filter days in the range 16 to 31
                var daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                daysInRange16to31 = Array(Set(daysInRange16to31))
                if !daysInRange16to31.isEmpty {
                 
                    avgeacSectorCounrArr[1].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                   
                 
                } else {
                 
               
                    avgeacSectorCounrArr[1].insert(contentsOf: [], at: 0)
                 
                }
             
            case 1:
                // Filter days in the range 0 to 15
                var daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                daysInRange0to15 = Array(Set(daysInRange0to15))
                if !daysInRange0to15.isEmpty {
                 
                   
                    avgeacSectorCounrArr[2].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                  
                    
                } else {
                    
                   
                  
                    avgeacSectorCounrArr[2].insert(contentsOf: [], at: 0)
           
                }
                
                // Filter days in the range 16 to 31
                var daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                daysInRange16to31 = Array(Set(daysInRange16to31))
                if !daysInRange16to31.isEmpty {
                
                    avgeacSectorCounrArr[3].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                   
                } else {
                 
                  
                    avgeacSectorCounrArr[3].insert(contentsOf: [], at: 0)
                    
                }
              
                
            case 2:
                // Filter days in the range 0 to 15
                var daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                daysInRange0to15 = Array(Set(daysInRange0to15))
                if !daysInRange0to15.isEmpty {
                
                    avgeacSectorCounrArr[4].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                 
                } else {
                 
                
                    avgeacSectorCounrArr[4].insert(contentsOf: [], at: 0)
                  
                }
                
                // Filter days in the range 16 to 31
                var daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                daysInRange16to31 = Array(Set(daysInRange16to31))
                if !daysInRange16to31.isEmpty {
                  
                
                    avgeacSectorCounrArr[5].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                    
                } else {
              
                 
                    avgeacSectorCounrArr[5].insert(contentsOf: [], at: 0)
                   
                }
             
            default:
                print("default")
            }
            
            
            
            // Add the modified array to the result
          //  averageDayNumbersArray.append(modifiedDayNumbers)
        }
        
        dump(avgeacSectorCounrArr)
    }
    
    func toSetDataSource() {
        
      

        
        let  fwArr =  dataSourceArr.filter { aHomeData in
            aHomeData.fw_Indicator == "F"
        }
        
        var dates = [Date]()
        
        fwArr.forEach { aHomeData in
            dates.append(aHomeData.dcr_dt?.toConVertStringToDate() ?? Date())
        }
        
        let datesFilteredByMonth = separateDatesByMonth(dates)
        
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonthNumber = calendar.component(.month, from: currentDate)
        var sampleCurrentMonthDate = Date()
        var isMonthAdded : Bool = false
        print("Current Month Number: \(currentMonthNumber)")
        
        
        if let sampleDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: currentMonthNumber, day: 1)) {
            print("Sample Date for the Current Month: \(sampleDate)")
            sampleCurrentMonthDate = sampleDate
        } else {
            print("Error creating sample date.")
        }
        
        
         monthDataArray = datesFilteredByMonth.map { (monthNumber, dates) in
            return MonthData(monthNumber: monthNumber, dates: dates)
        }
        
        
        if monthDataArray.contains(where: { $0.monthNumber == currentMonthNumber }) == false || monthDataArray.isEmpty {
            // If not, add it to monthDataArray
            isMonthAdded = true
            let newMonthData = MonthData(monthNumber: currentMonthNumber, dates: [sampleCurrentMonthDate])
            monthDataArray.append(newMonthData)
        }

        
        
        // Sort the monthDataArray based on monthNumber
        monthDataArray.sort { (lhs, rhs) in
            if lhs.monthNumber == 1 {
                return false // January comes first
            } else if rhs.monthNumber == 1 {
                return true // January comes before other months
            } else {
                return lhs.monthNumber < rhs.monthNumber
            }
        }
        
        // Extract day numbers from dates array for each MonthData
        dayNumbersArray = monthDataArray.map { monthData in
            return monthData.dates.map { day in
                let components = Calendar.current.dateComponents([.day], from: day)
                return components.day ?? 0
            }
        }
        
        let addedDaycomponent = calendar.component(.day, from: sampleCurrentMonthDate)
        
        var addedIndex: Int = 0
        
        for (monthIndex, monthDayNumbers) in dayNumbersArray.enumerated() {
            if let dayIndex = monthDayNumbers.firstIndex(of: addedDaycomponent) {
                // Found the day number in the current month, monthIndex is the month number
                //print("Day \(dayNumber) found in Month \(monthIndex + 1) at index \(dayIndex)")
                addedIndex = monthIndex
            }
        }
        //to take out samples dates
        // Use a Set to keep track of unique month numbers
        var uniqueMonths = Set<Int>()
        
        // Iterate over the array and add month numbers to the set
        for monthData in monthDataArray {
            uniqueMonths.insert(monthData.monthNumber)
        }
        
        // Create an array of Date objects for each unique month
        var uniqueMonthsDates: [Date] = []
        
        for uniqueMonth in uniqueMonths {
            if let sampleDate = monthDataArray.first(where: { $0.monthNumber == uniqueMonth })?.dates.first {
                uniqueMonthsDates.append(sampleDate)
            }
        }
        
        uniqueMonthsDates = uniqueMonthsDates.sorted { $0 < $1 }
        
        self.date = uniqueMonthsDates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        var monthStr : [String] = []
        
        date.forEach { aDate in
            monthStr.append(dateFormatter.string(from: aDate))
        }
        
        var dateMonthStr : [String] = []
        
        dateFormatter.dateFormat = "MMMM yyyy"
        
        date.forEach { aDate in
            dateMonthStr.append(dateFormatter.string(from: aDate))
        }
        
        var toDisplayDateString = ""
        
        dateMonthStr.enumerated().forEach { aDateIndex, dDatevalue in
            switch aDateIndex{
            case 0:
                toDisplayDateString = dDatevalue
            case 1:
                toDisplayDateString = "\(dateMonthStr[0]) - \(dateMonthStr[1])"
            case 2:
                toDisplayDateString = "\(dateMonthStr[0]) - \(dateMonthStr[2])"
            default:
                toDisplayDateString = ""
            }
        }
        
        delegate?.didSetValues(values: monthStr, valueStr: toDisplayDateString)
        
        var dayCountArr = [Int]()
        
        date.forEach { dateElement in
            let count = numberOfDaysInMonth(for: dateElement)
            dayCountArr.append(count ?? 0)
        }
        
        
        
       
        
        
        var averageDayNumbersArray: [[Int]] = []
        
        
        dayNumbersArray.enumerated().forEach { dayNumbersIndex, dayNumbers in
            var modifiedDayNumbers: [Int] = []
            
            switch dayNumbersIndex {
            case 0:
                if isMonthAdded && addedIndex == 0 {
                   // modifiedDayNumbers.append(22)
                    callsCount[0].insert(contentsOf: [], at: 0)
                    eacSectorCounrArr[0].insert(contentsOf: [], at: 0)
                    
                    
                    
                    if date.count == 1 {
                     //   modifiedDayNumbers.append(15)
                        modifiedDayNumbers.append(22)
                    }
                    else if date.count == 2 {
                        modifiedDayNumbers.append(31)
                    } else if date.count == 3 {
                        modifiedDayNumbers.append(33)
                    }
                    callsCount[1].insert(contentsOf: [], at: 0)
                    eacSectorCounrArr[1].insert(contentsOf: [], at: 0)
                } else {
                    // Filter days in the range 0 to 15
                    let daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                    if !daysInRange0to15.isEmpty {
                        
                        callsCount[0].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        eacSectorCounrArr[0].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        
                        // callsCount.append(daysInRange0to15.count)
                        if date.count == 1 {
                            modifiedDayNumbers.append(19)
                        } else {
                            modifiedDayNumbers.append(22)
                        }
                     
                        
                        //daysInRange0to15.first ?? 0
                    } else {
                        callsCount[0].insert(contentsOf: [], at: 0)
                        eacSectorCounrArr[0].insert(contentsOf: [], at: 0)
                        // callsCount.append(0)
                        if date.count == 1 {
                            modifiedDayNumbers.append(19)
                        } else {
                            modifiedDayNumbers.append(22)
                        }
                    }
                    
                    // Filter days in the range 16 to 31
                    let daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                    if !daysInRange16to31.isEmpty {
                        callsCount[1].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        eacSectorCounrArr[1].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        //  callsCount.append(daysInRange16to31.count)
                        
                        if date.count == 1 {
                            modifiedDayNumbers.append(26)
                        }
                        
                       else if date.count == 2 {
                            modifiedDayNumbers.append(31)
                        } else {
                            modifiedDayNumbers.append(33)
                        }
                    } else {
                        if date.count == 1 {
                            modifiedDayNumbers.append(26)
                        }
                        
                       else if date.count == 2 {
                            modifiedDayNumbers.append(31)
                        } else {
                            modifiedDayNumbers.append(33)
                        }
                       
                        callsCount[1].insert(contentsOf: [], at: 0)
                        eacSectorCounrArr[1].insert(contentsOf: [], at: 0)
                        // callsCount.append(0)
                    }
                }
                

                // callsCount.append(daysInRange0to15.count + daysInRange16to31.count)
            case 1:
              
                if isMonthAdded && addedIndex == 1 {
                    if date.count == 1 {
                        
                    }
                    
                    else if date.count == 2 {
                        modifiedDayNumbers.append(43)
                    } else {
                        modifiedDayNumbers.append(45)
                    }
                   
                    callsCount[2].insert(contentsOf: [], at: 0)
                    eacSectorCounrArr[2].insert(contentsOf: [], at: 0)

                    if date.count == 1 {
                        
                    } else
                    if date.count == 2 {
                        modifiedDayNumbers.append(55)
                    } else {
                        modifiedDayNumbers.append(57)
                    }
                    
                    callsCount[3].insert(contentsOf: [], at: 0)
                    eacSectorCounrArr[3].insert(contentsOf: [], at: 0)
                } else {
                    // Filter days in the range 0 to 15
                    let daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                    if !daysInRange0to15.isEmpty {
                        callsCount[2].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        //callsCount.append(daysInRange0to15.count)
                        eacSectorCounrArr[2].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        if date.count == 2 {
                            modifiedDayNumbers.append(43)
                        } else {
                            modifiedDayNumbers.append(45)
                        }
                        
                    } else {
                        
                        if date.count == 2 {
                            modifiedDayNumbers.append(43)
                        } else {
                            modifiedDayNumbers.append(45)
                        }
                        callsCount[2].insert(contentsOf: [], at: 0)
                        eacSectorCounrArr[2].insert(contentsOf: [], at: 0)
                        //  callsCount.append(0)
                    }
                    
                    // Filter days in the range 16 to 31
                    let daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                    if !daysInRange16to31.isEmpty {
                        //  callsCount.append(daysInRange16to31.count)
                        callsCount[3].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        eacSectorCounrArr[3].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        if date.count == 2 {
                            modifiedDayNumbers.append(55)
                        } else {
                            modifiedDayNumbers.append(57)
                        }
                    } else {
                        if date.count == 2 {
                            modifiedDayNumbers.append(55)
                        } else {
                            modifiedDayNumbers.append(57)
                        }
                        callsCount[3].insert(contentsOf: [], at: 0)
                        eacSectorCounrArr[3].insert(contentsOf: [], at: 0)
                        //callsCount.append(0)
                    }
                }

                //  callsCount.append(daysInRange16to31.count + daysInRange0to15.count)
                
            case 2:
                
                if isMonthAdded && addedIndex == 2 {
                    modifiedDayNumbers.append(70)
                    callsCount[4].insert(contentsOf: [], at: 0)
                    eacSectorCounrArr[4].insert(contentsOf: [], at: 0)

                    modifiedDayNumbers.append(85)
                    //callsCount.append(0)
                    eacSectorCounrArr[5].insert(contentsOf: [], at: 0)
                    callsCount[5].insert(contentsOf: [], at: 0)
                } else {
                    // Filter days in the range 0 to 15
                    let daysInRange0to15 = dayNumbers.filter { $0 >= 0 && $0 <= 15 }
                    if !daysInRange0to15.isEmpty {
                        // callsCount.append(daysInRange0to15.count)
                        callsCount[4].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        eacSectorCounrArr[4].insert(contentsOf: daysInRange0to15.sorted(by: <), at: 0)
                        modifiedDayNumbers.append(70)
                    } else {
                        modifiedDayNumbers.append(70)
                        callsCount[4].insert(contentsOf: [], at: 0)
                        eacSectorCounrArr[4].insert(contentsOf: [], at: 0)
                        // callsCount.append(0)
                    }
                    
                    // Filter days in the range 16 to 31
                    let daysInRange16to31 = dayNumbers.filter { $0 >= 16 && $0 <= 31 }
                    if !daysInRange16to31.isEmpty {
                        //callsCount.append(daysInRange16to31.count)
                        callsCount[dayNumbersIndex].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        eacSectorCounrArr[5].insert(contentsOf: daysInRange16to31.sorted(by: <), at: 0)
                        modifiedDayNumbers.append(85)
                    } else {
                        modifiedDayNumbers.append(85)
                        //callsCount.append(0)
                        eacSectorCounrArr[5].insert(contentsOf: [], at: 0)
                        callsCount[5].insert(contentsOf: [], at: 0)
                    }
                }
            default:
                print("default")
            }
            
            
            
            // Add the modified array to the result
            averageDayNumbersArray.append(modifiedDayNumbers)
        }
        
        
        _ = dayNumbersArray
        dayNumbersArray = averageDayNumbersArray
        
        
        
        
        
        let counts: [Int] =  eacSectorCounrArr.map({ innerArray in
            return innerArray.count
        })
        var aMonthValus = [ChartDataEntry]()
        var count : Int = 0
        dayNumbersArray.enumerated().forEach { aMonthDaysIndex, aMonthDays in
            
            switch aMonthDaysIndex {
            case 0:
                var entries1 = [ChartDataEntry]()
                
                dayNumbersArray[aMonthDaysIndex].enumerated().forEach {aDaynumberIndex, aDaynumber in
                    
                    let aEntry = ChartDataEntry(x: Double(aDaynumber), y: Double(counts[count]))
                    count = count + 1
                    //Double(modifiedDayNumbers[aMonthDaysIndex].count)
                    entries1.append(aEntry)
                }
                aMonthValus.append(contentsOf: entries1)
            case 1:
                var entries2 = [ChartDataEntry]()
                dayNumbersArray[aMonthDaysIndex].enumerated().forEach {aDaynumberIndex, aDaynumber in
                    let aEntry = ChartDataEntry(x: Double(aDaynumber), y: Double(counts[count]))
                    count = count + 1
                    entries2.append(aEntry)
                }
                aMonthValus.append(contentsOf: entries2)
            case 2:
                var entries3 = [ChartDataEntry]()
                dayNumbersArray[aMonthDaysIndex].enumerated().forEach {aDaynumberIndex, aDaynumber in
                    let aEntry = ChartDataEntry(x: Double(aDaynumber), y: Double(counts[count]))
                    count = count + 1
                    entries3.append(aEntry)
                }
                aMonthValus.append(contentsOf: entries3)
            default:
                print("Default")
            }
            
        }
        
        
        let flattenedArray: [Int] = callsCount.compactMap { $0.count }
        
        if let maxValue = flattenedArray.max(by: { $0 < $1 }) {
            print("The highest element is: \(maxValue)")
            self.yRangeMax = maxValue
        } else {
            print("The array is empty.")
        }
        if let minValue = flattenedArray.max(by: { $0 > $1 }) {
            print("The highest element is: \(minValue)")
            self.yRangeMin = minValue
        } else {
            print("The array is empty.")
        }
        
        self.values = aMonthValus
        
        toCalculateAvgDate()
    }
    
    func setupLineChart() {
        toSetDataSource()
        
        toAddCustomXaxis()
        // toAddCustomXaxis()
        
        lineChartView.delegate = self
        lineChartView.legend.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        // Sample data
        lineChartView.dragXEnabled = false
        lineChartView.dragYEnabled = false
        
        
        // Set the number of labels
        
        // Customize X-axis
        let xAxis = lineChartView.xAxis
        xAxis.setLabelCount(date.count * 2 + 1, force: true)
        
        switch dayNumbersArray.count {
        case 1:
            xAxis.axisMinimum = 15
            xAxis.axisMaximum = 30
        case 2:
            xAxis.axisMinimum = 15
            xAxis.axisMaximum = 60
        case 3:
            xAxis.axisMinimum = 15
            xAxis.axisMaximum = 90
        default:
            xAxis.axisMinimum = 15
            xAxis.axisMaximum = 90
        }
        
        
        xAxis.labelPosition = .bottom
        xAxis.granularityEnabled = true
        lineChartView.autoScaleMinMaxEnabled = false
        xAxis.wordWrapEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
        let xValuesNumberFormatter = CustomValueFormatter()
        xValuesNumberFormatter.date = date
        
        
        
        
        xAxis.valueFormatter = xValuesNumberFormatter
        
        
        lineChartView.xAxis.yOffset = 40
        // Customize the font
        xAxis.labelFont = UIFont(name: "Satoshi-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        // Customize Y-axis
        // Access the y-axis of your line chart view
        let yAxis = lineChartView.leftAxis // You can use `rightAxis` if needed
        
        let subyRange = yRangeMax
      //  let minimumPercentage: Double = 0.2 // 20% of the range
        
       // let minimumValue = Double(subyRange) * minimumPercentage
        
            yAxis.axisMinimum = 0
         
        if xAxis.axisMinimum == 15 && xAxis.axisMaximum == 30  {
            yAxis.axisMaximum = 100
        } else {
            yAxis.axisMaximum =  Double(yRangeMax) * 1.5
        }
          
        
        

            yAxis.labelCount = 5
        
        
        
        
        yAxis.labelFont = UIFont(name: "Satoshi-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        let dataSet = LineChartDataSet(entries: values, label: "")
        let data = LineChartData(dataSet: dataSet)
        dataSet.setCircleColor(.appTextColor)
        dataSet.drawValuesEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.circleHoleColor = .appTextColor
        dataSet.circleRadius = 5
        dataSet.colors = [NSUIColor.appTextColor]
        // Customize other properties of the data set if needed
        dataSet.lineWidth = 1.0  // Set the width of the line
        
        
        
        lineChartView.data = data
        
        
        //to hide x , y indicator axis - labels
        yAxis.drawLabelsEnabled = true
        xAxis.drawLabelsEnabled = true
        
        
        //to hide x , y indicator axis - lines
        yAxis.drawAxisLineEnabled = false
        xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.enabled = false
        
        //to hide x , y indicator axis - grid lines
        yAxis.drawGridLinesEnabled = true
        xAxis.drawGridLinesEnabled = false
        yAxis.gridLineWidth = 1
        lineChartView.gridBackgroundColor = .appSelectionColor
        
        // Configure the grid lines to be dotted
        yAxis.gridLineDashLengths = [4, 4]  // Adjust the lengths as needed
        yAxis.gridLineDashPhase = 0  // Adjust the phase if needed
        //   yAxis.axisLineColor = .appSelectionColor
        yAxis.gridColor = .appGreyColor
        
        
        
        lineChartView.drawBordersEnabled = false
        lineChartView.drawMarkers = false
        lineChartView.drawGridBackgroundEnabled = false
        
        // Apply the changes
        lineChartView.notifyDataSetChanged()
       // lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0, easingOption: .easeInOutCubic)
        
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print("chartValueSelected : x = \(highlight.x) y = \(highlight.y)")
        //        var set1 = LineChartDataSet()
        //        set1 = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        //        set1.setCircleColor(NSUIColor.appGreen)
        //        set1.circleHoleColor = .appWhiteColor
        
        print(highlight.dataIndex)
        
        let index = values.firstIndex(where: {$0.x == highlight.x}) ?? 0  // search index
        
        let counts: [Int] =  eacSectorCounrArr.map({ innerArray in
            return innerArray.count
        })
        
        
        let avgcounts: [Int] =  avgeacSectorCounrArr.map({ innerArray in
            return innerArray.count
        })
        
        
        
        if avgcounts[index] == 0 {
            self.totalCalls = counts[index]
            self.averageCalls = 0
        } else {
            self.totalCalls = counts[index]
            //Int(passesAvgCall / Int(highlight.y))
            self.averageCalls =  counts[index] / avgcounts[index]
        }
        
        let selectedChartDataEntry = [values[index]]
        
        let selecteddataSet = LineChartDataSet(entries: selectedChartDataEntry, label: "")
        selecteddataSet.drawValuesEnabled = false
        selecteddataSet.drawVerticalHighlightIndicatorEnabled = false
        selecteddataSet.drawHorizontalHighlightIndicatorEnabled = false
      //  let color = self.dcrCount.color
        selecteddataSet.setCircleColor(dcrCount.color)
        selecteddataSet.circleHoleColor =  .appTextColor
        selecteddataSet.circleRadius = 10
        selecteddataSet.colors = [NSUIColor.appTextColor]
        // let selecteddata = LineChartData(dataSet: selecteddataSet)
        
        //  values.remove(at: index)
        let exsistingdataSet = LineChartDataSet(entries: values, label: "")
        exsistingdataSet.drawValuesEnabled = false
        exsistingdataSet.drawVerticalHighlightIndicatorEnabled = false
        exsistingdataSet.drawHorizontalHighlightIndicatorEnabled = false
        exsistingdataSet.setCircleColor(.appTextColor)
        exsistingdataSet.circleHoleColor =  .appTextColor
        exsistingdataSet.circleRadius = 5
        exsistingdataSet.colors = [NSUIColor.appTextColor]
        //  let exsistingselected = LineChartData(dataSet: exsistingdataSet)
        
        //  values.add(selectedChartDataEntry, at: [index])
        
        
        
        // Create a LineChartData object and add datasets to it
        let data = LineChartData(dataSets:[selecteddataSet, exsistingdataSet])
        
        chartView.data = data
        
        chartView.notifyDataSetChanged()
        
        
        
        _ = index
        

        if let lineChartView = chartView as? LineChartView {
            // Get the transformer for the left axis
            let transformer = lineChartView.getTransformer(forAxis: .left)
            
            // Transform the entry coordinates to pixel coordinates
            let point = transformer.pixelForValues(x: entry.x, y: entry.y)
            
            // Create a custom view or overlay at the pixel position
            let customView = UIView(frame: CGRect(x: point.x, y: point.y, width: 5, height: 5))
            customView.backgroundColor = UIColor.clear
            
            lineChartView.subviews.forEach { $0.removeFromSuperview() }
            
            // Add the custom view to the chart view or its superview
            lineChartView.addSubview(customView)
            
            toShoPopup(customView)
        }
        
        
        //  toShoPopup(rectOfSelectedDataPoint)
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
        
    }
    
    
    func toShoPopup(_ view: UIView) {
        
        print("Tapped -->")
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: lineChartView.width / 3.5 , height: lineChartView.height / 3.7), on: view,  pagetype: .HomeGraph)
        //
        // vc.delegate = self
        // vc.selectedIndex = indexPath.row
        vc.color = self.dcrCount.color
        vc.totalCalls = self.totalCalls
        vc.avgCalls = self.averageCalls
        self.viewController?.navigationController?.present(vc, animated: true)
    }
    
    func toAddCustomXaxis() {
        let overlayView = UIView()
        overlayView.backgroundColor = .appSelectionColor // Customize the overlay view's background color
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: -35), // Adjust this constraint based on your layout
            overlayView.leadingAnchor.constraint(equalTo: lineChartView.leadingAnchor, constant: +40),
            overlayView.trailingAnchor.constraint(equalTo: lineChartView.trailingAnchor, constant: -10),
            overlayView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
    }
    
    func numberOfDaysInMonth(for date: Date) -> Int? {
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return nil
    }
}
