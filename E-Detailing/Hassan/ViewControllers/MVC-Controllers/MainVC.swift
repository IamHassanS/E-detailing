//
//  MainVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/07/23.
//

import UIKit
import Foundation
import FSCalendar
import UICircularProgressRing
import Alamofire
import CoreData






typealias collectionViewProtocols = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
typealias tableViewProtocols = UITableViewDelegate & UITableViewDataSource

class MainVC : UIViewController {
    
    enum SegmentType : String {
        case workPlan = "Work plan"
        case calls = "Calls"
        case outbox = "Outbox"
        case calender = "Date"
    }

    // @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet var deviateSwitch: UISwitch!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var backGroundVXview: UIVisualEffectView!
    @IBOutlet var segmentsCollection: UICollectionView!
    @IBOutlet var monthRangeLbl: UILabel!
    @IBOutlet var lblAverageDocCalls: UILabel!
    @IBOutlet weak var lblAnalysisName: UILabel!

    
    @IBOutlet weak var lblDate: UILabel!
    

    
    @IBOutlet var worktypeTable: UITableView!
    
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnActivity: UIButton!
    
    
    // @IBOutlet weak var segmentControlForDcr: UISegmentedControl!
    @IBOutlet weak var segmentControlForAnalysis: UISegmentedControl!
    
    @IBOutlet weak var salesStackView: UIStackView!
    @IBOutlet weak var callStackView: UIStackView!
    @IBOutlet weak var slideStackView: UIStackView!
    
    // views
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewAnalysis: UIView!
    @IBOutlet weak var viewQuickLinks: UIView!
    
    @IBOutlet weak var viewWorkPlan: UIView!
    @IBOutlet weak var viewCalls: UIView!
    @IBOutlet weak var viewOutBox: UIView!
    
    
    @IBOutlet weak var viewDayPlanStatus: UIView!
    

    
    @IBOutlet weak var tourPlanCalander: FSCalendar!
    
    @IBOutlet weak var viewPcpmChart: UICircularProgressRing!
    
    
    @IBOutlet weak var viewSalesAnalysisStackView: UIStackView!
    
    ///Mark: - charts
    
    @IBOutlet var chartHolderView: UIView!
    @IBOutlet var lineChatrtView: UIView!
    
    @IBOutlet var monthHolderView: UIView!
    
    @IBOutlet var month2View: UIView!
    
    @IBOutlet var month1View: UIView!
    
    @IBOutlet var month1VXview: UIVisualEffectView!
    
    @IBOutlet var month2VXview: UIVisualEffectView!
    
    @IBOutlet var month3VXview: UIVisualEffectView!
    
    @IBOutlet var month3View: UIView!
    
    @IBOutlet var month1Lbl: UILabel!
    
    @IBOutlet var month2Lbl: UILabel!
    
    @IBOutlet var quickLinkTitle: UILabel!
    @IBOutlet var month3Lbl: UILabel!
    
    ///Mark: - Calls
    
    @IBOutlet var outboxCountVIew: UIView!
    @IBOutlet var callsCountLbl: UILabel!
    
    @IBOutlet var outboxCallsCountLabel: UILabel!
    
    @IBOutlet var clearCallsBtn: UIButton!
    
    @IBOutlet var outboxCallsCountLbl: UILabel!
    
    
    @IBOutlet weak var quickLinkCollectionView: UICollectionView!
    @IBOutlet weak var dcrCallsCollectionView: UICollectionView!
    @IBOutlet weak var analysisCollectionView: UICollectionView!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    @IBOutlet var showMenuView: UIView!
    
    @IBOutlet var homeTitleLbl: UILabel!
    
    
    @IBOutlet var segmentBorderLbl: UILabel!
   
    @IBOutlet weak var callTableView: UITableView!
    @IBOutlet weak var outboxTableView: UITableView!
    
    @IBOutlet var viewLeftSegment: UIView!
    
    //my day plan
    
    @IBOutlet var btnAddplan: UIButton!
    
    @IBOutlet var btnFinalSubmit: UIButton!
    @IBOutlet var btnSavePlan: UIButton!
    
    @IBOutlet var rejectionTitle: UILabel!
    @IBOutlet var rejectionReason: UILabel!
    @IBOutlet var rejectionVIew: UIView!
    
    @IBOutlet var rejectionVXview: UIVisualEffectView!
    @IBOutlet var rejectionHeight: NSLayoutConstraint!
    
    @IBOutlet var viewCallstatus: UIView!
    
    @IBOutlet var lblCallStatus: UILabel!
    
    @IBOutlet var dateInfoLbl: UILabel!
    @IBOutlet var calenderHolderVIew: UIView!
    
    @IBOutlet var fsCalenderView: UIView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet weak var dayplancalenderVIew: FSCalendar!
    @IBOutlet var closeRejectionVIew: UIView!
    
    var  latitude : Double?
    var longitude: Double?
    
    func setDeviateSwitch(istoON: Bool) {
        deviateSwitch.isOn = istoON
    }
    

    
    
    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var callsCellHeight = 400 + 10 // + 10 padding
    var homeLineChartView : HomeLineChartView?
    
    var changePasswordView: ChangePasswordView?
    
    var checkinVIew: HomeCheckinView?
    
    var checkinDetailsView:  HomeCheckinDetailsView?
    
    var tpDeviateReasonView:  TPdeviateReasonView?
    
    let appSetups = AppDefaults.shared.getAppSetUp()

    
    @IBOutlet var deviateView: UIView!
    
    @IBOutlet var deviateViewHeight: NSLayoutConstraint!
    var isFromLaunch: Bool = false
    var chartType: ChartType = .doctor
    var cacheDCRindex: Int = 0
    var doctorArr = [HomeData]()
    var chemistArr = [HomeData]()
    var stockistArr = [HomeData]()
    var unlistedDocArr = [HomeData]()
    var cipArr = [HomeData]()
    var hospitalArr = [HomeData]()
    var  homeDataArr = [HomeData]()
    var unsyncedhomeDataArr = [UnsyncedHomeData]()
    var responseDcrDates = [DcrDates]()
    var outBoxDataArr : [TodayCallsModel]?
    var totalFWCount: Int = 0
    var cacheINdex: Int = 0
    var selectedCallIndex: Int = 0
    var userststisticsVM : UserStatisticsVM?
    var isPlanningNewDCR : Bool = false
    let dispatchGroup = DispatchGroup()
    var fetchedWorkTypeObject1: WorkType?
    var fetchedClusterObject1: [Territory]?
    var fetchedHQObject1: Subordinate?
    
    var fetchedHQObject2: Subordinate?
    var fetchedClusterObject2: [Territory]?
    var fetchedWorkTypeObject2: WorkType?
    
    var sessions: [Sessions]?
    var cacheTerritory: [Territory]?
    var isRejected = Bool()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var selectedSubordinate: Subordinate?
    var selectedDate: String?
    var selectedRawDate : Date?
    var selectedSegment : SegmentType = .workPlan
    var segmentType: [SegmentType] = []
    var selectedSegmentsIndex: Int = 0
    var selectedSessionIndex : Int?
    var unsavedIndex : Int?
    var isTohightCell: Bool = false
    
    private lazy var today: Date = {
        return Date()
    }()
    
    private var currentPage: Date?
    var tableCellheight: CGFloat = 0
    var isDayPlanRemarksadded: Bool = false
 

    
    
    
    var links = [QuicKLink]()
    
    var dcrCount = [DcrCount]()
    var masterVM : MasterSyncVM?
    
    let eventArr = ["Weekly off", "Field Work", "Holiday", "Leave", "Missed Released", "Re Entry", "TP Devition Released", "Non-Field Work", "TP Devition", "Leave Approval Pending"]
    let colorArr : [UIColor] =  [.appYellow, .appGreen, .appViolet, .appLightPink, .appLightGrey, .appPink, .appDeepGreen, .appBlue, .appBrown, .appDeepBlue]
    
    let menuList = ["Refresh","Tour Plan","Create Presentation","Leave Application","Reports","Activiy","Near Me","Quiz","Survey","Forms","Profiling"]
    
    var todayCallsModel: [TodayCallsModel]?
    enum ChartType {
        case doctor
        case chemist
        case stockist
        case unlistedDoctor
    }
    
    
    func toSetChartType(chartType: ChartType) {
        switch chartType {
            
        default:
            self.toIntegrateChartView(.doctor, 0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        updateLinks()
        setupUI()
        if istoRedirecttoCheckin() {
            checkinAction()
        }

    }
    
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dcrcallsAdded) , name: NSNotification.Name("callsAdded"), object: nil)
        
