//
//  DayReportView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import Foundation
import UIKit
import CoreData
extension  DayReportView: DayReportsSortViewDelegate {
    func userDidSort(sorted index: Int?) {
        self.selectedSortIndex = index
        hideAddedViews()
        guard let index = index else {return}
        switch index {
        case 0:
            toReorderRepotes(type: .orderAscending)
        case 1:
            toReorderRepotes(type: .orderDescending)
        case 2:
            toReorderRepotes(type: .orderByDateAscending)
        case 3:
            toReorderRepotes(type: .orderByDateDesending)
        default:
            print("Yet to sort")
        }
    
    }
    
    func userDidCancel() {
        hideAddedViews()
    }
    
    func hideAddedViews() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case dayReportsSortView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
               
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    
}

class DayReportView: BaseView {
    
    var viewDayReportVC : ViewDayReportVC!
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var pageTitleLbl: UILabel!
    @IBOutlet weak var backHolderView: UIView!
    @IBOutlet weak var filtersHolderView: UIView!
    @IBOutlet weak var searchHolderVIew: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var ussrNameLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var rejectedSeperatorView: UIView!
    @IBOutlet weak var rejectedView: UIView!
    @IBOutlet weak var rejectedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rejectedTitLbl: UILabel!
    @IBOutlet weak var rejectedReasonLbl: UILabel!
    @IBOutlet weak var aDayReportsTable: UITableView!
    var selectedType: CellType = .Doctor
    @IBOutlet var tableHeader: UIView!
    @IBOutlet var tableContentsHolder: UIView!
    @IBOutlet var sortView: UIView!
    @IBOutlet var resultInfoLbl: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var clearView: UIView!
    
