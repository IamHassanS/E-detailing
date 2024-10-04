//
//  UserStatisticsVIew.swift
//  E-Detailing
//
//  Created by San eforce on 14/02/24.
//

import Foundation
import UIKit
import FSCalendar
import CoreData





class UserStatisticsVIew: BaseView {
    
    var segmentType: [SegmentType] = []
    
    enum SegmentType : String {
        case workPlan = "Work plan"
        case calls = "Calls"
        case outbox = "Outbox"
    }
    
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
    
 
    var userStatisticsVC :  UserStatisticsVC!
    ///Common
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet var navigationView: UIView!
    
    @IBOutlet var contentsHolderView: UIView!
    
    @IBOutlet var contentStack: UIStackView!
   
    @IBOutlet var showMenuView: UIView!
    @IBOutlet var homeTitleLbl: UILabel!
 
    
    
    //Left pane
    @IBOutlet var viewPlans: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewWorkPlan: UIView!
  //  @IBOutlet weak var viewCalls: UIView!
  //  @IBOutlet weak var viewOutBox: UIView!
    
    
    
    //Day plan
    ///calender
    @IBOutlet var selectDateLbl: UILabel!
    
    @IBOutlet var calenderIcon: UIImageView!
    
    
    
    //Left segment
    @IBOutlet var segmentsCollection: UICollectionView!
    @IBOutlet var worktypeTable: UITableView!
   
    @IBOutlet weak var outboxTableView: UITableView!
    
    ///outbox
    
    @IBOutlet var outboxInfoView: UIView!
    @IBOutlet var outboxSegmentHolderView: UIView!
  //  @IBOutlet var outboxCallsCountLabel: UILabel!
    @IBOutlet var outboxTableHolder: UIView!
  //  @IBOutlet var outboxCountVIew: UIView!
    @IBOutlet var outBoxClearCallsHolder: UIView!
    @IBOutlet var clearCallsBtn: UIButton!
    
    /// Calls
    @IBOutlet var callsSegmentHolderVIew: UIView!
    ///
    @IBOutlet weak var callTableView: UITableView!
 
    @IBOutlet var callsInfoView: UIView!
    @IBOutlet var callsCountLbl: UILabel!
    @IBOutlet weak var btnSyncCall: UIButton!
   
    

    

    
    
    
    //right pane
    @IBOutlet weak var viewAnalysis: UIView!
    @IBOutlet var prevNextIV: UIImageView!
    
    
    
    @IBOutlet var monthRangeLbl: UILabel!
    @IBOutlet var lblAverageDocCalls: UILabel!
    @IBOutlet weak var lblAnalysisName: UILabel!
    @IBOutlet weak var lblWorkType: UILabel!
    @IBOutlet weak var lblHeadquarter: UILabel!
    @IBOutlet weak var lblCluster: UILabel!
    
  //  @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtViewRemarks: UITextView!
    
   
    
    @IBOutlet weak var btnNotification: UIButton!
  
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnActivity: UIButton!
    
    
    @IBOutlet weak var segmentControlForDcr: UISegmentedControl!
    @IBOutlet weak var segmentControlForAnalysis: UISegmentedControl!
    
    @IBOutlet weak var salesStackView: UIStackView!
    @IBOutlet weak var callStackView: UIStackView!
    @IBOutlet weak var slideStackView: UIStackView!
    
    // views
    
 
  
 
    @IBOutlet weak var viewQuickLinks: UIView!
    
  

    
    
    @IBOutlet weak var viewDayPlanStatus: UIView!
    
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var viewWorkType: UIView!
    @IBOutlet weak var viewHeadquarter: UIView!
    @IBOutlet weak var viewCluster: UIView!
    
    
    @IBOutlet weak var viewRemarks: UIView!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    
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
    

    
    
