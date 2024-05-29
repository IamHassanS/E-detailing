//
//  DetailedReportVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import UIKit

class DetailedReportVC: BaseViewController {

    
    @IBOutlet var reportsView: DetailedReportView!
    var reportsVM : ReportsVM?
    var appdefaultSetup : AppSetUp? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory() -> DetailedReportVC {
        let tourPlanVC : DetailedReportVC = UIStoryboard.Hassan.instantiateViewController()
        tourPlanVC.reportsVM = ReportsVM()
     
        return tourPlanVC
    }
    func showAlertToEnableNetwork(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }

    }

    func toSetParamsAndGetResponse(_ selecteddate : Date) {
        
        if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
            self.showAlertToEnableNetwork(desc: "Please connect to network to fetch repots.")
            return
        }

        let date = selecteddate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-d"

    
            let finalFormattedString = dateFormatter.string(from: date)
        
        var param = [String: Any]()
        param["tableName"] = "getdayrpt"
        param["sfcode"] = appdefaultSetup?.sfCode
        //"MR2697"
        //appdefaultSetup.sfCode
        param["sf_type"] = appdefaultSetup?.sfType
        //"1"
        //appdefaultSetup.sfType
       // param["SFName"] =
        //appdefaultSetup.sfName
        param["divisionCode"] = appdefaultSetup?.divisionCode
        //"64"
        //appdefaultSetup.divisionCode
        param["Rsf"] = appdefaultSetup?.sfCode
        //"MR2697"
        //appdefaultSetup.sfCode
        param["Designation"] = appdefaultSetup?.dsName
        //"MR"
        //appdefaultSetup.dsName
        param["state_code"] = appdefaultSetup?.stateCode
        //"13"
        //appdefaultSetup.stateCode
        param["subdivision_code"] = appdefaultSetup?.subDivisionCode
        //"93"
        //appdefaultSetup.subDivisionCode

            print(finalFormattedString)
      
        param["rptDt"] = finalFormattedString
        //"2023-12-8"
        //"2023-12-8"
       // {"tableName":"getdayrpt","sfcode":"MR2697","sf_type":"1","divisionCode":"64,","Rsf":"MR2697","Designation":"MR","state_code":"13","subdivision_code":"93,","rptDt":"2023-12-8"}
        
        
        dump(param)
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        

        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        getReporsAPIResponse(toSendData, paramData: param)
    }
    

    func getReporsAPIResponse(_ param: [String: Any], paramData: JSON){
        Shared.instance.showLoader(in: reportsView)
        reportsVM?.getReportsData(params: param, api: .getReports, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.reportsView.reportsModel = response
                
                if response.isEmpty {
                    self.reportsView.noreportsView.isHidden = false
                } else {
                    self.reportsView.noreportsView.isHidden = true
                   
                }
                if self.reportsView.searchTF.text == "" {
                    self.reportsView.isMatched = false
                    self.reportsView.toLoadData()
                } else {
                    self.reportsView.isMatched = true
                    self.reportsView.toLoadData()
                    self.reportsView.toFilterResults(self.reportsView.searchTF.text ?? "")
                }
                Shared.instance.removeLoader(in: self.reportsView)
                dump(response)
                
            case .failure(let error):
                Shared.instance.removeLoader(in: self.reportsView)
                print(error.localizedDescription)
                self.reportsView.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    
}
