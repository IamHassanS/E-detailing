//
//  DBManager + Tourplan Ex.swift
//  SAN ZEN
//
//  Created by San eforce on 06/10/24.
//
import CoreData
import Foundation

extension DBManager {
    func saveTPtoMasterData(modal: SessionResponseModel, completion: @escaping (Bool) -> Void) {
        var apiArrofSessions = [SessionDetails]()
        apiArrofSessions.append(contentsOf: (modal.current))
        apiArrofSessions.append(contentsOf: (modal.previous))
        apiArrofSessions.append(contentsOf: (modal.next))

        let toutplans = TourPlanArr()
        var allDayPlans = [SessionDetailsArr]()
       
//        if !apiArrofSessions.isEmpty  {
//            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: true)
//        } else {
//            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: false)
//        }
        
        apiArrofSessions.enumerated().forEach { ApisessionDetailsIndex, ApisessionDetails in
            
//            if ApisessionDetails.mnth == "12" && ApisessionDetails.yr == "2023" && ApisessionDetails.dayno == "1" {
//                dump(ApisessionDetails)
//                dump(ApisessionDetails.rejectionReason)
//            }
            
      
            
            let sessiondetArr = SessionDetailsArr()
          
            if ApisessionDetails.rejectionReason != "" {
                dump(ApisessionDetails)
                sessiondetArr.rejectionReason = ApisessionDetails.rejectionReason
               // sessiondetArr.isDataSentToApi = false
                
            } else {
             //   sessiondetArr.isDataSentToApi = true
            }
            sessiondetArr.isDataSentToApi = true
            sessiondetArr.isForWeekoff = ApisessionDetails.fwFlg == "Y" ? true : false
            if ApisessionDetails.tpDt.date.contains("2023-11-02")  {
                print(ApisessionDetails.tpDt.date)
                
            }
           // sessiondetArr.isForHoliday = ApisessionDetails.fwFlg == "Y" ? true : false
            sessiondetArr.changeStatus = ApisessionDetails.changeStatus
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: ApisessionDetails.tpDt.date) {
                print(date)
                sessiondetArr.rawDate =  date
                dateFormatter.dateFormat = "d MMMM yyyy"
                sessiondetArr.date = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "EEEE"
                sessiondetArr.day = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                sessiondetArr.dayNo = dateFormatter.string(from: date)
            } else {
                print("Failed to convert string to date.")
            }
            
            sessiondetArr.changeStatus = ApisessionDetails.changeStatus
            sessiondetArr.entryMode = ApisessionDetails.entryMode
 
            
            if ApisessionDetails.wtCode != "" {
                let sessionDetail = SessionDetail()
                sessionDetail.FWFlg = ApisessionDetails.fwFlg
                sessionDetail.isForFieldWork = ApisessionDetails.fwFlg == "Y" || ApisessionDetails.fwFlg == "F" ? true : false
                sessionDetail.WTCode = ApisessionDetails.wtCode
                sessionDetail.WTName = ApisessionDetails.wtName
                sessionDetail.clusterCode = ApisessionDetails.clusterCode
                //== "" ?  ApisessionDetails.clusterSFS : ApisessionDetails.clusterCode
                sessionDetail.clusterName = ApisessionDetails.clusterName
                //== "" ?  ApisessionDetails.clusterSFNms : ApisessionDetails.clusterName
                sessionDetail.drCode = ApisessionDetails.drCode
                sessionDetail.drName = ApisessionDetails.drName
                sessionDetail.HQCodes = ApisessionDetails.hqCodes
                sessionDetail.HQNames = ApisessionDetails.hqNames
               // sessionDetail.hospCode = ApisessionDetails.h
              //  sessionDetail.hospName = ApisessionDetails.h
                sessionDetail.jwCode = ApisessionDetails.jwCodes
                sessionDetail.jwName = ApisessionDetails.jwNames
                sessionDetail.remarks = ApisessionDetails.dayRemarks
                sessionDetail.chemName = ApisessionDetails.chemName
                sessionDetail.chemCode = ApisessionDetails.chemCode
                sessionDetail.stockistCode = ApisessionDetails.stockistCode
                sessionDetail.stockistName = ApisessionDetails.stockistName
              //  sessionDetail.unListedDrCode = ApisessionDetails.unListedDrCode
               // sessionDetail.unListedDrName = ApisessionDetails.unListedDrName
                sessiondetArr.sessionDetails.append(sessionDetail)
            }
            if ApisessionDetails.wtCode2 != "" {
                let sessionDetail = SessionDetail()
                sessionDetail.FWFlg = ApisessionDetails.fwFlg2
                sessionDetail.isForFieldWork = ApisessionDetails.fwFlg2 == "Y" || ApisessionDetails.fwFlg2 == "F" ? true : false
                sessionDetail.WTCode = ApisessionDetails.wtCode2
                sessionDetail.WTName = ApisessionDetails.wtName2
                sessionDetail.clusterCode = ApisessionDetails.clusterCode2
                //== "" ?  ApisessionDetails.clusterSFS : ApisessionDetails.clusterCode2
                sessionDetail.clusterName = ApisessionDetails.clusterName2
                //== "" ?  ApisessionDetails.clusterSFNms : ApisessionDetails.clusterName2
                sessionDetail.drCode = ApisessionDetails.drTwoCode
                sessionDetail.drName = ApisessionDetails.drTwoName
                sessionDetail.HQCodes = ApisessionDetails.hqCodes2
                sessionDetail.HQNames = ApisessionDetails.hqNames2
               // sessionDetail.hospCode = ApisessionDetails.h
              //  sessionDetail.hospName = ApisessionDetails.h
                sessionDetail.jwCode = ApisessionDetails.jwCodes2
                sessionDetail.jwName = ApisessionDetails.jwNames2
                sessionDetail.remarks = ApisessionDetails.dayRemarks2
                sessionDetail.stockistCode = ApisessionDetails.stockistTwoCode
                sessionDetail.stockistName = ApisessionDetails.stockistTwoName
                sessionDetail.chemName = ApisessionDetails.chemTwoName
                sessionDetail.chemCode = ApisessionDetails.chemTwoCode
              //  sessionDetail.unListedDrCode = ApisessionDetails.unListedDrCode
               // sessionDetail.unListedDrName = ApisessionDetails.unListedDrName
                sessiondetArr.sessionDetails.append(sessionDetail)
           }
            
            allDayPlans.append(sessiondetArr)
            
 
        }
        toutplans.arrOfPlan = allDayPlans

