//
//  TourPlanView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/01/24.
//

import Foundation
import UIKit
import FSCalendar
import CoreData

extension TourPlanView: PopOverVCDelegate {
    
    func logoutAction() {
        print("Log out")
    }
    
    func changePasswordAction() {
        print("Change password")
    }
    
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int) {
        if index == 0 {
            let modal = self.tempArrofPlan?[SelectedArrIndex]
            self.moveToMenuVC(modal?.rawDate ?? Date(), isForWeekOff: modal?.isForWeekoff, isforHoliday: false)
        }
        
        else if index == 1 {
            let modal = self.tempArrofPlan?[SelectedArrIndex]
            self.toRemoveSession(modal ?? SessionDetailsArr())
           // LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: false)
           // self.toToggleApprovalState(false)
        }
    }
    
    
}

extension TourPlanView {

    func toGetAllmonthData() {
        
    }
    
    
    enum Offsets {
        case all
        case current
        case next
        case previous
        case nextAndPrevious
        case currentAndNext
        case currentAndPrevious
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
    
    func getWeekoffDates(forMonth months: [Int], weekoffday: Int) -> [Date] {
        let currentDate = getFirstDayOfCurrentMonth() ?? Date()
        let calendar = Calendar.current
        
        var saturdays: [Date] = []
        
        for monthOffset in months {
            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) else {
                continue
            }
            
            let monthRange = calendar.range(of: .day, in: .month, for: targetDate)!
            
            for day in monthRange.lowerBound..<monthRange.upperBound {
                guard let date = calendar.date(bySetting: .day, value: day, of: targetDate) else {
                    continue
                }
                
                if calendar.component(.weekday, from: date) == weekoffday { // Sunday is represented as 1, so Saturday is 7
                    saturdays.append(date)
                }
            }
        }
        
        return saturdays
    }
}

extension TourPlanView {
   

    
    func toSetParams(_ arrOfPlan: [SessionDetailsArr], completion: @escaping (Result<SaveTPresponseModel, Error>) -> ())  {
        let appdefaultSetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["SFCode"] = appdefaultSetup.sfCode
        param["SFName"] = appdefaultSetup.sfName
        param["Div"] = appdefaultSetup.divisionCode
        var sessions = [JSON]()
        
        arrOfPlan.enumerated().forEach { index, allDayPlans in
            allDayPlans.sessionDetails?.enumerated().forEach { sessionIndex, session in
                _ = [String: Any]()
                var index = String()
                if sessionIndex == 0 {
                    index = ""
                } else {
                    index = "\(sessionIndex + 1)"
                }
                
                var drIndex = String()
                if sessionIndex == 0 {
                    drIndex = "_"
                } else if sessionIndex == 1{
                    drIndex = "_two_"
                } else if sessionIndex == 2 {
                    drIndex = "_three_"
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                let date =  dateFormatter.string(from:  allDayPlans.rawDate)
                let dateArr = date.components(separatedBy: " ") //"1 Nov 2023"
                dateFormatter.dateFormat = "EEEE"
                let day = dateFormatter.string(from: allDayPlans.rawDate)
                param["Yr"] = dateArr[2]//2023
               // param["Day"] =  dateArr[0]//1
               // param["Tour_Year"] = dateArr[2] // 2023
               // param["tpmonth"] = dateArr[1]// Nov
                param["tpday"] = day// Wednesday
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let dayNo = dateFormatter.string(from: allDayPlans.rawDate)
                let anotherDateArr = dayNo.components(separatedBy: "/") // MM/dd/yyyy - 09/12/2018
                param["dayno"] = anotherDateArr[1] // 11
              //  param["Tour_Month"] = anotherDateArr[0]// 11
                param["Mnth"] = anotherDateArr[0]
                let tpDtDate = dayNo.replacingOccurrences(of: "/", with: "-")
                param["TPDt"] =  tpDtDate//2023-11-01 00:00:00
                param["FWFlg\(index)"] = session.FWFlg
                param["HQCodes\(index)"] = session.HQCodes
                param["HQNames\(index)"] = session.HQNames
                param["WTCode\(index)"] = session.WTCode
                param["WTName\(index)"] = session.WTName
                param["chem\(drIndex)code"] = session.chemCode
                param["chem\(drIndex)name"] = session.chemName
                param["ClusterCode\(index)"] = session.clusterCode
                param["ClusterName\(index)"] = session.clusterName
                param["Dr\(drIndex)Code"] = session.drCode
                param["Dr\(drIndex)Name"] = session.drName
                param["jwCodes\(index)"] = session.jwCode
                param["jwNames\(index)"] = session.jwName
                
                if sessionIndex == 0 {
                    param["Stockist\(drIndex)Name"] = session.stockistName
                    param["Stockist\(drIndex)Code"] = session.stockistCode
                } else  {
                    param["Stockist\(drIndex)code"] = session.stockistCode
                    param["StockistName\(index)"] = session.stockistName
                }
              
                param["DayRemarks\(index)"] = session.remarks
            }
            param["Change_Status"] = "1"
            param["submittedTime"] = "\(Date())"
            param["Mode"] = "iOS-Edet"
            param["Entry_mode"] = "iOS-Edet"
            param["Approve_mode"] = ""
            param["Approved_time"] = ""
            param["app_version"] = LocalStorage.shared.getString(key: .AppVersion)
            
            sessions.append(param)
        }
        dump(sessions)
        
        
        let jsonDatum = ObjectFormatter.shared.convertJsonArr2Data(json: sessions)
        
//        var jsonDatum = Data()
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: sessions, options: [])
//            jsonDatum = jsonData
//            // Convert JSON data to a string
//            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
//                print(tempjsonString)
//
//            }
//
//
//        } catch {
//            print("Error converting parameter to JSON: \(error)")
//        }
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
       
        tourplanVM?.uploadTPmultipartFormData(params: toSendData, api: .saveTP, paramData: param) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(.success(response))
                dump(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                
                completion(.failure(error))
            }
        }
    }
    


    
}

class TourPlanView: BaseView {
    
    var sessionResponse: SessionResponseModel?
    
    //MARK: - Outlets
    ///  common
    @IBOutlet var overAllContentsHolder: UIView!
    
    @IBOutlet var calenderHolderView: UIView!
    
    @IBOutlet var tourPlanCalander: FSCalendar!
    
    @IBOutlet var tableElementsHolderView: UIView!
    
    @IBOutlet var bottomButtonsHolderView: UIView!
    
    @IBOutlet var worksPlanTable: UITableView!
    
    @IBOutlet var backHolder: UIView!
    
    @IBOutlet var planningLbl: UILabel!
    /// General page type outlets
    @IBOutlet var lblSendToApproval: UILabel!
    @IBOutlet var generalButtonsHolder: UIView!
    
    @IBOutlet var btnSendFOrApproval: UIButton!
    
    //MARK: if inactive: #282A3C (alpha 0.1)
    
    @IBOutlet var titleHolder: UIView!
    
    /// SessionType outlets
    @IBOutlet var sessionTypeButtonsHolderView: UIView!
    @IBOutlet var addSessionTapView: UIView!
    @IBOutlet var sessionTypeSaveTapView: UIView!
    
    
    /// ClusterType outlets
    @IBOutlet var clusterTypeButtonsHolder: UIView!
    
    @IBOutlet var clusterTypeSaveTapView: UIView!
    @IBOutlet var clusterTypeClearTapView: UIView!
    
    @IBOutlet var calenderPrevIV: UIImageView!
    
    @IBOutlet var calenderNextIV: UIImageView!
    
    @IBOutlet var mainDateLbl: UILabel!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var tableTitle: UILabel!
    
    @IBOutlet var sessionTableHolderView: UIView!
    
    @IBOutlet var rejectionTitle: UILabel!
    
    @IBOutlet var rejectionReason: UILabel!
    
    @IBOutlet var rejectionVIew: UIView!
    
    @IBOutlet var rejectionVIewHeightconst: NSLayoutConstraint!
    
    
    @IBOutlet var syncView: UIView!
    
    @IBOutlet var syncIV: UIImageView!
    
    @IBOutlet var syncTitle: UILabel!
    
    @IBOutlet var syncVXview: UIVisualEffectView!
    
    
    