        network.isReachable() { [weak self] reachability in
            guard let welf = self else {return}
        
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                welf.toConfigureMydayPlan()
                welf.refreshUI()
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                welf.toPostDayplan() {
                   // if !Shared.instance.isDayplanSet {
                        welf.toSetDayplan() {
                            welf.refreshUI()
                        }
                  //  } else {
                      //  welf.refreshUI()
                  //  }
                }
          
        
            }
            
        }
        
        network.isUnreachable() { [weak self] reachability in
            guard let welf = self else {return}
        
            switch reachability.reachability.connection {
                
            case .unavailable, .none:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                welf.toConfigureMydayPlan()
                welf.refreshUI()
            case .wifi, .cellular:
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                welf.toPostDayplan() {
                   // if !Shared.instance.isDayplanSet {
                        welf.toSetDayplan() {
                            welf.refreshUI()
                        }
                  //  } else {
                      //  welf.refreshUI()
                  //  }
                }
          
        
            }
            
        }
    }
    
    func refreshUI(issynced: Bool? = false) {
        toSeperateDCR(istoAppend: true)
        updateDcr()
        toIntegrateChartView(self.chartType, self.cacheDCRindex)
        toLoadCalenderData()
        toLoadDcrCollection()
        toLoadOutboxTable(isSynced: issynced ?? false)
        toloadCallsTable()
    }
    
    func refreshDashboard(completion: @escaping () -> ()) {
        self.masterVM?.fetchMasterData(type: .homeSetup, sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { [weak self] isProcessed in
            guard let welf = self else {return}
            welf.refreshUI()
            completion()
        }
    }
    
    func initView() {
        
        self.viewWorkPlan.addAction(for: .swipe_left) {
            self.setSegment(.calls, isfromSwipe: true)
        }
        
        self.viewCalls.addAction(for: .swipe_left) {
            self.setSegment(.outbox, isfromSwipe: true)
        }
        
        self.viewCalls.addAction(for: .swipe_right) {
            self.setSegment(.workPlan, isfromSwipe: true)
        }
        
        
        self.viewOutBox.addAction(for: .swipe_right) {
            self.setSegment(.calls, isfromSwipe: true)
        }
        
        
        self.backgroundView.addTap {
            self.didClose()
        }
        
        self.viewDate.Border_Radius(border_height: 0, isborder: true, radius: 10)
        
        [btnNotification,btnSync,btnProfile].forEach({$0?.Border_Radius(border_height: 0, isborder: true, radius: 25)})
        

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.quickLinkCollectionView.collectionViewLayout = layout
        
        if let layout = self.analysisCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.isScrollEnabled = true
        }
        

        
        
        if let layout = self.dcrCallsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.isScrollEnabled = true
        }
        
        self.viewAnalysis.addGestureRecognizer(createSwipeGesture(direction: .left))
        self.viewAnalysis.addGestureRecognizer(createSwipeGesture(direction: .right))
        
        
        [btnCall,btnActivity].forEach { button in
            button.layer.borderColor = AppColors.primaryColorWith_40per_alpha.cgColor
            button.layer.borderWidth = 1
        }

        
        self.updatePCPMChart()
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
   
        
    

    
    
    func getCurrentFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: Date())
    }
    
    func toSetupSubmitAlert() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "Do you want to add remarks for your day paln?", okAction:    appSetups.srtNeed == 1 ? "Just check out" : "Final submit" , cancelAction: "Add remark")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
           
            if  self.appSetups.srtNeed == 1 {
              self.checkoutAction()
          } else {
              
              print("Yet to implement final submit")
          }
          
        }
        
        commonAlert.addAdditionalCancelAction {
            print("Yes action")
            
            self.deviateAction(isForremarks: true)
        
        }
    }
    
    func checkoutAction() {
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
            guard let welf = self else {return}
            guard let coordinates = coordinates else {
                // "Please connect to active network to update Password"
              //   "Please enable location services in Settings."
                welf.showAlertToNetworks(desc: "Please enable location services in Settings.")
                
                return
            }
            
            Pipelines.shared.getAddressString(latitude: coordinates.latitude ?? Double(), longitude:  coordinates.longitude ?? Double()) { [weak self] address in
                guard let welf = self else {return}
                
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let currentDate = Date()
                let dateString = dateFormatter.string(from: currentDate)
                
                let datestr = dateString
                
                ///time
                dateFormatter.dateFormat = "HH:mm:ss"
                
                let timeString = dateFormatter.string(from: currentDate)
                
                let timestr = (timeString)
                
                
                let achckinInfo = CheckinInfo(address: address, checkinDateTime: "" , checkOutDateTime: welf.getCurrentFormattedDateString(), latitude:  coordinates.latitude ?? Double(), longitude:  coordinates.latitude ?? Double(), dateStr: datestr, checkinTime: "", checkOutTime: timestr)
                
                welf.fetchCheckins(checkin: achckinInfo) {[weak self] checkin in
                    
                    guard let welf = self else {return}
                    
                    welf.checkinDetailsAction(checkin: checkin)
                    
                }
                
                
            }
            
            
            
        }
    }
    

    
    
    func fetchCheckins(checkin: CheckinInfo, completion: @escaping (CheckinInfo) -> ()) {
        CoreDataManager.shared.fetchCheckininfo() { saveCheckins  in
            
            guard let aCheckin = saveCheckins.first else {
                
                self.checkinAction()
                
                return}
            
            var tempCheckin = checkin
            tempCheckin.checkinDateTime = aCheckin.checkinDateTime
            tempCheckin.checkinTime = aCheckin.checkinTime
            completion(tempCheckin)
        }
    }
    
    func setupHeight(_ isTodelete: Bool, index: Int) -> CGFloat {
        
        
        let model = self.sessions?[index]
        
        var cellHeight: CGFloat = 0
        
        if isTodelete {
            
            cellHeight = 40 + 5
        } else {
            
            cellHeight = 0
        }
        
        if model?.workType?.fwFlg  == "F" {
            
            
            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                cellHeight = cellHeight + 170
                
            } else {
                cellHeight = cellHeight +  220
                
            }
        } else {
            cellHeight = cellHeight +  76
        }
        return cellHeight
    }
    
    func getSubordinate(hqCode: String) -> Subordinate? {
        let hqArr = DBManager.shared.getSubordinate()
        var aSubordinateobj = NSManagedObject()
        hqArr.forEach { aSubordinate in
            if aSubordinate.id == hqCode {
                aSubordinateobj = aSubordinate
            }
            
        }
        return aSubordinateobj as? Subordinate
    }
    
    
    class func initWithStory(isfromLaunch: Bool, ViewModel: UserStatisticsVM) -> MainVC {
        let mainVC : MainVC = UIStoryboard.Hassan.instantiateViewController()
        mainVC.userststisticsVM = ViewModel
        mainVC.isFromLaunch = isfromLaunch
        mainVC.masterVM = MasterSyncVM()
        return mainVC
    }
    
    func saveHQentitiesToCoreData(aHQobj: HQModel, completion: (Bool) -> Void) {
        CoreDataManager.shared.removeHQ()
        CoreDataManager.shared.saveToHQCoreData(hqModel: aHQobj) {  _ in
            // guard let welf = self else {return}
            //            CoreDataManager.shared.fetchSavedHQ { selectedHQArr in
            //                if let aEntity = selectedHQArr.first {
            //                   // welf.sessions?[welf.selectedSessionIndex ?? 0].headQuarters = aEntity
            //                    completion(true)
            //                }
            //            }
            
            completion(true)
        }
    }
    
    
    func setupRejectionVIew() {
        
        guard let nonNillSessions = sessions else {return}
        
        isRejected = nonNillSessions.map { $0.isRejected }.contains(true)
        rejectionTitle.text = "Rejected reason"
        
        if isRejected {
            // var isTodisableApproval = true
            rejectionReason.text = nonNillSessions.map { $0.rejectionReason ?? "" }.first
            // self.rejectionReason.text = "A project archive refers to the systematic storing of project artifacts (e.g., project charter, working documents, models, deliverables, etc.) at the close of a project. Retaining project documents and artifacts is important for administrative closure."
            
            self.rejectionVIew.isHidden = false
            toConfigureDynamicHeader(false)
            
        } else {
            self.rejectionVIew.isHidden = true
            self.toConfigureDynamicHeader(true)
            //  worktypeTable.reloadData()
        }
    }
    
    func toConfigureDynamicHeader(_ istoHide : Bool) {
        if istoHide {
            self.rejectionReason.text = ""
            self.rejectionTitle.text = ""
            self.rejectionVIew.frame.size.height = 0
            self.rejectionVIew.isHidden = true
        } else {
            self.rejectionVIew.isHidden = false
        }
        let tempHeader = self.getViewExactHeight(view: self.rejectionVIew)
        self.rejectionVIew.frame.size.height = tempHeader.frame.height
        
        // worktypeTable.reloadData()
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
    
    
    func toAddnewSession() {
        var aSession = Sessions()
        
        aSession.cluster  = nil
        aSession.workType = nil
        aSession.headQuarters = nil
        aSession.isRetrived = Bool()
        aSession.isFirstCell = true
        aSession.planDate = self.selectedRawDate == nil ? Date() : self.selectedRawDate
        
        setDateLbl(date: aSession.planDate ?? Date())
        
        self.sessions?.insert(aSession, at: 0)
    }
    
    
    func setDateLbl(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        lblDate.text = dateFormatter.string(from:  date)
    }
    
    func toConfigureMydayPlan() {
        
        
        
        toFetchExistingPlan() { existingSessions in
            self.sessions = existingSessions
            if !(self.sessions?.isEmpty ?? false) {
                
                self.setDateLbl(date: self.sessions?[0].planDate ?? Date())
                
                self.sessions?.enumerated().forEach { index, aSession in
                    switch index {
                    case 0:
                        dump(aSession.headQuarters?.code)
                        self.fetchedHQObject1 =  self.getSubordinate(hqCode: aSession.headQuarters?.code ?? "")
                        self.fetchedWorkTypeObject1 = aSession.workType
                        self.fetchedClusterObject1 = aSession.cluster
                        
                    case 1:
                        dump(aSession.headQuarters?.code)
                        self.fetchedHQObject2 =  self.getSubordinate(hqCode: aSession.headQuarters?.code ?? "")
                        self.fetchedWorkTypeObject2 = aSession.workType
                        self.fetchedClusterObject2 = aSession.cluster
                    default:
                        print("<----->")
                    }
                    
                }
            } else {
                self.selectedRawDate =  self.selectedRawDate  == nil ? Date() : self.selectedRawDate
                self.toAddnewSession()
            }
            
            
            
            guard let nonNilSessons = self.sessions else {
                self.configureAddplanBtn(false)
                self.configureSaveplanBtn(false)
                return
            }
            var isPlan1filled : Bool = false
            var isPlan2filled : Bool = false
            
            var istoEnableSaveBtn: Bool = false
            var istoEnableAddPlanBtn: Bool = false
            
            nonNilSessons.enumerated().forEach { index, aSession in
                switch index {
                case 0:
                    
                    if aSession.isRetrived == true {
                        isPlan1filled =  true
                        
                        if nonNilSessons.count == 1 {
                            istoEnableAddPlanBtn = true
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableAddPlanBtn = false
                            istoEnableSaveBtn = false
                        }
                        
                    } else {
                        
                        isPlan1filled = self.toEnableSaveBtn(sessionindex: index, istoHandeleAddedSession: false)
                        //(aSession.cluster != nil || aSession.cluster != [] || aSession.workType != nil  || aSession.workType != WorkType() || aSession.headQuarters != nil || aSession.headQuarters != SelectedHQ())
                    }
                    
                    if isPlan1filled {
                        
                        if aSession.isRetrived == true {
                            
                            if nonNilSessons.count == 1 {
                                istoEnableAddPlanBtn = true
                            } else {
                                istoEnableAddPlanBtn = false
                            }
                            
                        } else {
                            istoEnableAddPlanBtn = false
                        }
                        
                        
                        
                        if aSession.isRetrived == true {
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableSaveBtn = true
                        }
                        
                    } else {
                        istoEnableAddPlanBtn = false
                        istoEnableSaveBtn = false
                    }
                    
                case 1:
                    if aSession.isRetrived == true {
                        isPlan2filled =  true
                        
                        if nonNilSessons.count == 1 {
                            istoEnableAddPlanBtn = true
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableAddPlanBtn = false
                            istoEnableSaveBtn = false
                        }
                        
                    } else {
                        isPlan2filled = self.toEnableSaveBtn(sessionindex: index, istoHandeleAddedSession: false)
                    }
                    
                    if isPlan2filled {
                        if aSession.isRetrived == true {
                            
                            if nonNilSessons.count == 1 {
                                istoEnableAddPlanBtn = true
                            } else {
                                istoEnableAddPlanBtn = false
                            }
                            
                        } else {
                            istoEnableAddPlanBtn = false
                        }
                        if aSession.isRetrived == true {
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableSaveBtn = true
                        }
                    } else {
                        istoEnableAddPlanBtn = false
                        istoEnableSaveBtn = false
                    }
                    
                default:
                    isPlan1filled = false
                    isPlan2filled = false
                }
                
                
            }
            
            self.configureAddplanBtn(istoEnableAddPlanBtn)
            
            self.configureSaveplanBtn(istoEnableSaveBtn)
            self.setupRejectionVIew()
          
            self.setSegment(.workPlan)
            
            
        }
        
    }
    
    
    func toEnableSaveBtn(sessionindex: Int, istoHandeleAddedSession: Bool) -> Bool {
        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context),
              let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
              let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }
        var index: Int = 0
        //        if sessions?.count == 2 {
        //            index = sessionindex == 0 ? 1 : 0
        //        }
        index = sessionindex
        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        guard let nonNillSession = self.sessions else {return false}
        
        switch index {
        case 0, 1 :
            
            
            let model = nonNillSession[index]
            
            if model.workType == nil || model.workType == WorkType() || model.workType == temporaryselectedWTobj {
                return false
            }
            
            if model.workType?.fwFlg  != nil && model.workType?.fwFlg  != "F"  {
                return true
            } else {
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    
                    if (model.cluster ==  nil || model.cluster == [temporaryselectedClusterobj]) || model.cluster  == [Territory]() || model.cluster?[0].code == nil || (model.workType == nil ||  model.workType == temporaryselectedWTobj) {
                        return false
                    } else {
                        if nonNillSession[index].isRetrived ?? false {
                            return false
                        } else {
                            return true
                        }
                        
                        
                    }
                    
                } else {
                    
                    
                    
                    if (model.headQuarters ==  nil || model.headQuarters == temporaryselectedHqobj) || (model.cluster == nil || model.cluster == [temporaryselectedClusterobj]) || model.cluster  == [Territory]() || model.cluster?[0].code == nil || (model.workType == nil ||  model.workType == temporaryselectedWTobj)  {
                        return false
                    } else {
                        if nonNillSession[index].isRetrived ?? false {
                            if istoHandeleAddedSession {
                                return true
                            } else {
                                return false
                            }
                            
                            
                        } else {
                            return true
                        }
                    }
                    
                    
                }
            }
            
        default:
            return false
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
                  homeData.dcr_dt = unsyncedHomeData.dcr_dt
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
                  
                  // Append the created HomeData object to homeDataArr
                  homeDataArr.append(homeData)
        }
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
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async {
                    if status == ReachabilityManager.ReachabilityStatus.notConnected.rawValue  {
                        
                        self.toCreateToast("Please check your internet connection.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                        //  self.toConfigureMydayPlan()
                        
                    } else if  status == ReachabilityManager.ReachabilityStatus.wifi.rawValue || status ==  ReachabilityManager.ReachabilityStatus.cellular.rawValue   {
                        
                        self.toCreateToast("You are now connected.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                    }
                }
            }
        }
    }
    
    func toLoadSegments() {
        segmentsCollection.delegate = self
        segmentsCollection.dataSource = self
        segmentsCollection.reloadData()
    }
    
    
    
    
    func updateEachDayPlan(yetToSaveSession: [Sessions], completion: @escaping (Bool) -> ()) {
        // Remove all existing day plans
        CoreDataManager.shared.removeAllDayPlans()
        
        // Save sessions as day plans
        
        
        
        CoreDataManager.shared.saveSessionAsEachDayPlan(session: yetToSaveSession) { isCompleted in
            // [weak self]
            //   guard let welf = self else { return }
            if isCompleted {
                
                
                completion(true)
            }
        }
    }
    
    

    
    
    
    
    
    
    //http://edetailing.sanffa.info/iOSServer/db_api.php/?axn=edetsave/dayplan
    //{"tableName":"dayplan","sfcode":"MR6432","division_code":"22,","Rsf":"MR6432","sf_type":"1","Designation":"MR","state_code":"10","subdivision_code":"19,","town_code":"116780,116777,","Town_name":"Bandipora,Bramulla,","WT_code":"306","WTName":"Field Work","FwFlg":"F","town_code2":"","Town_name2":"","WT_code2":"","WTName2":"","FwFlg2":"","Remarks":"","location":"","location2":"","InsMode":"0","Appver":"M1","Mod":"","TPDt":"2024-02-07 00:00:00.000","TpVwFlg":"","TP_cluster":"","TP_worktype":""}
    
    func toHighlightAddedCell()  {
        //        if sessions?.count == 2 {
        //
        //            return false
        //        } else {
        guard var nonEmptySession = self.sessions else  {
            return
        }
        
        
        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context),
              let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
              let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }
        
        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        let unsavedSessionsWithIndices = nonEmptySession.enumerated().filter { index, session in
            return !(session.isRetrived ?? false)
        }
        
        let unsavedSessions = unsavedSessionsWithIndices.map { index, session in
            return session
        }
        
        let indices = unsavedSessionsWithIndices.map { index, _ in
            return index
        }
        
        
        
        if unsavedSessions.isEmpty {
            
            var aSession = Sessions()
            
            aSession.cluster  = nil
            aSession.workType = nil
            aSession.headQuarters = nil
            aSession.isRetrived = Bool()
            
            nonEmptySession.insert(aSession, at: 0)
            // nonEmptySession.append(aSession)
            self.sessions = nonEmptySession
            self.unsavedIndex = indices.first
            self.isTohightCell = false
        
        } else {
            
            let unfilledSessionWithIndex = unsavedSessions.enumerated().filter { index, session in
                return  (session.cluster == nil || session.cluster == [temporaryselectedClusterobj] || session.headQuarters == nil ||  session.headQuarters == temporaryselectedHqobj || session.workType == nil || session.workType == temporaryselectedWTobj)
            }
            
            let  unfilledSessions = unfilledSessionWithIndex.map { index, session in
                return session
            }
            
            let unfilledindices = unfilledSessionWithIndex.map { index, _ in
                return index
            }
            
            
            if unfilledSessions.isEmpty {
                
                let unSentSessions = unfilledSessions.filter {($0.isRetrived ?? false)}
                
                if !unSentSessions.isEmpty {
                    var aSession = Sessions()
                    
                    aSession.cluster  = nil
                    aSession.workType = nil
                    aSession.headQuarters = nil
                    aSession.isRetrived = Bool()
                    
                    nonEmptySession.insert(aSession, at: 0)
                    //  nonEmptySession.append(aSession)
                    self.sessions = nonEmptySession
                } else {
                    //   self.toCreateToast("please do save session to add plan")
                    self.unsavedIndex = unfilledindices.first
                    // self.isTohightCell = true
                 
                }
            } else {
                self.unsavedIndex = unfilledindices.first
                //  self.isTohightCell = true
             
            }
            
            
        }
        // }
        
        
    
        
    }
    

    
    func configureAddplanBtn(_ isToEnable: Bool) {
        //self.sessions?.count ?? 0 >= 2 ?  false
        if isToEnable {
            self.btnAddplan.isUserInteractionEnabled = true
            self.btnAddplan.alpha = 1
            return
        }  else {
            
            self.btnAddplan.isUserInteractionEnabled = false
            self.btnAddplan.alpha = 0.5
            return
        }
        
        
    }
    
    
    func configureSaveplanBtn(_ isToEnable: Bool) {
        
        if !isToEnable {
            self.btnSavePlan.isUserInteractionEnabled = false
            self.btnSavePlan.alpha = 0.5
        } else {
            self.btnSavePlan.isUserInteractionEnabled = true
            self.btnSavePlan.alpha = 1
        }
    }
    
    func toHideDeviateView(isTohide: Bool) {
        if isTohide {
            deviateView.isHidden = true
            deviateViewHeight.constant = 0
        } else {
            deviateView.isHidden = false
            deviateViewHeight.constant = 50
        }
      
    }
    
    func setupUI() {
        cellRegistration()
        initView()
        rejectionVIew.isHidden = true
        toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
        toHideDeviateView(isTohide: true)
        backgroundView.isHidden = true
        backGroundVXview.alpha = 0
        // backgroundView.backgroundColor = .appGreyColor
        dateInfoLbl.textColor = .appTextColor
        dateInfoLbl.setFont(font: .medium(size: .BODY))
        viewDayPlanStatus.layer.cornerRadius = 5
        dateInfoLbl.setFont(font: .medium(size: .BODY))
        dateInfoLbl.textColor = .appTextColor
        
        rejectionVXview.backgroundColor = .appLightPink
        closeRejectionVIew.addTap {
            self.toConfigureDynamicHeader(true)
            
        }
        closeRejectionVIew.layer.cornerRadius =  closeRejectionVIew.height / 2
        rejectionTitle.setFont(font: .medium(size: .BODY))
        rejectionTitle.textColor = .appLightPink
        rejectionReason.setFont(font: .medium(size: .BODY))
        rejectionReason.textColor = .appTextColor
        rejectionVIew.layer.cornerRadius = 5
        

        
        segmentType = [.workPlan, .calls, .outbox]
        toLoadSegments()
        worktypeTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        

        
        
        btnAddplan.backgroundColor = .appGreyColor
        btnAddplan.layer.borderWidth = 1
        btnAddplan.layer.borderColor = UIColor.appLightTextColor.cgColor
        
        
        
        btnSavePlan.backgroundColor = .appGreyColor
        btnSavePlan.layer.borderWidth = 1
        btnSavePlan.layer.borderColor = UIColor.appLightTextColor.cgColor
        
        btnFinalSubmit.backgroundColor = .appTextColor
        
        outboxCountVIew.isHidden = true
        outboxCallsCountLabel.setFont(font: .medium(size: .BODY))
        outboxCallsCountLabel.textColor = .appWhiteColor
        outboxCountVIew.layer.cornerRadius = outboxCountVIew.height / 2
        outboxCountVIew.backgroundColor = .appTextColor
        clearCallsBtn.layer.cornerRadius = 5
        clearCallsBtn.backgroundColor = .appTextColor
        clearCallsBtn.titleLabel?.textColor = .appWhiteColor
        
        
        outboxCallsCountLbl.setFont(font: .medium(size: .BODY))
        outboxCallsCountLbl.textColor = .appTextColor
        
        viewCalls.layer.cornerRadius = 5
        viewCalls.backgroundColor = .appWhiteColor
        lblDate.setFont(font: .bold(size: .SUBHEADER))
        

        
        btnCall.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnCall.layer.borderWidth = 1
        btnCall.tintColor = .appTextColor
        btnCall?.layer.cornerRadius = 5
        btnCall.backgroundColor = .appGreyColor
        btnActivity.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnActivity.layer.borderWidth = 1
        btnActivity.tintColor = .appTextColor
        btnActivity?.layer.cornerRadius = 5
        btnActivity.backgroundColor = .appGreyColor
        
        self.worktypeTable.contentInsetAdjustmentBehavior = .never
        self.callTableView.contentInsetAdjustmentBehavior = .never
        self.worktypeTable.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        self.callTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        callsCountLbl.setFont(font: .medium(size: .BODY))
        callsCountLbl.textColor = .appTextColor
        homeTitleLbl.setFont(font: .bold(size: .SUBHEADER))
        homeTitleLbl.text = "SAN Media Pvt Ltd.,"
        homeTitleLbl.textColor = .appWhiteColor

        quickLinkTitle.setFont(font: .bold(size: .SUBHEADER))
        monthRangeLbl.setFont(font: .medium(size: .BODY))
        lblAverageDocCalls.setFont(font: .bold(size: .SUBHEADER))
        lblAnalysisName.setFont(font: .bold(size: .SUBHEADER))
  
        chartHolderView.layer.cornerRadius = 5
        chartHolderView.backgroundColor = .appWhiteColor
 
        month1View.layer.cornerRadius = 5
        month2View.layer.cornerRadius = 5
        month3View.layer.cornerRadius = 5

        month1VXview.backgroundColor = .appSelectionColor
        month2VXview.backgroundColor = .appSelectionColor
        month3VXview.backgroundColor = .appSelectionColor
        
        month1Lbl.setFont(font: .bold(size: .BODY))
        month2Lbl.setFont(font: .bold(size: .BODY))
        month3Lbl.setFont(font: .bold(size: .BODY))

    }
    
    @objc func dcrcallsAdded() {
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            toSetParams(isfromSyncCall: true) {
                // self.toLoadOutboxTable(isSynced: true)
                self.refreshDashboard() {}
            }
        } else {
            self.refreshDashboard() {}
        }
     
    }
    
    func toLoadDcrCollection() {
        dcrCallsCollectionView.delegate = self
        dcrCallsCollectionView.dataSource = self
        dcrCallsCollectionView.reloadData()
    }
    
    
    func toPostDayplan(completion: @escaping () -> ()) {
        
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.istoUploadDayplans) && LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            
            
            callSavePlanAPI() {  [weak self] isUploaded in
                guard let welf = self else {return}
                
                guard var nonNilSession = welf.sessions else {
                    return
                }
                
                if isUploaded {
                    welf.toConfigureMydayPlan()
                } else {
                    
          
                    nonNilSession.indices.forEach { index in
                        nonNilSession[index].isRetrived = false
                    }
                    
                    welf.sessions = nonNilSession
                    
                    welf.setSegment(.workPlan)
                }
                
                
                
                completion()
            }
            
        } else {
            completion()
        }
        
    }
    
    func toSetDayplan(completion: @escaping () -> ()) {
        
        if !isPlanningNewDCR {
        
                masterVM?.toGetMyDayPlan(type: .myDayPlan, isToloadDB: true) {_ in
                    self.toConfigureMydayPlan()
                    self.toSetParams(isfromSyncCall: false) {
                        Shared.instance.isDayplanSet = true
                        completion()
                    }
                }
        } else {
            
            self.toSetParams(isfromSyncCall: false) {
                self.configureSaveplanBtn(self.toEnableSaveBtn(sessionindex: 0,  istoHandeleAddedSession: false))
                completion()
            }
           
          
        }
        
        
        
    }
    
    func istoRedirecttoCheckin() -> Bool {
        
//               LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: "")
//               LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
//               LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        // Assuming you have a storedDateString retrieved from local storage
        let storedDateString = LocalStorage.shared.getString(key: LocalStorage.LocalValue.lastCheckedInDate)
        let storedDate =  storedDateString.toDate(format: "yyyy-MM-dd")
        //dateFormatter.date(from: storedDateString) ?? Date()
        
        let currentDate = Date()

        if appSetups.srtNeed == 1 {
            
            if !Calendar.current.isDate(currentDate, inSameDayAs: storedDate) {
                // Reset the lastCheckedInDate to an empty string
               // LocalStorage.shared.setSting(LocalStorage.LocalValue.lastCheckedInDate, text: "")
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
               // LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: true)
             
                
                self.btnFinalSubmit.setTitle("Final submit", for: .normal)
                
                
                return true
                
                
            }
            
            
            let lastcheckedinDate =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.lastCheckedInDate) //"2024-02-28 14:19:54"
            
            
            let toDayDate = dateFormatter.string(from: Date())
            
            if toDayDate == lastcheckedinDate {
                
                if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.userCheckedOut) {
                    self.btnFinalSubmit.isUserInteractionEnabled = false
                    self.btnFinalSubmit.alpha = 0.5
                  
                }
                
                
                self.btnFinalSubmit.setTitle("Final submit / Check OUT", for: .normal)
                return false
            } else {
                
                LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
                
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                    self.btnFinalSubmit.setTitle("Final submit / Check OUT", for: .normal)
                    return false
                    
                } else {
                    self.btnFinalSubmit.setTitle("Final submit", for: .normal)
                    return true
                }
                
                
            }
            
            
            
        } else {
            return false
        }
    }
    
    
    
    func requestAuth() {
        Pipelines.shared.requestAuth() {[weak self] coordinates in
            guard let welf = self else {return}
            guard coordinates != nil else {
                // "Please connect to active network to update Password"
              //   "Please enable location services in Settings."
                welf.showAlertToNetworks(desc: "Please enable location services in Settings.")
                return
            }
            welf.latitude = coordinates?.latitude
            welf.longitude = coordinates?.longitude
        }
    }
    
    func cellRegistration() {
        self.quickLinkCollectionView.register(UINib(nibName: "QuickLinkCell", bundle: nil), forCellWithReuseIdentifier: "QuickLinkCell")
        
        self.dcrCallsCollectionView.register(UINib(nibName: "DCRCallAnalysisCell", bundle: nil), forCellWithReuseIdentifier: "DCRCallAnalysisCell")
        
        self.analysisCollectionView.register(UINib(nibName: "AnalysisCell", bundle: nil), forCellWithReuseIdentifier: "AnalysisCell")
        

        self.callTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forCellReuseIdentifier: "outboxCollapseTVC")
        
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "outboxCollapseTVC")
        
        self.outboxTableView.register(UINib(nibName: "OutboxDetailsTVC", bundle: nil), forCellReuseIdentifier: "OutboxDetailsTVC")
        
        
        //    self.worktypeTable.register(UINib(nibName: "HomeWorktypeTVC", bundle: nil), forCellReuseIdentifier: "HomeWorktypeTVC")
        
        self.worktypeTable.register(UINib(nibName: "MyDayPlanTVC", bundle: nil), forCellReuseIdentifier: "MyDayPlanTVC")
        
        
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
    }
    
    func toLoadCalenderData() {

        self.tourPlanCalander.register(MyDayPlanCalenderCell.self, forCellReuseIdentifier: "MyDayPlanCalenderCell")
        
        tourPlanCalander.scrollEnabled = false
        tourPlanCalander.calendarHeaderView.isHidden = true
        tourPlanCalander.headerHeight = 0 // this makes some extra spacing, but you can try 0 or 1
        //tourPlanCalander.daysContainer.backgroundColor = UIColor.gray
        tourPlanCalander.rowHeight =  tourPlanCalander.height / 5
        tourPlanCalander.layer.borderColor = UIColor.appSelectionColor.cgColor
        //  tourPlanCalander.calendarWeekdayView.weekdayLabels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        tourPlanCalander.calendarWeekdayView.weekdayLabels.forEach { label in
            label.setFont(font: .medium(size: .BODY))
            label.textColor = .appLightTextColor
        }
        //  tourPlanCalander.layer.borderWidth = 1
        //  tourPlanCalander.layer.cornerRadius = 5
        //  tourPlanCalander.clipsToBounds = true
        tourPlanCalander.placeholderType = .none
        tourPlanCalander.calendarWeekdayView.backgroundColor = .clear
        self.tourPlanCalander.scrollDirection = .horizontal
        self.tourPlanCalander.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        tourPlanCalander.adjustsBoundingRectWhenChangingMonths = true
        
        self.returnWeeklyoffDates()
        togetDCRdates() {
            self.tourPlanCalander.delegate = self
            self.tourPlanCalander.dataSource = self
            self.tourPlanCalander.reloadData()
        }
     
        
     
        //   mainDateLbl.text = toTrimDate(date: tourPlanCalander.currentPage , isForMainLabel: true)
        
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
        
        dateInfoLbl.text = toTrimDate(date: tourPlanCalander.currentPage , isForMainLabel: true)
        lineChatrtView?.addSubview(homeLineChartView ?? HomeLineChartView())
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeLineChartView?.frame = lineChatrtView.bounds
        
        let changePasswordViewwidth = view.bounds.width / 2.7
        let changePasswordViewheight = view.bounds.height / 1.7
        
        let changePasswordViewcenterX = view.bounds.midX - (changePasswordViewwidth / 2)
        let changePasswordViewcenterY = view.bounds.midY - (changePasswordViewheight / 2)
        
        self.changePasswordView?.frame = CGRect(x: changePasswordViewcenterX, y: changePasswordViewcenterY, width: changePasswordViewwidth, height: changePasswordViewheight)
        
        let checkinVIewwidth = view.bounds.width / 3
        let checkinVIewheight = view.bounds.height / 3
        
        let checkinVIewcenterX = view.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = view.bounds.midY - (checkinVIewheight / 2)
        
        
        checkinVIew?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
        
        
        
        
        let checkinDetailsVIewwidth = view.bounds.width / 3
        let checkinDetailsVIewheight = view.bounds.height / 2.3
        
        let checkinDetailsVIewcenterX = view.bounds.midX - (checkinDetailsVIewwidth / 2)
        let checkinDetailsVIewcenterY = view.bounds.midY - (checkinDetailsVIewheight / 2)
        
        
        checkinDetailsView?.frame = CGRect(x: checkinDetailsVIewcenterX, y: checkinDetailsVIewcenterY, width: checkinDetailsVIewwidth, height: checkinDetailsVIewheight)
        
        
        
        
        let  tpDeviateVIewwidth = view.bounds.width / 1.7
        let  tpDeviateVIewheight = view.bounds.height / 2.7
        
        let  tpDeviateVIewcenterX = view.bounds.midX - (tpDeviateVIewwidth / 2)
        let tpDeviateVIewcenterY = view.bounds.midY - (tpDeviateVIewheight / 2)
        
        
        tpDeviateReasonView?.frame = CGRect(x: tpDeviateVIewcenterX, y: tpDeviateVIewcenterY, width: tpDeviateVIewwidth, height: tpDeviateVIewheight)
    }
    
    deinit {
        print("ok bye")
    }
    

    
    
    
    func toLoadOutboxTable(isSynced: Bool? = true) {
        toSetupOutBoxDataSource(isSynced: isSynced ?? false) {
            self.outboxTableView.delegate = self
            self.outboxTableView.dataSource = self
            self.outboxTableView.reloadData()
        }
    }
    
    
    func toLoadWorktypeTable() {
        worktypeTable.delegate = self
        worktypeTable.dataSource = self
        worktypeTable.reloadData()
    }
    
    func toConfigureClearCalls(istoEnable: Bool) {
        if istoEnable {
            clearCallsBtn.alpha = 1
            clearCallsBtn.isUserInteractionEnabled = true
        } else {
            clearCallsBtn.alpha = 0.5
            clearCallsBtn.isUserInteractionEnabled = false
        }
        
    }
    
    func toSetupOutBoxDataSource(isSynced: Bool, completion: @escaping() -> ()) {
        
       // toSeperateDCR(istoAppend: isSynced)
        
        self.outBoxDataArr?.removeAll()
        
        let outBoxDataArr =  self.unsyncedhomeDataArr
        
        if !outBoxDataArr.isEmpty {
            outboxCountVIew.isHidden = false
            
            outboxCallsCountLabel.text = "\(outBoxDataArr.count)"
        } else {
            outboxCountVIew.isHidden = true
        }
        
        
        self.outBoxDataArr = [TodayCallsModel]()
        
        outBoxDataArr.forEach { aHomeData in
            
            let toDdayCall =  TodayCallsModel()
            toDdayCall.aDetSLNo = aHomeData.anslNo ?? ""
            toDdayCall.custCode = aHomeData.custCode ?? ""
            toDdayCall.custName = aHomeData.custName ?? ""
            let type =  Int(aHomeData.custType ?? "0")
            toDdayCall.custType = type ?? 0
            toDdayCall.transSlNo = aHomeData.trans_SlNo ?? ""
            toDdayCall.name = aHomeData.custName ?? ""
            toDdayCall.vstTime = aHomeData.dcr_dt ?? ""
            toDdayCall.submissionDate = aHomeData.dcr_dt ?? ""
            toDdayCall.designation = type == 1 ? "Doctor" : type == 2 ? "Chemist" : type == 3 ? "Stockist" : type == 4 ?  "UnlistedDr." : type == 5 ? "cip" : type == 6 ? "hospital" : ""
            
            toDdayCall.submissionStatus =  aHomeData.rejectionReason  ?? "Waiting to sync"
            //
            self.outBoxDataArr?.append(toDdayCall)
        }


        
        toSeperateOutboxSections(outboxArr: self.outBoxDataArr ?? [TodayCallsModel]()) {
            
            CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventCaptures in
                if self.outBoxDataArr?.count ?? 0 == 0 && unsyncedEventCaptures.isEmpty {
                    self.toConfigureClearCalls(istoEnable: false)
                } else {
                    self.toConfigureClearCalls(istoEnable: true)
                }
                completion()
            }
            
        }
    }
    
    
