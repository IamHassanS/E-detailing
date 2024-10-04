//
//  TourPlanApprovalView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/07/24.
//

import Foundation
import UIKit
import CoreData

extension TourPlanApprovalView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            var filteredlist = [TourPlanApprovalModel]()
            filteredlist.removeAll()
            var isMatched = false
            approvalList?.forEach({ list in
                if list.sfName.lowercased().contains(newText) {
                    filteredlist.append(list)
                    isMatched = true
                    
                }
            })
            
            if newText.isEmpty {
               filteredApprovalList = self.approvalList
                self.loadApprovalTable()
            } else if isMatched {
                filteredApprovalList = filteredlist
                isSearched = true
                self.selectedBrandsIndex = nil
                self.approvalDetails = nil
                //self.loadApprovalDetailTable()
                self.loadApprovalTable()
            } else {
                isSearched = false
                self.loadApprovalTable()
                print("Not matched")
            }
            
            return true
        }
        return true
    }
}

extension TourPlanApprovalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case approvalTable :
            guard let approvalList = isSearched ? filteredApprovalList : approvalList else { return 0}
            return approvalList.count
         //   return 10
        case approvalDetailsTable:
            guard let approvalDetails = self.approvalDetails else {return 0}
            dump(approvalDetails.count)
            return approvalDetails.count
            
        default:
            return 0
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
        case approvalTable :
            return tableView.height / 11
        case approvalDetailsTable:
            switch indexPath.row {
                
            case 0:
                ///top - 10 || MR name - 60 ||Date info - 60 || work type info 2 *  90 (Max) || bottom 15
                return 10 + 60 + 60 + 15
            default :
              //  return 10 + 60 + 10
              ///  session height - 670 + 100
                guard let approvalDetails = self.approvalDetails else {  return 0 }
                let model = approvalDetails[indexPath.row]
                
                if !model.isExtended {
                   return 10 + 60 + 10
                } else {
                    var cellHeight: CGFloat = 0
                   let sessions = convertToSessionDetails(from: model)
                    sessions.forEach { aSessionDetail in
                        if aSessionDetail.FWFlg == "F" || aSessionDetail.FWFlg == "Y"  {
                            cellHeight += 670 + 100
                         
                       } else {
                           cellHeight +=  60 + 20 + 100
                        
                       }
                    }
                    return 10 + 60 + cellHeight
                }
            }
        default:
            return 0
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case approvalTable :
            let cell: DCRApprovalsTVC = approvalTable.dequeueReusableCell(withIdentifier: "DCRApprovalsTVC", for: indexPath) as! DCRApprovalsTVC
            cell.selectionStyle = .none
            cell.approcalDateLbl.textColor = .appTextColor
            cell.mrNameLbl.textColor = .appTextColor
            cell.contentHolderView.backgroundColor = .appWhiteColor
            cell.contentHolderView.layer.cornerRadius = 5
            cell.accessoryIV.image = UIImage(named: "chevlon.right")
            cell.accessoryIV.tintColor = .appTextColor
            cell.dateHolderView.layer.cornerRadius = 5
            cell.dateHolderView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
            
            guard let approvalList = isSearched ? filteredApprovalList : approvalList  else {
                return UITableViewCell()
            }
            let model = approvalList[indexPath.row]
            cell.populateCell(model)
            
            
            if selectedBrandsIndex == indexPath.row {
                cell.contentHolderView.backgroundColor = .appTextColor
                cell.dateHolderView.backgroundColor = .appWhiteColor
                cell.mrNameLbl.textColor = .appWhiteColor
                cell.accessoryIV.tintColor = .appWhiteColor
            }
            
            cell.addTap {[weak self] in
                guard let welf = self else {return}
                welf.selectedBrandsIndex = indexPath.row
                welf.approvalTable.reloadData()
                //  welf.approvalCollection.reloadData()
                // welf.loadApprovalDetailTable()
                Shared.instance.showLoaderInWindow()
                let additionalParam = TPdetailParam(month: model.mnth, year: model.yr, sfcode: model.sfCode)
                welf.tourPlanApprovalVC.getTPapprovalDetail(additionalparam: additionalParam, vm: UserStatisticsVM()) { approvalDetailModel in
                    Shared.instance.removeLoaderInWindow()
                    guard let approvalDetailModel = approvalDetailModel else {return}
                    dump(approvalDetailModel)
                    welf.selectedType = .All
                    welf.approvalDetails = approvalDetailModel
                    welf.rejectView.isHidden = false
                    welf.approveView.isHidden = false
                    welf.loadApprovalDetailTable()
                }
            }
            
            return cell
        case approvalDetailsTable:
            switch indexPath.row {
            case 0:
                let cell: TourPlanApprovalinfoTVC = approvalDetailsTable.dequeueReusableCell(withIdentifier: "TourPlanApprovalinfoTVC") as! TourPlanApprovalinfoTVC
                cell.selectionStyle = .none
                guard let approvalDetails = self.approvalDetails, let approvalList = approvalList?[selectedBrandsIndex ?? 0] else {return UITableViewCell()}
                cell.toPopulatecell(model: approvalDetails, list: approvalList)
                return cell
                
            default:
                let cell: TourplanApprovalDetailedInfoTVC = tableView.dequeueReusableCell(withIdentifier: "TourplanApprovalDetailedInfoTVC", for: indexPath) as! TourplanApprovalDetailedInfoTVC
                guard let approvalDetails = self.approvalDetails else {  return UITableViewCell() }
                let model = approvalDetails[indexPath.row]
                cell.populateCell(model: model)
                cell.chevlonIV.addTap {[weak self] in
                                        guard let welf = self else {return}
                                        model.isExtended = !model.isExtended
                                        welf.loadApprovalDetailTable()
                }
                cell.selectionStyle = .none
                return cell
            }
            
            
        default:
            return UITableViewCell()
        }

    }
    
    
}