    //MARK: - Properties
    var selectedDate: String = ""
    var tourplanVC : TourPlanVC!
    var isNextMonth = false
    var isPrevMonth = false
    var isCurrentMonth = false
    var arrOfPlan : [SessionDetailsArr]?
    var tempArrofPlan: [SessionDetailsArr]?
    var tourplanVM: TourPlanVM?
    var  weeklyOff : Weeklyoff?
    var  holidays : [Holidays]?
   // var tableSetupmodel: TableSetupModel?
    var totalDays = Int()
    var filledDates = [Date]()
    var months = [String]()
    var weeklyOffDates = [String]()
    var weeklyOffRawDates = [Date]()
    var responseHolidaydates = [String]()
    var existingDates = [String]()
    var isRejected = Bool()
    private var currentPage: Date?
    var offsets: LocalStorage.Offsets = .all
    private lazy var today: Date = {
        return Date()
    }()
    //MARK: - View Lifecyle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.tourplanVC = baseVC as? TourPlanVC
       // toSetPagetype(ofType: .general)
       // setupUI()
    }
    
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.tourplanVC = baseVC as? TourPlanVC
       // tourplanVC.togetTableSetup()
        initialSetups()
        self.isHidden = false
    }
    
    func toPostDataToserver(_ isfromSync : Bool) {

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
        var  arrOfPlan = [SessionDetailsArr]()
        var tpArray =  [TourPlanArr]()

        AppDefaults.shared.eachDatePlan.tourPlanArr?.enumerated().forEach { index, eachDayPlan in
            tpArray.append(eachDayPlan)
        }
        tpArray.forEach({ tpArr in
            arrOfPlan = tpArr.arrOfPlan
        })


        let unSavedPlans = arrOfPlan.filter({ toFilterSessionsArr in
            toFilterSessionsArr.isDataSentToApi == false
        })

        var unsentIndices = [Int]()

        dump(unSavedPlans)
        if !(unSavedPlans.isEmpty ) {
            unsentIndices = unSavedPlans.indices.filter { unSavedPlans[$0].isDataSentToApi == false }
        }


        dump(unsentIndices)

        if unSavedPlans.count > 0 {
            self.toSendUnsavedObjects(unSavedPlans: unSavedPlans, unsentIndices: unsentIndices, isFromFirstLoad: true, isFromSync: isfromSync){_ in}
        } else {
            fetchDataFromServer(isfromSync)
        }

    }
    
    
    func fetchDataFromServer(_ isfromSync: Bool) {
        Shared.instance.showLoader(in: self)
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getall_tp"
        param["sfcode"] = "\(appsetup.sfCode!)"
        param["division_code"] = "\(appsetup.divisionCode!)"
        param["Rsf"] = "\(appsetup.sfCode!)"
        param["sf_type"] = "\(appsetup.sfType!)"
        param["Designation"] = "\(appsetup.dsName!)"
        param["state_code"] = "\(appsetup.stateCode!)"
        param["subdivision_code"] = "\(appsetup.subDivisionCode!)"
        

        let currentDate = Date()
        let calendar = Calendar.current

        // Get the current month and year components
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)

        // Convert the components to strings and add them to your parameters
        param["tp_month"] = "\(month),"
        param["tp_year"] = "\(year),"

      //  param["tp_month"] = "12,"
      //  param["tp_year"] = "2023,"


        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        
