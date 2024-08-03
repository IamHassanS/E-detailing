//
//  DCRapprovalView.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import Foundation
import UIKit
import CoreData

extension DCRapprovalView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            var filteredlist = [ApprovalsListModel]()
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
                self.loadApprovalDetailTable()
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
 
extension DCRapprovalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case approvalTable :
            guard let approvalList = isSearched ? filteredApprovalList : approvalList else { return 0}
            return approvalList.count
        default:
            return 3
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch tableView {
        case approvalTable :
            return tableView.height / 11
        default:
            switch indexPath.row {
                
            case 0:
                //top - 10 || MR name - 60 ||Date info - 60 || work type info 2 *  90 (Max) || bottom 15
                return 10 + 60 + 60 + 90 + 15
            case 1:
                return 60
            case 2:
                guard let approvalDetails = approvalDetails else {return CGFloat()}
                switch selectedType {
                    
                case .All:
                    return CGFloat(70 * approvalDetails.count)
                case .Doctor:
                    return CGFloat(70 * approvalDetails.filter { $0.type == "DOCTOR" }.count)
                case .Chemist:
                    return CGFloat(70 * approvalDetails.filter { $0.type == "CHEMIST" }.count)
                case .Stockist:
                    return CGFloat(70 * approvalDetails.filter { $0.type == "STOCKIST" }.count)
                case .UnlistedDoctor:
                    return CGFloat(70 * approvalDetails.filter { $0.type == "ULDOCTOR" }.count)
                case .Hospital:
                    print("YET TO")
                case .CIP:
                    print("YET TO")
                }
                
                
                return CGFloat(70 * approvalDetails.count)
            default:
                return 0
                
            }
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
              //  welf.loadApprovalDetailTable()
                Shared.instance.showLoaderInWindow()
                welf.dcrApprovalVC.fetchApprovalDetail(transNumber: model.transSlNo, vm: UserStatisticsVM()) { approvalDetailModel in
                    Shared.instance.removeLoaderInWindow()
                    guard let approvalDetailModel = approvalDetailModel else {return}
                    //dump(approvalDetailModel)
                    welf.selectedType = .All
                    welf.approvalDetails = approvalDetailModel
                    welf.loadApprovalDetailTable()
                }
            }
            
     return cell
        default:
            switch indexPath.row {
            case 0:
                let cell: DCRApprovalsWorkTypeTVC = approvalDetailsTable.dequeueReusableCell(withIdentifier: "DCRApprovalsWorkTypeTVC") as! DCRApprovalsWorkTypeTVC
                cell.selectionStyle = .none
                guard let approvalDetails = self.approvalDetails, let approvalList = approvalList?[selectedBrandsIndex ?? 0] else {return UITableViewCell()}
               
                cell.toPopulatecell(detailsmodel: approvalDetails, listModel: approvalList)
                return cell
                
            case 1:
                let cell: VisitsCountTVC = tableView.dequeueReusableCell(withIdentifier: "VisitsCountTVC", for: indexPath) as! VisitsCountTVC
            
               
           //     cell.wtModel = self.reportsModel
                guard  let approvalDetailModel =  approvalDetails else {return UITableViewCell() }
                cell.selectionStyle = .none
                cell.delegate = self
                cell.toPopulateCell(model: approvalDetailModel)
                cell.toloadData()
                return cell
            case 2:
                
                let cell: DCRAllApprovalsTVC = tableView.dequeueReusableCell(withIdentifier: "DCRAllApprovalsTVC", for: indexPath) as! DCRAllApprovalsTVC
                
                guard  let approvalDetailModel =  approvalDetails else {return UITableViewCell() }
                
                
                switch selectedType {
                    
                case .All:
                    cell.populateCell(model: approvalDetailModel)
                case .Doctor:
                    cell.populateCell(model: approvalDetailModel.filter { $0.type == "DOCTOR" })
                case .Chemist:
                    cell.populateCell(model: approvalDetailModel.filter { $0.type == "CHEMIST" })
                case .Stockist:
                    cell.populateCell(model: approvalDetailModel.filter { $0.type == "STOCKIST" })
                case .UnlistedDoctor:
                    cell.populateCell(model: approvalDetailModel.filter { $0.type == "ULDOCTOR" })
                case .Hospital:
                    print("YET TO")
                case .CIP:
                    print("YET TO")
                }
                

                cell.rootController = self.dcrApprovalVC
                cell.selectedapproval = approvalList?[selectedBrandsIndex ?? 0]
                cell.selectionStyle = .none
                return cell
                
                
            default:
                return UITableViewCell()
            }
          
        }
        

    }
    
    
}