class TourPlanApprovalView : BaseView {
    
    
    @IBOutlet var approvalTitle: UILabel!
    
    @IBOutlet weak var topNavigationView: UIView!
    
    
    @IBOutlet weak var collectionHolderView: UIView!
    
    @IBOutlet weak var backHolderView: UIView!
    
    
    @IBOutlet weak var approvalDetailsTable: UITableView!
    
    
    @IBOutlet weak var approvalTable: UITableView!
    
    
    @IBOutlet var searchHolderView: UIView!
    
    @IBOutlet var rejectView: UIView!
    
    @IBOutlet var approveView: UIView!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var searchTF: UITextField!
    var isSearched = false
    var tpDeviateReasonView:  TPdeviateReasonView?
    var filteredApprovalList: [TourPlanApprovalModel]?
    var approvalDetails: [TourPlanApprovalDetailModel]?
    var tourPlanApprovalVC : TourPlanApprovalVC!
    var selectedBrandsIndex: Int?
    var selectedType: CellType = .All
    var approvalList: [TourPlanApprovalModel]?
    var isRemarksadded = false
    var dayRemarks = ""
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.tourPlanApprovalVC = baseVC as? TourPlanApprovalVC
        initTaps()
        setupUI()
        cellregistration()
        callAPI()
      
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
     super.didLayoutSubviews(baseVC: baseVC)
        
        let  tpDeviateVIewwidth = self.bounds.width / 1.7
        let  tpDeviateVIewheight = self.bounds.height / 2.7
        