    @IBOutlet weak var quickLinkCollectionView: UICollectionView!
    @IBOutlet weak var dcrCallsCollectionView: UICollectionView!
    @IBOutlet weak var analysisCollectionView: UICollectionView!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    


    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var callsCellHeight = 400 + 10 // + 10 padding
    var homeLineChartView : HomeLineChartView?
    var chartType: ChartType = .doctor
    var cacheDCRindex: Int = 0
    var doctorArr = [HomeData]()
    var chemistArr = [HomeData]()
    var stockistArr = [HomeData]()
    var unlistedDocArr = [HomeData]()
    var cipArr = [HomeData]()
    var hospitalArr = [HomeData]()
    var  homeDataArr = [HomeData]()
    var outBoxDataArr : [TodayCallsModel]?
    var todayCallsModel: [TodayCallsModel]?
    var totalFWCount: Int = 0
    var cacheINdex: Int = 0
    var selectedCallIndex: Int = 0
    var sessionResponseVM : SessionResponseVM?
    var selectedSegmentsIndex: Int = 0
    //MARK: - life cycle
    override func didLoad(baseVC: BaseViewController) {
        self.userStatisticsVC = baseVC as? UserStatisticsVC
        setupUI()
       
    }
    
    
    func toLoadSegments() {
        segmentsCollection.delegate = self
        segmentsCollection.dataSource = self
        segmentsCollection.reloadData()
    }
    
