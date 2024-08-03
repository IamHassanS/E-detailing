//
//  MenuVIew.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 10/01/24.
//


import Foundation
import UIKit
import CoreData
import Alamofire
extension MenuView : UITextViewDelegate {
    
}


extension MenuView {
    func toGetTourPlanResponse() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        self.sessionDetailsArr.date = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
        self.sessionDetailsArr.rawDate = self.menuVC.selectedDate ?? Date()
        dateFormatter.dateFormat = "EEEE"
        self.sessionDetailsArr.day = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        self.sessionDetailsArr.dayNo = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
        self.sessionDetailsArr.entryMode = ""
        self.sessionDetailsArr.rejectionReason = ""
        
        
        let aDaySessions = self.sessionDetailsArr
        
        
        // toCheckSessionInfo() returns unfilled sessions
        let filteredSessions = toCheckSessionInfo()
        
        //New func added
        
        if filteredSessions.isEmpty {
            aDaySessions.sessionDetails?.forEach { session in
                session.workType = nil
                session.headQuates = nil
                session.cluster = nil
                session.jointWork = nil
                session.listedDoctors = nil
                session.chemist = nil
                session.stockist = nil
                session.unlistedDoctors = nil
                if !(session.isForFieldWork ?? false) {
                    session.toRemoveValues()
                }
            }
            toAppendsessionDetails(aDaySessions: aDaySessions)
        } else {
            var sessionIndex = [Int]()
            filteredSessions.forEach { filteredsessions in
                aDaySessions.sessionDetails?.enumerated().forEach { daySessionIndex ,daySessions in
                    if filteredsessions.sessionName == daySessions.sessionName {
                        sessionIndex.append(daySessionIndex)
                    }
                }
                
            }
            
            toAlertCell(sessionIndex)
        }
        
    }
    
    struct NotfilledPlans {
        let planindex: Int
        let isValidated : Bool
    }
    
    func toCheckSessionInfo() -> [SessionDetail] {
        let aDaySessions = self.sessionDetailsArr
        
        let nonEmptySession =  aDaySessions.sessionDetails?.filter { session in
            session.WTCode != ""
        }
        
        if  aDaySessions.sessionDetails?.count != nonEmptySession?.count {
            self.toCreateToast("Please fill the required fields to save Plan")
            return  aDaySessions.sessionDetails?.filter { session in
                session.WTCode == ""
                
            } ?? [SessionDetail]()
        } else {
            let territoryNeededSessions = aDaySessions.sessionDetails?.filter { session in
                session.isToshowTerritory == true
            }
            
            
            if territoryNeededSessions?.count == 0 {
                //   return true
                return territoryNeededSessions ?? [SessionDetail]()
            } else {
                
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    
                }
                let territoryNotFilledSessions = territoryNeededSessions?.filter{ session in
                    // session.selectedHeadQuaterID.isEmpty  || session.selectedClusterID.isEmpty
                    if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                        session.selectedClusterID!.isEmpty
                    } else {
                        session.HQCodes == "" || session.selectedClusterID!.isEmpty
                    }
                   
                    
                }
                
                var subActivitySeected : Bool = true
                
                if territoryNotFilledSessions?.count == 0 {
                    
                    let otherFieldMandatorySessions = nonEmptySession?.filter { session in
                        session.isForFieldWork == true && tableSetup?.fw_meetup_mandatory == "0"
                    }
                    
                    otherFieldMandatorySessions?.forEach { session in
                        if self.isDocNeeded {
                            if session.selectedlistedDoctorsID?.count == 0{
                                self.toCreateToast("Please select doctor")
                                subActivitySeected = false
                            }
                        } else {
                            if session.selectedjointWorkID?.count == 0 && session.selectedlistedDoctorsID?.count == 0 && session.selectedchemistID?.count == 0 {
                                self.toCreateToast("Please fill any one of sub activity fields to save sessions")
                                subActivitySeected = false
                                
                            } else {
                                subActivitySeected = true
                                
                            }
                        }
                        
                        
                    }
                    if subActivitySeected {
                        return [SessionDetail]()
                    } else {
                        return otherFieldMandatorySessions ?? [SessionDetail]()
                    }
                    
                    //subActivitySeected
                } else {
                    self.toCreateToast("Please fill the HeadQuarters and cluster to save sessions")
                    return territoryNotFilledSessions ?? [SessionDetail]()
                }
            }

        }
    }
    
    func toValidateRequiredFields(_ sessions: SessionDetailsArr) -> Bool {
        return false
    }
    
    func toAppendsessionDetails(aDaySessions : SessionDetailsArr) {
        let appdefaultSetup = AppDefaults.shared.getAppSetUp()
        let tourPlanArr =  AppDefaults.shared.tpArry
        // var arrOfPlan = tourPlanArr.arrOfPlan
        tourPlanArr.Div = appdefaultSetup.divisionCode
        tourPlanArr.SFCode = appdefaultSetup.sfCode
        tourPlanArr.SFName = appdefaultSetup.sfName
        
        var wholeDatesSessionDetailsArr = [SessionDetailsArr]()
        
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
        if  AppDefaults.shared.eachDatePlan.tourPlanArr.isEmpty {
            
        } else {
            AppDefaults.shared.eachDatePlan.tourPlanArr.forEach { wholeMonthPlansArr in
                wholeDatesSessionDetailsArr.append(contentsOf: wholeMonthPlansArr.arrOfPlan)
                //= wholeMonthPlansArr.arrOfPlan
            }
            wholeDatesSessionDetailsArr.forEach { savedSessionDetArr in
                tourPlanArr.arrOfPlan?.append(savedSessionDetArr)
            }
        }
        
        tourPlanArr.arrOfPlan?.append(aDaySessions)
        var isRemoved = false
        var indices = [Int]()
        tourPlanArr.arrOfPlan?.enumerated().forEach { index , sessionDetArr in
            // if tourPlanArr.arrOfPlan?.count ?? 0 > index {
            if sessionDetArr.date == aDaySessions.date && aDaySessions.changeStatus == "True" {
                // tourPlanArr.arrOfPlan?.remove(at: index)
                indices.append(index)
                isRemoved = true
            } else {
                //  tourPlanArr.arrOfPlan.append(sessionDetailsArr)
            }
            //  }
            
            
        }
        if isRemoved {
            indices = indices.reversed()
            indices.forEach { toRemoveIndex in
                
                tourPlanArr.arrOfPlan?.remove(at: toRemoveIndex)
                
                
            }
            
            tourPlanArr.arrOfPlan.append(aDaySessions)
        }
        
        AppDefaults.shared.tpArry = tourPlanArr
        
        self.toSetParams(aDaySessions) { responseData in
            switch responseData {
                
            case .success(let response):
                if response.success ?? false {
                    aDaySessions.isDataSentToApi = true
                   // aDaySessions.changeStatus = "False"
                  //  aDaySessions.isSucessfullySubmited = true
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.TPalldatesAppended, value: true)
                    self.toCreateToast("Data uploaded to server successfully.")
                    self.saveObjecttoDevice()
                  
                } else {
                
                  //  aDaySessions.isSucessfullySubmited = false
                  //  self.saveObjecttoDevice()
                    aDaySessions.isDataSentToApi = false
                    self.toCreateToast("Error while uploading data to server please try again!")
                    self.saveObjecttoDevice()
                 
                }
                Shared.instance.removeLoader(in: self)
            case .failure(let error):
                print(error.localizedDescription)
                aDaySessions.isDataSentToApi = false
                self.saveObjecttoDevice()
                Shared.instance.removeLoader(in: self)
                self.toCreateToast("Error while uploading data to server please try again!")
             
            }
        }
        
    }
    
    
    
