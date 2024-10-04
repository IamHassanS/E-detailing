//
//  MainVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/07/24.
//

import UIKit
import Foundation
import FSCalendar
import Alamofire
import CoreData

typealias collectionViewProtocols = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
typealias tableViewProtocols = UITableViewDelegate & UITableViewDataSource

class MainVC : UIViewController {

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
    @IBOutlet weak var segmentControlForAnalysis: UISegmentedControl!
    @IBOutlet weak var salesStackView: UIStackView!
    @IBOutlet weak var callStackView: UIStackView!
    @IBOutlet weak var slideStackView: UIStackView!
    
    @IBOutlet var btnSyncDate: ShadowButton!
    // views
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewAnalysis: UIView!
    @IBOutlet weak var viewQuickLinks: UIView!
    @IBOutlet weak var viewWorkPlan: UIView!
    @IBOutlet weak var viewCalls: UIView!
    @IBOutlet weak var viewOutBox: UIView!
    @IBOutlet weak var viewDayPlanStatus: UIView!
    @IBOutlet weak var tourPlanCalander: FSCalendar!
  //  @IBOutlet weak var viewPcpmChart: UICircularProgressRing!
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
    
    ///my day plan
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
    @IBOutlet var deviateView: UIView!
    @IBOutlet var deviateViewHeight: NSLayoutConstraint!
    @IBOutlet var viewNoCalls: UIView!
    
    @IBOutlet var viewNoOutboxCalls: UIView!
    let dcrCallObjectParser =  DCRCallObjectParser.instance
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var  latitude : Double?
    var longitude: Double?
    var callsCellHeight = 400 + 10 // + 10 padding
    var homeLineChartView : HomeLineChartView?
    var changePasswordView: ChangePasswordView?
    var checkinVIew: HomeCheckinView?
    var checkinDetailsView:  HomeCheckinDetailsView?
    var tpDeviateReasonView:  TPdeviateReasonView?
    let appSetups = AppDefaults.shared.getAppSetUp()
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
    var selectedDate: String?
    var selectedRawDate : Date?
    var selectedSegment : SegmentType = .workPlan
    var segmentType: [SegmentType] = []
    var selectedSegmentsIndex: Int = 0
    var selectedSessionIndex : Int?
    var unsavedIndex : Int?
    var isTohightCell: Bool = false
    let celenderToday = Date()
    var selectedToday : Date?
    var planSubmitted: Bool = false
    var isToRegretCheckin: Bool = false
    var currentPage =  Date()
    var tableCellheight: CGFloat = 0
    var isDayPlanRemarksadded: Bool = false
    var dayRemarks: String = ""
    var links = [QuicKLink]()
    
    var dcrCount = [DcrCount]()
    var masterVM : MasterSyncVM?
    var isFieldWorkExists: Bool = false
    let eventArr = ["Weekly off", "Field Work", "Holiday", "Leave", "Missed Released", "Rejected", "Re Entry", "TP Devition Released", "Non-Field Work", "TP Devition", "Leave Approval Pending"]
    let colorArr : [UIColor] =  [.appYellow, .appGreen, .appViolet, .appLightPink, .appLightGrey, .appDeepBrown, .appPink, .appDeepGreen, .appBlue, .appBrown, .appDeepBlue]
    
    let menuList = ["Refresh","Tour Plan","Create Presentation","Leave Application","Reports","Activiy","Near Me","Quiz","Survey","Forms","Profiling"]
    
    var todayCallsModel: [TodayCallsModel]?
    var isNextMonth = false
    var isPrevMonth = false
    var isCurrentMonth = false
    var istwoMonthsAgo = false
    
    enum ChartType {
        case doctor
        case chemist
        case stockist
        case unlistedDoctor
    }
    
    enum SegmentType : String {
        case workPlan = "Work plan"
        case calls = "Calls"
        case outbox = "Outbox"
        case calender = "Date"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLinks()
        setupUI()
        addObservers()
        makeBackgroundTask()
        if isTPmandatoryNeeded && findDateExistsinTPrange() {
            self.navigationController?.pushViewController(TourPlanVC.initWithStory(), animated: true)
            return
        }
    }
    
    func loadHome() {
        fetchLocations() { _ in }
        
        
        if  isFromLaunch {
           // welf.getDCRdates()
          btnCalenderSync(btnSyncDate!)
          return
        }
        
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
           toPostAlldayPlan() { [weak self]  in
               guard let welf = self else {return}
               welf.handleDateSync()
            }
            return
        }
        
        handleDateSync()
        
    }
    
    func makeBackgroundTask() {
        let homeQueue = DispatchQueue(label: "com.home.dispatchQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
        homeQueue.async(group: nil, qos: .userInteractive, flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                self?.loadHome()
            }
        }
    }
    
    func handleDateSync() {
        isUserPlanning{ [weak self] isUserPlanning in
            guard let welf = self else {return}
            isUserPlanning ?   welf.planningAction() : welf.btnCalenderSync(welf.btnSyncDate!)
            //welf.getDCRdates()
            //welf.btnCalenderSync(welf.btnSyncDate!)
        }
    }
    
    func getDCRdates() {
        togetDCRdates(isToUpdateDate: false) { [weak self] in
         //   if !isSequentialDCRenabled {
            self?.configurePastWindups(pageType: .calender) {}
          //  }
        }
    }
    
    /// sync outbox datas
    ///
    ///uses `OperationQueue` to perform async API calls
    ///
    /// - Parameter completion: empty completion once sync completes Date sync API is called
    
    func toPostAlldayPlan(completion: @escaping () -> ()) {

        let customQueue = DispatchQueue(label: "com.queue.concurrent", qos: .background)
  
        toSetupOutBoxDataSource(isSynced: false) { [weak self] in
            guard let welf = self else { return }
            
            
            guard !obj_sections.isEmpty else {
                completion()
                return
            }
            
            print("Outbox sync started")
            customQueue.async {
                let dcrSyncGroup = DispatchGroup()
                let maxConcurrentloads = 1
                let semaphore = DispatchSemaphore(value: maxConcurrentloads)
                let operationQueue = OperationQueue()
                operationQueue.maxConcurrentOperationCount = 1
            obj_sections.forEach { section in
                // Enter the group for each section
                
                
                dcrSyncGroup.enter()
                semaphore.wait()
                let refreshDateStr = section.date
                let callitems = section.items
                let refreshDate = section.date.toDate(format: "yyyy-MM-dd")
                
                print("Outbox sync for date \(refreshDate) started")
                
                
                
                let myDaplanOperation = BlockOperation {
                    DispatchQueue.main.async {
                        print("Posting day plan for \(refreshDate)")
                        welf.toPostDayplan(byDate: refreshDate, istoupdateUI: welf.selectedDate != nil) {
                            print("completed day plan for \(refreshDate) ✅")
                        }
                    }
                }
                
                let postCallsOperation = BlockOperation {
                    DispatchQueue.main.async {
                        print("Posting calls for \(refreshDate)")
                        welf.toretryDCRupload(dcrCall: callitems, date: refreshDateStr) { _ in
                            print("completed calls upload for \(refreshDate) ✅")
                        }
                    }
                }
                
                let postImagesOperation = BlockOperation {
                    DispatchQueue.main.async {
                        print("Posting Event captures for \(refreshDate)")
                        welf.toUploadUnsyncedImageByDate(date: refreshDateStr) {
                            print("completed Event captures upload for \(refreshDate) ✅")
                        }
                    }
                }
                
                let uploadWindupsOperation = BlockOperation {
                    print("Posting windups for \(refreshDate)")
                    welf.toUploadWindups(date: refreshDate) { _ in
                        print("completed windups upload for \(refreshDate) ✅ ---> Now Iterating to next day")
                        semaphore.signal()
                        dcrSyncGroup.leave()// Leave the group after this operation completes
                    }
                }
                
                // Set up operation dependencies
                postCallsOperation.addDependency(myDaplanOperation)
                postImagesOperation.addDependency(postCallsOperation)
                uploadWindupsOperation.addDependency(postImagesOperation)
                
                operationQueue.addOperation(myDaplanOperation) // First operation
                operationQueue.addOperation(postCallsOperation)   // Second operation
                operationQueue.addOperation(postImagesOperation)  // Third operation
                operationQueue.addOperation(uploadWindupsOperation)  // Fourth operation
                
              //  operationQueue.addOperations([myDaplanOperation, postCallsOperation, postImagesOperation, uploadWindupsOperation], waitUntilFinished: true)
              
            }
            operationQueue.waitUntilAllOperationsAreFinished()
            // Notify completion once all operations across all sections are done
            dcrSyncGroup.notify(queue: .main) {
                welf.masterVM?.fetchMasterData(
                    type: .homeSetup,
                    sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID),
                    istoUpdateDCRlist: false,
                    mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
                ) { _ in
                    Shared.instance.removeLoaderInWindow()
                    print("Outbox sync completed")
                    welf.showAlertToFilldates(description: "Outbox Sync completed")
                    completion()  // Now the completion is called once everything finishes
                }
            }
        }
        }
    }
    
    
    /// sync outbox datas
    ///
    ///uses `OperationQueue` to perform async API calls
    ///
    /// - Parameter completion: empty completion once sync completes Date sync API is called