        let  tpDeviateVIewcenterX = self.bounds.midX - (tpDeviateVIewwidth / 2)
        let tpDeviateVIewcenterY = self.bounds.midY - (tpDeviateVIewheight / 2)
        
        
        tpDeviateReasonView?.frame = CGRect(x: tpDeviateVIewcenterX, y: tpDeviateVIewcenterY, width: tpDeviateVIewwidth, height: tpDeviateVIewheight)
    }
    
    func callAPI() {
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            self.showAlert(desc: "Please connect to internet to fetch approvals.")
            return
        }
        Shared.instance.showLoaderInWindow()
        tourPlanApprovalVC.fetchTPapproval(vm: UserStatisticsVM()) {[weak self] approvalist in
            Shared.instance.removeLoaderInWindow()
            guard let welf = self, let approvalist = approvalist else {return}
            welf.approvalList = approvalist
            welf.approvalDetails = nil
            welf.loadApprovalDetailTable()
            welf.approveView.isHidden = true
            welf.rejectView.isHidden = true
            welf.loadApprovalTable()
          //  loadApprovalDetailTable()
         //   welf.dcrApprovalVC.fetchFirstIndex()
            
        }
    }

    func setupUI() {
        self.backgroundColor = .appGreyColor
        rejectView.isHidden = true
        approveView.isHidden = true
        backgroundView.isHidden = true
        collectionHolderView.layer.cornerRadius = 5
        searchHolderView.layer.cornerRadius = 5
        rejectView.layer.cornerRadius = 5
        approveView.layer.cornerRadius = 5
        rejectView.backgroundColor = .appLightPink
        approveView.backgroundColor = .appGreen
        searchTF.delegate = self
    }
    
    func loadApprovalTable() {
        approvalTable.delegate = self
        approvalTable.dataSource = self
        approvalTable.reloadData()
    }
    
    func loadApprovalDetailTable() {
        approvalDetailsTable.delegate = self
        approvalDetailsTable.dataSource = self
        approvalDetailsTable.reloadData()
    }
    
    func cellregistration() {
        approvalTable.register(UINib(nibName: "DCRApprovalsTVC", bundle: nil), forCellReuseIdentifier: "DCRApprovalsTVC")
        
        approvalDetailsTable.register(UINib(nibName: "TourPlanApprovalinfoTVC", bundle: nil), forCellReuseIdentifier: "TourPlanApprovalinfoTVC")
        
        approvalDetailsTable.register(UINib(nibName: "TourplanApprovalDetailedInfoTVC", bundle: nil), forCellReuseIdentifier: "TourplanApprovalDetailedInfoTVC")
        
    }

    
    func initTaps() {
        backHolderView.addTap {
            self.tourPlanApprovalVC.navigationController?.popViewController(animated: true)
        }
        
//        rejectView.addTap { [weak self] in
//            guard let welf = self else {return}
//            if !welf.isRemarksadded && welf.dayRemarks.isEmpty {
//                welf.deviateAction(isForremarks: false)
//                return
//            }
            
            rejectView.addTap { [weak self] in
                guard let welf = self else {return}
                if !welf.isRemarksadded && welf.dayRemarks.isEmpty {
                    welf.deviateAction(isForremarks: false)
                    return
                } else if  welf.isRemarksadded {
                    guard let approvalDetails = welf.approvalDetails else {return}
                    let model = approvalDetails[welf.selectedBrandsIndex ?? 0]
                    let param = TPdetailParam(month: model.mnth, year: model.yr, sfcode: model.sfCode)
                    welf.tourPlanApprovalVC.rejectAPI(additionalparam: param, vm: UserStatisticsVM()) {[weak self] response in
                        guard let welf = self else {return}
                        welf.isRemarksadded = false
                        welf.dayRemarks = ""
                        if response?.isSuccess ?? false  {
                            welf.toCreateToast(response?.msg ?? "")
                            welf.callAPI()
                        } else {
                            welf.toCreateToast(response?.checkinMasg ??  "Failed to reject plan. Try again later")
                        }
                  
                        
                    }
                }
            
        }
        
        backgroundView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.didClose()
        }
        
        approveView.addTap {[weak self] in
            guard let welf = self else {return}
            
            if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                welf.toCreateToast("Please connect to interner")
                return
            }
            
            guard let approvalDetails = welf.approvalDetails else {return}
            let model = approvalDetails[welf.selectedBrandsIndex ?? 0]
            let param = TPdetailParam(month: model.mnth, year: model.yr, sfcode: model.sfCode)
            welf.tourPlanApprovalVC.approveAPI(additionalparam: param, vm: UserStatisticsVM()) { response in
                if response?.isSuccess ?? false  {
                    welf.toCreateToast("Tout plan Approved.")
                    welf.callAPI()
                } else {
                    welf.toCreateToast("Failed to approve. Try again later")
                }
            
                
            }
        }
        