      //  AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
        
        
        do {
            // Read the data from the file URL
            let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                
                if let aPlan = eachDatePlan as? EachDatePlan {
                    AppDefaults.shared.eachDatePlan = aPlan
                } else {
                    print("unable to convert to EachDatePlan")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                AppDefaults.shared.eachDatePlan = EachDatePlan()
            }
        } catch {
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
            AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
        }
        dump(AppDefaults.shared.eachDatePlan)
        
        AppDefaults.shared.tpArry.arrOfPlan = allDayPlans
 
        
        
        AppDefaults.shared.eachDatePlan.tourPlanArr.removeAll()
        
        
        
        AppDefaults.shared.eachDatePlan.tourPlanArr.append(AppDefaults.shared.tpArry)
        
        

        
        
        if !(modal.current.isEmpty) {
            let sessionResponseArr = modal.current[0]

            toCinfigureApprovalState(sessionResponseArr)
        }
        
        if !(modal.previous.isEmpty) {
            let sessionResponseArr = modal.previous[0]

            toCinfigureApprovalState(sessionResponseArr)
        }
     
        if !(modal.next.isEmpty) {
            let sessionResponseArr = modal.next[0]

            toCinfigureApprovalState(sessionResponseArr)
        }
        
        
        
        
        var apiMnths : [Int] = []
      //  var currentMnths = [String]()
        
        
        if !(modal.current.isEmpty) {
            let sessionResponseArr = modal.current[0]
            apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
            toCinfigureApprovalState(sessionResponseArr)
        }
        
