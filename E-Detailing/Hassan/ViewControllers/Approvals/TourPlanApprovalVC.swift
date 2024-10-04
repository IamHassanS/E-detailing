//
//  TourPlanApprovalVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/07/24.
//

import Foundation
import UIKit

struct TPdetailParam{
    let month: String
    let year: String
    let sfcode: String
}

class TourPlanApprovalVC: BaseViewController {
    
    
    
    
    @IBOutlet var tourPlanApprovalView: TourPlanApprovalView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    class func initWithStory() -> TourPlanApprovalVC {
        let reportsVC : TourPlanApprovalVC = UIStoryboard.Hassan.instantiateViewController()
        return reportsVC
    }
    
    
    func fetchTPapproval(vm: UserStatisticsVM, completion: @escaping([TourPlanApprovalModel]?) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()
      //  {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"gettpapproval","sfcode":"MGR1244","division_code":"44,","Rsf":"MR6029"}
        var param: [String: Any] = [:]
        param["tableName"] = "gettpapproval"
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
        
        vm.getTPapprovals(params: toSendData, api: .approvals, paramData: param) { result in
            
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
    
    

    
    func getTPapprovalDetail(additionalparam: TPdetailParam, vm: UserStatisticsVM, completion: @escaping([TourPlanApprovalDetailModel]?) -> ()) {
        let appsetup = AppDefaults.shared.getAppSetUp()
//        {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","battery":"25","tableName":"gettpdetail","sfcode":"MGR1705","Month":"7","Year":"2024","division_code":"44,","Rsf":"MG1705"}
        
        var param: [String: Any] = [:]
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfname"] = appsetup.sfName
        param["sf_type"] = "\(appsetup.sfType ?? 0)"
        param["Designation"] = appsetup.desig
        param["state_code"] = "\(appsetup.stateCode ?? 0)"
        param["subdivision_code"] = appsetup.subDivisionCode
        param["tableName"] = "gettpdetail"
        param["sfcode"] =  additionalparam.sfcode
        param["Month"] =  additionalparam.month.toDate(format: "MMMM").toString(format: "M")
        param["Year"] = additionalparam.year
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] =   additionalparam.sfcode
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.getTPapprovalDetail(params: toSendData, api: .getAllPlansData, paramData: param) { result in
            
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
    
    func approveAPI(additionalparam: TPdetailParam, vm: UserStatisticsVM, completion : @escaping(GeneralResponseModal?) ->()) {
       // {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"savetpapproval","sfcode":"MGR1244","Month":"7","Year":"2024","division_code":"44,","Rsf":"MGR3313"}
      //   http://sanffa.info/iOSServer/db_api.php/?axn=save%2Ftp
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfname"] = appsetup.sfName
        param["sf_type"] = "\(appsetup.sfType ?? 0)"
        param["Designation"] = appsetup.desig
        param["state_code"] = "\(appsetup.stateCode ?? 0)"
        param["subdivision_code"] = appsetup.subDivisionCode
        param["tableName"] = "savetpapproval"
        param["sfcode"] =  appsetup.sfCode
        param["Month"] =  additionalparam.month
        param["Year"] = additionalparam.year
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] =   additionalparam.sfcode
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveTP(params: toSendData, api: .sendToApproval, paramData: param) { result in
            
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
    
    func rejectAPI(additionalparam: TPdetailParam, vm: UserStatisticsVM, completion : @escaping(GeneralResponseModal?) ->()) {
       // {"AppName":"SAN ZEN","Appver":"Test.H.8","Mod":"Android-Edet","sf_emp_id":"2","sfname":"SELVA ASM","Device_version":"10","Device_name":"HUAWEI - KOB2-L09","language":"en","sf_type":"2","Designation":"MGR","state_code":"12","subdivision_code":"170,","key":"mark2023","Configurl":"http:\/\/sanffa.info\/","tableName":"savetpreject","sfcode":"MGR1244","Month":"6","Year":"2024","reason":"9kjhu\n","division_code":"44,","Rsf":"MGR3313"}
        // http://sanffa.info/iOSServer/db_api.php/?axn=save%2Ftp
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param: [String: Any] = [:]
        param["sf_emp_id"] = appsetup.sfEmpId
        param["sfname"] = appsetup.sfName
        param["sf_type"] = "\(appsetup.sfType ?? 0)"
        param["Designation"] = appsetup.desig
        param["state_code"] = "\(appsetup.stateCode ?? 0)"
        param["subdivision_code"] = appsetup.subDivisionCode
        param["tableName"] = "savetpreject"
        param["sfcode"] =  appsetup.sfCode
        param["Month"] =  additionalparam.month
        param["Year"] = additionalparam.year
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] =   additionalparam.sfcode
        param["reason"] = self.tourPlanApprovalView.dayRemarks
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String : Any]()
         toSendData["data"] = jsonDatum
        
        vm.approveTP(params: toSendData, api: .sendToApproval, paramData: param) { result in
            
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