//        rejectView.addTap {[weak self] in
//            guard let welf = self else {return}
//            guard let approvalDetails = welf.approvalDetails else {return}
//            let model = approvalDetails[welf.selectedBrandsIndex ?? 0]
//            let param = TPdetailParam(month: model.mnth, year: model.yr, sfcode: model.sfCode)
//            welf.tourPlanApprovalVC.rejectAPI(additionalparam: param, vm: UserStatisticsVM()) { response in
//                if response?.isSuccess ?? false  {
//                    welf.toCreateToast(response?.msg ?? "")
//                    welf.callAPI()
//                } else {
//                    welf.toCreateToast("Failed to approve. Try again later")
//                }
//          
//                
//            }
//        }
        
        
    }
    
    func deviateAction(isForremarks: Bool) {
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        self.subviews.forEach { aAddedView in
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
        
        tpDeviateReasonView = self.tourPlanApprovalVC.loadCustomView(nibname: XIBs.tpDeviateReasonView) as? TPdeviateReasonView
        tpDeviateReasonView?.delegate = self
        
        tpDeviateReasonView?.addedSubviewDelegate = self
        tpDeviateReasonView?.isForRemarks = false
        tpDeviateReasonView?.isForRejection = true
        tpDeviateReasonView?.setupui()
        self.addSubview(tpDeviateReasonView ?? TPdeviateReasonView())
    }
    func convertToSessionDetails(from model: TourPlanApprovalDetailModel) -> [SessionDetail] {
        var sessionDetails = [SessionDetail]()

        // Create first SessionDetail
        let session1 = SessionDetail()
        session1.workTypeCode = model.wtCode
        session1.FWFlg = model.fwFlg
        session1.HQCodes = model.hqCodes
        session1.HQNames = model.hqNames
        session1.WTCode = model.wtCode
        session1.WTName = model.wtName
        session1.chemCode = model.chemCode
        session1.chemName = model.chemName
        session1.clusterCode = model.clusterCode
        session1.clusterName = model.clusterName
        session1.drCode = model.drCode
        session1.drName = model.drName
        session1.jwCode = model.jwCodes
        session1.jwName = model.jwNames
        session1.remarks = model.dayRemarks
        session1.stockistCode = model.stockistCode
        session1.stockistName = model.stockistName
        sessionDetails.append(session1)

        guard model.wtCode2 != "" else {
            return sessionDetails
        }
        // Create second SessionDetail
        let session2 = SessionDetail()
        session2.workTypeCode = model.wtCode2
        session2.FWFlg = model.fwFlg2
        session2.HQCodes = model.hqCodes2
        session2.HQNames = model.hqNames2
        session2.WTCode = model.wtCode2
        session2.WTName = model.wtName2
        session2.chemCode = model.chemTwoCode
        session2.chemName = model.chemTwoName
        session2.clusterCode = model.clusterCode2
        session2.clusterName = model.clusterName2
        session2.drCode = model.drTwoCode
        session2.drName = model.drTwoName
        session2.jwCode = model.jwCodes2
        session2.jwName = model.jwNames2
        session2.remarks = model.dayRemarks2
        session2.stockistCode = model.stockistTwoCode
        session2.stockistName = model.stockistTwoName
        sessionDetails.append(session2)
        
        guard model.wtCode3 != "" else {
            return sessionDetails
        }
        // Create third SessionDetail
        let session3 = SessionDetail()
        session3.workTypeCode = model.wtCode3
        session3.FWFlg = model.fwFlg3
        session3.HQCodes = model.hqCodes3
        session3.HQNames = model.hqNames3
        session3.WTCode = model.wtCode3
        session3.WTName = model.wtName3
        session3.chemCode = model.chemThreeCode
        session3.chemName = model.chemThreeName
        session3.clusterCode = model.clusterCode3
        session3.clusterName = model.clusterName3
        session3.drCode = model.drThreeCode
        session3.drName = model.drThreeName
        session3.jwCode = model.jwCodes3
        session3.jwName = model.jwNames3
        session3.remarks = model.dayRemarks3
        session3.stockistCode = model.stockistThreeCode
        session3.stockistName = model.stockistThreeName
        sessionDetails.append(session3)

        return sessionDetails
    }
}
extension TourPlanApprovalView : addedSubViewsDelegate {
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("yes action")
    }
    
    
    func showAlertToNetworks(desc: String, isToclearacalls: Bool) {

    }
    
    
    func redirectToSettings() {

    }
    
    func showAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true, customAction: {
            print("no action")
            self.tourPlanApprovalVC.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
    
    func didClose() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            
            switch aAddedView {
 
            case tpDeviateReasonView:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                isRemarksadded = false
                dayRemarks = ""
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }

    func didUpdate() {
    
    }
    
    
}
extension TourPlanApprovalView : SessionInfoTVCDelegate {
    func remarksAdded(remarksStr: String, index: Int) {
        
        guard !remarksStr.isEmpty else {
         toCreateToast("Kindly add reason for rejection")
            
            return}
        self.isRemarksadded = true
        self.dayRemarks = remarksStr
        
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case tpDeviateReasonView:
                if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                    self.toCreateToast("Please connect to internet.")
                    return
                }
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                guard let approvalDetails = approvalDetails else {return}
                let model = approvalDetails[selectedBrandsIndex ?? 0]
                let param = TPdetailParam(month: model.mnth, year: model.yr, sfcode: model.sfCode)
                tourPlanApprovalVC.rejectAPI(additionalparam: param, vm: UserStatisticsVM()) {[weak self] response in
                    guard let welf = self else {return}
                    welf.isRemarksadded = false
                    welf.dayRemarks = ""
                    if response?.isSuccess ?? false  {
                        welf.toCreateToast(response?.msg ?? "")
                        welf.callAPI()
                    } else {
                        welf.toCreateToast(response?.checkinMasg ??  "Failed to reject plan. Try again later")
                    }
              
                    
                }
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
            }

        }

    }
    
    
}
