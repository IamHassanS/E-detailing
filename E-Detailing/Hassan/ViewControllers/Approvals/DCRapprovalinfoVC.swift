//
//  DCRapprovalinfoVC.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import Foundation
import UIKit



class DCRapprovalinfoVC: BaseViewController {
    var selectedList: ApprovalsListModel?
    var approvalDetail: ApprovalDetailsModel?
    var allApprovals: [ApprovalDetailsModel]?
    var filteredApprovals: [ApprovalDetailsModel]?
    var reportsVM: ReportsVM?
    @IBOutlet var dcrApprovalinfoView: DCRapprovalinfoView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory(model: ApprovalDetailsModel, allApprovals: [ApprovalDetailsModel], selectedList: ApprovalsListModel) -> DCRapprovalinfoVC {
        let reportsVC : DCRapprovalinfoVC = UIStoryboard.Hassan.instantiateViewController()
        reportsVC.approvalDetail = model
        reportsVC.allApprovals = allApprovals
        reportsVC.selectedList = selectedList
        return reportsVC
    }
    
    func makeRcpaApiCall(completion: @escaping ([RCPAresonseModel]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        var param: [String: Any] = [:]
        param["tableName"] = "getdcr_rcpa"
        param["dcrdetail_cd"] = approvalDetail?.transDetailSlno
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = selectedList?.sfCode ?? ""
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getDetailedRCPAdetais(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.dcrApprovalinfoView.rcpaResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                let aRCPAresonseModel = RCPAresonseModel()
                self.dcrApprovalinfoView.rcpaResponseModel.append(aRCPAresonseModel)
                self.dcrApprovalinfoView.rcpaResponseModel.append(contentsOf: response)
                completion(self.dcrApprovalinfoView.rcpaResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    
    func makeSlidesInfoApiCall(completion: @escaping ([SlideDetailsResponse]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
        // {"tableName":"getslidedet","ACd":"KS134-306","Mslcd":"KS134-73","sfcode":"MR7224","division_code":"47","Rsf":"MR7224","sf_type":"1","Designation":"0","state_code":"15","subdivision_code":"84,"}
        var param: [String: Any] = [:]
        param["tableName"] = "getslidedet"
        param["Mslcd"] =  approvalDetail?.transDetailSlno
       // param["ACd"] = selectedList?.transSlNo
        
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] =  selectedList?.sfCode ?? ""
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getSlideDetails(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.dcrApprovalinfoView.slidesResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                let aRCPAresonseModel = SlideDetailsResponse()
                self.dcrApprovalinfoView.slidesResponseModel.append(aRCPAresonseModel)
                self.dcrApprovalinfoView.slidesResponseModel.append(contentsOf: response)
                completion(self.dcrApprovalinfoView.slidesResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    
    func makeEventsInfoApiCall(completion: @escaping ([EventResponse]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
      //  {"tableName":"getevent_rpt","dcr_cd":"DP3-819","dcrdetail_cd":"DP3-1288","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,"}
        var param: [String: Any] = [:]
        param["tableName"] = "getevent_rpt"
       // param["dcr_cd"] = selectedList?.aCode
        //detailedReportModel?.a
        param["dcrdetail_cd"] = approvalDetail?.transDetailSlno
        
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = selectedList?.sfCode ?? ""
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getDetailedEventsdetais(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.dcrApprovalinfoView.eventsResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                self.dcrApprovalinfoView.eventsResponseModel.append(contentsOf: response)
                completion(self.dcrApprovalinfoView.eventsResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }


}