//    func toPostAlldayPlan(completion: @escaping () -> ()) {
//        
//        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
//            completion()
//            return
//        }
//      
//        toSetupOutBoxDataSource(isSynced: false) { [weak self] in
//            guard let welf = self else { return }
//            
//            guard !obj_sections.isEmpty else {
//                completion()
//                return
//            }
//            
//            let operationQueue = OperationQueue()
//
//            // Completion Operation
//            let completionOperation = BlockOperation {
//                DispatchQueue.main.async {
//                    Shared.instance.removeLoaderInWindow()
//                  //  welf.showAlertToFilldates(description: "Sync completed")
//                    completion()
//                }
//            }
//
//            obj_sections.forEach { section in
//                let refreshDateStr = section.date
//                let callitems = section.items
//                let refreshDate = section.date.toDate(format: "yyyy-MM-dd")
//                
//                // Post Day Plan Operation
//                let postDayPlanOperation = BlockOperation {
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    welf.toPostDayplan(byDate: refreshDate, istoupdateUI: welf.selectedDate != nil) {
//                        dispatchGroup.leave()
//                    }
//                    dispatchGroup.wait()
//                }
//                
//                // Retry DCR Upload Operation
//                let retryDCROperation = BlockOperation {
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    welf.toretryDCRupload(dcrCall: callitems, date: refreshDateStr) { _ in
//                        dispatchGroup.leave()
//                    }
//                    dispatchGroup.wait()
//                }
//                retryDCROperation.addDependency(postDayPlanOperation)
//                
//                // Upload Unsynced Images Operation
//                let uploadImageOperation = BlockOperation {
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    welf.toUploadUnsyncedImageByDate(date: refreshDateStr) {
//                        dispatchGroup.leave()
//                    }
//                    dispatchGroup.wait()
//                }
//                uploadImageOperation.addDependency(retryDCROperation)
//                
//                // Upload Windups Operation
//                let uploadWindupsOperation = BlockOperation {
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    welf.toUploadWindups(date: refreshDate) { _ in
//                        welf.toLoadOutboxTable()
//                        welf.setSegment(.calls)
//                        dispatchGroup.leave()
//                    }
//                    dispatchGroup.wait()
//                }
//                uploadWindupsOperation.addDependency(uploadImageOperation)
//                
//                // Home Data Sync Operation
//                let homeDataSyncOperation = BlockOperation {
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    welf.masterVM?.fetchMasterData(
//                        type: .homeSetup,
//                        sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID),
//                        istoUpdateDCRlist: false,
//                        mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
//                    ) { _ in
//                        dispatchGroup.leave()
//                    }
//                    dispatchGroup.wait()
//                }
//                homeDataSyncOperation.addDependency(uploadWindupsOperation)
//                
//                // Adding operations to the queue
//                operationQueue.addOperations([postDayPlanOperation, retryDCROperation, uploadImageOperation, uploadWindupsOperation, homeDataSyncOperation], waitUntilFinished: false)
//                
//                // Ensure the completion operation runs after all others
//                completionOperation.addDependency(homeDataSyncOperation)
//            }
//
//            // Add the completion operation to the queue
//            operationQueue.addOperation(completionOperation)
//        }
//    }
    
    class func initWithStory(isfromLaunch: Bool, ViewModel: UserStatisticsVM) -> MainVC {
        let mainVC : MainVC = UIStoryboard.Hassan.instantiateViewController()
        mainVC.userststisticsVM = ViewModel
        mainVC.isFromLaunch = isfromLaunch
        mainVC.masterVM = MasterSyncVM()
        return mainVC
    }
    
    /// Notification observers that oberve notification
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dcrcallsAdded) , name: NSNotification.Name("callsAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDayplan) , name: NSNotification.Name("daplanRefreshed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postAllPlan) , name: NSNotification.Name("postAllPlan"), object: nil)
    }
     
    @objc func postAllPlan() {
        if isSequentialDCRenabled {
            guard let sessions = sessions, sessions.count > 0 else {return}
            guard sessions[0].workType == nil else {return}
        } else {
            guard selectedDate == nil else {return}
        }
       
        Shared.instance.showLoaderInWindow()
        self.toPostAlldayPlan{ [weak self] in
            guard let welf = self else {return}
            welf.handleDateSync()
            Shared.instance.removeLoaderInWindow()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      // CoreDataManager.shared.removeAllDayPlans()
      //  self.toConfigureMydayPlan(planDate: Shared.instance.selectedDate) {}
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
        
//        if let layout = self.analysisCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.collectionView?.isScrollEnabled = true
//        }
 
        if let layout = self.dcrCallsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.isScrollEnabled = true
        }
        
        
        if let layout = self.eventCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.collectionView?.isScrollEnabled = false
            layout.minimumInteritemSpacing = 10
        }
        
     
        
       // self.viewAnalysis.addGestureRecognizer(createSwipeGesture(direction: .left))
       // self.viewAnalysis.addGestureRecognizer(createSwipeGesture(direction: .right))
        
        
        [btnCall,btnActivity].forEach { button in
            button.layer.borderColor = AppColors.primaryColorWith_40per_alpha.cgColor
            button.layer.borderWidth = 1
        }

        
     //   self.updatePCPMChart()
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func setupUI() {
      
        cellRegistration()
        initView()
        viewNoCalls.isHidden = true
        viewNoOutboxCalls.isHidden = true
        rejectionVIew.isHidden = true
        toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
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
        lblAverageDocCalls.text = "Average \(LocalStorage.shared.getString(key: .doctor)) Calls"
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
        btnAddplan.layer.borderColor = UIColor.appTextColor.cgColor
        btnSavePlan.backgroundColor = .appGreyColor
        btnSavePlan.layer.borderWidth = 1
        btnSavePlan.layer.borderColor = UIColor.appTextColor.cgColor
        
        btnFinalSubmit.backgroundColor = .appTextColor
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
        btnCall.layer.cornerRadius = 5
        btnCall.backgroundColor = .appGreyColor
        btnActivity.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        btnActivity.layer.borderWidth = 1
        btnActivity.tintColor = .appTextColor
        btnActivity.layer.cornerRadius = 5
        btnActivity.backgroundColor = .appGreyColor
        
        self.worktypeTable.contentInsetAdjustmentBehavior = .never
        self.callTableView.contentInsetAdjustmentBehavior = .never
        self.worktypeTable.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        self.callTableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
        callsCountLbl.setFont(font: .medium(size: .BODY))
        callsCountLbl.textColor = .appTextColor
        homeTitleLbl.setFont(font: .bold(size: .SUBHEADER))
        
        btnNotification.isHidden = geoFencingEnabled ? false : true
        
      //  btnNotification.
        
        
        homeTitleLbl.text = AppDefaults.shared.getAppSetUp().divisionName
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
    
    
    
    func toSetChartType(chartType: ChartType) {
        switch chartType {
            
        default:
            self.toIntegrateChartView(.doctor, 0)
        }
    }
    
    
    func setDeviateSwitch(istoON: Bool) {
        deviateSwitch.isOn = istoON
    }
    
    
    /// function to refresh home Dashboard use this fincton to refresh Homepage without making API calls
    /// - Parameters:
    ///   - date: Sets App selected date
    ///   - rejectionReason: reason of rejection if exists (from ``DCRdatesModel``)
    ///   - issynced: Boolean
    ///   - segmentType: Home ui segment type
    ///   - completion: empty completion
    func refreshUI(date: Date? = nil, rejectionReason: String? = nil, issynced: Bool? = false, _ segmentType: SegmentType, completion: @escaping () -> ()) {
       
        toSetCacheDate(date: date)
        
        switch segmentType {
        case .workPlan:
            self.setSegment(.workPlan)
        case .calls:
            self.setSegment(.calls)
        case .calender:
            self.setSegment(.calender)
        case .outbox:
            self.setSegment(.outbox)
        }
        
//        viewNoOutboxCalls.isHidden = obj_sections.isEmpty ? false : true
//        
//        if let todayCallsModel = self.todayCallsModel, todayCallsModel.count != 0 {
//            viewNoCalls.isHidden  = true
//        } else {
//            viewNoCalls.isHidden  = false
//        }
        
        if let selectedToday = self.selectedToday  {
            toConfigureMydayPlan(planDate: selectedToday, isRetrived: true) { [weak self] in
                guard let welf = self else {return}
                welf.toSetDashboardDataSource(issynced: issynced,  reasonOfRejection: rejectionReason)
                completion()
            }
        } else {
            var sessionArr: [Sessions] = []
            var aSession = Sessions()
            aSession.cluster  = nil
            aSession.workType = nil
            aSession.headQuarters = nil
            aSession.isRetrived = Bool()
            aSession.isFirstCell = true
            aSession.planDate = nil
            sessionArr.append(aSession)
            self.sessions = sessionArr
            self.configureAddplanBtn(false)
            self.configureSaveplanBtn(false)
            toSetDashboardDataSource(issynced: issynced)
            completion()
        }
    }
    
    func toSetDashboardDataSource(issynced: Bool? = false, reasonOfRejection: String? = nil) {
        toSeperateDCR(istoAppend: true)
        updateDcr()
        togetDCRdates(isToUpdateDate: false) { }
       
        toIntegrateChartView(chartType, cacheDCRindex)
        if let reasonOfRejection = reasonOfRejection   {
            if !reasonOfRejection.isEmpty {
                setupRejectionVIew(isRejected: true, reason: reasonOfRejection)
            } else {
                setupRejectionVIew(isRejected: false, reason:  "")
            }
        } else {
            setupRejectionVIew(isRejected: false, reason:  "")
        }
        toLoadWorktypeTable()
        toLoadCalenderData()
        toLoadDcrCollection()
        toLoadOutboxTable(isSynced: issynced ?? false)
        toloadCallsTable()
    }
    
    func refreshDashboard(date: Date, _ segmentType: SegmentType? = nil, completion: @escaping () -> ()) {
        self.masterVM?.fetchMasterData(type: .homeSetup, sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { [weak self] isProcessed in
            guard let welf = self else {return}
            welf.refreshUI(date: date, segmentType ?? welf.segmentType[welf.selectedSegmentsIndex]) {
                completion()
            }
            
        }
    }


    @IBAction func didTapActivity(_ sender: Any) {
        let vc = ActivityVC.initWithStory()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func toSetupSubmitAlert() {
        let commonAlert = CommonAlert()

        commonAlert.setupAlert(alert: AppName, alertDescription: "You are trying to complete the day are you sure?", okAction:    "Ok" , cancelAction: "Cancel")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")

            self.deviateAction(isForremarks: true)
            
        }
        
        commonAlert.addAdditionalCancelAction {
            print("Yes action")
       
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
    
    

    

    
    
    func setupRejectionVIew(isRejected: Bool, reason : String) {
//        guard let nonNillSessions = sessions else {return}
//        
//        isRejected = nonNillSessions.map { $0.isRejected }.contains(true)
        rejectionTitle.text = "Rejected reason"
        
        if isRejected {
            // var isTodisableApproval = true
            rejectionReason.text = reason
            //nonNillSessions.map { $0.rejectionReason ?? "" }.first
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

    func setDateLbl(date: Date) {
        
        if self.selectedToday == nil  {
            lblDate.text = "Select Date"
            return
        }
        
     
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            lblDate.text = dateFormatter.string(from:  date)
        
    }
    
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async { [weak self] in
                    guard let welf = self else {return}
                    if status == ReachabilityManager.ReachabilityStatus.notConnected.rawValue  {
                        
                        welf.toCreateToast("Please check your internet connection.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                   
                        
                    } else if  status == ReachabilityManager.ReachabilityStatus.wifi.rawValue || status ==  ReachabilityManager.ReachabilityStatus.cellular.rawValue   {
                        
                        welf.toCreateToast("You are now connected.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
//                        welf.toPostAlldayPlan() {
//                            welf.btnCalenderSync(welf.btnSyncDate!)
//                        }
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
    
    func configureFinalsubmit(_ istoEnable : Bool) {
        if istoEnable {
            self.btnFinalSubmit.isUserInteractionEnabled = true
            self.btnFinalSubmit.alpha = 1
        } else {
            self.btnFinalSubmit.isUserInteractionEnabled = false
            self.btnFinalSubmit.alpha = 0.5
        }
        
        
        
    }
    
    func configureAddCall(_ istoEnable: Bool) {
       
        if istoEnable {
            self.btnCall.isUserInteractionEnabled = true
            self.btnCall.alpha = 1
            
            self.btnActivity.isUserInteractionEnabled = true
            self.btnActivity.alpha = 1
            return
        } else  {
            self.btnCall.isUserInteractionEnabled = false
            self.btnCall.alpha = 0.5
            
            self.btnActivity.isUserInteractionEnabled = false
            self.btnActivity.alpha = 0.5
            return
            

        }
    }
    
    
    func configureSaveplanBtn(_ isToEnable: Bool) {
        
        if isToEnable {
            self.btnSavePlan.isUserInteractionEnabled = true
            self.btnSavePlan.alpha = 1
        } else {
            self.btnSavePlan.isUserInteractionEnabled = false
            self.btnSavePlan.alpha = 0.5
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
    

    
    @objc func refreshDayplan() {
        handleDateSync()
    }
    
    @objc func dcrcallsAdded() {
//        let totalcalls: Int = obj_sections.reduce(0) { (result, section) -> Int in
//            return result + section.items.count
//        }
        
        let totalDays: Int = obj_sections.count
        
//        if totalcalls > 39 {
//            self.showAlertToPushCalls(desc: "NOTE! you have more than 40 calls in your out box")
//        }
        
                if totalDays > 2 {
                    self.showAlertToPushCalls(desc: "Note: You have unsynced data for more than 3 days. Please synchronize your data by performing sync calls in the Outbox.")
                }
        
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            toSetParams(date: self.selectedToday ?? Date(), isfromSyncCall: true) {
                // self.toLoadOutboxTable(isSynced: true)
                self.refreshDashboard(date: Shared.instance.selectedDate, SegmentType.calls) {
                  
                }
            }
        } else {
            refreshUI(date: Shared.instance.selectedDate, SegmentType.outbox) {}
        }
     
    }
    
    func showAlertToPushCalls(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("yes action")
            // self.toDeletePresentation()
          //  self.setSegment(.outbox, isfromSwipe: true)
            
        }

    }
    
    
    func toLoadDcrCollection() {
        dcrCallsCollectionView.delegate = self
        dcrCallsCollectionView.dataSource = self
        dcrCallsCollectionView.reloadData()
    }
    
    
    func toPostDayplan(byDate:Date, istoupdateUI: Bool, completion: @escaping () -> ()) {
        
        if  LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            
            
            callSavePlanAPI(byDate: byDate, istoupdateUI: istoupdateUI) {  [weak self] isUploaded in
                guard let welf = self else {return}
                
                if isUploaded  && istoupdateUI {
                    welf.toConfigureMydayPlan(planDate: byDate, isRetrived: true) {
                        completion()
                    }
                    
                } else {
                    if !istoupdateUI {
                        completion()
                        return
                    }
                    
                    welf.masterVM?.toGetMyDayPlan(type: .myDayPlan, isToloadDB: true, date: byDate) {_ in
                        
                        welf.toConfigureMydayPlan(planDate: byDate, isRetrived: true) {
                            completion()
                        }
                        
                    }
                    
                    
                }
            }
            
        } else {
            showAlertToFilldates(description: "Internet connection is required to sync Day plans.")
            completion()
        }
        
    }
    
    func toSetDayplan(byDate: Date, completion: @escaping () -> ()) {
        self.toSetParams(date: byDate, isfromSyncCall: false) {
        completion()
        }
    }
    
    func isSelectedDateCompleted(date: Date, completion : @escaping (Bool) -> () )  {
        var isDateExists : Bool = false
        CoreDataManager.shared.toFetchAllDayStatus { dayStatus in
            for adayStatus in dayStatus {
                let savedDate = adayStatus.statusDate
                let savedDateString = savedDate?.toString(format: "MMMM dd, yyyy")
                let selectedDate =  date
                let selectedDateString = selectedDate.toString(format: "MMMM dd, yyyy")
                if selectedDateString == savedDateString && !adayStatus.didUserWindup  {
                    isDateExists = true
                }
            }
            completion(isDateExists)
        }
    }
    
    func toReturnWindedupDates() -> [EachDayStatus]? {
        // Placeholder for the results
        var windedupDates: [EachDayStatus]?
        
        // Fetch all day statuses
        CoreDataManager.shared.toFetchAllDayStatus { dayStatus in
            // Filter to include only entities where the user has winded up
            let windedupEntities = dayStatus.filter { $0.didUserWindup }
            
            // Assign the filtered results to the return variable
            windedupDates = windedupEntities
        }
        
        return windedupDates
    }
    
    
    func toReturnNotWindedupDate() -> EachDayStatus? {
        // Placeholder date in case the closure does not return a date
        var returnDate : EachDayStatus?
        
        // Fetch all day statuses
        CoreDataManager.shared.toFetchAllDayStatus { dayStatus in
            // Filter out entities where the user has not winded up
            var notWindedupEntities = dayStatus.filter { !$0.didUserWindup }
            
            // If there are 2 or fewer entities, return the first one's statusDate if available
            if notWindedupEntities.count <= 2 {
                returnDate = notWindedupEntities.first
            } else {
                // Otherwise, sort the entities by statusDate in ascending order
                notWindedupEntities.sort { $0.statusDate ?? Date() < $1.statusDate ?? Date() }
                // Return the earliest statusDate
                returnDate = notWindedupEntities.first
            }
        }
        
        return returnDate
    }

    func cellRegistration() {
        self.quickLinkCollectionView.register(UINib(nibName: "QuickLinkCell", bundle: nil), forCellWithReuseIdentifier: "QuickLinkCell")
        
        self.dcrCallsCollectionView.register(UINib(nibName: "DCRCallAnalysisCell", bundle: nil), forCellWithReuseIdentifier: "DCRCallAnalysisCell")
        
     //   self.analysisCollectionView.register(UINib(nibName: "AnalysisCell", bundle: nil), forCellWithReuseIdentifier: "AnalysisCell")
        

        self.callTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forCellReuseIdentifier: "outboxCollapseTVC")
        
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "outboxCollapseTVC")
        
        self.outboxTableView.register(UINib(nibName: "OutboxDetailsTVC", bundle: nil), forCellReuseIdentifier: "OutboxDetailsTVC")
        
        
        //    self.worktypeTable.register(UINib(nibName: "HomeWorktypeTVC", bundle: nil), forCellReuseIdentifier: "HomeWorktypeTVC")
        
        self.worktypeTable.register(UINib(nibName: "MyDayPlanTVC", bundle: nil), forCellReuseIdentifier: "MyDayPlanTVC")
        
        
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
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
            self.viewNoOutboxCalls.isHidden = obj_sections.isEmpty ? false : true
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
        guard  let tempUnsyncedArr = DBManager.shared.geUnsyncedtHomeData() else{ return }
        self.unsyncedhomeDataArr =  tempUnsyncedArr
        
        self.outBoxDataArr?.removeAll()
        
        let outBoxDataArr =  self.unsyncedhomeDataArr.filter { $0.fw_Indicator != "N" }
        
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
            self.toConfigureClearCalls(istoEnable: true)
            completion()
        }
    }
 
    func toSeperateOutboxSections(outboxArr: [TodayCallsModel], completion: @escaping () -> ()) {
        // Dictionary to store arrays of TodayCallsModel for each day
        var callsByDay: [String: [TodayCallsModel]] = [:]
        var eventsByDay: [String: [UnsyncedEventCaptureModel]] = [:]
        var plansByDay : [String: [Sessions]] = [:]
        var statusByDay : [String: [EachDayStatus]] = [:]
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
        
   
        
        // Fetch UnsyncedEventCaptureModel data and organize by day
        let dispatchGroup = DispatchGroup()
     
        CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventCaptures in
            dispatchGroup.enter()
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
        
      //  dispatchGroup.enter()
        var dateArr: [Date] = []
        CoreDataManager.shared.fetchEachDayPlan { aDayplans in
            
           let unSyncedPlans = aDayplans.filter { !$0.isSynced }
            
            unSyncedPlans.forEach { eachDayPlan in
                dateArr.append(eachDayPlan.planDate ?? Date())
            }
         //   dispatchGroup.leave()
        }
        
     
       
        for aDate in dateArr {
            dispatchGroup.enter()
            toFetchExistingPlan(byDate: aDate) {existingSessions in
                for aExistingSessions in existingSessions {
                    if aExistingSessions.isSynced == false  {
                        let dayString = dateFormatter.string(from: aExistingSessions.planDate ?? Date())
                        if plansByDay[dayString] == nil {
                            plansByDay[dayString] = [aExistingSessions]
                        } else {
                            plansByDay[dayString]?.append(aExistingSessions)
                        }
                    }
                    
                }
                dispatchGroup.leave()
            }
          
        }
        
        CoreDataManager.shared.toFetchAllDayStatus { eachDayStatus in
            dispatchGroup.enter()
            let filteredDayStatus = eachDayStatus.filter { $0.didUserWindup && !$0.isSynced }
            
            for aEachDayStatus in filteredDayStatus {
                if let statusDate = aEachDayStatus.statusDate {
                    let dayString = dateFormatter.string(from: statusDate)
                    if statusByDay[dayString] == nil {
                        statusByDay[dayString] = [aEachDayStatus]
                    } else {
                        statusByDay[dayString]?.append(aEachDayStatus)
                    }
                }
            }
            dispatchGroup.leave()
        }
        

        
        // Wait for all async tasks to complete
        dispatchGroup.notify(queue: .main) {
            // Create sections combining callsByDay, eventsByDay, plansByDay and statusByDay
            obj_sections.removeAll()
            let allDays = Set(callsByDay.keys).union(Set(eventsByDay.keys)).union(Set(plansByDay.keys)).union(Set(statusByDay.keys))
    
            for day in allDays {
                let calls = callsByDay[day] ?? []
                let events = eventsByDay[day] ?? []
                let dayPlans = plansByDay[day] ?? []
                let dayStaus = statusByDay[day] ?? []
                let section = Section(items: calls, eventCaptures: events, date: day, sessions: dayPlans, eachDayStatus: dayStaus)
                
                obj_sections.append(section)
                obj_sections =  obj_sections.sorted { $0.date.toDate(format: "yyyy-MM-dd") < $1.date.toDate(format: "yyyy-MM-dd") }
              
            }
            completion()
        }
    }


    
    /// Fetched all added DCR call from API
    /// - Parameters:
    ///   - date: Date for which call to be fetched
    ///   - isfromSyncCall: Boolean
    ///   - completion: empty completion
    func toSetParams(date: Date, isfromSyncCall: Bool, completion: @escaping () -> ()) {
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            self.toCreateToast("Please connect to internet")
            completion()
            return
        }
        let appsetup = AppDefaults.shared.getAppSetUp()
        let date = date.toString(format: "yyyy-MM-dd HH:mm:ss")
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
    


    

    
//    private func updatePCPMChart() {
//        
//        self.viewPcpmChart.startAngle = -90.0
//        self.viewPcpmChart.isClockwise = true
//        self.viewPcpmChart.font = UIFont(name: "Satoshi-Bold", size: 18)!
//        self.viewPcpmChart.fontColor = .darkGray
//        if #available(iOS 13.0, *) {
//            self.viewPcpmChart.outerRingColor = UIColor.systemGray4
//        } else {
//            self.viewPcpmChart.outerRingColor = UIColor.lightGray
//            // Fallback on earlier versions
//        }
//        
//        self.viewPcpmChart.innerRingColor = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(185.0/255.0), blue: CGFloat(26.0/255.0), alpha: CGFloat(1.0))
//        self.viewPcpmChart.innerRingWidth = 25.0
//        self.viewPcpmChart.style = .bordered(width: 0.0, color: .black)
//        self.viewPcpmChart.outerRingWidth = 25.0
//        
//        self.viewPcpmChart.maxValue = CGFloat(truncating: 10.0)
//        self.viewPcpmChart.startProgress(to: CGFloat(truncating: 4.0), duration: 2)
//    }

    private func updateLinks () {
        
        let presentationColor = UIColor.appGreen
       // let activityColor = UIColor.appBrown
        let reportsColor = UIColor.appLightPink
        let previewColor = UIColor.appBlue
        
        
        let presentation = QuicKLink(color: presentationColor, name: "Presentaion", image: UIImage(imageLiteralResourceName: "presentationIcon"))
      //  let activity = QuicKLink(color: activityColor, name: "Activity", image: UIImage(imageLiteralResourceName: "SideMenuActivity"))
        let reports = QuicKLink(color: reportsColor, name: "Reports", image: UIImage(imageLiteralResourceName: "reportIcon"))
        
        let slidePreview = QuicKLink(color: previewColor, name: "Preview", image: UIImage(imageLiteralResourceName: "slidePreviewIcon"))
        
        self.links.append(presentation)
        self.links.append(slidePreview)
        self.links.append(reports)
      //  self.links.append(activity)
        
        
        
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
            var unsyncedDocArr = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "1"
             }
            
            var uniqueUnsyncCustCodes =  Set<String>()
            
            // Filter the array to include only the first occurrence of each unique custCode
            unsyncedDocArr = unsyncedDocArr.filter { aUnsyncedHomeData in
                if let custCode = aUnsyncedHomeData.custCode, !uniqueUnsyncCustCodes.contains(custCode) {
                    uniqueUnsyncCustCodes.insert(custCode)
                    return true
                } else {
                    return false
                }
            }
            
//             let unsyncedDocilteredArray = unsyncedDocArr.filter { model in
//                 return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
//             }
             
             let doctorCount = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
             
             
             var doctorfilteredArray = doctorArr.filter { model in
                 return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
             }
            
           var uniqueSyncCustCodes = Set<String>()
            
            // Filter the array to include only the first occurrence of each unique custCode
            doctorfilteredArray = doctorfilteredArray.filter { aUnsyncedHomeData in
                if let custCode = aUnsyncedHomeData.custCode, !uniqueSyncCustCodes.contains(custCode) {
                    uniqueSyncCustCodes.insert(custCode)
                    return true
                } else {
                    return false
                }
            }
          let uniqueCalls = uniqueUnsyncCustCodes.union(uniqueSyncCustCodes)
             
            self.dcrCount.append(DcrCount(name: appSetups.docCap ??  "Listed Doctor",color: .appGreen,count: doctorCount.description, image: UIImage(named: "dashboardDoctor") ?? UIImage(), callsCount: uniqueCalls.count))
            // doctorfilteredArray.count + unsyncedDocilteredArray.count
        }

        if appSetups.chmNeed == 0 {
            var unsyncedChemist = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "2"
             }
            
            
            var uniqueUnsyncCustCodes =  Set<String>()
            
            // Filter the array to include only the first occurrence of each unique custCode
            unsyncedChemist = unsyncedChemist.filter { aUnsyncedHomeData in
                if let custCode = aUnsyncedHomeData.custCode, !uniqueUnsyncCustCodes.contains(custCode) {
                    uniqueUnsyncCustCodes.insert(custCode)
                    return true
                } else {
                    return false
                }
            }
            
            
//            let unsyncedChemistilteredArray = unsyncedChemist.filter { model in
//                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
//            }
            
            let chemistCount = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            var chemistfilteredArray = chemistArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
            
            
            var uniquesyncCustCodes =  Set<String>()
            
            // Filter the array to include only the first occurrence of each unique custCode
            chemistfilteredArray = chemistfilteredArray.filter { aUnsyncedHomeData in
                if let custCode = aUnsyncedHomeData.custCode, !uniquesyncCustCodes.contains(custCode) {
                    uniquesyncCustCodes.insert(custCode)
                    return true
                } else {
                    return false
                }
            }
            let uniqueCalls = uniqueUnsyncCustCodes.union(uniquesyncCustCodes)
            
            self.dcrCount.append(DcrCount(name: appSetups.chmCap ??  "Chemist",color: .appBlue,count: chemistCount.description, image: UIImage(named: "dashboardChemist") ?? UIImage(), callsCount:  uniqueCalls.count))
            //chemistfilteredArray.count + unsyncedChemistilteredArray.count
        }
        
        
        if appSetups.stkNeed == 0 {
            var unsyncedStockist = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "3"
             }
            
            var uniqueSyncCustCodes = Set<String>()
             
             // Filter the array to include only the first occurrence of each unique custCode
            unsyncedStockist = unsyncedStockist.filter { aUnsyncedHomeData in
                 if let custCode = aUnsyncedHomeData.custCode, !uniqueSyncCustCodes.contains(custCode) {
                     uniqueSyncCustCodes.insert(custCode)
                     return true
                 } else {
                     return false
                 }
             }
            
            
//            let unsyncedStockistilteredArray = unsyncedStockist.filter { model in
//                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
//            }
            
            var stockistFilteredArray = stockistArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
             
            
            var uniqueUnSyncCustCodes = Set<String>()
             
             // Filter the array to include only the first occurrence of each unique custCode
            stockistFilteredArray = stockistFilteredArray.filter { aUnsyncedHomeData in
                 if let custCode = aUnsyncedHomeData.custCode, !uniqueUnSyncCustCodes.contains(custCode) {
                     uniqueUnSyncCustCodes.insert(custCode)
                     return true
                 } else {
                     return false
                 }
             }
            
            
            let stockistCount = DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            let uniqueCalls = uniqueSyncCustCodes.union(uniqueUnSyncCustCodes)
            
            self.dcrCount.append(DcrCount(name: appSetups.stkCap ??  "Stockist",color: .appLightPink,count: stockistCount.description, image: UIImage(named: "dashboardStockist") ?? UIImage(), callsCount: uniqueCalls.count))
            //stockistFilteredArray.count + unsyncedStockistilteredArray.count
        }
        
        
        if appSetups.unlNeed == 0 {
            
            var unsyncedunlistedDoc = self.unsyncedhomeDataArr.filter { aUnsyncedHomeData in
                 aUnsyncedHomeData.custType == "4"
             }
            
            
            var uniqueUnsyncCustCodes =  Set<String>()
            
            // Filter the array to include only the first occurrence of each unique custCode
            unsyncedunlistedDoc = unsyncedunlistedDoc.filter { aUnsyncedHomeData in
                if let custCode = aUnsyncedHomeData.custCode, !uniqueUnsyncCustCodes.contains(custCode) {
                    uniqueUnsyncCustCodes.insert(custCode)
                    return true
                } else {
                    return false
                }
            }
            
            
//            let unsyncedunlistedDocilteredArray = unsyncedunlistedDoc.filter { model in
//                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate, iftosyncOutbox: true)
//            }
            
            var unlistedDocFilteredArray = unlistedDocArr.filter { model in
                return isDateInCurrentMonthAndYear(model.dcr_dt, currentDate: currentDate)
            }
            
            var uniqueUnSyncCustCodes = Set<String>()
             
             // Filter the array to include only the first occurrence of each unique custCode
            unlistedDocFilteredArray = unlistedDocFilteredArray.filter { aUnsyncedHomeData in
                 if let custCode = aUnsyncedHomeData.custCode, !uniqueUnSyncCustCodes.contains(custCode) {
                     uniqueUnSyncCustCodes.insert(custCode)
                     return true
                 } else {
                     return false
                 }
             }
            
            let unlistedDocCount = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
            
            let uniqueCalls = uniqueUnsyncCustCodes.union(uniqueUnSyncCustCodes)
            
            self.dcrCount.append(DcrCount(name: appSetups.nlCap ?? "UnListed Doctor",color: .appLightTextColor.withAlphaComponent(0.2) ,count: unlistedDocCount.description, image: UIImage(named: "dashboardUnlistedDoctor") ?? UIImage(), callsCount: uniqueCalls.count))
            //unlistedDocFilteredArray.count + unsyncedunlistedDocilteredArray.count
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
            toLoadOutboxTable()
            
           
           // if isfromSwipe ?? false {
                self.selectedSegmentsIndex = 0
                self.segmentsCollection.reloadData()
          //  }
            
            
        case .calls:
            if let todayCallsModel = self.todayCallsModel, todayCallsModel.count != 0 {
                viewNoCalls.isHidden  = true
            } else {
                viewNoCalls.isHidden  = false
            }
       
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
            viewNoOutboxCalls.isHidden = obj_sections.isEmpty ? false : true
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
        dateComponents.month = moveUp ?  1 : -1

      
        if moveUp {
            // Calculate the next month
            
            let thisMonth = calendar.date(byAdding: .month, value: 0, to: self.celenderToday)
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: self.celenderToday)
            let twoMonthBack = calendar.date(byAdding: .month, value: -2, to: self.celenderToday)
            
        //    var isToMoveindex: Int? = nil
            
            let selectedMonth = currentPage.toString(format: "yyyy-MM")
            
            if selectedMonth == thisMonth?.toString(format: "yyyy-MM") {
                
                istwoMonthsAgo = false
                isPrevMonth = false
                isCurrentMonth = true
                self.currentPage = thisMonth ?? Date()
                
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
                
            } else if selectedMonth == previousMonth?.toString(format: "yyyy-MM") {
                
                isPrevMonth = true
                isCurrentMonth = false
                istwoMonthsAgo = false
                self.currentPage = thisMonth ?? Date()
                
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: false)
                
            } else if selectedMonth == twoMonthBack?.toString(format: "yyyy-MM") {
                istwoMonthsAgo = true
                isPrevMonth = false
                isCurrentMonth = false
                self.currentPage = previousMonth ?? Date()
                
                toDisableNextPrevBtn(enableprevBtn: false, enablenextBtn: true)
            }
        } else if !moveUp {
            
            // Calculate the previous month
            
            let thisMonth = calendar.date(byAdding: .month, value: 0, to: self.celenderToday)
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: self.celenderToday)
            let twoMonthBack = calendar.date(byAdding: .month, value: -2, to: self.celenderToday)
            
        //    var isToMoveindex: Int? = nil
            
            let selectedMonth = currentPage.toString(format: "yyyy-MM")
            
            if selectedMonth == thisMonth?.toString(format: "yyyy-MM") {
                
                istwoMonthsAgo = false
                isPrevMonth = false
                isCurrentMonth = true
                self.currentPage = previousMonth ?? Date()
                
                toDisableNextPrevBtn(enableprevBtn: true, enablenextBtn: true)
                
            } else if selectedMonth == previousMonth?.toString(format: "yyyy-MM") {
                isPrevMonth = true
                isCurrentMonth = false
                istwoMonthsAgo = false
                self.currentPage = twoMonthBack ?? Date()
                toDisableNextPrevBtn(enableprevBtn: false, enablenextBtn: true)
                
            } else if selectedMonth == twoMonthBack?.toString(format: "yyyy-MM") {
                istwoMonthsAgo = true
                isPrevMonth = false
                isCurrentMonth = false
                self.currentPage = twoMonthBack ?? Date()
                toDisableNextPrevBtn(enableprevBtn: false, enablenextBtn: true)
            }
            
        } else {
            if let currentMonth = calendar.date(byAdding: .month, value: 0, to: self.celenderToday) {
                print("Previous Month:", currentMonth)
                self.currentPage = currentMonth
               
            }
        }

        self.tourPlanCalander.setCurrentPage(self.currentPage, animated: true)
  
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
            
        
            btnNext.alpha = 1
            btnNext.isUserInteractionEnabled = false
            
        } else if enablenextBtn {
            prevBtn.alpha = 1
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
    
    /// API call to sync dates
    ///
    /// ``DCRdatesModel`` from response is saved to core data
    ///
    ///Upon saving App process  to select date from ``DCRdatesModel``
    /// - Parameter sender: Any of type UIButton
    @IBAction func btnCalenderSync(_ sender: Any) {
        if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            Shared.instance.showLoaderInWindow()
            masterVM?.tofetchDcrdates() {[weak self] result in
                Shared.instance.removeLoaderInWindow()
                guard let welf = self else {return}
                switch result {
                   
                case .success(let response):
         
                    CoreDataManager.shared.saveDatestoCoreData(model: response) { [weak self] in
                        guard let welf = self else {return}
                        welf.togetDCRdates(isToUpdateDate: false) {
                         //   if !isSequentialDCRenabled {
                            welf.configurePastWindups(pageType: .calender) {}
                          //  }
                        }
                    }

                case .failure(let error):
                  //  Shared.instance.removeLoaderInWindow()
                    welf.toCreateToast("\(error)")
                }
            }
            

            
        } else {
            
            togetDCRdates(isToUpdateDate: false) {
               // if !isSequentialDCRenabled {
                self.configurePastWindups(pageType: .calender) {}
               // }
                
            }

        }
        
    }
    
    func isUserPlanning(completion: (Bool) -> ()) {
     
        
        if isSequentialDCRenabled {
            guard let sessions = sessions, sessions.count > 0 else {
                completion(false)
                return
            }
            guard sessions[0].workType == nil else {
                completion(false)
                return
            }
            completion(true)
        } else {
            completion(selectedDate == nil  ? false : true)
        }
        

     
        
    }
    
    func planningAction() {
        CoreDataManager.shared.tpAppendToday { [weak self] in
            guard let welf = self else {return}
            welf.togetDCRdates(isToUpdateDate: false) {
                welf.configurePastWindups(pageType: .calender) {}
            }
        }

    }
    
    func doUserWindupAPIcall(completion: @escaping(Bool) -> () ) {
        

      //  {"tableName":"final_day","sfcode":"MR5940","division_code":"63,","Rsf":"MR5940","sf_type":"1","Designation":"MR","state_code":"2","subdivision_code":"86,","day_flag":"1","Appver":"Version.H1","Mod":"Android-Edet","Activity_Dt":"2024-04-22 00:00:00","current_Dt":"2024-05-08 10:12:51","day_remarks":"remark mandatory"}
        var param : [String: Any] = [:]
        param["tableName"]  = "final_day"
        param["sfcode"] = appSetups.sfCode
        
        param["division_code"] = appSetups.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appSetups.sfType
        param["Designation"] = appSetups.desig
        param["state_code"] = appSetups.stateCode
        param["subdivision_code"] = appSetups.subDivisionCode
        param["day_flag"] = "1"
        param["Activity_Dt"] = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd HH:mm:ss")
        param["current_Dt"] = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd HH:mm:ss")
        param["day_remarks"] = self.dayRemarks == "Type here.." ? "" :  self.dayRemarks
        
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        var tosendData = [String: Any]()
        tosendData["data"] = paramData
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            self.handleWindups(date: selectedToday, isSynced: false, didUserWindup: true, paramData: paramData) { isSaved in
                completion(isSaved)
                return
            }
            return
        }
        
        userststisticsVM?.finalSubmit(params: tosendData, api: .finalSubmit, paramData: param) {[weak self]  result in
            guard let welf = self else {return}
            switch result {
                
            case .success(let response):
                if response.isSuccess  ?? false {
                    welf.toCreateToast(response.msg ?? "Day completed successfully...")
                    
                    welf.handleWindups(date: welf.selectedToday, isSynced: true, didUserWindup: true, paramData: paramData) { isSaved in
                      //  welf.toCreateToast("Saved log offline")
                        completion(isSaved)
                    }
                    
                } else {
                    
                    welf.handleWindups(date: welf.selectedToday, isSynced: false, didUserWindup: true, paramData: paramData) { isSaved in
                     //   welf.toCreateToast("Saved log offline")
                        completion(isSaved)
                    }
                    
                }
            
            case .failure(let error):
                welf.toCreateToast(error.rawValue)

                welf.handleWindups(date: welf.selectedToday, isSynced: false, didUserWindup: true, paramData: paramData) { isSaved in
                
                    completion(isSaved)
                }
           
            }
          
        }
    }
    
    func handleWindups(date: Date?, isSynced: Bool, didUserWindup: Bool, paramData: Data, completion: @escaping (Bool) -> ()) {

        guard let selectedToday = date else {
            completion(true)
            return}
        
        if isDayCheckinNeeded {
            CoreDataManager.shared.fetchCheckininfo() { saveCheckins  in
                guard let aCheckin = saveCheckins.first else {return}

                let achckinInfo = CheckinInfo(address: aCheckin.address, checkinDateTime: aCheckin.checkinDateTime , checkOutDateTime: aCheckin.checkOutDateTime, latitude:  aCheckin.latitude, longitude:   aCheckin.longitude, dateStr: selectedToday.toString(format: "yyyy-MM-dd HH:mm:ss"), checkinTime: aCheckin.checkinTime, checkOutTime: aCheckin.checkOutTime)
                
                toSaveDayStatusToCoreData(date: selectedToday, didUserWindup: didUserWindup, isSynced: isSynced, cacheParam: paramData, checkinInfo: achckinInfo) { isSaved in
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: true)
                    completion(isSaved)
                }
            }
        } else {
            toSaveDayStatusToCoreData(date: selectedToday, didUserWindup: didUserWindup, isSynced: isSynced, cacheParam: paramData) { isSaved in
                LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: true)
                completion(isSaved)
            }
        }
    }
    
    func toSaveDayStatusToCoreData(date: Date, didUserWindup: Bool, isSynced: Bool, cacheParam: Data, checkinInfo: CheckinInfo? = nil,  completion: @escaping (Bool) -> ()) {
        
        if isDayCheckinNeeded {
            guard let aCheckinInfo = checkinInfo else {
                CoreDataManager.shared.saveDayStatusToCoreData(date: date, didUserWindup: didUserWindup, isSynced: isSynced, params: cacheParam) {isSaved in
                    completion(isSaved)
                }
                return
            }
            
            CoreDataManager.shared.saveDayStatusToCoreData(date: date, didUserWindup: didUserWindup, isSynced: isSynced, checkinInfo: aCheckinInfo, params: cacheParam) {isSaved in
                completion(isSaved)
            }
            
        } else   {
            CoreDataManager.shared.saveDayStatusToCoreData(date: date, didUserWindup: didUserWindup, isSynced: isSynced, params: cacheParam) {isSaved in
                completion(isSaved)
            }
        }
    }

    @IBAction func didTapFinalSubmit(_ sender: Any) {
        
        
        if findDateExistsinTPrange() {
            self.showAlertToFilldates(description: "Prepare your Tour Plan")
            return
        }
        
        guard let selectedToday = self.selectedToday else {
            
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.viewDate.backgroundColor = .appLightPink
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.viewDate.backgroundColor = .appWhiteColor
                   
                })
            }
            
            showAlertToFilldates(description: "Please select date to submit.")
            return
        }
 
        
        if isDayCheckinNeeded {
            

            
            guard let nonNillsessions = self.sessions, !nonNillsessions.isEmpty  else {
                if !LocalStorage.shared.getBool(key: .isUserCheckedin) {
                    checkinAction()
            
                }
                return
            }
            
            guard nonNillsessions[0].workType != nil else {
                if !LocalStorage.shared.getBool(key: .isUserCheckedin) {
                    checkinAction()
                    
                }
                return
            }
        }
     
        toFetchExistingPlan(byDate: selectedToday) { [weak self] existingSessions in
            guard let welf   = self else {return}
            if existingSessions.isEmpty {
                welf.showAlertToFilldates(description: "Please fill work plan to Final submit")
                welf.setSegment(.workPlan)
                return
            }
            
           let fieldWorkSession = existingSessions.filter { $0.workType?.fwFlg == "F" }
            
            if !fieldWorkSession.isEmpty {
                welf.isFieldWorkExists = true
                CoreDataManager.shared.toGetCallsCountForDate(callDate: selectedToday) {  callsCount in
                    if callsCount == 0 {
                        let cacheCalls = DBManager.shared.getHomeData().filter { $0.dcr_dt == Shared.instance.selectedDate.toString(format: "yyyy-MM-dd") && $0.fw_Indicator == "F" && $0.custType != "0" }
                        if cacheCalls.isEmpty {
                            welf.showAlertToFilldates(description: "Add call for choosen work plan to Final submit")
                            welf.setSegment(.calls)
                            return
                        } else {
                            welf.doUserWindup()
                        }
                    } else {
                        welf.doUserWindup()
                    }
                }
            } else {
                welf.toAppendNonFieldWorks()
                welf.doUserWindup()
            }
        }
    }
    
    
    func toModifyDayStatus(dcrDate: String) {
        let context = DBManager.shared.managedContext()
        
        let fetchRequest: NSFetchRequest<HomeData> = HomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dcr_dt == %@", dcrDate )
        
        do {
           let results = try context.fetch(fetchRequest)
           for result in results {
               result.dayStatus = "1"
                DBManager.shared.saveContext()
            }
        } catch {
            // Handle fetch error
         
        }
    }
    
    func doRemoveActions(completion: @escaping () -> ()) {
        let filteredDetails =  homeDataArr.filter { $0.dcr_dt ?? "" == Shared.instance.selectedDate.toString(format: "yyyy-MM-dd") }
        
      let filteredData =  DBManager.shared.getHomeData().filter { $0.dcr_dt ?? "" == Shared.instance.selectedDate.toString(format: "yyyy-MM-dd") }
        filteredData.forEach { HomeData in
            HomeData.dayStatus = "1"
        }
        
        toModifyDayStatus(dcrDate: Shared.instance.selectedDate.toString(format: "yyyy-MM-dd"))
        
        filteredDetails.indices.forEach { index in
            filteredDetails[index].fw_Indicator = isFieldWorkExists ? "F" : "N"
        }
        self.selectedToday = nil
        self.isFieldWorkExists = false
        self.todayCallsModel = nil
        self.callsCountLbl.text = ""
        isDayPlanRemarksadded = false
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: false)
        


        CoreDataManager.shared.removeDcrDate(date: Shared.instance.selectedDate) {
            completion()
          //  guard let welf = self else {return}
          //  welf.btnCalenderSync(welf.btnSyncDate!)
        }
    }
    
    func fetchEmptyDates()  {
        let calendar = Calendar.current
        let today = Date()
        let twoMonthsBack = calendar.date(byAdding: .month, value: -2, to: today)!
        let startOfTwoMonthsBack = calendar.date(from: calendar.dateComponents([.year, .month], from: twoMonthsBack))
        let dates = getDates(from: startOfTwoMonthsBack ?? Date(), to: today)
        dates.forEach { date in
            dump(date.toString(format: "yyyy-MM-dd"))
        }
        let allDates =  dates.map { $0.toString(format: "yyyy-MM-dd") }
        
        let homeData = DBManager.shared.getHomeData()
      
        
      
        var plannedDates = homeData.map { $0.dcr_dt?.toDate(format: "yyyy-MM-dd").toString(format: "yyyy-MM-dd") }
        if let unsyncedHomeDta = DBManager.shared.geUnsyncedtHomeData() {
            let unSyncedplannedDates = unsyncedHomeDta.map { $0.dcr_dt?.toDate(format: "yyyy-MM-dd").toString(format: "yyyy-MM-dd") }
            plannedDates.append(contentsOf: unSyncedplannedDates)
        }
        // Convert plannedDates to a set for efficient lookups
          let plannedDatesSet = Set(plannedDates)
          
          // Filter allDates to exclude dates present in plannedDatesSet
          let filteredDates = allDates.filter { !plannedDatesSet.contains($0) }
        
         dump(filteredDates)
    }
 

    // Function to generate an array of dates from start date to end date
    func getDates(from startDate: Date, to endDate: Date) -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    func doSequentialFlow(completion: @escaping () -> () ) {
        setDCRdates {[weak self] sequenceDate  in
            guard let welf = self else {return}
            if let sequenceDate = sequenceDate {
                welf.configureFinalsubmit(true)
                let filteredDetails =  welf.homeDataArr.filter { $0.dcr_dt ?? "" == sequenceDate.rejectedDate.toString(format: "yyyy-MM-dd") }
                filteredDetails.indices.forEach { index in
                    filteredDetails[index].fw_Indicator = welf.isFieldWorkExists ? "F" : "N"
                }
                welf.refreshUI(date: sequenceDate.rejectedDate, rejectionReason: sequenceDate.rejectionReason.isEmpty ? nil : sequenceDate.rejectionReason, SegmentType.workPlan) {
                    welf.toCreateNewDayStatus()
                    completion()
                }
            } else {
               print("Yet to")
                welf.doNonSequentialFlow()
                completion()
            }
            
        }
        
        return

    }
    
    
    func doNonSequentialFlow() {
    
       refreshUI(date: selectedToday, SegmentType.workPlan) {}
    }
    
 
    
    func doUserWindup() {
        
        if isDayPlanRemarksadded {
            if isDayCheckinNeeded {
                LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: true)
                checkoutAction()
            } else {
                
                doUserWindupAPIcall { [weak self] _ in
                    guard let welf = self else {return}
                    
                    welf.masterVM?.fetchMasterData(type: .homeSetup, sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) { [weak self] isProcessed in
                        guard let welf = self else {return}
                        if isSequentialDCRenabled {
                            welf.doRemoveActions {
                                welf.doSequentialFlow() {
                                welf.showAlertToFilldates(description: LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) == true ? "Final submission done." : "Not connected to internet submission saved locally.")
                                return
                                }
                            }
                        } else {
                            welf.doRemoveActions() {
                                welf.doNonSequentialFlow()
                                welf.showAlertToFilldates(description: LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) == true ? "Final submission done." : "Not connected to internet submission saved locally.")
                                return
                            }
               
                        }
                        
                    }
                    
       
                }
            }
        } else {
            if isDayCheckinNeeded {
                guard let nonNillsessions = self.sessions else {
                    if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                        self.checkinAction()
                    }
                    return
                }
                guard nonNillsessions[0].workType != nil else {
                    if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                        self.checkinAction()
                    }
                    return
                }
                
                self.toSetupSubmitAlert()
                
            } else {
                self.toSetupSubmitAlert()
            }

            
         
        }

    }
    
    struct RejectionReason {
        let rejectedDate : Date
        let rejectionReason: String
    }
    
    /// App `Sequential flow` date auto selection function
    ///
    /// fetches incompleted pending dcrDates from core data (if date satifies below condition then it is pending date)
    /// 
    /// ```Swift
    ///$0.isDateAdded == false
    /// ```
    /// - Parameter completion: ``RejectionReason``
    func setDCRdates(completion: @escaping (RejectionReason?) -> ()) {
        var yetToreturnDate: RejectionReason?
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        CoreDataManager.shared.fetchDcrDates { dcrDates in
            
            let unFilledDates =  dcrDates.filter { $0.isDateAdded == false }
            var dates: [RejectionReason]? = []
            unFilledDates.forEach { dcrDates in
                if let date = dcrDates.date, let reason = dcrDates.reason  {
                    
                    dates?.append(RejectionReason(rejectedDate: date.toDate(format: "yyyy-MM-dd"), rejectionReason: reason))
                }
               
            }
            
            dates =  dates?.sorted(by: { date1, date2 in
                
                date1.rejectedDate < date2.rejectedDate
            })
            
            yetToreturnDate = dates?.first
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(yetToreturnDate)
        }
      
    }
    

    func clearAction() {
        self.outboxCountVIew.isHidden = true
        self.outBoxDataArr?.removeAll()
        LocalStorage.shared.setBool(LocalStorage.LocalValue.userCheckedOut, value: false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserCheckedin, value: false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.didUserWindUP, value: false)
        CoreDataManager.shared.removeUnsyncedDayPlans()
        CoreDataManager.shared.removeAllDayStatus()
        CoreDataManager.shared.removeUnsyncedHomeData()
        CoreDataManager.shared.removeAllOutboxParams()
        CoreDataManager.shared.removeAllUnsyncedEventCaptures()
        CoreDataManager.shared.removeAllSanvedCalls()
        CoreDataManager.shared.fetchDcrDates { [weak self] dcrDates in
            guard let welf = self else {return}
            dcrDates.forEach { aDcrDate in
                aDcrDate.isDateAdded = false
            }
            CoreDataManager.shared.saveContext()

            welf.btnCalenderSync(welf.btnSyncDate!)
        }
    }

    func toCheckDataExistanceinOutbox(completion: @escaping (Bool) -> () ) {
        guard obj_sections.isEmpty else {
            completion(true)
            return }
        completion(false)
//        //Day plans
//        
//        CoreDataManager.shared.fetchEachDayPlan { dayplans in
//            let isAllPlansSynced = dayplans.filter { $0.isSynced == false }.isEmpty
//            
//            guard !isAllPlansSynced else {
//                
//                //Calls
//                
//                guard let unsyncedCalls =  DBManager.shared.geUnsyncedtHomeData(), unsyncedCalls.count > 0 else{
//                    
//                    //Day submissions
//                    
//                    CoreDataManager.shared.toFetchAllDayStatus { eachDayStatus in
//                        let isAllDaysSubmitted = eachDayStatus.filter { $0.isSynced == false }.isEmpty
//                        guard isAllDaysSubmitted else {
//                            
//                            //Day Not submitted Yet
//                            completion(false)
//                            return
//                        }
//                    }
//                    completion(true)
//                    return
//                }
//                
//                //Calls Exists
//                
//                completion(true)
//                return
//            }
//            
//            //Dayplan Exists
//            
//            completion(true)
//            return
//            
//        }

    }
    
    @IBAction func didTapClearCalls() {
        toCheckDataExistanceinOutbox() { ifExists in
          guard ifExists else { return }
            self.showAlertToNetworks(desc: "This action will clear all of unsynced outbox calls. Are you sure you want to proceed?", isToclearacalls: true)
            
        }
  
        
    }

    @IBAction func outboxCallSyncAction(_ sender: UIButton) {
        
    }

    @IBAction func callAction(_ sender: UIButton) {
        
//        if findDateExistsinTPrange() {
//            self.showAlertToFilldates(description: "Please complete your tour plan to Add Call")
//            return
//        }
        
        if selectedToday == nil  {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.viewDate.backgroundColor = .appLightPink
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.viewDate.backgroundColor = .appWhiteColor
                   
                })
            }
            
            self.showAlertToFilldates(description: "Please select date to Add Call")
            return
        }
        
        if isDayCheckinNeeded {
            guard let nonNillsessions = self.sessions  else {
                if !LocalStorage.shared.getBool(key: .isUserCheckedin) {
                    checkinAction()
            
                }
                return
            }
            
            guard nonNillsessions[0].workType != nil else {
                if !LocalStorage.shared.getBool(key: .isUserCheckedin) {
                    checkinAction()
                    
                }
                return
            }
        }
    
        

      
        
        CoreDataManager.shared.fetchEachDayPlan(byDate: self.selectedToday ?? Date()) {[weak self]  myDayPlans in
            guard let welf = self else {return}
            guard let myDayPlan =  myDayPlans.first else {
                welf.showAlertToNetworks(desc: "Shedule your work plan to add call", isToclearacalls: false)
                welf.setSegment(.workPlan)
                return
            }
            
            var workTypes : [WorkType] = []
            var selectedTerritories : [Territory] = []
            
            myDayPlan.eachPlan?.forEach({ eachPlan in
                guard let eachPlan = eachPlan as? EachPlan else {return}
                let wtCode = eachPlan.wortTypeCode ?? ""
                let workType = DBManager.shared.getWorkType()
                let filetedworkType = workType.filter{$0.code ==  wtCode}
                workTypes.append(contentsOf: filetedworkType)
                

                
                   let townCode = eachPlan.townCodes ?? ""
                   let territories =  DBManager.shared.getTerritory(mapID: eachPlan.rsfID ?? "")
                   let territoryCodes =   townCode.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                
                if territories.isEmpty {

                } else {
                    // Filter territories based on codes
                    let filteredTerritories = territories.filter { territory in
                        return territoryCodes.contains(territory.code ?? "")
                    }
                    // Extract names as a comma-separated string
                    selectedTerritories.append(contentsOf: filteredTerritories)
       
                }
                
            })

            guard  !workTypes.isEmpty else { 
                welf.showAlertToNetworks(desc: "Shedule your work plan to add call", isToclearacalls: false)
                welf.setSegment(.workPlan)
                return }
            let isFieldWork = workTypes.map { aWorkType in
                if aWorkType.fwFlg == "F" {
                    return true
                } else {
                    return false
                }
            }
            
            guard isFieldWork.contains(true) else   {
                welf.showAlertToNetworks(desc: "Field work plan is mandatory to add call.", isToclearacalls: false)
                return
            }
           
            let callVC = UIStoryboard.callVC
//            if let fetchedClusterObject1 = welf.fetchedClusterObject1 {
//                selectedTerritories.append(contentsOf: fetchedClusterObject1)
//            }
//            
//            if let fetchedClusterObject2 = welf.fetchedClusterObject2 {
//                selectedTerritories.append(contentsOf:fetchedClusterObject2)
//            }
            callVC.selectedTerritories = selectedTerritories
            
            welf.navigationController?.pushViewController(callVC, animated: true)
            
            
        }
    }

    @IBAction func todayCallSyncAction(_ sender: UIButton) {
        guard let selectedToday =  self.selectedToday else {
            showAlertToFilldates(description: "Please select date before syncing call")
            return
        }
        Shared.instance.showLoaderInWindow()
        toSetParams(date: selectedToday, isfromSyncCall: true) {
            self.refreshDashboard(date: selectedToday) {
                Shared.instance.removeLoaderInWindow()
            }
        }

    }

    @IBAction func notificationAction(_ sender: UIButton) {
        
        // checkinAction()
        
        fetchLocations { locationInfo in
            guard let locationInfo = locationInfo else {return}
            self.toCreateToast(locationInfo.address == "No address found" || locationInfo.address == ""  ? "Latitude: \(locationInfo.latitude), Longitude: \(locationInfo.longitude)" : locationInfo.address)
            Shared.instance.locationInfo = locationInfo
        }
    }

    func fetchLocations(completion: @escaping(LocationInfo?) -> ()) {
        Pipelines.shared.requestAuth(isFromLaunch: isFromLaunch) {[weak self] coordinates  in
            guard let welf = self else {
                completion(nil)
                return
            }
            
            if geoFencingEnabled {
                guard coordinates != nil else {
                    welf.showAlert(desc: "Please enable location services in Settings.")
                    completion(nil)
                    return
                }
            }

            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                Pipelines.shared.getAddressString(latitude: coordinates?.latitude ?? Double(), longitude:  coordinates?.longitude ?? Double()) {  address in
                    completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address: address ?? "No address found"))
                    return
                }
            } else {
                
                completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address:  "No address found"))
                return
            }
        }
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
        
        
        if findDateExistsinTPrange() {
            self.showAlertToFilldates(description: "Prepare your Tour Plan")
            return
        }
        
        toHighlightAddedCell()
        self.configureAddplanBtn(false)
        self.toLoadWorktypeTable()
        
        //(aSession)
    }


    @IBAction func sideMenuAction(_ sender: UIButton) {
        
        print("Tapped")
        let menuvc =   HomeSideMenuVC.initWithStory(self)
        menuvc.delegate = self
        menuvc.menuAlertDelegate = self
        self.modalPresentationStyle = .custom
        self.navigationController?.present(menuvc, animated: false)
        
    }


    @IBAction func dateAction(_ sender: UIButton) {
        
        
        if findDateExistsinTPrange() {
            self.showAlertToFilldates(description: "Prepare your Tour Plan")
            return
        }
        
     //  if !isSequentialDCRenabled {
            self.selectedSegment  = self.selectedSegment  != .calender ?   .calender :   segmentType[selectedSegmentsIndex]
            self.setSegment(self.selectedSegment)
       //     return
      //  }
        
        if isDayCheckinNeeded {
            if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                checkinAction()
                return
            }
        }
        