//    func toSeperateOutboxSections(outboxArr : [TodayCallsModel]) {
//        // Dictionary to store arrays of TodayCallsModel for each day
//        var callsByDay: [String: [TodayCallsModel]] = [:]
//        var eventsByday: [String : UnsyncedEventCaptureModel] = [:]
//        // Create a DateFormatter to parse the vstTime
//
//        
//        
//        // Iterate through the array and organize elements by day
//        for call in outboxArr {
//             let date = call.vstTime.toDate() 
//                let dayString = date.toString(format: "yyyy-MM-dd")
//                
//                // Check if the day key exists in the dictionary
//                if callsByDay[dayString] == nil {
//                    callsByDay[dayString] = [call]
//                } else {
//                    callsByDay[dayString]?.append(call)
//                }
//            
//        }
//        obj_sections.removeAll()
//        // Iterate through callsByDay and create Section objects
//        for (day, calls) in callsByDay {
//            let section = Section(items: calls, date: day)
//            obj_sections.append(section)
//        }
//        
//        
//    }
    
    func toSeperateOutboxSections(outboxArr: [TodayCallsModel], completion: @escaping () -> ()) {
        // Dictionary to store arrays of TodayCallsModel for each day
        var callsByDay: [String: [TodayCallsModel]] = [:]
        var eventsByDay: [String: [UnsyncedEventCaptureModel]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Organize calls by day
        for call in outboxArr {
             let date = call.vstTime.toDate()
                let dayString = dateFormatter.string(from: date)
                if callsByDay[dayString] == nil {
                    callsByDay[dayString] = [call]
                } else {
                    callsByDay[dayString]?.append(call)
                }
            
        }
        
        let dispatchGroup = DispatchGroup()
        
        // Fetch UnsyncedEventCaptureModel data and organize by day
        dispatchGroup.enter()
        CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventCaptures in
            for eventCapture in unsyncedEventCaptures {
                if let eventDate = eventCapture.eventcaptureDate {
                    let dayString = dateFormatter.string(from: eventDate)
                    if eventsByDay[dayString] == nil {
                        eventsByDay[dayString] = [eventCapture]
                    } else {
                        eventsByDay[dayString]?.append(eventCapture)
                    }
                }
            }
            dispatchGroup.leave()
        }
        
        // Wait for all async tasks to complete
        dispatchGroup.notify(queue: .main) {
            // Create sections combining calls and events
            obj_sections.removeAll()
            let allDays = Set(callsByDay.keys).union(eventsByDay.keys)
            for day in allDays {
                let calls = callsByDay[day] ?? []
                let events = eventsByDay[day] ?? []
                let section = Section(items: calls, eventCaptures: events, date: day)
                obj_sections.append(section)
            }
            completion()
        }
    }
    