class DCRapprovalView : BaseView {
    
    
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
    var filteredApprovalList: [ApprovalsListModel]?
    var approvalDetails: [ApprovalDetailsModel]?
    var approvalList: [ApprovalsListModel]?
    var dcrApprovalVC : DCRapprovalVC!
    var selectedBrandsIndex: Int?
    var selectedType: CellType = .All
    
    var isRemarksadded = false
    var dayRemarks = ""
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.dcrApprovalVC = baseVC as? DCRapprovalVC
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
        dcrApprovalVC.fetchApprovalList(vm: UserStatisticsVM()) {[weak self] approvalist in
            Shared.instance.removeLoaderInWindow()
            guard let welf = self, let approvalist = approvalist else {return}
            welf.approvalList = approvalist
            welf.loadApprovalTable()
            welf.dcrApprovalVC.fetchFirstIndex()
            
        }
    }
    
    func setupUI() {
        self.backgroundColor = .appGreyColor
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
        
        approvalDetailsTable.register(UINib(nibName: "DCRApprovalsWorkTypeTVC", bundle: nil), forCellReuseIdentifier: "DCRApprovalsWorkTypeTVC")
        
        approvalDetailsTable.register(UINib(nibName: "VisitsCountTVC", bundle: nil), forCellReuseIdentifier: "VisitsCountTVC")
        
        approvalDetailsTable.register(UINib(nibName: "DCRAllApprovalsTVC", bundle: nil), forCellReuseIdentifier: "DCRAllApprovalsTVC")
        
        
    }

    
    func initTaps() {
        backHolderView.addTap {
            self.dcrApprovalVC.navigationController?.popViewController(animated: true)
        }
        
        rejectView.addTap { [weak self] in
            guard let welf = self else {return}
            if !welf.isRemarksadded && welf.dayRemarks.isEmpty {
                welf.deviateAction(isForremarks: false)
                return
            }
           
        }
        
        backgroundView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.didClose()
        }
        
        approveView.addTap {[weak self] in
            guard let welf = self else {return}
             print("Yet to")
            Shared.instance.showLoaderInWindow()
            welf.dcrApprovalVC.dcrApprovalAPI(vm: UserStatisticsVM()) { result in
                Shared.instance.removeLoaderInWindow()
                if result?.isSuccess ?? false {
                    welf.toCreateToast("Plan Approved successfully.")
                    welf.callAPI()
                }
               
            }
        }
        
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
        
        tpDeviateReasonView = self.dcrApprovalVC.loadCustomView(nibname: XIBs.tpDeviateReasonView) as? TPdeviateReasonView
        tpDeviateReasonView?.delegate = self
        
        tpDeviateReasonView?.addedSubviewDelegate = self
        tpDeviateReasonView?.isForRemarks = false
        tpDeviateReasonView?.isForRejection = true
        tpDeviateReasonView?.setupui()
        self.addSubview(tpDeviateReasonView ?? TPdeviateReasonView())
    }
    
}
extension DCRapprovalView: VisitsCountTVCDelegate {
    func typeChanged(index: Int, type: CellType) {
        
        guard self.selectedType != type else {
            return
        }

        self.selectedType = type
        self.loadApprovalDetailTable()
    }
    
    
}
extension DCRapprovalView : addedSubViewsDelegate {
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
            self.dcrApprovalVC.navigationController?.popViewController(animated: true)
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

extension DCRapprovalView : SessionInfoTVCDelegate {
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
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
             //   self.setDeviateSwitch(istoON: true)
                Shared.instance.showLoaderInWindow()
                dcrApprovalVC.dcrRejectAPI(vm: UserStatisticsVM()) {[weak self] result in
                    guard let welf = self else {return}
                    welf.isRemarksadded = false
                    welf.dayRemarks = ""
                    Shared.instance.removeLoaderInWindow()
                    if result?.isSuccess ?? false {
                        welf.toCreateToast("Plan rejected.")
                        welf.callAPI()
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