//        var jsonDatum = Data()
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
//            jsonDatum = jsonData
//            // Convert JSON data to a string
//            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
//                print(tempjsonString)
//
//            }
//
//
//        } catch {
//            print("Error converting parameter to JSON: \(error)")
//        }

        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum

       // {"tableName":"getall_tp","sfcode":"MR6028","division_code":"44,","Rsf":"MR6028","sf_type":"1","Designation":"MR","state_code":"41","subdivision_code":"170,","tp_month":"12,","tp_year":"2023,"}


      //  "{\"tableName\":\"gettpsetup\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"

        self.tourplanVC.getAllPlansData(toSendData, paramData: param) { result in
            switch result{
            case .success(let respnse):
                self.sessionResponse = respnse
                self.toMapAPIresponse { iscompleted in
                   if iscompleted {
                       
                      self.initialSetups()
                      
                       self.isHidden = false
                       
                       if isfromSync {
                           DBManager.shared.saveTPtoMasterData(modal: respnse) {_ in}
                           self.updateCalender()
                       } else {
                           self.setupBtnAfterSubmission()
                       }
                       
                    }
                }
                Shared.instance.removeLoader(in: self)
            case .failure( _):
                Shared.instance.removeLoader(in: self)
                self.isHidden = false
                self.initialSetups()
                self.toCreateToast("Failed connecting to server!")
            }
        }
    }
    
    func initialSetups() {
        self.tourplanVM = TourPlanVM()
        self.toSetPagetype(ofType: .general)
        self.setupUI()
        self.initViews()
    }
    
    
    func toCinfigureApprovalState(_ sessionDetail: SessionDetails) {
        // Handle Approval flow
        
        //  LocalStorage.shared.sentToApprovalModelArr = NSKeyedUnarchiver.unarchiveObject(withFile: SentToApprovalModelArr.ArchiveURL.path) as? [SentToApprovalModel] ?? [SentToApprovalModel]()
        do {
            // Read the data from the file URL
            let data = try Data(contentsOf:  SentToApprovalModelArr.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let approvalModel = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
                
                if let approvalModel = approvalModel as? SentToApprovalModelArr {
                    LocalStorage.shared.sentToApprovalModelArr = approvalModel.sentToApprovalModelArr
                } else {
                    print("unable to convert to SentToApprovalModelArr")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive SentToApprovalModelArr: Data is nil or incorrect class type")
           
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
        
        
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: LocalStorage.shared.sentToApprovalModelArr, requiringSecureCoding: false)
            try data.write(to: SentToApprovalModelArr.ArchiveURL, options: .atomic)
            print("Save successful")
        } catch {
            print("Unable to save: \(error)")
        }
        
    }
    
    func setupBtnAfterSubmission() {
        LocalStorage.shared.sentToApprovalModelArr.forEach { sentToApprovalModel in
            if sentToApprovalModel.date == self.toModifyDateAsMonth(date: self.currentPage ?? Date()) {
               
                
                if sentToApprovalModel.approvalStatus != "2" {
                    self.toToggleApprovalState(true, isRejected: false)
                } else if sentToApprovalModel.approvalStatus == "0" {
                    self.toToggleApprovalState(true, isRejected: false)
                  //self.toToggleApprovalState(true, isRejected: true)
                }
            }
        }
    }
    
    func toMapAPIresponse(completion: @escaping (Bool) -> Void) {

        var apiArrofSessions = [SessionDetails]()
        apiArrofSessions.append(contentsOf: (self.sessionResponse?.current ?? [SessionDetails]()))
        apiArrofSessions.append(contentsOf: (self.sessionResponse?.previous ?? [SessionDetails]()))
        apiArrofSessions.append(contentsOf: (self.sessionResponse?.next ?? [SessionDetails]()))


        var apiMnths : [Int] = []
      //  var currentMnths = [String]()
        
        
        if !(sessionResponse?.current.isEmpty ?? true) {
            let sessionResponseArr = sessionResponse?.current[0] ?? SessionDetails()
            apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
            toCinfigureApprovalState(sessionResponseArr)
        }
        
        if !(sessionResponse?.previous.isEmpty ?? true) {
            let sessionResponseArr = sessionResponse?.previous[0] ?? SessionDetails()
            apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
            toCinfigureApprovalState(sessionResponseArr)
        }
     
        if !(sessionResponse?.next.isEmpty ?? true) {
            let sessionResponseArr = sessionResponse?.next[0] ?? SessionDetails()
            apiMnths.append(Int(sessionResponseArr.mnth) ?? 1)
            toCinfigureApprovalState(sessionResponseArr)
        }
  
        
       let currentMnthRange = toGetcurrentNextPrevMonthNumbers()
        
        // Check if currentMnths contains all elements of apiMnths
        let containsAll = currentMnthRange.allSatisfy { apiMnths.contains(($0)) }

        if containsAll {
            print("currentMnths contains all elements of apiMnths.")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: true)
        } else {
            print("currentMnths does not contain all elements of apiMnths.")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: false)
           let missingIndices = findMissingMonths(apiMonths: apiMnths, currentMonthRange: currentMnthRange)
            self.offsets =   getOffsetType(for: missingIndices)
        }
        
        completion(true)
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
            return .all
        } else if Set(missingIndices) == Set([1]) {
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
    
    
    
    func monthWiseSeperationofSessions(_ date: Date) {
        

        let tocomparemonth = toGetMonth(date)
        var thisMonthPaln = [SessionDetailsArr]()

        arrOfPlan?.forEach({ plan in
            let month = toGetMonth(plan.rawDate ?? Date())
            if month == tocomparemonth {
                thisMonthPaln.append(plan)
            }
        })
        
        var uniquePlans = [String: SessionDetailsArr]() // Assuming `date` is String or can be cast to String
        thisMonthPaln.forEach { plan in
            uniquePlans[plan.date] = plan
        }
        
        thisMonthPaln = Array(uniquePlans.values)
      
        thisMonthPaln = thisMonthPaln.sorted(by: { $0.rawDate.compare($1.rawDate) == .orderedAscending })
        

        self.tempArrofPlan = thisMonthPaln
        
        DispatchQueue.main.async {
            self.worksPlanTable.delegate = self
            self.worksPlanTable.dataSource = self
            self.worksPlanTable.reloadData()
            self.tourPlanCalander.collectionView.reloadData()
        }

      //  let indexpath = IndexPath(row: 0, section: 0)
      //  worksPlanTable.scrollToRow(at: indexpath, at: .top, animated: false)
        
//        if filledDates.count == 3 {
 //           toEnableApprovalBtn(totaldate: filledDates, filleddate: arrOfPlan?.count ?? 0)
//        } else {
//
//                if months.isEmpty {
//                    months.append(toGetMonth(date))
//                    filledDates.append(date)
//                } else {
//                    if months.contains(toGetMonth(date)) {
//                    } else {
//                        months.append(toGetMonth(date))
//                        filledDates.append(date)
//                    }
//                }
//        }
       
        if !thisMonthPaln.isEmpty {
            if thisMonthPaln[0].changeStatus == "2" {
                isRejected = true
            } else {
                isRejected = false
            }
//            thisMonthPaln.forEach { aSessionArr in
//                if aSessionArr.changeStatus == "2" {
//
//                } else {
//
//                }
//            }
            
        }
        
        if isRejected {
           // var isTodisableApproval = true
            self.rejectionReason.text = thisMonthPaln[0].rejectionReason
            self.rejectionVIew.isHidden = false
            toConfigureDynamicHeader()
            
        } else {
            self.rejectionVIew.isHidden = true
            self.rejectionVIew.frame.size.height = 0
            worksPlanTable.reloadData()
        }
       
      
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
        LocalStorage.shared.sentToApprovalModelArr.forEach({ sentToApprovalmodal in
            if sentToApprovalmodal.date ==  toModifyDate(date: self.currentPage ?? Date()) {
                
                if thisMonthPaln[0].changeStatus == "1" {
                    sentToApprovalmodal.approvalStatus = "1"
                 
                } else if thisMonthPaln[0].changeStatus == "2" {
                    sentToApprovalmodal.approvalStatus =  "2"
                   
                } else   if  thisMonthPaln[0].changeStatus == "3" {
                    sentToApprovalmodal.approvalStatus = "3"
                   
                }
            }
        })
        
//        let initialsavefinish = NSKeyedArchiver.archiveRootObject( LocalStorage.shared.sentToApprovalModelArr, toFile: SentToApprovalModelArr.ArchiveURL.path)
//        if !initialsavefinish {
//            print("Error")
//        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: LocalStorage.shared.sentToApprovalModelArr, requiringSecureCoding: false)
            try data.write(to: SentToApprovalModelArr.ArchiveURL, options: .atomic)
            print("Save successful")
        } catch {
            print("Unable to save: \(error)")
        }
        
        toEnableApprovalBtn(totaldate: date, filleddate: thisMonthPaln.count, isRejected : isRejected)

    }

 
    
    
    func toEnableApprovalBtn( totaldate: Date, filleddate: Int, isRejected: Bool) {
        let setups = AppDefaults.shared.getAppSetUp()
        totalDays = 0
       // filledDates.forEach { date in

      //  }
        var isJoinedAtToggledMonth = true

        // Get the selected month from totaldate
        let selectedMonth = Calendar.current.component(.month, from: totaldate)
        // Convert setups.sfDCRDate to Date
        if let joiningDate = setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
        {
//        let joiningDateStr = "2024-09-12"
//       let joiningDate = joiningDateStr.toDate(format: "yyyy-MM-dd", timeZone: nil)
            // Get the month component of the joiningDate
            let joiningMonth = Calendar.current.component(.month, from: joiningDate)
            
            // Compare both months
            if selectedMonth == joiningMonth {
                isJoinedAtToggledMonth = true
            }
        }
        
        if !isJoinedAtToggledMonth {
            let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: totaldate)
        
                totalDays = totalDays + (range?.count ?? 30)
        
                print("Total days--->\(totalDays)----||")
        } else {
            // Calculate days from the joined date to the end of the month
            if let joiningDate = setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
            //
            //setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
            {
                // Get the last day of the month for totaldate
                if let endOfMonth = Calendar.current.dateInterval(of: .month, for: totaldate)?.end {
                    // Calculate the difference in days between joiningDate and the end of the month
                    let numberOfDays = Calendar.current.dateComponents([.day], from: joiningDate, to: endOfMonth).day ?? 0
                    totalDays += numberOfDays
                    print("Total days from joining date ---> \(totalDays) ---- ||")
                }
         }
        }

        
        
        
        if filleddate >= totalDays {
            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: true)
            self.planningLbl.text = "TP Planning completed / Submission Pending"
            toToggleApprovalState(true, isRejected: isRejected)
        } else {
            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: false)
            self.planningLbl.text = "Planning..."
            toToggleApprovalState(false, isRejected: isRejected)
        }
        
    }
    
    
//    func toEnableApprovalBtn(totaldate: [Date], filleddate: Int) {
//        totalDays = 0
//        filledDates.forEach { date in
//            let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)
//                totalDays = totalDays + (range?.count ?? 30)
//        }
//        print("Total days--->\(totalDays)----||")
//
//
//        if filleddate >= totalDays {
//            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: true)
//            self.planningLbl.text = "Planned"
//            toToggleApprovalState(true)
//        } else {
//            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: false)
//            self.planningLbl.text = "Planning..."
//            toToggleApprovalState(false)
//        }
//
//    }
    
    func toToggleApprovalState(_ isActive: Bool, isRejected: Bool) {
        var isMonthSent = Bool()
      
        var sentToApprovalData : SentToApprovalModel?
        LocalStorage.shared.sentToApprovalModelArr.forEach({ sentToApprovalmodal in
            if sentToApprovalmodal.date ==  toModifyDateAsMonth(date: self.currentPage ?? Date()) {
                
                
                if sentToApprovalmodal.approvalStatus == "1" || sentToApprovalmodal.approvalStatus == "3"  {
                    isMonthSent = true
                   // approvalStr = sentToApprovalmodal.approvalStatus
                    sentToApprovalData = sentToApprovalmodal
                } else if sentToApprovalmodal.approvalStatus == "0" {
                    isMonthSent = false
                  //  planningLbl.text = "Planning.."
                  //  generalButtonsHolder.backgroundColor = .appSelectionColor
                   // btnSendFOrApproval.isUserInteractionEnabled = false
                   // return
                }
            }
            
            
        })
        
   
        if  isRejected {
            planningLbl.text =  ApprovalStatus.rejected.rawValue
        } else if isMonthSent {
            planningLbl.text =  sentToApprovalData?.approvalStatus == "1" ? ApprovalStatus.submitted.rawValue :  sentToApprovalData?.approvalStatus == "2" ? ApprovalStatus.rejected.rawValue  : sentToApprovalData?.approvalStatus == "3" ? ApprovalStatus.approved.rawValue : "Planning.."
            //"Waiting for approval"
            
            
            
           // btnSendFOrApproval.titleLabel?.text = "Waiting for approval"
        } else {
            
        }
        
        if isRejected &&  isActive {
            generalButtonsHolder.backgroundColor = .appTextColor
            btnSendFOrApproval.isUserInteractionEnabled = true
        } else {
            if isActive && !isMonthSent {
                generalButtonsHolder.backgroundColor = .appTextColor
                btnSendFOrApproval.isUserInteractionEnabled = true
               
            } else {
                generalButtonsHolder.backgroundColor = .appSelectionColor
                btnSendFOrApproval.isUserInteractionEnabled = false
            }
        }
        

    }
    
    
    func toRemoveSession(_ sessionDetArr:  SessionDetailsArr) {

        
        toRemoveElement(isToremove: true, toRemoveSessionDetArr: sessionDetArr)
    }
    
    
