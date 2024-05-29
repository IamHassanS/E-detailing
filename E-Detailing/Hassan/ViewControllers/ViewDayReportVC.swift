//
//  ViewDayReportVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import Foundation
import UIKit
class ViewDayReportVC: BaseViewController {
    var reportsVM : ReportsVM?
    var reportsModel : ReportsModel?
    var isToReduceLocationHeight : Bool = false
    var appdefaultSetup : AppSetUp? = nil
    @IBOutlet weak var dayReportView: DayReportView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func initWithStory(model: ReportsModel) -> ViewDayReportVC {
        let tourPlanVC : ViewDayReportVC = UIStoryboard.Hassan.instantiateViewController()
      //  tourPlanVC.homeVM = HomeViewModal()
        tourPlanVC.reportsModel = model
        tourPlanVC.reportsVM = ReportsVM()
        return tourPlanVC
    }
    
    func toSetParamsAndGetResponse(_ type: Int) {
       // let appdefaultSetup = AppDefaults.shared.getAppSetUp()
       // let dateFormatter = DateFormatter()

   //     {"tableName":"getvwvstdet","ACd":"SE74-2280","typ":"1","sfcode":"MR0026","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,"}
        
       // if type == 1 {
           // return
           // self.dayReportView.initialSerups()
       // }
        
        var param = [String: Any]()
        param["tableName"] = "getvwvstdet"
        param["ACd"] = reportsModel?.aCode
        //"SE74-2280"
        param["sfcode"] = appdefaultSetup?.sfCode
        //"MR2697"
        //appdefaultSetup.sfCode
      //  if type != 0 {
            param["typ"] = type
       // }
       
        param["sf_type"] = appdefaultSetup?.sfType
        //"1"
        //appdefaultSetup.sfType
       // param["SFName"] =
        //appdefaultSetup.sfName
        param["division_code"] = appdefaultSetup?.divisionCode
        //"8"
        //appdefaultSetup.divisionCode
        param["Rsf"] =  LocalStorage.shared.getString(key: .selectedRSFID)
        //appdefaultSetup?.sfCode
        //"MR0026"
        //appdefaultSetup.sfCode
        param["Designation"] = appdefaultSetup?.dsName
        //"TBM"
        //appdefaultSetup.dsName
        param["state_code"] = appdefaultSetup?.stateCode
        //"28"
        //appdefaultSetup.stateCode
        param["subdivision_code"] = appdefaultSetup?.subDivisionCode
        //"62"
  

        
        
        dump(param)
        
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        
//        var jsonDatum = Data()
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
//            jsonDatum = jsonData
//            // Convert JSON data to a string
//            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
//                print(tempjsonString)
//
//            }
//
//
//        } catch {
//            print("Error converting parameter to JSON: \(error)")
//        }
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        getReporsAPIResponse(toSendData, paramData: param)
    }
    

    func getReporsAPIResponse(_ param: [String: Any], paramData: JSON){
        Shared.instance.showLoader(in: dayReportView)
        reportsVM?.getDetailedReportsData(params: param, api: .getReports, paramData: paramData) { result in
            switch result {
            case .success(let response):
                dump(response)
                self.dayReportView.detailedReportsModelArr = response
                self.dayReportView.initialSerups()
               // self.reportsView.setupUI()
                dump(response)
                Shared.instance.removeLoader(in: self.dayReportView)
            case .failure(let error):
                print(error.localizedDescription)
                Shared.instance.removeLoader(in: self.dayReportView)
                self.dayReportView.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    
}