//    func toSaveObject(object: EachDatePlan) ->  EachDatePlan {
//        var savedobject: EachDatePlan?
//        do {
//            let archived = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
//            
//            let record = try NSKeyedUnarchiver.unarchivedObject(ofClass: EachDatePlan.self, from: archived)
//            print(record ?? EachDatePlan())
//           savedobject = record
//        } catch {
//            print(error)
//            
//        }
//        return savedobject ?? EachDatePlan()
//    }
    
    func saveObjecttoDevice() {
        let  arrOfPlan = AppDefaults.shared.tpArry.arrOfPlan ?? [SessionDetailsArr]()

        AppDefaults.shared.eachDatePlan.tourPlanArr.removeAll()
        
        
        AppDefaults.shared.tpArry.arrOfPlan = removeDuplicateElements(posts: arrOfPlan)

        AppDefaults.shared.eachDatePlan.tourPlanArr.append(AppDefaults.shared.tpArry)
        
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

        self.menuVC.menuDelegate?.callPlanAPI()
        self.hideMenuAndDismiss()
    }
    
    func removeDuplicateElements(posts: [SessionDetailsArr]) -> [SessionDetailsArr] {
        var uniquePosts = [SessionDetailsArr]()
        for post in posts {
            if !uniquePosts.contains(where: {$0.date == post.date }) {
                uniquePosts.append(post)
            }
        }
        return uniquePosts
    }
    
    
    func toSetParams(_ tourPlanArr: SessionDetailsArr, completion: @escaping (Result<SaveTPresponseModel, Error>) -> () ) {
        Shared.instance.showLoader(in: self)
        let appdefaultSetup = AppDefaults.shared.getAppSetUp()
        

        _ = self.menuVC.selectedDate
       // let dateArr = self.sessionDetailsArr.date?.components(separatedBy: " ") //"1 Nov 2023"
       // let anotherDateArr = self.sessionDetailsArr.dayNo?.components(separatedBy: "/") // MM/dd/yyyy - 09/12/2018
        var param = [String: Any]()
        param["SFCode"] = appdefaultSetup.sfCode
        param["SFName"] = appdefaultSetup.sfName
        param["Div"] = appdefaultSetup.divisionCode
        let dateFormatter = DateFormatter()
        tourPlanArr.sessionDetails?.enumerated().forEach { sessionIndex, session in
            // var sessionParam = [String: Any]()
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
           
            dateFormatter.dateFormat = "d MMMM yyyy"
            let date =  dateFormatter.string(from:  tourPlanArr.rawDate)
            let dateArr = date.components(separatedBy: " ") //"1 Nov 2023"
            dateFormatter.dateFormat = "EEEE"
            let day = dateFormatter.string(from: tourPlanArr.rawDate)
            param["Yr"] = dateArr[2]//2023
           // param["Day"] =  dateArr[0]//1
           // param["Tour_Year"] = dateArr[2] // 2023
           // param["tpmonth"] = dateArr[1]// Nov
            param["tpday"] = day// Wednesday
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            let dayNo = dateFormatter.string(from: tourPlanArr.rawDate)
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
            
            
            param["ClusterCode\(index)"] = session.clusterCode
            param["ClusterName\(index)"] = session.clusterName
            param["Dr\(drIndex)code"] = session.drCode
            param["Dr\(drIndex)name"] = session.drName
            param["JWCodes\(index)"] = session.jwCode
            param["JWNames\(index)"] = session.jwName
            
            
            if sessionIndex == 0 {
                param["Chem\(drIndex)Code"] = session.chemCode
                param["Chem\(drIndex)Name"] = session.chemName
                
                param["Stockist\(drIndex)Name"] = session.stockistName
                param["Stockist\(drIndex)Code"] = session.stockistCode
            } else  {
                param["Chem\(drIndex)code"] = session.chemCode
                param["Chem\(drIndex)name"] = session.chemName
                
                param["Stockist\(drIndex)code"] = session.stockistCode
                param["StockistName\(index)"] = session.stockistName
            }
            
//             param["Stockist\(drIndex)name"] = session.stockistName
//             param["Stockist\(drIndex)code"] = session.stockistCode
//            param["cip_code\(index)"] = session.unListedDrCode
//            param["cip_name\(index)"] = session.unListedDrName
            
            param["DayRemarks\(index)"] = session.remarks
        }
        
        
        let dateString = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let submittedtime = dateFormatter.string(from: dateString)
        
        param["submitted_time"] = submittedtime
        param["Mode"] = "iOS-Edet"
        param["Entry_mode"] = "iOS-Edet"
        param["Approve_mode"] = ""
        param["Approved_time"] = ""
        param["app_version"] = "N 1.6.9"
        
        let jsonDatum = ObjectFormatter.shared.convertJsonArr2Data(json: [param])
 
//        var jsonDatum = Data()
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: [param], options: [])
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
        
        toutplanVM?.uploadTPmultipartFormData(params: toSendData, api: .saveTP, paramData: param) { result in
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

class MenuView : BaseView{
    
    
    
    enum CellType: String {
        case edit
        case session
        case workType
        case WorkTypeInfo = "work Type"
        case cluster
        case headQuater
        case jointCall
        case listedDoctor = "Listed Doctor"
        case chemist = "Chemist"
        case chemistCategory = "Chemist Category"
        case stockist = "Stockist"
        case unlistedDoctor  = "Unlisted Doctor"
        case cip = "CIP"
        case hospitals = "Hospital"
        case doctorInfo
        case chemistInfo
        case stockistInfo
        case unlistedDoctorinfo
        case clusterInfo = "Cluster"
        case inputs = "Input"
        case product = "Product"
        case doctorVisit = "Doctor Visit"
        case holiday = "Holiday / Weekly off"
        case qualification
        case category
        case speciality
        case theraptic
        case feedback
        case competitors
        case leave
        case doctorClass = "Class"
      //  case FieldWork
       // case others
    }
    
    var menuVC :  MenuVC!
    //MARK: Outlets
    
    @IBOutlet var lblAddPlan: UILabel!
    @IBOutlet weak var sideMenuHolderView : UIView!
 
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var menuTable : UITableView!

    @IBOutlet weak var contentBgView: UIView!
  
    @IBOutlet weak var closeTapView: UIView!
    
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var selectionChevlon: UIImageView!
    
    @IBOutlet weak var selectTitleLbl: UILabel!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet var lblCLear: UILabel!
    
    @IBOutlet var lblSave: UILabel!
    
    @IBOutlet weak var clearview: UIView!
    @IBOutlet weak var addSessionView: UIView!
    
    @IBOutlet var tableHolderView: UIView!
    
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet var searchHolderView: UIView!
    
    @IBOutlet var searchTF: UITextField!
    
    @IBOutlet var searchHolderHeight: NSLayoutConstraint!
    
    @IBOutlet var typesTitleview: UIView!
    
    @IBOutlet var typesTitle: UILabel!
    
    @IBOutlet var typesTitleHeightConst: NSLayoutConstraint!
    
    @IBOutlet var selectAllView: UIView!
    
    @IBOutlet var selectAllIV: UIImageView!
    
    @IBOutlet var selectAllHeightConst: NSLayoutConstraint!
    
    @IBOutlet var noresultsView: UIView!
    
    @IBOutlet var titleSeperator: UIView!
    

    var isSearched: Bool = false
    var isSearchedWorkTypeSelected: Bool = false
    ///properties to hold array elements

    var selectedWorkTypeName : String = ""
    var cellType : CellType = .session
    var workTypeArr : [WorkType]?
    var headQuatersArr : [Subordinate]?
    var clusterArr : [Territory]?
    var jointWorkArr : [JointWork]?
    var listedDocArr : [DoctorFencing]?
    var chemistArr : [Chemist]?
    var stockistArr : [Stockist]?
    var unlisteedDocArr : [UnListedDoctor]?
    var toutplanVM: TourPlanVM?
    ///properties to hold session contents
    var sessionDetailsArr = SessionDetailsArr()
    var sessionDetail = SessionDetail()
    var tableSetup : TableSetup?
    ///properties to handle selection:
    var selectedSession: Int = 0
    var clusterIDArr : [String]?
    var isToalartCell = Bool()
    var alartcellIndex: Int = 0
    ///Height constraint constants
    let selectViewHeight: CGFloat = 50
    let searchVIewHeight: CGFloat = 50
    let typesTitleHeight: CGFloat = 35
    ///each field height 75
    var cellEditStackHeightforFW : CGFloat = 600
    var cellEditHeightForFW :  CGFloat = 670 + 100
    var cellStackHeightforFW : CGFloat = 600
    let cellStackHeightfOthers : CGFloat = 80
    var cellHeightForFW :  CGFloat = 670 + 100
    var cellHeightForOthers : CGFloat = 140 + 100
    var selectAllHeight : CGFloat = 50
    
    var cellEditHeightForOthers : CGFloat = 140
    var cellEditStackHeightfOthers : CGFloat = 80
    
    
    var isDocNeeded = false
    var isJointCallneeded = false
    var isChemistNeeded = false
    var isSockistNeeded = false
    var isnewCustomerNeeded = false
    var isHQNeeded = false
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.showMenu()
    }
    
    
    //MARK: - life cycle
    override func didLoad(baseVC: BaseViewController) {
        self.menuVC = baseVC as? MenuVC
        self.initView()
        self.initGestures()
        self.ThemeUpdate()
        setTheme()

    }
    
    func setTheme() {
        searchTF.textColor = .appTextColor
        titleSeperator.backgroundColor = .appSelectionColor
      //  [, countLbl, selectTitleLbl, typesTitle]
        
        
        countLbl.textColor = .systemGreen
        countLbl.setFont(font: .medium(size: .BODY))
        
        selectTitleLbl.textColor = .appTextColor
        selectTitleLbl.setFont(font: .medium(size: .BODY))
        
        lblAddPlan.textColor = .appTextColor
        lblAddPlan.setFont(font: .bold(size: .SUBHEADER))
        
        typesTitle.textColor = .appLightTextColor
        typesTitle.setFont(font: .medium(size: .SMALL))
        
       let bottomLbl = [lblAddPlan, lblCLear, lblSave]
        bottomLbl.forEach { label in
            
            label?.textColor =  label == lblSave ? .appWhiteColor :  .appTextColor
            label?.setFont(font: .bold(size: .BODY))
        }
    }
    
    //MARK: - function to initialize view
    func initView(){
        self.toutplanVM = TourPlanVM()
      // tableSetupAPI()
      //  self.tableSetup = NSKeyedUnarchiver.unarchiveObject(withFile: TableSetupModel.ArchiveURL.path) as? TableSetupModel ?? TableSetupModel()
      
        searchTF.delegate = self
        cellRegistration()
        loadrequiredDataFromDB()

        
        self.selectTitleLbl.text = "Select"
        self.countView.isHidden = true
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
  
       
        self.selectView.layer.borderWidth = 1
        self.selectView.layer.borderColor = UIColor.gray.cgColor
        self.selectView.layer.cornerRadius = 5
        
        addSessionView.layer.cornerRadius = 5
        addSessionView.layer.borderWidth = 1
        addSessionView.layer.borderColor = UIColor.systemGreen.cgColor
      //  addSessionView.elevate(2)
        
      //  saveView.elevate(2)
        saveView.layer.cornerRadius = 5
        
      //  clearview.elevate(2)
        clearview.layer.borderColor = UIColor.gray.cgColor
        clearview.layer.borderWidth = 1
        clearview.layer.cornerRadius = 5
      //  countView.elevate(2)
        countView.layer.borderColor = UIColor.systemGreen.cgColor
        countView.layer.borderWidth = 1
        countView.layer.cornerRadius = 5
        
        
        
      //  searchHolderView.elevate(2)
        searchHolderView.layer.borderColor = UIColor.lightGray.cgColor
        searchHolderView.layer.borderWidth = 0.5
        searchHolderView.layer.cornerRadius = 5
        
      //  self.menuTable.layoutIfNeeded()
      //  NotificationCenter.default.addObserver(self, selector: #selector(hideMenu), name: Notification.Name("hideMenu"), object: nil)
    }

    func toConfigureTableSetup() {
        
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
            self.isHQNeeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        } else {
            self.isHQNeeded = true
         
        }
        
        if tableSetup?.drNeed == "0" {
            self.isDocNeeded = true
        } else {
            self.isDocNeeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        }
        
        
        if  tableSetup?.chmNeed == "0" {
            self.isChemistNeeded = true
        } else {
            self.isChemistNeeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        }
 
        if   tableSetup?.jwNeed == "0" {
            self.isJointCallneeded = true
        } else {
            self.isJointCallneeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        }
        
        if tableSetup?.stkNeed == "0" {
            self.isSockistNeeded = true
        } else {
            self.isSockistNeeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        }
        
        if tableSetup?.cip_Need == "0" {
            //tableSetup.Cip_Need
            self.isnewCustomerNeeded = true
        } else {
            self.isnewCustomerNeeded = false
            cellStackHeightforFW =  cellStackHeightforFW - 75
            cellHeightForFW =  cellHeightForFW - 75
        }
    }
    
    func loadrequiredDataFromDB() {
        
        let tableSetupArr = DBManager.shared.getTableSetUp()
        
        self.tableSetup = tableSetupArr[0]
        
        self.menuVC.isWeekoffEditable =  self.tableSetup?.weeklyoff_Editable == "0" ? true : false
        
        toConfigureTableSetup()
        
        self.workTypeArr = DBManager.shared.getWorkType()
      
        self.headQuatersArr =  DBManager.shared.getSubordinate()
     
     //   self.clusterArr = DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
     
        self.jointWorkArr = DBManager.shared.getJointWork()
      
        self.listedDocArr = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
       
        self.chemistArr = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
         
        self.stockistArr =  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
        
        self.unlisteedDocArr = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
        
        toGenerateNewSession(self.menuVC.sessionDetailsArr != nil ? false : true)
    }
    
    func toGenerateNewSession(_ istoAddSession: Bool) {

        sessionDetail.workType = workTypeArr?.uniqued()
        sessionDetail.headQuates =  headQuatersArr?.uniqued()
        sessionDetail.cluster = clusterArr?.uniqued()
        sessionDetail.jointWork = jointWorkArr?.uniqued()
        sessionDetail.listedDoctors = listedDocArr?.uniqued()
        sessionDetail.chemist = chemistArr?.uniqued()
        sessionDetail.stockist = stockistArr?.uniqued()
        sessionDetail.unlistedDoctors = unlisteedDocArr?.uniqued()
        if self.menuVC.sessionDetailsArr != nil  {
            self.menuVC.sessionDetailsArr?.sessionDetails?.forEach({ eachsessiondetail in
                eachsessiondetail.workType = workTypeArr?.uniqued()
                eachsessiondetail.headQuates =  headQuatersArr?.uniqued()
                eachsessiondetail.cluster = clusterArr?.uniqued()
                eachsessiondetail.jointWork = jointWorkArr?.uniqued()
                eachsessiondetail.listedDoctors = listedDocArr?.uniqued()
                eachsessiondetail.chemist = chemistArr?.uniqued()
                eachsessiondetail.stockist = stockistArr?.uniqued()
                eachsessiondetail.unlistedDoctors = unlisteedDocArr?.uniqued()
                if self.menuVC.sessionDetailsArr?.changeStatus == "True" {
                    self.sessionDetailsArr.isDataSentToApi = false
                } else {
                    self.sessionDetailsArr.isDataSentToApi = true
                }
            })
            toAppendvaluestoSessions()
            self.sessionDetailsArr = self.menuVC.sessionDetailsArr ?? SessionDetailsArr()
            lblAddPlan.text = self.menuVC.sessionDetailsArr?.date ?? ""
            if  istoAddSession {
                sessionDetail = SessionDetail()
                self.sessionDetailsArr.sessionDetails?.append(sessionDetail)
                self.sessionDetailsArr.isDataSentToApi = false
                setPageType(.session, for: (self.sessionDetailsArr.sessionDetails?.count ?? 0) - 1)
                self.selectedSession =  self.sessionDetailsArr.sessionDetails?.count ?? 0 - 1
            } else {
                setPageType(.edit)
            }
          
        } else {
            sessionDetail = SessionDetail()
            self.sessionDetailsArr.sessionDetails?.append(sessionDetail)
            setPageType(.session, for: self.sessionDetailsArr.sessionDetails?.count ?? 0 - 1)
            self.selectedSession =  self.sessionDetailsArr.sessionDetails?.count ?? 0 - 1
        }
    }
    
    
    func toAppendvaluestoSessions() {
        var clusterCodes = [String]()
        var jointCallCodes = [String]()
        var chemistCodes = [String]()
        var stockistCodes = [String]()
        var drCodes = [String]()
        var unlistedDrCodes = [String]()
        self.menuVC.sessionDetailsArr?.sessionDetails.enumerated().forEach({ sessionDetailIndex, sessionDetail in
            
            guard let sessionDetails = menuVC.sessionDetailsArr?.sessionDetails,
                      sessionDetails.indices.contains(sessionDetailIndex) else {
                    print("Index out of range: \(sessionDetailIndex)")
                    return
                }
       
            if !(sessionDetail.clusterCode?.isEmpty ?? false) {
                clusterCodes = sessionDetail.clusterCode?.components(separatedBy: ",") ?? [String]()
                var selectedClusterID = [String: Bool]()
                    clusterCodes.forEach { code in
                        // Use the code as the key and set the value to true
                        selectedClusterID[code] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedClusterID = selectedClusterID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].clusterName = sessionDetail.clusterName?.replacingOccurrences(of: ",", with: ", ")
                
            }
     
            if   !(sessionDetail.jwCode?.isEmpty ?? false) {
                jointCallCodes = sessionDetail.jwCode?.components(separatedBy: ",") ?? [String]()
                var selectedjointCallCodeID = [String: Bool]()
                    jointCallCodes.forEach { codes in
                        selectedjointCallCodeID[codes] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedjointWorkID  = selectedjointCallCodeID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].jwName = sessionDetail.jwName?.replacingOccurrences(of: ",", with: ", ")
                    
            }
            

            
     
            if !(sessionDetail.chemCode?.isEmpty ?? false) {
                chemistCodes = sessionDetail.chemCode?.components(separatedBy: ",") ?? [String]()
                var selectedjointCallCodeID = [String: Bool]()
                    chemistCodes.forEach { codes in
                        selectedjointCallCodeID[codes] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedchemistID = selectedjointCallCodeID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].chemName = sessionDetail.chemName?.replacingOccurrences(of: ",", with: ", ")
                
            }


            
            
            if !(sessionDetail.stockistCode?.isEmpty ?? false) {
                
                stockistCodes = sessionDetail.stockistCode?.components(separatedBy: ",") ?? [String]()
                var selectedstockistCodeID = [String: Bool]()
                    stockistCodes.forEach { codes in
                        selectedstockistCodeID[codes] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedStockistID  = selectedstockistCodeID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].stockistName = sessionDetail.stockistName?.replacingOccurrences(of: ",", with: ", ")
            }
            
            
            if !(sessionDetail.drCode?.isEmpty ?? false) {
                
                drCodes = sessionDetail.stockistCode?.components(separatedBy: ",") ?? [String]()
                var selectedDrCodeID = [String: Bool]()
               // var selectedstockistCodeID = [String: Bool]()
                drCodes.forEach { codes in
                    selectedDrCodeID[codes] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedlistedDoctorsID = selectedDrCodeID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].drName = sessionDetail.drName?.replacingOccurrences(of: ",", with: ", ")
            }

            if !(sessionDetail.unListedDrCode?.isEmpty ?? false) {
                
                unlistedDrCodes = sessionDetail.unListedDrCode?.components(separatedBy: ",") ?? [String]()
                var selectedunlistedDrCodeID = [String: Bool]()
               // var selectedstockistCodeID = [String: Bool]()
                unlistedDrCodes.forEach { codes in
                    selectedunlistedDrCodeID[codes] = true
                       
                    }
                menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].selectedUnlistedDoctorsID = selectedunlistedDrCodeID
                    menuVC.sessionDetailsArr?.sessionDetails?[sessionDetailIndex].unListedDrName = sessionDetail.unListedDrName?.replacingOccurrences(of: ",", with: ", ")
            }

        })
        


    }
    
    
    func toRemoveSession(at index: Int) {
        if isForEdit()  {
            self.menuVC.sessionDetailsArr?.sessionDetails?.remove(at: index)
        } else {
            self.sessionDetailsArr.sessionDetails?.remove(at: index)
        }
        self.selectedSession = 0
        setPageType(self.cellType)
      
    }
    
    
    func isForEdit() -> Bool {
        if self.menuVC.sessionDetailsArr != nil  {
            return true
        } else {
            return false
        }
    }
    
    func isForWeekoff() -> Bool {
        if self.menuVC.isForWeekoff != false  {
            return true
        } else {
            return false
        }
    }
    
    func isForHoliday() -> Bool {
        if self.menuVC.isForHoliday != false  {
            return true
        } else {
            return false
        }
    }

    @objc func hideMenu() {
        self.hideMenuAndDismiss()
    }
    
    func ThemeUpdate() {

    }
    
    
    func cellRegistration() {
        
        menuTable.register(UINib(nibName: "SessionInfoTVC", bundle: nil), forCellReuseIdentifier: "SessionInfoTVC")
        
        menuTable.register(UINib(nibName: "SelectAllTypesTVC", bundle: nil), forCellReuseIdentifier: "SelectAllTypesTVC")
        
        menuTable.register(UINib(nibName: "EditSessionTVC", bundle: nil), forCellReuseIdentifier: "EditSessionTVC")
        
        menuTable.register(UINib(nibName: "RemarksEditSessionCell", bundle: nil), forCellReuseIdentifier: "RemarksEditSessionCell")
        
        menuTable.register(UINib(nibName: "WorkTypeCell", bundle: nil), forCellReuseIdentifier: "WorkTypeCell")
        
    }
    
    
    func isToAllowEdit() -> Bool {
        
        if self.menuVC.isSentForApproval {
            return true
        } else if self.menuVC.isWeekoffEditable  {
            return false
        }
        return false
    }
    
    func setPageType(_ pagetype: CellType, for session: Int? = nil, andfor sessions: [Int]? = nil) {
        switch pagetype {
            
        case .edit:
            self.cellType = .edit
            addSessionView.isHidden = true
            self.lblSave.text = "Edit"
            saveView.isHidden = isToAllowEdit()
                //menuVC.isWeekoffEditable ? false : true
            //false
            clearview.isHidden = true
            self.selectViewHeightCons.constant = 0
            self.searchHolderHeight.constant = 0
            typesTitleHeightConst.constant = 0
            self.selectView.isHidden = true
            searchHolderView.isHidden = true
            typesTitleview.isHidden = true
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitle.text = ""
            self.menuTable.separatorStyle = .none
            if isForEdit()  {
                if self.menuVC.sessionDetailsArr?.sessionDetails?.count == 0 {
                     
                } else {
                    
                    for i in 0...(self.menuVC.sessionDetailsArr?.sessionDetails?.count ?? 0) - 1 {
                        self.menuVC.sessionDetailsArr?.sessionDetails?[i].workType = self.workTypeArr
                    }
                    
                    
                }
                
              //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
            } else if isForWeekoff() || isForHoliday() {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                typesTitle.text = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
                typesTitleview.isHidden = false
                typesTitleHeightConst.constant = typesTitleHeight
            } else {
                if self.sessionDetailsArr.sessionDetails?.count == 0 {
                     
                } else {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                }
            }
          
            
        case .session:
            self.cellType = .session
            addSessionView.isHidden = false
            saveView.isHidden = menuVC.isWeekoffEditable ? false : true
            self.lblSave.text = "Save"
            clearview.isHidden = true
            self.selectViewHeightCons.constant = 0
            self.searchHolderHeight.constant = 0
            typesTitleHeightConst.constant = 0
            self.selectView.isHidden = true
            searchHolderView.isHidden = true
            typesTitleview.isHidden = true
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitle.text = ""
            self.menuTable.separatorStyle = .none
           if self.menuVC.sessionDetailsArr == nil {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "d MMMM yyyy"
               typesTitle.text = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
               typesTitleview.isHidden = false
               typesTitleHeightConst.constant = typesTitleHeight
           }
            
            if isForEdit()  {
               if self.menuVC.sessionDetailsArr?.sessionDetails?.count == 0 {
                    
               } else {
                   let count = self.menuVC.sessionDetailsArr?.sessionDetails?.count ?? 0
                   if count <= selectedSession {
                     
                   } else {
                       self.menuVC.sessionDetailsArr?.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                   }
                
               }
               
              //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
            } else if isForWeekoff() || isForHoliday() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                typesTitle.text = dateFormatter.string(from: self.menuVC.selectedDate ?? Date())
                typesTitleview.isHidden = false
                typesTitleHeightConst.constant = typesTitleHeight
            } else {
                if self.sessionDetailsArr.sessionDetails?.count == 0 {
                     
                } else {
                    let count = self.sessionDetailsArr.sessionDetails?.count ?? 0
                    if count <= selectedSession {
                     
                    } else {
                        self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    }
                    
                }
            }
           
      
            
        case .workType:
            self.cellType = .workType
            addSessionView.isHidden = true
            saveView.isHidden = true
            clearview.isHidden = true
            self.selectViewHeightCons.constant = selectViewHeight
            self.searchHolderHeight.constant =   searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitleview.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
            self.selectView.isHidden = false
            searchHolderView.isHidden = false
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitle.text = "Work Type"
            self.menuTable.separatorStyle = .singleLine
            if isForEdit()  {
                if self.menuVC.sessionDetailsArr?.sessionDetails?.count == 0 {
                     
                } else {
                    self.menuVC.sessionDetailsArr?.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                }
              //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
            } else {
                if self.sessionDetailsArr.sessionDetails?.count == 0 {
                     
                } else {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                }
            }
            
        
        case .cluster:
            self.cellType = .cluster
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant =   selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Cluster"
            typesTitleview.isHidden = false
            self.selectView.isHidden = false
            searchHolderView.isHidden = false
            self.countView.isHidden = true
//            selectAllView.isHidden = false
//            selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].cluster = self.clusterArr
        
        case .headQuater:
            self.cellType = .headQuater
            addSessionView.isHidden = true
            saveView.isHidden = true
            clearview.isHidden = true
            self.countView.isHidden = false
            self.selectViewHeightCons.constant =   selectViewHeight
            self.searchHolderHeight.constant =  searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Head Quarters"
            typesTitleview.isHidden = false
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
//            selectAllView.isHidden = false
//            selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].headQuates = self.headQuatersArr
       
        case .jointCall:
            self.cellType = .jointCall
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant =  selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Joint Call"
            typesTitleview.isHidden = false
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
//            selectAllView.isHidden = false
//            selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].jointWork = self.jointWorkArr
     
        case .listedDoctor:
            self.cellType = .listedDoctor
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant =  selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Listed doctor"
            typesTitleview.isHidden = false
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
//            selectAllView.isHidden = false
//            selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].listedDoctors = self.listedDocArr
        
        case .chemist:
            self.cellType = .chemist
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant = selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Chemist"
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
           // selectAllView.isHidden = false
            //selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitleview.isHidden = false
            
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].chemist = self.chemistArr
        case .stockist:
            self.cellType = .stockist
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant = selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "Stockist"
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
           // selectAllView.isHidden = false
            //selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitleview.isHidden = false
            
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].stockist = self.stockistArr
        case .unlistedDoctor:
            self.cellType = .unlistedDoctor
            addSessionView.isHidden = true
            saveView.isHidden = false
            clearview.isHidden = false
            self.countView.isHidden = false
            self.selectViewHeightCons.constant = selectViewHeight
            self.searchHolderHeight.constant = searchVIewHeight
            typesTitleHeightConst.constant = typesTitleHeight
            typesTitle.text = "New customers"
            searchHolderView.isHidden = false
            self.selectView.isHidden = false
            self.countView.isHidden = true
           // selectAllView.isHidden = false
            //selectAllHeightConst.constant = selectAllHeight
            selectAllView.isHidden = true
            selectAllHeightConst.constant = 0
            typesTitleview.isHidden = false
            
            self.menuTable.separatorStyle = .singleLine
            self.sessionDetailsArr.sessionDetails?[self.selectedSession].unlistedDoctors = self.unlisteedDocArr
        default:
            print("Yet to implement")
        }
        
        
   
        self.menuTable.isHidden = false
        self.searchTF.text = ""
        self.searchTF.placeholder = "Search"
        self.noresultsView.isHidden = true
        self.menuTable.reloadData()
        var targetRowIndexPath = IndexPath()
        
        if sessions == nil {
            lookupForSession()
        } else if sessions != nil {
            let sessionIndex = sessions?.count ?? 0 > 1 ? sessions?.first ?? 0 :  sessions?.last ?? 0
            self.alartcellIndex = sessionIndex
            targetRowIndexPath =  IndexPath(row: sessionIndex, section: 0)
        } else {
            lookupForSession()
        }
        
        func lookupForSession() {
            if session == nil {
                targetRowIndexPath =   IndexPath(row: 0, section: 0)
            } else {
                targetRowIndexPath =  IndexPath(row: session ?? 0, section: 0)
            }
        }

        if menuTable.indexPathExists(indexPath: targetRowIndexPath)
        {
            menuTable.scrollToRow(at: targetRowIndexPath, at: .top, animated: false)
        }
       
    }
    
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        
        hideMenuAndDismiss()
    }
    

    
    func initGestures(){
        closeTapView.addTap {
            self.hideMenuAndDismiss()
        }
        
        saveView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.endEditing(true)
            welf.isSearched = false
            switch welf.cellType {
            case .edit:
              //  self.menuTable.reloadData()
              //  self.toGetTourPlanResponse()
         
                welf.lblAddPlan.text = "Edit (\(welf.menuVC.sessionDetailsArr?.date ?? ""))"
          
                  //  lblAddPlan.text = self.menuVC.sessionDetailsArr?.date ?? ""
                
                
                welf.sessionDetailsArr.changeStatus = "True"
                welf.setPageType(.session)
            case .session:
               // self.menuTable.reloadData()
                welf.toGetTourPlanResponse()
            case .workType:
                if welf.sessionDetailsArr.sessionDetails![welf.selectedSession].isForFieldWork ?? false {
                    welf.setPageType(.session, for: welf.selectedSession)
                } else {
                    welf.setPageType(.session, for: welf.selectedSession)
                }
            case .cluster:
                welf.setPageType(.session, for: welf.selectedSession)
              
            case .headQuater:
                welf.setPageType(.session, for: welf.selectedSession)
               
            case .jointCall:
                welf.setPageType(.session, for: welf.selectedSession)
               
            case .listedDoctor:
               
                welf.setPageType(.session, for: welf.selectedSession)
                
            case .chemist:
                welf.setPageType(.session, for: welf.selectedSession)

          
            case .stockist:
                welf.setPageType(.session, for: welf.selectedSession)
            case .unlistedDoctor:
                welf.setPageType(.session, for: welf.selectedSession)
            default:
                print("Yet to implement")
            }
        }
        
        selectView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.endEditing(true)
            welf.isSearched = false
            switch welf.cellType {
            case .edit:
                break
            case .session:
                break
            case .workType:
                if welf.sessionDetailsArr.sessionDetails![welf.selectedSession].isForFieldWork ?? false {
                    welf.setPageType(.session, for: welf.selectedSession)
                } else {
                    welf.setPageType(.session, for: welf.selectedSession)
                }
            case .cluster:
                welf.setPageType(.session, for: welf.selectedSession)
            case .headQuater:
                welf.setPageType(.session, for: welf.selectedSession)
            case .jointCall:
                welf.setPageType(.session, for: welf.selectedSession)
            case .listedDoctor:
                welf.setPageType(.session, for: welf.selectedSession)
            case .chemist:
                welf.setPageType(.session, for: welf.selectedSession)
            case .stockist:
                welf.setPageType(.session, for: welf.selectedSession)
            case .unlistedDoctor:
                welf.setPageType(.session, for: welf.selectedSession)
            default:
                print("Yet to implement")
            }
           
        }
        
        addSessionView.addTap {
            
           // let totalcount = Int(self.tableSetup?.addsessionCount ?? "2")
           // let sessionCount = self.sessionDetailsArr.sessionDetails?.count
           // let isAllowedToadd = totalcount ?? 2 > sessionCount ?? 0 ? true : false
            let count = self.sessionDetailsArr.sessionDetails?.count
            if  count ?? 0 > 1
             {
              //  if !isAllowedToadd
//                if #available(iOS 13.0, *) {
//                    (UIApplication.shared.delegate as! AppDelegate).createToastMessage("Maximum plans added", isFromWishList: true)
//                } else {
//                  print("Maximum plan added")
//                }
                self.toCreateToast("Maximum plan added")
            } else {
                
                let sessionArr = self.toCheckSessionInfo()
                
                if sessionArr.isEmpty {
                    self.toGenerateNewSession(true)
                    self.isToalartCell = false
                } else {
                    self.toAlertCell()
                }
                
                //isToAddSession: true
                
            }
        }
        
        
    
         
        clearview.addTap { [weak self] in
            guard let welf = self else {return}
            switch welf.cellType {
                
            case .session:
                break
            case .workType:
                break
            case .cluster:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedClusterID?.removeAll()
              
            case .headQuater:
              //  sessionDetailsArr.sessionDetails?[selectedSession].selectedHeadQuaterID.removeAll()
                break
                
            case .jointCall:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedjointWorkID?.removeAll()
             
            case .listedDoctor:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedlistedDoctorsID?.removeAll()
               
            case .chemist:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedchemistID?.removeAll()
             
            case .edit:
                break
            case .stockist:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedStockistID?.removeAll()
            case .unlistedDoctor:
                welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedUnlistedDoctorsID?.removeAll()
            default:
                print("Yet to implement")
            }
            welf.menuTable.reloadData()
        }
        
        
        selectAllView.addTap { [self] in
            self.endEditing(true)
            
            self.selectAllIV.image =  self.selectAllIV.image ==  UIImage(named: "checkBoxEmpty") ? UIImage(named: "checkBoxSelected") : UIImage(named: "checkBoxEmpty")
            switch self.cellType {
              
            case .session:
                break
            case .workType:
                break
            case .cluster:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                 
                    self.sessionDetailsArr.sessionDetails?[selectedSession].cluster?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?[cluster.code ?? ""] = true
                     
                        
              
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].cluster?.enumerated().forEach({ (index, cluster) in
                   
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?.removeValue(forKey: cluster.code ?? "")
                    })
                  
                    
          
                }
      
                
            case .headQuater:
