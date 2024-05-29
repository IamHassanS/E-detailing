//
//  UserStatisticsVC.swift
//  E-Detailing
//
//  Created by San eforce on 14/02/24.
//

import Foundation
import UIKit
import CoreData






class UserStatisticsVC: BaseViewController {
    
    
    @IBOutlet var userStatisticsView: UserStatisticsVIew!
    var userStstisticsVM : UserStatisticsVM?
    var links = [QuicKLink]()
    var dcrCount = [DcrCount]()
    var eventArr : [String] = []
    var menuList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    class func initWithStory()-> UserStatisticsVC{
        
        let view : UserStatisticsVC = UIStoryboard.Hassan.instantiateViewController()
        view.userStstisticsVM = UserStatisticsVM()
        return view
    }
    
    
    func initNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
    }
    
    @objc override func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let status = dict["Type"] as? String{
                DispatchQueue.main.async {
                    if status == "No Connection" {
                        //   self.toSetPageType(.notconnected)
                        self.toCreateToast("Please check your internet connection.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: false)
                      //  self.segmentControlForDcr.selectedSegmentIndex = 2
                      //  self.segmentControlForDcr.sendActions(for: .valueChanged)
                    } else if  status == "WiFi" || status ==  "Cellular"   {
                        
                        self.toCreateToast("You are now connected.")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isConnectedToNetwork, value: true)
                        self.toretryDCRupload( date: "") {isCompleted in
                            if isCompleted {
                               // self.toSetParams()
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    func toretryDCRupload( date: String, completion: @escaping (Bool) -> Void) {
    
        let paramData = LocalStorage.shared.getData(key: .outboxParams)
        var localParamArr = [String: [[String: Any]]]()
        do {
            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
            dump(localParamArr)
        } catch {
            self.toCreateToast("unable to retrive")
        }
        
        var specificDateParams : [[String: Any]] = [[:]]
        
        
        if date.isEmpty {
            localParamArr.forEach { key, value in
                
                specificDateParams = value
                
            }
        } else {
            localParamArr.forEach { key, value in
                if key == date {
                    dump(value)
                    specificDateParams = value
                }
            }
        }
        
        print("specificDateParams has \(specificDateParams.count) values")
        if !localParamArr.isEmpty {
            toSendParamsToAPISerially(index: 0, items: specificDateParams) { isCompleted in
                if isCompleted {
                    Shared.instance.removeLoaderInWindow()
                    self.toSetParams()
                    completion(true)
                }
            }
        } else {
            Shared.instance.removeLoaderInWindow()
            completion(true)
        }
        
    }
    
    func toSetParams() {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        var params = [String : Any]()
        params["tableName"] = "gettodycalls"
        params["sfcode"] =  appsetup.sfCode ?? ""
        params["ReqDt"] = date
        params["division_code"] = appsetup.divisionCode ?? ""
        params["Rsf"] = appsetup.sfCode ?? ""
        params["sf_type"] = appsetup.sfType ?? ""
        params["Designation"] = appsetup.dsName ?? ""
        params["state_code"] = appsetup.stateCode ?? ""
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        print(params)
        getTodayCalls(toSendData, paramData: params)
    }
    
    func getTodayCalls(_ param: [String: Any], paramData: JSON) {
        Shared.instance.showLoaderInWindow()
        userStstisticsVM?.getTodayCallsData(params: param, api: .getTodayCalls, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.userStatisticsView.todayCallsModel = response
                // Shared.instance.removeLoader(in: self.view)
                self.userStatisticsView.setupCalls(response: response)
                dump(response)
                Shared.instance.removeLoaderInWindow()
            case .failure(let error):
                //  Shared.instance.removeLoader(in: self.view)
                
                print(error.localizedDescription)
                self.view.toCreateToast("Error while fetching response from server.")
                Shared.instance.removeLoaderInWindow()
                
            }
        }
    }
    
    func toSendParamsToAPISerially(index: Int, items: [JSON], completion: @escaping (Bool) -> Void) {
        
        guard index < items.count else {
            // All items processed, exit the recursion
            DispatchQueue.main.async {
                self.userStatisticsView.toLoadOutboxTable()
            }
            
            return
        }
        
        let params = items[index]
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: params)
        
        // Perform your asynchronous task or function
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        
        if params.isEmpty {
            completion(true)
            return
        }
        self.sendAPIrequest(toSendData, paramData: params) { iscompleted in
            completion(iscompleted)
            let nextIndex = index + 1
            self.toSendParamsToAPISerially(index: nextIndex, items: items) {_ in}
            
        }
        // Handle the result if needed
        
        // Move to the next item
        
    }
    
    
    func initDataSource() {
         menuList = ["Refresh","Tour Plan","Create Presentation","Leave Application","Reports","Activiy","Near Me","Quiz","Survey","Forms","Profiling"]
        
         eventArr = ["Weekly off","Field Work","Non-Field Work","Holiday","Missed Released","Missed","Re Entry","Leave","TP Devition Released","TP Devition"]//,"Leave Aprroval Pending","Approval Pending"]
    }
    
    func sendAPIrequest(_ param: [String: Any], paramData: JSON, completion: @escaping (Bool) -> Void) {
        Shared.instance.showLoaderInWindow()
        userStstisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                
                dump(response)
                if response.msg == "Call Already Exists" {
                    // self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: jsonDatum)
                    self.toCreateToast(response.msg!)
                    self.toRemoveOutboxandDefaultParams(param: paramData)
                } else {
                    self.toRemoveOutboxandDefaultParams(param: paramData)
                    
                    //   self.saveCallsToDB(issussess: true, appsetup: appsetup, cusType: cusType, param: jsonDatum)
                }
                
                completion(true)
                //  Shared.instance.removeLoaderInWindow()
            case .failure(let error):
                //   self.saveCallsToDB(issussess: false, appsetup: appsetup, cusType: cusType, param: jsonDatum)
                
                print(error.localizedDescription)
                self.view.toCreateToast("Error uploading data try again later.")
                
                completion(true)
                //   Shared.instance.removeLoaderInWindow()
                
                return
            }
            
        }
    }
    
    func toRemoveOutboxandDefaultParams(param: JSON) {
        
        
        //to remove object from Local array and core data
        
        let filteredValues =  self.userStatisticsView.outBoxDataArr?.filter({ outBoxCallModel in
            outBoxCallModel.custCode != param["CustCode"] as! String
        })
        
        self.userStatisticsView.outBoxDataArr = filteredValues
        
        
        self.userStatisticsView.homeDataArr.forEach { aHomeData in
            if aHomeData.custCode == param["CustCode"] as? String {
                aHomeData.isDataSentToAPI = "1"
            }
        }
        let identifier = param["CustCode"] as? String

        let context = DBManager.shared.managedContext()
        
        let fetchRequest: NSFetchRequest<HomeData> = HomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", identifier ?? "")
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingObject = results.first {
                // Object found, update isDataSentToAPI
                existingObject.isDataSentToAPI = "1"
                
                // Save the context to persist changes
                DBManager.shared.saveContext()
            } else {
                // Object not found, handle accordingly
            }
        } catch {
            // Handle fetch error
        }
        
        
        //to remove values from User defaults values
        
        let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.outboxParams)
        
        
        var localParamArr = [String: [[String: Any]]]()
        do {
            localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
            dump(localParamArr)
        } catch {
            self.toCreateToast("unable to retrive")
        }
        
        
        let custCodeToRemove = param["CustCode"] as! String
        
        // Iterate through the dictionary and filter out elements with the specified CustCode
        localParamArr = localParamArr.mapValues { callsArray in
            return callsArray.filter { call in
                if let custCode = call["CustCode"] as? String {
                    if custCode == custCodeToRemove {
                        print("Removing element with CustCode: \(custCode)")
                        return false
                    }
                }
                return true
            }
        }
        // Remove entries where the filtered array is empty
        localParamArr = localParamArr.filter { _, callsArray in
            return !callsArray.isEmpty
        }
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
        
        
        //            var jsonDatum = Data()
        //
        //            do {
        //                let jsonData = try JSONSerialization.data(withJSONObject: localParamArr, options: [])
        //                jsonDatum = jsonData
        //                // Convert JSON data to a string
        //                if let tempjsonString = String(data: jsonData, encoding: .utf8) {
        //                    print(tempjsonString)
        //
        //                }
        //            } catch {
        //                print("Error converting parameter to JSON: \(error)")
        //            }
        
        LocalStorage.shared.setData(LocalStorage.LocalValue.outboxParams, data: jsonDatum)
        
        
        
        // Create a new array with modified sections
        let updatedSections = obj_sections.map { section -> Section in
            var updatedSection = section
            
            // Filter items in the section
            updatedSection.items = section.items.filter { call in
                // Assuming custCode is not an optional type
                return call.custCode != custCodeToRemove
            }
            
            // Keep the section if it still has items after filtering
            return updatedSection
        }
        
        
        
        
        
        // Assign the updated array back to obj_sections
        obj_sections = updatedSections.filter({ section in
            !section.items.isEmpty
        })
        
        print(obj_sections)
        
        
    }
    
    
    private enum Constants {
        static let spacing: CGFloat = 1
    }
    
}