//    let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        CoreDataManager.shared.toRetriveEventcaptureCDM {
//              unsyncedEventCaptures in
//            
//            
//            
//            for aEvent in unsyncedEventCaptures {
//                
//                let dayString = aEvent.eventcaptureDate?.toString(format: "yyyy-MM-dd")
//                if eventsByday[dayString ?? ""] == nil {
//                    eventsByday[dayString ?? ""] = aEvent
//                } else {
//                    eventsByday[dayString ?? ""]?.append(aEvent)
//                }
//            }
//            
//            dispatchGroup.leave()
//            
//            
//        }
    
    

    
    func toSetParams(date: Date? = Date(), isfromSyncCall: Bool, completion: @escaping () -> ()) {
      //  Shared.instance.showLoader(in: self.viewCalls)
        let appsetup = AppDefaults.shared.getAppSetUp()
        let date = date?.toString(format: "yyyy-MM-dd HH:mm:ss")
        var params = [String : Any]()
        params["tableName"] = "gettodycalls"
        params["sfcode"] =  appsetup.sfCode ?? ""
        params["ReqDt"] = date
        params["division_code"] = appsetup.divisionCode ?? ""
        params["Rsf"] = appsetup.sfCode ?? ""
        params["sf_type"] = appsetup.sfType ?? ""
        params["Designation"] = appsetup.dsName ?? ""
        params["state_code"] = appsetup.stateCode ?? ""
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        print(params)
        getTodayCalls(toSendData, paramData: params, istosyncCall: isfromSyncCall) {
           // Shared.instance.removeLoader(in: self.viewCalls)
            completion()
            
        }
    }
    
    
    func getTodayCalls(_ param: JSON, paramData: JSON, istosyncCall: Bool? = false, completion: @escaping () -> ()) {
    
        userststisticsVM?.getTodayCallsData(params: param, api: .getTodayCalls, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.todayCallsModel = response
                self.callsCountLbl.text = "Call Count: \(response.count)"
                if istosyncCall ?? false {
                    
                        completion()
                    
                } else {
                    completion()
                }
              
               
            case .failure(let error):
           
                
                print(error.localizedDescription)
                self.view.toCreateToast("Error while fetching response from server.")
            
                completion()
                
            }
        }
    }
    
    
    func setupCalls(response: [TodayCallsModel]) {
       
       
    }
    
    
    func setupDataFromDB() {
        
    }
    
    func toloadCallsTable() {
        callTableView.delegate = self
        callTableView.dataSource = self
        callTableView.reloadData()
    }
    


    

    
    private func updatePCPMChart() {
        
        self.viewPcpmChart.startAngle = -90.0
        self.viewPcpmChart.isClockwise = true
        self.viewPcpmChart.font = UIFont(name: "Satoshi-Bold", size: 18)!
        self.viewPcpmChart.fontColor = .darkGray
        if #available(iOS 13.0, *) {
            self.viewPcpmChart.outerRingColor = UIColor.systemGray4
        } else {
            self.viewPcpmChart.outerRingColor = UIColor.lightGray
            // Fallback on earlier versions
        }
        
        self.viewPcpmChart.innerRingColor = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(185.0/255.0), blue: CGFloat(26.0/255.0), alpha: CGFloat(1.0))
        self.viewPcpmChart.innerRingWidth = 25.0
        self.viewPcpmChart.style = .bordered(width: 0.0, color: .black)
        self.viewPcpmChart.outerRingWidth = 25.0
        
        self.viewPcpmChart.maxValue = CGFloat(truncating: 10.0)
        self.viewPcpmChart.startProgress(to: CGFloat(truncating: 4.0), duration: 2)
    }

    private func updateLinks () {
        
        let presentationColor = UIColor.appGreen
        let activityColor = UIColor.appBrown
        let reportsColor = UIColor.appLightPink
        let previewColor = UIColor.appBlue
        
        
        let presentation = QuicKLink(color: presentationColor, name: "Presentaion", image: UIImage(imageLiteralResourceName: "presentationIcon"))
        let activity = QuicKLink(color: activityColor, name: "Activity", image: UIImage(imageLiteralResourceName: "activity"))
        let reports = QuicKLink(color: reportsColor, name: "Reports", image: UIImage(imageLiteralResourceName: "reportIcon"))
        
        let slidePreview = QuicKLink(color: previewColor, name: "Slide Preview", image: UIImage(imageLiteralResourceName: "slidePreviewIcon"))
        
        self.links.append(presentation)
        self.links.append(slidePreview)
        self.links.append(reports)
        self.links.append(activity)
        
        
        
    }
    
    func isDateInCurrentMonthAndYear(_ dateString: String?, currentDate: Date, iftosyncOutbox: Bool? = false) -> Bool {
        guard let dateString = dateString else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = iftosyncOutbox ?? false ?  "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
        if let dcrDate = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)
            let dcrMonth = calendar.component(.month, from: dcrDate)
            let dcrYear = calendar.component(.year, from: dcrDate)
            return dcrMonth == currentMonth && dcrYear == currentYear
        }
        return false
    }

    
    private func updateDcr () {
        
        
        self.dcrCount.removeAll()
        // Get the current date
        let currentDate = Date()
        // Filter the array based on the current month and year

        if appSetups.docNeed == 0 {
            let unsyncedDoc = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "1"
             }
             
             let unsyncedDocilteredArray = unsyncedDoc.filter { model in
                 return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
             }
             
             let doctorCount = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
             
             
             let DoctorfilteredArray = doctorArr.filter { model in
                 return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
             }
             
             self.dcrCount.append(DcrCount(name: "Listed Doctor",color: .appGreen,count: doctorCount.description, image: UIImage(named: "ListedDoctor") ?? UIImage(), callsCount:  DoctorfilteredArray.count + unsyncedDocilteredArray.count))
        }

        if appSetups.chmNeed == 0 {
            let unsyncedChemist = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "2"
             }
            
            
            let unsyncedChemistilteredArray = unsyncedChemist.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
            }
            
            let chemistCount = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            let ChemistfilteredArray = chemistArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
            
            self.dcrCount.append(DcrCount(name: "Chemist",color: .appBlue,count: chemistCount.description, image: UIImage(named: "Chemist") ?? UIImage(), callsCount:  ChemistfilteredArray.count + unsyncedChemistilteredArray.count))
        }
        
        
        if appSetups.stkNeed == 0 {
            let unsyncedStockist = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "3"
             }
            
            let unsyncedStockistilteredArray = unsyncedStockist.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
            }
            
            let stockistFilteredArray = stockistArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
             
            
            let stockistCount = DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            self.dcrCount.append(DcrCount(name: "Stockist",color: .appLightPink,count: stockistCount.description, image: UIImage(named: "Stockist") ?? UIImage(), callsCount: stockistFilteredArray.count + unsyncedStockistilteredArray.count))
        }
        
        
        if appSetups.unlNeed == 0 {
            
            let unsyncedunlistedDoc = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "4"
             }
            let unsyncedunlistedDocilteredArray = unsyncedunlistedDoc.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
            }
            
            let unlistedDocFilteredArray = unlistedDocArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
            
            let unlistedDocCount = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            
            self.dcrCount.append(DcrCount(name: "UnListed Doctor",color: .appLightTextColor.withAlphaComponent(0.2) ,count: unlistedDocCount.description, image: UIImage(named: "Doctor") ?? UIImage(), callsCount: unlistedDocFilteredArray.count + unsyncedunlistedDocilteredArray.count))
        }

        

        
        
        
//        let cipFilteredArray = cipArr.filter { model in
//            return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
//        }
//        self.dcrCount.append(DcrCount(name: "Cip Calls",color: .appYellow,count: DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count.description, image: UIImage(named: "cip") ?? UIImage(), callsCount: cipFilteredArray.count))
//        
//        
//        let hospitalFilteredArray = cipArr.filter { model in
//            return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
//        }
//        
//        self.dcrCount.append(DcrCount(name: "Hospital Calls",color: .appBrown,count: DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count.description, image: UIImage(named: "hospital") ?? UIImage(), callsCount: hospitalFilteredArray.count))
        
    }
    
    private func createSwipeGesture(direction : UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipe.direction = direction
        return swipe
    }
    
    @objc private func swipeAction(_ sender : UISwipeGestureRecognizer) {
        // self.viewProfile.isHidden = true
        self.viewDayPlanStatus.isHidden = true
        
        switch sender.direction {
            
        case .left :
            
            var value =  self.segmentControlForAnalysis.selectedSegmentIndex
            value += 1
            
            self.segmentControlForAnalysis.selectedSegmentIndex = value > 2 ? 2 : value
            switch value{
            case 0:
                self.lblAnalysisName.text = "Call Analysis"
                self.salesStackView.isHidden = true
                self.slideStackView.isHidden = true
                self.callStackView.isHidden = false
            case 1:
                self.lblAnalysisName.text = "E-Detailing Analysis"
                self.salesStackView.isHidden = true
                self.slideStackView.isHidden = false
                self.callStackView.isHidden = true
            case 2:
                self.lblAnalysisName.text = "Sales Analysis"
                self.salesStackView.isHidden = false
                self.slideStackView.isHidden = true
                self.callStackView.isHidden = true
            default:
                break
            }
        case .right :
            var value =  self.segmentControlForAnalysis.selectedSegmentIndex
            value -= 1
            
            self.segmentControlForAnalysis.selectedSegmentIndex = value < 0 ? 0 : value
            
            switch value {
            case 0:
                self.lblAnalysisName.text = "Call Analysis"
                self.salesStackView.isHidden = true
                self.slideStackView.isHidden = true
                self.callStackView.isHidden = false
            case 1:
                self.lblAnalysisName.text = "E-Detailing Analysis"
                self.salesStackView.isHidden = true
                self.slideStackView.isHidden = false
                self.callStackView.isHidden = true
            case 2:
                self.lblAnalysisName.text = "Sales Analysis"
                self.salesStackView.isHidden = false
                self.slideStackView.isHidden = true
                self.callStackView.isHidden = true
            default:
                break
            }
        default:
            break
        }
    }
    
    func setSegment(_ segmentType: SegmentType, isfromSwipe: Bool? = false) {
        switch segmentType {
            
        case .workPlan:
            viewWorkPlan.isHidden = false
            viewCalls.isHidden = true
            viewOutBox.isHidden = true
            viewDayPlanStatus.isHidden = true
            
        
               toLoadWorktypeTable()
            
            
           
           // if isfromSwipe ?? false {
                self.selectedSegmentsIndex = 0
                self.segmentsCollection.reloadData()
          //  }
            
            
        case .calls:
            // callsSegmentHolderVIew.isHidden = false
            // outboxSegmentHolderView.isHidden = true
            viewWorkPlan.isHidden = true
            viewCalls.isHidden = false
            viewOutBox.isHidden = true
            viewDayPlanStatus.isHidden = true
            toloadCallsTable()
          //  if isfromSwipe ?? false {
                self.selectedSegmentsIndex = 1
                self.segmentsCollection.reloadData()
           // }
            
            
        case .outbox:
            // outboxSegmentHolderView.isHidden = false
            viewWorkPlan.isHidden = true
            viewCalls.isHidden = true
            viewOutBox.isHidden = false
            viewDayPlanStatus.isHidden = true
            // callsSegmentHolderVIew.isHidden = true
            toLoadOutboxTable()
          //  if isfromSwipe ?? false {
                self.selectedSegmentsIndex = 2
                self.segmentsCollection.reloadData()
          //  }
            
        case .calender:
            viewWorkPlan.isHidden = true
            viewCalls.isHidden = true
            viewOutBox.isHidden = true
            viewDayPlanStatus.isHidden = false
        }
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1



        
        
        if moveUp {
            
            if let nextMonth = calendar.date(byAdding: .month, value: 0 , to: self.today) {
                print("Next Month:", nextMonth)
                self.currentPage = nextMonth

                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
                
            }
 

        } else if !moveUp{

            
            if let previousMonth = calendar.date(byAdding: .month, value: -1 , to: self.today) {
                print("Previous Month:", previousMonth)
                self.currentPage = previousMonth
               
                toDisableNextPrevBtn(enableprevBtn: false, enablenextBtn: true)
            }
            



        }
        
        self.tourPlanCalander.setCurrentPage(self.currentPage!, animated: true)
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
    
}

extension MainVC {
    
    @IBAction func didtapDeviateSwitch(_ sender: UISwitch) {
        if sender.isOn {
            deviateAction(isForremarks: false)
            setDeviateSwitch(istoON: true)
        } else {
            // Switch is OFF
            // Perform actions when the switch is turned off
        }
        
    }

    @IBAction func didTapPrevBtn(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }

    @IBAction func didTapCalNextBtn(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
    }

    @IBAction func btnCalenderSync(_ sender: Any) {
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            Shared.instance.showLoaderInWindow()
            masterVM?.tofetchDcrdates() {[weak self] result in
                guard let welf = self else {return}
                switch result {
                    
                case .success(let response):
                 //   Shared.instance.removeLoaderInWindow()
                    CoreDataManager.shared.saveDatestoCoreData(model: response)
                    welf.returnWeeklyoffDates()
                    welf.togetDCRdates() {
                        welf.tourPlanCalander.delegate = self
                        welf.tourPlanCalander.dataSource = self
                        welf.tourPlanCalander.reloadData()
                    }
                case .failure(let error):
                  //  Shared.instance.removeLoaderInWindow()
                    welf.toCreateToast("\(error)")
                }
            }
            

            
        } else {
            
            self.toCreateToast("OOPS! Unable sync dates.")
        }
        
    }

    @IBAction func didTapFinalSubmit(_ sender: Any) {
        if isDayPlanRemarksadded {
            if appSetups.srtNeed == 1 {
                checkoutAction()
            } else {
                print("Yet to implement final submit")
            }
          
        } else {
            if appSetups.srtNeed == 1 {
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                    self.toSetupSubmitAlert()
                } else {
                    self.checkinAction()
                }
            } else {
                self.toSetupSubmitAlert()
            }

            
         
        }

    }



    @IBAction func didTapClearCalls() {
        
        
        self.outboxCountVIew.isHidden = true
        self.outBoxDataArr?.removeAll()
        //LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: Data())
        CoreDataManager.shared.removeAllOutboxParams()
        CoreDataManager.shared.removeUnsyncedHomeData()
        CoreDataManager.shared.removeAllUnsyncedEventCaptures()
        toSeperateDCR(istoAppend: false)
        self.updateDcr()
        DispatchQueue.main.async {
            
            self.toLoadOutboxTable()
            self.toLoadDcrCollection()
            self.toIntegrateChartView(self.chartType, self.cacheDCRindex)
        }
    }

    @IBAction func outboxCallSyncAction(_ sender: UIButton) {
        
    }

    @IBAction func callAction(_ sender: UIButton) {
        
        if istoRedirecttoCheckin() {
            checkinAction()
            
        } else {
            let callVC = UIStoryboard.callVC
            
            self.navigationController?.pushViewController(callVC, animated: true)
        }
        
        
        
        
    }

    @IBAction func todayCallSyncAction(_ sender: UIButton) {

        toSetParams(isfromSyncCall: true) {
            self.refreshDashboard {
                
            }
        }

    }

    @IBAction func notificationAction(_ sender: UIButton) {
        
        // checkinAction()
        
    }


    @IBAction func masterSyncAction(_ sender: UIButton) {
        
        let masterSync = MasterSyncVC.initWithStory()
        masterSync.isfromHome = true
        masterSync.delegate = self
        self.navigationController?.pushViewController(masterSync, animated: true)
        
    }


    @IBAction func profileAction(_ sender: UIButton) {
        print("Tapped -->")
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.view.width / 4, height: self.view.height / 2.3), on: btnProfile, pagetype: .profile)
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
            //.present(vc, animated: true)
        
    }


    @IBAction func didTapAddplan(_ sender: Any) {
        
        toHighlightAddedCell()
        self.configureAddplanBtn(false)
        self.toLoadWorktypeTable()
        
        //(aSession)
    }


    @IBAction func sideMenuAction(_ sender: UIButton) {
        
        print("Tapped")
        let menuvc =   HomeSideMenuVC.initWithStory(self)
        menuvc.delegate = self
        self.modalPresentationStyle = .custom
        self.navigationController?.present(menuvc, animated: false)
        
    }


    @IBAction func dateAction(_ sender: UIButton) {
        
        if istoRedirecttoCheckin() {
            checkinAction()
            
        } else {
            self.selectedSegment  = self.selectedSegment  != .calender ?   .calender :   segmentType[selectedSegmentsIndex]
            self.setSegment(self.selectedSegment)
        }
        
    }


    @IBAction func didTapSaveBtn(_ sender: Any) {
        // Ensure you have sessions to save
        
        if istoRedirecttoCheckin() {
            checkinAction()
            
        } else {
            //let isnotToSave = toHighlightAddedCell() ?? true
            
            guard var yetToSaveSession = self.sessions else {
                return
            }
            
            
            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                yetToSaveSession.indices.forEach { index in
                    yetToSaveSession[index].isRetrived = true
                    //yetToSaveSession[index] = true
                    yetToSaveSession[index].planDate = self.selectedRawDate
                }
            } else {
                yetToSaveSession.indices.forEach { index in
                    if  yetToSaveSession[index].isRetrived == true {
                        yetToSaveSession[index].planDate = self.selectedRawDate
                    } else {
                        yetToSaveSession[index].isRetrived = false
                        yetToSaveSession[index].planDate = self.selectedRawDate
                    }
                }
            }
            
            
            
            updateEachDayPlan(yetToSaveSession: yetToSaveSession) { [weak self] _  in
                guard let welf = self else {return}
                guard var nonNilSession = welf.sessions else {
                    return
                }

                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                    welf.callSavePlanAPI() { isUploaded in
                        if isUploaded {
                            welf.toConfigureMydayPlan()
                            
                            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoUploadDayplans, value: false)
                            
                        } else {
                            
                  
                            nonNilSession.indices.forEach { index in
                                nonNilSession[index].isRetrived = false
                                nonNilSession[index].planDate = welf.selectedRawDate == nil ? Date() : welf.selectedRawDate
                            }
                            
                            welf.sessions = nonNilSession
                            
                            welf.setSegment(.workPlan)
                        }
                        
                    }
                    
                } else {
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.istoUploadDayplans, value: true)
                 //   welf.masterVM?.toUpdateDataBase(aDayplan: <#T##DayPlan#>, completion: <#T##(Bool) -> ()#>)
                   // welf.toConfigureMydayPlan()
                    nonNilSession.indices.forEach { index in
                        nonNilSession[index].isRetrived = true
                        nonNilSession[index].planDate = welf.selectedRawDate == nil ? Date() : welf.selectedRawDate
                        
                    }
                    
                    welf.sessions = nonNilSession
                    
                    welf.setSegment(.workPlan)
                    
                //    welf.toEnableSaveBtn(sessionindex: welf.selectedSessionIndex ?? 0,  istoHandeleAddedSession: false)
                    
                    welf.configureSaveplanBtn(welf.toEnableSaveBtn(sessionindex: welf.selectedSessionIndex ?? 0,  istoHandeleAddedSession: false))
                    
                    if nonNilSession.count == 2 {
                        welf.configureAddplanBtn(false)
                    } else {
                        welf.configureAddplanBtn(true)
                    }
                    
                   
                    
                  //  welf.configureSaveplanBtn(<#T##isToEnable: Bool##Bool#>)
                    
                    welf.toCreateToast("You are not connected to internet")
                }
                
                
            }
            
        }
        
        
        
        
        
    }

}