//    
//    func toAppendWeeklyoffs(date: [String], rawDate: [Date], isHolidayDict: [String: Bool]) {
//        
//        AppDefaults.shared.eachDatePlan.weekoffsDates = rawDate
//        
////            let initialsavefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
////            if !initialsavefinish {
////                print("Error")
////            }
//        
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
//            try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
//            print("Save successful")
//        } catch {
//            print("Unable to save: \(error)")
//        }
//       // AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
//        do {
//            // Read the data from the file URL
//            let data = try Data(contentsOf: EachDatePlan.ArchiveURL)
//            
//            // Attempt to unarchive EachDatePlan directly
//            if let eachDatePlan = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) {
//                
//                if let aPlan = eachDatePlan as? EachDatePlan {
//                    AppDefaults.shared.eachDatePlan = aPlan
//                } else {
//                    print("unable to convert to EachDatePlan")
//                }
//            } else {
//                // Fallback to default initialization if unarchiving fails
//                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
//                AppDefaults.shared.eachDatePlan = EachDatePlan()
//            }
//        } catch {
//            // Handle any errors that occur during reading or unarchiving
//            print("Unable to unarchive: \(error)")
//            AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
//        }
//        dump(AppDefaults.shared.eachDatePlan)
//        
//        var includedSessionArr = [SessionDetailsArr]()
//        
//        if AppDefaults.shared.eachDatePlan.tourPlanArr.count > 0 {
//            
//            AppDefaults.shared.tpArry.arrOfPlan.removeAll()
//            
//            AppDefaults.shared.tpArry.arrOfPlan =  AppDefaults.shared.eachDatePlan.tourPlanArr[0].arrOfPlan
//            includedSessionArr = AppDefaults.shared.tpArry.arrOfPlan
//        }
//        
//        var  dates = [String]()
//        
//        includedSessionArr.forEach { SessionDetailsArr in
//            dates.append(SessionDetailsArr.date)
//        }
//        
//
//                AppDefaults.shared.eachDatePlan.weekoffsDates.enumerated().forEach { adateIndex, adate in
//                    
//                    
//                  //  let dateArray = [/* Your Date array */]
//                  //  let dateBoolDictionary = [Date: Bool](/* Your [Date: Bool] dictionary */)
//                    let aSessionDetArr = SessionDetailsArr()
//                    var isTrue = Bool()
//                    let dateStr = toModifyDate(date: adate)
//                    
//                    
//                    isHolidayDict.forEach { (key, value) in
//                        if key == dateStr && value == true {
//                            isTrue = true
//                        }
//                    }
//                
//
//                  
//                    
//                  // let isTrue = isHolidayDict[dateStr]
//
//                    let aSession = SessionDetail()
//                    
//                    aSession.isForFieldWork = false
//              
//
//                    
//                    if isTrue {
//                        
//                        self.holidays?.forEach({ aholiday in
//                            var toCompareStr = ""
//                            let dateString = aholiday.holiday_Date
//
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd"
//
//                            if let date = dateFormatter.date(from: dateString ?? "") {
//                                let outputFormatter = DateFormatter()
//                                outputFormatter.dateFormat = "d MMMM yyyy"
//                                
//                                let formattedString = outputFormatter.string(from: date)
//                                print(formattedString) // Output: "1 January 2023"
//                                toCompareStr = formattedString
//                            } else {
//                                print("Failed to convert string to Date.")
//                            }
//                            
//                            if toCompareStr == dateStr {
//                                aSession.WTCode = aholiday.wtcode
//                                //self.weeklyOff?.wtcode ?? ""
//                                aSession.WTName =  aholiday.wtname
//                            }
//                        })
//                        
//
//                        aSessionDetArr.isForWeekoff = false
//                        aSessionDetArr.isForHoliday = true
//                    } else {
//                        aSession.WTCode = self.weeklyOff?.wtcode ?? ""
//                        aSession.WTName = self.weeklyOff?.wtname ?? "Weekly off"
//                        aSessionDetArr.isForWeekoff = true
//                        aSessionDetArr.isForHoliday = false
//                    }
//                    
//            
//                    aSessionDetArr.date = toModifyDate(date: adate)
//                    aSessionDetArr.rawDate = adate
//                    
//                    aSessionDetArr.isDataSentToApi = false
//                    aSessionDetArr.sessionDetails.append(aSession)
//                    
//                    if !dates.contains(aSessionDetArr.date) {
//                        includedSessionArr.append(aSessionDetArr)
//                    }
//                    
//                   
//                }
//            
//
//            dump(includedSessionArr)
//           // let  temptpArray =  TourPlanArr()
//           // temptpArray.arrOfPlan = includedSessionArr
//             AppDefaults.shared.tpArry.arrOfPlan.removeAll()
//            AppDefaults.shared.tpArry.arrOfPlan.append(contentsOf: includedSessionArr)
//        if AppDefaults.shared.eachDatePlan.tourPlanArr.count == 0 {
//            AppDefaults.shared.eachDatePlan.tourPlanArr.append(AppDefaults.shared.tpArry)
//        } else {
//            AppDefaults.shared.eachDatePlan.tourPlanArr[0].arrOfPlan.removeAll()
//            AppDefaults.shared.eachDatePlan.tourPlanArr[0].arrOfPlan.append(contentsOf: includedSessionArr)
//        }
//   
//        
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
//            try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
//            print("Save successful")
//            DispatchQueue.main.async {
//                self.toLoadData()
//            }
//        } catch {
//            print("Unable to save: \(error)")
//        }
//        
////        let savefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
////        if !savefinish {
////            print("Error")
////         
////        } else {
////            DispatchQueue.main.async {
////                self.toLoadData()
////            }
////          
////        }
//    }
    
    
  

    func toGetMonth(_ date: Date)  -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    func toRemoveElement(isToremove: Bool?, toRemoveSessionDetArr:  SessionDetailsArr?) {
        
        var  temptpArray =  [TourPlanArr]()
        self.arrOfPlan?.enumerated().forEach({ sessionDetArrIndex ,sessionDetArr in
            if sessionDetArr.date == toRemoveSessionDetArr?.date {
                self.arrOfPlan?.remove(at: sessionDetArrIndex)
            }
        })
        AppDefaults.shared.eachDatePlan.tourPlanArr?.forEach {  eachDayPlan in
            temptpArray.append(eachDayPlan)
        }
        
        temptpArray.forEach({ tpArr in
            tpArr.arrOfPlan =  self.arrOfPlan
        })
        
        AppDefaults.shared.eachDatePlan.tourPlanArr = temptpArray
        
//        let savefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
//        if !savefinish {
//            print("Error")
//        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
            try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
            print("Save successful")
        } catch {
            print("Unable to save: \(error)")
        }
        toLoadData()
        
    }
    

    
    func toLoadData()  {
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
        self.arrOfPlan = [SessionDetailsArr]()
        var tpArray =  [TourPlanArr]()

        AppDefaults.shared.eachDatePlan.tourPlanArr?.enumerated().forEach { index, eachDayPlan in
            tpArray.append(eachDayPlan)
        }
        tpArray.forEach({ tpArr in
            self.arrOfPlan = tpArr.arrOfPlan
        })

        monthWiseSeperationofSessions(tourPlanCalander.currentPage)
    }
    
    func initViews() {

        syncView.addTap {
           // NotificationCenter.default.post(name: Notification.Name("synced"), object: nil)
            self.toPostDataToserver(true)
            //self.fetchDataFromServer(true)
            
        }
        
        backHolder.addTap {
            self.tourplanVC.navigationController?.popViewController(animated: true)
        }
        
        calenderPrevIV.addTap {
            self.moveCurrentPage(moveUp: false)
        }
        
        calenderNextIV.addTap {
            self.moveCurrentPage(moveUp: true)
            }
        
      

        
    }
    
    func toSendUnsavedObjects(unSavedPlans : [SessionDetailsArr], unsentIndices: [Int], isFromFirstLoad : Bool, isFromSync: Bool, completion: @escaping (Bool) -> Void) {
        if unSavedPlans.count > 0 {
            self.toSetParams(unSavedPlans ) {
                responseResult in
                switch responseResult {
                case .success(let responseJSON):
                    dump(responseJSON)
                    
                    //                    unsentIndices.forEach { index in
                    //                        unSavedPlans[index].isDataSentToApi = true
                    //                    }
                    
                    var temptpArray = [TourPlanArr]()
                    
                    AppDefaults.shared.eachDatePlan.tourPlanArr?.forEach {  eachDayPlan in
                        temptpArray.append(eachDayPlan)
                    }
                    
                    var temparrOfplan = [SessionDetailsArr]()
                    
                    temptpArray.forEach({ tpArr in
                        temparrOfplan = tpArr.arrOfPlan
                        //unSavedPlans//self.arrOfPlan
                    })
                    
                    var apiSentPlans = temparrOfplan.filter { ASessionDetailsArr in
                        ASessionDetailsArr.isDataSentToApi == true
                    }
                    
                    apiSentPlans.append(contentsOf: unSavedPlans)
                    
                    temparrOfplan = apiSentPlans
                    
                    temparrOfplan.forEach { plans in
                        plans.isDataSentToApi = true
                    }
                    
                    temptpArray.forEach({ tpArr in
                        tpArr.arrOfPlan = temparrOfplan
                        //unSavedPlans//self.arrOfPlan
                    })
                    
                    
                    
                    AppDefaults.shared.eachDatePlan.tourPlanArr = temptpArray
//                    let savefinish = NSKeyedArchiver.archiveRootObject(AppDefaults.shared.eachDatePlan, toFile: EachDatePlan.ArchiveURL.path)
//                    if !savefinish {
//                        print("Error")
//                    }
                    
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: AppDefaults.shared.eachDatePlan, requiringSecureCoding: false)
                        try data.write(to: EachDatePlan.ArchiveURL, options: .atomic)
                        print("Save successful")
                    } catch {
                        print("Unable to save: \(error)")
                    }
                    
                    // self.toLoadData()
                    if isFromFirstLoad {
                        self.fetchDataFromServer(isFromSync)
                        completion(true)
                    } else {
                        
                    }
                case .failure(_):
                    self.toCreateToast("The operation couldn’t be completed. Try again later")
                    if isFromFirstLoad {
                        self.initialSetups()
                        self.isHidden = false
                    }
                    completion(false)
                }
            }
        } else {
            //  self.initialSetups()
            self.toCreateToast("Already this month plans are submited for approval.")
        }
        
    }
    
    
    func toCheckWeatherWeeklyoffPosted(completion: @escaping (Bool) -> Void) {
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
        var  arrOfPlan = [SessionDetailsArr]()
        var tpArray =  [TourPlanArr]()
        
        AppDefaults.shared.eachDatePlan.tourPlanArr?.enumerated().forEach { index, eachDayPlan in
            tpArray.append(eachDayPlan)
        }
        tpArray.forEach({ tpArr in
            arrOfPlan = tpArr.arrOfPlan
        })
        
        
        let nonWeekoff = arrOfPlan.filter({ toFilterSessionsArr in
            toFilterSessionsArr.isForWeekoff == false
        })
        
        
        var unSavedPlans = [SessionDetailsArr]()
        
        if nonWeekoff.isEmpty {
            unSavedPlans = arrOfPlan.filter({ toFilterSessionsArr in
                toFilterSessionsArr.isDataSentToApi == false &&  toFilterSessionsArr.isForWeekoff == false
            })
        } else {
            unSavedPlans = arrOfPlan.filter({ toFilterSessionsArr in
                toFilterSessionsArr.isDataSentToApi == false
            })
        }
        
        
        
        var unsentIndices = [Int]()
        
        dump(unSavedPlans)
        if !(unSavedPlans.isEmpty ) {
            unsentIndices = unSavedPlans.indices.filter { unSavedPlans[$0].isDataSentToApi == false &&  !unSavedPlans[$0].isForWeekoff }
        }
        
        
        dump(unsentIndices)
        
        if unSavedPlans.count > 0 {
            self.toSendUnsavedObjects(unSavedPlans: unSavedPlans, unsentIndices: unsentIndices, isFromFirstLoad: true, isFromSync: false) {isCompleted in
                if isCompleted {
                    completion(true)
                }
            }
        } else {
            completion(true)
        }
    }
    
    
    func callApprovalApi() {
        Shared.instance.showLoader(in: self)
        let appdefaultSetup = AppDefaults.shared.getAppSetUp()
        let dateFormatter = DateFormatter()

        var param = [String: Any]()
        param["tableName"] = "tpsend_appr"
        param["sfcode"] = appdefaultSetup.sfCode
        param["SFName"] = appdefaultSetup.sfName
        param["division_code"] = appdefaultSetup.divisionCode
        param["Rsf"] = appdefaultSetup.sfCode
        param["Designation"] =  appdefaultSetup.dsName
        param["state_code"] =  appdefaultSetup.stateCode
        param["subdivision_code"] =  appdefaultSetup.subDivisionCode
        param["Change_Status"] = "1"
        let thisMonth = self.currentPage ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dayNo = dateFormatter.string(from: thisMonth)
        let anotherDateArr = dayNo.components(separatedBy: "/") // MM/dd/yyyy - 09/12/2018
        param["TPMonth"] = anotherDateArr[0] // 11
      //  param["Tour_Month"] = anotherDateArr[0]// 11
        param["TPYear"] = anotherDateArr[2]
        
        
        
        
    //{"tableName":"tpsend_appr","division_code":"1","SFName":"SATHISH MR 2","sfcode":"MR1932","TPMonth":"07","TPYear":"2023"}
        
// {"tableName":"tpsend_appr","DivCode":"1","SFName":"SATHISH MR 2","SF":"MR1932","TPMonth":"07","TPYear":"2023"}
        
       // {"tableName":"gettpdetail","sfcode":"MR1932","Month":"7","Year":"2023","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,"}
        
        dump(param)
        
        
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
//        var jsonDatum = Data()
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
//            jsonDatum = jsonData
//            // Convert JSON data to a string
//            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
//                print(tempjsonString)
//
//            }
//
//
//        } catch {
//            print("Error converting parameter to JSON: \(error)")
//        }
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
       
        tourplanVM?.uploadTPmultipartFormData(params: toSendData, api: .sendToApproval, paramData: param) { result in
            switch result {
            case .success(let response):
                Shared.instance.removeLoader(in: self)
                print(response)
                //completion(.success(response))
                if response.success ?? false {
                    self.toCreateToast("Submitted successfully")

                   // self.toPostDataToserver()
                    self.fetchDataFromServer(false)
                    
                } else {
                    
                }
                dump(response)
            case .failure(let error):
                Shared.instance.removeLoader(in: self)
                print(error.localizedDescription)
                self.toCreateToast("Please try again later!")
              // completion(.failure(error))
            }
        }
    }
    
    
    func sendToApproval() {
        
        toCheckWeatherWeeklyoffPosted() { isChecked in
            self.callApprovalApi()
        }
        

    }
    
    @IBAction func didTApSendToApproval(_ sender: UIButton) {
        
        sendToApproval()
//        let unSavedPlans = self.tempArrofPlan?.filter({ toFilterSessionsArr in
//            toFilterSessionsArr.isDataSentToApi == false
//        })
//
//        var unsentIndices = [Int]()
//
//        dump(unSavedPlans)
//        if !(unSavedPlans?.isEmpty ?? true) {
//             unsentIndices = unSavedPlans?.indices.filter { unSavedPlans?[$0].isDataSentToApi == false } ?? [Int]()
//        }
//
//
//        dump(unSavedPlans)
//
//        toSendUnsavedObjects(unSavedPlans: unSavedPlans ?? [SessionDetailsArr](), unsentIndices: unsentIndices, isFromFirstLoad: false)
        
        
        
    }
    
    
    func toDisableNextPrevBtn(enableprevBtn: Bool, enablenextBtn: Bool) {
        
        if enableprevBtn && enablenextBtn {
            calenderPrevIV.alpha = 1
            calenderPrevIV.isUserInteractionEnabled = true
            
            calenderNextIV.alpha = 1
            calenderNextIV.isUserInteractionEnabled = true
        } else  if enableprevBtn {
            calenderPrevIV.alpha = 1
            calenderPrevIV.isUserInteractionEnabled = true
            
            calenderNextIV.alpha = 0.3
            calenderNextIV.isUserInteractionEnabled = false
            
        } else if enablenextBtn {
            calenderPrevIV.alpha = 0.3
            calenderPrevIV.isUserInteractionEnabled = false
            
            calenderNextIV.alpha = 1
            calenderNextIV.isUserInteractionEnabled = true
        }
        
     
    }
    

    private func moveCurrentPage(moveUp: Bool) {
     
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1

      //  self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)

      
        if moveUp {
            var isToMoveindex: Int? = nil
            self.isNextMonth = true
            if isPrevMonth {
                self.isCurrentMonth = true
            }
            
            if isNextMonth && isCurrentMonth {
                isToMoveindex = 0
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
                isCurrentMonth = false
            } else {
                isToMoveindex = 1
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
            }
            
            if let nextMonth = calendar.date(byAdding: .month, value: isToMoveindex ?? 0, to: self.today) {
                  print("Next Month:", nextMonth)
                self.currentPage = nextMonth
                self.isPrevMonth = false
              }
        } else if !moveUp{
            // Calculate the previous month
            var isToMoveindex: Int? = nil
            self.isPrevMonth = true
            if isNextMonth {
                self.isCurrentMonth = true
            }
            
            if isPrevMonth && isCurrentMonth {
                isToMoveindex = 0
                isCurrentMonth = false
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
            } else {
                isToMoveindex = -1
                toDisableNextPrevBtn(enableprevBtn: false, enablenextBtn: true)
            }
            if let previousMonth = calendar.date(byAdding: .month, value: isToMoveindex ?? 0, to: self.today) {
                print("Previous Month:", previousMonth)
                self.currentPage = previousMonth
                self.isNextMonth = false
               
            }
        } else {
            if let currentMonth = calendar.date(byAdding: .month, value: 0, to: self.today) {
                print("Previous Month:", currentMonth)
                self.currentPage = currentMonth
               
            }
        }

        self.tourPlanCalander.setCurrentPage(self.currentPage!, animated: true)
        monthWiseSeperationofSessions(self.currentPage ?? Date())
    }
    
    /// Returns the amount of months from another date
    func months(fromdate: Date, todate: Date) -> Int {
         return Calendar.current.dateComponents([.month], from: fromdate, to: todate).month ?? 0
     }
    
    func cellRegistration() {
        worksPlanTable.register(UINib(nibName: "worksPlanTVC", bundle: nil), forCellReuseIdentifier: "worksPlanTVC")
        //tourPlanCalander.collectionView.register(UINib(nibName: "FSCalendarCVC", bundle: nil), forCellWithReuseIdentifier: "FSCalendarCVC")
    }
    
    
    func toLoadCalenderData() {
        tourPlanCalander.delegate = self
        tourPlanCalander.dataSource = self
        tourPlanCalander.reloadData()
    }
    
    func toCheckMonthVariations() -> Bool {
        
      // AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
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
        //MARK: - Added months
        
        var addedMonths = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        AppDefaults.shared.eachDatePlan.weekoffsDates.forEach { weeklyoffDates in
            addedMonths.append(dateFormatter.string(from: weeklyoffDates))
        }
        let uniqueSet = Set(addedMonths)
        addedMonths = Array(uniqueSet)
        
        //MARK: - Current months
        
        let currentMonths = getCurrentPreviousNextMonthStrings()
        
        
        let containsAllElements = currentMonths.allSatisfy { addedMonths.contains($0) }

        if containsAllElements {
            return true
        } else {
            return false
        }
    }
    
    private func updateCalender () {
        
        if let storedOffset = LocalStorage.shared.retrieveOffset() {
            print("Stored offset:", storedOffset)
            self.offsets = storedOffset
        } else {
            print("Offset not found.")
        }
        
       // self.offsets = LocalStorage.shared.getOffset(key: LocalStorage.LocalValue.offsets)
   //     let weeklyoffSetupArr = DBManager.shared.getWeeklyOff()
    //    self.weeklyOff = weeklyoffSetupArr[0]
//        let weekoffIndex = Int(self.weeklyOff?.holiday_Mode ?? "0")
//        let weekoffDates = getDatesForDayIndex(weekoffIndex ?? 0, numberOfMonths: 3)
        
      //  let holidaysSetupArr = DBManager.shared.getHolidays()
       // self.holidays = holidaysSetupArr
       
      //  responseHolidaydates.removeAll()
        

     //   self.holidays?.forEach({ aholiday in
        //    responseHolidaydates.append(aholiday.holiday_Date ?? "")
           
      //  })

      //  let isAlldatesAppended  = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.TPalldatesAppended)

//        if isAlldatesAppended {
//            
//            let dateString = self.responseHolidaydates
//
//            var holidayDates = [Date]()
//            var holidayDateStr = [String]()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            holidayDates.removeAll()
//            dateString.forEach { aDate in
//                if let date = dateFormatter.date(from: aDate) {
//                    // Now 'date' contains the Date object
//                    print(date)
//                    dateFormatter.dateFormat = "yyyy"
//                    let holidayYear = dateFormatter.string(from: date)
//                    let thisYear = dateFormatter.string(from: self.currentPage ?? Date())
//                    
//                    dateFormatter.dateFormat = "MMMM"
//                    
//                    let toRemoveMonth =  dateFormatter.string(from: date)
//                    
//                    if holidayYear == thisYear && toRemoveMonth != "January" {
//                        holidayDates.append(date)
//                    }
//                   
//                } else {
//                    print("Failed to convert string to Date.")
//                }
//            }
//            holidayDateStr.removeAll()
//            holidayDates.forEach { rawDate in
//                holidayDateStr.append(toModifyDate(date: rawDate))
//            }
//            var isHolidayDict = [String: Bool]()
//            holidayDates.forEach { aDate in
//                
//                let dateStr = toModifyDate(date: aDate)
//                
//                isHolidayDict[dateStr] = true
//            }
//            dump(isHolidayDict)
//            
//            
//            
//            let weekoffIndex = Int(self.weeklyOff?.holiday_Mode ?? "0") ?? 0
//            
//           var monthIndex : [Int] = []
//            
//            switch self.offsets {
//                
//            case .all:
//                monthIndex =  [-1, 0, 1]
//            case .current:
//                monthIndex =  [0]
//            case .next:
//                monthIndex =  [1]
//            case .previous:
//                monthIndex =  [-1]
//                
//            case .nextAndPrevious:
//                monthIndex =  [-1, 1]
//            case .currentAndNext:
//                monthIndex =  [0, 1]
//            case .currentAndPrevious:
//                monthIndex =  [-1, 0]
//            case .none:
//                monthIndex =  []
//            }
//            
//            let weekoffDates = getWeekoffDates(forMonths: monthIndex, weekoffday: weekoffIndex + 1)
//            
//           // let weekoffDates = getDatesForDayIndex(weekoffIndex + 1, self.offsets)
//            self.weeklyOffRawDates.append(contentsOf: weekoffDates)
//            weeklyOffDates.removeAll()
//            self.weeklyOffRawDates.forEach { rawDate in
//                weeklyOffDates.append(toModifyDate(date: rawDate))
//            }
//            weeklyOffRawDates.forEach { aWeekoffDate in
//                let aweekoffStrr = toModifyDate(date: aWeekoffDate)
//                isHolidayDict[aweekoffStrr] = false
//            }
//           
//            dump(isHolidayDict)
//            
//            holidayDates.forEach { aHoliday in
//                weeklyOffRawDates.append(aHoliday)
//            }
//            
//            holidayDateStr.forEach { aholidayStr in
//                weeklyOffDates.append(aholidayStr)
//            }
//            
//            
//            
//            toAppendWeeklyoffs(date: self.weeklyOffDates, rawDate: self.weeklyOffRawDates, isHolidayDict: isHolidayDict)
//        } else {
            toLoadData()
       // }
     

        
        self.selectedDate = ""
        tourPlanCalander.scrollEnabled = false
        tourPlanCalander.calendarHeaderView.isHidden = true
        tourPlanCalander.headerHeight = 0 // this makes some extra spacing, but you can try 0 or 1
        //tourPlanCalander.daysContainer.backgroundColor = UIColor.gray
        tourPlanCalander.rowHeight =  tourPlanCalander.height / 5
        tourPlanCalander.layer.borderColor = UIColor.appSelectionColor.cgColor
        tourPlanCalander.calendarWeekdayView.weekdayLabels.forEach { label in
            label.setFont(font: .bold(size: .BODY))
        }
        tourPlanCalander.layer.borderWidth = 1
        tourPlanCalander.layer.cornerRadius = 5
        tourPlanCalander.clipsToBounds = true
        tourPlanCalander.placeholderType = .none
        tourPlanCalander.calendarWeekdayView.backgroundColor = .appSelectionColor
        self.tourPlanCalander.scrollDirection = .horizontal
        self.tourPlanCalander.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        tourPlanCalander.adjustsBoundingRectWhenChangingMonths = true
        tourPlanCalander.delegate = self
        tourPlanCalander.dataSource = self
        tourPlanCalander.reloadData()
        mainDateLbl.text = toTrimDate(date: tourPlanCalander.currentPage , isForMainLabel: true)
    }
    
    
    

    func getCurrentPreviousNextMonthStrings() -> [String] {
        
        var months = [String]()
        
        let calendar = Calendar.current
        let currentDate = Date()

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"

        // Current month
        let currentMonthString = monthFormatter.string(from: currentDate)
        print("Current Month: \(currentMonthString)")
        months.append(currentMonthString)
        // Previous month
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            let previousMonthString = monthFormatter.string(from: previousMonth)
            print("Previous Month: \(previousMonthString)")
            months.append(previousMonthString)
            
        }

        // Next month
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            let nextMonthString = monthFormatter.string(from: nextMonth)
            print("Next Month: \(nextMonthString)")
            months.append(nextMonthString)
        }
        return months
    }
    
    //MARK: - Enum Page types
    /**
     Page types use enum to switch page types
     - note : set the page type by use of toSetPagetype function
     */
       
    enum pageTypes {
        case general
        case session
        case workType
        case cluster
        case edit
    }
    

    ///  Pagetypes use enum  to switch page types
    /// - Parameter pageType: use appropriate pageTypes enums
    func toSetPagetype(ofType pageType : pageTypes) {
        switch pageType {
            
        case .general:
            generalButtonsHolder.isHidden = false
            sessionTypeButtonsHolderView.isHidden = true
            clusterTypeButtonsHolder.isHidden = true
            
            
        case .session:
            generalButtonsHolder.isHidden = true
            sessionTypeButtonsHolderView.isHidden = false
            clusterTypeButtonsHolder.isHidden = true
            
            
        case .workType:
            generalButtonsHolder.isHidden = true
            sessionTypeButtonsHolderView.isHidden = true
            clusterTypeButtonsHolder.isHidden = true
            
            
        case .cluster:
            generalButtonsHolder.isHidden = true
            sessionTypeButtonsHolderView.isHidden = true
            clusterTypeButtonsHolder.isHidden = false
            
            
        case .edit:
            generalButtonsHolder.isHidden = true
            sessionTypeButtonsHolderView.isHidden = true
            clusterTypeButtonsHolder.isHidden = true
        }
    }
    
    func setupUI() {
        syncTitle.setFont(font: .medium(size: .BODY))
        syncTitle.textColor = .appLightPink
        syncVXview.backgroundColor = .appLightPink
        syncIV.tintColor = .appLightPink
        syncView.layer.cornerRadius = 5
        titleLbl.setFont(font: .bold(size: .BODY))
        mainDateLbl.setFont(font: .medium(size: .BODY))
        tableTitle.textColor = .appLightTextColor
        tableTitle.setFont(font: .bold(size: .SUBHEADER))
        planningLbl.setFont(font: .bold(size: .BODY))
        rejectionTitle.setFont(font: .bold(size: .BODY))
        rejectionReason.setFont(font: .bold(size: .BODY))
        rejectionVIew.layer.cornerRadius = 5
        btnSendFOrApproval.setTitle("Send to approval", for: .normal)

 
        
        btnSendFOrApproval.backgroundColor = .clear
        btnSendFOrApproval.tintColor = .appWhiteColor
       // titleHolder.elevate(2)
        titleHolder.backgroundColor = .appSelectionColor
        titleHolder.layer.cornerRadius = 5
        worksPlanTable.separatorStyle = .none
       
        cellRegistration()
        
        updateCalender()
       // calenderHolderView.elevate(2)
        calenderHolderView.layer.cornerRadius = 5

        bottomButtonsHolderView.layer.cornerRadius = 5
        generalButtonsHolder.layer.cornerRadius = 5
        
        //sessionTableHolderView.elevate(2)
        sessionTableHolderView.layer.cornerRadius = 5
      
    }
    
    
    func toConfigureDynamicHeader() {
        let tempHeader = self.getViewExactHeight(view: self.rejectionVIew)
        self.rejectionVIew.frame.size.height = tempHeader.frame.height
        worksPlanTable.reloadData()
    }
    
    func getViewExactHeight(view:UIView)->UIView {
       
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
    
    func toTrimDate(date : Date, isForMainLabel: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isForMainLabel == true ? "MMMM yyyy" : "dd"
        return dateFormatter.string(from: date)
    }
    
    
    func moveToMenuVC(_ date: Date, isForWeekOff: Bool?, isforHoliday: Bool?) {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let toCompareDate = dateFormatter.string(from: date )
          self.selectedDate =  self.toTrimDate(date: date)

          
        let menuvc = MenuVC.initWithStory(self, date, isForWeekOff: isForWeekOff, isForHoliday: isforHoliday)
                  self.tourplanVC.modalPresentationStyle = .custom

        // AppDefaults.shared.eachDatePlan = NSKeyedUnarchiver.unarchiveObject(withFile: EachDatePlan.ArchiveURL.path) as? EachDatePlan ?? EachDatePlan()
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
                Shared.instance.removeLoaderInWindow()
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive EachDatePlan: Data is nil or incorrect class type")
                AppDefaults.shared.eachDatePlan = EachDatePlan()
            }
        } catch {
            Shared.instance.removeLoaderInWindow()
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
            AppDefaults.shared.eachDatePlan = EachDatePlan() // Fallback to default initialization
        }
        dump(AppDefaults.shared.eachDatePlan)
  