    @IBOutlet var clearIV: UIImageView!
    @IBOutlet var resultinfoView: UIView!
    var isForViewmore = false
    var isForRCPA = false
    var rejectedHeight: CGFloat =  70
    var detailedReportsModelArr : [DetailedReportsModel]?
    var filtereddetailedReportsModelArr : [DetailedReportsModel]?
    var filteredSelectedIndex: Int? = nil
    var selectedIndex: Int? = nil
    var reportsModel : ReportsModel?
    var isTohideCount : Bool = false
    var isMatched: Bool = false
    var selectedSortIndex: Int? = nil
    var dayReportsSortView: DayReportsSortView?
    var isSortPresented = false
    var checkinVIew: CustomerCheckinView?
    var eventsResponse : [EventResponse]?
    var downloadingIndex: Int?
    private lazy var sortPopupView: SortVIew = {
        let customView = SortVIew(frame: CGRect(x: (self.width / 2) - (self.width / 3) / 2, y: (self.height / 2) - 150, width: self.width / 3, height: 300))
        customView.isFromDayReport = true
        customView.delegate = self
        return customView
    }()
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.viewDayReportVC = baseVC as? ViewDayReportVC
        self.viewDayReportVC.appdefaultSetup = AppDefaults.shared.getAppSetUp()
        self.viewDayReportVC.toSetParamsAndGetResponse(1)
        setupUI()
    }
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.viewDayReportVC = baseVC as? ViewDayReportVC
        
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        let changePasswordViewwidth = self.bounds.width / 2.7
        let changePasswordViewheight = self.bounds.height / 1.7
        
        let changePasswordViewcenterX = self.bounds.midX - (changePasswordViewwidth / 2)
        let changePasswordViewcenterY = self.bounds.midY - (changePasswordViewheight / 2)
        
        self.dayReportsSortView?.frame = CGRect(x: changePasswordViewcenterX, y: changePasswordViewcenterY, width: changePasswordViewwidth, height: changePasswordViewheight)
        
        let checkinVIewwidth = self.bounds.width / 3.5
        let checkinVIewheight = self.bounds.height / 2
        
        let checkinVIewcenterX = self.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = self.bounds.midY - (checkinVIewheight / 2)

        checkinVIew?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
    }

    
    func initialSerups() {
        resultinfoView.isHidden = true
        resultInfoLbl.isHidden = true
        cellregistration()
        toLoadData()
    }
    
    func setupUI() {
        pageTitleLbl.setFont(font: .bold(size: .BODY))
        pageTitleLbl.text = "Day Report ( \(self.viewDayReportVC.dcrDate) )"
        clearIV.tintColor = .appTextColor
        backgroundView.isHidden = true
        resultinfoView.isHidden = isMatched ? false : true
        resultInfoLbl.isHidden = isMatched ? false : true
        resultInfoLbl.setFont(font: .medium(size: .BODY))
        resultInfoLbl.textColor = .appLightTextColor
        searchTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        searchTF.delegate = self
        self.aDayReportsTable.tableHeaderView = tableHeader
        seperatorView.backgroundColor = .appSelectionColor
        ussrNameLbl.setFont(font: .bold(size: .SUBHEADER))
        ussrNameLbl.textColor = .appLightPink
        self.ussrNameLbl.text = "\(viewDayReportVC.appdefaultSetup!.sfName!)"
            // - \(viewDayReportVC.appdefaultSetup!.desig!)
        initTaps()
        mockData()
        sortView.layer.cornerRadius = 5
        tableContentsHolder.layer.cornerRadius = 5
        tableContentsHolder.backgroundColor = .appWhiteColor
        searchHolderVIew.backgroundColor = .appWhiteColor
        searchHolderVIew.layer.cornerRadius = 5
        self.backgroundColor = .appGreyColor
        aDayReportsTable.separatorStyle = .none
    }
    
    
    func toShowSortOptions() {
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
   
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case dayReportsSortView:
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
        
        dayReportsSortView = self.viewDayReportVC.loadCustomView(nibname: XIBs.dayReportsSortView) as? DayReportsSortView
        dayReportsSortView?.delegate = self
        dayReportsSortView?.selectedIndex = selectedSortIndex
        dayReportsSortView?.isFromDayReport = true
        dayReportsSortView?.setupUI()
    

        self.addSubview(dayReportsSortView ?? DayReportsSortView())
    }
    
    
    func initTaps() {
        backHolderView.addTap {
            self.viewDayReportVC.navigationController?.popViewController(animated: true)
        }
        
        backgroundView.addTap {
            self.hideAddedViews()
        }
        
        sortView.addTap {
            
            self.toShowSortOptions()

        }
        
        clearView.addTap {
            self.toFilterResults("")
            self.searchTF.text = ""
            self.searchTF.placeholder = "Search"
        }
    }
    
    func cellregistration() {
        aDayReportsTable.register(UINib(nibName: "VisitsCountTVC", bundle:nil), forCellReuseIdentifier: "VisitsCountTVC")
        aDayReportsTable.register(UINib(nibName: "VisitInfoTVC", bundle:nil), forCellReuseIdentifier: "VisitInfoTVC")
      //  aDayReportsTable.register(UINib(nibName: "WTsheetTVC", bundle:nil), forCellReuseIdentifier: "WTsheetTVC")
        
        aDayReportsTable.register(UINib(nibName: "ListedWorkTypesTVC", bundle:nil), forCellReuseIdentifier: "ListedWorkTypesTVC")
        
        aDayReportsTable.register(UINib(nibName: "ViewAllInfoTVC", bundle:nil), forCellReuseIdentifier: "ViewAllInfoTVC")
    }
    
    func toLoadData() {
      
        aDayReportsTable.delegate = self
        aDayReportsTable.dataSource = self
        aDayReportsTable.reloadData()
    }
    
    func mockData() {
//        let count = 2
//        var detailedModelArr = [DetailedReportsModel]()
//        for _ in 0...count - 1 {
//            let anElement = DetailedReportsModel()
//            detailedModelArr.append(anElement)
//        }
        
       // self.detailedReportsModelArr = viewDayReportVC.d
        
        self.rejectedView.isHidden = true
        self.rejectedView.frame.size.height = 0
        self.aDayReportsTable.tableHeaderView?.frame.size.height = 50
        self.reportsModel = viewDayReportVC.reportsModel
       
        var  count : Int = 0
        count =  self.reportsModel!.chm +  self.reportsModel!.hos + self.reportsModel!.stk + self.reportsModel!.drs + self.reportsModel!.udr + self.reportsModel!.cip
        if count == 0 {
            isTohideCount = true
        }
        
    }
    
    

    
    func viewImageAction(events: [EventResponse]) {
        
    
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
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
        
        checkinVIew = self.viewDayReportVC.loadCustomView(nibname: XIBs.customerCheckinVIew) as? CustomerCheckinView
        checkinVIew?.delegate = self
     //   checkinVIew?.setupTaggeImage(fetchedImageData: imageData)
        checkinVIew?.setupTaggedImages(fetchedImageData: events)
        self.addSubview(checkinVIew ?? CustomerCheckinView())
        
    }
    
    
}