//            self.selectedSegment  = self.selectedSegment  != .calender ?   .calender :   segmentType[selectedSegmentsIndex]
//            self.setSegment(self.selectedSegment)
        
        
    }


    @IBAction func didTapSaveBtn(_ sender: Any) {
        
        if findDateExistsinTPrange() {
            self.showAlertToFilldates(description: "Prepare your Tour Plan")
            return
        }
        // Ensure you have sessions to save
       // if !isSequentialDCRenabled {
            guard self.selectedToday != nil else {
                showAlertToFilldates(description: "Please select date to submit work plan")
                return
            }
       // }
        
        if isDayCheckinNeeded {
            if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserCheckedin) {
                checkinAction()
                return
            }
        }
            //let isnotToSave = toHighlightAddedCell() ?? true
            
       
        
            guard var yetToSaveSession = self.sessions else {
                return
            }
            
            toCreateNewDayStatus()
            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                yetToSaveSession.indices.forEach { index in
                    yetToSaveSession[index].isRetrived = true
                    yetToSaveSession[index].planDate = self.selectedRawDate
                  //  yetToSaveSession[index].isSynced = true
                }
            } else {
                yetToSaveSession.indices.forEach { index in
                    if  yetToSaveSession[index].isRetrived == true {
                        yetToSaveSession[index].planDate =  selectedToday ?? Date()
                        yetToSaveSession[index].isSynced = true
                    } else {
                        yetToSaveSession[index].isRetrived = true
                        yetToSaveSession[index].planDate =  selectedToday ?? Date()
                        yetToSaveSession[index].isSynced = false
                    }
                }
            }
            
            
            
            updateEachDayPlan(isSynced: LocalStorage.shared.getBool(key: .isConnectedToNetwork), planDate:  selectedToday ?? Date(), yetToSaveSession: yetToSaveSession) { [weak self] _  in
                guard let welf = self else {return}
                guard var nonNilSession = welf.sessions else {
                    return
                }
  
   
                if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    welf.callSavePlanAPI(byDate: welf.selectedToday ?? Date(), istoupdateUI: true) { isUploaded in
                        if isUploaded {
                            welf.toConfigureMydayPlan(planDate: welf.selectedToday ?? Date()) {}
                            
                            LocalStorage.shared.setBool(LocalStorage.LocalValue.istoUploadDayplans, value: false)
                            
                        } else {
                            
                  
                            nonNilSession.indices.forEach { index in
                                nonNilSession[index].isRetrived = false
                                nonNilSession[index].planDate = welf.selectedToday ?? Date()
                            }
                            
                            welf.sessions = nonNilSession

                            welf.toConfigureMydayPlan(planDate: welf.selectedToday ?? Date()) {
                                
                             let isFWexists = !nonNilSession.filter { $0.workType?.fwFlg == "F" || $0.workType?.fwFlg ==  "A" }.isEmpty
                              if isFWexists {
                                    welf.setSegment(.calls)
                                }
                            }
                       
                        }
                        
                    }
                    
                } else {
                    LocalStorage.shared.setBool(LocalStorage.LocalValue.istoUploadDayplans, value: true)
                    nonNilSession.indices.forEach { index in
                        nonNilSession[index].isRetrived = true
                        nonNilSession[index].planDate = welf.selectedToday ?? Date()
                        
                    }
                    
                    welf.sessions = nonNilSession
  
                    welf.configureSaveplanBtn(welf.toEnableSaveBtn(sessionindex: welf.selectedSessionIndex ?? 0,  istoHandeleAddedSession: false))
                    
                    if nonNilSession.count == 2 {
                        welf.configureAddplanBtn(false)
                    } else {
                        welf.configureAddplanBtn(true)
                    }
                    
                    welf.toConfigureMydayPlan(planDate: welf.selectedToday ?? Date()) {
                        
                      let isFWexists = !nonNilSession.filter { $0.workType?.fwFlg == "F" || $0.workType?.fwFlg ==  "A" }.isEmpty
                      if isFWexists {
                            welf.setSegment(.calls)
                        }
                        
                    }
//                    if nonNilSession[0].workType?.fwFlg == "F" || nonNilSession[0].workType?.fwFlg ==  "A" {
//                        welf.setSegment(.calls)
//                    }
                    
                    welf.toCreateToast("You are not connected to internet")
                }

            }

    }
    
    func toCreateNewDayStatus() {
        CoreDataManager.shared.removeDayStatus(date: selectedToday ?? Date()) {[weak self] isRemoved in
            guard let welf = self else {return}
            CoreDataManager.shared.saveDayStatusToCoreData(date: welf.selectedToday ?? Date(), didUserWindup: false, isSynced: false, params: Data()) { _ in }
        }
        
    
    }

}