extension MainVC: MenuResponseProtocol {
    func passProductsAndInputs(product: ProductSelectedListViewModel, additioncall: AdditionalCallsListViewModel,index: Int) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        //        let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context),
        //         let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
        guard let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }
        
        //  let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
        //  let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        switch type {
            
        case .workType:
            if self.selectedSessionIndex == 0 {
                self.fetchedWorkTypeObject1 = selectedObject as? WorkType
                self.sessions?[selectedSessionIndex ?? 0].workType = fetchedWorkTypeObject1
            } else {
                self.fetchedWorkTypeObject2 = selectedObject as? WorkType
                self.sessions?[selectedSessionIndex ?? 0].workType = fetchedWorkTypeObject2
            }
            
            self.tableCellheight =  setupHeight(true, index: 0)
            
            self.toLoadWorktypeTable()
        case .cluster:
            if self.selectedSessionIndex == 0 {
                self.fetchedClusterObject1 = selectedObjects as? [Territory]
            } else {
                self.fetchedClusterObject2 = selectedObjects as? [Territory]
            }
            
            
            sessions?.enumerated().forEach({index, aSessions in
                switch index {
                case 0:
                    if !(aSessions.isRetrived ?? false) {
                        self.sessions?[index].cluster = fetchedClusterObject1
                    } else {
                        //  self.sessions?[index].cluster = cacheTerritory ?? [temporaryselectedClusterobj]
                    }
                case 1:
                    if !(aSessions.isRetrived ?? false) {
                        self.sessions?[index].cluster = fetchedClusterObject2
                    } else {
                        //   self.sessions?[index].cluster = cacheTerritory ?? [temporaryselectedClusterobj]
                    }
                    
                default:
                    print("Yet to implement")
                }
                
            })
            
            self.toLoadWorktypeTable()
        case .headQuater:
            
            switch self.selectedSessionIndex {
                
            case 0:
                if  self.fetchedHQObject1 == nil {
                    self.fetchedHQObject1 = selectedObject as? Subordinate
                }
                
                // self.sessions?[selectedSessionIndex ?? 0].headQuarters = fetchedHQObject1
                
                if self.fetchedHQObject1?.id != (selectedObject as? Subordinate)?.id {
                    self.fetchedHQObject1 = selectedObject as? Subordinate
                    
                    if !(self.sessions?[selectedSessionIndex ?? 0].isRetrived ?? false) {
                        sessions?[selectedSessionIndex ?? 0].cluster = [temporaryselectedClusterobj]
                        //self.sessions?[selectedSessionIndex].cluster =
                        
                    }
                    
                    
                } else {
                    
                    if  (sessions?[selectedSessionIndex ?? 0].isRetrived ?? false) {
                        sessions?[selectedSessionIndex ?? 0].cluster = fetchedClusterObject1
                    }
                    
                    
                    
                }
                let aHQobj = HQModel()
                aHQobj.code = self.fetchedHQObject1?.id ?? String()
                aHQobj.mapId = self.fetchedHQObject1?.mapId ?? String()
                aHQobj.name = self.fetchedHQObject1?.name ?? String()
                aHQobj.reportingToSF = self.fetchedHQObject1?.reportingToSF ?? String()
                aHQobj.steps = self.fetchedHQObject1?.steps ?? String()
                aHQobj.sfHQ = self.fetchedHQObject1?.sfHq ?? String()
                
                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context)
                        
                else {
                    fatalError("Entity not found")
                }
                
                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                
                temporaryselectedHqobj.code                  = aHQobj.code
                temporaryselectedHqobj.name                 = aHQobj.name
                temporaryselectedHqobj.reportingToSF       = aHQobj.reportingToSF
                temporaryselectedHqobj.steps                 = aHQobj.steps
                temporaryselectedHqobj.sfHq                   = aHQobj.sfHQ
                temporaryselectedHqobj.mapId                  = aHQobj.mapId
                
                sessions?[selectedSessionIndex ?? 0].headQuarters = temporaryselectedHqobj

                toLoadWorktypeTable()
                let territories = DBManager.shared.getTerritory(mapID:  aHQobj.code)
                
                if territories.isEmpty {
                    Shared.instance.showLoaderInWindow()
                    masterVM?.fetchMasterData(type: .clusters, sfCode: aHQobj.code, istoUpdateDCRlist: true, mapID: aHQobj.code) { [weak self] _  in
                        guard let welf = self else {return}
                       
                        welf.setHQ(aHQobj: aHQobj) {
                            Shared.instance.removeLoaderInWindow()
                            welf.toCreateToast("Clusters synced successfully")
                        }
                  
                    }
                } else {
                    self.setHQ(aHQobj: aHQobj) { }
                  
                    
                }
                
            case 1:
                
                if  self.fetchedHQObject2 == nil {
                    self.fetchedHQObject2 = selectedObject as? Subordinate
                }
                
                // self.sessions?[selectedSessionIndex ?? 0].headQuarters = self.getSubordinate(hqCode: <#T##String#>)
                
                if self.fetchedHQObject2?.id != (selectedObject as? Subordinate)?.id {
                    self.fetchedHQObject2 = selectedObject as? Subordinate
                    
                    
                    if !(self.sessions?[selectedSessionIndex ?? 0].isRetrived ?? false) {
                        sessions?[selectedSessionIndex ?? 0].cluster = [temporaryselectedClusterobj]
                        //self.sessions?[selectedSessionIndex].cluster =
                    }
                    
                } else {
                    
                    if  (sessions?[selectedSessionIndex ?? 0].isRetrived ?? false) {
                        sessions?[selectedSessionIndex ?? 0].cluster =  fetchedClusterObject2
                    }
                    
                }
                let aHQobj = HQModel()
                aHQobj.code = self.fetchedHQObject2?.id ?? String()
                aHQobj.mapId = self.fetchedHQObject2?.mapId ?? String()
                aHQobj.name = self.fetchedHQObject2?.name ?? String()
                aHQobj.reportingToSF = self.fetchedHQObject2?.reportingToSF ?? String()
                aHQobj.steps = self.fetchedHQObject2?.steps ?? String()
                aHQobj.sfHQ = self.fetchedHQObject2?.sfHq ?? String()
                
                
                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: context)
                        
                else {
                    fatalError("Entity not found")
                }
                
                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                
                temporaryselectedHqobj.code                  = aHQobj.code
                temporaryselectedHqobj.name                 = aHQobj.name
                temporaryselectedHqobj.reportingToSF       = aHQobj.reportingToSF
                temporaryselectedHqobj.steps                 = aHQobj.steps
                temporaryselectedHqobj.sfHq                   = aHQobj.sfHQ
                temporaryselectedHqobj.mapId                  = aHQobj.mapId
                sessions?[selectedSessionIndex ?? 0].headQuarters = temporaryselectedHqobj
                
                
                LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aHQobj.code)
                toLoadWorktypeTable()
                let territories = DBManager.shared.getTerritory(mapID:  aHQobj.code)
                
                
                
                if territories.isEmpty {
                    Shared.instance.showLoaderInWindow()
                    masterVM?.fetchMasterData(type: .clusters, sfCode: aHQobj.code, istoUpdateDCRlist: true, mapID: aHQobj.code) { [weak self] _  in
                        
                        guard let welf = self else {return}
                        
                        Shared.instance.removeLoaderInWindow()
                        welf.toCreateToast("Clusters synced successfully")
                    }
                }
                
            default:
                print("Yet to implement")
            }
            
            
            
            
            
            
            
        default:
            print("Yet to implement.")
        }
        
        guard let tempSessionIndex = self.selectedSessionIndex   else {return}
        
        if sessions?.count == 2 {
            // index = tempSessionIndex == 0 ? 1 : 0
            self.configureSaveplanBtn(self.toEnableSaveBtn(sessionindex: tempSessionIndex, istoHandeleAddedSession: true))
        } else {
            self.configureSaveplanBtn(self.toEnableSaveBtn(sessionindex: tempSessionIndex,  istoHandeleAddedSession: false))
        }
        
        
        
    }
    
    func setHQ(aHQobj: HQModel, completion: @escaping () -> () ) {
        CoreDataManager.shared.removeDayPlanHQ()
        CoreDataManager.shared.saveToDayplanHQCoreData(hqModel: aHQobj) { _ in
            LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text: aHQobj.code)
            completion()
       
        }
    }
    
    func toCheckExistenceInSession() {
        
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        print("Yet to implement")
    }
    
    
    func routeToView(_ view : UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}


extension MainVC : MasterSyncVCDelegate {
    func isHQModified(hqDidChanged: Bool) {
        
                if hqDidChanged {
                    toConfigureMydayPlan()
    
                }
        
    }
}

extension MainVC : HomeLineChartViewDelegate
{
    
    
    func didSetValues(values: [String], valueStr: String) {
        
        
        self.monthRangeLbl.text = valueStr
        switch values.count {
            
        case 0:
            toHodeMonthStact(count: 0)
            
            
        case 1:
            
            toHodeMonthStact(count: 1)
            
        case 2:
            toHodeMonthStact(count: 2)
            
            
        case 3:
            
            toHodeMonthStact(count: 3)
            
            
        default:
            print("Above / Below")
        }
        
        
        
        
        func toHodeMonthStact(count: Int) {
            
            let views: [UIView] = [month1View, month2View, month3View]
            let labels : [UILabel] = [month1Lbl, month2Lbl, month3Lbl]
            switch count {
            case 0:
                views.enumerated().forEach { aViewIndex, aView in
                    aView.isHidden = true
                }
                labels.forEach { aLabel in
                    aLabel.isHidden = true
                }
            case 1:
                
                views.forEach { aView in
                    switch aView {
                    case month1View:
                        aView.isHidden = false
                    default:
                        aView.isHidden = true
                        
                    }
                }
                labels.enumerated().forEach {aLabelIndex, aLabel in
                    switch aLabel {
                    case month1Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[0]
                    default:
                        aLabel.isHidden = true
                        
                    }
                }
                
            case 2:
                views.forEach { aView in
                    switch aView {
                    case month1View, month2View:
                        aView.isHidden = false
                    default:
                        aView.isHidden = true
                        
                    }
                }
                labels.enumerated().forEach {aLabelIndex,  aLabel in
                    switch aLabel {
                    case month1Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[0]
                        
                    case month2Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[1]
                    default:
                        aLabel.isHidden = true
                        
                    }
                }
                
                
            case 3:
                views.forEach { aView in
                    switch aView {
                    case month1View, month2View, month3View:
                        aView.isHidden = false
                    default:
                        aView.isHidden = true
                        
                    }
                }
                labels.enumerated().forEach {aLabelIndex,  aLabel in
                    switch aLabel {
                    case month1Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[0]
                        
                    case month2Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[1]
                        
                    case month1Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[0]
                        
                    case month3Lbl:
                        aLabel.isHidden = false
                        aLabel.text = values[2]
                    default:
                        aLabel.isHidden = true
                        
                    }
                }
            default:
                print("Out of range")
            }
        }
        
    }
}

extension MainVC : collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.segmentsCollection:
            return segmentType.count
        case self.quickLinkCollectionView :
            return self.links.count
        case self.dcrCallsCollectionView:
            return self.dcrCount.count
        case self.analysisCollectionView:
            return 4
        case self.eventCollectionView:
            return eventArr.count
        default:
            return 0
        }
    }
    
    func toSetupUpdatePasswordAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Log out", cancelAction: "Dismiss")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            
            Pipelines.shared.doLogout()
            commonAlert.addAdditionalCancelAction {
                
                print("no action")
            }
        }
    }
    
    func toSetupAlert() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "Please do try syncing All slides!.", okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case self.segmentsCollection:
            let cell: PreviewTypeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewTypeCVC", for: indexPath) as! PreviewTypeCVC
            
            
            cell.selectionView.isHidden =  selectedSegmentsIndex == indexPath.row ? false : true
            cell.titleLbl.textColor =  selectedSegmentsIndex == indexPath.row ? .appTextColor : .appLightTextColor
            cell.titleLbl.text = segmentType[indexPath.row].rawValue
            
            
            
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedSegmentsIndex  = indexPath.row
                
                welf.segmentsCollection.reloadData()
                
                
                switch welf.segmentType[welf.selectedSegmentsIndex] {
                    
                case .workPlan:
                    
                    welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
                    
                case .calls :
                    
                    welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
                    
                    
                case .outbox:
                    
                    welf.setSegment(welf.segmentType[welf.selectedSegmentsIndex])
                case .calender:
                    print("Yet to implement")
                }
            }
            
            
            return cell
        case self.quickLinkCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickLinkCell", for: indexPath) as! QuickLinkCell
            cell.link = self.links[indexPath.row]
            
            cell.addTap {
                switch cell.link.name {
                case "Presentaion":
                    
                    if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesLoaded) {
                        let vc =  PresentationHomeVC.initWithStory()
                    vc.mastersyncVM = self.masterVM ?? MasterSyncVM()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.toSetupAlert()
                   }
                    
                case "Slide Preview":
                    if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesLoaded) {
                    let vc = PreviewHomeVC.initWithStory()
                    self.navigationController?.pushViewController(vc, animated: true)
                }  else {
                    self.toSetupAlert()
               }
                case "Reports":
          
                        let vc = ReportsVC.initWithStory(pageType: .reports)
                        self.navigationController?.pushViewController(vc, animated: true)
             
                default:
                    print("Yet to")
                }
            }
            
            return cell
        case self.dcrCallsCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRCallAnalysisCell", for: indexPath) as! DCRCallAnalysisCell
            cell.imgArrow.isHidden = true
            let model =  self.dcrCount[indexPath.row]
            cell.dcrCount = model
            // cell.imgArrow.image = UIImage(named: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysTemplate)
            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                cell.setCellType(cellType: .MR)
                // lblName.text = self.dcrCount.name
                if self.selectedCallIndex == indexPath.row {
                    cell.imgArrow.isHidden = false
                }
            } else {
                cell.setCellType(cellType: .Manager)
                if self.selectedCallIndex == indexPath.row {
                    cell.imgArrow.isHidden = false
                }
            }
            
            
            
            
            cell.addTap {
                let model = self.dcrCount[indexPath.row]
                self.cacheDCRindex = indexPath.row
                self.selectedCallIndex = indexPath.row
                if model.name == "Listed Doctor" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.doctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Doctor Calls"
                } else if model.name == "Chemist" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.chemist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Chemist Calls"
                } else if model.name == "Stockist" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.stockist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Stockist Calls"
                } else if model.name == "UnListed Doctor" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.unlistedDoctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average UnListed Doctor Calls"
                }
                self.dcrCallsCollectionView.reloadData()
                //
                // }
            }
            return cell
        case self.analysisCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
            if indexPath.row != 0 {
                //   cell.viewAnalysis.backgroundColor = color
                cell.imgArrow.isHidden = true
            }
            //                if indexPath.row == 1{
            //                    cell.lblName.text = "Brand Analysis"
            //                    cell.lblDetail.text = "Brand wise detailed to doctors & Chemists with duration"
            //                }
            //                if indexPath.row == 2{
            //                    cell.lblName.text = "Specialty Analysis"
            //                    cell.lblDetail.text = "Specialty wise detailed to doctors by brand & product"
            //                }
            
            return cell
        case self.eventCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayPlanEventCell", for: indexPath) as! DayPlanEventCell
            
           // _ = self.homeDataArr
            
            cell.lblEvent.text = eventArr[indexPath.row]
            cell.lblEvent.textColor = colorArr[indexPath.row]
            cell.vxView.backgroundColor = colorArr[indexPath.row]
            //cell.viewEvent.backgroundColor = colorArr[indexPath.row]
            
            //     cell.width1 = collectionView.bounds.width - Constants.spacing
            cell.Border_Radius(border_height: 0.0, isborder: false, radius: 5)
            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickLinkCell", for: indexPath) as! QuickLinkCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case segmentsCollection:
            // return CGSize(width:segmentType[indexPath.item].rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
            return CGSize(width: collectionView.width / 3, height: collectionView.height)
        case self.quickLinkCollectionView :
            let width = self.quickLinkCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: 60)
            return size
        case self.dcrCallsCollectionView :
            let width = self.dcrCallsCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: self.dcrCallsCollectionView.frame.height)
            return size
        case self.analysisCollectionView :
            let width = self.analysisCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: self.analysisCollectionView.frame.height)
            return size
        case self.eventCollectionView:
            let width = self.eventCollectionView.bounds.width - Constants.spacing
            let size = CGSize(width: width, height: 60)
            return size
        default :
            let width = self.analysisCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: self.analysisCollectionView.frame.height)
            return size
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}