extension DayReportView: VisitsCountTVCDelegate {
    func typeChanged(index: Int, type: CellType) {
        Shared.instance.selectedDCRtype = type
        guard self.selectedType != type else {
            return
        }
        
        if index != 0 {
            
            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                self.viewDayReportVC.toSetParamsAndGetResponse(index)
            } else {
                self.toCreateToast("Please connect to internet.")
            }
            
           
        }
//        self.filtereddetailedReportsModelArr?.forEach({ detailedReportsModel in
//            detailedReportsModel.isCellExtended = false
//        })
//        self.detailedReportsModelArr?.forEach({ detailedReportsModel in
//            detailedReportsModel.isCellExtended = false
//        })
        
        self.isMatched = false
        self.searchTF.text = ""
        self.searchTF.placeholder = "Search"
        self.selectedType = type
    }
    
    
}

extension DayReportView : ViewAllInfoTVCDelegate {
    func didRCPACommentsTapped(view: UIView, comments: String) {
        
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 7), on: view,  pagetype: .hover)

        vc.color = .appTextColor
        vc.comments = comments
        self.viewDayReportVC?.navigationController?.present(vc, animated: true)
    }
    
    func didRCPAinfoTapped(view: UIView, model: RCPAresonseModel) {
        print("Tapped -->")
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 7), on: view,  pagetype: .RCPA)

        vc.color = .appTextColor
        vc.rcpaInfo = model
 
        self.viewDayReportVC?.navigationController?.present(vc, animated: true)
    }
    
    func didDurationInfoTapped(view: UIView, startTime: String, endTime: String) {
        print("Tapped -->")
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 4 , height: self.height / 7.5), on: view,  pagetype: .timeLine)

        vc.color = .appTextColor
        vc.startTime = "Start Time : \(startTime)"
     
        vc.endTime = "End Time : \(endTime)"
       
        self.viewDayReportVC?.navigationController?.present(vc, animated: true)
    }
    
    func didRCPAtapped(isrcpaTapped: Bool, index: Int, responsecount: Int) {

        
        if self.isMatched {
            filteredSelectedIndex = index
            self.filtereddetailedReportsModelArr?[index].isEventsExtended = false
            self.filtereddetailedReportsModelArr?[index].isSlidesExtended = false
            self.filtereddetailedReportsModelArr?[index].isRCPAExtended = isrcpaTapped
            self.filtereddetailedReportsModelArr?[index].rcpaCount = responsecount
        } else {
            self.selectedIndex = index
            self.detailedReportsModelArr?[index].isRCPAExtended = isrcpaTapped
            self.detailedReportsModelArr?[index].isEventsExtended = false
            self.detailedReportsModelArr?[index].isSlidesExtended = false
            self.detailedReportsModelArr?[index].rcpaCount = responsecount
        }
        self.toLoadData()
        
    }
    
    func didEventstapped(isEventstapped: Bool, index: Int, response : [EventResponse]) {
        print("Yet to")
        self.eventsResponse = response
       // let prefixURL = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageDownloadURL)
       // let modifiedUrlString = prefixURL.replacingOccurrences(of: "photos/", with: "")

        guard let eventsResponse = self.eventsResponse else {return}
        self.detailedReportsModelArr?[index].isRCPAExtended = false
        self.detailedReportsModelArr?[index].isEventsExtended = false
        self.detailedReportsModelArr?[index].isSlidesExtended = false
        
        self.toLoadData()
        
        self.viewImageAction(events: eventsResponse)


    }
    
    func didSlidestapped(isSlidestapped: Bool, index: Int, responsecount: Int) {
        if self.isMatched {
            filteredSelectedIndex = index
            self.filtereddetailedReportsModelArr?[index].isEventsExtended = false
            self.filtereddetailedReportsModelArr?[index].isSlidesExtended = isSlidestapped
            self.filtereddetailedReportsModelArr?[index].isRCPAExtended = false
            self.filtereddetailedReportsModelArr?[index].slidesCount = responsecount
            self.detailedReportsModelArr?[index].rcpaCount = Int()
        } else {
            self.selectedIndex = index
            self.detailedReportsModelArr?[index].isRCPAExtended = false
            self.detailedReportsModelArr?[index].isEventsExtended = false
            self.detailedReportsModelArr?[index].isSlidesExtended = isSlidestapped
            self.detailedReportsModelArr?[index].slidesCount = responsecount
            self.detailedReportsModelArr?[index].rcpaCount = Int()
        }
        self.toLoadData()
        
    }
    

    
    func didLessTapped(islessTapped: Bool, index: Int) {
        
        if isMatched {
            filteredSelectedIndex = index
        } else {
            self.selectedIndex = index
        }
        
     
        let model = self.isMatched ? self.filtereddetailedReportsModelArr?[filteredSelectedIndex ?? 0] : self.detailedReportsModelArr?[selectedIndex ?? 0]
     
   
        
        if islessTapped {
            model?.isCellExtended = false
            model?.isRCPAExtended = false
        } else {
            model?.isCellExtended = !islessTapped
            model?.isRCPAExtended = false
            model?.isEventsExtended = false
            model?.isSlidesExtended = false
        }
        
    
     
        self.toLoadData()
    }
    
    
    
    
}
extension DayReportView: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
           
            if self.reportsModel?.halfDayFWType != "" {
                return 2
            } else {
                return 1
            }
        case 1:
            if self.isTohideCount {
                return 0
            } else {
                return 1
            }
           
        case 2:
            return   self.isMatched ? self.filtereddetailedReportsModelArr?.count ?? 0 : self.detailedReportsModelArr?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
