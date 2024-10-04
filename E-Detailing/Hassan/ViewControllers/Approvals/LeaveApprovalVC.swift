//
//  LeaveApprovalVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/07/24.
//

import Foundation
import UIKit
class LeaveApprovalVC: BaseViewController {
    
    
    
    
    @IBOutlet var leaveApprovalView: LeaveApprovalView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    class func initWithStory() -> LeaveApprovalVC {
        let reportsVC : LeaveApprovalVC = UIStoryboard.Hassan.instantiateViewController()
        return reportsVC
    }
    
    
    
    func callAPI( vm: UserStatisticsVM, completion: @escaping([LeaveApprovalDetail]?) -> ()) {
      //  {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"getlvlapproval","sfcode":"MGR1244","division_code":"44,","Rsf":"MR6029"}
       //  http://sanffa.info/iOSServer/db_api.php/?axn=get%2Fapprovals
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["tableName"] = "getlvlapproval"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
      //  param["Trans_SlNo"] = transNumber
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.getLeaveArrovalDetail(params: toSendData, api: .approvals, paramData: param) { result in
            
            switch result {
                
            case .success(let response):
                if response.isEmpty {
                    self.toCreateToast("Leave Approvals not Available")
                    self.navigationController?.popViewController(animated: true)
                }
                dump(response)
                completion(response)
            case .failure(let error):
                dump(error)
                completion(nil)
            }
            
        }
        
    }
    
    func leaveApprovalAPI(vm: UserStatisticsVM, completion: @escaping(GeneralResponseModal?) -> ()) {
        
     //   {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","battery":"37","tableName":"leaveapproverej","LvID":"155324","LvAPPFlag":"0","RejRem":"","sfcode":"MGR1244","division_code":"44","Rsf":""}

      //  http://sanffa.info/iOSServer/db_api.php/?axn=save%2Fapprovals
        
        guard let approvalList = leaveApprovalView.isSearched ?  leaveApprovalView.filteredApprovalList : leaveApprovalView.approvalList,  !approvalList.isEmpty else {
            return
        }
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["tableName"] = "leaveapproverej"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = appsetup.sfCode
        //approvalList[self.leaveApprovalView.selectedActionIndex ?? 0].sfCode
        param["division_code"] = appsetup.divisionCode
        param["Designation"] = appsetup.desig
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        param["LvID"] = approvalList[self.leaveApprovalView.selectedActionIndex ?? 0].lvID
        param["LvAPPFlag"] = "0"

        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveDCR(params: toSendData, api: .dcrApproval, paramData: param) { result in
            
            switch result {
                
            case .success(let response):
                dump(response)
                completion(response)
            case .failure(let error):
                dump(error)
                completion(nil)
            }
            
        }
    }
    
    func leaveRejectAPI(vm: UserStatisticsVM, completion: @escaping(GeneralResponseModal?) -> ()) {
        guard let approvalList = leaveApprovalView.isSearched ?  leaveApprovalView.filteredApprovalList : leaveApprovalView.approvalList,  !approvalList.isEmpty else {
            return
        }


      //  {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","battery":"37","tableName":"leaveapproverej","LvID":"155324","LvAPPFlag":"0","RejRem":"","sfcode":"MGR1244","division_code":"44","Rsf":""}
        
    //   http://sanffa.info/iOSServer/db_api.php/?axn=save%2Fapprovals
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["tableName"] = "leaveapproverej"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = appsetup.sfCode
        //approvalList[self.leaveApprovalView.selectedActionIndex ?? 0].sfCode
        param["division_code"] = appsetup.divisionCode
        param["Designation"] = appsetup.desig
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        param["RejRem"] = self.leaveApprovalView.dayRemarks
        param["LvID"] = approvalList[self.leaveApprovalView.selectedActionIndex ?? 0].lvID
        param["LvAPPFlag"] = "1"
     //   model.activityDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
        
      //  param["date"] = approvalList[leaveApprovalView.selectedBrandsIndex ?? 0].da
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveDCR(params: toSendData, api: .dcrApproval, paramData: param) { result in
            
            switch result {
                
            case .success(let response):
                dump(response)
                completion(response)
            case .failure(let error):
                dump(error)
                completion(nil)
            }
            
        }
    }
    
}