        if !(modal.previous.isEmpty) {
            let sessionResponseArr = modal.previous[0]
           apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
            toCinfigureApprovalState(sessionResponseArr)
        }
     
//        if !(modal.next.isEmpty) {
//            let sessionResponseArr = modal.next[0]
//            apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
//            toCinfigureApprovalState(sessionResponseArr)
//        }
  
        
       let currentMnthRange = toGetcurrentNextPrevMonthNumbers()
        
        // Check if currentMnths contains all elements of apiMnths
        let containsAll = currentMnthRange.allSatisfy { apiMnths.contains(($0)) }

        if containsAll {
            print("currentMnths contains all elements of apiMnths.")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: true)
            let missingIndices = findMissingMonths(apiMonths: apiMnths, currentMonthRange: currentMnthRange)
          //  LocalStorage.shared.setOffset(LocalStorage.LocalValue.offsets, value: getOffsetType(for: missingIndices))
            
            LocalStorage.shared.storeOffset(getOffsetType(for: missingIndices))
        } else {
            print("currentMnths does not contain all elements of apiMnths.")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: false)
           let missingIndices = findMissingMonths(apiMonths: apiMnths, currentMonthRange: currentMnthRange)
            LocalStorage.shared.storeOffset(getOffsetType(for: missingIndices))
        }
        var offsets: LocalStorage.Offsets = .all
       // var months = [String]()
        var weeklyOffDates = [String]()
        var weeklyOffRawDates = [Date]()
        var responseHolidaydates = [String]()
      //  var existingDates = [String]()

        if let storedOffset = LocalStorage.shared.retrieveOffset() {
            print("Stored offset:", storedOffset)
            offsets = storedOffset
        } else {
            print("Offset not found.")
        }
        
       // self.offsets = LocalStorage.shared.getOffset(key: LocalStorage.LocalValue.offsets)
        let weeklyoffSetupArr = DBManager.shared.getWeeklyOff()
        if !weeklyoffSetupArr.isEmpty {
            weeklyOff = weeklyoffSetupArr
        }
        
      
      