extension MainVC : tableViewProtocols , CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int) {
        
        for index in obj_sections.indices {
            if index == section {
                let collapsed = !obj_sections[section].collapsed
                obj_sections[section].collapsed = collapsed
            } else {
                obj_sections[index].collapsed = true
            }
            obj_sections[index].isCallExpanded = false
        }
        
        
        
        // Reload the whole section
        self.outboxTableView.reloadData()
     
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch tableView  {
        case outboxTableView:
            return obj_sections.count
            
            
        case worktypeTable:
            return 1
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {

        case self.callTableView:
            return self.todayCallsModel?.count ?? 0
        case self.outboxTableView:
            if obj_sections.isEmpty {
                return  0
            } else {
                return obj_sections[section].collapsed ? 0 : 1
            }
            
        case self.worktypeTable:
            
            guard let nonEmptySession = self.sessions else {
                
                return 1
                
            }
            
            if nonEmptySession.isEmpty {
                return 1
            } else {
                return nonEmptySession.count
            }
        default :
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {

        case self.callTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DCRCallCell", for: indexPath) as! DCRCallCell
            cell.selectionStyle = .none
            //  cell.imgProfile.backgroundColor = UIColor.random()
            let model: TodayCallsModel = self.todayCallsModel?[indexPath.row] ?? TodayCallsModel()
            cell.topopulateCell(model)
            cell.optionsBtn.addTap {
                print("Tapped -->")
                let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 3, height: 90), on: cell.optionsBtn,  pagetype: .calls)
                 vc.delegate = self
                 vc.selectedIndex = indexPath.row
                self.navigationController?.present(vc, animated: true)
            }
            return cell
        case self.outboxTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutboxDetailsTVC", for: indexPath) as! OutboxDetailsTVC
            let model = obj_sections[indexPath.section].items
            let eventModel = obj_sections[indexPath.section].eventCaptures
            cell.delegate = self
            cell.viewController = self
            cell.todayCallsModel = model
            cell.eventCaptureModel = eventModel
            //[indexPath.row]
            //self.outBoxDataArr
            let count = model.count
            //self.outBoxDataArr?.count ?? 0
            cell.callsCountLbl.text = "\(count)"
            cell.eventCOuntLbl.text = "\(eventModel.count)"
            cell.toLoadData()
            
            
            if  !obj_sections[indexPath.section].isCallExpanded {
                cell.toSetCallsCellHeight(callsExpandState:  .callsNotExpanded)
               
            }
            
            if  !obj_sections[indexPath.section].isEventEcpanded {
                cell.toSetEventsCellheight(callsExpandState:  .eventNotExpanded)
                
            }
            
            
            cell.callsCollapseIV.addTap {
                cell.eventExpandState  = .eventNotExpanded
                obj_sections[indexPath.section].isEventEcpanded = false
                cell.callsExpandState =  cell.callsExpandState == .callsNotExpanded ?  .callsExpanded : .callsNotExpanded
                if cell.callsExpandState == .callsExpanded {
                    obj_sections[indexPath.section].isCallExpanded = true
 
                } else {
                    obj_sections[indexPath.section].isCallExpanded = false
   
                }
                cell.toSetCallsCellHeight(callsExpandState:  cell.callsExpandState)
                cell.toSetEventsCellheight(callsExpandState: .eventNotExpanded)
                self.outboxTableView.reloadData()
            }
            
            
            
            
            cell.eventCollapseIV.addTap {
                cell.callsExpandState = .callsNotExpanded
                obj_sections[indexPath.section].isCallExpanded = false
                cell.eventExpandState =  cell.eventExpandState != .eventNotExpanded ? .eventNotExpanded  : .eventExpanded
                
        
                if cell.eventExpandState == .eventExpanded {
                    obj_sections[indexPath.section].isEventEcpanded = true
                    
 
                } else {
                    obj_sections[indexPath.section].isEventEcpanded = false
   
                }
                cell.toSetEventsCellheight(callsExpandState:  cell.eventExpandState)
                cell.toSetCallsCellHeight(callsExpandState:  .callsNotExpanded)
                self.outboxTableView.reloadData()
            }
            
            
            // cell.imgProfile.backgroundColor = UIColor.random()
            cell.selectionStyle = .none
            return cell
            
        case worktypeTable:
            guard let nonEmtySession = self.sessions,  !nonEmtySession.isEmpty else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyDayPlanTVC", for: indexPath) as! MyDayPlanTVC
            let model = nonEmtySession[indexPath.row]
            cell.contentHolderVIew.backgroundColor = model.isRetrived == true ?  .appGreyColor : .appWhiteColor
            if isTohightCell {
                if unsavedIndex ?? 0 == indexPath.row {
                    UIView.animate(withDuration: 1, delay: 0, animations: {
                        cell.contentHolderVIew.backgroundColor =  .red.withAlphaComponent(0.5)
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.animate(withDuration: 1, delay: 0, animations: {
                            cell.contentHolderVIew.backgroundColor = model.isRetrived == true ?  .appGreyColor : .appWhiteColor
                            self.isTohightCell = false
                        })
                    }
                }
                
            }
            
            
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            var cacheObjects : [NSManagedObject] = []
            
            guard let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context), let selectedHQentity = NSEntityDescription.entity(forEntityName: "Subordinate", in: context),
                  let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
            else {
                fatalError("Entity not found")
            }
            
            let temporaryHQObj = NSManagedObject(entity: selectedHQentity, insertInto: nil) as! Subordinate
            let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
            let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
            
            
            
            
            if let afetchedHQObject =  model.headQuarters  {
                
                let subordinateObj = CoreDataManager.shared.convertHeadQuartersToSubordinate(afetchedHQObject, context: context)
                
                cacheObjects.append(subordinateObj)
            } else {
                
                cacheObjects.append(temporaryHQObj)
            }
            
            if let afetchedClusterObject =  model.cluster , !afetchedClusterObject.isEmpty {
                cacheObjects.append(contentsOf: afetchedClusterObject)
            } else {
                cacheObjects.append(contentsOf: [temporaryselectedClusterobj])
                
                
            }
            
            if let afetchedWorkTypeObject =  model.workType  {
                cacheObjects.append(afetchedWorkTypeObject)
            } else {
                cacheObjects.append(temporaryselectedWTobj)
            }
            //  let model = self.sessions[indexPath.row]
            if model.isRetrived == true {
                cell.wtBorderView.backgroundColor = .appLightTextColor.withAlphaComponent(0.15)
                // cell.contentHolderVIew.backgroundColor = .appGreyColor
                cell.isUserInteractionEnabled = false
                cell.setupUI(model: cacheObjects, istoDelete: false)
            } else {
                cell.wtBorderView.backgroundColor = .appWhiteColor
                //cell.contentHolderVIew.backgroundColor = .appWhiteColor
                cell.isUserInteractionEnabled = true
                cell.setupUI(model: cacheObjects, istoDelete: indexPath.row == 0 && !(model.isFirstCell ?? false) ? true : false)
            }
            
            // cell.setupHeight(true)
            cell.selectionStyle = .none
            
            
            
            
            
            
            
            cell.wtBorderView.addTap { [weak self] in
                
                guard let welf = self else {return}
                welf.selectedSessionIndex = indexPath.row
                
                welf.navigateToSpecifiedMenu(type: .workType)
            }
            
            cell.hqBorderView.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedSessionIndex = indexPath.row
                if model.workType != nil {
                    welf.navigateToSpecifiedMenu(type: .headQuater)
                } else {
                    welf.toCreateToast("Please select worktype")
                }
                
            }
            