//                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
//
//                } else {
//
//                }
//                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
//
//                    self.sessionDetailsArr.sessionDetails?[selectedSession].headQuates?.enumerated().forEach({ index, cluster in
//                        sessionDetailsArr.sessionDetails?[selectedSession].selectedHeadQuaterID[cluster.id ?? ""] = true
//
//                    })
//                } else {
//                    self.sessionDetailsArr.sessionDetails?[selectedSession].headQuates?.enumerated().forEach({ (index, cluster) in
//                        sessionDetailsArr.sessionDetails?[selectedSession].selectedHeadQuaterID.removeValue(forKey: cluster.id ?? "")
//                    })
//
//                }
                break
            case .jointCall:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                  
                    self.sessionDetailsArr.sessionDetails?[selectedSession].jointWork?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?[cluster.code ?? ""] = true
                    
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].jointWork?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?.removeValue(forKey: cluster.code ?? "")
                    })
                   
                }
            case .listedDoctor:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                   // sessionDetailsArr.sessionDetails?[selectedSession].selectedDoctorsIndices.removeAll()
                    self.sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID?[cluster.code ?? ""] = true
                      //  sessionDetailsArr.sessionDetails?[selectedSession].selectedDoctorsIndices.append(index)
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID?.removeValue(forKey: cluster.code ?? "")
                    })
                
                }
            case .chemist:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].chemist?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID?[cluster.code ?? ""] = true
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].chemist?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID?.removeValue(forKey: cluster.code ?? "")
                    })
                }
            case .edit:
                break
            case .stockist:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].stockist?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID?[cluster.code ?? ""] = true
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].stockist?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID?.removeValue(forKey: cluster.code ?? "")
                    })
                }
            case .unlistedDoctor:
                if  self.selectAllIV.image ==  UIImage(named: "checkBoxSelected") {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID?[cluster.code ?? ""] = true
                    })
                } else {
                    self.sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?.enumerated().forEach({ (index, cluster) in
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID?.removeValue(forKey: cluster.code ?? "")
                    })
                }
            default:
                print("Yet to implement")
            }
            self.menuTable.reloadData()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
    
    func toAlertCell(_ index: [Int]? = nil) {
        isToalartCell = true
        setPageType(.session, andfor: index)
    }
    
    func toSetSelectAllImage(selectedIndexCount : Int) {
        var isToSelectAll: Bool = false
        switch self.cellType {
        case .session:
            break
        case .workType:
            break
        case .cluster:
            
            if isSearched {
                if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].cluster?.count ?? 0 {
                    isToSelectAll = true
                } else {
                    isToSelectAll = false
                }
            } else {
                if selectedIndexCount == self.clusterArr?.count ?? 0 {
                    isToSelectAll = true
                } else {
                    isToSelectAll = false
                }
            }
            
 
        case .headQuater:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].headQuates?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        case .jointCall:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].jointWork?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        case .listedDoctor:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        case .chemist:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].chemist?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        case .edit:
            break
        case .stockist:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].stockist?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        case .unlistedDoctor:
            if selectedIndexCount == sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?.count ?? 0 {
                isToSelectAll = true
            } else {
                isToSelectAll = false
            }
        default:
            print("Yet to implement")
        }
        if isToSelectAll {
            self.selectAllIV.image =  UIImage(named: "checkBoxSelected")
        } else {
            self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
        }
    }

    //MARK: UDF, gestures  and animations
    
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    
    func showMenu(){
       // let isRTL = isRTLLanguage
        let _ : CGFloat =  -1
        //isRTL ? 1 :
        let width = self.frame.width
        self.sideMenuHolderView.transform =  CGAffineTransform(translationX: width,y: 1)
        //isRTL ? CGAffineTransform(translationX: 1 * width,y: 0)  :
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = .identity
                        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
                       }, completion: nil)
    }

    func hideMenuAndDismiss(){
       
        let rtlValue : CGFloat = 1
      //  isRTL ? 1 :
        let width = self.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = CGAffineTransform(translationX: width * rtlValue,
                                                                              y: 0)
                        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                       }) { (val) in
            
                           self.menuVC.dismiss(animated: true, completion: nil)
        }
        
        
    }
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
      
        let _ : CGFloat =   -1
        //isRTL ? 1 :
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
        //        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
        case .began,.changed:
            guard  ( xMovement > 0)  else {return}
          //  ||  (xMovement < 0)
           // isRTL && || !isRTL &&
            
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        default:
            let velocity = gesture.velocity(in: self.sideMenuHolderView).x
            self.animationDuration = Double(velocity)
            if abs(xMovement) <= self.frame.width * 0.25{//show
                self.sideMenuHolderView.transform = .identity
                self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
            }else{//hide
                self.hideMenuAndDismiss()
            }
            
        }
    }
    
    

}
extension MenuView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.cellType {
        case .edit:
            return sessionDetailsArr.sessionDetails?.count ?? 0
            
