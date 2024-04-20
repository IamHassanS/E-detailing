//
//  swift
//  E-Detailing
//
//  Created by San eforce on 20/03/24.
//

import Foundation
import UIKit
import CoreData
class AddCallinfoVC: BaseViewController {
    @IBOutlet var addCallinfoView: AddCallinfoView!
    let appsetup = AppDefaults.shared.getAppSetUp()
    var dcrCall : CallViewModel!
    var userStatisticsVM: UserStatisticsVM?
 
    var  latitude: Double?
    var longitude: Double?
    var address: String?
    
    class func initWithStory(viewmodel: UserStatisticsVM) -> AddCallinfoVC {
        let reportsVC : AddCallinfoVC = UIStoryboard.Hassan.instantiateViewController()
        reportsVC.userStatisticsVM = viewmodel
       // reportsVC.pageType = pageType
        return reportsVC
    }
    
    
    func setupParam(dcrCall: CallViewModel) {
        var productData = [[String : Any]]()
        var inputData = [[String : Any]]()
        var jointWorkData = [[String : Any]]()
        var additionalCallData = [[String : Any]]()
        var rcpaData = [[String : Any]]()
        
        
        let productValue = self.addCallinfoView.productSelectedListViewModel.productData()
        let inputValue = self.addCallinfoView.inputSelectedListViewModel.inputData()
        let jointWorkValue = self.addCallinfoView.jointWorkSelectedListViewModel.getJointWorkData()
        let additionalCallValue = self.addCallinfoView.additionalCallListViewModel.getAdditionalCallData()
        let rcpaValue =  self.addCallinfoView.rcpaDetailsModel
        
        
        let slides : [String : Any] = ["Slide" : "", "SlidePath" : "", "SlideRemarks" : "", "SlideType" : "", "SlideRating" : "", "Times" : "times"]
        
        for product in productValue {
            let product : [String : Any] = ["Code" : product.code , "Name" : product.name, "Group" : "", "ProdFeedbk" : "", "Rating" : "", "Timesline" : "timesLine", "Appver" : "", "Mod" : "", "SmpQty" : product.sampleCount, "RxQty" : product.rxCount , "prdfeed" : "", "Type" : "", "StockistName" : "", "StockistCode" : "", "Slides" : slides]
            productData.append(product)
        }
        
        
        for input in inputValue{
            let input = ["Code" : input.code , "Name" : input.name, "IQty" : input.inputCount]
            inputData.append(input)
        }

        for jointWork in jointWorkValue{
            let jointWork = ["Code" : jointWork.code , "Name" : jointWork.name]
            jointWorkData.append(jointWork)
        }

        for call in additionalCallValue {

            let products = call.productSelectedListViewModel.productData()

            let inputs = call.inputSelectedListViewModel.inputData()

            var callProductData = [[String : Any]]()
            var callInputData = [[String : Any]]()

            for input in inputs{
                let input = ["Code" : input.code , "Name" : input.name, "IQty" : input.inputCount]
                callInputData.append(input)
            }

            for product in products {
                let product : [String : Any] = ["Code" : product.code , "Name" : product.name,"SmpQty" : product.sampleCount]
                callProductData.append(product)
            }

            let adcuss : [String : Any] = ["Code" : call.docCode, "Name" : call.docName,"town_code" : call.docTownCode ,"town_name" : call.docTownName, "Products" : callProductData , "Inputs" : callInputData]
            additionalCallData.append(adcuss)
        }
        
        for rcpa in rcpaValue {

            let rcpaChemist = ["Name" : rcpa.addedChemist?.name , "Code" : rcpa.addedChemist?.code]

            rcpa.addedProductDetails?.addedProduct?.forEach{ aAddedProduct in
              
                var competitorData = [[String : Any]]()
                var productCode : String =    aAddedProduct.addedProduct?.code ?? ""
                var productName : String =  aAddedProduct.addedProduct?.name ?? ""

//                for j in 0..<rcpa.rcpaChemist.products[i].rcpas.count {
//                    productCode = rcpa.rcpaChemist.products[i].rcpas[j].product?.code ?? ""
//                    productName = rcpa.rcpaChemist.products[i].rcpas[j].product?.name ?? ""
//
//                    let competitors  = [ "CPQty" : rcpa.rcpaChemist.products[i].rcpas[j].competitorQty,
//                                         "CPRate" : rcpa.rcpaChemist.products[i].rcpas[j].competitorRate,
//                                         "CPValue" : rcpa.rcpaChemist.products[i].rcpas[j].competitorTotal,
//                                         "CompCode" : rcpa.rcpaChemist.products[i].rcpas[j].competitorCompanyCode,
//                                         "CompName" : rcpa.rcpaChemist.products[i].rcpas[j].competitorCompanyName,
//                                         "CompPCode" : rcpa.rcpaChemist.products[i].rcpas[j].competitorBrandCode,
//                                         "CompPName" : rcpa.rcpaChemist.products[i].rcpas[j].competitorBrandName,
//                                         "Chemname" : rcpa.chemistName,
//                                         "Chemcode" : rcpa.chemistCode,
//                                         "CPRemarks" : rcpa.rcpaChemist.products[i].rcpas[j].remarks
//                    ]
//
//                    competitorData.append(competitors)
//                }

                let rcpa : [String : Any] = [ "Chemists" : [rcpaChemist],
                             "OPCode" : productCode, //rcpa.rcpaChemist.products[i].product.code ?? "",
                             "OPName" : productName, // rcpa.rcpaChemist.products[i].product.name ?? "",
                             "OPQty" : sumOfQuantities(corelatedStringArr: rcpa.addedProductDetails?.addedQuantity) ,
                             "OPRate" : sumOfQuantities(corelatedStringArr: rcpa.addedProductDetails?.addedRate),
                             "OPValue" : sumOfQuantities(corelatedStringArr: rcpa.addedProductDetails?.addedValue),
                             "Competitors" : competitorData
                ]

                rcpaData.append(rcpa)

            }
             // rcpaData.append(rcpa)
        }
        
        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")

        var cusType : String = ""

        switch self.dcrCall.type {
            case .doctor:
                cusType = "1"
            case .chemist:
                cusType = "2"
            case .stockist:
                cusType = "3"
            case .hospital:
                cusType = "6"
            case .cip:
                cusType = "5"
            case .unlistedDoctor:
                cusType = "4"
        }
        
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        
        var params = [String : Any]()
        params["tableName"] = "postDCRdata"
        params["JointWork"] = jointWorkData
        params["Inputs"] = inputData
        params["Products"] = productData
        params["AdCuss"] = additionalCallData
        params["RCPAEntry"] = rcpaData
        params["CateCode"] = dcrCall.cateCode
        params["CusType"] = cusType
        params["CustCode"] = dcrCall.code
        params["CustName"] = dcrCall.name
        params["Entry_location"] = "0.0:0.0"
        params["sfcode"] = appsetup.sfCode ?? ""
        params["Rsf"] = appsetup.sfCode ?? ""
        params["sf_type"] = "\(appsetup.sfType ?? 0)"
        params["Designation"] = appsetup.dsName ?? ""
        params["state_code"] = appsetup.stateCode ?? ""
        params["subdivision_code"] = appsetup.subDivisionCode ?? ""
        params["division_code"] = divisionCode
        params["AppUserSF"] = appsetup.sfCode ?? ""
        params["SFName"] = appsetup.sfName ?? ""
        params["SpecCode"] = dcrCall.specialityCode
        params["mappedProds"] = ""
        params["mode"]  = "0"
        params["Appver"] = "iEdet.1.1"
        params["Mod"] = "ios-Edet-New"
        params["WT_code"] = "2748"
        params["WTName"] = "Field Work"
        params["FWFlg"] = "F"
        params["town_code"] = dcrCall.townCode
        params["town_name"] = dcrCall.townName
        params["ModTime"] = date
        params["ReqDt"] = date
        params["vstTime"] = date
        params["Remarks"] =  self.addCallinfoView.overallRemarks ?? ""
        //self.txtRemarks.textColor == .lightGray ? "" : self.txtRemarks.text ?? ""
        params["amc"] = ""
        params["sign_path"] = ""
        params["SignImageName"] = ""
        params["filepath"] = ""
        params["EventCapture"] = ""
        params["EventImageName"] = ""
        params["DCSUPOB"] =  ""
        //self.txtPob.text ?? ""
        if let overallFeedback = self.addCallinfoView.overallFeedback {
            params["Drcallfeedbackcode"] = overallFeedback.id ?? ""
        }
        
        //(self.selectedFeedback == nil) ? "" : (self.selectedFeedback.code ?? "") ?? ""
        params["sample_validation"] = "0"
        params["input_validation"] = "0"
       

      //  Pipelines.shared.getAddressString(latitude: <#T##Double#>, longitude: <#T##Double#>, completion: <#T##(String?) -> Void#>)
       // let param = ["data" : params.toString()]

        Pipelines.shared.requestAuth() {[weak self] coordinates in
            guard let welf = self else {return}
            guard coordinates != nil else {
                welf.showAlert()
                return
            }
            welf.latitude = coordinates?.latitude
            welf.longitude = coordinates?.longitude
            Shared.instance.showLoaderInWindow()
            Pipelines.shared.getAddressString(latitude:   welf.latitude ?? Double(), longitude:   welf.longitude ?? Double()) { address in
                welf.address = address
                params["address"] =  address
                params["Entry_location"] = "\(welf.latitude ?? Double()):\(welf.longitude ?? Double())"
                //String(format: "%.6f:%.6f", welf.latitude ??  Double(), welf.longitude ??  Double())
                let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
                var toSendData = [String : Any]()

                toSendData["data"] = jsonDatum
                welf.callDCRScaeapi(toSendData: toSendData, params: params, cusType: cusType) { isPosted in
                    Shared.instance.removeLoaderInWindow()
                    if !isPosted {
                        welf.saveCallsToDB(issussess: isPosted, appsetup: welf.appsetup, cusType: cusType, param: params)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name("callsAdded"), object: nil)
                    }
                
                    
                    welf.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
                }
            }
            
        }

     
    }
    
    func showAlertToEnableLocation() {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: "E - Detailing", alertDescription: "Please enable location services in Settings.", okAction: "Cancel",cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
            self.redirectToSettings()
            
        }
    }
    
    func redirectToSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    
    func showAlert() {
        showAlertToEnableLocation()
    }
    
    
        private func popToBack<T>(_ VC : T) {
            let mainVC = navigationController?.viewControllers.first{$0 is T}
    
            if let vc = mainVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    
    func callDCRScaeapi(toSendData: JSON, params: JSON, cusType: String, completion: @escaping (Bool) -> () ) {
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
           // Shared.instance.showLoaderInWindow()
            postDCTdata(toSendData, paramData: params) { result in
                switch result {
                case .success(let model):
                   
                      
                        completion(model.isSuccess ?? false )
                
             
                case .failure(let error):
                  
                    self.toCreateToast("\(error)")
                    print(error)
                    completion(false)
            
                }
              
            }
        } else {
           completion(false)
        }
        
        func postDCTdata(_ param: [String: Any], paramData: JSON, _ completion : @escaping (Result<DCRCallesponseModel, UserStatisticsError>) -> Void)  {
           
            userStatisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
                completion(result)
            }
        }
    }
    
    func saveCallsToDB(issussess: Bool, appsetup: AppSetUp, cusType : String, param: [String: Any]) {
                var dbparam = [String: Any]()
                dbparam["CustCode"] = dcrCall.code
                dbparam["CustType"] = cusType
                dbparam["FW_Indicator"] = "F"
                dbparam["Dcr_dt"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
                dbparam["month_name"] = Date().toString(format: "MMMM")
                dbparam["Mnth"] = Date().toString(format: "MM")
                dbparam["Yr"] =  Date().toString(format: "YYYY")
                dbparam["CustName"] = dcrCall.name
                dbparam["town_code"] = dcrCall.townCode
                dbparam["town_name"] = dcrCall.territory
                dbparam["Dcr_flag"] = ""
                dbparam["SF_Code"] = appsetup.sfCode
                dbparam["Trans_SlNo"] = ""
                dbparam["AMSLNo"] = ""
                dbparam["isDataSentToAPI"] = issussess == true ?  "1" : "0"
                dbparam["successMessage"] = issussess ? "call Aldready Exists" : "Waiting to sync"
                 dbparam["checkinTime"] = dcrCall.dcrCheckinTime
                 dbparam["checkOutTime"] = dcrCall.dcrCheckOutTime
                var dbparamArr = [[String: Any]]()
                dbparamArr.append(dbparam)
                let masterData = DBManager.shared.getMasterData()
                var HomeDataSetupArray = [UnsyncedHomeData]()
                for (index,homeData) in dbparamArr.enumerated() {
        
             
                        let contextNew = DBManager.shared.managedContext()
                        let HomeDataEntity = NSEntityDescription.entity(forEntityName: "UnsyncedHomeData", in: contextNew)
                        let HomeDataSetupItem = UnsyncedHomeData(entity: HomeDataEntity!, insertInto: contextNew)
                    
                     if  self.dcrCall.type == .chemist {
                         HomeDataSetupItem.custType = "2"
                       }
                       if  self.dcrCall.type == .stockist {
                           HomeDataSetupItem.custType = "3"
                         }
                       if  self.dcrCall.type == .doctor {
                           HomeDataSetupItem.custType = "1"
                         }
                       if  self.dcrCall.type == .hospital {
                           HomeDataSetupItem.custType = "6"
                         }
                       if  self.dcrCall.type == .unlistedDoctor {
                           HomeDataSetupItem.custType = "4"
                         }
                       if  self.dcrCall.type == .cip
                       {
                           HomeDataSetupItem.custType = "5"
                         }
                        HomeDataSetupItem.setValues(fromDictionary: homeData)
                        HomeDataSetupItem.index = Int16(index)
                        HomeDataSetupArray.append(HomeDataSetupItem)
              
                }
        
                HomeDataSetupArray.forEach{ (type) in
                    masterData.addToUnsyncedHomeData(type)
                }
                DBManager.shared.saveContext()
        
        if !issussess {
            saveParamoutboxParamtoDefaults(param: param)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("callsAdded"), object: nil)
    

    }
    
    func saveParamoutboxParamtoDefaults(param: JSON) {
        
        var callsByDay: [String: [[String: Any]]] = [:]
        
        let paramdate = param["vstTime"]
        var dayString = String()
        
        // Create a DateFormatter to parse the vstTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: paramdate as! String) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
             dayString = dateFormatter.string(from: date)
            
            // Check if the day key exists in the dictionary
            if callsByDay[dayString] == nil {
                callsByDay[dayString] = [param]
            } else {
                callsByDay[dayString]?.append(param)
            }
        }
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: callsByDay)
        
        
        let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.outboxParams)
        if paramData.isEmpty {
            LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
            return
        }
        var localParamArr = [String: [[String: Any]]]()
 
        do {
            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
            dump(localParamArr)
        } catch {
            self.toCreateToast("unable to retrive")
        }
        
        
        var matchFound = Bool()
        for (_, calls) in localParamArr {
            for call in calls {
                // if let vstTime = call["vstTime"] as? String,
                if  let custCode = call["CustCode"] as? String,
                    //   vstTime == param["vstTime"] as? String,
                    custCode == param["CustCode"] as? String {
                    // Match found, do something with the matching call
                    matchFound = true
                    print("Match found for CustCode: \(custCode)")
                    // vstTime: \(vstTime),
                    
                }
            }
        }
        
        if !matchFound {
            // Check if the day key exists in the dictionary
            if localParamArr[dayString] == nil {
                localParamArr[dayString] = [param]
            } else {
                localParamArr[dayString]?.append(param)
            }
            let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
            
            LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
        }
    }
    
    func sumOfQuantities(corelatedStringArr: [String]?) -> Int {
        guard let quantities = corelatedStringArr else {
            return 0 // Return 0 if the array is nil or empty
        }
        
        var sum = 0
        for quantityString in quantities {
            if let quantity = Int(quantityString) {
                sum += quantity
            } else {
                // Handle invalid string that cannot be converted to integer
                print("Invalid quantity string: \(quantityString)")
            }
        }
        return sum
    }
    

    
}


