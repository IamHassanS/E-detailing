//
//  ReportsView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import Foundation
import UIKit
import CoreData

extension ReportsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportInfoArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ReportTypesCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportTypesCVC", for: indexPath) as!  ReportTypesCVC
        if let modal = reportInfoArr?[indexPath.row]  {

            cell.setupUI(type: reporsVC.pageType, modal: modal)
    
        }
   
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            switch welf.reporsVC.pageType  {
                
            case .reports:
                if indexPath.row == 0 {
                    let vc = DetailedReportVC.initWithStory()
                    welf.reporsVC.navigationController?.pushViewController(vc, animated: true)
                }
            case .approvals:
                switch welf.reportInfoArr?[indexPath.row].name {
                case "DCR Approvals":
                    
                    if welf.approvalsCountModel?.apprCount[0].leaveapprCount == "0" {
                        welf.showAlert(desc: "Leave Approvals not Available")
                        return
                    }
                    
                    let vc = DCRapprovalVC.initWithStory()
                    welf.reporsVC.navigationController?.pushViewController(vc, animated: true)
                    
                case "Leave Approvals":
                    let vc = LeaveApprovalVC.initWithStory()
                    welf.reporsVC.navigationController?.pushViewController(vc, animated: true)
                    print("Yet to")
                default:
                    let vc = TourPlanApprovalVC.initWithStory()
                    welf.reporsVC.navigationController?.pushViewController(vc, animated: true)
                    print("Yet to")
               
                }
            case .myResource:
                
                if let modal = welf.reportInfoArr?[indexPath.row]  {

                    switch modal.name {
                    case "Holiday / Weekly off":
                       
                        let precallvc = PreCallVC.initWithStory(pageType: .Fundays)
                        self?.reporsVC .navigationController?.pushViewController(precallvc, animated: true)
                        
                    default:
                        
                        let vc = SpecifiedMenuVC.initWithStory(nil, celltype: welf.toRetriveCellType(name: modal.name) ?? .listedDoctor)
                        welf.reporsVC.modalPresentationStyle = .custom
                        welf.reporsVC.navigationController?.present(vc, animated: false)
                    }
             
            
                }
                
      
            }
            
 
            
     
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 4, height: collectionView.height / 6)
    }
    
    func toRetriveCellType(name: String) -> MenuView.CellType? {
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.listedDoctor.rawValue {
            return MenuView.CellType.doctorInfo
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.chemist.rawValue {
            return MenuView.CellType.chemistInfo
        }
        
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.stockist.rawValue {
            return MenuView.CellType.stockistInfo
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.unlistedDoctor.rawValue {
            return MenuView.CellType.unlistedDoctorinfo
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.inputs.rawValue {
            return MenuView.CellType.inputs
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.product.rawValue {
            return MenuView.CellType.product
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.clusterInfo.rawValue {
            return MenuView.CellType.clusterInfo
        }
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.doctorVisit.rawValue {
            return MenuView.CellType.doctorVisit
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.holiday.rawValue {
            return MenuView.CellType.holiday
        }
        
        if MenuView.CellType(rawValue: name)?.rawValue ?? "" ==  MenuView.CellType.WorkTypeInfo.rawValue {
            return MenuView.CellType.WorkTypeInfo
        }
        
        return MenuView.CellType(rawValue: name)
    }
    
}



class ReportsView : BaseView {
    
    
    struct ReportInfo {
        let name: String
        let image: String
    }
    
    struct ApprovalInfo {
        let name: String
        let count: String
    }
    
    
    enum cellType {
        
    }
    
    @IBOutlet var reportTitle: UILabel!
    
    @IBOutlet weak var topNavigationView: UIView!
    
    
    @IBOutlet weak var collectionHolderView: UIView!
    
    @IBOutlet weak var backHolderView: UIView!
    
    
    @IBOutlet weak var reportsCollection: UICollectionView!
    
    
    @IBOutlet var resouceHQholderVIew: UIView!
    
    @IBOutlet var resourceHQlbl: UILabel!
    var reporsVC : ReportsVC!
    var reportInfoArr : [ReportInfo]?
    var approvalInfoArr: [ApprovalInfo]?
    var pagetype: ReportsVC.PageType = .reports
    var approvalsCountModel: ApprovalsCountModel?
    lazy var contentDict : Array<JSON> = [JSON]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.reporsVC = baseVC as? ReportsVC
        setupUI()
        cellregistration()
  
    }
    
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.reporsVC = baseVC as? ReportsVC
        if reporsVC.pageType == .approvals {
            setPagetype(pagetype: reporsVC.pageType)
        }

    }
    
    func initTaps() {
        backHolderView.addTap {
            self.reporsVC.navigationController?.popViewController(animated: true)
        }
        resouceHQholderVIew.addTap {
          //  self.headquarterAction()
        }
    }
    
//    func headquarterAction() {
//      //  let headquarter = DBManager.shared.getSubordinate()
//
//        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR)  {
//            return
//        }
//        
//        if  Shared.instance.isFetchingHQ {
//            self.toCreateToast("Syncing please wait")
//            return
//        }
//
//        
//        let vc = SpecifiedMenuVC.initWithStory(self, celltype: .headQuater)
//        
//        vc.menuDelegate = self
//        
//
//            CoreDataManager.shared.fetchSavedHQ{ [weak self] hqArr in
//                guard let welf = self else {return}
//                let savedEntity = hqArr.first
//                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: welf.context)
//         
//                else {
//                    fatalError("Entity not found")
//                }
//                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
//                
//                welf.fetchedHQObject = CoreDataManager.shared.convertHeadQuartersToSubordinate(savedEntity ?? temporaryselectedHqobj, context: welf.context)
//            }
//        
//        
//        
//
//        vc.selectedObject = self.fetchedHQObject
//        
//        self.modalPresentationStyle = .custom
//        self.navigationController?.present(vc, animated: false)
//
//    }
    
    func setPagetype(pagetype: ReportsVC.PageType) {
        switch pagetype {
            
        case .reports:
            resouceHQholderVIew.isHidden = true
            self.reportTitle.text = "Reports"
           // contentDict
            contentDict = [["Day Report" : "Day Report"]]
                reportInfoArr = generateModel(contentDict: contentDict as! [[String: String]])
            
            //, ["Monthly Report": "Monthly"], ["Day Check in Report": "Day Check in"], ["Customer Check in Report" : "Day Check in"], ["Visit Monitor" : "Visit"]
            
           
        case .approvals:
            resouceHQholderVIew.isHidden = true
            reportTitle.text = "Approvals"
            if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                self.showAlert(desc: "Please connect to internet to fetch approvals.")
                return
            }
            Shared.instance.showLoaderInWindow()
            reporsVC.fetchApprovals(vm: UserStatisticsVM()) {[weak self] approvalsCount in
                Shared.instance.removeLoaderInWindow()
                guard let welf = self, let approvalsCount = approvalsCount, !approvalsCount.apprCount.isEmpty else {return}
                let dcrApprovalCount = approvalsCount.apprCount[0].dcrapprCount ?? "0"
                let leaveApprovalCount = approvalsCount.apprCount[0].leaveapprCount ?? "0"
                let tpApprovalCount = approvalsCount.apprCount[0].tpapprCount ?? "0"
                welf.contentDict.removeAll()
                if leaveApprovalCount != "0" || !leaveApprovalCount.isEmpty {
                    welf.contentDict.append(["Leave Approvals" : "\(leaveApprovalCount)"])
                }
                
                if dcrApprovalCount != "0" ||  !dcrApprovalCount.isEmpty {
                    welf.contentDict.append(["DCR Approvals" : "\(dcrApprovalCount)"])
                }
                
                if tpApprovalCount != "0" || !tpApprovalCount.isEmpty {
                    welf.contentDict.append(["TP Approvals" : "\(tpApprovalCount)"])
                }
                
                welf.reportInfoArr = welf.generateModel(contentDict: welf.contentDict as! [[String: String]])
                welf.toLoadData()
            }
            return
        case .myResource:
            resouceHQholderVIew.isHidden = false
            setHQlbl()
            self.reportTitle.text = "My Resource"
            contentDict = Array<JSON>()
            reportInfoArr = generateModel(contentDict: toSetupResources())
        }
        toLoadData()
    }
    
    func showAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true, customAction: {
            print("no action")
            self.reporsVC.navigationController?.popViewController(animated: true)
        })
    }
    
    func setHQlbl() {
        // let appsetup = AppDefaults.shared.getAppSetUp()
            CoreDataManager.shared.toRetriveSavedDayPlanHQ { hqModelArr in
                let savedEntity = hqModelArr.first
                guard let savedEntity = savedEntity else{
                    
                    self.resourceHQlbl.text = "Select HQ"
                    
                    return
                    
                }
                
                self.resourceHQlbl.text = savedEntity.name == "" ? "Select HQ" : savedEntity.name
                
                let subordinates = DBManager.shared.getSubordinate()
                
                let asubordinate = subordinates.filter{$0.id == savedEntity.code}
                
                if !asubordinate.isEmpty {
                 //  self.fetchedHQObject = asubordinate.first
                 //   LocalStorage.shared.setSting(LocalStorage.LocalValue.selectedRSFID, text:  asubordinate.first?.id ?? "")
                }
            
              
  
 
                
            }
            // Retrieve Data from local storage
               return
        

       
    }
    
    
    
    func setupUI() {
        initTaps()
        reportTitle.setFont(font: .bold(size: .SUBHEADER))
        collectionHolderView.backgroundColor = .appSelectionColor
        resourceHQlbl.setFont(font: .medium(size: .BODY))
        resourceHQlbl.textColor = .appTextColor
        resouceHQholderVIew.layer.cornerRadius = 5
        resouceHQholderVIew.backgroundColor = .appWhiteColor
        if reporsVC.pageType != .approvals {
            setPagetype(pagetype: reporsVC.pageType)
        }
      
    }
    
    func generateModel(contentDict: [[String: String]]) -> [ReportInfo] {
        var modelArray: [ReportInfo] = []
        contentDict.forEach { aDict in
            for (name, image) in aDict {
                let reportInfo = ReportInfo(name: name, image: image)
                modelArray.append(reportInfo)
            }
        }
  

        return modelArray
    }
    
    
    func toSetupResources() -> [[String: String]] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        

        
   
        let docDict: [String: String] = [MenuView.CellType.listedDoctor.dynamicValue: String(DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)]
        
        contentDict.append(docDict)
        
        if appsetup.chmNeed == 0 {
      
            let  checmistDict: [String: String] = [MenuView.CellType.chemist.dynamicValue : String(DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)]
            
            contentDict.append(checmistDict)
        }
        if appsetup.stkNeed == 0 {
       
            let  StockistDict: [String: String] = [MenuView.CellType.stockist.dynamicValue : String(DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)]
            
            contentDict.append(StockistDict)
        }
        
        
        if appsetup.unlNeed == 0 {
        
            let  UnlistedDict: [String: String] = [MenuView.CellType.unlistedDoctor.dynamicValue : String(DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)]
            
            contentDict.append(UnlistedDict)
        }
        if appsetup.cipNeed == 0 {
       
            let  cipDict: [String: String] = [MenuView.CellType.cip.rawValue : "0"]
            
            contentDict.append(cipDict)
        }
        if appsetup.hospNeed == 0 {
        
            let  hospDict: [String: String] = [MenuView.CellType.hospitals.rawValue : ""]
            
            contentDict.append(hospDict)
        }
        
        let cacheInputs = DBManager.shared.getInput()
        var inputCount: Int = 0
              let noInput = cacheInputs.filter { aInput in
                  aInput.code == "-1"
              }
      
      
              if noInput.isEmpty {
                  inputCount = DBManager.shared.getInput().count
              } else {
                  inputCount = DBManager.shared.getInput().count - 1
              }
      
           
        
        let  hospDict: [String: String] = [MenuView.CellType.inputs.rawValue  : String(inputCount)]
        //DBManager.shared.getInput().count
        contentDict.append(hospDict)
        let  ProductDict: [String: String] = [MenuView.CellType.product.rawValue  : String(DBManager.shared.getProduct().count)]
        contentDict.append(ProductDict)
        let  ClusterDict: [String: String] = [MenuView.CellType.clusterInfo.rawValue : String(DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count)]
        contentDict.append(ClusterDict)
       // let  DoctorDict: [String: String] = [MenuView.CellType.doctorVisit.rawValue  : String(DBManager.shared.getVisitControl().count)]
      //  contentDict.append(DoctorDict)
        let  HolidayDict: [String: String] = [MenuView.CellType.holiday.rawValue   : "\(String(DBManager.shared.getHolidays().count)) " + "/" + " \(String(DBManager.shared.getWeeklyOff().count))"]
        //\(String(DBManager.shared.getHolidays().count)) / \(String(DBManager.shared.getWeeklyOff().count))
        contentDict.append(HolidayDict)
        
        let WorkTypeDict : [String: String] = [MenuView.CellType.WorkTypeInfo.rawValue   : String(DBManager.shared.getWorkType().count)]
        contentDict.append(WorkTypeDict)
        return contentDict as!  [[String: String]]
    }
    
    func cellregistration() {
        reportsCollection.register(UINib(nibName: "ReportTypesCVC", bundle: nil), forCellWithReuseIdentifier: "ReportTypesCVC")
    }
    
    func toLoadData() {
        reportsCollection.delegate = self
        reportsCollection.dataSource = self
        reportsCollection.reloadData()
    }
    
}
