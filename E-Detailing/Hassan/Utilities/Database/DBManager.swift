//
//  DBManager.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 19/12/23.
//

import Foundation
import CoreData
import UIKit

class DBManager {
    
    static let shared = DBManager()
    
    var existingDates = [String]()
    var  weeklyOff : [Weeklyoff]?
    var  holidays : [Holidays]?
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "E-Detailing")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = self.managedContext()
        context.automaticallyMergesChangesFromParent = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func managedContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    
    func saveMasterData(type : MasterInfo, Values : [[String :Any]],id : String) {
        
        switch type {
        
        case .worktype:
            self.saveWorkTypeData(values: Values)
        case .headquartes:
            break
//        case .competitors:
//            self.saveCompetitorData(values: Values)
        case .inputs:
            self.saveInputData(values: Values, id: id)
        case .slideBrand:
            self.saveSlideBrandData(values: Values)
        case .slideTheraptic:
            self.saveSlideTherapticData(values: Values)
        case .products:
            self.saveProductData(values: Values, id: id)
        case .slides:
            self.saveSlidesData(values: Values)
        case .brands:
            self.saveBrandData(values: Values)
//        case .departments:
//            self.saveDepartsData(values: Values)
        case .speciality:
            self.saveSpecialityData(values: Values)
        case .category:
            self.saveCategoryData(values: Values)
        case .chemistCategory:
            self.saveChemistCategoryData(values: Values)
        case .qualifications:
            self.saveQualificationData(values: Values)
        case .doctorClass:
            self.saveDoctorClassData(values: Values)
        case .docTypes:
            break
        case .ratingDetails:
            break
        case .ratingFeedbacks:
            break
        case .speakerList:
            break
        case .participantList:
            break
        case .indicationList:
            break
        case .setups:
            break
        case .clusters:
            self.saveTerritoryData(values: Values, id: id)
        case .doctors:
            self.saveDoctorFencingData(values: Values, id: id)
        case .chemists:
            self.saveChemistData(values: Values, id: id)
        case .stockists:
            self.saveStockistData(values: Values, id: id)
        case .unlistedDoctors:
            self.saveUnListedDoctorData(values: Values, id: id)
        case .institutions:
            break
        case .jointWork:
            self.saveJointWorkData(values: Values, id: id)
        case .subordinate:
            self.saveSubordinateData(values: Values, id: id)
//        case .subordinateMGR:
//            self.saveSubordainateMgrData(values: Values, id: id)
        case .doctorFencing:
            self.saveDoctorFencingData(values: Values, id: id)
        case .myDayPlan:
            self.saveMyDayPlanData(values: Values)
        case .syncAll:
            break
        case .slideSpeciality:
            self.saveSlideSpecialityData(values: Values)
        case .docFeedback:
            self.saveFeedbackData(values: Values)
//        case .customSetup:
//            break
        case .leaveType:
            self.saveLeaveTypeData(values: Values)
        case .tourPlanStatus:
            break
        case .visitControl:
            self.saveVisitControlData(values: Values)
//        case .stockBalance:
//            self.saveStockBalance(values: Values)
        case .mappedCompetitors:
            self.saveMapCompDetData(values: Values)
        case .empty:
            break
        case .tourPlanSetup:
            saveTPSetup(values: Values)
        case .weeklyOff:
            saveWeeklyoff(values: Values)
        case .holidays:
            saveHolidays(values: Values)
        case .homeSetup:
            saveHomeData(values: Values)
       
        default:
            return
        }
    }
    
    
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
//                if calendar.component(.weekday, from: date) == (weekoffday == 0 ? 1 : weekoffday) {
//                    saturdays.append(date)
//                }
//                
//            }
//        }
//        
//        return saturdays
//    }
    
    
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
        
        
//        let initialsavefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
//        if !initialsavefinish {
//            print("Error")
//
//        } else {
//            AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
//            
//            dump(AppDefaults.shared.eachDatePlan)
//        }
        
        
        
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
        
        
//                let initialsavefinish = NSKeyedArchiver.archiveRootObject(LocalStorage.shared.sentToApprovalModelArr, toFile: SentToApprovalModelArr.ArchiveURL.path)
//                if !initialsavefinish {
//                    print("Error")
//                }
        
        
      //  CoreDataManager.shared.removeAllApprovals()
       // CoreDataManager.shared.toSaveTPApprovals(approvals: LocalStorage.shared.sentToApprovalModelArr) {_ in
          //  CoreDataManager.shared.fetchAppapprovals() { approvals in
          //  dump(approvals)
          //  }
       // }
        
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
    
    
 
    
   
    
    func getMasterData() -> MasterData {
        var masterArray:[MasterData] = []
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MasterData")
        
        do {
            masterArray = try self.managedContext().fetch(fetch) as! [MasterData]
        }
        catch {
            print("error",error.localizedDescription)
        }
        guard let master = masterArray.first else{
            let mContext = self.managedContext()
            let masterEntity = NSEntityDescription.entity(forEntityName: "MasterData", in: mContext)
            let masterData = MasterData(entity: masterEntity!, insertInto: mContext)
            return masterData
        }
        return master
    }
    
    func deleteAllRecords() {
        let context = self.managedContext()
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MasterData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
        do {
            try context.execute(deleteRequest)
            try context.save()
        }catch {
            
        }
    }
    
    
    func saveSlidesData(values : [[String : Any]]) {
        self.deleteSlidesData()
        let masterData = self.getMasterData()
        var slideArray = [ProductSlides]()
        for (index,slide) in values.enumerated() {
            let contextNew = self.managedContext()
            let slideEntity = NSEntityDescription.entity(forEntityName: "ProductSlides", in: contextNew)
            let slideItem = ProductSlides(entity: slideEntity!, insertInto: contextNew)
            slideItem.setValues(fromDictionary: slide, context: contextNew)
            slideItem.index = Int16(index)
            slideArray.append(slideItem)
        }
        
        if let list = masterData.slides?.allObjects as? [ProductSlides] {
            _ = list.map{masterData.removeFromSlides($0)}
        }
        
        slideArray.forEach{ (slide) in
            masterData.addToSlides(slide)
        }
        self.saveContext()
    }
    
    func deleteSlidesData() {
        let masterData = self.getMasterData()
        if let PrevList = masterData.slides?.allObjects as? [ProductSlides] {
            _ = PrevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveSlideBrandData(values : [[String : Any]]) {
        self.deleteSlideBrandData()
        let masterData = self.getMasterData()
        var slideBrandArray = [SlideBrand]()
        for (index,brand) in values.enumerated(){
            let contextNew = self.managedContext()
            let slideBrandEntity = NSEntityDescription.entity(forEntityName: "SlideBrand", in: contextNew)
            let slideBrandItem = SlideBrand(entity: slideBrandEntity!, insertInto: contextNew)
            slideBrandItem.setValues(fromDictionary: brand, context: contextNew)
            slideBrandItem.index = Int16(index)
            slideBrandArray.append(slideBrandItem)
        }
        if let list = masterData.slideBrand?.allObjects as? [SlideBrand]{
            _ = list.map{masterData.removeFromSlideBrand($0)}
        }
        slideBrandArray.forEach { (brand) in
            masterData.addToSlideBrand(brand)
        }
        self.saveContext()
    }
    
    func saveSlideTherapticData(values : [[String : Any]]) {
        self.deleteSlideTherapticData()
        let masterData = self.getMasterData()
        var slideTherapticArray = [SlideTheraptic]()
        for (index,brand) in values.enumerated(){
            let contextNew = self.managedContext()
            let slideTherapticEntity = NSEntityDescription.entity(forEntityName: "SlideTheraptic", in: contextNew)
            let slideherapticItem = SlideTheraptic(entity: slideTherapticEntity!, insertInto: contextNew)
            slideherapticItem.setValues(fromDictionary: brand, context: contextNew)
            slideherapticItem.index = Int16(index)
            slideTherapticArray.append(slideherapticItem)
        }
        if let list = masterData.theraptic?.allObjects as? [SlideTheraptic]{
            _ = list.map{masterData.removeFromTheraptic($0)}
        }
        slideTherapticArray.forEach { (theraptic) in
            masterData.addToTheraptic(theraptic)
        }
        self.saveContext()
    }
    
    func deleteSlideTherapticData() {
        let masterData = self.getMasterData()
        if let PrevList = masterData.theraptic?.allObjects as? [SlideTheraptic]{
            _ = PrevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func deleteSlideBrandData() {
        let masterData = self.getMasterData()
        if let PrevList = masterData.slideBrand?.allObjects as? [SlideBrand]{
            _ = PrevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    

    
    func saveSlideSpecialityData(values : [[String : Any]]) {
        self.deleteSlideSpecialityData()
        let masterData = self.getMasterData()
        var slideSpecialityArray = [SlideSpeciality]()
        for (index,speciality) in values.enumerated(){
            let contextNew = self.managedContext()
            let slideSpecialityEntity = NSEntityDescription.entity(forEntityName: "SlideSpeciality", in: contextNew)
            let slideSpecialityItem = SlideSpeciality(entity: slideSpecialityEntity!, insertInto: contextNew)
            slideSpecialityItem.setValues(fromDictionary: speciality, context: contextNew)
            slideSpecialityItem.index = Int16(index)
            slideSpecialityArray.append(slideSpecialityItem)
        }
        if let list = masterData.slideSpeciality?.allObjects as? [SlideSpeciality]{
            _ = list.map{masterData.removeFromSlideSpeciality($0)}
        }
        slideSpecialityArray.forEach { (special) in
            masterData.addToSlideSpeciality(special)
        }
        self.saveContext()
    }
    
    func deleteSlideSpecialityData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.slideSpeciality?.allObjects as? [SlideSpeciality]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveSubordinateData(values : [[String : Any]],id : String) {
        self.deleteSubordinate(id: id)
        let masterData = self.getMasterData()
        var subordinateArray = [Subordinate]()
        for (index,subordinate) in values.enumerated() {
            let contextNew = self.managedContext()
            let subordinateEntity = NSEntityDescription.entity(forEntityName: "Subordinate", in: contextNew)
            let subordinateItem = Subordinate(entity: subordinateEntity!, insertInto: contextNew)
            subordinateItem.setValues(fromDictionary: subordinate, context: contextNew, id1: id)
            subordinateItem.index = Int16(index)
            subordinateArray.append(subordinateItem)
        }
        
        if let list = masterData.subordinate?.allObjects  as? [Subordinate] {
            _ = list.map{masterData.removeFromSubordinate($0)}
        }
        
        subordinateArray.forEach{ (subordinate) in
            masterData.addToSubordinate(subordinate)
        }
        self.saveContext()
    }
    
    func deleteSubordinate(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.subordinate?.allObjects as? [Subordinate] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func saveSubordainateMgrData(values : [[String : Any]],id : String){
        self.deleteSubordinateMgr(id: id)
        let masterData = self.getMasterData()
        var subordinateMgrArray = [Subordinate]()
        for (index,subordinate) in values.enumerated() {
            let contextNew = self.managedContext()
            let subordinateMgrEntity = NSEntityDescription.entity(forEntityName: "Subordinate", in: contextNew)
            let subordinateMgrItem = Subordinate(entity: subordinateMgrEntity!, insertInto: contextNew)
            subordinateMgrItem.setValues(fromDictionary: subordinate, context: contextNew, id1: id)
            subordinateMgrItem.index = Int16(index)
            subordinateMgrArray.append(subordinateMgrItem)
        }
        
        if let list = masterData.subordinateMgr?.allObjects as? [Subordinate] {
            _ = list.map{masterData.removeFromSubordinateMgr($0)}
        }
        
        subordinateMgrArray.forEach{ (subordinateMgr) in
            masterData.addToSubordinateMgr(subordinateMgr)
        }
        self.saveContext()
    }
    
    func deleteSubordinateMgr(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.subordinateMgr?.allObjects as? [Subordinate] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    
    func saveDoctorFencingData(values : [[String : Any]],id : String) {
        self.deleteDoctorData(id: id)
        let masterData = self.getMasterData()
        var doctorArray = [DoctorFencing]()
        for (index,doctor) in values.enumerated() {
            let contextNew = self.managedContext()
            let doctorEntity = NSEntityDescription.entity(forEntityName: "DoctorFencing", in: contextNew)
            let doctorItem = DoctorFencing(entity: doctorEntity!, insertInto: contextNew)
            doctorItem.setValues(fromDictionary: doctor, id: id)
            doctorItem.index = Int16(index)
            doctorArray.append(doctorItem)
            
        }
        
        if let list = masterData.doctorFencing?.allObjects as? [DoctorFencing]{
            _ = list.map{masterData.removeFromDoctorFencing($0)}
        }
        doctorArray.forEach{ (doctor) in
            masterData.addToDoctorFencing(doctor)
        }
        self.saveContext()
    }
    
    func deleteDoctorData(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.doctorFencing?.allObjects as? [DoctorFencing] {
            let data = prevList.filter{$0.mapId == id}
            _ = data.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveChemistData (values : [[String : Any]],id : String) {
        self.deleteChemistData(id: id)
        let masterData = self.getMasterData()
        var chemistArray = [Chemist]()
        for (index , chemist) in values.enumerated() {
            let contextNew = self.managedContext()
            let chemistEntity = NSEntityDescription.entity(forEntityName: "Chemist", in: contextNew)
            let chemistItem = Chemist(entity: chemistEntity!, insertInto: contextNew)
            chemistItem.setValues(fromDictionary: chemist, id: id)
            chemistItem.index = Int16(index)
            chemistArray.append(chemistItem)
        }
        if let list = masterData.chemist?.allObjects as? [Chemist] {
            _ = list.map{masterData.removeFromChemist($0)}
        }
        chemistArray.forEach{ (chm) in
            masterData.addToChemist(chm)
        }
        self.saveContext()
    }
    
    func deleteChemistData(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.chemist?.allObjects as? [Chemist]{
            let data = prevList.filter{$0.mapId == id}
            _ = data.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func deleteStockistData(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.stockist?.allObjects as? [Stockist]{
            let data = prevList.filter{$0.mapId == id}
            _ = data.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func deleteUnListedDoctorData(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.unListedDoc?.allObjects as? [UnListedDoctor]{
            let data = prevList.filter{$0.mapId == id}
            _ = data.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func saveStockistData(values : [[String :Any]],id : String) {
        self.deleteStockistData(id: id)
        let masterData = self.getMasterData()
        var stockistArray = [Stockist]()
        for (index,stockist) in values.enumerated(){
            let contextNew = self.managedContext()
            let stockistEntity = NSEntityDescription.entity(forEntityName: "Stockist", in: contextNew)
            let stockistItem = Stockist(entity: stockistEntity!, insertInto: contextNew)
            stockistItem.setValues(fromDictionary: stockist, id: id)
            stockistItem.index = Int16(index)
            stockistArray.append(stockistItem)
        }
        if let list = masterData.stockist?.allObjects as? [Stockist] {
            _ = list.map{masterData.removeFromStockist($0)}
        }
        stockistArray.forEach{ (stk) in
            masterData.addToStockist(stk)
        }
        self.saveContext()
    }
    
    
    func saveUnListedDoctorData(values : [[String : Any]],id : String) {
        self.deleteUnListedDoctorData(id: id)
        let masterData = self.getMasterData()
        var unListedDoctorArray = [UnListedDoctor]()
        for (index, doctor) in values.enumerated() {
            let contextNew = self.managedContext()
            let doctorEntity = NSEntityDescription.entity(forEntityName: "UnListedDoctor", in: contextNew)
            let doctorItem = UnListedDoctor(entity: doctorEntity!, insertInto: contextNew)
            doctorItem.setValues(fromDictionary: doctor, context: contextNew, id: id)
            doctorItem.index = Int16(index)
            unListedDoctorArray.append(doctorItem)
        }
        if let list = masterData.unListedDoc?.allObjects as? [UnListedDoctor]{
            _ = list.map{masterData.removeFromUnListedDoc($0)}
        }
        unListedDoctorArray.forEach{ (doc) in
            masterData.addToUnListedDoc(doc)
        }
        self.saveContext()
    }
    
    
    func saveWorkTypeData(values : [[String : Any]]){
        self.deleteWorkTypeData()
        let masterData = self.getMasterData()
        var workTypeArray = [WorkType]()
        for (index,workType) in values.enumerated() {
            let contextNew = self.managedContext()
            let workTypeEntity = NSEntityDescription.entity(forEntityName: "WorkType", in: contextNew)
            let workTypeItem = WorkType(entity: workTypeEntity!, insertInto: contextNew)
            workTypeItem.setValues(fromDictionary: workType)
            workTypeItem.index = Int16(index)
            workTypeArray.append(workTypeItem)
        }
        if let list = masterData.workType?.allObjects as? [WorkType]{
            _ = list.map{masterData.removeFromWorkType($0)}
        }
        workTypeArray.forEach{ (workType) in
            masterData.addToWorkType(workType)
        }
        self.saveContext()
    }
    
    func deleteWorkTypeData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.workType?.allObjects as? [WorkType] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveTPSetup(values : [[String : Any]]){
        self.deleteTableSetupData()
        let masterData = self.getMasterData()
        var TableSetupArray = [TableSetup]()
        for (index,workType) in values.enumerated() {
            let contextNew = self.managedContext()
            let workTypeEntity = NSEntityDescription.entity(forEntityName: "TableSetup", in: contextNew)
            let TableSetupItem = TableSetup(entity: workTypeEntity!, insertInto: contextNew)
            TableSetupItem.setValues(fromDictionary: workType)
            TableSetupItem.index = Int16(index)
            TableSetupArray.append(TableSetupItem)
        }
        if let list = masterData.tableSetup?.allObjects as? [TableSetup]{
            _ = list.map{masterData.removeFromTableSetup($0)}
        }
        TableSetupArray.forEach{ (type) in
            masterData.addToTableSetup(type)
        }
        self.saveContext()
    }
    
    func deleteTableSetupData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.tableSetup?.allObjects as? [WorkType] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveWeeklyoff(values : [[String : Any]]){
        self.deleteWeeklyoff()
        let masterData = self.getMasterData()
        var WeeklyoffSetupArray = [Weeklyoff]()
        for (index,workType) in values.enumerated() {
            let contextNew = self.managedContext()
            let workTypeEntity = NSEntityDescription.entity(forEntityName: "Weeklyoff", in: contextNew)
            let WeeklyoffSetupItem = Weeklyoff(entity: workTypeEntity!, insertInto: contextNew)
            WeeklyoffSetupItem.setValues(fromDictionary: workType)
            WeeklyoffSetupItem.index = Int16(index)
            WeeklyoffSetupArray.append(WeeklyoffSetupItem)
        }
        if let list = masterData.weeklyoff?.allObjects as? [Weeklyoff]{
            _ = list.map{masterData.removeFromWeeklyoff($0)}
        }
        WeeklyoffSetupArray.forEach{ (type) in
            masterData.addToWeeklyoff(type)
        }
        self.saveContext()
    }
    
    
    func deleteWeeklyoff() {
        let masterData = self.getMasterData()
        if let prevList = masterData.weeklyoff?.allObjects as? [WorkType] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func saveHolidays(values : [[String : Any]]){
        self.deleteHolidays()
        let masterData = self.getMasterData()
        var WeeklyoffSetupArray = [Holidays]()
        for (index,workType) in values.enumerated() {
            let contextNew = self.managedContext()
            let workTypeEntity = NSEntityDescription.entity(forEntityName: "Holidays", in: contextNew)
            let WeeklyoffSetupItem = Holidays(entity: workTypeEntity!, insertInto: contextNew)
            WeeklyoffSetupItem.setValues(fromDictionary: workType)
            WeeklyoffSetupItem.index = Int16(index)
            WeeklyoffSetupArray.append(WeeklyoffSetupItem)
        }
        if let list = masterData.holidays?.allObjects as? [Holidays]{
            _ = list.map{masterData.removeFromHolidays($0)}
        }
        WeeklyoffSetupArray.forEach{ (type) in
            masterData.addToHolidays(type)
        }
        self.saveContext()
    }
    
    
    func deleteHolidays() {
        let masterData = self.getMasterData()
        if let prevList = masterData.holidays?.allObjects as? [Holidays] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    
    
    func deleteHomeData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.homeData?.allObjects as? [HomeData] {
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveHomeData(values : [[String : Any]]){
        self.deleteHomeData()
        let masterData = self.getMasterData()
        var HomeDataSetupArray = [HomeData]()
        for (index,homeData) in values.enumerated() {
            let contextNew = self.managedContext()
            let HomeDataEntity = NSEntityDescription.entity(forEntityName: "HomeData", in: contextNew)
            let HomeDataSetupItem = HomeData(entity: HomeDataEntity!, insertInto: contextNew)
            HomeDataSetupItem.setValues(fromDictionary: homeData)
            HomeDataSetupItem.index = Int16(index)
            HomeDataSetupArray.append(HomeDataSetupItem)
        }
        if let list = masterData.homeData?.allObjects as? [HomeData]{
            _ = list.map{masterData.removeFromHomeData($0)}
        }
        HomeDataSetupArray.forEach{ (type) in
            masterData.addToHomeData(type)
        }
        self.saveContext()
    }


    
    func saveTerritoryData(values : [[String : Any]],id : String) {
        self.deleteTerritoryData(id: id)
        let masterData = self.getMasterData()
        var territoryArray = [Territory]()
        for (index,territory) in values.enumerated() {
            let contextNew = self.managedContext()
            let territoryEntity = NSEntityDescription.entity(forEntityName: "Territory", in: contextNew)
            let territoryItem = Territory(entity: territoryEntity!, insertInto: contextNew)
            territoryItem.setValues(fromDictionary: territory, mapID: id)
            territoryItem.index = Int16(index)
            territoryArray.append(territoryItem)
        }
        if let list = masterData.territory?.allObjects as? [Territory]{
            _ = list.map{masterData.removeFromTerritory($0)}
        }
        territoryArray.forEach{ (territory) in
            masterData.addToTerritory(territory)
        }
        self.saveContext()
    }
    
    
    
    func deleteTerritoryData(id: String) {
        let masterData = self.getMasterData()

        if let territories = masterData.territory?.allObjects as? [Territory] {
            let territoriesToDelete = territories.filter { $0.mapId == id }

            for territory in territoriesToDelete {
                self.managedContext().delete(territory)
            }

            self.saveContext()
        }
    }
    
//    func deleteTerritoryData(id : String) {
//        let masterData = self.getMasterData()
//        if let prevList = masterData.territory?.allObjects as? [Territory]{
//            _ = prevList.map{self.managedContext().delete($0)}
//        }
//        self.saveContext()
//    }
    
    func saveMyDayPlanData(values : [[String : Any]]) {
        self.deleteMyDayPlanData()
        let masterData = self.getMasterData()
        var myDayPlanArray = [MyDayPlan]()
        for (index,mydayPlan) in values.enumerated(){
            let contextNew = self.managedContext()
            let myDayPlanEntity = NSEntityDescription.entity(forEntityName: "MyDayPlan", in: contextNew)
            let myDayPlanItem = MyDayPlan(entity: myDayPlanEntity!, insertInto: contextNew)
            myDayPlanItem.setValues(fromDictionary: mydayPlan, context: contextNew)
            myDayPlanItem.index = Int16(index)
            myDayPlanArray.append(myDayPlanItem)
        }
        if let list = masterData.myDayPlan?.allObjects as? [MyDayPlan] {
            _ = list.map{masterData.removeFromMyDayPlan($0)}
        }
        myDayPlanArray.forEach{ (dayPlan) in
            masterData.addToMyDayPlan(dayPlan)
        }
        self.saveContext()
    }
    
    func deleteMyDayPlanData(){
        let masterData = self.getMasterData()
        if let prevList = masterData.myDayPlan?.allObjects as? [MyDayPlan]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveJointWorkData(values : [[String :Any]], id : String){
        self.deleteJointWorkData(id: id)
        let masterData = self.getMasterData()
        var jointWorkArray = [JointWork]()
        for (index,jointWrk) in values.enumerated() {
            let contextNew = self.managedContext()
            let jointWorkEntity = NSEntityDescription.entity(forEntityName: "JointWork", in: contextNew)
            let jointWorkItem = JointWork(entity: jointWorkEntity!, insertInto: contextNew)
            jointWorkItem.setValues(fromDictionary: jointWrk, id: id)
            jointWorkItem.index = Int16(index)
            jointWorkArray.append(jointWorkItem)
        }
        if let list = masterData.jointWork?.allObjects as? [JointWork]{
            _ = list.map{masterData.removeFromJointWork($0)}
        }
        jointWorkArray.forEach{ (jointWork) in
            masterData.addToJointWork(jointWork)
        }
        self.saveContext()
    }
    
    func deleteJointWorkData(id :String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.jointWork?.allObjects as? [JointWork]{
            let data = prevList.filter{$0.mapId == id}
                _ = data.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveProductData(values : [[String : Any]],id : String) {
        self.deleteProductData(id: id)
        let masterData = self.getMasterData()
        var productArray = [Product]()
        
        for (_,product) in values.enumerated(){
            let contextNew = self.managedContext()
            let productEntity = NSEntityDescription.entity(forEntityName: "Product", in: contextNew)
            let productItem = Product(entity: productEntity!, insertInto: contextNew)
            productItem.setValues(fromDictionary: product, id: id)
           // productItem.index = Int16(index)
            productArray.append(productItem)
        }
        if let list = masterData.product?.allObjects as? [Product]{
            _ = list.map{masterData.removeFromProduct($0)}
        }
        // Filter products by different modes
        let saleArr = productArray.filter { $0.productMode?.lowercased() == "sale" }
        let saleSampleArr = productArray.filter { $0.productMode?.lowercased() == "sale/sample" }
        let sampleArr = productArray.filter { $0.productMode?.lowercased() == "sample" }
        let allArr = productArray.filter { $0.productMode == "" }
        
        productArray.removeAll()
        productArray.append(contentsOf: allArr)
        productArray.append(contentsOf: saleArr)
        productArray.append(contentsOf: saleSampleArr)
        productArray.append(contentsOf: sampleArr)
    
        // Reorder indices starting from 0
        for (index, product) in productArray.enumerated() {
            product.index = Int16(index) // Assuming index is an Int16 property in Product entity
        }
        
        // Sort array based on indices
        _ = productArray.sorted { $0.index < $1.index }
        
        productArray.forEach { (product) in
            masterData.addToProduct(product)
        }
        self.saveContext()
    }
    func deleteProductData(id : String) {
        let masterData = self.getMasterData()
        if let prevList = masterData.product?.allObjects as? [Product]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveInputData(values : [[String : Any]],id : String){
        self.deleteInputData(id: id)
        let masterData = self.getMasterData()
        var inputArray = [Input]()
        for (index,input) in values.enumerated() {
            let contextNew = self.managedContext()
            let inputEntity = NSEntityDescription.entity(forEntityName: "Input", in: contextNew)
            let inputItem = Input(entity: inputEntity!, insertInto: contextNew)
            inputItem.setValues(fromDictionary: input, context: contextNew, id: id)
            inputItem.index = Int16(index)
            inputArray.append(inputItem)
        }
        if let list = masterData.input?.allObjects as? [Input]{
            _ = list.map{masterData.removeFromInput($0)}
        }
        inputArray.forEach { (input) in
            masterData.addToInput(input)
        }
        self.saveContext()
    }
    
    func deleteInputData(id : String){
        let masterData = self.getMasterData()
        if let prevList = masterData.input?.allObjects as? [Input]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveBrandData(values : [[String : Any]]) {
        self.deleteBrandData()
        let masterData = self.getMasterData()
        var brandArray = [Brand]()
        for (index,brand) in values.enumerated(){
            let contextNew = self.managedContext()
            let brandEntity = NSEntityDescription.entity(forEntityName: "Brand", in: contextNew)
            let brandItem = Brand(entity: brandEntity!, insertInto: contextNew)
            brandItem.setValues(fromDictionary: brand)
            brandItem.index = Int16(index)
            brandArray.append(brandItem)
        }
        if let list = masterData.brand?.allObjects as? [Brand]{
            _ = list.map{masterData.removeFromBrand($0)}
        }
        brandArray.forEach { (brand) in
            masterData.addToBrand(brand)
        }
        self.saveContext()
    }
    
    func deleteBrandData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.brand?.allObjects as? [Brand]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveCompetitorData(values : [[String : Any]]){
        self.deleteCompetitorData()
        let masterData = self.getMasterData()
        var competitorArray = [Competitor]()
        for (index,competitor) in values.enumerated(){
            let contextNew = self.managedContext()
            let competitorEntity = NSEntityDescription.entity(forEntityName: "Competitor", in: contextNew)
            let competitorItem = Competitor(entity: competitorEntity!, insertInto: contextNew)
            competitorItem.setValues(fromDictionary: competitor)
            competitorItem.index = Int16(index)
            competitorArray.append(competitorItem)
        }
        if let list = masterData.competitor?.allObjects as? [Competitor]{
            _ = list.map{masterData.removeFromCompetitor($0)}
        }
        competitorArray.forEach { (competitor) in
            masterData.addToCompetitor(competitor)
        }
        self.saveContext()
    }
    
    func deleteCompetitorData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.competitor?.allObjects as? [Competitor]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveSpecialityData(values : [[String : Any]]) {
        self.deleteSpecialityData()
        let masterData = self.getMasterData()
        var specialityArray = [Speciality]()
        for (index,speciality) in values.enumerated() {
            let contextNew = self.managedContext()
            let specialityEntity = NSEntityDescription.entity(forEntityName: "Speciality", in: contextNew)
            let specialityItem = Speciality(entity: specialityEntity!, insertInto: contextNew)
            specialityItem.setValues(fromDictionary: speciality)
            specialityItem.index = Int16(index)
            specialityArray.append(specialityItem)
        }
        if let list = masterData.speciality?.allObjects as? [Speciality]{
            _ = list.map{masterData.removeFromSpeciality($0)}
        }
        specialityArray.forEach { (speciality) in
            masterData.addToSpeciality(speciality)
        }
        self.saveContext()
    }
    
    func deleteSpecialityData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.speciality?.allObjects as? [Speciality]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveQualificationData(values : [[String : Any]]){
        self.deleteQualificationData()
        let masterData = self.getMasterData()
        var qualificationArray = [Qualifications]()
        for (index,quali) in values.enumerated() {
            let contextNew = self.managedContext()
            let qualificationEntity = NSEntityDescription.entity(forEntityName: "Qualifications", in: contextNew)
            let qualificationItem = Qualifications(entity: qualificationEntity!, insertInto: contextNew)
            qualificationItem.setValues(fromDictionary: quali)
            qualificationItem.index = Int16(index)
            qualificationArray.append(qualificationItem)
        }
        if let list = masterData.qualification?.allObjects as? [Qualifications]{
            _ = list.map{masterData.removeFromQualification($0)}
        }
        qualificationArray.forEach { (qualification) in
            masterData.addToQualification(qualification)
        }
        self.saveContext()
    }
    
    func deleteQualificationData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.qualification?.allObjects as? [Qualifications]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func getChemistCategory() -> [ChemistCategory] {
        let masterData = self.getMasterData()
        guard let categoryArray = masterData.chemistCategory?.allObjects as? [ChemistCategory] else{
            return [ChemistCategory]()
        }
        let array = categoryArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func saveChemistCategoryData(values : [[String : Any]]) {
        self.deleteChemistCategoryData()
        let masterData = self.getMasterData()
        var categoryArray = [ChemistCategory]()
        for (index,category) in values.enumerated(){
            let contextNew = self.managedContext()
            let categoryEntity = NSEntityDescription.entity(forEntityName: "ChemistCategory", in: contextNew)
            let categoryItem = ChemistCategory(entity: categoryEntity!, insertInto: contextNew)
            categoryItem.setValues(fromDictionary: category)
            categoryItem.index = Int16(index)
            categoryArray.append(categoryItem)
        }
        if let list = masterData.chemistCategory?.allObjects as? [ChemistCategory]{
            _ = list.map{masterData.removeFromChemistCategory($0)}
        }
        categoryArray.forEach { (category) in
            masterData.addToChemistCategory(category)
        }
        self.saveContext()
    }
    
    func deleteChemistCategoryData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.chemistCategory?.allObjects as? [ChemistCategory]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveCategoryData(values : [[String : Any]]) {
        self.deleteCategoryData()
        let masterData = self.getMasterData()
        var categoryArray = [DoctorCategory]()
        for (index,category) in values.enumerated(){
            let contextNew = self.managedContext()
            let categoryEntity = NSEntityDescription.entity(forEntityName: "DoctorCategory", in: contextNew)
            let categoryItem = DoctorCategory(entity: categoryEntity!, insertInto: contextNew)
            categoryItem.setValues(fromDictionary: category)
            categoryItem.index = Int16(index)
            categoryArray.append(categoryItem)
        }
        if let list = masterData.category?.allObjects as? [DoctorCategory]{
            _ = list.map{masterData.removeFromCategory($0)}
        }
        categoryArray.forEach { (category) in
            masterData.addToCategory(category)
        }
        self.saveContext()
    }
    
    func deleteCategoryData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.category?.allObjects as? [DoctorCategory]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveDoctorClassData(values : [[String : Any]]) {
        self.deleteDoctorClassData()
        let masterData = self.getMasterData()
        var classArray = [DoctorClass]()
        for (index,cls) in values.enumerated() {
            let contextNew = self.managedContext()
            let classEntity = NSEntityDescription.entity(forEntityName: "DoctorClass", in: contextNew)
            let classItem = DoctorClass(entity: classEntity!, insertInto: contextNew)
            classItem.setValues(fromDictionary: cls)
            classItem.index = Int16(index)
            classArray.append(classItem)
        }
        if let list = masterData.doctorClass?.allObjects as? [DoctorClass]{
            _ = list.map{masterData.removeFromDoctorClass($0)}
        }
        classArray.forEach { (docClass) in
            masterData.addToDoctorClass(docClass)
        }
        self.saveContext()
    }
    
    
    func deleteDoctorClassData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.doctorClass?.allObjects as? [DoctorClass]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveDepartsData(values : [[String : Any]]) {
        self.deleteDepartsData()
        let masterData = self.getMasterData()
        var departArray = [Departs]()
        for (index,depart) in values.enumerated() {
            let contextNew = self.managedContext()
            let departEntity = NSEntityDescription.entity(forEntityName: "Departs", in: contextNew)
            let departItem = Departs(entity: departEntity!, insertInto: contextNew)
            departItem.setValues(fromDictionary: depart)
            departItem.index = Int16(index)
            departArray.append(departItem)
        }
        if let list = masterData.departs?.allObjects as? [Departs]{
            _ = list.map{masterData.removeFromDeparts($0)}
        }
        departArray.forEach { (departs) in
            masterData.addToDeparts(departs)
        }
        self.saveContext()
    }
    
    func deleteDepartsData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.departs?.allObjects as? [Departs]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveFeedbackData(values : [[String : Any]]) {
        self.deleteFeedbackData()
        let masterData = self.getMasterData()
        var feedbackArray = [Feedback]()
        for (index,feedback) in values.enumerated() {
            if feedback["name"] as? String == "" {
              continue
            }
            let contextNew = self.managedContext()
            let feedbackEntity = NSEntityDescription.entity(forEntityName: "Feedback", in: contextNew)
            let feedbackItem = Feedback(entity: feedbackEntity!, insertInto: contextNew)
            feedbackItem.setValues(fromDictionary: feedback)
            feedbackItem.index = Int16(index)
            feedbackArray.append(feedbackItem)
        }
        if let list = masterData.feedback?.allObjects as? [Feedback]{
            _ = list.map{masterData.removeFromFeedback($0)}
        }
        feedbackArray.forEach { Feedback in
            masterData.addToFeedback(Feedback)
        }
        self.saveContext()
    }
    
    func deleteFeedbackData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.feedback?.allObjects as? [Feedback]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func saveLeaveTypeData(values : [[String : Any]]) {
        self.deleteLeaveTypeData()
        let masterData = self.getMasterData()
        var leaveArray = [LeaveType]()
        for (index,leaveType) in values.enumerated() {
            let contextNew = self.managedContext()
            let leaveTypeEntity = NSEntityDescription.entity(forEntityName: "LeaveType", in: contextNew)
            let leaveTypeItem = LeaveType(entity: leaveTypeEntity!, insertInto: contextNew)
            leaveTypeItem.setValues(fromDictionary: leaveType, context: contextNew)
            leaveTypeItem.index = Int16(index)
            leaveArray.append(leaveTypeItem)
        }
        if let list = masterData.leaveType?.allObjects as? [LeaveType]{
            _ = list.map{masterData.removeFromLeaveType($0)}
        }
        leaveArray.forEach { LeaveType in
            masterData.addToLeaveType(LeaveType)
        }
        self.saveContext()
    }
    
    func deleteLeaveTypeData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.leaveType?.allObjects as? [LeaveType]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
 
    func saveVisitControlData(values : [[String : Any]]) {
        self.deleteVisitControlData()
        let masterData = self.getMasterData()
        var vistiControlArray = [VisitControl]()
        for (index,visitControl) in values.enumerated() {
            let contextNew = self.managedContext()
            let visitControlEntity = NSEntityDescription.entity(forEntityName: "VisitControl", in: contextNew)
            let visitControlItem = VisitControl(entity: visitControlEntity!, insertInto: contextNew)
            visitControlItem.setValues(fromDictionary: visitControl)
            visitControlItem.index = Int16(index)
            vistiControlArray.append(visitControlItem)
        }
        if let list = masterData.visitControl?.allObjects as? [VisitControl]{
            _ = list.map{masterData.removeFromVisitControl($0)}
        }
        vistiControlArray.forEach { VisitControl in
            masterData.addToVisitControl(VisitControl)
        }
        self.saveContext()
    }
    
    func deleteVisitControlData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.visitControl?.allObjects as? [VisitControl]{
            _  = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    
    func saveStockBalance(values : [[String : Any]]) {
        self.deleteStockBalance()
        guard let stock = values.first else{
            return
        }

        let masterData = self.getMasterData()
        let mContextnew = self.managedContext()
        let StockEntity = NSEntityDescription.entity(forEntityName: "StockBalance", in: mContextnew)
        let stockItem = StockBalance(entity: StockEntity!, insertInto: mContextnew)
        stockItem.setValues(fromDictionary: stock, context: mContextnew)
        masterData.stockBalance = stockItem
        self.saveContext()
    }
    
    func deleteStockBalance() {
        let masterData = self.getMasterData()
        if let list = masterData.stockBalance {
            self.managedContext().delete(list)
        }
        self.saveContext()
    }
    
    func saveMapCompDetData(values : [[String : Any]]){
        self.deleteMapCompDetData()
        let masterData = self.getMasterData()
        var mapCompDetArray = [MapCompDet]()
        for (index,map) in values.enumerated() {
            let contextNew = self.managedContext()
            let mapCompDetEntity = NSEntityDescription.entity(forEntityName: "MapCompDet", in: contextNew)
            let mapCompDetItem = MapCompDet(entity: mapCompDetEntity!, insertInto: contextNew)
            mapCompDetItem.setValues(fromDictionary: map)
            mapCompDetItem.index = Int16(index)
            mapCompDetArray.append(mapCompDetItem)
        }
        if let list = masterData.mapCompDet?.allObjects as? [MapCompDet]{
            _ = list.map{masterData.removeFromMapCompDet($0)}
        }
        mapCompDetArray.forEach{ MapCompDet in
            masterData.addToMapCompDet(MapCompDet)
        }
        self.saveContext()
    }
    
    func deleteMapCompDetData() {
        let masterData = self.getMasterData()
        if let prevList = masterData.mapCompDet?.allObjects as? [MapCompDet]{
            _ = prevList.map{self.managedContext().delete($0)}
        }
        self.saveContext()
    }
    
    func getSlide() -> [ProductSlides] {
        let masterData = self.getMasterData()
        guard let slideArray = masterData.slides?.allObjects as? [ProductSlides] else{
            return [ProductSlides]()
        }
        let array = slideArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideBrand() -> [SlideBrand]{
        let masterData = self.getMasterData()
        guard let slideBrandArray = masterData.slideBrand?.allObjects as? [SlideBrand] else{
            return [SlideBrand]()
        }
        let array = slideBrandArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideTheraptic() -> [SlideTheraptic]{
        let masterData = self.getMasterData()
        guard let slideBrandArray = masterData.theraptic?.allObjects as? [SlideTheraptic] else{
            return [SlideTheraptic]()
        }
        let array = slideBrandArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSlideSpeciality() -> [SlideSpeciality]{
        let masterData = self.getMasterData()
        guard let slideSpecialityArray = masterData.slideSpeciality?.allObjects as? [SlideSpeciality] else{
            return [SlideSpeciality]()
        }
        let array = slideSpecialityArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSubordinate() -> [Subordinate] {
        let masterData = self.getMasterData()
        guard let subordinateArray = masterData.subordinate?.allObjects as? [Subordinate] else{
            return [Subordinate]()
        }
        let array = subordinateArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSubordinateMGR() -> [Subordinate] {
        let masterData = self.getMasterData()
        
        guard let subordinateMgrArray = masterData.subordinateMgr?.allObjects as? [Subordinate] else{
            return [Subordinate]()
        }
        
        let array = subordinateMgrArray.sorted{ (item1 , item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getDoctor() -> [DoctorFencing]{
        let masterData = self.getMasterData()
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return [DoctorFencing]()
        }
        let array = doctorArray.sorted{ (item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
//    func getDoctor(mapID: String) -> [DoctorFencing]{
//        let masterData = self.getMasterData()
//        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
//            return [DoctorFencing]()
//        }
//
//        let filteredArray = doctorArray.filter { $0.mapId == mapID }
//
//        
//        
//        let sortedArray = filteredArray.sorted { $0.index < $1.index }
//
//        return sortedArray
//        
//    }
  
    
    
    func getDoctorByTerritory(townCodes: [String]) -> [DoctorFencing] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [DoctorFencing]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getDoctor(mapID: String) -> [DoctorFencing] {
        let masterData = self.getMasterData()
        guard let doctorArray = masterData.doctorFencing?.allObjects as? [DoctorFencing] else {
            return []
        }

        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [DoctorFencing]()

        for doctor in doctorArray {
            if doctor.mapId == mapID && !uniqueCodes.contains(doctor.code ?? "") {
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "")
            }
        }

        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getChemist(mapID: String) -> [Chemist]{
        let masterData = self.getMasterData()
        guard let chemistArray = masterData.chemist?.allObjects as? [Chemist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [Chemist]()
        
        for chemist in chemistArray {
            if chemist.mapId == mapID && !uniqueCodes.contains(chemist.code ?? "") {
                filteredArray.append(chemist)
                uniqueCodes.insert(chemist.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getChemistByTerritory(townCodes: [String]) -> [Chemist] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.chemist?.allObjects as? [Chemist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [Chemist]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    
    
    func getChemist() -> [Chemist]{
        let masterData = self.getMasterData()
        guard let chemistArray = masterData.chemist?.allObjects as? [Chemist] else {
            return [Chemist]()
        }
        let array = chemistArray.sorted{ (item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getStockist(mapID: String) -> [Stockist]{
        let masterData = self.getMasterData()
        guard let stockiststArray = masterData.stockist?.allObjects as? [Stockist] else {
            return []
        }
        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [Stockist]()
        
        for stockistst in stockiststArray {
            if stockistst.mapId == mapID && !uniqueCodes.contains(stockistst.code ?? "") {
                filteredArray.append(stockistst)
                uniqueCodes.insert(stockistst.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getStockistByTerritory(townCodes: [String]) -> [Stockist] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.stockist?.allObjects as? [Stockist] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [Stockist]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    
    func getStockist() -> [Stockist]{
        let masterData = self.getMasterData()
        guard let stockistArray = masterData.stockist?.allObjects as? [Stockist] else{
            return [Stockist]()
        }
        let array = stockistArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getUnListedDoctor() -> [UnListedDoctor]{
        let masterData = self.getMasterData()
        guard let unlistedDoctorArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return [UnListedDoctor]()
        }
        let array = unlistedDoctorArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getUnListedDoctor(mapID: String) -> [UnListedDoctor]{
        let masterData = self.getMasterData()
        guard let unlistedDocArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return []
        }

        var uniqueCodes = Set<String>() // To keep track of unique codes
        var filteredArray = [UnListedDoctor]()
        
        for unlistedDoc in unlistedDocArray {
            if unlistedDoc.mapId == mapID && !uniqueCodes.contains(unlistedDoc.code ?? "") {
                filteredArray.append(unlistedDoc)
                uniqueCodes.insert(unlistedDoc.code ?? "")
            }
        }
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        
        return sortedArray
    }
    
    
    func getUnlistedDocByTerritory(townCodes: [String]) -> [UnListedDoctor] {
        let masterData = self.getMasterData()
        
        // Safely unwrap doctorFencing data
        guard let doctorArray = masterData.unListedDoc?.allObjects as? [UnListedDoctor] else {
            return []
        }
        
        var uniqueCodes = Set<String>() // To track unique doctor codes
        var filteredArray = [UnListedDoctor]()
        
        // Filter doctors by mapID, unique code, and town code
        for doctor in doctorArray {
            if
               !uniqueCodes.contains(doctor.code ?? ""),
               townCodes.contains(doctor.townCode ?? "") { // Filter by town code
                filteredArray.append(doctor)
                uniqueCodes.insert(doctor.code ?? "") // Track unique doctor code
            }
        }

        // Sort by index property
        let sortedArray = filteredArray.sorted { $0.index < $1.index }
        return sortedArray
    }
    
    func getWorkType() -> [WorkType]{
        let masterData = self.getMasterData()
        guard let workTypeArray = masterData.workType?.allObjects as? [WorkType] else{
            return [WorkType]()
        }
        let array = workTypeArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getTableSetUp() -> [TableSetup]{
        let masterData = self.getMasterData()
        guard let TableSetupArray = masterData.tableSetup?.allObjects as? [TableSetup] else{
            return [TableSetup]()
        }
        let array = TableSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getWeeklyOff() -> [Weeklyoff]{
        let masterData = self.getMasterData()
        guard var WeeklyoffSetupArray = masterData.weeklyoff?.allObjects as? [Weeklyoff] else{
            return [Weeklyoff]()
        }
        
        var uniqueHolidayModes = Set<String>()
        WeeklyoffSetupArray = WeeklyoffSetupArray.filter { aWeeklyoff in
            guard !uniqueHolidayModes.contains(aWeeklyoff.holiday_Mode ?? "0") else {
                return false
            }
            uniqueHolidayModes.insert(aWeeklyoff.holiday_Mode ?? "0")
            return true
        }
        
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func geUnsyncedtHomeData() -> [UnsyncedHomeData]? {
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.unsyncedHomeData?.allObjects else{
            return [UnsyncedHomeData]()
        }
//        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
//            return item1.index < item2.index
//        }
        return WeeklyoffSetupArray as? [UnsyncedHomeData] ?? nil
    }
    
    func getHomeData() -> [HomeData]{
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.homeData?.allObjects as? [HomeData] else{
            return [HomeData]()
        }
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getHolidays() -> [Holidays]{
        let masterData = self.getMasterData()
        guard let WeeklyoffSetupArray = masterData.holidays?.allObjects as? [Holidays] else{
            return [Holidays]()
        }
        let array = WeeklyoffSetupArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getTerritory() -> [Territory]{
        let masterData = self.getMasterData()
        
        guard let territoryArray = masterData.territory?.allObjects as? [Territory] else{
            return [Territory]()
        }
        let array = territoryArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getTerritory(mapID: String) -> [Territory] {
        let masterData = self.getMasterData()

        guard let territoryArray = masterData.territory?.allObjects as? [Territory] else {
            return []
        }

        let filteredArray = territoryArray.filter { $0.mapId == mapID }

        let sortedArray = filteredArray.sorted { $0.index < $1.index }

        return sortedArray
    }
    
    func getMyDayPlan() -> [MyDayPlan]{
        let masterData = self.getMasterData()
        guard let mydayplanArray = masterData.myDayPlan?.allObjects as? [MyDayPlan] else{
            return [MyDayPlan]()
        }
        let array = mydayplanArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getJointWork() -> [JointWork]{
        let masterData = self.getMasterData()
        guard let jointWorkArray = masterData.jointWork?.allObjects as? [JointWork] else{
            return [JointWork]()
        }
        let array = jointWorkArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
//    func getProduct() -> [Product]{
//        let masterData = self.getMasterData()
//        guard var productArray = masterData.product?.allObjects as? [Product] else{
//            return [Product]()
//        }
//
//        
//        
//      //  var productArr = DBManager.shared.getProduct()
//        let saleArr = productArray.filter { $0.productMode?.lowercased() == "sale" }
//        let SaleSampleArr =  productArray.filter { $0.productMode?.lowercased() == "sale/sample" }
//        let sampleArr = productArray.filter { $0.productMode?.lowercased() == "sample" }
//        
//        productArray.removeAll()
//        productArray.append(contentsOf: saleArr)
//        productArray.append(contentsOf: SaleSampleArr)
//        productArray.append(contentsOf: sampleArr)
//        
//        
//                let array = productArray.sorted{(item1 , item2 ) -> Bool in
//                    return item1.index < item2.index
//                }
//        
//        return array
//    }
    
    
    func getProduct() -> [Product] {
        let masterData = self.getMasterData()
        guard let productArray = masterData.product?.allObjects as? [Product] else{
            return [Product]()
        }
        let array = productArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }

    func getInput() -> [Input]{
        let masterData = self.getMasterData()
        guard let inputArray = masterData.input?.allObjects as? [Input] else{
            return [Input]()
        }
        let array = inputArray.sorted{(item1 , item2 ) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getBrands() -> [Brand]{
        let masterData = self.getMasterData()
        guard let brandArray = masterData.brand?.allObjects as? [Brand] else{
            return [Brand]()
        }
        let array = brandArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getCompetitor() -> [Competitor]{
        let masterData = self.getMasterData()
        guard let competitorArray = masterData.competitor?.allObjects as? [Competitor] else{
            return [Competitor]()
        }
        let array = competitorArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getSpeciality() -> [Speciality]{
        let masterData = self.getMasterData()
        guard let specialityArray = masterData.speciality?.allObjects as? [Speciality] else{
            return [Speciality]()
        }
        let array = specialityArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getDoctorClass() -> [DoctorClass]{
        let masterData = self.getMasterData()
        guard let classArray = masterData.doctorClass?.allObjects as? [DoctorClass] else{
            return [DoctorClass]()
        }
        let array = classArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getDeparts() -> [Departs]{
        let masterData = self.getMasterData()
        guard let departArray = masterData.departs?.allObjects as? [Departs] else{
            return [Departs]()
        }
        let array = departArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getCategory() -> [DoctorCategory] {
        let masterData = self.getMasterData()
        guard let categoryArray = masterData.category?.allObjects as? [DoctorCategory] else{
            return [DoctorCategory]()
        }
        let array = categoryArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
  
    func getQualification() -> [Qualifications]{
        let masterData = self.getMasterData()
        guard let qualiArray = masterData.qualification?.allObjects as? [Qualifications] else{
            return [Qualifications]()
        }
        let array = qualiArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getLeaveType() -> [LeaveType]{
        let masterData = self.getMasterData()
        guard let leaveArray = masterData.leaveType?.allObjects as? [LeaveType] else{
            return [LeaveType]()
        }
        let array = leaveArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getVisitControl() -> [VisitControl]{
        let masterData = self.getMasterData()
        guard let visitArray = masterData.visitControl?.allObjects as? [VisitControl] else{
            return [VisitControl]()
        }
        let array = visitArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getMapCompDet() -> [MapCompDet]{
        let masterData = self.getMasterData()
        guard let mapArray = masterData.mapCompDet?.allObjects as? [MapCompDet] else{
            return [MapCompDet]()
        }
        let array = mapArray.sorted{(item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    
    func getFeedback() -> [Feedback]{
        let masterData = self.getMasterData()
        guard let feedbackArray = masterData.feedback?.allObjects as? [Feedback] else{
            return [Feedback]()
        }
        let array = feedbackArray.sorted { (item1,item2) -> Bool in
            return item1.index < item2.index
        }
        return array
    }
    
    func getStockBalance() -> StockBalance? {
        let masterData = self.getMasterData()
        return masterData.stockBalance
    }
}