    func toIntegrateChartView(_ type: ChartType, _ index: Int) {
        
        self.lineChatrtView.subviews.forEach { aAddedView in
            aAddedView.removeFromSuperview()
        }
        
        let ahomeLineChartView = HomeLineChartView()
        ahomeLineChartView.delegate = self
        ahomeLineChartView.allListArr = homeDataArr
        ahomeLineChartView.dcrCount = self.userStatisticsVC.dcrCount[index]
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
        
        
        ahomeLineChartView.viewController = self.userStatisticsVC
        
        self.homeLineChartView = ahomeLineChartView
        
        
        lineChatrtView?.addSubview(homeLineChartView ?? HomeLineChartView())
        
    }
    
    
    func toSetupAlert() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Please do try syncing All slides!.", okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            print("no action")
        }
    }
    
    func setupCalls(response: [TodayCallsModel]) {
        callsCountLbl.text = "Call Count: 0\(response.count)"
        toloadCallsTable()
    }
    
    func toloadCallsTable() {
        callTableView.delegate = self
        callTableView.dataSource = self
        callTableView.reloadData()
    }
    
    private enum Constants {
        static let spacing: CGFloat = 1
    }
    
    
    func toLoadOutboxTable() {
        toSetupOutBoxDataSource()
        outboxTableView.delegate = self
        outboxTableView.dataSource = self
        outboxTableView.reloadData()
    }
    

    func toLoadWorktypeTable() {
        worktypeTable.delegate = self
        worktypeTable.dataSource = self
        worktypeTable.reloadData()
    }
    
    
    func toSetupOutBoxDataSource() {
        
        self.outBoxDataArr?.removeAll()
        
        let outBoxDataArr =  self.homeDataArr.filter { aHomeData in
            aHomeData.isDataSentToAPI == "0"
        }
        
//        if !outBoxDataArr.isEmpty {
//            outboxCountVIew.isHidden = false
//
//            outboxCallsCountLabel.text = "\(outBoxDataArr.count)"
//        } else {
//            outboxCountVIew.isHidden = true
//        }
        
        
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
            toDdayCall.designation = type == 1 ? "Doctor" : type == 2 ? "Chemist" : type == 3 ? "Stockist" : type == 4 ? "hospital" : type == 5 ? "cip" : type == 6 ? "UnlistedDr." : ""
            self.outBoxDataArr?.append(toDdayCall)
        }
        toSeperateOutboxSections(outboxArr: self.outBoxDataArr ?? [TodayCallsModel]())
        if self.outBoxDataArr?.count ?? 0 == 0 {
            toConfigureClearCalls(istoEnable: false)
        } else {
            toConfigureClearCalls(istoEnable: true)
        }
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
    
    func toSeperateOutboxSections(outboxArr : [TodayCallsModel]) {
        // Dictionary to store arrays of TodayCallsModel for each day
        var callsByDay: [String: [TodayCallsModel]] = [:]
        
        // Create a DateFormatter to parse the vstTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Iterate through the array and organize elements by day
        for call in outboxArr {
            if let date = dateFormatter.date(from: call.vstTime) {
                let dayString = dateFormatter.string(from: date)
                
                // Check if the day key exists in the dictionary
                if callsByDay[dayString] == nil {
                    callsByDay[dayString] = [call]
                } else {
                    callsByDay[dayString]?.append(call)
                }
            }
        }
        obj_sections.removeAll()
        // Iterate through callsByDay and create Section objects
        for (day, calls) in callsByDay {
            let section = Section(items: calls, date: day)
            obj_sections.append(section)
        }
        
        
    }
    
    
    func setupUI() {
        segmentType = [.workPlan, .calls, .outbox]
        toLoadSegments()
        navigationView.backgroundColor = .appTextColor
      //  outboxCountVIew.isHidden = true
       // outboxCallsCountLabel.setFont(font: .medium(size: .BODY))
      //  outboxCallsCountLabel.textColor = .appWhiteColor
      //  outboxCountVIew.layer.cornerRadius = outboxCountVIew.height / 2
      //  outboxCountVIew.backgroundColor = .appTextColor
        clearCallsBtn.layer.cornerRadius = 5
        clearCallsBtn.backgroundColor = .appTextColor
        clearCallsBtn.titleLabel?.textColor = .appWhiteColor
        
        
       // outboxCallsCountLbl.setFont(font: .medium(size: .BODY))
      //  outboxCallsCountLbl.textColor = .appTextColor
        
      //  viewCalls.layer.cornerRadius = 5
       // viewCalls.backgroundColor = .appWhiteColor
        selectDateLbl.setFont(font: .bold(size: .SUBHEADER))
        btnCall.layer.borderColor = UIColor.appSelectionColor.cgColor
        btnCall.layer.borderWidth = 0.5
        btnCall.tintColor = .appTextColor
        btnCall?.layer.cornerRadius = 5
        btnCall.backgroundColor = .appGreyColor
        btnActivity.layer.borderColor = UIColor.appSelectionColor.cgColor
        btnActivity.layer.borderWidth = 0.5
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
                showMenuView.addTap {
                    print("Tapped")
                    let menuvc =   HomeSideMenuVC.initWithStory(self)
                    self.userStatisticsVC.modalPresentationStyle = .custom
                    self.userStatisticsVC.navigationController?.present(menuvc, animated: false)
                }
//        quickLinkTitle.setFont(font: .bold(size: .SUBHEADER))
//        monthRangeLbl.setFont(font: .medium(size: .BODY))
//        lblAverageDocCalls.setFont(font: .bold(size: .SUBHEADER))
//        lblAnalysisName.setFont(font: .bold(size: .SUBHEADER))
//        //toSeperateDCR()
//        chartHolderView.layer.cornerRadius = 5
//        chartHolderView.backgroundColor = .appWhiteColor
//        // self.toIntegrateChartView(.doctor, 0)
//        month1View.layer.cornerRadius = 5
//        month2View.layer.cornerRadius = 5
//        month3View.layer.cornerRadius = 5
//
//        //  month3View.isHidden = true
//        // month2View.isHidden = true
//        month1VXview.backgroundColor = .appSelectionColor
//        month2VXview.backgroundColor = .appSelectionColor
//        month3VXview.backgroundColor = .appSelectionColor
//
//        month1Lbl.setFont(font: .bold(size: .BODY))
//        month2Lbl.setFont(font: .bold(size: .BODY))
//        month3Lbl.setFont(font: .bold(size: .BODY))
        
        
        cellregistration()
        setSegment(.workPlan)
        
 
    }
    
    func cellregistration() {
       // self.quickLinkCollectionView.register(UINib(nibName: "QuickLinkCell", bundle: nil), forCellWithReuseIdentifier: "QuickLinkCell")
        
    //    self.dcrCallsCollectionView.register(UINib(nibName: "DCRCallAnalysisCell", bundle: nil), forCellWithReuseIdentifier: "DCRCallAnalysisCell")
        
       // self.analysisCollectionView.register(UINib(nibName: "AnalysisCell", bundle: nil), forCellWithReuseIdentifier: "AnalysisCell")
        

        self.callTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "DCRCallCell", bundle: nil), forCellReuseIdentifier: "DCRCallCell")
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forCellReuseIdentifier: "outboxCollapseTVC")
        
        
        self.outboxTableView.register(UINib(nibName: "outboxCollapseTVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "outboxCollapseTVC")
        
        self.outboxTableView.register(UINib(nibName: "OutboxDetailsTVC", bundle: nil), forCellReuseIdentifier: "OutboxDetailsTVC")
        
        
        self.worktypeTable.register(UINib(nibName: "HomeWorktypeTVC", bundle: nil), forCellReuseIdentifier: "HomeWorktypeTVC")
        
        
        self.segmentsCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
    
        
    }
    
}