//              AppDefaults.shared.eachDatePlan.tourPlanArr?.enumerated().forEach { index, eachDayPlan in
//                  eachDayPlan.arrOfPlan?.enumerated().forEach { index, sessions in
//                      if sessions.date == toCompareDate {
//                          menuvc.sessionDetailsArr = sessions
//                      }
//                  }
//              }
        if let tourPlanArr = AppDefaults.shared.eachDatePlan.tourPlanArr {
            for eachDayPlan in tourPlanArr {
                if let arrOfPlan = eachDayPlan.arrOfPlan {
                    if let sessions = arrOfPlan.first(where: { $0.date == toCompareDate }) {
                        menuvc.sessionDetailsArr = sessions
                        break
                    }
                }
            }
        }

        LocalStorage.shared.sentToApprovalModelArr.forEach({ sentToApprovalmodal in
            if sentToApprovalmodal.date ==  toModifyDateAsMonth(date: self.currentPage ?? Date()) {
                
                
                if sentToApprovalmodal.approvalStatus == "1" || sentToApprovalmodal.approvalStatus == "3"  {
                    menuvc.isSentForApproval = true
                }
            }
            
            
        })
    self.tourplanVC.navigationController?.present(menuvc, animated: true)
    }
}

extension TourPlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArrofPlan?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : worksPlanTVC = tableView.dequeueReusableCell(withIdentifier: "worksPlanTVC", for: indexPath) as! worksPlanTVC
        let modal =  self.tempArrofPlan?[indexPath.row]
        if modal?.date == "3 October 2024" {
            print("Maatikuchu")
        }
        
        cell.toPopulateCell(modal ?? SessionDetailsArr())
        cell.selectionStyle = .none
        cell.addTap {
            self.moveToMenuVC(modal?.rawDate ?? Date(), isForWeekOff: modal?.isForWeekoff, isforHoliday: modal?.isForHoliday)
        }
        