//            let cell: WTsheetTVC = tableView.dequeueReusableCell(withIdentifier: "WTsheetTVC", for: indexPath) as! WTsheetTVC
//            return cell
            let cell: ListedWorkTypesTVC = tableView.dequeueReusableCell(withIdentifier: "ListedWorkTypesTVC", for: indexPath) as! ListedWorkTypesTVC
            cell.wtModel = self.reportsModel
            cell.toloadData()
            cell.selectionStyle = .none
            return cell
            
            
        case 1:
            let cell: VisitsCountTVC = tableView.dequeueReusableCell(withIdentifier: "VisitsCountTVC", for: indexPath) as! VisitsCountTVC
            cell.delegate = self
           
//            var selectionDict = [CellType : Bool]()
//            let celltype: CellType = .Doctor
//            selectionDict[celltype] = true
//            cell.selectedIndex = selectionDict
            cell.wtModel = self.reportsModel
            cell.topopulateCell(model: self.reportsModel ?? ReportsModel())
            cell.selectionStyle = .none
            return cell
        case 2:
            let model =   self.isMatched ? self.filtereddetailedReportsModelArr?[indexPath.row] : self.detailedReportsModelArr?[indexPath.row]
         
            if model?.isCellExtended == false  {
                let cell: VisitInfoTVC = tableView.dequeueReusableCell(withIdentifier: "VisitInfoTVC", for: indexPath) as! VisitInfoTVC
                cell.selectionStyle = .none
                cell.elevationView.elevate(5)
                cell.elevationView.layer.cornerRadius = 5
                
                cell.userTypeIV.image = self.selectedType.image
                cell.toPopulateCell(model: model ?? DetailedReportsModel())
                
                cell.viewMoreDesc.addTap {
                    print("Tapped")
                    model?.isCellExtended = true
                    if self.isMatched {
                        self.filteredSelectedIndex = indexPath.row
                    } else {
                        self.selectedIndex = indexPath.row
                    }
                   
                   // self.isForViewmore = true
                    self.toLoadData()
                }
                return cell
            } else {
                let cell: ViewAllInfoTVC = tableView.dequeueReusableCell(withIdentifier: "ViewAllInfoTVC", for: indexPath) as! ViewAllInfoTVC
                cell.reportsVM = self.viewDayReportVC.reportsVM
                cell.selectedIndex = self.isMatched ? self.filteredSelectedIndex : self.selectedIndex
                cell.delegate = self
                cell.typeImage = self.selectedType.image
               //let model = self.detailedReportsModelArr?[indexPath.row]
                cell.detailedReportModel = model
                cell.cellRCPAType = model?.isRCPAExtended ?? false ? .showRCPA : .hideRCPA
                cell.cellSlidesType = model?.isSlidesExtended ?? false ? .showSlides : .hideSlides
                cell.reportModel = self.reportsModel
                cell.toSetDataSourceForProducts()
                cell.toSetDataSourceForInputs()
                cell.hideLocationSection()
                cell.toLoadData()
                cell.selectionStyle = .none
                return cell
            }

            

            
        default:
            return UITableViewCell()
        }
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // this will turn on `masksToBounds` just before showing the cell
//        cell.contentView.layer.masksToBounds = true
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.reportsModel?.halfDayFWType != "" {
                return 200 / 2
            } else {
                return 200 / 3
            }
        case 1:
           
            return tableView.height / 9
        default:
            let model =  self.isMatched ? self.filtereddetailedReportsModelArr?[indexPath.row] : self.detailedReportsModelArr?[indexPath.row]
            
            if model?.isCellExtended == false {
               return  240
            }
            else if  model?.isCellExtended == true {

                
                var timeinfoHeight = CGFloat()
                 if self.viewDayReportVC.isToReduceLocationHeight {
                     timeinfoHeight = 0
                 } else {
                     timeinfoHeight = 100
                 }
                
                var rcpaSectionHeight : CGFloat = 0
                var rcpaHeaderHeight: CGFloat = 0
                switch Shared.instance.selectedDCRtype {
                case .Doctor:
                    if isDoctorRCPAneeded {
                        rcpaHeaderHeight = 60
                        if model?.isRCPAExtended ?? false  {
                            rcpaSectionHeight = CGFloat((model?.rcpaCount ?? 0) * 40)
                        }
                    }
                case .Chemist:
                    if isChemistRCPAneeded {
                        rcpaHeaderHeight = 60
                        if model?.isRCPAExtended ?? false  {
                            rcpaSectionHeight = CGFloat((model?.rcpaCount ?? 0) * 40)
                        }
                    }
                case .UnlistedDoctor:
                    if isUnListedDoctorRCPAneeded {
                        rcpaHeaderHeight = 60
                        if model?.isRCPAExtended ?? false  {
                            rcpaSectionHeight = CGFloat((model?.rcpaCount ?? 0) * 40)
                        }
                    }
                default:
                    rcpaSectionHeight = 0
                }

                var slidesSectionHeight: CGFloat = 0
                var slideHeaderHeight: CGFloat = 0
                switch Shared.instance.selectedDCRtype {
                case .Doctor:
                    if isDoctorDetailingNeeded {
                        slideHeaderHeight = 60
                        if model?.isSlidesExtended ?? false  {
                            slidesSectionHeight = CGFloat((model?.slidesCount ?? 0) * 40)
                        }
                    }
                case .Chemist:
                    if isChemistDetailingNeeded{
                        slideHeaderHeight = 60
                        if model?.isSlidesExtended ?? false  {
                            slidesSectionHeight = CGFloat((model?.slidesCount ?? 0) * 40)
                        }
                    }
    
                case .UnlistedDoctor:
                    if isUnListedDoctorDetailingNeeded {
                        slideHeaderHeight = 60
                        if model?.isSlidesExtended ?? false  {
                            slidesSectionHeight = CGFloat((model?.slidesCount ?? 0) * 40)
                        }
                    }
                default:
                    slideHeaderHeight = 0
                    rcpaSectionHeight = 0
                }
                
                var eventsHeaderHeight: CGFloat = 0
                switch Shared.instance.selectedDCRtype {
                case .Doctor:
                    if isDoctorEventCaptureNeeded {
                        eventsHeaderHeight = 60
                   
                    }
                case .Chemist:
                    if isChemistEventCaptureNeeded{
                        eventsHeaderHeight = 60
                       
                    }
                case .Stockist:
                    if isStockistEventCaptureNeeded {
                        eventsHeaderHeight = 60
                    }
                case .UnlistedDoctor:
                    if isUnListedDoctorEventCaptureNeeded {
                        eventsHeaderHeight = 60
                 
                    }
                default:
                    eventsHeaderHeight = 0
                }
                
                
//                if model?.isSlidesExtended ?? false  {
//                    slidesSectionHeight = CGFloat((model?.slidesCount ?? 0) * 40)
//                }
                //25 elevation padding, 60 header height (product)
                 
                 
                // (170 - visit info, 100 - Time info, product title header - 60, products cell - 40, input title Header - 60, input cell - 40 Each, RCPA header - 60 , Each RCPA cell - 40, Remarks - 75, show options - 50, 20 - cache)
               let productCellHeight = toCalculateProductsHeight(index: indexPath.row)
                let inputCellHeight = toCalculateInputHeight(index: indexPath.row)
                return 170 + timeinfoHeight + 40 + productCellHeight + 40 + inputCellHeight + rcpaHeaderHeight + rcpaSectionHeight + slideHeaderHeight + slidesSectionHeight + eventsHeaderHeight + 75 + 50 
     
            }  else {
                return CGFloat()
            }
            
        }
    }
    
    func toCalculateProductsHeight(index : Int) -> CGFloat {
        let eachCellSize : Int = 40
        var productStrArr : [String] = []
        productStrArr.removeAll()
        productStrArr.append("This is Title String")
        if self.detailedReportsModelArr?[index].products != "" {
            productStrArr.append(contentsOf: self.detailedReportsModelArr?[index].products.components(separatedBy: ",") ?? [])
            if productStrArr.last ==  "  )" {
                productStrArr.removeLast()
            }
        }
        productStrArr = productStrArr.filter { !$0.isEmpty }
        switch productStrArr.count  {
            
        case 1:
            return CGFloat(eachCellSize * 2)
        default:
            return CGFloat(productStrArr.count * eachCellSize)
        }
    }
    
    func toCalculateInputHeight(index : Int) -> CGFloat {
        let eachCellSize : Int = 40
        var productStrArr : [String] = []
        productStrArr.removeAll()
        productStrArr.append("This is Title String")
        if self.detailedReportsModelArr?[index].gifts != "" {
            productStrArr.append(contentsOf: self.detailedReportsModelArr?[index].gifts.components(separatedBy: ",") ?? [])
            if productStrArr.last ==  "  )" {
                productStrArr.removeLast()
            }
        }
        productStrArr = productStrArr.filter { !$0.isEmpty }
        switch productStrArr.count  {

        case 1:
            return CGFloat(eachCellSize * 2)

        default:
            return CGFloat(productStrArr.count * eachCellSize)
        }
        
      
    }
    
}