extension UserStatisticsVIew : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.outboxTableView {
            
            print("riigjroo  \(obj_sections.count)")
            return obj_sections.count
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if tableView == self.outboxTableView {
        //            return obj_sections[section].collapsed ? 0 : obj_sections[section].items.count
        //        }
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
            return 3
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
                let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 3, height: 90), on: cell.optionsBtn, onframe: CGRect(), pagetype: .calls)
                // vc.delegate = self
                //  vc.selectedIndex = indexPath.row
                self.userStatisticsVC.navigationController?.present(vc, animated: true)
            }
            return cell
        case self.outboxTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutboxDetailsTVC", for: indexPath) as! OutboxDetailsTVC
            let model = obj_sections[indexPath.section].items
            cell.todayCallsModel = model
            //[indexPath.row]
            //self.outBoxDataArr
            let count = model.count
            //self.outBoxDataArr?.count ?? 0
            cell.callsCountLbl.text = "\(count)"
            cell.toLoadData()
            
            if  !obj_sections[indexPath.section].isCallExpanded {
                cell.toSetCellHeight(callsExpandState:  .callsNotExpanded)
            }
            
            
            cell.callsCollapseIV.addTap {
                cell.callsExpandState =  cell.callsExpandState == .callsNotExpanded ? .callsExpanded : .callsNotExpanded
                // cell.callsCollapseIV.image = cell.callsExpandState == .callsNotExpanded ? UIImage(named: "chevlon.expand") : UIImage(named: "chevlon.collapse")
                
                if cell.callsExpandState == .callsExpanded {
                    obj_sections[indexPath.section].isCallExpanded = true
                    
                    //                    cell.cellStackHeightConst.constant = CGFloat(290 + 90 * count)
                    //                    cell.callSubDetailVIew.isHidden = false
                    //                    cell.callSubdetailHeightConst.constant = 90 * 2
                    //                    cell.callDetailStackHeightConst.constant = CGFloat(50 + 90 * count)
                    //                    cell.callsHolderViewHeightConst.constant = CGFloat(50 + 90 * count)
                    //                    cell.callsViewSeperator.isHidden = false
                } else {
                    obj_sections[indexPath.section].isCallExpanded = false
                    
                    //                    cell.cellStackHeightConst.constant = 290
                    //                    cell.callSubDetailVIew.isHidden = true
                    //                    cell.callSubdetailHeightConst.constant = 0 //90
                    //                    cell.callsHolderViewHeightConst.constant = 50
                    //                    cell.callDetailStackHeightConst.constant = 50
                    //                    cell.callsViewSeperator.isHidden = true
                }
                cell.toSetCellHeight(callsExpandState:  cell.callsExpandState)
                self.outboxTableView.reloadData()
            }
            
            // cell.imgProfile.backgroundColor = UIColor.random()
            cell.selectionStyle = .none
            return cell
            
        case worktypeTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWorktypeTVC", for: indexPath) as! HomeWorktypeTVC
            cell.selectionStyle = .none
            return cell
            
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return UITableView.automaticDimension
        
        if tableView == self.outboxTableView {
            let count = obj_sections[indexPath.section].items.count
            //self.outBoxDataArr?.count ?? 0
            switch indexPath.section {
            default:
                if  obj_sections[indexPath.section].isCallExpanded == true {
                    return CGFloat(290 + 10 + (90 * count))
                } else {
                    return 290 + 10
                }
            }
            
            
        } else if tableView == self.callTableView {
            return 75
        } else if tableView == self.worktypeTable {
            return 60
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
            

            
            let dateString = obj_sections[section].date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMMM dd, yyyy"
                
                let formattedDate = outputFormatter.string(from: date)
                print(formattedDate)  // Output: January 19, 2024
                header?.dateLbl.text = formattedDate
            } else {
                print("Error parsing date")
            }
            
            
            
            return header
            
        } else {
            
            return view
        }
    }
}