//        let weekoffIndex = Int(self.weeklyOff?.holiday_Mode ?? "0")
//        let weekoffDates = getDatesForDayIndex(weekoffIndex ?? 0, numberOfMonths: 3)
        
        let holidaysSetupArr = DBManager.shared.getHolidays()
        if !holidaysSetupArr.isEmpty {
            holidays = holidaysSetupArr
        }
       
       
        responseHolidaydates.removeAll()
        

        holidays?.forEach({ aholiday in
            responseHolidaydates.append(aholiday.holiday_Date ?? "")
           
        })
        
        
        let isAlldatesAppended  = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.TPalldatesAppended)

        if !isAlldatesAppended {
            
            let dateString = responseHolidaydates
            
            var holidayDates = [Date]()
            var holidayDateStr = [String]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            holidayDates.removeAll()
            dateString.forEach { aDate in

            
            holidayDates.append(aDate.toDate(format: "yyyy-MM-dd"))
   
            }
            
            
            let setups = AppDefaults.shared.getAppSetUp()
            if let joiningDate =  setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil) {
                holidayDates.removeAll { addedDate in
                //  let dateStr =  appendedDates.toString(format: "yyyy-MM-dd", timeZone: nil)
                 //   let joiningDate = joiningDate.toString(format: "yyyy-MM-dd", timeZone: nil)
                    addedDate < joiningDate
                }
            }
            
            holidayDateStr.removeAll()
            holidayDates.forEach { rawDate in
                holidayDateStr.append(toModifyDate(date: rawDate))
            }
            var isHolidayDict = [String: Bool]()
            holidayDates.forEach { aDate in
                
                let dateStr = toModifyDate(date: aDate)
                
                isHolidayDict[dateStr] = true
            }
            dump(isHolidayDict)
            
            
            
            var weekoffIndex : [Int] = []
            //(weeklyOff?.holiday_Mode ?? "0") ?? 0
            weeklyOff?.forEach({ aWeeklyoff in
                weekoffIndex.append(Int(aWeeklyoff.holiday_Mode ?? "0") ?? 0)
            })
            
            var monthIndex : [Int] = []
            
            switch offsets {
                
            case .all:
                monthIndex =  [-1, 0, 1]
            case .current:
                monthIndex =  [0]
            case .next:
                monthIndex =  [1]
            case .previous:
                monthIndex =  [-1]
                
            case .nextAndPrevious:
                monthIndex =  [-1, 1]
            case .currentAndNext:
                monthIndex =  [0, 1]
            case .currentAndPrevious:
                monthIndex =  [-1, 0]
            case .none:
                monthIndex =  []
            }
            
            var weekoffDates : [Date] = []
            weekoffIndex.forEach { weeklyoffIndex in
                weekoffDates.append(contentsOf: getWeekoffDates(forMonths: monthIndex, weekoffday: weeklyoffIndex))
            }
           
            
            // let weekoffDates = getDatesForDayIndex(weekoffIndex + 1, self.offsets)
            weeklyOffRawDates.append(contentsOf: weekoffDates)
            
            if let joiningDate =  setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil) {
                weeklyOffRawDates.removeAll { addedDate in
                //  let dateStr =  appendedDates.toString(format: "yyyy-MM-dd", timeZone: nil)
                 //   let joiningDate = joiningDate.toString(format: "yyyy-MM-dd", timeZone: nil)
                    addedDate < joiningDate
                }
            }
            
       
            
            
            weeklyOffDates.removeAll()
            weeklyOffRawDates.forEach { rawDate in
                weeklyOffDates.append(toModifyDate(date: rawDate))
            }
            weeklyOffRawDates.forEach { aWeekoffDate in
                let aweekoffStrr = toModifyDate(date: aWeekoffDate)
                isHolidayDict[aweekoffStrr] = false
            }
            
            dump(isHolidayDict)
            
            holidayDates.forEach { aHoliday in
                weeklyOffRawDates.append(aHoliday)
            }
            
            holidayDateStr.forEach { aholidayStr in
                weeklyOffDates.append(aholidayStr)
            }
            
            AppDefaults.shared.eachDatePlan.weekoffsDates.append(contentsOf:  holidayDates)
            AppDefaults.shared.eachDatePlan.weekoffsDates.append(contentsOf:  weekoffDates)
            
            toAppendWeeklyoffs(date: weeklyOffDates, rawDate: weeklyOffRawDates, isHolidayDict: isHolidayDict, eachDatePlan:   AppDefaults.shared.eachDatePlan)
            completion(true)
        } else {
            

            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
                try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
                print("Save successful")
            } catch {
                do {
                    // Read the data from the file URL
                    let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
                    
                    // Attempt to unarchive EachDatePlan directly
                    if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                        
                        if let aPlan = eachDatePlan as? EachDatePlan {
                            AppDefaults.shared.eachDatePlan = aPlan
                        } else {
                            print("unable to convert to EachDatePlan")
                        }
                    } else {
                        // Fallback to default initialization if unarchiving fails
                        print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                        AppDefaults.shared.eachDatePlan = EachDatePlan()
                    }
                } catch {
                    // Handle any errors that occur during reading or unarchiving
                    print("Unable to unarchive: \(error)")
                    AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
                }
                dump(AppDefaults.shared.eachDatePlan)
                print("Unable to save: \(error)")
            }
            
            
            
            completion(true)
        }

       
        
        
        
    }
    
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
    
    
    func toAppendWeeklyoffs(date: [String], rawDate: [Date], isHolidayDict: [String: Bool], eachDatePlan: EachDatePlan) {
        
        
        
        let includedSessionArr = eachDatePlan.tourPlanArr[0].arrOfPlan
        
        var  dates = [String]()
        
        
        guard var includedSessionArr = includedSessionArr else {return}
        includedSessionArr.forEach { SessionDetailsArr in
            dates.append(SessionDetailsArr.date)
        }
        
        
        eachDatePlan.weekoffsDates.enumerated().forEach { adateIndex, adate in
            
            
          //  let dateArray = [/* Your Date array */]
          //  let dateBoolDictionary = [Date: Bool](/* Your [Date: Bool] dictionary */)
            let aSessionDetArr = SessionDetailsArr()
            //var isTrue = Bool()
            let dateStr = toModifyDate(date: adate)
            
            let aSession = SessionDetail()
            aSession.isForFieldWork = false
            
            
            isHolidayDict.forEach { (key, value) in
                if key == dateStr && value == true {
                    //isTrue = true
                    
                    self.holidays?.forEach({ aholiday in
                        var toCompareStr = ""
                        let dateString = aholiday.holiday_Date

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"

                        if let date = dateFormatter.date(from: dateString ?? "") {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "d MMMM yyyy"
                            
                            let formattedString = outputFormatter.string(from: date)
                            print(formattedString) // Output: "1 January 2023"
                            toCompareStr = formattedString
                        } else {
                            print("Failed to convert string to Date.")
                        }
                        
                        if toCompareStr == dateStr {
                            aSession.WTCode = aholiday.wtcode
                            //self.weeklyOff?.wtcode ?? ""
                            aSession.WTName =  aholiday.wtname
                        }
                    })
                    aSessionDetArr.isForWeekoff = false
                    aSessionDetArr.isForHoliday = true
                } else {
                    if let weeklyOff = weeklyOff, !weeklyOff.isEmpty {
                        aSession.WTCode = weeklyOff[0].wtcode ?? ""
                        aSession.WTName = weeklyOff[0].wtname ?? "Weekly off"
                        aSessionDetArr.isForWeekoff = true
                        aSessionDetArr.isForHoliday = false
                   
                    }
    
                }
                
                
                
                
            }

            aSessionDetArr.date = toModifyDate(date: adate)
            aSessionDetArr.rawDate = adate
            
            aSessionDetArr.isDataSentToApi = false
            aSessionDetArr.sessionDetails.append(aSession)
            
            if !dates.contains(aSessionDetArr.date) {
                includedSessionArr.append(aSessionDetArr)
            }
            
           
        }
        
        dump(includedSessionArr)
        
        var uniquePlans = [String: SessionDetailsArr]() // Assuming `date` is String or can be cast to String
        includedSessionArr.forEach { plan in
            uniquePlans[plan.date] = plan
        }
        
        includedSessionArr = Array(uniquePlans.values)
        
        AppDefaults.shared.tpArry.arrOfPlan = includedSessionArr
 
        
        AppDefaults.shared.eachDatePlan.tourPlanArr.removeAll()
        
        
        
        AppDefaults.shared.eachDatePlan.tourPlanArr.append(AppDefaults.shared.tpArry)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
            try data.write(to: EachDatePlan.ArchiveURL, options: .noFileProtection)
            print("data write Save successful")
        } catch {
            print("Unable to save: \(error)")
            do {
                // Read the data from the file URL
                let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
                
                // Attempt to unarchive EachDatePlan directly
                if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                    
                    if let aPlan = eachDatePlan as? EachDatePlan {
                        AppDefaults.shared.eachDatePlan = aPlan
                    } else {
                        print("unable to convert to EachDatePlan")
                    }
                } else {
                    // Fallback to default initialization if unarchiving fails
                    print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                    AppDefaults.shared.eachDatePlan = EachDatePlan()
                }
            } catch {
                // Handle any errors that occur during reading or unarchiving
                print("Unable to unarchive: \(error)")
                AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
            }
            dump(AppDefaults.shared.eachDatePlan)
        }
        
    }
    
    

    
    
    func findMissingMonths(apiMonths: [Int], currentMonthRange: [Int]) -> [Int] {
        let allMonths = Set(apiMonths)
        let expectedMonths = Set(currentMonthRange)
        let missingMonths = expectedMonths.subtracting(allMonths).sorted()

        var missingIndices: [Int] = []
        
        for month in missingMonths {
            if let index = currentMonthRange.firstIndex(of: month) {
                missingIndices.append(index)
            }
        }
        
        
        
        return missingIndices
       
  
    }

    func getOffsetType(for missingIndices: [Int]) -> LocalStorage.Offsets {
        if missingIndices.isEmpty {
            return .none
        }    else if Set(missingIndices) == Set([0, 1, 2]) {
            return .all
        }
        
        else if Set(missingIndices) == Set([1]) {
            return .current
        } else if missingIndices == [2] {
            return .next
        } else if missingIndices == [0] {
            return .previous
        } else if Set(missingIndices) == Set([0, 2]) {
            return .nextAndPrevious
        } else if Set(missingIndices) == Set([1, 2]) {
            return .currentAndNext
        } else if Set(missingIndices) == Set([0, 1]) {
            return .currentAndPrevious
        }
        
        else {
            return .all
        }
            // Handle other cases if needed
           
        }
    
    func toGetcurrentNextPrevMonthNumbers() -> [Int] {
        let currentDate = Date()

        // Get the calendar
        let calendar = Calendar.current

        // Get the current month number
        let currentMonthNumber = calendar.component(.month, from: currentDate)

        // Calculate the previous month number
        let previousMonthNumber = (currentMonthNumber - 2 + 12) % 12 + 1

        // Calculate the next month number
        let nextMonthNumber = (currentMonthNumber % 12) + 1

        // Create an array with current, previous, and next month numbers
        let monthNumbers = [previousMonthNumber, currentMonthNumber, nextMonthNumber]
        
      //  let formattedMonthNumbers = monthNumbers.map { String(format: "%02d", $0) }

        print("Month Numbers: \(monthNumbers)")
        return monthNumbers
    }
    
    
    func toCinfigureApprovalState(_ sessionDetail: SessionDetails) {
                // Handle Approval flow
        
       // LocalStorage.shared.sentToApprovalModelArr = NSKeyedUnarchiver.unarchiveObject(withFile: SentToApprovalModelArr.ArchiveURL.path) as? [SentToApprovalModel] ?? [SentToApprovalModel]()
        
        
        do {
            // Read the data from the file URL
            let data = try Data(contentsOf:  SentToApprovalModelArr.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let approvalModel = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                
                if let approvalModel = approvalModel as? [SentToApprovalModel] {
                    LocalStorage.shared.sentToApprovalModelArr = approvalModel
                } else {
                    print("unable to convert to EachDatePlan")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
           
            }
        } catch {
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
           
        }
        
        
        let sentToApprovalModel =  SentToApprovalModel()
        
        var sessionDate = Date()
        let dateString = sessionDetail.tpDt.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            print(date)
             sessionDate = date
        } else {
            print("Unable to convert the string to a Date.")
        }
        
       
          sentToApprovalModel.rawDate = sessionDate
          sentToApprovalModel.date = self.toModifyDateAsMonth(date: sessionDate)
          sentToApprovalModel.approvalStatus = sessionDetail.changeStatus
        
               
        
                if LocalStorage.shared.sentToApprovalModelArr.count == 0 {
                    LocalStorage.shared.sentToApprovalModelArr.append(sentToApprovalModel)
                } else {
                    LocalStorage.shared.sentToApprovalModelArr.forEach({ sentToApprovalinfo in
                        existingDates.append(sentToApprovalinfo.date)
                    })
                }
        
        
                if !existingDates.contains(self.toModifyDate(date: sessionDate)) {
                    LocalStorage.shared.sentToApprovalModelArr.append(sentToApprovalModel)
                } else {
                  
                }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: LocalStorage.shared.sentToApprovalModelArr, requiringSecureCoding: false)
            try data.write(to: SentToApprovalModelArr.ArchiveURL, options: .atomic)
            print("Save successful")
        } catch {
            print("Unable to save: \(error)")
        }
        
     
    }
    
    
    func toModifyDateAsMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date )
    }
    
    func toModifyDate(date: Date, isForHoliday: Bool? = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (isForHoliday ?? false) ? "yyyy-MM-dd" : "d MMMM yyyy"
        return dateFormatter.string(from: date )
    }

    func getTP() -> EachDatePlan? {
       // return NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
        do {
            // Read the data from the file URL
            let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                
                if let aPlan = eachDatePlan as? EachDatePlan {
                     return aPlan
                } else {
                    print("unable to convert to EachDatePlan")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                return EachDatePlan()
            }
        } catch {
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
            return EachDatePlan() // Fallback to default initialization
        }
      return EachDatePlan()
    }
}