//        cell.optionsIV.addTap {
//            
//            
//            print("Tapped -->")
//            let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 2, height: 50), on: cell.optionsIV, onframe: CGRect(), pagetype: .TP)
//            vc.delegate = self
//            vc.selectedIndex = indexPath.row
//            self.tourplanVC.navigationController?.present(vc, animated: true)
////            self.toRemoveSession(modal ?? SessionDetailsArr())
////            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoEnableApproveBtn, value: false)
////            self.toToggleApprovalState(false)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var isForfieldWork = Bool()
        var isFieldWorkExist = [Bool]()
        let modal =  self.tempArrofPlan?[indexPath.row]
        var detailsArr = [[String]]()
        var jointCallstr = [String]()
        var headQuartersstr = [String]()
        var clusterstr  = [String]()
        var jointcallstr  = [String]()
        var doctorsstr  = [String]()
        var chemiststr  = [String]()
        var stockiststr = [String]()
        var unlistedDocstr = [String]()
        modal?.sessionDetails?.forEach({ session in
            if session.isForFieldWork ?? false{
                isFieldWorkExist.append(true)
                if  session.jwName != "" {
                    jointCallstr.append(session.jwName ?? "")
                  }
                if  session.HQCodes != "" {
                    headQuartersstr.append(session.HQCodes ?? "")
                  }
                if  session.clusterCode != "" {
                    clusterstr.append(session.clusterCode ?? "")
                  }
                if  session.jwCode != "" {
                    jointcallstr.append(session.jwCode ?? "")
                  }
                if  session.drCode != "" {
                    doctorsstr.append(session.drCode ?? "")
                  }
                if  session.chemCode != "" {
                    chemiststr.append(session.chemCode ?? "")
                  }
              if session.stockistCode != "" {
                  stockiststr.append(session.stockistCode ?? "")
              }
              if session.unListedDrCode != "" {
                  unlistedDocstr.append(session.unListedDrCode ?? "")
              }
            } else {
                isFieldWorkExist.append(false)
            }
   
            
        })
        
        isFieldWorkExist.forEach { workexist in
            if workexist {
                isForfieldWork = workexist
            }
        }
        
        if isForfieldWork {
//            if headQuartersstr.count > 0 {
//                detailsArr.append(headQuartersstr)
//            }
            if clusterstr.count > 0 {
                detailsArr.append(clusterstr)
            }
            
            if jointcallstr.count > 0 {
                detailsArr.append(jointcallstr)
        
            }
            
            if doctorsstr.count > 0 {
                detailsArr.append(doctorsstr)

            }
            
            if chemiststr.count > 0 {
                detailsArr.append(chemiststr)
            }
            
            if stockiststr.count > 0 {
                detailsArr.append(stockiststr)
            }
            
            if unlistedDocstr.count > 0 {
                detailsArr.append(unlistedDocstr)
            }
        }

        
       
        switch indexPath.row {
            ///  cgfloat value 80 mentioned here belongs to a content view in cell which holds date, options image and other label
         
            /// cgfloat value 80  mentioned here belongs to a collection view cell (if needed give10 points of paddin value)
//
//        case 0:
//
//             (2 * 75) + 80
//        case 1:
//            return 75 + 80
        default:
            if isForfieldWork {
                let size =  detailsArr.count > 5 ?  (2 * 75) + 80 : 75 + 80
                 return CGFloat(size)
            } else {
                return 80
            }
          
        }
    }
    
}
extension TourPlanView : FSCalendarDelegate, FSCalendarDataSource ,FSCalendarDelegateAppearance {
    

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("::>--Tapped-->::")
        print(date)
        let dateformatter = DateFormatter()
        let month = DateFormatter()
        dateformatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM dd, yyyy", options: 0, locale: calendar.locale)
        month.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print(calendar.currentPage)
        mainDateLbl.text = toTrimDate(date: calendar.currentPage , isForMainLabel: true)
        self.selectedDate = ""
        //"\(values.month!) \(values.year!)"
        //
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // let borderColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.25))
        let setups = AppDefaults.shared.getAppSetUp()
        let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        var isExist = Bool()
        //let joiningDateStr = "2024-09-12"
        let toCompareDate = dateFormatter.string(from: date)