extension UserStatisticsVIew : CollapsibleTableViewHeaderDelegate {
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
        //.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}

extension UserStatisticsVIew : outboxCollapseTVCDelegate {
    func didTapRefresh(_ refreshIndex: Int) {
        
        let isConnected = LocalStorage.shared.getBool(key: .isConnectedToNetwork)
        //  obj_sections[section].isLoading = true
        if isConnected {
            self.userStatisticsVC.toretryDCRupload(date: obj_sections[refreshIndex].date) {_ in }
        } else {
            self.toCreateToast("Please connect to internet and try again later.")
        }
        
        // header?.refreshBtn.isUserInteractionEnabled = false
        // header?.refreshBtn.alpha = 0.5
    }
    
    
}

extension UserStatisticsVIew : collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.segmentsCollection:
            return segmentType.count
        case self.quickLinkCollectionView :
            return self.userStatisticsVC.links.count
        case self.dcrCallsCollectionView:
            return self.userStatisticsVC.dcrCount.count
        case self.analysisCollectionView:
            return 4
        case self.eventCollectionView:
            return self.userStatisticsVC.eventArr.count
        default:
            return 0
        }
    }
    func setSegment(_ segmentType: SegmentType) {
        switch segmentType {
            
        case .workPlan:
            viewWorkPlan.isHidden = false
            outboxSegmentHolderView.isHidden = true
            callsSegmentHolderVIew.isHidden = true
         toLoadWorktypeTable()
        case .calls:
            callsSegmentHolderVIew.isHidden = false
            outboxSegmentHolderView.isHidden = true
            viewWorkPlan.isHidden = true
            toloadCallsTable()
        case .outbox:
            outboxSegmentHolderView.isHidden = false
            viewWorkPlan.isHidden = true
            callsSegmentHolderVIew.isHidden = true
            toLoadOutboxTable()
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
                }
                

   
                }
            
            
            return cell
            
            
        case self.quickLinkCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickLinkCell", for: indexPath) as! QuickLinkCell
            cell.link = self.userStatisticsVC.links[indexPath.row]
            
            cell.addTap {
                switch cell.link.name {
                case "Presentaion":
                    
                    if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isSlidesLoaded) {
                        let vc =  PresentationHomeVC.initWithStory()
                        self.userStatisticsVC.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.toSetupAlert()
                    }
                    
                case "Slide Preview":
                    let vc = PreviewHomeVC.initWithStory()
                    self.userStatisticsVC.navigationController?.pushViewController(vc, animated: true)
                default:
                    print("Yet to implement")
                }
            }
            
            return cell
        case self.dcrCallsCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRCallAnalysisCell", for: indexPath) as! DCRCallAnalysisCell
            cell.imgArrow.isHidden = true
            let model =  self.userStatisticsVC.dcrCount[indexPath.row]
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
                let model = self.userStatisticsVC.dcrCount[indexPath.row]
                self.cacheDCRindex = indexPath.row
                self.selectedCallIndex = indexPath.row
                if model.name == "Doctor Calls" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.doctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Doctor Calls"
                } else if model.name == "Chemist Calls" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.chemist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Chemist Calls"
                } else if model.name == "Stockist Calls" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.stockist, indexPath.row)
                    self.lblAverageDocCalls.text = "Average Stockist Calls"
                } else if model.name == "UnListed Doctor Calls" {
                    self.chartType = .doctor
                    self.toIntegrateChartView(.unlistedDoctor, indexPath.row)
                    self.lblAverageDocCalls.text = "Average UnListed Doctor Calls"
                }
                self.dcrCallsCollectionView.reloadData()

            }
            return cell
        case self.analysisCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalysisCell", for: indexPath) as! AnalysisCell
//            if indexPath.row != 0 {
//                cell.viewAnalysis.backgroundColor = color
//                cell.imgArrow.isHidden = true
//            }
            return cell
        case self.eventCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayPlanEventCell", for: indexPath) as! DayPlanEventCell
            cell.lblEvent.text = userStatisticsVC.eventArr[indexPath.row]
            cell.lblEvent.textColor = ColorArray[indexPath.row]
            cell.viewEvent.backgroundColor = ColorArrayForBackground[indexPath.row]
            
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
//            let width = self.analysisCollectionView.frame.width / 3
//            let size = CGSize(width: width - 10, height: self.analysisCollectionView.frame.height)
//            return size
            return CGSize()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension UserStatisticsVIew : HomeLineChartViewDelegate
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

extension UserStatisticsVIew: MenuResponseProtocol {
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject) {
        print("Yet to implement")
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("")
    }
    func routeToView(_ view : UIViewController) {
        self.userStatisticsVC.modalPresentationStyle = .fullScreen
        self.userStatisticsVC.navigationController?.pushViewController(view, animated: true)
    }
    
}