        case .session:
            return sessionDetailsArr.sessionDetails?.count ?? 0
        
        case .workType:
            return sessionDetailsArr.sessionDetails?[selectedSession].workType?.count ?? 0
           
        case .cluster:
            return sessionDetailsArr.sessionDetails?[selectedSession].cluster?.count ?? 0
         
        case .headQuater:
            return sessionDetailsArr.sessionDetails?[selectedSession].headQuates?.count ?? 0
          
        case .jointCall:
            return sessionDetailsArr.sessionDetails?[selectedSession].jointWork?.count ?? 0
           
        case .listedDoctor:
            return sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?.count ?? 0
          
        case .chemist:
            return sessionDetailsArr.sessionDetails?[selectedSession].chemist?.count ?? 0

        case .stockist:
            return sessionDetailsArr.sessionDetails?[selectedSession].stockist?.count ?? 0
        case .unlistedDoctor:
            return sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?.count ?? 0
        default:
           return 0
        }
       
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType {
            
        case .edit:
            let cell : EditSessionTVC = tableView.dequeueReusableCell(withIdentifier:"EditSessionTVC" ) as! EditSessionTVC
            cell.selectionStyle = .none

            cell.lblName.text = "Plan \(indexPath.row + 1)"
           
            sessionDetailsArr.sessionDetails?[indexPath.row].sessionName = cell.lblName.text ?? ""
            
//            let selectedWorkTypeIndex = sessionDetailsArr.sessionDetails?[indexPath.row].selectedWorkTypeIndex
//            let searchedWorkTypeIndex = sessionDetailsArr.sessionDetails?[indexPath.row].searchedWorkTypeIndex
//
//            let selectedHQIndex = sessionDetailsArr.sessionDetails?[indexPath.row].selectedHQIndex
//            let searchedHQIndex = sessionDetailsArr.sessionDetails?[indexPath.row].searchedHQIndex
            
            let isForFieldWork = sessionDetailsArr.sessionDetails?[indexPath.row].isForFieldWork
            let modal = sessionDetailsArr.sessionDetails![indexPath.row]
            
     
            
            if  isForFieldWork ?? false  {
                
               
                // cellStackHeightforFW
                let cellViewArr : [UIView] = [cell.workTypeView, cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.unlistedDocView, cell.remarksView]
                
                cellViewArr.forEach { view in
                    switch view {
                    case cell.headQuatersView:
                        if modal.HQNames == "" {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        } else {
                            view.isHidden = false
                        }
                        
                       case cell.clusterView:
                        if !(modal.selectedClusterID?.isEmpty ?? true) {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
                        
                    case cell.jointCallView:
                        if !(modal.selectedjointWorkID?.isEmpty ?? true) {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
                        
                    case cell.listedDoctorView:
                        if !(modal.selectedlistedDoctorsID?.isEmpty ?? true)  {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
            
                    case cell.chemistView:
                        if !(modal.selectedchemistID?.isEmpty ?? true) {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
                        
                    case cell.stockistView:
                        if !(modal.selectedStockistID?.isEmpty ?? true) {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
                        
                    case cell.unlistedDocView:
                        if !(modal.selectedUnlistedDoctorsID?.isEmpty ?? true)  {
                            view.isHidden = false
                        } else {
                            cellEditStackHeightforFW =  cellEditStackHeightforFW - 75
                            cellEditHeightForFW =  cellEditHeightForFW - 75
                            view.isHidden = true
                        }
                        
                    case cell.remarksView:
                        if modal.remarks == "" ||  modal.remarks == nil {
                          
                            cell.remarksView.isHidden = true
                            cell.remarksHeightConst.constant = 0
                            cellEditHeightForFW =  cellEditHeightForFW - 100
                        } else {
                            cell.remarksDesc.text = modal.remarks
                            cell.remarksView.isHidden = false
                            cell.remarksHeightConst.constant = 100
                            
                        }
                        
                    default:
                        view.isHidden = false
                    }
                }
                cell.stackHeight.constant =  cellEditStackHeightforFW
            }  else {
                
                [cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.unlistedDocView].forEach { view in
                    view?.isHidden = true
                    // cell.workselectionHolder,
                }
                
                if modal.remarks == "" ||  modal.remarks == nil {
                    cell.remarksView.isHidden = true
                    cell.remarksHeightConst.constant = 0
                    cellEditHeightForOthers = 140
                    let height =  cellEditHeightForOthers
                    cellEditHeightForOthers = height
                } else {
                    cell.remarksDesc.text = modal.remarks
                    cell.remarksView.isHidden = false
                    cell.remarksHeightConst.constant = 100
                    cellEditHeightForOthers = 140
                    let height =  cellEditHeightForOthers + 100
                    cellEditHeightForOthers = height
                }
                cell.stackHeight.constant =  cellEditStackHeightfOthers
                
             
            }
            if isSearched {
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTName != "" {
                    cell.lblWorkType.text = sessionDetailsArr.sessionDetails?[indexPath.row].WTName
                    //sessionDetailsArr.sessionDetails?[indexPath.row].workType?[searchedWorkTypeIndex ?? 0].name
                } else {
                    cell.lblWorkType.text = "No info available"
                }
                
                if sessionDetailsArr.sessionDetails?[indexPath.row].HQNames != "" {
                    cell.lblHeadquaters.text = sessionDetailsArr.sessionDetails?[indexPath.row].HQNames
                    //sessionDetailsArr.sessionDetails?[indexPath.row].headQuates?[searchedHQIndex ?? 0].name
                } else {
                    cell.lblHeadquaters.text = "No info available"
                }
                
                
            } else {
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTName != "" {
                    cell.lblWorkType.text = sessionDetailsArr.sessionDetails?[indexPath.row].WTName
                    //sessionDetailsArr.sessionDetails?[indexPath.row].workType?[selectedWorkTypeIndex ?? 0].name
                } else {
                    cell.lblWorkType.text = "No info available"
                }
                
                
                
                if sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes != "" {
                    cell.lblHeadquaters.text = sessionDetailsArr.sessionDetails?[indexPath.row].HQNames
                    //sessionDetailsArr.sessionDetails?[indexPath.row].headQuates?[selectedHQIndex ?? 0].name
                } else {
                    cell.lblHeadquaters.text = "No info available"
                }
                
            }
            
            var clusterNameArr = [String]()
            var clusterCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.isEmpty ?? true) {
                let selectedHQ = sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes == "" ? LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) : sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes
                self.clusterArr = DBManager.shared.getTerritory(mapID: selectedHQ ?? "")
                self.clusterArr?.forEach({ cluster in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.forEach { key, value in
                        if key == cluster.code {
                            clusterNameArr.append(cluster.name ?? "")
                            clusterCodeArr.append(key)
                        }
                    }
                })
                cell.lblCluster.text = clusterNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterName =  clusterNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterCode = clusterCodeArr.joined(separator:",")
            } else {
                
                cell.lblCluster.text = "No info available"
            }
//            var headQuatersNameArr = [String]()
//            var headQuartersCodeArr = [String]()
//            if !sessionDetailsArr.sessionDetails?[indexPath.row].selectedHeadQuaterID.isEmpty {
//                self.headQuatersArr?.forEach({ headQuaters in
//                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedHeadQuaterID.forEach { key, value in
//                        if key == headQuaters.id {
//                            headQuatersNameArr.append(headQuaters.name ?? "")
//                            headQuartersCodeArr.append(key)
//                        }
//                    }
//                })
//
//                cell.lblHeadquaters.text = headQuatersNameArr.joined(separator:", ")
//                sessionDetailsArr.sessionDetails?[indexPath.row].HQNames =  cell.lblHeadquaters.text ?? ""
//                sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes = headQuartersCodeArr.joined(separator:", ")
//            } else {
//
//                cell.lblHeadquaters.text = "No info available"
//            }
            
            
            
            var jointWorkNameArr = [String]()
            var jointWorkCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedjointWorkID?.isEmpty ?? true) {
                self.jointWorkArr?.forEach({ work in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedjointWorkID?.forEach { key, value in
                        if key == work.code {
                            jointWorkNameArr.append(work.name ?? "")
                            jointWorkCodeArr.append(key)
                        }
                    }
                })
                cell.lblJointCall.text = jointWorkNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].jwName =  jointWorkNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].jwCode = jointWorkCodeArr.joined(separator:",")
            } else {
                
                cell.lblJointCall.text = "No info available"
            }
            
            
            var listedDoctorsNameArr = [String]()
            var listedDoctorsCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedlistedDoctorsID?.isEmpty ?? true)  {
                self.listedDocArr?.forEach({ doctors in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedlistedDoctorsID?.forEach { key, value in
                        if key == doctors.code {
                            listedDoctorsNameArr.append(doctors.name ?? "")
                            listedDoctorsCodeArr.append(key)
                        }
                    }
                })
                cell.lblListedDoctor.text = listedDoctorsNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].drName =  listedDoctorsNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].drCode = listedDoctorsCodeArr.joined(separator:",")
            } else {
                
                cell.lblListedDoctor.text = "No info available"
            }
            
            
            var chemistNameArr = [String]()
            var chemistCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedchemistID?.isEmpty ?? true) {
                self.chemistArr?.forEach({ chemist in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedchemistID?.forEach { key, value in
                        if key == chemist.code {
                            chemistNameArr.append(chemist.name ?? "")
                            chemistCodeArr.append(key)
                        }
                    }
                })
                cell.lblChemist.text = chemistNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].chemName =  chemistNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].chemCode = chemistCodeArr.joined(separator:",")
            } else {
                
                cell.lblChemist.text = "No info available"
            }
            
            
            var stockistNameArr = [String]()
            var stockistCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedStockistID?.isEmpty ?? true) {
                self.stockistArr?.forEach({ stockist in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedStockistID?.forEach { key, value in
                        if key == stockist.code {
                            stockistNameArr.append(stockist.name ?? "")
                            stockistCodeArr.append(key)
                        }
                    }
                })
                cell.lblstockist.text = stockistNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistName =  stockistNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistCode = stockistCodeArr.joined(separator:",")
            } else {
                
                cell.lblstockist.text = "No info available"
            }
            
            
            
            var unlistedDocNameArr = [String]()
            var unlistedDocCodeArr = [String]()
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedUnlistedDoctorsID?.isEmpty ?? true) {
                self.unlisteedDocArr?.forEach({ unlistDoc in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedUnlistedDoctorsID?.forEach { key, value in
                        if key == unlistDoc.code {
                            unlistedDocNameArr.append(unlistDoc.name ?? "")
                            unlistedDocCodeArr.append(key)
                        }
                    }
                })
                cell.lblunlistedDoc.text = unlistedDocNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrName =  unlistedDocNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrCode = unlistedDocCodeArr.joined(separator:",")
            } else {
                
                cell.lblunlistedDoc.text = "No info available"
            }
            
            
           return cell
            

        case .session:
            let cell : SessionInfoTVC = tableView.dequeueReusableCell(withIdentifier:"SessionInfoTVC" ) as! SessionInfoTVC
            cell.selectionStyle = .none
            if indexPath.row == alartcellIndex {
                if isToalartCell {
                    UIView.animate(withDuration: 1, delay: 0, animations: {
                        cell.overallContentsHolder.backgroundColor =  .red.withAlphaComponent(0.5)
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.animate(withDuration: 1, delay: 0, animations: {
                            cell.overallContentsHolder.backgroundColor = .appSelectionColor
                            self.isToalartCell = false
                        })
                    }
                }
            }


            
            cell.delegate = self
            cell.selectedIndex = indexPath.row
            if cell.selectedIndex == indexPath.row {
                cell.remarksTV.text = sessionDetailsArr.sessionDetails?[indexPath.row].remarks == "" ? "Type here.." : sessionDetailsArr.sessionDetails?[indexPath.row].remarks
               // sessionDetailsArr.sessionDetails?[selectedSession].remarks
                if  cell.remarksTV.text == "Type here.." {
                    cell.remarksTV.textColor =  UIColor.lightGray
                } else {
                    cell.remarksTV.textColor = UIColor.black
                }
            }

            if self.sessionDetailsArr.sessionDetails?.count == 1 {
                cell.deleteIcon.isHidden = true
            } else  {
                cell.deleteIcon.isHidden = false
            }
           
            cell.keybordenabled = false
            cell.lblName.text = "Plan \(indexPath.row + 1)"
            sessionDetailsArr.sessionDetails?[indexPath.row].sessionName = cell.lblName.text ?? ""
            
//            let selectedWorkTypeIndex = sessionDetailsArr.sessionDetails?[indexPath.row].selectedWorkTypeIndex
//            let searchedWorkTypeIndex = sessionDetailsArr.sessionDetails?[indexPath.row].searchedWorkTypeIndex
//
//            let selectedHQIndex = sessionDetailsArr.sessionDetails?[indexPath.row].selectedHQIndex
//            let searchedHQIndex = sessionDetailsArr.sessionDetails?[indexPath.row].searchedHQIndex
            
            let isForFieldWork = sessionDetailsArr.sessionDetails?[indexPath.row].isForFieldWork
            
          
            
            if  isForFieldWork ?? false  {
                cell.stackHeight.constant = cellStackHeightforFW
                
                let cellViewArr : [UIView] = [cell.workTypeView, cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.newCustomersView]
                
                cellViewArr.forEach { view in
                    switch view {
                        
                    case cell.headQuatersView:
                        if self.isHQNeeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
                        
                        
                    case cell.jointCallView:
                        if self.isJointCallneeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
                        
                    case cell.listedDoctorView:
                        if self.isDocNeeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
            
                    case cell.chemistView:
                        if self.isChemistNeeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
                        
                    case cell.stockistView:
                        if self.isSockistNeeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
                        
                    case cell.newCustomersView:
                        if self.isnewCustomerNeeded {
                            view.isHidden = false
                        } else {
                            view.isHidden = true
                        }
                        
                    default:
                        view.isHidden = false
                    }
                }
            }  else {
                cell.stackHeight.constant = cellStackHeightfOthers
                [cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.newCustomersView].forEach { view in
                    view?.isHidden = true
                    // cell.workselectionHolder,
                }
                
            }
            if isSearched {
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTName != "" {
                    cell.lblWorkType.text = sessionDetailsArr.sessionDetails?[indexPath.row].WTName
                    //sessionDetailsArr.sessionDetails?[indexPath.row].workType?[searchedWorkTypeIndex ?? 0].name
                } else {
                    cell.lblWorkType.text = "Select"
                }
                
                if sessionDetailsArr.sessionDetails?[indexPath.row].HQNames != "" {
                    cell.lblHeadquaters.text = sessionDetailsArr.sessionDetails?[indexPath.row].HQNames
                    //sessionDetailsArr.sessionDetails?[indexPath.row].headQuates?[searchedHQIndex ?? 0].name
                } else {
                    cell.lblHeadquaters.text = "Select"
                }
            } else {
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTName != "" {
                    cell.lblWorkType.text = sessionDetailsArr.sessionDetails?[indexPath.row].WTName
                    //sessionDetailsArr.sessionDetails?[indexPath.row].workType?[selectedWorkTypeIndex ?? 0].name
                } else {
                    cell.lblWorkType.text = "Select"
                }
                
                if sessionDetailsArr.sessionDetails?[indexPath.row].HQNames != "" {
                    cell.lblHeadquaters.text = sessionDetailsArr.sessionDetails?[indexPath.row].HQNames
                    //sessionDetailsArr.sessionDetails?[indexPath.row].headQuates?[selectedHQIndex ?? 0].name
                } else {
                    cell.lblHeadquaters.text = "Select"
                }
                
            }
//            if isSearched {
//                let model = sessionDetailsArr.sessionDetails?[indexPath.row]
//                if model?.searchedWorkTypeIndex == nil {
//                    model?.selectedClusterID =  [String : Bool]()
//                  //  mod?el.selectedHeadQuaterID =  [String : Bool]()
//                    model?.selectedjointWorkID = [String : Bool]()
//                    model?.selectedlistedDoctorsID = [String : Bool]()
//                    model?.selectedchemistID = [String : Bool]()
//                    model?.selectedStockistID = [String : Bool]()
//                    model?.selectedUnlistedDoctorsID = [String : Bool]()
//                }
//            } else {
//                let model = sessionDetailsArr.sessionDetails?[indexPath.row]
//                 if model?.selectedWorkTypeIndex == nil {
//                    model?.selectedClusterID =  [String : Bool]()
//                  //  mod?el.selectedHeadQuaterID =  [String : Bool]()
//                    model?.selectedjointWorkID = [String : Bool]()
//                    model?.selectedlistedDoctorsID = [String : Bool]()
//                    model?.selectedchemistID = [String : Bool]()
//                    model?.selectedStockistID = [String : Bool]()
//                    model?.selectedUnlistedDoctorsID = [String : Bool]()
//                }
//            }
    
            
           
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.isEmpty ?? true) {
                var clusterNameArr = [String]()
                var clusterCodeArr = [String]()
                var selectedHQ = String()
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    selectedHQ = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
                } else {
                    selectedHQ = sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes ?? ""
                }
               
                self.clusterArr = DBManager.shared.getTerritory(mapID: selectedHQ)
                self.clusterArr?.forEach({ cluster in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.forEach { key, value in
                        if key == cluster.code {
                            clusterNameArr.append(cluster.name ?? "")
                            clusterCodeArr.append(key)
                        }
                    }
                })
                cell.lblCluster.text = clusterNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterName =  clusterNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterCode = clusterCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].clusterCode = ""
                cell.lblCluster.text = "Select"
            }
            
