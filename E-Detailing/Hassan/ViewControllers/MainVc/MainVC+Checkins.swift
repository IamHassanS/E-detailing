//
//  MainVC+Checkins.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/06/24.
//

import Foundation
extension MainVC {
    
    func istoRedirecttoCheckin() -> Bool {
        

        var currentDate : Date?
      //  if !isSequentialDCRenabled {
            if self.selectedToday == nil {
                return false
            } else {
                guard let nonNillsessions = self.sessions   else {
                    currentDate = Shared.instance.selectedDate
                    return true
                }
                
                guard nonNillsessions[0].workType != nil else {
                    currentDate = Shared.instance.selectedDate
                    return true
                }
                
              return false
            }
      //  }
        guard let currentDate = currentDate else {return false}
        
        // Assuming you have a storedDateString retrieved from local storage
        let storedDateString = LocalStorage.shared.getString(key: LocalStorage.LocalValue.lastCheckedInDate)
        let storedDate =  storedDateString.toDate(format: "yyyy-MM-dd")
        //dateFormatter.date(from: storedDateString) ?? Date()
        if !Calendar.current.isDate(currentDate, inSameDayAs: storedDate) {
            // CoreDataManager.shared.removeAdayPlans(planDate: currentDate)
        }
        if isDayCheckinNeeded {
            
            if !Calendar.current.isDate(currentDate, inSameDayAs: storedDate) {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
                ///Dont change titile it may break underlying chekin details view actions
                self.btnFinalSubmit.setTitle("Check IN", for: .normal)
                
                
                return true
                
                
            }
            
            
            let lastcheckedinDate =  toReturnLastCheckinDate()?.toString(format: "yyyy-MM-dd") ?? ""
            //LocalStorage.shared.getString(key: LocalStorage.LocalValue.lastCheckedInDate) //"2024-02-28 14:19:54"
            
            
            let toDayDate = currentDate.toString(format: "yyyy-MM-dd")
            
            if toDayDate == lastcheckedinDate {
                
                if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.userCheckedOut) {
                    self.configureAddCall(false)
                    self.btnFinalSubmit.isUserInteractionEnabled = false
                    self.btnFinalSubmit.alpha = 0.5
                    
                }
                
            
                    self.btnFinalSubmit.setTitle(isDayCheckinNeeded ?  "Final submit / Check OUT" : "Final submit", for: .normal)
          
               
                return false
            } else {
                
                LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
                
                self.configureAddCall(true)
                
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                    self.btnFinalSubmit.setTitle(isDayCheckinNeeded ?  "Final submit / Check OUT" : "Final submit", for: .normal)
                    return false
                    
                } else {
                    self.btnFinalSubmit.setTitle("Check IN", for: .normal)
                    return true
                }
                
                
            }
            
            
            
        } else {
            self.btnFinalSubmit.setTitle(isDayCheckinNeeded ?  "Final submit / Check OUT" : "Final submit", for: .normal)
            self.configureAddCall(true)
            return false
        }
    }
    
    func checkoutAction() {
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
            guard let welf = self else {return}
            
            if geoFencingEnabled {
                guard coordinates != nil else {
                    welf.showAlertToNetworks(desc: "Please enable location services in Settings.", isToclearacalls: false)
               
                    return
                }
            }
            
            Pipelines.shared.getAddressString(latitude: coordinates?.latitude ?? Double(), longitude:  coordinates?.longitude ?? Double()) { [weak self] address in
                guard let welf = self else {return}
  
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let currentDate = welf.toMergeDate(selectedDate: Shared.instance.selectedDate) ?? Date()
                let dateString = dateFormatter.string(from: currentDate)
                
                let datestr = dateString
                
                ///time
                dateFormatter.dateFormat = "HH:mm:ss"
                
                let timeString = dateFormatter.string(from: currentDate)
                
                let timestr = (timeString)
                
                
                let achckinInfo = CheckinInfo(address: address, checkinDateTime: "" , checkOutDateTime: welf.getCurrentFormattedDateString(selecdate: currentDate), latitude:  coordinates?.latitude ?? Double(), longitude:  coordinates?.latitude ?? Double(), dateStr: datestr, checkinTime: "", checkOutTime: timestr)
                
                 welf.fetchCheckins(checkin: achckinInfo) {[weak self] checkin in
                     guard let welf = self else {return}
                     CoreDataManager.shared.removeAllCheckins()
                     CoreDataManager.shared.saveCheckinsToCoreData(checkinInfo: checkin) { _ in
                         welf.checkinDetailsAction(checkin: checkin)
                     }
                }
                
                
            }
        }
    }
    
    /// set home dashboard selected date
    /// - Parameter date: of type Date
    func toSetCacheDate(date: Date? = nil) {
        Shared.instance.selectedDate = date ?? Date()
        currentPage = date ?? Date()
        selectedToday = date
       // celenderToday = date ?? Date()
        setDateLbl(date: date ?? Date())
    }
    
    func toReturnReason() {
        
    }
    
    /// function to setup not submitted dates
    /// - Parameters:
    ///   - pageType: Home page page type
    ///   - completion: empty completion
    func configurePastWindups(pageType:  MainVC.SegmentType?, completion: @escaping () -> ()) {
        if let notWindedups = toReturnNotWindedupDate() {
            if let notWindedupDate = notWindedups.statusDate {
                let mergedDate = self.toMergeDate(selectedDate: notWindedupDate) ?? Date()
                self.callDayPLanAPI(date: mergedDate, isFromDCRDates: true) { [weak self] in
                    guard let welf = self else {return}
                    welf.toSetParams(date: mergedDate, isfromSyncCall: true) {
                        welf.toConfigureMydayPlan(planDate: mergedDate) {
                            welf.validateWindups() {
                                
                                CoreDataManager.shared.fetchDcrDates { dcrDates in
                                  let filteredDates = dcrDates.filter { $0.date ==  mergedDate.toString(format: "yyyy-MM-dd") }
                                    if let firstEntry = filteredDates.first {
                                        welf.refreshUI(date: mergedDate, rejectionReason: firstEntry.reason, SegmentType.workPlan) {
                                            completion()
                                        }
                                    } else {
                                        welf.refreshUI(date: mergedDate, SegmentType.workPlan) {
                                            completion()
                                        }
                                    }
                                }
                                
//                                welf.refreshUI(date: mergedDate, pageType ?? .workPlan) {
//                                    completion()
//                                }
                            }
                        }
                        
                    }
                    
                }
            }
        } else {
            togetDCRdates(isToUpdateDate: true) { [weak self] in
                guard let welf = self else {return}
                welf.validateWindups() {
              
                }
                
            }
            
        }
        
    }
    
    /// if user final submitted day then Home page is resetted
    /// - Parameters:
    ///   - lastCheckinDate:
    ///   - completion: users past non winded up date
    func reserCallModule(lastCheckinDate: Date?, completion: @escaping () -> ()) {
        if let lastCheckinDate = lastCheckinDate {
            let lastCheckinDateStr = lastCheckinDate.toString(format: "yyyy-MM-dd")
            LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: lastCheckinDateStr)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
        } else {
            LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: "")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
        }
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: false)
        isDayPlanRemarksadded = false
        configureFinalsubmit(true)
        configureAddCall(true)
        
        if isSequentialDCRenabled {
            doSequentialFlow() {
                completion()
            }
        } else {
            doNonSequentialFlow()
            if isDayCheckinNeeded {
                if istoRedirecttoCheckin() {
                    checkinAction()
                  
                }
            }
            completion()
        }
    }
    
    /// operation made after user final submitted for day
    /// - Parameter completion: Empty completion
    func validateWindups(completion: @escaping () -> ()) {
        var isDateWindup: Bool = false
        let selectedDateStr = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd")
        var lastCheckinDate : Date?
        if let windedUps = toReturnWindedupDates() {
            for windedUp in windedUps {
                if let windedUpDate = windedUp.statusDate {
                    let windedUpDateStr = windedUpDate.toString(format: "yyyy-MM-dd")
                    lastCheckinDate = windedUpDate
                    isToRegretCheckin = true
                    if windedUpDateStr == selectedDateStr && windedUp.didUserWindup {
                        isDateWindup = true
                        break
                    }
                }
            }
        }
        
        if isDateWindup {
            LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: selectedDateStr)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: true)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: true)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: true)
            configureFinalsubmit(true)
            configureAddCall(true)
            configureAddplanBtn(false)
            refreshUI(.workPlan) {
                completion()
            }
          
        } else {
            reserCallModule(lastCheckinDate:  lastCheckinDate) {
            completion()
            }
        }
    }
    
    func toReturnLastCheckinDate() -> Date? {
        var lastCheckinDate : Date?
        
        if let windedUps = toReturnWindedupDates() {
            for windedUp in windedUps {
                if let windedUpDate = windedUp.statusDate {
                    lastCheckinDate = windedUpDate
                }
            }
        }
        return lastCheckinDate
        
    }
}