            cell.clusterBorderView.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedSessionIndex = indexPath.row
                
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    welf.navigateToSpecifiedMenu(type: .cluster)
                } else {
                    if model.headQuarters != nil {
                        welf.navigateToSpecifiedMenu(type: .cluster)
                    } else {
                        welf.toCreateToast("Please select HQ")
                    }
                }
                

                
                
            }
            
            cell.deleteTapStack.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedSessionIndex = indexPath.row
                welf.sessions?.remove(at: welf.selectedSessionIndex ?? 0)
                
                if welf.sessions?[0].workType?.fwFlg == "F" && !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    welf.fetchedHQObject1 =  welf.getSubordinate(hqCode:  welf.sessions?[0].headQuarters?.code ?? "")
                }
                welf.fetchedClusterObject1 = nil
                welf.selectedSessionIndex = nil
                welf.configureSaveplanBtn(false)
                welf.configureAddplanBtn(true)
                welf.toLoadWorktypeTable()
            }
            
            return cell
            
        default :
            return UITableViewCell()
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
            //            return cell
        }
    }
    
    func navigateToSpecifiedMenu(type: MenuView.CellType) {
        let vc = SpecifiedMenuVC.initWithStory(self, celltype: type)
      //  let model = sessions?[selectedSessionIndex ?? 0]
        switch type {
            
        case .workType:
            if let nonnillsession = self.sessions, nonnillsession.count > 1 {
                if let workType = sessions?[1].workType  {
                    vc.selectedObject = workType
                }
            }

            
         
            //self.fetchedWorkTypeObject
      
        case .cluster:
            
            switch self.selectedSessionIndex {
            case 0:
                vc.clusterMapID = self.fetchedHQObject1?.id ?? ""
                vc.selectedClusterID = self.fetchedClusterObject1?.reduce(into: [String: Bool]()) { result, aTerritory in
                    result[aTerritory.code ?? ""] = true
                }
            case 1:
                vc.clusterMapID = self.fetchedHQObject2?.id ?? ""
                vc.selectedClusterID = self.fetchedClusterObject2?.reduce(into: [String: Bool]()) { result, aTerritory in
                    result[aTerritory.code ?? ""] = true
                }
            default:
                print("Yet to implement")
            }
            
            
            
            
        case .headQuater:
            switch self.selectedSessionIndex {
            case 0:
                
                
                
                if let sessions = sessions, sessions.indices.contains(1) {
                    // Check if there is an element at index 1
                    if let code = sessions[1].headQuarters?.code {
                        vc.previousselectedObj = self.getSubordinate(hqCode: code)
                        vc.selectedObject = self.fetchedHQObject1
                    }
                } else {
                    // Handle the case where there is no element at index 1 or sessions is nil
                    print("Error: No element at index 1 or sessions is nil")
                    vc.selectedObject = self.fetchedHQObject1
                }
                
//                if let code =  sessions?[1].headQuarters?.code  {
//                    vc.previousselectedObj = self.getSubordinate(hqCode: code)
//                    vc.selectedObject = self.fetchedHQObject1
//                } else {
//                    vc.selectedObject = self.fetchedHQObject1
//                }
                
        
          
                
            case 1:
                if let code =  sessions?[1].headQuarters?.code  {
                    vc.previousselectedObj = self.getSubordinate(hqCode: code)
                    vc.selectedObject = self.fetchedHQObject1
                } else {
                    vc.selectedObject = self.fetchedHQObject2
                }
            default:
                print("---->>")
            }
            // vc.selectedObject = self.fetchedHQObject
            //self.fetchedHQObject
        default:
            print("Yet to implement")
            
        }
        
        self.modalPresentationStyle = .custom
        self.navigationController?.present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return UITableView.automaticDimension
        
        if tableView == self.outboxTableView {
            let callsCount = obj_sections[indexPath.section].items.count
            let eventsCount = obj_sections[indexPath.section].eventCaptures.count
            

            
            //self.outBoxDataArr?.count ?? 0
            switch indexPath.section {
            default:
                if  obj_sections[indexPath.section].isCallExpanded == true  {
                    return CGFloat(290 + 10 + (90 * callsCount))
                }
                if obj_sections[indexPath.section].isEventEcpanded == true {
                    return CGFloat(290 + 10 + (90 * eventsCount))
                }
                else {
                    return 290 + 10
                }
            }
            
            
        } else if tableView == self.callTableView {
            return 75
        } else if tableView == self.worktypeTable {
            //            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
            //                return 150 + 10
            //            } else {
            //                return 200 + 10
            //            }
            guard let nonEmptySession = self.sessions , nonEmptySession.count > 0 else  {
                return 0
            }
            
            let model = nonEmptySession[indexPath.row]
            if model.isRetrived ?? false  || model.isFirstCell ?? false {
                return  setupHeight(false, index: indexPath.row)
            } else {
                return  setupHeight(indexPath.row == 0 ? true : false, index: indexPath.row)
            }
            
            
        }
        else {
            return 95
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == outboxTableView {
            return 50
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        if tableView == outboxTableView {
            
            //            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            //            header.titleLabel.text = obj_sections[section].name
            //            header.section = section
            //            header.delegate = self
            
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "outboxCollapseTVC") as? outboxCollapseTVC
            header?.delegate = self
            header?.section = section
            if obj_sections[section].collapsed {
                header?.collapseIV.image = UIImage(named: "chevlon.expand")
            } else {
                header?.collapseIV.image = UIImage(named: "chevlon.collapse")
            }
            header?.refreshdelegate = self
            
     
            
            
            let object = obj_sections[section].items.first
            let dateString = object?.vstTime ?? ""
                let date = dateString.toDate()
                let formattedDate = date.toString(format: "MMMM dd, yyyy")
                print(formattedDate)  // Output: January 19, 2024
                header?.dateLbl.text = formattedDate
            header?.addTap {
                guard let header = header else {return}
                header.delegate?.toggleSection(header, section: header.section)
            }
            return header
            

            
        } else {
            
            return view
        }
    }
    
    func toretryDCRupload( date: String, completion: @escaping (Bool) -> Void) {
        var userAddress: String?
    
        Pipelines.shared.getAddressString(latitude: self.latitude ?? Double(), longitude: self.longitude ?? Double()) { [weak self] address in
            guard let welf = self else{return}
            userAddress = address
            
            
            CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
                guard let aoutboxCDM = outboxCDMs.first else {
                    completion(false)
                    return}
                
                let coreparamDatum = aoutboxCDM.unSyncedParams
                
                guard let paramData = coreparamDatum else {
                    completion(false)
                    return}
                
                
                var localParamArr = [String: [[String: Any]]]()
                do {
                    localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
                    dump(localParamArr)
                } catch {
                    //  self.toCreateToast("unable to retrive")
                    completion(false)
                }
                
                var specificDateParams : [[String: Any]] = [[:]]
                
                
                if date.isEmpty {
                    localParamArr.forEach { key, value in
                        
                        specificDateParams = value
                        
                        
                        for index in 0..<specificDateParams.count {
                            var paramData = specificDateParams[index]
                            
                            // Check if "Entry_location" key exists
                            if let _ = paramData["Entry_location"] as? String {
                                // Update the value of "Entry_location" key
                                paramData["Entry_location"] = "\(welf.latitude ?? Double()):\(welf.longitude ?? Double())"
                            }
                            
                            // Check if "address" key exists
                            if let _ = paramData["address"] as? String {
                                // Update the value of "address" key
                                paramData["address"] = userAddress ?? ""
                            }
                            
                            // Update the dictionary in specificDateParams array
                            specificDateParams[index] = paramData
                        }
                        
                        
                    }
                } else {
                    if localParamArr.isEmpty {
                        completion(true)
                    }
                    localParamArr.forEach { key, value in
                        if key == date {
                            dump(value)
                            specificDateParams = value

                            for index in 0..<specificDateParams.count {
                                var paramData = specificDateParams[index]
                                
                                // Check if "Entry_location" key exists
                                if paramData["Entry_location"] is String {
                                    // Update the value of "Entry_location" key
                                    paramData["Entry_location"] = "\(welf.latitude ?? Double()):\(welf.longitude ?? Double())"
                                }
                                
                                // Check if "address" key exists
                                if paramData["address"] is String {
                                    // Update the value of "address" key
                                    paramData["address"] = userAddress ?? ""
                                }
                                
                                // Update the dictionary in specificDateParams array
                                specificDateParams[index] = paramData
                            }
                            
                        }
                    }
                }
                
                print("specificDateParams has \(specificDateParams.count) values")
                if !localParamArr.isEmpty {
                  
                    welf.toSendParamsToAPISerially(index: 0, items: specificDateParams) { isCompleted in
                    
                        if isCompleted {
                          
                            completion(true)
                        }
                    }
                } else {
               
                    completion(true)
                }
                
            }
            

           // let paramData = LocalStorage.shared.getData(key: .outboxParams)

            
            }
        
        
        
        

        
    }
    
    
    
    func toSendParamsToAPISerially(index: Int, items: [JSON], completion: @escaping (Bool) -> Void) {
        Shared.instance.showLoaderInWindow()
        guard index < items.count else {
            // All items processed, exit the recursion
            Shared.instance.removeLoaderInWindow()
            completion(true)
            return
        }
        
        let params = items[index]
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        
        // Perform your asynchronous task or function
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        if params.isEmpty {
            Shared.instance.removeLoaderInWindow()
            completion(true)
            
            return
        }
        
       //  let diapatchGroup = DispatchGroup()
       // diapatchGroup.enter()
       
        self.sendAPIrequest(toSendData, paramData: params) { callstatus in

            let nextIndex = index + 1
            self.toSendParamsToAPISerially(index: nextIndex, items: items) {_ in}
   
            
        }
        // Handle the result if needed
        
        // Move to the next item
        
    }
    
    struct callstatus {
        var status: String?
        var isCallSubmitted: Bool?
    }
    
    func sendAPIrequest(_ param: [String: Any], paramData: JSON, completion: @escaping (callstatus) -> Void) {
      //  Shared.instance.showLoaderInWindow()
     
        userststisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
        
            switch result {
              
            case .success(let response):
                print(response)
            
                dump(response)
                if response.isSuccess ?? false {
                    let callStatus = callstatus(status: response.msg ?? "", isCallSubmitted: response.isSuccess ?? false)
                    self.toRemoveOutboxandDefaultParams(param: paramData) { isRemoved in
                        completion(callStatus)
                    }
                  
                } else {
                    let callStatus = callstatus(status: response.msg ?? "", isCallSubmitted: response.isSuccess ?? false)
                    self.toCreateToast(response.msg ?? "Error uploading data try again later.")
                    self.toUpdateData(param: paramData, status: response.msg ?? "Yet to")
                    self.toRemoveFailedHomeDictResponse(param: paramData)
                    completion(callStatus)
                }
                //  Shared.instance.removeLoaderInWindow()
            case .failure(let error):
                //   self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: jsonDatum)
                
                print(error.localizedDescription)
                self.view.toCreateToast("Error uploading data try again later.")
                let callStatus = callstatus(status:  "Waiting to sync", isCallSubmitted: false)
                completion(callStatus)
                //   Shared.instance.removeLoaderInWindow()
                
                return
            }
            
        }
    }

    func toUpdateData(param: JSON, status: String?) {
        let custCodeToUpdate = param["CustCode"] as! String
        
        
        let context = DBManager.shared.managedContext()
        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = UnsyncedHomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", custCodeToUpdate)

        do {
            let existingEntities = try context.fetch(fetchRequest)
            
            if let existingEntity = existingEntities.first {
                existingEntity.rejectionReason = status
                DBManager.shared.saveContext()
            }
        } catch {
            // Handle fetch error
        }
//    self.unsyncedhomeDataArr.forEach { aUnsyncedHomeData in
//        if aUnsyncedHomeData.custCode == custCodeToUpdate {
//            aUnsyncedHomeData.rejectionReason = "status"
//        }
//      }


        let updatedSections = obj_sections.map { section -> Section in
            var updatedSection = section
            
            // Filter items in the section
            updatedSection.items = section.items.filter { call in
                // Assuming custCode is not an optional type
                return call.custCode == custCodeToUpdate
            }
            
            updatedSection.items = section.items.map { call in
                let updatedCall = call
                
                // Update the submissionStatus property
                if call.custCode == custCodeToUpdate {
                    updatedCall.submissionStatus = status ?? "Waiting for sync."
                }
                
                return updatedCall
            }
            // Keep the section if it still has items after filtering
            return updatedSection
        }
        // Assign the updated array back to obj_sections
        obj_sections = updatedSections.filter({ section in
            !section.items.isEmpty
        })
        
        dump(obj_sections)
        
        DispatchQueue.main.async {
           // self.toSetParams()
            self.toLoadOutboxTable(isSynced: false)
        }
    }
    
    
    func toRemoveFailedHomeDictResponse(param: JSON) {
        
        //to remove object from Local array and core data
        
        let filteredValues =  self.outBoxDataArr?.filter({ outBoxCallModel in
            outBoxCallModel.custCode != param["CustCode"] as! String
        })
        
        
        
            self.outBoxDataArr = filteredValues
            self.refreshUI(issynced: true)
         
 
    }

    func updateSections(custCodeToRemove: String) {
        // Create a new array with modified sections
        let updatedSections = obj_sections.map { section -> Section in
            var updatedSection = section

            // Filter items in the section
            updatedSection.items = section.items.filter { call in
                // Assuming custCode is not an optional type
                return call.custCode != custCodeToRemove
            }

            // Keep the section if it still has items after filtering
            return updatedSection
        }

        // Assign the updated array back to obj_sections
        obj_sections = updatedSections.filter({ section in
            !section.items.isEmpty
        })

        print(obj_sections)
    }
    
    func toSaveaParamData(jsonDatum: Data, completion: @escaping () -> ()) {
        let managedObjectContext = DBManager.shared.managedContext() // Assuming DBManager.shared.managedContext() returns the managed object context
        
        // Fetch existing OutBoxParam entities and delete them
        let fetchRequest: NSFetchRequest<OutBoxParam> = OutBoxParam.fetchRequest()
        do {
            let existingParams = try managedObjectContext.fetch(fetchRequest)
            for param in existingParams {
                managedObjectContext.delete(param)
            }
        } catch {
            print("Failed to fetch existing OutBoxParam entities: \(error)")
            // Handle error
            completion()
            return
        }
        
        // Create a new OutBoxParam entity and assign the jsonDatum
        if let entityDescription = NSEntityDescription.entity(forEntityName: "OutBoxParam", in: managedObjectContext) {
            let outBoxParam = OutBoxParam(entity: entityDescription, insertInto: managedObjectContext)
            outBoxParam.unSyncedParams = jsonDatum
            
            // Save to Core Data
            do {
                try managedObjectContext.save()
                completion()
            } catch {
                print("Failed to save to Core Data: \(error)")
                // Handle error
            }
        } else {
            print("Entity description not found.")
            // Handle error
        }
    }
    
    
    func toRemoveOutboxandDefaultParams(param: JSON, completion: @escaping (Bool) -> ()) {

        //to remove object from Local array and core data
        
        let filteredValues =  self.outBoxDataArr?.filter({ outBoxCallModel in
            outBoxCallModel.custCode != param["CustCode"] as! String
        })
        
        self.outBoxDataArr = filteredValues
        
        
        unsyncedhomeDataArr.removeAll { aHomeData in
            return aHomeData.custCode == param["CustCode"] as? String
        }
        let identifier = param["CustCode"] as? String // Assuming "identifier" is a unique identifier in HomeData

        let context = DBManager.shared.managedContext()

        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = UnsyncedHomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", identifier ?? "")

        do {
            let results = try context.fetch(fetchRequest)
            if let existingObject = results.first {
                
                context.delete(existingObject)

                DBManager.shared.saveContext()
            } else {
                // Object not found, handle accordingly
            }
        } catch {
            // Handle fetch error
        }
        

       // let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.outboxParams)
        
        
        CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
            guard let aoutboxCDM = outboxCDMs.first else {
                completion(false)
                return
            }
            
            let coreparamDatum = aoutboxCDM.unSyncedParams
            
            guard let paramData = coreparamDatum else {
                completion(false)
                return}
            var localParamArr = [String: [[String: Any]]]()
            do {
                localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
                dump(localParamArr)
            } catch {
                self.toCreateToast("unable to retrive")
            }
            
            
            let custCodeToRemove = param["CustCode"] as! String
            
            // Iterate through the dictionary and filter out elements with the specified CustCode
            localParamArr = localParamArr.mapValues { callsArray in
                return callsArray.filter { call in
                    if let custCode = call["CustCode"] as? String {
                        if custCode == custCodeToRemove {
                            print("Removing element with CustCode: \(custCode)")
                            return false
                        }
                    }
                    return true
                }
            }
            // Remove entries where the filtered array is empty
            localParamArr = localParamArr.filter { _, callsArray in
                return !callsArray.isEmpty
            }
            
            let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
            

            toSaveaParamData(jsonDatum: jsonDatum) { 
                
                
                // Create a new array with modified sections
                let updatedSections = obj_sections.map { section -> Section in
                    var updatedSection = section
                    
                    // Filter items in the section
                    updatedSection.items = section.items.filter { call in
                        // Assuming custCode is not an optional type
                        return call.custCode != custCodeToRemove
                    }
                    
                    // Keep the section if it still has items after filtering
                    return updatedSection
                }
                // Assign the updated array back to obj_sections
                obj_sections = updatedSections.filter({ section in
                    !section.items.isEmpty
                })
                
                print(obj_sections)
                
                self.dcrcallsAdded()
                
                completion(true)
                
            }

        }
        

        
        

        
        
    }
    
    
    
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        
        let collapsed = !obj_sections[section].collapsed
        obj_sections[section].collapsed = collapsed
        
        // Reload the whole section
        self.outboxTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    
    

}

extension MainVC : FSCalendarDelegate, FSCalendarDataSource ,FSCalendarDelegateAppearance {
    
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
    
    func returnWeeklyoffDates() {
        let weeklyoffSetupArr : [Weeklyoff]? = DBManager.shared.getWeeklyOff()

        guard let  weeklyoffSetupArr = weeklyoffSetupArr, !weeklyoffSetupArr.isEmpty else {return}
        let weeklyOff = weeklyoffSetupArr[0]
        let weekoffIndex = Int(weeklyOff.holiday_Mode ?? "0") ?? 0
        let weekoffDates = self.getWeekoffDates(forMonths: [-1, 0, 1], weekoffday: weekoffIndex + 1)
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
    
    
    func toAppendDCRtoHomeData(date: String, flag: String, tbName:String, editFlag: String) {
        
        let isDayExists: Bool = self.homeDataArr.map { $0.dcr_dt }.contains(date)
        
        if isDayExists {
            print("<------Day exists----->")
            self.homeDataArr.removeAll { $0.dcr_dt == date }
        }
            if let entityDescription = NSEntityDescription.entity(forEntityName: "HomeData", in: context) {
                let entityHomedata = HomeData(entity: entityDescription, insertInto: context)
                
                
                entityHomedata.anslNo = ""
                entityHomedata.custCode =  String()
                entityHomedata.custName = String()
                entityHomedata.custType = String()
                entityHomedata.dcr_dt = date
                entityHomedata.dcr_flag = String()
                entityHomedata.editflag = editFlag
                entityHomedata.fw_Indicator = (flag == "1"  &&  tbName == "missed") ?  "M" : (flag == "2"  &&  tbName == "leave") ? "LAP" : ""
                
                
             
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
                
              
                
                self.homeDataArr.append(entityHomedata)
            }
     
      

            
            
        
  
    
    }
    
    func togetDCRdates(completion: @escaping () -> ()) {
        CoreDataManager.shared.fetchDcrDates { savedDcrDates in
            for dcrDate in savedDcrDates {
                CoreDataManager.shared.context.refresh(dcrDate, mergeChanges: true)
                // Now, the data is loaded for all properties
                self.responseDcrDates.append(dcrDate)
                self.toAppendDCRtoHomeData(date: dcrDate.date ?? "", flag: dcrDate.flag ?? "", tbName: dcrDate.tbname ?? "", editFlag: dcrDate.editFlag ?? "")
                print("Sf_Code: \(dcrDate.sfcode ?? ""), Date: \(dcrDate.date ?? ""), Flag: \(dcrDate.flag ?? ""), Tbname: \(dcrDate.tbname ?? "")")
            }
            
        
            completion()
        }
        
       // dump( self.responseDcrDates)
        
        
        
        
        

        
    }
    
    
    
    
    func toExtractWorkDetails(date: Date) -> HomeData? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let dateString = dateFormatter.string(from: date)
        
        print(dateString)
        
        
        let filteredDetails =   homeDataArr.filter { $0.dcr_dt ?? "" == dateString}
        
        if !filteredDetails.isEmpty {
            return filteredDetails.first
        } else {
            return nil
        }
        
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print(calendar.currentPage)
        dateInfoLbl.text = toTrimDate(date: calendar.currentPage , isForMainLabel: true)
        self.selectedDate = ""
        //"\(values.month!) \(values.year!)"
        //
    }
    
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
        let model: HomeData? = toExtractWorkDetails(date: date)
        
        
        if model?.fw_Indicator ==  "F" {
            cell.addedIV.backgroundColor = .appGreen
            
        } else if  model?.fw_Indicator ==  "W" {
            cell.addedIV.backgroundColor = .appYellow
            dump(model)
        } else if  model?.fw_Indicator ==  "N" {
            cell.addedIV.backgroundColor = .appBlue
            dump(model)
        } else if  model?.fw_Indicator ==  "LAP" {
            cell.addedIV.backgroundColor = .appDeepBlue
            dump(model)
        } else if  model?.fw_Indicator ==  "L" {
            cell.addedIV.backgroundColor = .appLightPink
            dump(model)
        }   else if  model?.fw_Indicator ==  "H" {
            cell.addedIV.backgroundColor = .appViolet
            dump(model)
        }  else if  model?.fw_Indicator ==  "M" {
            cell.addedIV.backgroundColor = .appLightGrey
            dump(model)
        }
        
        
        
        
        
        
        
        
        cell.customLabel.text = toTrimDate(date: date)
        cell.customLabel.textColor = .appTextColor
        cell.customLabel.setFont(font: .medium(size: .BODY))
        cell.customLabel.textColor = .appTextColor
        // cell.customLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.titleLabel.isHidden = true
        cell.shapeLayer.isHidden = true
        
        cell.layer.borderColor = UIColor.appSelectionColor.cgColor
        cell.layer.borderWidth = 0.5
        
        
        