//            if !sessionDetailsArr.sessionDetails?[indexPath.row].selectedHeadQuaterID.isEmpty {
//                var headQuatersNameArr = [String]()
//                var headQuartersCodeArr = [String]()
//                self.headQuatersArr?.forEach({ headQuaters in
//                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedHeadQuaterID.forEach { key, value in
//                        if key == headQuaters.id {
//                            headQuatersNameArr.append(headQuaters.name ?? "")
//                            headQuartersCodeArr.append(key)
//                        }
//                    }
//                })
//
//                cell.lblHeadquaters.text = headQuatersNameArr.joined(separator:", ")
//                sessionDetailsArr.sessionDetails?[indexPath.row].HQNames =  cell.lblHeadquaters.text ?? ""
//                sessionDetailsArr.sessionDetails?[indexPath.row].HQCodes = headQuartersCodeArr.joined(separator:", ")
//            } else {
//
//                cell.lblHeadquaters.text = "Select"
//            }
            
            
            
          
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedjointWorkID?.isEmpty ?? true) {
                var jointWorkNameArr = [String]()
                var jointWorkCodeArr = [String]()
                self.jointWorkArr?.forEach({ work in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedjointWorkID?.forEach { key, value in
                        if key == work.code {
                            jointWorkNameArr.append(work.name ?? "")
                            jointWorkCodeArr.append(key)
                        }
                    }
                })
                cell.lblJointCall.text = jointWorkNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].jwName =  jointWorkNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].jwCode = jointWorkCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].jwName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].jwCode = ""
                cell.lblJointCall.text = "Select"
            }
            
            
           
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedlistedDoctorsID?.isEmpty ?? true) {
                var listedDoctorsNameArr = [String]()
                var listedDoctorsCodeArr = [String]()
                self.listedDocArr?.forEach({ doctors in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedlistedDoctorsID?.forEach { key, value in
                        if key == doctors.code {
                            listedDoctorsNameArr.append(doctors.name ?? "")
                            listedDoctorsCodeArr.append(key)
                        }
                    }
                })
                cell.lblListedDoctor.text = listedDoctorsNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].drName =  listedDoctorsNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].drCode = listedDoctorsCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].drName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].drCode = ""
                cell.lblListedDoctor.text = "Select"
            }
           
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedchemistID?.isEmpty ?? true) {
                var chemistNameArr = [String]()
                var chemistCodeArr = [String]()
                self.chemistArr?.forEach({ chemist in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedchemistID?.forEach { key, value in
                        if key == chemist.code {
                            chemistNameArr.append(chemist.name ?? "")
                            chemistCodeArr.append(key)
                        }
                    }
                })
                cell.lblChemist.text = chemistNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].chemName =  chemistNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].chemCode = chemistCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].chemName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].chemCode = ""
                cell.lblChemist.text = "Select"
            }
            
            //Set label for Stockists
            
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedStockistID?.isEmpty ?? true) {
                var stockistNameArr = [String]()
                var stockistCodeArr = [String]()
                self.stockistArr?.forEach({ chemist in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedStockistID?.forEach { key, value in
                        if key == chemist.code {
                            stockistNameArr.append(chemist.name ?? "")
                            stockistCodeArr.append(key)
                        }
                    }
                })
                cell.lblStockist.text = stockistNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistName = stockistNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistCode = stockistCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].stockistCode = ""
                cell.lblStockist.text = "Select"
            }
            
            //Set label for new customers
            
            if !(sessionDetailsArr.sessionDetails?[indexPath.row].selectedUnlistedDoctorsID?.isEmpty ?? true) {
                var unlistedDocNameArr = [String]()
                var unlistedDocCodeArr = [String]()
                self.unlisteedDocArr?.forEach({ chemist in
                    sessionDetailsArr.sessionDetails?[indexPath.row].selectedUnlistedDoctorsID?.forEach { key, value in
                        if key == chemist.code {
                            unlistedDocNameArr.append(chemist.name ?? "")
                            unlistedDocCodeArr.append(key)
                        }
                    }
                })
                cell.lblNewCustomers.text = unlistedDocNameArr.joined(separator:", ")
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrName =  unlistedDocNameArr.joined(separator:",")
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrCode = unlistedDocCodeArr.joined(separator:",")
            } else {
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrName =  ""
                sessionDetailsArr.sessionDetails?[indexPath.row].unListedDrCode = ""
                cell.lblNewCustomers.text = "Select"
            }
            
            
            
            var isToproceed = false
            

            
            cell.clusterView.addTap { [weak self] in
                guard let welf = self else {return}
                welf.clusterArr = []
                let cacheIndex =  welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].selectedHQIndex
                let searchedCacheIndex = welf.sessionDetailsArr.sessionDetails?[welf.selectedSession].searchedHQIndex
                var id: String = ""
                if searchedCacheIndex != nil {
                    id = welf.headQuatersArr?[searchedCacheIndex ?? 0].id ?? ""
                } else {
                    id = welf.headQuatersArr?[cacheIndex ?? 0].id ?? ""
                }
                
                welf.clusterArr = DBManager.shared.getTerritory(mapID:  id)
                if welf.clusterArr?.count == 0 || welf.clusterArr == nil && LocalStorage.shared.getBool(key: .isConnectedToNetwork)  {
                   
                    print("Call api")
                    
                    welf.menuVC.toUpdateDCR(mapID: id) { _ in
                        
                        print("HQ identifier -- > \(id)" )
                        welf.clusterArr = DBManager.shared.getTerritory(mapID:  id);
                        
                        welf.toSetSelectAllImage(selectedIndexCount: welf.sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.count ?? 0)
                        if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""    {
                            isToproceed = true
                        }
                        if isToproceed {
                            welf.cellType = .cluster
                            welf.selectedSession = indexPath.row
                            welf.setPageType(.cluster)
                        } else {
                            welf.toCreateToast("Please select work type")
                        }
                      
                    }
                    
                } else {
                    welf.clusterArr = DBManager.shared.getTerritory(mapID:  id)
                    welf.toSetSelectAllImage(selectedIndexCount: welf.sessionDetailsArr.sessionDetails?[indexPath.row].selectedClusterID?.count ?? 0)
                    if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""    {
                        isToproceed = true
                    }
                    if isToproceed {
                        welf.cellType = .cluster
                        welf.selectedSession = indexPath.row
                        welf.setPageType(.cluster)
                    } else {
                        welf.toCreateToast("Please select work type")
                    }
                }
                
                

                
                
            }
            cell.workTypeView.addTap {
                
               
                    self.cellType = .workType
                    self.selectedSession = indexPath.row
                    self.setPageType(.workType)
           
                
                
            }
            
            cell.headQuatersView.addTap { [weak self] in
                guard let welf = self else {return}
//                [self] in
//                toSetSelectAllImage(selectedIndexCount: sessionDetailsArr.sessionDetails?[indexPath.row].selectedHeadQuaterID.count)
//                if sessionDetailsArr.sessionDetails?[indexPath.row].selectedWorkTypeIndex != nil  ||  sessionDetailsArr.sessionDetails?[indexPath.row].selectedWorkTypeIndex != nil  {
//                    isToproceed = true
//                }
//                if isToproceed {
//                    self.cellType = .headQuater
//                    self.selectedSession = indexPath.row
//
//                    self.setPageType(.headQuater)
//                } else {
//                    self.toCreateToast("Please select work type")
//                }
                if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""  {
                    isToproceed = true
                }
                if isToproceed {
                    welf.cellType = .headQuater
                    welf.selectedSession = indexPath.row
                    welf.setPageType(.headQuater)
                } else {
                    welf.toCreateToast("Please select work type")
                }
            }
            cell.jointCallView.addTap { [weak self] in
                guard let welf = self else {return}
               
                welf.toSetSelectAllImage(selectedIndexCount: welf.sessionDetailsArr.sessionDetails?[indexPath.row].selectedjointWorkID?.count ?? 0)
                if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""  {
                    isToproceed = true
                }
                if isToproceed {
                    welf.cellType = .jointCall
                    welf.selectedSession = indexPath.row
                    
                    welf.setPageType(.jointCall)
                } else {
                    welf.toCreateToast("Please select work type")
                }
                
                
            }
            cell.listedDoctorView.addTap { [self] in
                toSetSelectAllImage(selectedIndexCount: sessionDetailsArr.sessionDetails?[indexPath.row].selectedlistedDoctorsID?.count ?? 0)
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != "" {
                    isToproceed = true
                }
                if isToproceed {
                    self.cellType = .listedDoctor
                    self.selectedSession = indexPath.row
                    
                    self.setPageType(.listedDoctor)
                } else {
                    self.toCreateToast("Please select work type")
                }
                
                
                
            }
            cell.chemistView.addTap { [weak self] in
                guard let welf = self else {return}
                welf.toSetSelectAllImage(selectedIndexCount: welf.sessionDetailsArr.sessionDetails?[indexPath.row].selectedchemistID?.count ?? 0)
                if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""  {
                    isToproceed = true
                }
                if isToproceed {
                    welf.cellType = .chemist
                    welf.selectedSession = indexPath.row
                    welf.setPageType(.chemist)
                } else {
                    welf.toCreateToast("Please select work type")
                }
                
                
                
            }
            
            cell.stockistView.addTap { [self] in
                toSetSelectAllImage(selectedIndexCount: sessionDetailsArr.sessionDetails?[indexPath.row].selectedStockistID?.count ?? 0)
                if sessionDetailsArr.sessionDetails?[indexPath.row].WTCode  != "" {
                    isToproceed = true
                }
                if isToproceed {
                    self.cellType = .stockist
                    self.selectedSession = indexPath.row
                    self.setPageType(.stockist)
                } else {
                    self.toCreateToast("Please select work type")
                }
            }
            
            
            cell.newCustomersView.addTap { [weak self] in
                guard let welf = self else {return}
                welf.toSetSelectAllImage(selectedIndexCount: welf.sessionDetailsArr.sessionDetails?[indexPath.row].selectedUnlistedDoctorsID?.count ?? 0)
                if welf.sessionDetailsArr.sessionDetails?[indexPath.row].WTCode != ""  {
                    isToproceed = true
                }
                if isToproceed {
                    welf.cellType = .unlistedDoctor
                    welf.selectedSession = indexPath.row
                    welf.setPageType(.unlistedDoctor)
                } else {
                    welf.toCreateToast("Please select work type")
                }
            }
            
            //cell.deleteIcon.isHidden = false
            
            
            cell.deleteIcon.addTap {
                self.selectedSession = indexPath.row
                self.toRemoveSession(at: indexPath.row)
                tableView.reloadData()
            }
         
            return cell
            
        case .workType:
            let cell = tableView.dequeueReusableCell(withIdentifier:"WorkTypeCell" ) as! WorkTypeCell
            cell.workTypeLbl.textColor = .appTextColor
            cell.workTypeLbl.setFont(font: .medium(size: .SMALL))
            let item = sessionDetailsArr.sessionDetails?[selectedSession].workType?[indexPath.row]
            cell.workTypeLbl.text = item?.name ?? ""
            let cacheIndex =  sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex
            let searchedCacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex
            
            
            if isSearched {
                if searchedCacheIndex != nil {
                    self.selectedWorkTypeName = self.workTypeArr?[searchedCacheIndex ?? 0].name ?? ""
                    self.selectTitleLbl.text = selectedWorkTypeName
                    
                 
                } else {
                    self.selectedWorkTypeName = "Select"
                    self.selectTitleLbl.text = selectedWorkTypeName
                }
            } else {
                if cacheIndex != nil {
                    self.selectedWorkTypeName = sessionDetailsArr.sessionDetails?[selectedSession].workType?[cacheIndex ?? 0].name ?? ""
                    sessionDetailsArr.sessionDetails?[selectedSession].WTCode = sessionDetailsArr.sessionDetails?[selectedSession].workType?[cacheIndex ?? 0].code ?? ""
                    
                    sessionDetailsArr.sessionDetails?[selectedSession].WTName = sessionDetailsArr.sessionDetails?[selectedSession].workType?[cacheIndex ?? 0].name ?? ""
                    
                    self.selectTitleLbl.text = selectedWorkTypeName
                } else {
                    self.selectedWorkTypeName = "Select"
                    self.selectTitleLbl.text = selectedWorkTypeName
                    
   
                }
            }
            
            
            
            if isSearched {
                if sessionDetailsArr.sessionDetails?[selectedSession].WTName == cell.workTypeLbl.text {
                    cell.workTypeLbl.textColor = .black
                    cell.workTypeLbl.setFont(font: .bold(size: .BODY))
                }
                else {
                    cell.workTypeLbl.textColor = .black
                    cell.workTypeLbl.setFont(font: .medium(size: .SMALL))
                    
                }
            } else {
                if sessionDetailsArr.sessionDetails?[selectedSession].WTName == cell.workTypeLbl.text {
                    cell.workTypeLbl.textColor = .black
                    cell.workTypeLbl.setFont(font: .bold(size: .BODY))
                }
                else {
                    cell.workTypeLbl.textColor = .black
                    cell.workTypeLbl.setFont(font: .medium(size: .SMALL))
                }
            }
            
            
            
            cell.addTap { [self] in
                
                if self.isSearched {
                    var isToremove: Bool = false
                    let cacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex
                    let cacheCode = sessionDetailsArr.sessionDetails?[selectedSession].WTCode
                    let cacheName = sessionDetailsArr.sessionDetails?[selectedSession].WTName
                    sessionDetailsArr.sessionDetails?[selectedSession].WTCode = item?.code ?? ""
                    sessionDetailsArr.sessionDetails?[selectedSession].WTName = item?.name ?? ""
                    self.workTypeArr?.enumerated().forEach({ index, workType in
                        if workType.code  ==  item?.code {
                            if sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex == index {
                                sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex  = index
                                sessionDetailsArr.sessionDetails?[selectedSession].WTName = workType.name ?? ""
                                sessionDetailsArr.sessionDetails?[selectedSession].FWFlg =  workType.terrslFlg ?? ""
                                sessionDetailsArr.sessionDetails?[selectedSession].WTCode =  workType.code ?? ""
                               // isToremove = true
                                isToremove = false
                            } else {
                                sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex = index
                                if item?.terrslFlg == "Y" {
                                    sessionDetailsArr.sessionDetails?[selectedSession].isForFieldWork = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].isForFieldWork = false
                                }
                                let terrFlg = item?.terrslFlg ?? ""
                                sessionDetailsArr.sessionDetails?[selectedSession].isToshowTerritory = terrFlg == "N" ? false : true
                                sessionDetailsArr.sessionDetails?[selectedSession].FWFlg = workType.terrslFlg ?? ""
                                sessionDetailsArr.sessionDetails?[selectedSession].WTCode = workType.code ?? ""
                                
                                sessionDetailsArr.sessionDetails?[selectedSession].WTName = workType.name ?? ""
                            }
                        }
                    })
              
                    var isExist = Bool()
                
                    if sessionDetailsArr.sessionDetails?.count ?? 0 > 1 {
                        let asession = sessionDetailsArr.sessionDetails?.enumerated().filter {sessionDetailIndex, sessionDetail in
                             sessionDetail.WTCode ==  sessionDetailsArr.sessionDetails?[selectedSession].WTCode
                         }
                        
                       // sessionDetailsArr.sessionDetails?[selectedSession].workType?[indexPath.row].tpDCR == ""
                        if asession?.count ?? 0 > 1 {
                            isExist = true
                        }
                        if isExist {
                            self.endEditing(true)
                            self.toCreateToast("You have already choosen similar work type for another session")
                            sessionDetailsArr.sessionDetails?[selectedSession].searchedWorkTypeIndex = cacheIndex
                            sessionDetailsArr.sessionDetails?[selectedSession].WTCode = cacheCode
                            sessionDetailsArr.sessionDetails?[selectedSession].WTName = cacheName
                        } else {
                            if isToremove {
                                self.menuTable.reloadData()
                            } else {
                                setPageType(.session, for: self.selectedSession)
                                self.endEditing(true)
                            }
                         
                        }
                    } else {
                        if isToremove {
                            self.menuTable.reloadData()
                        } else {
                        
                            setPageType(.session, for: self.selectedSession)
                            self.endEditing(true)
                        }
                     
                    }
           
                } else {
                    let cacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex
                    let cacheCode = sessionDetailsArr.sessionDetails?[selectedSession].WTCode
                    let cacheName = sessionDetailsArr.sessionDetails?[selectedSession].WTName
                   // sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex = indexPath.row
                    sessionDetailsArr.sessionDetails?[selectedSession].WTCode = item?.code ?? ""
                    sessionDetailsArr.sessionDetails?[selectedSession].WTName = item?.name ?? ""
                            var isExist = Bool()
                    _ = Int()
                        if sessionDetailsArr.sessionDetails?.count ?? 0 > 1 {
                               let asession = sessionDetailsArr.sessionDetails?.enumerated().filter {sessionDetailIndex, sessionDetail in
                                   sessionDetail.WTCode ==  sessionDetailsArr.sessionDetails?[selectedSession].WTCode
                                   
                                 //  sessionDetail.selectedWorkTypeIndex ==  sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex
                                }
//                            sessionDetailsArr.sessionDetails?.forEach({ sessionDetail in
//                                if sessionDetailsArr.sessionDetails?[selectedSession].WTCode == sessionDetail.WTCode {
//                                    existCount += 1
//                                }
//                            })
                            
                                
                            if asession?.count ?? 0 > 1 {
                                    isExist = true
                                }
                  
                                if isExist {
                                    self.toCreateToast("You have already choosen similar work type for another session")
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex = cacheIndex
                                    sessionDetailsArr.sessionDetails?[selectedSession].WTCode = cacheCode
                                    sessionDetailsArr.sessionDetails?[selectedSession].WTName = cacheName
                                } else {
                                    toSetData()
                                }
                            } else {
                                toSetData()
                            }
           
           
                    
                    func toSetData() {
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedWorkTypeIndex = indexPath.row
                        if item?.terrslFlg == "Y" {
                            sessionDetailsArr.sessionDetails?[selectedSession].isForFieldWork = true
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].isForFieldWork = false
                        }
                        sessionDetailsArr.sessionDetails?[selectedSession].FWFlg = item?.terrslFlg ?? ""
                        sessionDetailsArr.sessionDetails?[selectedSession].WTCode = item?.code ?? ""
                        let terrFlg = item?.terrslFlg ?? ""
                        sessionDetailsArr.sessionDetails?[selectedSession].isToshowTerritory = terrFlg == "N" ? false : true
                        sessionDetailsArr.sessionDetails?[selectedSession].WTName = item?.name ?? ""
                        setPageType(.session, for: self.selectedSession)
                        self.endEditing(true)
                    }
                }
            }
            
            
            cell.selectionStyle = .none
            return cell
            
            
            
            
        case .cluster, .headQuater, .jointCall, .listedDoctor, .chemist, .stockist, .unlistedDoctor:
            
            // MARK: General note
            /**
             .headQuater, .jointCall, .listedDoctor, .chemist types follows same type of cell reloads and actions as .cluster
             - note : do read documentstions of .cluster tyoe below and make changes to types appropriately
             */
            // MARK: General note ends
            
            let cell = tableView.dequeueReusableCell(withIdentifier:MenuTCell.identifier ) as! MenuTCell
            var item : AnyObject?
            switch self.cellType {
                
            case .headQuater:
                item = sessionDetailsArr.sessionDetails?[selectedSession].headQuates?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                let cacheIndex =  sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex
                let searchedCacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex
                
                
                if isSearched {
                    if searchedCacheIndex == nil {
                        self.selectedWorkTypeName = "Select"
                        self.selectTitleLbl.text = selectedWorkTypeName
                    } else {
                        
                        self.selectedWorkTypeName = self.headQuatersArr?[searchedCacheIndex ?? 0].name ?? ""
                        self.selectTitleLbl.text = selectedWorkTypeName
                    }
                } else {
                    if cacheIndex == nil {
                        self.selectedWorkTypeName = "Select"
                        self.selectTitleLbl.text = selectedWorkTypeName
                    } else {
                        self.selectedWorkTypeName = sessionDetailsArr.sessionDetails?[selectedSession].headQuates?[cacheIndex ?? 0].name ?? ""
                        sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = sessionDetailsArr.sessionDetails?[selectedSession].headQuates?[cacheIndex ?? 0].id ?? ""
                        
                        sessionDetailsArr.sessionDetails?[selectedSession].HQNames = sessionDetailsArr.sessionDetails?[selectedSession].headQuates?[cacheIndex ?? 0].name ?? ""
                        
                        self.selectTitleLbl.text = selectedWorkTypeName
                    }
                }
                
                
                
                if isSearched {
                    if sessionDetailsArr.sessionDetails?[selectedSession].HQNames == cell.lblName.text {
                        cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    }
                    else {
                        cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                    }
                } else {
                    if sessionDetailsArr.sessionDetails?[selectedSession].HQNames == cell.lblName.text {
                        cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    }
                    else {
                        cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                    }
                }
                
                
                
                cell.addTap { [self] in
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID = [String: Bool]()
                    if self.isSearched {
                        var isToremove: Bool = false
                      //  let cacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex
                       // let cacheCode = sessionDetailsArr.sessionDetails?[selectedSession].HQCodes
                       // let cacheName = sessionDetailsArr.sessionDetails?[selectedSession].HQNames
                        self.headQuatersArr?.enumerated().forEach({ index, HQs in
                            if HQs.id  ==  item?.id {
                                if sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex == index {
//                                    sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex  = nil
//                                    sessionDetailsArr.sessionDetails?[selectedSession].HQNames = ""
//                                    sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = ""
                                    sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex = index
                                    sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = HQs.id ?? ""
                                    sessionDetailsArr.sessionDetails?[selectedSession].HQNames = HQs.name ?? ""
                                    isToremove = false
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].searchedHQIndex = index
                                    sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = HQs.id ?? ""
                                    sessionDetailsArr.sessionDetails?[selectedSession].HQNames = HQs.name ?? ""
                                }
                            }
                        })
                        
                        if isToremove {
                            self.menuTable.reloadData()
                        } else {
                            setPageType(.session, for: self.selectedSession)
                            self.endEditing(true)
                        }
                        
                        
                        
                    } else {
                        if sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex == indexPath.row {
//                            sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex  = nil
//                            sessionDetailsArr.sessionDetails?[selectedSession].HQNames = ""
//                            sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = ""
                         //   self.menuTable.reloadData()
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex = indexPath.row
                            sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = item?.id ?? ""
                            sessionDetailsArr.sessionDetails?[selectedSession].HQNames = item?.name ?? ""
                            setPageType(.session, for: self.selectedSession)
                            self.endEditing(true)
                        } else {
                          //  let cacheIndex = sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedHQIndex = indexPath.row
                            sessionDetailsArr.sessionDetails?[selectedSession].HQCodes = item?.id ?? ""
                            sessionDetailsArr.sessionDetails?[selectedSession].HQNames = item?.name ?? ""
                            setPageType(.session, for: self.selectedSession)
                            self.endEditing(true)
                            
                        }
                    }
                }
                
                
                cell.selectionStyle = .none
                return cell
                

                
                
            case .cluster:
                
                let item = sessionDetailsArr.sessionDetails?[selectedSession].cluster?[indexPath.row]
                let _ = sessionDetailsArr.sessionDetails?[selectedSession].cluster
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                
                // MARK: - cells load action
                /**
                 here  sessionDetailsArr.sessionDetails?[selectedSession].cluster is an array which has cluster,
                 sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID id dictionary which has selected cluster code and appropriate boolean values captured from cell tap action.
                 
                 - note : iterating through cluster Array and selectedClusterID dictionary if code in selectedClusterID dictionary is equal to code in cluster array
                 - note : And furher if value for code in  selectedClusterID dictionary is true cell is modified accordingly
                 */

                    self.clusterArr?.forEach({ cluster in
                        //  dump(cluster.code)
                        sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?.forEach { id, isSelected in
                            if id == cluster.code {

                                if isSelected  {
                                    if cluster.name ==  cell.lblName?.text {
                                        cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                    }
                                    
                                } else {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                                }
                            } else {
                            }
                        }
                    })

                // MARK: - set count and selected label
                /**
                 here  sessionDetailsArr.sessionDetails?[selectedSession].cluster is an array which has cluster,
                 sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID id dictionary which has selected cluster code and appropriate boolean values captured from cell tap action.
                 - note : iterating through selectedClusterID dictionary if (code) value in selectedClusterID dictionary is is true count value is increamented
                 */
                
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                    
                }
                
                // MARK: - set count and selected ends
                
                
                // MARK: - cells load action ends
                
                cell.addTap { [self] in
                    self.endEditing(true)
                    _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID
                    
                    // MARK: - Append contents to selectedClusterID Dictionary
                    /**
                     selectedClusterID dictionary holds code key and Boolean value
                     - note : on tap action on cell if key code doent exists we are making value to true else value for key is removed
                     - note : if value is false selectAllIV is set to checkBoxEmpty image since key does not holds all code values as true.
                     */
                    
                    if self.isSearched {
                        self.clusterArr?.enumerated().forEach({ index, cluster in
                            if cluster.code  ==  item?.code {
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![cluster.code ?? ""] == nil {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![cluster.code ?? ""] = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![cluster.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![cluster.code ?? ""] == true ? false : true
                                }
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![cluster.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID!.removeValue(forKey: cluster.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            }
                            
                        })
                      
                    } else {
                        if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?[item?.code ?? ""] {
                            
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![item?.code ?? ""] == true ? false : true
                            
                            if sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID![item?.code ?? ""] == false {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID!.removeValue(forKey: item?.code ?? "")
                                self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                            }
                            
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedClusterID?[item?.code ?? ""] = true
                        }
                    }
                    tableView.reloadData()
                    
                }
                

            case .jointCall:
                item = sessionDetailsArr.sessionDetails?[selectedSession].jointWork?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                sessionDetailsArr.sessionDetails?[selectedSession].jointWork?.forEach({ work in
                    //  dump(cluster.code)
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?.forEach { id, isSelected in
                        if id == work.code {
                            
                            if isSelected  {
                                
                                if work.name ==  cell.lblName?.text {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                }
                                
                            } else {
                                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                            }
                        } else {

                        }
                    }
                })
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                    
                }
                
                cell.addTap { [self] in
                    _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID
                    
                    if isSearched {
                        self.jointWorkArr?.enumerated().forEach({ index, work in
                            if work.code  ==  item?.code {
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![work.code ?? ""] == nil {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![work.code ?? ""] = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![work.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![work.code ?? ""] == true ? false : true
                                }
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![work.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID!.removeValue(forKey: work.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            }
                            
                        })
                    } else {
                        if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?[item?.code ?? ""] {
                            
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![item?.code ?? ""] == true ? false : true
                            
                            if sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID![item?.code ?? ""] == false {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID!.removeValue(forKey: item?.code ?? "")
                                self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                            }
                            
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedjointWorkID?[item?.code ?? ""] = true
                        }
                    }
                    tableView.reloadData()
                }
                
            case .listedDoctor:
                item = sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                sessionDetailsArr.sessionDetails?[selectedSession].listedDoctors?.forEach({ doctors in
                    //  dump(cluster.code)
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID?.forEach { id, isSelected in
                        if id == doctors.code {
                            
                            if isSelected  {
                                
                                if doctors.name ==  cell.lblName?.text {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                }
                                
                                
                            } else {
                                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                            }
                        } else {
                        }
                    }
                })
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                }
                
                cell.addTap { [self] in
                    
                   let exixtingIDs = sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID
                   
                    if   Int(tableSetup?.max_doc ?? "0")  ==  exixtingIDs?.count {
                        self.toCreateToast("Maximum doctors added")
                    } else {
                        if self.isSearched {
                    
                            self.listedDocArr?.enumerated().forEach({ index, doctors in
                                if doctors.code  ==  item?.code {
                                    if sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![doctors.code ?? ""] == nil {
                                        sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![doctors.code ?? ""] = true
                                    } else {
                                        sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![doctors.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![doctors.code ?? ""] == true ? false : true
                                    }
                                    if sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![doctors.code ?? ""] == false {
                                        sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID!.removeValue(forKey: doctors.code ?? "")
                                        self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                    }
                                    
                                }
                                
                            })
                        } else {
                            if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![item?.code ?? ""] {
                                
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID?[item?.code ?? ""] == true ? false : true
                                
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![item?.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID!.removeValue(forKey: item?.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            } else {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedlistedDoctorsID![item?.code ?? ""] = true
                            }
                        }
                        tableView.reloadData()
                    }
                }
            case .chemist:
                item = sessionDetailsArr.sessionDetails?[selectedSession].chemist?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                sessionDetailsArr.sessionDetails?[selectedSession].chemist?.forEach({ chemist in
                  
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID?.forEach { id, isSelected in
                        if id == chemist.code {
                            
                            if isSelected  {
                                
                                if chemist.name ==  cell.lblName?.text {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                }
                                
                                
                            } else {
                                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                            }
                        } else {
                       
                        }
                    }
                })
                
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                    
                }
                
                cell.addTap { [self] in
                    _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID
                    
                    if self.isSearched {
                        self.chemistArr?.enumerated().forEach({ index, chemist in
                            if chemist.code  ==  item?.code {
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![chemist.code ?? ""] == nil {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![chemist.code ?? ""] = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![chemist.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![chemist.code ?? ""] == true ? false : true
                                }
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![chemist.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID!.removeValue(forKey: chemist.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            }
                            
                        })
                    } else {
                        if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID?[item?.code ?? ""] {
                            
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![item?.code ?? ""] == true ? false : true
                            
                            if sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![item?.code ?? ""] == false {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID!.removeValue(forKey: item?.code ?? "")
                                self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                            }
                            
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedchemistID![item?.code ?? ""] = true
                        }
                    }
                    

                    
                    tableView.reloadData()
                }
                
                
            case .stockist:
                item = sessionDetailsArr.sessionDetails?[selectedSession].stockist?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                sessionDetailsArr.sessionDetails?[selectedSession].stockist?.forEach({ stockist in
                  
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID?.forEach { id, isSelected in
                        if id == stockist.code {
                            
                            if isSelected  {
                                
                                if stockist.name ==  cell.lblName?.text {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                }
                                
                                
                            } else {
                                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                            }
                        } else {
                       
                        }
                    }
                })
                
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                    
                }
                
                cell.addTap { [self] in
                    _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID
                    
                    if self.isSearched {
                        self.stockistArr?.enumerated().forEach({ index, chemist in
                            if chemist.code  ==  item?.code {
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![chemist.code ?? ""] == nil {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![chemist.code ?? ""] = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![chemist.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![chemist.code ?? ""] == true ? false : true
                                }
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![chemist.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID!.removeValue(forKey: chemist.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            }
                            
                        })
                    } else {
                        if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![item?.code ?? ""] {
                            
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![item?.code ?? ""] == true ? false : true
                            
                            if sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![item?.code ?? ""] == false {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID!.removeValue(forKey: item?.code ?? "")
                                self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                            }
                            
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedStockistID![item?.code ?? ""] = true
                        }
                    }

                    tableView.reloadData()
                }
            case .unlistedDoctor:
                item = sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?[indexPath.row]
                cell.lblName?.text = item?.name ?? ""
                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                sessionDetailsArr.sessionDetails?[selectedSession].unlistedDoctors?.forEach({ stockist in
                  
                    sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID?.forEach { id, isSelected in
                        if id == stockist.code {
                            
                            if isSelected  {
                                
                                if stockist.name ==  cell.lblName?.text {
                                    cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                                }
                                
                                
                            } else {
                                cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                            }
                        } else {
                       
                        }
                    }
                })
                
                var count = 0
                sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID?.forEach({ (code, isSelected) in
                    if isSelected {
                        count += 1
                    }
                })
                
                if count > 0 {
                    self.selectTitleLbl.text = "Selected"
                    self.countView.isHidden = false
                    self.countLbl.text = "\(count)"
                } else {
                    self.selectTitleLbl.text = "Select"
                    self.countView.isHidden = true
                    
                }
                
                cell.addTap { [self] in
                    _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID
                    
                    if self.isSearched {
                        self.unlisteedDocArr?.enumerated().forEach({ index, chemist in
                            if chemist.code  ==  item?.code {
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![chemist.code ?? ""] == nil {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![chemist.code ?? ""] = true
                                } else {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![chemist.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![chemist.code ?? ""] == true ? false : true
                                }
                                if sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![chemist.code ?? ""] == false {
                                    sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID!.removeValue(forKey: chemist.code ?? "")
                                    self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                                }
                                
                            }
                            
                        })
                    } else {
                        if let _ = sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![item?.code ?? ""] {
                            
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![item?.code ?? ""] =  sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![item?.code ?? ""] == true ? false : true
                            
                            if sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![item?.code ?? ""] == false {
                                sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID!.removeValue(forKey: item?.code ?? "")
                                self.selectAllIV.image =  UIImage(named: "checkBoxEmpty")
                            }
                            
                        } else {
                            sessionDetailsArr.sessionDetails?[selectedSession].selectedUnlistedDoctorsID![item?.code ?? ""] = true
                        }
                    }

                    tableView.reloadData()
                }
                
            default:  return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
            
       
        default:
           return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellType {
            
        case .session:
 
            if sessionDetailsArr.sessionDetails![indexPath.row].isForFieldWork ?? false  {
                return cellHeightForFW
            }  else {
                return cellHeightForOthers
            }
        case .workType:
            return 50
        case .cluster, .headQuater, .jointCall, .listedDoctor, .chemist, .stockist, .unlistedDoctor:
            if indexPath.section == 0 {
                return 50
            } else {
                return 50
            }
           
        case .edit:
            if sessionDetailsArr.sessionDetails![indexPath.row].isForFieldWork ?? false  {
                return cellEditHeightForFW
            }  else {
                return  cellEditHeightForOthers
                
            }
        default:
            return 0
        }
    }
    


}

class MenuTCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var holderView: UIView!
    static let identifier = "MenuTCell"
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.textColor = .appTextColor
        lblName.setFont(font: .medium(size: .SMALL))
    }
    
}








// Given JSON string
let jsonString = "{\"tableName\": \"savetp\",\"TPDatas\": {\"worktype_name\": \"Field Work,\",\"worktype_code\": \"3637\",\"cluster_name\": \"CHAKKARAKKAL,KELAKAM,KUTHUPARAMBA,MATTANNUR,PANOOR,\",\"cluster_code\": \"18758,20218,20221,18759,18761,\",\"DayRmk\": \"planner Remarks\",},\"dayno\": \"9\",\"TPDt\": \"2023-11-9 00:00:00\",\"TPMonth\": \"11\",\"TPYear\": \"2023\"}"


extension MenuView :UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTF {
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle the text change
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")

            switch self.cellType {
                
            case .workType:
                var filteredWorkType = [WorkType]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].workType?.forEach({ workType in
                    if workType.name!.lowercased().contains(newText) {
                        filteredWorkType.append(workType)
                        isMatched = true
                        
                    }
                })
                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
                
                
            case .cluster:
                var filteredWorkType = [Territory]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].cluster?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].cluster = self.clusterArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    if isMatched {
                        self.sessionDetailsArr.sessionDetails?[self.selectedSession].cluster = filteredWorkType
                        isSearched = true
                        self.noresultsView.isHidden = true
                        self.selectAllView.isHidden = true
                        self.selectAllHeightConst.constant = 0
                        self.menuTable.isHidden = false
                        self.menuTable.reloadData()
                    } else {
                        print("Not matched")
                        self.noresultsView.isHidden = false
                        isSearched = true
                        self.selectAllView.isHidden = true
                        self.selectAllHeightConst.constant = 0
                        self.menuTable.isHidden = true
                    }
                }
  
            case .headQuater:
                var filteredWorkType = [Subordinate]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].headQuates?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].headQuates = self.headQuatersArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].headQuates = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
            case .jointCall:
                var filteredWorkType = [JointWork]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].jointWork?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].jointWork = self.jointWorkArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].jointWork = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }

            case .listedDoctor:
                var filteredWorkType = [DoctorFencing]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].listedDoctors?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].listedDoctors = self.listedDocArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].listedDoctors = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
                

            case .chemist:
                var filteredWorkType = [Chemist]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].chemist?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].chemist = self.chemistArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].chemist = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
                
            case .stockist:
                var filteredWorkType = [Stockist]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].stockist?.forEach({ stockist in
                    if stockist.name!.lowercased().contains(newText) {
                        filteredWorkType.append(stockist)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].stockist = self.stockistArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].stockist = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
                
                
            case .unlistedDoctor:
                var filteredWorkType = [UnListedDoctor]()
                filteredWorkType.removeAll()
                var isMatched = false
                sessionDetailsArr.sessionDetails?[self.selectedSession].unlistedDoctors?.forEach({ newDocs in
                    if newDocs.name!.lowercased().contains(newText) {
                        filteredWorkType.append(newDocs)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].unlistedDoctors = self.unlisteedDocArr
                    self.noresultsView.isHidden = true
//                    self.selectAllView.isHidden = false
//                    self.selectAllHeightConst.constant = selectAllHeight
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.sessionDetailsArr.sessionDetails?[self.selectedSession].unlistedDoctors = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.selectAllView.isHidden = true
                    self.selectAllHeightConst.constant = 0
                    self.menuTable.isHidden = true
                }
            default:
                break
            }
            // You can update your UI or perform other actions based on the filteredArray
        }

        return true
    }
}


extension MenuView: SessionInfoTVCDelegate {
    func remarksAdded(remarksStr: String, index: Int) {
        self.selectedSession = index
        sessionDetailsArr.sessionDetails?[selectedSession].remarks =  remarksStr
        dump(sessionDetailsArr.sessionDetails?[selectedSession].remarks)
        self.menuTable.reloadData()
    }
    
    
}

