//
//  LeaveApprovalView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/07/24.
//

import Foundation
import UIKit
import CoreData

extension LeaveApprovalView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            var filteredlist = [LeaveApprovalDetail]()
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
                self.toLoadData()
            } else if isMatched {
                filteredApprovalList = filteredlist
                isSearched = true
                self.selectedActionIndex = nil
                self.toLoadData()
            } else {
                isSearched = false
                showAlert(desc: "No related search found")
                self.endEditing(true)
                self.toLoadData()
                print("Not matched")
            }
            
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
}

extension LeaveApprovalView: LeaveApprovalTVCDelegate {
    func diduserApprove(index: Int) {
        selectedActionIndex = index
        print("Yet to")
        if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
            toCreateToast("Please connect to active internet")
            return
        }
        Shared.instance.showLoaderInWindow()
        leaveApprovalVC.leaveApprovalAPI(vm: UserStatisticsVM()) {[weak self] result in
            guard let welf = self else {return}
            welf.isRemarksadded = false
            welf.dayRemarks = ""
            Shared.instance.removeLoaderInWindow()
            if result?.isSuccess ?? false {
                welf.toCreateToast(result?.checkinMasg ?? "Approved successfully")
                welf.callAPI()
            } else {
                welf.toCreateToast(result?.checkinMasg ?? "Unable to approve leave please do try again later.")
            }
           
        }
        
    }
    
    func diduserReject(index: Int) {
        deviateAction(isForremarks: true)
    }
    
    
}
 
extension LeaveApprovalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let approvalList = isSearched ? filteredApprovalList : approvalList else {return 0}
        return approvalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:  LeaveApprovalTVC = tableView.dequeueReusableCell(withIdentifier: "LeaveApprovalTVC", for: indexPath) as! LeaveApprovalTVC
        cell.selectionStyle = .none
        guard let approvalList =  isSearched ? filteredApprovalList : approvalList else {return UITableViewCell()}
        let model: LeaveApprovalDetail = approvalList[indexPath.row]
        cell.toPopulateCell(model: model)
        cell.delegate = self
        cell.approveView.addTap { [weak self] in
        
            cell.delegate?.diduserApprove(index: indexPath.row)
            
        }
        
        cell.rejectView.addTap {[weak self] in
          
            cell.delegate?.diduserReject(index: indexPath.row)
        }
        
        cell.addressonDesc.addTap {[weak self] in
            guard let welf = self else {return}
            welf.showHover(view: cell.addressonDesc, comment: model.address)
        }
        
        cell.reasonDesc.addTap {[weak self] in
            guard let welf = self else {return}
            welf.showHover(view: cell.reasonDesc, comment: model.reason)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 3
    }
    
    
}

class LeaveApprovalView : BaseView {
    
    
    @IBOutlet var approvalTitle: UILabel!
    
    @IBOutlet weak var topNavigationView: UIView!
    
    
    @IBOutlet weak var tableHolderView: UIView!
    
    @IBOutlet weak var backHolderView: UIView!
    
    
    @IBOutlet weak var approvalDetailsTable: UITableView!
    

    @IBOutlet var searchHolderView: UIView!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var searchTF: UITextField!
    
    var tpDeviateReasonView:  TPdeviateReasonView?
    var isSearched = false
    var leaveApprovalVC : LeaveApprovalVC!
  //  var selectedBrandsIndex: Int?
    var filteredApprovalList: [LeaveApprovalDetail]?
    var approvalList: [LeaveApprovalDetail]?
    var isRemarksadded = false
    var dayRemarks = ""
    var selectedActionIndex: Int?
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.leaveApprovalVC = baseVC as? LeaveApprovalVC
        initTaps()
        setupUI()
        cellregistration()
        callAPI()
    
        
    }
    
    
    func showHover(view: UIView, comment: String) {
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 7), on: view,  pagetype: .hover)

        vc.color = .appTextColor
        vc.comments = comment
        self.leaveApprovalVC?.navigationController?.present(vc, animated: true)
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
        leaveApprovalVC.callAPI(vm: UserStatisticsVM()) {[weak self] approvalist in
            Shared.instance.removeLoaderInWindow()
            guard let welf = self, let approvalist = approvalist else {return}
            welf.approvalList = approvalist
            welf.toLoadData()
        }
    }
    
    func initTaps() {
        
        backHolderView.addTap {
            self.leaveApprovalVC.navigationController?.popViewController(animated: true)
        }
        
        backgroundView.addTap {
            self.didClose()
        }
    }
    
    func cellregistration() {
        approvalDetailsTable.register(UINib(nibName: "LeaveApprovalTVC", bundle: nil), forCellReuseIdentifier: "LeaveApprovalTVC")
    }
    
    func toLoadData() {
        approvalDetailsTable.delegate = self
        approvalDetailsTable.dataSource = self
        approvalDetailsTable.reloadData()
    }
    

    
    func setupUI() {
        self.backgroundColor = .appGreyColor
        approvalDetailsTable.backgroundColor = .clear
        approvalDetailsTable.separatorStyle = .none
        approvalDetailsTable.layer.cornerRadius = 5
        searchHolderView.layer.cornerRadius = 5
        searchTF.delegate = self
        backgroundView.isHidden = true
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
        
        tpDeviateReasonView = self.leaveApprovalVC.loadCustomView(nibname: XIBs.tpDeviateReasonView) as? TPdeviateReasonView
        tpDeviateReasonView?.delegate = self
        
        tpDeviateReasonView?.addedSubviewDelegate = self
        tpDeviateReasonView?.isForRemarks = false
        tpDeviateReasonView?.isForRejection = true
        tpDeviateReasonView?.setupui()
        self.addSubview(tpDeviateReasonView ?? TPdeviateReasonView())
    }

}
extension LeaveApprovalView : addedSubViewsDelegate {
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
            self.searchTF.text = ""
          //  self.leaveApprovalVC.navigationController?.popViewController(animated: true)
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
extension LeaveApprovalView : SessionInfoTVCDelegate {
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
                if !LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                    toCreateToast("Please connect to active internet")
                    return
                }
                Shared.instance.showLoaderInWindow()
                
                leaveApprovalVC.leaveRejectAPI(vm: UserStatisticsVM()) {[weak self] result in
                    guard let welf = self else {return}
                    welf.isRemarksadded = false
                    welf.dayRemarks = ""
                    Shared.instance.removeLoaderInWindow()
                    if result?.isSuccess ?? false {
                        welf.toCreateToast( result?.checkinMasg ?? "Rejected successfully")
                        welf.callAPI()
                    } else {
                        welf.toCreateToast( result?.checkinMasg ?? "Unable to reject leave try again later.")
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
