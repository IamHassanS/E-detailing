//
//  DCRapprovalVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/07/24.
//

import Foundation
import UIKit
class DCRapprovalVC: BaseViewController {

    

    
    @IBOutlet var dcrApprovalView: DCRapprovalView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory() -> DCRapprovalVC {
        let reportsVC : DCRapprovalVC = UIStoryboard.Hassan.instantiateViewController()
        return reportsVC
    }
    
    
    func fetchFirstIndex() {
    
       
  
        
        guard let approvalList = dcrApprovalView.approvalList,  !approvalList.isEmpty else {
            return
        }

        let model = approvalList[0]
        dcrApprovalView.selectedBrandsIndex = 0
        dcrApprovalView.approvalTable.reloadData()
            Shared.instance.showLoaderInWindow()
            fetchApprovalDetail(transNumber: model.transSlNo, vm: UserStatisticsVM()) {[weak self] approvalDetailModel in
                guard let welf = self else {return}
                Shared.instance.removeLoaderInWindow()
                guard let approvalDetailModel = approvalDetailModel else {return}
                //dump(approvalDetailModel)
                welf.dcrApprovalView.selectedType = .All
                welf.dcrApprovalView.approvalDetails = approvalDetailModel
                welf.dcrApprovalView.loadApprovalDetailTable()
            }
        
    }
    
    func fetchApprovalList(vm: UserStatisticsVM, completion: @escaping([ApprovalsListModel]?) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()
        //{"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"4474","sfname":"VENKATA KALYAN R","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"2","subdivision_code":"103,","key":"alpt1612","Configurl":"http:\/\/edetailing.sanffa.info\/","tableName":"getvwdcr","sfcode":"MGR3083","division_code":"70,","Rsf":"MR7723"}
        var param: [String: Any] = [:]
        param["tableName"] = "getvwdcr"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        param["Tp_need"] = appsetup.tpNeed
        param["geotag_need"] = appsetup.geoTagNeed
        param["TPdev_need"] = appsetup.tpNeed
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.getArrovalList(params: toSendData, api: .approvals, paramData: param) { result in
            
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
    
    
    func fetchApprovalDetail(transNumber: String, vm: UserStatisticsVM, completion: @escaping([ApprovalDetailsModel]?) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()
      //  {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"4474","sfname":"VENKATA KALYAN R","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"2","subdivision_code":"103,","key":"alpt1612","Configurl":"http:\/\/edetailing.sanffa.info\/","tableName":"getvwdcrone","Trans_SlNo":"AP67-399","sfcode":"MR8170","division_code":"70,","Rsf":"MR7723"}
        var param: [String: Any] = [:]
        param["tableName"] = "getvwdcrone"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        param["Trans_SlNo"] = transNumber
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.getArrovalDetail(params: toSendData, api: .approvals, paramData: param) { result in
            
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
    
    func dcrApprovalAPI(vm: UserStatisticsVM, completion: @escaping(GeneralResponseModal?) -> ()) {
        
     //   {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"dcrapproval","date":"01\/06\/2024","sfcode":"MGR1705","division_code":"44,","Rsf":""}

      //  http://sanffa.info/iOSServer/db_api.php/?axn=save%2Fapprovals
        
        guard let approvalList = dcrApprovalView.isSearched ?  dcrApprovalView.filteredApprovalList : dcrApprovalView.approvalList,  !approvalList.isEmpty else {
            return
        }
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["tableName"] = "dcrapproval"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = approvalList[self.dcrApprovalView.selectedBrandsIndex ?? 0].sfCode
        param["division_code"] = appsetup.divisionCode
        param["Designation"] = appsetup.desig
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        
     //   model.activityDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
        
        param["date"] = approvalList[dcrApprovalView.selectedBrandsIndex ?? 0].activityDate
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveDCR(params: toSendData, api: .dcrApproval, paramData: param) { result in
            
            switch result {
                
            case .success(let response):
                dump(response)
                completion(response)
                self.toCreateToast(response.checkinMasg ?? response.msg ?? "Approved Successfully")
            case .failure(let error):
                dump(error)
                completion(nil)
            }
            
        }
    }
    
    func dcrRejectAPI(vm: UserStatisticsVM, completion: @escaping(GeneralResponseModal?) -> ()) {
        
        guard let approvalList = dcrApprovalView.isSearched ?  dcrApprovalView.filteredApprovalList : dcrApprovalView.approvalList,  !approvalList.isEmpty else {
            return
        }


     //   {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"dcrreject","date":"01\/01\/1970","reason":"Reject\n","sfcode":"MGR1245","division_code":"44,","Rsf":""}
        
    //   http://sanffa.info/iOSServer/db_api.php/?axn=save%2Fapprovals
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["tableName"] = "dcrreject"
        param["sfname"] = appsetup.sfName
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfcode"] = approvalList[self.dcrApprovalView.selectedBrandsIndex ?? 0].sfCode
        param["division_code"] = appsetup.divisionCode
        param["Designation"] = appsetup.desig
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        param["reason"] = self.dcrApprovalView.dayRemarks
     //   model.activityDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
        
        param["date"] = approvalList[dcrApprovalView.selectedBrandsIndex ?? 0].activityDate
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveDCR(params: toSendData, api: .dcrApproval, paramData: param) { result in
            
            switch result {
                
            case .success(let response):
                dump(response)
                self.toCreateToast(response.checkinMasg ?? response.msg ?? "Rejected Successfully")
                completion(response)
            case .failure(let error):
                dump(error)
                completion(nil)
            }
            
        }
    }
}
