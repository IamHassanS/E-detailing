//
//  ReportsVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import UIKit

class ReportsVC: BaseViewController {

    
    enum PageType {
        case reports
        case approvals
        case myResource
    }
    
    @IBOutlet var reportsView: ReportsView!
    var pageType: PageType = .reports
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory(pageType: PageType) -> ReportsVC {
        let reportsVC : ReportsVC = UIStoryboard.Hassan.instantiateViewController()
      //  tourPlanVC.homeVM = HomeViewModal()
        reportsVC.pageType = pageType
        return reportsVC
    }
    
    func fetchApprovals(vm: UserStatisticsVM, completion: @escaping (ApprovalsCountModel?) -> () ){
        let appsetup = AppDefaults.shared.getAppSetUp()
       // {"tableName":"getapprovalcheck","sfcode":"MGR1753","division_code":"22,","Rsf":"MR6427","sf_type":"2","Designation":"MGR","state_code":"41","subdivision_code":"90,179,19,114,","Tp_need":"0","geotag_need":"0","TPdev_need":"0"}
        var param: [String: Any] = [:]
        param["tableName"] = "getapprovalcheck"
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
        vm.getArrovalCounts(params: toSendData, api: .approvals, paramData: param) { result in
            
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