extension MainVC: MenuResponseProtocol {
    func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
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
                self.fetchedClusterObject1 = nil
            } else {
                self.fetchedWorkTypeObject2 = selectedObject as? WorkType
                self.sessions?[selectedSessionIndex ?? 0].workType = fetchedWorkTypeObject2
                self.fetchedClusterObject2 = nil
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
                
                guard let subordinateObj = selectedObject as? Subordinate else {return}
                let territories = DBManager.shared.getTerritory(mapID:  subordinateObj.id ?? "")
                
                if territories.isEmpty {
                    if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                        showAlertToFilldates(description: "Clusters not yet synced connect to internet to sync.")
                        return
                    }
                }
                
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
                    // let territories = DBManager.shared.getTerritory(mapID:  aHQobj.code)
                
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
        
        if view is NearMeVC  {
            let fieldWorkSession = sessions?.filter { $0.workType?.fwFlg == "F" }
            if fieldWorkSession?.count == 0 {
                showAlert(desc: "Field work is required to add tag")
                return
            }

    
            fetchLocations() { _ in
//                [weak self] coordinates in
//                guard (coordinates != nil) else {return}
               // self?.modalPresentationStyle = .fullScreen
              //  self?.navigationController?.pushViewController(view, animated: true)
                return
            }
            self.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(view, animated: true)
            return
        }
        
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}