        cell.addedIV.isHidden = true

        var isDateLesserThanJoiningDate = false
        if let joiningDate =  setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
        {
     //   let joiningDateStr = "2024-09-12"
   // let joiningDate = joiningDateStr.toDate(format: "yyyy-MM-dd", timeZone: nil)
            if date < joiningDate {
               // cell.isUserInteractionEnabled = false
              //  cell.contentHolderView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
                isDateLesserThanJoiningDate = true
                
            }

        }
        
        self.arrOfPlan?.forEach({ arrPlan in
            dump(arrPlan.date)
            if arrPlan.date == "1 January 2024" {
                print("<---Newyear--->")
            }
            if arrPlan.date ==  toCompareDate {
              
                isExist = true
                
            }
        })
        
        
        
        var isWeeklyoff = Bool()
        let currentDate = date  // Replace this with your desired date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: currentDate)
        if let weekday = components.weekday {
            // The `weekday` property returns the day of the week as an integer (1 to 7, where Sunday is 1).
            // To convert it to the range 0 to 6, you can use modulo arithmetic.
            let dayIndex = (weekday - calendar.firstWeekday + 6) % 7
            print("Day Index: \(dayIndex)")
            if self.weeklyOff?.holiday_Mode   == "\(dayIndex)" {
                isWeeklyoff = true

//                if weeklyOffDates.isEmpty {
//                    self.weeklyOffDates.append(toModifyDate(date: date))
//                    self.weeklyOffRawDates.append(date)
//                } else {
//                    if weeklyOffDates.contains(toModifyDate(date: date)) {
//
//                    } else {
//                        self.weeklyOffDates.append(toModifyDate(date: date))
//                        self.weeklyOffRawDates.append(date)
//                    }
//                }
            }
        } else {
            print("Failed to get the day of the week.")
        }