extension DayReportView:UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle the text change
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            toFilterResults(newText)
            
           
        }
        return true
    }
    
    func toFilterResults(_ toSearchString: String) {
        
        let newText = toSearchString
        self.filtereddetailedReportsModelArr = [DetailedReportsModel]()
        detailedReportsModelArr?.forEach({ report in
            
            if report.name.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            else if report.visitTime.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.modTime.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.territory.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if "\(report.pobValue)".lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.callFdback.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.wWith.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.remarks.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            
            else if report.remarks.lowercased().contains(newText) {
                self.filtereddetailedReportsModelArr?.append(report)
            }
            

            
        })
        
        if newText.isEmpty {
            isMatched = false
            resultinfoView.isHidden = true
            resultInfoLbl.isHidden = true
          //  self.noreportsView.isHidden = true
            self.aDayReportsTable.isHidden = false
            self.toLoadData()
            
        }
     
        else if filtereddetailedReportsModelArr?.count != 0 {
            isMatched = true
            resultinfoView.isHidden = false
            resultInfoLbl.isHidden = false
          //  self.noreportsView.isHidden = true
            self.aDayReportsTable.isHidden = false
            self.toLoadData()
            
        } else if filtereddetailedReportsModelArr?.count == 0 && !newText.isEmpty  {
             isMatched = false
            resultinfoView.isHidden = false
            resultInfoLbl.isHidden = false
            self.aDayReportsTable.isHidden = true
           // self.noreportsView.isHidden = false
        }

        let resultCount = filtereddetailedReportsModelArr?.count ?? 0
        var resultStr = ""
        if resultCount == 0 {
            resultStr = "No results found"
        } else if resultCount == 1 {
            resultStr = "found \(resultCount) result"
        } else {
            resultStr = "found \(resultCount) results"
        }
        resultInfoLbl.text = resultStr
     //   dump(filteredreportsModel)
    }
}