        if selectedDate ==  toTrimDate(date: date, isForMainLabel: false)  {
            cell.contentHolderView.backgroundColor = .appTextColor
            cell.customLabel.textColor = .appWhiteColor
        } else {
            cell.contentHolderView.backgroundColor = .clear
            cell.customLabel.textColor = .appLightTextColor
        }
        
        
        cell.addTap { [weak self] in
            //Shared.instance.showLoaderInWindow()
            guard let welf = self else {return}
            let selectedDate = date.toString(format: "yyyy-MM-dd")
            /// note:- future date selection action
            if welf.isFurureDate(date: date) {
                
              
                
                welf.showAlertToFilldates(description: "Day planing for future dates are restricted.")
                //welf.toCreateToast("Day planing for future dates are restricted.")
          
                return
            }
            
            /// note:- DCR sequential action
            ///
           let isForsequential = false
            if isForsequential {
                welf.getNonExistingDatesInCurrentMonth(selectedDate: date) { tobefilledDate in
                    Shared.instance.removeLoaderInWindow()
                    guard let tobefilledDate = tobefilledDate else {return}
                     //Shared.instance.showLoaderInWindow()
                     if tobefilledDate.toDate(format: "yyyy-MM-dd") < selectedDate.toDate(format: "yyyy-MM-dd")  {
                         //Shared.instance.removeLoaderInWindow()
                         welf.showAlertToFilldates(description: tobefilledDate)
                         return
                     }
                 }
            }

            
            /// note:- DCR edit flag
            if model?.editflag == "0" {
                print("-----> YET TO CALL API <------")
                welf.callDayPLanAPI(date: selectedDate.toDate(format: "yyyy-MM-dd"), isFromDCRDates: true)
                
                
            }
            
            
            /// note:- Today date selection action
            let today = Date()
            if today.toString(format: "yyyy-MM-dd")  ==  date.toString(format: "yyyy-MM-dd") {
                welf.callDayPLanAPI(date: today, isFromDCRDates: false)
            }
            
            
            if model == nil {
                welf.selectedDate = welf.toTrimDate(date: date, isForMainLabel: false)
                welf.selectedRawDate = date
                welf.sessions?.removeAll()
                welf.fetchedWorkTypeObject1 = nil
                welf.isPlanningNewDCR = true
                welf.fetchedClusterObject1 = nil
                welf.fetchedHQObject1 = nil
                welf.fetchedHQObject2 = nil
                welf.fetchedClusterObject2 = nil
                welf.fetchedWorkTypeObject2 = nil
                welf.toAddnewSession()
                welf.configureSaveplanBtn(welf.toEnableSaveBtn(sessionindex: 0,  istoHandeleAddedSession: false))
                welf.setSegment(.workPlan)
                welf.tourPlanCalander.reloadData()
                welf.toSetParams(date: date, isfromSyncCall: false) {}
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                welf.lblDate.text = dateFormatter.string(from: date)
            } else {
            
            }
           
        }
        
        return cell
    }
    
    
    func showAlertToFilldates(description: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "\(description)", okAction: "Close")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
    }
    

    
    
    func callDayPLanAPI(date: Date, isFromDCRDates: Bool) {
       // Shared.instance.showLoaderInWindow()
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            masterVM?.toGetMyDayPlan(type: .myDayPlan, isToloadDB: true, date: date, isFromDCR: isFromDCRDates) {[weak self] _ in
                Shared.instance.removeLoaderInWindow()
                guard let welf = self else {return}
                welf.toConfigureMydayPlan()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                welf.lblDate.text = dateFormatter.string(from: date)
                welf.selectedRawDate = date
                welf.selectedDate = welf.toTrimDate(date: date, isForMainLabel: false)
                welf.tourPlanCalander.reloadData()
            }
        } else {
            
            toConfigureMydayPlan()
            
        }
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
    
    
//    func toFindSequentialNonfilledDates(selectedDate: Date) -> Date? {
//   
//        
//        let calendar = Calendar.current
//        
//       let currentMonth = calendar.component(.month, from: Date())
//
//        
//        let filteredDates = homeDataArr.filter { dateObject in
//            guard let date = dateObject.dcr_dt?.toDate(format: "yyyy-MM-dd") else { return false }
//            
//            let isDateInCurrentMonth = Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month)
//            
//            if currentMonth == getCurrentMonth(from: selectedDate) {
//                // If selectedDate is in the current month, filter dates in the current month only
//                return isDateInCurrentMonth && !homeDataArr.contains { $0.dcr_dt?.toDate(format: "yyyy-MM-dd") == date }
//            } else {
//                // If selectedDate is not in the current month, consider dates from both current and previous months
//                
//                return  !homeDataArr.contains { $0.dcr_dt?.toDate(format: "yyyy-MM-dd") == date }
//            }
//        }
//        
//
//            if let leastDate = filteredDates.min(by: { $0.dcr_dt?.toDate(format: "yyyy-MM-dd") ?? Date() < $1.dcr_dt?.toDate(format: "yyyy-MM-dd") ?? Date() }) {
//                print("Least date: \(leastDate.dcr_dt ?? "")")
//                return leastDate.dcr_dt?.toDate(format: "yyyy-MM-dd")
//            }
//        
//        return nil
//        
//    }
    
}

extension MainVC : UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presenter = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        presenter.presentedViewFrame = presented.view.frame
        return presenter
    }
}


extension MainVC : outboxCollapseTVCDelegate {
    func didTapRefresh(_ refreshIndex: Int) {
        
        let isConnected = LocalStorage.shared.getBool(key: .isConnectedToNetwork)
        //  obj_sections[section].isLoading = true
        if isConnected {
           
            self.toretryDCRupload(date: obj_sections[refreshIndex].date) { _ in
                self.toCreateToast("Sync completed")
                Shared.instance.showLoaderInWindow()
                self.toUploadUnsyncedImage() {
                    self.toLoadOutboxTable()
                    Shared.instance.removeLoaderInWindow()
                }
                
            }
        } else {
            self.toCreateToast("Please connect to internet and try again later.")
        }

    }
    
    
    func toUploadUnsyncedImage(completion: @escaping () -> ()) {
      
        CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventsArr in
            
            
            // Create a dispatch group to wait for all uploads to complete
            let dispatchGroup = DispatchGroup()
            
            unsyncedEventsArr.forEach { unsyncedEvent in
                var eventCaptureVMs = [EventCaptureViewModel]()
                let yattoPostData = unsyncedEvent.eventCaptureParamData
                let eventCaptures = unsyncedEvent.capturedEvents
                let optionalParam = ObjectFormatter.shared.convertDataToJson(data: yattoPostData ?? Data())
                
                eventCaptures?.forEach { aEventCapture in
                    let aEventCaptureViewModel = EventCaptureViewModel(eventCapture: aEventCapture)
                    eventCaptureVMs.append(aEventCaptureViewModel)
                }
                
                // Process each eventCaptureViewModel synchronously
                eventCaptureVMs.forEach { aEventCaptureViewModel in
                    dispatchGroup.enter()
                    var custCode: String = ""
                    if  let patamcustcode = optionalParam?["custCode"] {
                        custCode = patamcustcode as! String
                    }
                  
                    self.callSaveimageAPI(param: optionalParam ?? JSON(), paramData: yattoPostData ?? Data(), evencaptures: aEventCaptureViewModel, custCode: custCode) { result in
                            dispatchGroup.leave()
                        }

                }
            }
            
            // Notify the completion handler when all uploads are done
            dispatchGroup.notify(queue: .main) {
                
                completion()
            }
        }
    }
    
}

private enum Constants {
    static let spacing: CGFloat = 1
}


extension MainVC: PopOverVCDelegate {
    
    
    func checkinDetailsAction(checkin: CheckinInfo? = nil) {
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                
            case checkinDetailsView:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
              
            default:
                print("Yet to implement")
          
                
                aAddedView.isUserInteractionEnabled = false
              
                
            }
            
        }
        
        checkinDetailsView = self.loadCustomView(nibname: XIBs.homeCheckinDetailsView) as? HomeCheckinDetailsView
        checkinDetailsView?.delegate = self
        checkinDetailsView?.chckinInfo = checkin
        checkinDetailsView?.userstrtisticsVM = self.userststisticsVM
        checkinDetailsView?.appsetup = self.appSetups
        if btnFinalSubmit.titleLabel?.text == "Final submit" {
            checkinDetailsView?.setupUI(type: HomeCheckinDetailsView.ViewType.checkin)
        } else {
            checkinDetailsView?.setupUI(type: HomeCheckinDetailsView.ViewType.checkout)
        }
        view.addSubview(checkinDetailsView ?? HomeCheckinDetailsView())
    }
    
    
    func checkinAction() {
        
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                
                
            case checkinDetailsView:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                
                
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
            default:
                
                print("Yet to implement")
              
                aAddedView.isUserInteractionEnabled = false
              
                
            }
            
        }
        
        checkinVIew = self.loadCustomView(nibname: XIBs.homeCheckinView) as? HomeCheckinView
        checkinVIew?.delegate = self
        checkinVIew?.userstrtisticsVM = self.userststisticsVM
        checkinVIew?.appsetup = self.appSetups
        checkinVIew?.setupUI()
        
        view.addSubview(checkinVIew ?? HomeCheckinView())
        
    }
    
    
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int) {
        print("Yet to implement")
        if index == 1 {
            
         
            toSetupDeleteAlert(index: SelectedArrIndex)

        } else {
            let aCall = self.todayCallsModel?[SelectedArrIndex] ?? TodayCallsModel()
           // didTapoutboxEdit(dcrCall: aCall)
            toCallEditAPI(dcrCall: aCall)
        }
    }
    
    func logoutAction() {
        
        self.toCreateToast("logged out successfully")
        
        Pipelines.shared.doLogout()
        
    }
    
    func toSetupDeleteAlert(index: Int) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "Are you sure calls ", okAction: "Yes" , cancelAction: "No")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            
            self.toDeleteAddedDCRCall(index: index)
        }
        
        commonAlert.addAdditionalCancelAction {
            print("Yes action")
         
        
        }
    }
    
    func removeAllAddedCall(id: String) {
        let fetchRequest: NSFetchRequest<AddedDCRCall> = AddedDCRCall.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "addedCallID == %@", id)

        do {
            let existingCalls = try context.fetch(fetchRequest)
            for call in existingCalls {
                context.delete(call)
            }

            try context.save()
        } catch {
            print("Error deleting existing calls: \(error)")
        }
    }
    
    func toDeleteAddedDCRCall(index: Int) {
        let model: TodayCallsModel = self.todayCallsModel?[index] ?? TodayCallsModel()
        //  {"sfcode":"MGR0941","division_code":"63,","Rsf":"MR5990","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,","amc":"DP3-1344","CusType":"1","sample_validation":"0","input_validation":"0"}
        Shared.instance.showLoaderInWindow()
        var param = [String: Any]()
        param["sfcode"] = appSetups.sfCode
        param["division_code"] = appSetups.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appSetups.sfType
        param["Designation"] = appSetups.desig
        param["state_code"] = appSetups.stateCode
        param["subdivision_code"] = appSetups.subDivisionCode
        param["amc"] = model.aDetSLNo
        param["CusType"] = model.custType
        param["sample_validation"] = "0"
        param["input_validation"] = "0"
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        print(param)
        
        self.userststisticsVM?.deleteAddedcalls(params: toSendData, api: .deleteCall, paramData: param) {result in
           
            switch result {
                
            case .success(let response):
                dump(response)
                self.toCreateToast("Calls deleted Successfully")
               // self.removeAllAddedCall(id: model.custCode)
                self.toSetParams(isfromSyncCall: true) {
                    self.refreshDashboard {
                        Shared.instance.removeLoaderInWindow()
                    }
                }
            case .failure(let error):
                self.toCreateToast(error.localizedDescription)
                Shared.instance.removeLoaderInWindow()
            }
            
        }
    }
    
    
    func deviateAction(isForremarks: Bool) {
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
            default:
                
                print("Yet to implement")
                aAddedView.isUserInteractionEnabled = false
                
                
            }
            
        }
        
        tpDeviateReasonView = self.loadCustomView(nibname: XIBs.tpDeviateReasonView) as? TPdeviateReasonView
        tpDeviateReasonView?.delegate = self
        
        tpDeviateReasonView?.addedSubviewDelegate = self
        tpDeviateReasonView?.isForRemarks = isForremarks
       // changePasswordView?.userStatisticsVM = self.userststisticsVM
       // changePasswordView?.appsetup = self.appSetups
        tpDeviateReasonView?.setupui()
        view.addSubview(tpDeviateReasonView ?? TPdeviateReasonView())
    }
    
    func changePasswordAction() {
        backgroundView.isHidden = false
        backGroundVXview.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case changePasswordView:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
            default:
                
                print("Yet to implement")
                aAddedView.isUserInteractionEnabled = false
                
                
            }
            
        }
        
        changePasswordView = self.loadCustomView(nibname: XIBs.changePasswordView) as? ChangePasswordView
        changePasswordView?.delegate = self
        changePasswordView?.userStatisticsVM = self.userststisticsVM
        changePasswordView?.appsetup = self.appSetups
        changePasswordView?.setupUI()
        view.addSubview(changePasswordView ?? ChangePasswordView())
    }
    
    
}


extension MainVC : SessionInfoTVCDelegate {
    func remarksAdded(remarksStr: String, index: Int) {
        
        dump(remarksStr)
        self.isDayPlanRemarksadded = true
        guard var yetToSaveSession = self.sessions else {return}
        
        yetToSaveSession.indices.forEach { index in
            yetToSaveSession[index].remarks = remarksStr
        }
        
        
        backgroundView.isHidden = true
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
             //   self.setDeviateSwitch(istoON: true)
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
            }

        }
        
        self.sessions = yetToSaveSession
        
  
        
        didTapFinalSubmit(self)

    }
    
    
}

extension MainVC : addedSubViewsDelegate {
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("yes action")
    }
    
    
    func showAlertToNetworks(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Cancel",cancelAction: "Ok")
       // "Please connect to active network to update Password"
     //   "Please enable location services in Settings."
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
            self.redirectToSettings()
            
        }
    }
    
    
    func redirectToSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func showAlert(desc: String) {
        // "Please connect to active network to update Password"
      //   "Please enable location services in Settings."
      showAlertToNetworks(desc: desc)
    }
    
    func didClose() {
        backgroundView.isHidden = true
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {
            case changePasswordView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                
            case checkinDetailsView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                self.btnFinalSubmit.setTitle("Final submit / Check OUT", for: .normal)
                
                if checkinDetailsView?.viewType == .checkout {
                    self.didTapSaveBtn(self)
                    if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.userCheckedOut) {
                        self.btnFinalSubmit.isUserInteractionEnabled = false
                        self.btnFinalSubmit.alpha = 0.5
                    }
                }
            
                
     
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                self.setDeviateSwitch(istoON: false)
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    

    
    func didUpdate() {
        backgroundView.isHidden = true
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {
            case changePasswordView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                self.toSetupUpdatePasswordAlert(desc: "Password updated sucessfully, Do you want to log out?")
                
               
                
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                checkinDetailsAction()
                
                
            case checkinDetailsView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            case tpDeviateReasonView:
                
                
                
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                self.setDeviateSwitch(istoON: true)
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    
}
extension Calendar {
    func generateDates(inside range: ClosedRange<Date>, matching unit: Calendar.Component, matchingPolicy: Calendar.MatchingPolicy) -> [Date] {
        var dates = [Date]()
        var currentDate = range.lowerBound
        while currentDate <= range.upperBound {
            if isDate(currentDate, equalTo: range.upperBound, toGranularity: .day) {
                // Include the upper bound date
                dates.append(currentDate)
                break
            } else {
                dates.append(currentDate)
                currentDate = date(byAdding: unit, value: 1, to: currentDate)!
            }
        }
        return dates
    }
}


extension MainVC :  HomeSideMenuViewDelegate {
    func refreshDashBoard() {
        print("Yet to refresh dashboard")
    }
    
    
}


extension MainVC: OutboxDetailsTVCDelegate {
    func didTapOutboxDelete(dcrCall: TodayCallsModel) {
      
        var param: [String: Any] = [:]
        param["CustCode"] = dcrCall.custCode
        self.toRemoveOutboxandDefaultParams(param: param) { isRemoved in
            CoreDataManager.shared.removeUnsyncedEventCaptures(withCustCode: dcrCall.custCode) {_  in
                
                self.toLoadOutboxTable()
            }
        }
        
    }
    
    func didTapEventcaptureDelete(event: UnsyncedEventCaptureModel) {
        guard let custCode = event.custCode else {return}

        CoreDataManager.shared.removeUnsyncedEventCaptures(withCustCode: custCode) {_  in
            
            self.toLoadOutboxTable()
        }

    }
    
    func didTapoutboxEdit(dcrCall: TodayCallsModel) {
        print("Tapped")
        dump(dcrCall)
        let listedDocters = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
       let filteredDoctores = listedDocters.filter { aDoctorFencing in
            aDoctorFencing.code == dcrCall.custCode
        }
        guard let nonNilDoctors = filteredDoctores.first else {
            
            
            return}
        let aCallVM = CallViewModel(call: nonNilDoctors , type: DCRType.doctor)
        editDCRcall(call: aCallVM, type: DCRType.doctor)
    }
    
    
}