        //dump(self.weeklyOffRawDates)
        //dump(self.weeklyOffDates)
        var isForHoliday = Bool()
        
        cell.addedIV.isHidden = isExist || isForHoliday  ? false : true
       // cell.addedIV.tintColor = isExist ? UIColor.green : UIColor.red
        //|| isWeeklyoff || isForHoliday
        cell.customLabel.text = toTrimDate(date: date)
        cell.customLabel.textColor = .appTextColor
        cell.customLabel.setFont(font: .medium(size: .BODY))
        cell.customLabel.textColor = .appTextColor
       // cell.customLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.titleLabel.isHidden = true
        cell.shapeLayer.isHidden = true
       // cell.shapeLayer.frame = bounds
        cell.layer.borderColor = UIColor.appSelectionColor.cgColor
        cell.layer.borderWidth = 0.5
       // cell.layer.masksToBounds = true
      //  cell.layer.addSublayer(addExternalBorder())
        if selectedDate == cell.customLabel.text {
            cell.contentHolderView.backgroundColor = .appSelectionColor
        } else if isDateLesserThanJoiningDate {
            cell.contentHolderView.backgroundColor = .appSelectionColor
            cell.addedIV .isHidden = true
        }
        else {
            cell.contentHolderView.backgroundColor = .clear
        }
        

        cell.addTap { [weak self] in
            guard let welf = self else {return}
      
            if
                let joiningDate =  setups.sfDCRDate?.date.toDate(format: "yyyy-MM-dd HH:mm:ss", timeZone: nil)
            {
           // let joiningDateStr = "2024-09-12"
       // let joiningDate = joiningDateStr.toDate(format: "yyyy-MM-dd", timeZone: nil)
                //"yyyy-MM-dd HH:mm:ss"
                if date < joiningDate {
                    cell.isUserInteractionEnabled = false
                    welf.toCreateToast("Selected date is lesser than joining date.")
                    return
                }

            }
            
            welf.responseHolidaydates.forEach { aHolisayDate in
                if welf.toModifyDate(date: date, isForHoliday: true) == aHolisayDate {
                    isForHoliday = true

                }
            }
            welf.selectedDate =  welf.toTrimDate(date: date)
            welf.tourPlanCalander.collectionView.reloadData()
            
            welf.moveToMenuVC(date, isForWeekOff: isWeeklyoff, isforHoliday: isForHoliday)

        }
        
        return cell
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

}

extension TourPlanView: MenuResponseProtocol {
     func passProductsAndInputs(additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to implement")
    }
    

    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        print("Yet to implement")
    }
    
    func routeToView(_ view: UIViewController) {
        print("")
    }
    

    func callPlanAPI() {
        toLoadData()
        print("Called")
    }
    

}