extension DayReportView: SortVIewDelegate {
    
    enum SortingType {
        case orderAscending
        case orderDescending
        case orderByDateAscending
        case orderByDateDesending
    }
    
    func didSelected(index: Int?, isTosave: Bool) {
        selectedSortIndex = index
        isSortPresented =  isSortPresented ? false : true
        //addOrRemoveSort(isSortPresented)
        switch index {
        case 0:
            toReorderRepotes(type: .orderAscending)
        case 1:
            toReorderRepotes(type: .orderDescending)
        case 2:
            toReorderRepotes(type: .orderByDateAscending)
        case 3:
            toReorderRepotes(type: .orderByDateDesending)
  
        case .none:
            print("Yet to")
        case .some(_):
            print("Yet to")
        }
    }
    
    
    func toReorderRepotes(type: SortingType) {
        switch type {
            
        case .orderAscending:
          
            if isMatched {
                self.filtereddetailedReportsModelArr = self.filtereddetailedReportsModelArr?.sorted { $0.name < $1.name }
                
            } else {
                
                self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name < $1.name }
            }
            self.toLoadData()
        case .orderDescending:
            if isMatched {
                self.filtereddetailedReportsModelArr = self.filtereddetailedReportsModelArr?.sorted { $0.name > $1.name }
                
            } else {
                self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name > $1.name }
            }
            self.toLoadData()
        case .orderByDateAscending:
            print("Yet to implement")
            if isMatched {
                self.filtereddetailedReportsModelArr = self.filtereddetailedReportsModelArr?.sorted {
                  let date1 = toCOnvertTimeTodate($0.visitTime)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.visitTime) // Handle invalid time strings
                    return date1 < date2
                    
                }
                  
            } else {
             //   self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name < $1.name }
                
                
                self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted {
                  let date1 = toCOnvertTimeTodate($0.visitTime)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.visitTime) // Handle invalid time strings
                    return date1 < date2
                    
                }
                
            }
            self.toLoadData()
        case .orderByDateDesending:
            print("Yet to implement")
            if isMatched {
                self.filtereddetailedReportsModelArr = self.filtereddetailedReportsModelArr?.sorted {
                  let date1 = toCOnvertTimeTodate($0.visitTime)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.visitTime) // Handle invalid time strings
                    return date1 > date2
                    
                }
                  
            } else {
             //   self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted { $0.name < $1.name }
                
                
                self.detailedReportsModelArr = self.detailedReportsModelArr?.sorted {
                  let date1 = toCOnvertTimeTodate($0.visitTime)
                                                                                                               
                    let date2 = toCOnvertTimeTodate($1.visitTime) // Handle invalid time strings
                    return date1 > date2
                    
                }
                
            }
            self.toLoadData()
        }
    }

    func toCOnvertTimeTodate(_ time: String) -> Date {
        let timeString = time

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"

        if let date = dateFormatter.date(from: timeString) {
            print(date)
            return date
        } else {
            print("Invalid time string format")
        }
        return Date()
    }
    
//    func addOrRemoveSort(_ isToAdd: Bool) {
//        let views: [UIView] = [self.aDayReportsTable, self.searchHolderVIew, clearView]
//        if isToAdd {
//            views.forEach { aView in
//                aView.alpha = 1
//                aView.isUserInteractionEnabled = true
//                
//                self.sortPopupView.removeFromSuperview()
//            }
//        } else {
//            views.forEach { aView in
//                aView.alpha = 0.3
//                aView.isUserInteractionEnabled = false
//                self.sortPopupView.selectedIndex = selectedSortIndex
//                self.sortPopupView.isFromDayReport = true
//                self.sortPopupView.toLoadData()
//                self.addSubview(self.sortPopupView)
//            }
//        }
//    }
}
extension DayReportView : addedSubViewsDelegate {
    func didClose() {
       backgroundView.isHidden = true
        backgroundView.alpha = 0.3
        self.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    func didUpdate() {
        print("Yet to implement")
    }
    
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    func showAlert(desc: String) {
        print("Yet to implement")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("Yet to implement")
    }
    
    
}