extension MainVC : MasterSyncVCDelegate {
    func isHQModified(hqDidChanged: Bool) {
        
                if hqDidChanged {
                   // toConfigureMydayPlan(planDate: self.selectedToday ?? Date())
    
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
//        case self.analysisCollectionView:
//            return 4
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
                    
                case "Preview":
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
                if model.name == LocalStorage.shared.getString(key: .doctor) {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.doctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average \(LocalStorage.shared.getString(key: .doctor)) Calls"
                } else if model.name ==  LocalStorage.shared.getString(key: .chemist)  {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.chemist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average \(LocalStorage.shared.getString(key: .chemist)) Calls"
                } else if model.name ==  LocalStorage.shared.getString(key: .stockist)  {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.stockist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average \(LocalStorage.shared.getString(key: .stockist)) Calls"
                } else if model.name ==  LocalStorage.shared.getString(key: .unlistedDoctor)  {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.unlistedDoctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average \(LocalStorage.shared.getString(key: .unlistedDoctor)) Calls"
                }
                self.dcrCallsCollectionView.reloadData()
      
            }
            return cell
//        case self.analysisCollectionView:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
//            if indexPath.row != 0 {
//           
//                cell.imgArrow.isHidden = true
//            }
//
//            return cell
        case self.eventCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayPlanEventCell", for: indexPath) as! DayPlanEventCell

            cell.lblEvent.text = eventArr[indexPath.row]
            cell.lblEvent.textColor = colorArr[indexPath.row]
            cell.vxView.backgroundColor = colorArr[indexPath.row]

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

            return CGSize(width: collectionView.width / 3, height: collectionView.height)
        case self.quickLinkCollectionView :
            let width = self.quickLinkCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: 60)
            return size
        case self.dcrCallsCollectionView :
            let width = self.dcrCallsCollectionView.frame.width / 3
            let size = CGSize(width: width - 10, height: self.dcrCallsCollectionView.frame.height)
            return size
//        case self.analysisCollectionView :
//            let width = self.analysisCollectionView.frame.width / 3
//            let size = CGSize(width: width - 10, height: self.analysisCollectionView.frame.height)
//            return size
        case self.eventCollectionView:
          //  eventArr[indexPath.row]
            return CGSize(width:eventArr[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]).width + 20, height: collectionView.height / 5.5)

        default :
            return CGSize()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
            let plansModel = obj_sections[indexPath.section].myDayplans
            let date = obj_sections[indexPath.section].date
            let dayStatusCount = obj_sections[indexPath.section].dayStatus.count
            
           
           cell.isTohideDaySubmission = dayStatusCount == 0 ? true : false
           
            
         //   var custCodes: [String] = model.map { $0.custCode }
            cell.delegate = self
            cell.viewController = self
            cell.todayCallsModel = model
            cell.eventCaptureModel = eventModel
            cell.myDayPlans = plansModel
            let count = model.count
            cell.callsCountLbl.text = "\(count)"
            cell.eventCOuntLbl.text = "\(eventModel.count)"
            var firstPlan = ""
            var secondPlan = ""
            if !plansModel.isEmpty {
                plansModel.enumerated().forEach { index, aSession in
                    switch index {
                    case 0:
                        if let wtName = aSession.workType?.name  {
                            firstPlan = wtName
                        }
                    case 1:
                            if let wtName = aSession.workType?.name  {
                                secondPlan = wtName
                            }
                        
                    default:
                        print("Yet to")
                    }
                }
                if !secondPlan.isEmpty && secondPlan != firstPlan {
                    cell.workPlanTitLbl.text = "Work Plan - \(firstPlan), \(secondPlan)"
                } else {
                    cell.workPlanTitLbl.text = "Work Plan - \(firstPlan)"
                }
                cell.isTohideWorkPlan = false
            } else {
                cell.isTohideWorkPlan = true
            }


           
            cell.toLoadData()
            
            
            if  !obj_sections[indexPath.section].isCallExpanded {
                cell.toSetCallsCellHeight(callsExpandState:  .callsNotExpanded)
               
            }
            
            if  !obj_sections[indexPath.section].isEventEcpanded {
                cell.toSetEventsCellheight(callsExpandState:  .eventNotExpanded)
                
            }
            
            cell.workPlanRefreshView.addTap {[weak self] in
                guard let welf = self else {return}
                if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    welf.showAlertToFilldates(description: "Internet connection is required to sync Day plan.")
                    return
                }
                let dateString = date
                let rawDate = dateString.toDate(format: "yyyy-MM-dd")
                Shared.instance.showLoaderInWindow()
                welf.toPostDayplan(byDate: rawDate, istoupdateUI: welf.selectedDate != nil) {
                    welf.toLoadOutboxTable()
                    Shared.instance.removeLoaderInWindow()
                }
            }
            
            cell.callsRefreshVIew.addTap { [weak self] in
                guard let welf = self else {return}
                if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    welf.showAlertToFilldates(description: "Internet connection is required to sync calls.")
                    return
                }
                Shared.instance.showLoaderInWindow()
                let dcrCalls = obj_sections[indexPath.section].items
                let date = obj_sections[indexPath.section].date
                welf.toretryDCRupload(dcrCall: dcrCalls, date: date) {_ in
                    welf.toUploadUnsyncedImageByDate(date: date) {
                        Shared.instance.removeLoaderInWindow()
                        welf.showAlertToFilldates(description: "Sync completed")
                    }
                }
            }
            
            cell.eventRefreshView.addTap { [weak self] in
                guard let welf = self else {return}
                
                if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    welf.showAlertToFilldates(description: "Internet connection is required to sync calls.")
                    return
                }
                Shared.instance.showLoaderInWindow()
                welf.toUploadUnsyncedImageByDate(date: date) {
                    welf.toLoadOutboxTable()
                    Shared.instance.removeLoaderInWindow()
                    welf.showAlertToFilldates(description: "Sync completed")
                    
                }
            }
            
            cell.daySubmitRefreshView.addTap { [weak self] in
                guard let welf = self else {return}
                if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    welf.showAlertToFilldates(description: "Internet connection is required to sync calls.")
                    return
                }
                Shared.instance.showLoaderInWindow()
                welf.toUploadWindups(date: date.toDate(format: "yyyy-MM-dd")) { _ in
                    welf.toLoadOutboxTable()
                    Shared.instance.removeLoaderInWindow()
                    welf.showAlertToFilldates(description: "Sync completed")
                    
                }
            }
            
            cell.callsCollapseIV.addTap { [weak self] in
                guard let welf = self else {return}
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
                welf.outboxTableView.reloadData()
            }
            
            
            
            
            cell.eventCollapseIV.addTap { [weak self] in
                guard let welf = self else {return}
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
                welf.outboxTableView.reloadData()
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
                
            //    if !isSequentialDCRenabled {
                    if welf.selectedToday == nil {
                        
                        UIView.animate(withDuration: 1, delay: 0, animations: {
                            welf.viewDate.backgroundColor = .appLightPink
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            UIView.animate(withDuration: 1, delay: 0, animations: {
                                welf.viewDate.backgroundColor = .appWhiteColor
                               
                            })
                        }
                        
                        
                        
                        welf.showAlertToFilldates(description: "Please select date to Add Work type")
                        return
                    }
            //    }
                
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
            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                if let nonnillsession = self.sessions, nonnillsession.count > 1 {
                    if let workType = sessions?[1].workType  {
                        vc.selectedObject = workType
                    }
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
            //290 -  checkin - 50 || work plan - 50 || call detail - 50 || event cpature - 50 || check out - 50
            let callsCount = obj_sections[indexPath.section].items.count
            let eventsCount = obj_sections[indexPath.section].eventCaptures.count
            let plansCount = obj_sections[indexPath.section].myDayplans.count
            let dayStatusCount = obj_sections[indexPath.section].dayStatus.count
            
            let istohideCheckin: Bool = true
            let istohideCheckout: Bool = true
            
            var cellHeight : Int = 350
            if istohideCheckin {
                cellHeight = cellHeight - 50
            }
            
            if istohideCheckout {
                cellHeight = cellHeight - 50
            }
             
            if plansCount == 0 {
                cellHeight = cellHeight - 50
            }
            
            if dayStatusCount == 0 {
                cellHeight = cellHeight - 50
            }
        
            
            switch indexPath.section {

            default:
                if  obj_sections[indexPath.section].isCallExpanded == true  {
                    return CGFloat(cellHeight + 10 + (90 * callsCount))
                }
                if obj_sections[indexPath.section].isEventEcpanded == true {
                    return CGFloat(cellHeight + 10 + (90 * eventsCount))
                }
                else {
                    return CGFloat(cellHeight + 10)
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
            guard obj_sections.count > section else {return nil}
            if obj_sections[section].collapsed {
                header?.collapseIV.image = UIImage(named: "chevlon.expand")
            } else {
                header?.collapseIV.image = UIImage(named: "chevlon.collapse")
            }
            header?.refreshdelegate = self
            
     
            
            let dayPlan = obj_sections[section].myDayplans.first
            if let dayPlan = dayPlan {
                let formattedDate =  dayPlan.planDate?.toString(format: "MMMM dd, yyyy")
                header?.dateLbl.text = formattedDate
            } else {
                let object = obj_sections[section].items.first
                if let dateString = object?.vstTime, !dateString.isEmpty  {
                    let date = dateString.toDate()
                    let formattedDate = date.toString(format: "MMMM dd, yyyy")
                    print(formattedDate)  // Output: January 19, 2024
                    header?.dateLbl.text = formattedDate
                } else {
                    let dateStr = obj_sections[section].date
                    let date = dateStr.toDate(format: "yyyy-MM-dd")
                    let formattedDate = date.toString(format: "MMMM dd, yyyy")
                    header?.dateLbl.text = formattedDate
                }
            }
            

            header?.addTap {
                guard let header = header else {return}
                header.delegate?.toggleSection(header, section: header.section)
            }
            return header
            

            
        } else {
            
            return view
        }
    }
    

    
    
    

    
    struct callstatus {
        var status: String?
        var isCallSubmitted: Bool?
    }
    
    func sendAPIrequest(refreshDate: Date, _ param: [String: Any], paramData: JSON, completion: @escaping (callstatus) -> Void) {
  
     
        userststisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
        
            switch result {
              
            case .success(let response):
                print(response)
            
                dump(response)
                if response.isSuccess ?? false {
                    let callStatus = callstatus(status: response.msg ?? "", isCallSubmitted: response.isSuccess ?? false)
                    self.toRemoveOutboxandDefaultParams(refreshDate: refreshDate, param: paramData) { isRemoved in
                        completion(callStatus)
                    }
                  
                } else {
                    let callStatus = callstatus(status: response.msg ?? "", isCallSubmitted: response.isSuccess ?? false)
                    self.toCreateToast(response.msg ?? "Error uploading data try again later.")
                    self.toUpdateData(param: paramData, status: response.msg ?? "Yet to")
                    self.toRemoveFailedHomeDictResponse(param: paramData)
                    completion(callStatus)
                }
          
            case .failure(let error):
    
                
                print(error.localizedDescription)
                self.view.toCreateToast("Error uploading data try again later.")
                let callStatus = callstatus(status:  "Waiting to sync", isCallSubmitted: false)
                completion(callStatus)
          
                
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
        
       // dump(obj_sections)
        
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
        self.refreshUI(date: Shared.instance.selectedDate, issynced: true, segmentType[selectedSegmentsIndex]) {}
          
         
 
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
    

    
    

    
    
    
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        
        let collapsed = !obj_sections[section].collapsed
        obj_sections[section].collapsed = collapsed
        
        // Reload the whole section
        self.outboxTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    
    

}

extension MainVC : FSCalendarDelegate, FSCalendarDataSource ,FSCalendarDelegateAppearance {
    

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print(calendar.currentPage)
        dateInfoLbl.text = toTrimDate(date: calendar.currentPage , isForMainLabel: true)
       // self.selectedDate = ""
        //"\(values.month!) \(values.year!)"
        //
    }
    

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // let borderColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(60.0/255.0), alpha: CGFloat(0.25))
        let cell = calendar.dequeueReusableCell(withIdentifier: "MyDayPlanCalenderCell", for: date, at: position) as! MyDayPlanCalenderCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        cell.addedIV.backgroundColor = .clear
        //  let toCompareDate = dateFormatter.string(from: date)
        cell.addedIV.isHidden = false
        
        if date.toString(format: "yyyy-MM-dd") == "2024-08-11" {
            let model: HomeData? = toExtractWorkDetails(date: date)
            dump(model)
        }
        
        let model: HomeData? = toExtractWorkDetails(date: date)
        
        
        if model?.fw_Indicator ==  "F" {
            cell.addedIV.backgroundColor = .appGreen
            
        } else if  model?.fw_Indicator ==  "W" {
            cell.addedIV.backgroundColor = .appYellow
        
        } else if  model?.fw_Indicator ==  "N" {
            cell.addedIV.backgroundColor = .appBlue
       
        } else if  model?.fw_Indicator ==  "LAP" {
            cell.addedIV.backgroundColor = .appDeepBlue
          
        } else if  model?.fw_Indicator ==  "L" {
            cell.addedIV.backgroundColor = .appLightPink
           
        }   else if  model?.fw_Indicator ==  "H" {
            cell.addedIV.backgroundColor = .appViolet
           
        }  else if  model?.fw_Indicator ==  "M" {
            cell.addedIV.backgroundColor = .appLightGrey
          
        }  else if  model?.fw_Indicator ==  "R" {
            cell.addedIV.backgroundColor = .appDeepBrown
            
        }  else if  model?.fw_Indicator ==  "RE" {
            cell.addedIV.backgroundColor = .appPink
            
        }
        cell.customLabel.text = toTrimDate(date: date)
        cell.customLabel.textColor = .appTextColor
        cell.customLabel.setFont(font: .medium(size: .BODY))
        cell.customLabel.textColor = .appTextColor
        cell.titleLabel.isHidden = true
        cell.shapeLayer.isHidden = true
        
        cell.layer.borderColor = UIColor.appSelectionColor.cgColor
        cell.layer.borderWidth = 0.5
        
        
        if let selectedToday = self.selectedToday {
            if selectedToday.toString(format: "yyyy-MM-dd") ==  date.toString(format: "yyyy-MM-dd")  {
                cell.contentHolderView.backgroundColor = .appTextColor
                cell.customLabel.textColor = .appWhiteColor
            } else {
                cell.contentHolderView.backgroundColor = .clear
                cell.customLabel.textColor = .appLightTextColor
            }
        }  else {
            cell.contentHolderView.backgroundColor = .clear
            cell.customLabel.textColor = .appLightTextColor
        }

        
        
        cell.addTap { [weak self] in
           
            
            guard let welf = self else {return}
        
            let selectedDate = date.toString(format: "MMMM dd, yyyy")

            //isSequentialDCRenabled
            
            if welf.isFurureDate(date: date) {
                CoreDataManager.shared.fetchDcrDates { dcrDates in
                dump(dcrDates)
                }
                
                welf.showAlertToFilldates(description: "Day planing for future dates are restricted.")
                welf.setSegment(.workPlan)
                return
            }
            
                    if let notWindedups = welf.toReturnNotWindedupDate()  {
                     
                        if let notWindedupDays = notWindedups.statusDate {
                            if selectedDate != notWindedupDays.toString(format: "MMMM dd, yyyy") {
                                welf.showAlertToFilldates(description: "Kindly submit your status on \(notWindedupDays.toString(format: "MMMM dd, yyyy")) to change date.")
                                welf.setSegment(.workPlan)
                            } else {
                                welf.callDayPLanAPI(date: notWindedupDays, isFromDCRDates: true) {
                                    welf.toSetParams(date: notWindedupDays, isfromSyncCall: true) {
                                        CoreDataManager.shared.fetchDcrDates { dcrDates in
                                          let filteredDates = dcrDates.filter { $0.date ==  notWindedupDays.toString(format: "yyyy-MM-dd") }
                                            if let firstEntry = filteredDates.first {
                                                welf.refreshUI(date: notWindedupDays, rejectionReason: firstEntry.reason, SegmentType.workPlan) {
                                                  
                                                }
                                            } else {
                                                welf.refreshUI(date: notWindedupDays, SegmentType.workPlan) {
                                                  
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        
                            return
                        }

                    }
        
       
          
          
            ///Allow selection only from fetched dates from date Sync API
            CoreDataManager.shared.fetchDcrDates { savedDcrDates in
              
                
                let yetToModifiedDates =  savedDcrDates.filter { $0.date == date.toString(format: "yyyy-MM-dd") && $0.isDateAdded == false  &&  $0.flag == "0" || $0.flag == "1" || $0.flag == "2" || $0.flag == "3" || $0.flag == "1000" }
                
                guard !yetToModifiedDates.isEmpty else {
                    
                    welf.showAlertToFilldates(description: "you cant select \(selectedDate)")
                   // Shared.instance.removeLoaderInWindow()
                    return
                    
                }
               var reason : String?
               var isExists = Bool()
//                yetToModifiedDates.contains { aDcrDates in
//                   aDcrDates.date == date.toString(format: "yyyy-MM-dd") &&  !aDcrDates.isDateAdded
//            
//                }
                if let matchedDate = yetToModifiedDates.first(where: { $0.date == date.toString(format: "yyyy-MM-dd") && !$0.isDateAdded }) {
                    reason = matchedDate.reason == "" ? nil : matchedDate.reason
                    isExists = true
                    dump(matchedDate)
                } else {
                     isExists = false
                }
                
                if !isExists {
                 
                    welf.showAlertToFilldates(description: "you cant select \(selectedDate)")
                
                    return
                }

                let mergedDate =  welf.toMergeDate(selectedDate: date) ?? Date()
                welf.lblDate.text = mergedDate.toString(format: "MMMM d, yyyy")
                welf.validateWindups() {
                
                    welf.callDayPLanAPI(date: date, isFromDCRDates: true) {
                        welf.toSetParams(date: date, isfromSyncCall: true) {
                            welf.refreshUI(date: mergedDate, rejectionReason: reason, SegmentType.workPlan) {
                              
                            }
                        }
                    }
                    
                }
        
                return
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
            guard obj_sections.count > refreshIndex else {return}
            
            let refreshDateStr = obj_sections[refreshIndex].date
            let callitems = obj_sections[refreshIndex].items
            let refreshDate = obj_sections[refreshIndex].date.toDate(format: "yyyy-MM-dd")
            
            Shared.instance.showLoaderInWindow()
            toPostDayplan(byDate: refreshDate, istoupdateUI: false) { [weak self] in
                guard let welf = self else {return}
              
                welf.toretryDCRupload(dcrCall: callitems, date: refreshDateStr) { _  in
                    welf.toUploadUnsyncedImageByDate(date: refreshDateStr) {
                        welf.toUploadWindups(date: refreshDate) { _ in
                            welf.toLoadOutboxTable()
                           // welf.setSegment(.calls)
                            welf.masterVM?.fetchMasterData(type: .homeSetup, sfCode: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID), istoUpdateDCRlist: false, mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) {  _ in
                                welf.btnCalenderSync(welf.btnSyncDate!)
                                Shared.instance.removeLoaderInWindow()
                                welf.showAlertToFilldates(description: "Sync completed")
                            }
                            }
                    }
                }
                
            }

        } else {
            showAlertToFilldates(description: "Internet connection is required to sync calls.")
        }

    }
    
    func toUploadUnsyncedImageByDate(date: String,  custCode: String? = nil, completion: @escaping () -> ()) {
      
        CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventsArr in
            
            
            // Create a dispatch group to wait for all uploads to complete
            let dispatchGroup = DispatchGroup()
            
            var filteredunsyncedEventsArr = unsyncedEventsArr
            
            if let custCode = custCode {
                filteredunsyncedEventsArr =  unsyncedEventsArr.filter { $0.custCode == custCode }
            }
            
            filteredunsyncedEventsArr.forEach { unsyncedEvent in
                let captureDate = unsyncedEvent.eventcaptureDate
                if date == captureDate?.toString(format: "yyyy-MM-dd") {
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
                      
                        self.callSaveimageAPI(param: optionalParam ?? JSON(), paramData: yattoPostData ?? Data(), evencaptures: aEventCaptureViewModel, custCode: custCode, captureDate: captureDate ?? Date()) { result in
                                dispatchGroup.leave()
                            }

                    }
                }

            }
            
            // Notify the completion handler when all uploads are done
            dispatchGroup.notify(queue: .main) {
                
                completion()
            }
        }
    }
    
    func toUploadUnsyncedImage(custCode: String? = nil, completion: @escaping () -> ()) {
      
        CoreDataManager.shared.toRetriveEventcaptureCDM { unsyncedEventsArr in
            
            
            // Create a dispatch group to wait for all uploads to complete
            let dispatchGroup = DispatchGroup()
            
            var filteredunsyncedEventsArr = unsyncedEventsArr
            
            if let custCode = custCode {
                filteredunsyncedEventsArr =  unsyncedEventsArr.filter { $0.custCode == custCode }
            }
            
            filteredunsyncedEventsArr.forEach { unsyncedEvent in
                var eventCaptureVMs = [EventCaptureViewModel]()
                let yattoPostData = unsyncedEvent.eventCaptureParamData
                let eventCaptures = unsyncedEvent.capturedEvents
                let optionalParam = ObjectFormatter.shared.convertDataToJson(data: yattoPostData ?? Data())
                let captureDate = unsyncedEvent.eventcaptureDate
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
                  
                    self.callSaveimageAPI(param: optionalParam ?? JSON(), paramData: yattoPostData ?? Data(), evencaptures: aEventCaptureViewModel, custCode: custCode, captureDate: captureDate ?? Date()) { result in
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
//        if btnFinalSubmit.titleLabel?.text == "Check IN" {
//            checkinDetailsView?.setupUI(type: HomeCheckinDetailsView.ViewType.checkin)
//        } else {
//            checkinDetailsView?.setupUI(type: HomeCheckinDetailsView.ViewType.checkout)
//        }
        let diduserWindUP = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.didUserWindUP)
        checkinDetailsView?.setupUI(type: diduserWindUP ? HomeCheckinDetailsView.ViewType.checkout : HomeCheckinDetailsView.ViewType.checkin)
        view.addSubview(checkinDetailsView ?? HomeCheckinDetailsView())
        view.layoutIfNeeded()
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

        } else  if index == 0 {
            let aCall = self.todayCallsModel?[SelectedArrIndex] ?? TodayCallsModel()
           // didTapoutboxEdit(dcrCall: aCall)
            toCallEditAPI(dcrCall: aCall)
        } else {
         //   syncAllCalls()
        }
    }
    
    func logoutAction() {
        
        self.toCreateToast("logged out successfully")
        
        Pipelines.shared.doLogout()
        
    }
    
    func toSetupDeleteAlert(index: Int) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: "Are you sure to delete calls ", okAction: "Yes" , cancelAction: "No")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            
            self.toDeleteAddedDCRCall(index: index)
        }
        
        commonAlert.addAdditionalCancelAction {
            print("Yes action")
         
        
        }
    }
    
    func removeAllAddedCall(id: String, refreshDate: Date) {
        let fetchRequest: NSFetchRequest<AddedDCRCall> = AddedDCRCall.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "addedCallID == %@", id)

        do {
            let existingCalls = try context.fetch(fetchRequest)
            for call in existingCalls {
                let callDateString = call.callDate?.toString(format: "yyyy-MM-dd")
                let dcrCallDate = refreshDate
                let dcrCallDateString = dcrCallDate.toString(format: "yyyy-MM-dd")
                if callDateString == dcrCallDateString {
                    context.delete(call)
                }
                
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
                self.toSetParams(date: self.selectedToday ?? Date(), isfromSyncCall: true) {
                    self.refreshDashboard(date: Shared.instance.selectedDate) {
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
        
      
        self.isDayPlanRemarksadded = true
        self.dayRemarks = remarksStr
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
    
    
    func showAlertToNetworks(desc: String, isToclearacalls: Bool) {
        let commonAlert = CommonAlert()
       
        if isToclearacalls {
            commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok",cancelAction: "Cancel")
            commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                print("yes action")
                    self.clearAction()
            }
            commonAlert.addAdditionalCancelAction {
                print("no action")
            }
        } else {
            commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
            commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                print("yes action")
            }
            
            
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
        showAlertToNetworks(desc: desc, isToclearacalls: false)
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
                
                self.btnFinalSubmit.setTitle(isDayCheckinNeeded ?  "Final submit / Check OUT" : "Final submit", for: .normal)
                
                if checkinDetailsView?.viewType == .checkout {
                    
                    doUserWindupAPIcall {[weak self] _ in
                        guard let welf = self else {return}
                       
                        welf.configureFinalsubmit(true)
                        welf.configureAddCall(!LocalStorage.shared.getBool(key: LocalStorage.LocalValue.didUserWindUP))
                        welf.configureSaveplanBtn(false)
                        welf.configureAddplanBtn(false)
                        
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
                
            case checkinDetailsView:
                backgroundView.isHidden = false
    
                
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                checkinDetailsAction()
               
                
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



extension MainVC :  HomeSideMenuVCDelegate {
    func didMasterSync() {
       masterSyncAction(btnSync)
    }
    
    func didProfileTapped() {
        profileAction(btnProfile)
    }
    
    func didLocationUpdated() {
        notificationAction(btnNotification)
    }
    
    func refreshDashBoard() {
        print("Yet to refresh dashboard")
    }
    
    
}



extension MainVC: OutboxDetailsTVCDelegate {
    func didTapEventcaptureSync(event: UnsyncedEventCaptureModel) {
        guard let custCode = event.custCode else {return}
        Shared.instance.showLoaderInWindow()
        
        toUploadUnsyncedImage(custCode: custCode) { [weak self] in
            guard let welf = self else {return}
            Shared.instance.removeLoaderInWindow()
            welf.toLoadOutboxTable()
            welf.showAlertToFilldates(description: "captured Events synced sucessfully")
            
        }
    }
    
    struct callType {
        var call: AnyObject?
        var type: DCRType?
    }
    
    func toReturnCallType(dcrCall: TodayCallsModel) ->  callType? {
        var call: AnyObject?
        var type: DCRType?
        
        switch dcrCall.custType {
        case 1:
            let listedDocters = DBManager.shared.getDoctor()
            //mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
            let filteredDoctores = listedDocters.filter { aDoctorFencing in
                aDoctorFencing.code == dcrCall.custCode
            }
            guard let nonNilDoctors = filteredDoctores.first else {
                showAlertToFilldates(description: "Please try syncing Doctor list in mastersync")
                return nil
            }
            let aCallVM = CallViewModel(call: nonNilDoctors , type: DCRType.doctor)
            aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
            call = aCallVM
            type = DCRType.doctor
        case 2:
            let listedChemist = DBManager.shared.getChemist()
            //mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
            }
            guard let nonNilChemist = filteredChemist.first else {
                showAlertToFilldates(description: "Please try syncing Chemist list in mastersync")
                return nil}
            let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.chemist)
            aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
            call = aCallVM
            type = DCRType.doctor
        case 3:
            let listedChemist = DBManager.shared.getStockist()
            //mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
            }
            guard let nonNilChemist = filteredChemist.first else {
                
                return nil}
            let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.stockist)
            aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
            call = aCallVM
            type = DCRType.doctor
        case 4:
            let listedChemist = DBManager.shared.getUnListedDoctor()
            //mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
            }
            guard let nonNilChemist = filteredChemist.first else {
                showAlertToFilldates(description: "Please try syncing Unlisted doctor list in mastersync")
                return nil}
            let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.unlistedDoctor)
            aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
            call = aCallVM
            type = DCRType.doctor
        default:
            print("Yet to")
        }
        return callType(call: call, type: type)
    }
    
    func didTapOutboxSync(dcrCall: TodayCallsModel,  syncCode: String?) {
        print("Yet to sync")
        
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            showAlert(desc: "Internet connection is required to sync calls.")
            return
        }

       let callType = toReturnCallType(dcrCall: dcrCall)
        
        let call: AnyObject? = callType?.call
        let type: DCRType? = callType?.type
        
        guard let call = call, let type = type else {
            Shared.instance.showLoaderInWindow()
            toUploadUnsyncedImage(custCode: syncCode ?? dcrCall.custCode) {
                
                self.toSetupOutBoxDataSource(isSynced: true) {
                    Shared.instance.removeLoaderInWindow()
                }
            }
            return
        }
        dcrCallObjectParser.toReturnModelobjects(call: call, type: type) {[weak self]  outboxModel in
            guard let welf = self else {return}
            welf.dcrCallObjectParser.dcrCall = call as? CallViewModel
            welf.dcrCallObjectParser.toSetDCRParam(outboxModel: outboxModel) { json in
                guard let json = json else {
                    return }
                var param: [String: Any] = [:]
                param["CustCode"] = dcrCall.custCode
                let callDate = dcrCall.vstTime.toDate()
                Shared.instance.showLoaderInWindow()
                welf.toSendParamsToAPISerially(refreshDate: callDate, index: 0, items: [json]) { _ in
                    welf.toUploadUnsyncedImage(custCode: syncCode ?? dcrCall.custCode) {
                        welf.toCreateToast("Sync completed")
                        Shared.instance.removeLoaderInWindow()
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
    func didTapOutboxDelete(dcrCall: TodayCallsModel) {

        self.showAlertToClearCall(dcrCall: dcrCall)

        
    }
    

    func showAlertToClearCall(dcrCall: TodayCallsModel) {
        
        var param: [String: Any] = [:]
        param["CustCode"] = dcrCall.custCode
        let callDate = dcrCall.vstTime.toDate()
        
        var calltype: String = ""
        switch dcrCall.custType {
        case 1:
            calltype = "Dcoctor"
        case 2:
            calltype = "Chemist"
        case 3:
            calltype = "Stockist"
        case 4:
            calltype = "Unlisted Doctor"
        default:
            print("Yet to")
        }
        
        let desc = "Are yot sure want to remove added \(calltype) (\(dcrCall.name)) call on \(callDate.toString(format: "MMMM dd, yyyy")) from outbox?"
        
        let commonAlert = CommonAlert()
            commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok",cancelAction: "Cancel")
            commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                print("yes action")
                self.clearOutboxCall(dcrCall: dcrCall)
            }
            commonAlert.addAdditionalCancelAction {
                print("no action")
            }
      
    }
    
    func clearOutboxCall(dcrCall: TodayCallsModel) {
        
        
          var param: [String: Any] = [:]
          param["CustCode"] = dcrCall.custCode
          let callDate = dcrCall.vstTime.toDate()
          
          var calltype: String = ""
          switch dcrCall.custType {
          case 1:
              calltype = "Dcoctor"
          case 2:
              calltype = "Chemist"
          case 3:
              calltype = "Stockist"
          case 4:
              calltype = "Unlisted Doctor"
          default:
              print("Yet to")
          }
        
        self.toRemoveOutboxandDefaultParams(refreshDate: callDate, param: param) { isRemoved in
            CoreDataManager.shared.removeUnsyncedEventCaptures(date: callDate, withCustCode: dcrCall.custCode) { _  in
                CoreDataManager.shared.removeDayStatus(date: callDate) { _ in
                    self.showAlertToFilldates(description: "Added \(calltype) (\(dcrCall.name)) call on \(callDate.toString(format: "MMMM dd, yyyy")) removed from outbox successfully")
                }
                self.toLoadOutboxTable()
                _ =  self.istoRedirecttoCheckin()
            }
        }
    }
    

    
    func didTapoutboxEdit(dcrCall: TodayCallsModel) {
        print("Tapped")
        
        var filteredSection: Section?
        var diduserWindup : Bool = false
        for section in obj_sections {
            // Filter items within the section
            let filteredItems = section.items.filter { $0.custCode == dcrCall.custCode && $0.vstTime == dcrCall.vstTime }

            // Check if there are any matching items
            if !filteredItems.isEmpty {
                filteredSection = section
                break
            }
        }
        
        
        
    guard let filteredSection = filteredSection else {return}
       for dayStatus in filteredSection.dayStatus{
            if dayStatus.didUserWindup {
                diduserWindup = true
                break
            }
        }
        
        guard !diduserWindup else {
            
            self.showAlertToFilldates(description: "You cannot edit calls for submitted day")
            return }
        
        switch dcrCall.custType {
        case 1:
            let listedDocters = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            let filteredDoctores = listedDocters.filter { aDoctorFencing in
                 aDoctorFencing.code == dcrCall.custCode
             }
             guard let nonNilDoctors = filteredDoctores.first else {

             return}
             let aCallVM = CallViewModel(call: nonNilDoctors , type: DCRType.doctor)
             aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
             editDCRcall(call: aCallVM, type: DCRType.doctor)
        case 2:
            let listedChemist = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
             }
             guard let nonNilChemist = filteredChemist.first else {

             return}
             let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.chemist)
             aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
             editDCRcall(call: aCallVM, type: DCRType.chemist)
        case 3:
            let listedChemist = DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
             }
             guard let nonNilChemist = filteredChemist.first else {

             return}
             let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.stockist)
             aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
             editDCRcall(call: aCallVM, type: DCRType.stockist)
        case 4:
            let listedChemist = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            let filteredChemist = listedChemist.filter { chemist  in
                chemist.code == dcrCall.custCode
             }
             guard let nonNilChemist = filteredChemist.first else {

             return}
             let aCallVM = CallViewModel(call: nonNilChemist , type: DCRType.unlistedDoctor)
             aCallVM.dcrDate = dcrCall.submissionDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
             editDCRcall(call: aCallVM, type: DCRType.unlistedDoctor)
        default:
            print("Yet to")
        }

    }
    
    
}

extension MainVC:  MenuAlertProtocols {
    
    func clearAllSlideDatas() {
        Shared.instance.showLoaderInWindow()
        CoreDataManager.shared.removeAllSlides{  isRemoved in
         
            Shared.instance.iscelliterating = false
            Shared.instance.isSlideDownloading = false
            
            LocalStorage.shared.setSting(LocalStorage.LocalValue.slideDownloadIndex, text: "0")
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: false)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesLoaded, value: false)
            LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesRemoved, value: isRemoved)
            
            CoreDataManager.shared.removeAllSavedSlides()
            CoreDataManager.shared.removeAllGeneralGroupedSlides()
            CoreDataManager.shared.removeAllGroupedSlides()
            CoreDataManager.shared.removeAllPresentations()
             
                DispatchQueue.main.async {
                    Shared.instance.removeLoaderInWindow()
            }
        }
        
    }
    
    func showAlertToClearSlides(desc: String) {
        let commonAlert = CommonAlert()
       
            commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok",cancelAction: "Cancel")
            commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                print("yes action")
                    self.clearAllSlideDatas()
            }
            commonAlert.addAdditionalCancelAction {
                print("no action")
            }
        
    }
    
    func addAlert(_ type: AlertTypes) {
        switch type {
        case .clearSlides:
            self.showAlertToClearSlides(desc: "Are you sure about clearing all saved slides?")
            
        case .notConnected:
            self.showAlert(desc: "Please connect to internet.")
        }
    }
    
    
}
