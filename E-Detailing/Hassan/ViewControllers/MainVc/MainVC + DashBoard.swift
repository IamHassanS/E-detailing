//
//  MainVC + DashBoard.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/06/24.
//

import Foundation
import CoreData
extension MainVC {
    
    
    func toAppendNonFieldWorks() {

        let addedCallDate =  Shared.instance.selectedDate
        
        let dateStr = addedCallDate.toString(format: "yyyy-MM-dd")
        
      //  self.homeDataArr.removeAll { $0.dcr_dt == dateStr  }
        
        var dbparam = [String: Any]()
        dbparam["FW_Indicator"] = "N"
        dbparam["Dcr_dt"] =  addedCallDate.toString(format: "yyyy-MM-dd HH:mm:ss")
        dbparam["month_name"] = addedCallDate.toString(format: "MMMM")
        dbparam["Mnth"] = addedCallDate.toString(format: "MM")
        dbparam["Yr"] =  addedCallDate.toString(format: "YYYY")
        dbparam["Dcr_flag"] = "1"
        dbparam["Trans_SlNo"] = ""
        dbparam["AMSLNo"] = ""
        var dbparamArr = [[String: Any]]()
        dbparamArr.append(dbparam)
        let masterData = DBManager.shared.getMasterData()
        var HomeDataSetupArray = [UnsyncedHomeData]()
        for (index,homeData) in dbparamArr.enumerated() {
                let contextNew = DBManager.shared.managedContext()
                let HomeDataEntity = NSEntityDescription.entity(forEntityName: "UnsyncedHomeData", in: contextNew)
                let HomeDataSetupItem = UnsyncedHomeData(entity: HomeDataEntity!, insertInto: contextNew)
                HomeDataSetupItem.setValues(fromDictionary: homeData)
                HomeDataSetupItem.index = Int16(index)
                HomeDataSetupArray.append(HomeDataSetupItem)
        }
        HomeDataSetupArray.forEach{ (type) in
            masterData.addToUnsyncedHomeData(type)
        }
        DBManager.shared.saveContext()

    }
    
    func toIntegrateChartView(_ type: ChartType, _ index: Int) {
        
        self.lineChatrtView.subviews.forEach { aAddedView in
            aAddedView.removeFromSuperview()
        }
        
        let ahomeLineChartView = HomeLineChartView()
        ahomeLineChartView.delegate = self
        ahomeLineChartView.allListArr = homeDataArr
        ahomeLineChartView.dcrCount = self.dcrCount[index]
        switch type {
            
        case .doctor:

            
            ahomeLineChartView.setupUI(self.doctorArr, avgCalls: self.totalFWCount)
            
        case .chemist:
            ahomeLineChartView.setupUI(self.chemistArr, avgCalls: self.totalFWCount)
            
        case .stockist:
            ahomeLineChartView.setupUI(self.stockistArr, avgCalls: self.totalFWCount)
            
        case .unlistedDoctor:
            ahomeLineChartView.setupUI(self.unlistedDocArr, avgCalls: self.totalFWCount)
            
        }
        
        
        ahomeLineChartView.viewController = self
        
        self.homeLineChartView = ahomeLineChartView
        
        dateInfoLbl.text = toTrimDate(date: selectedToday ?? Date() , isForMainLabel: true)
        lineChatrtView?.addSubview(homeLineChartView ?? HomeLineChartView())
        
    }
    
    func toSeperateDCR(istoAppend: Bool? = false) {
        
        homeDataArr = DBManager.shared.getHomeData()
        self.appendUnsyncedCalls()

        let totalFWs =  homeDataArr.filter { aHomeData in
            aHomeData.fw_Indicator == "F"
        }
        self.totalFWCount = totalFWs.count + self.unsyncedhomeDataArr.count
        
        if istoAppend ?? false {
            mergeCalls()
        }
        
        
        doctorArr =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "1"
        }
        
        chemistArr =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "2"
        }
        
        stockistArr =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "3"
        }
        
        
        unlistedDocArr =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "4"
        }
        
        cipArr =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "5"
        }
        
      hospitalArr   =  homeDataArr.filter { aHomeData in
            aHomeData.custType == "6"
        }
        
    }
    
    func appendUnsyncedCalls() {
        
        guard  let tempUnsyncedArr = DBManager.shared.geUnsyncedtHomeData() else{ return }
        self.unsyncedhomeDataArr =  tempUnsyncedArr

        
    }
    
    func mergeCalls() {

        for unsyncedHomeData in unsyncedhomeDataArr {
            let homeData = HomeData(context: self.context)
                  homeData.anslNo = unsyncedHomeData.anslNo
                  homeData.custCode = unsyncedHomeData.custCode
                  homeData.custName = unsyncedHomeData.custName
                  homeData.custType = unsyncedHomeData.custType
                  let unSyncedDate = unsyncedHomeData.dcr_dt?.toDate(format: "yyyy-MM-dd HH:mm:ss")
            
                  homeData.dcr_dt = unSyncedDate?.toString(format: "yyyy-MM-dd")
                  homeData.dcr_flag = unsyncedHomeData.dcr_flag
                  homeData.editflag = unsyncedHomeData.editflag
                  homeData.fw_Indicator = unsyncedHomeData.fw_Indicator
                  homeData.index = unsyncedHomeData.index
                  homeData.isDataSentToAPI = unsyncedHomeData.isDataSentToAPI
                  homeData.mnth = unsyncedHomeData.mnth
                  homeData.month_name = unsyncedHomeData.month_name
                  homeData.rejectionReason = unsyncedHomeData.rejectionReason
                  homeData.sf_Code = unsyncedHomeData.sf_Code
                  homeData.town_code = unsyncedHomeData.town_code
                  homeData.town_name = unsyncedHomeData.town_name
                  homeData.trans_SlNo = unsyncedHomeData.trans_SlNo
                  homeData.yr = unsyncedHomeData.yr
                  homeData.dayStatus = unsyncedHomeData.dayStatus
            
                  // Append the created HomeData object to homeDataArr
            
                  homeDataArr.append(homeData)
        }
    }
}
