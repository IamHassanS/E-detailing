//
//  ConnectionHandler.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/11/23.
//


import Foundation
import UIKit
import Alamofire

final class ConnectionHandler : NSObject {
    
    enum TableName: String {
        case getDayPlan = "getmydayplan"
        case reports = "getdayrpt"
        case detailedReport = "getvwvstdet"
        case getToadyCalls = "gettodycalls"
        case checkin = "savetp_attendance"
        case getdcrdate = "getdcrdate"
        case gettodaydcr = "gettodaydcr"
        case getpreCalls = "getcuslvst"
    }
    
    static let shared = ConnectionHandler()
    private let alamofireManager : Session
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var preference = UserDefaults.standard
    let strDeviceType = "1"
    let strDeviceToken = "20591310"
    
    override init() {
        print("Singleton initialized")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300 // seconds
        configuration.timeoutIntervalForResource = 500
        alamofireManager = Session.init(configuration: configuration,
                                        serverTrustManager: .none)//Alamofire.SessionManager(configuration: configuration)
    }
    func getRequest(for api : APIEnums,
                    params : Parameters, istoDownload: Bool? = false, apiFilepath: String? = "") -> APIResponseProtocol{
        // + api.rawValue
        
        if istoDownload ?? false {
            return self.getRequest(forAPI: slideURL + (apiFilepath ?? ""),
                                   params: params,
                                   CacheAttribute: api.cacheAttribute ?  .none : api)
        }
        
        if api.method == .get {
            return self.getRequest(forAPI: api == .none ? AppConfigURL  + api.rawValue : APIUrl + api.rawValue,
                                   params: params,
                                   CacheAttribute: api.cacheAttribute ?  .none : api)
        } else {
            return self.postRequest(forAPI: api == .none ? AppConfigURL  + api.rawValue : APIUrl  + api.rawValue,
                                    params: params, CacheAttribute: api)
        }
    }
    
    func networkChecker(with StartTime:Date,
                        EndTime: Date,
                        ContentData: Data?) {
        
        let dataInByte = ContentData?.count
        
        if let dataInByte = dataInByte {
            
            // Standard Values
            let standardMinContentSize : Float = 3
            let standardKbps : Float = 2
            
            // Kb Conversion
            let dataInKb : Float = Float(dataInByte / 1000)
            
            // Time Interval Calculation
            let milSec  = EndTime.timeIntervalSince(StartTime)
            let duration = String(format: "%.01f", milSec)
            let dur: Float = Float(duration) ?? 0
            
            // Kbps Calculation
            let Kbps = dataInKb / dur
            
            if dataInKb > standardMinContentSize {
                if Kbps < standardKbps {
                    print("å:::: Low Network Kbps : \(Kbps)")
                    //   self.appDelegate.createToastMessage("LOW NETWORK")
                } else {
                    print("å:::: Normal NetWork Kbps : \(Kbps)")
                }
            } else {
                print("å:::: Small Content : \(Kbps)")
            }
            
        }
    }
    
    func postRequest(forAPI api: String, params: JSON, CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        let parameters = params
        let startTime = Date()
        alamofireManager.request(api,
                                 method: .post,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
        .responseJSON { (response) in
            print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))
            
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            switch response.result{
            case .success(let value):
                var ArrJSONseq = Array<JSON>()
                var jsonseq = JSON()
                if CacheAttribute == .none ||  CacheAttribute ==  .tableSetup {
                     ArrJSONseq = value as! Array<JSON>
                    
                } else {
                    jsonseq = value as! JSON
                }
                if response.response?.statusCode == 200{
                    //response.response.isSuccess
                    //|| !api.contains(APIUrl)
                   // ||
                    if CacheAttribute == .none  {
                     
                        responseHandler.handleArrSuccess(value: ArrJSONseq, data: response.data ?? Data())
                    } else if CacheAttribute == .tableSetup {
                      
                     jsonseq = ArrJSONseq[0]
                       
                        responseHandler.handleSuccess(value: jsonseq, data: response.data ?? Data())
                    }
                    else {
                        responseHandler.handleSuccess(value: jsonseq, data: response.data ?? Data())
                    }
                    //
                }else{
                   // responseHandler.handleFailure(value: json.status_message)
                }
            case .failure(let error):
                if error._code == 1001 {
                    responseHandler.handleFailure(value: "The request timed out.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    func getRequest(forAPI api: String,
                    params: JSON,
                    CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        let parameters = params
        let startTime = Date()
        
    
        var header = [String: String]()
        //HTTPHeaders = [.authorization(bearerToken: LocalStorage.shared.getString(key: .accessToken))]
           
            header["Accept"] = "application/json"
           // header["Authorization"] = LocalStorage.shared.getString(key: .accessToken)
        
        alamofireManager.request(api,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default)
        //,
    //headers: HTTPHeaders(header)
        .responseJSON { (response) in
            print("Å api : ",response.request?.url ?? ("\(api)\(params)"))
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            guard response.response?.statusCode != 503 else {
                //  Shared.instance.removeLoaderInWindow()
                return
            }
            guard response.response?.statusCode != 401 else{//Unauthorized
                if response.request?.url?.description.contains(APIUrl) ?? false{
                    //self.doLogoutActions()
                }
                return
            }
            switch response.result {
            case .success(let value):
                var ArrJSONseq = Array<JSON>()
                var jsonseq = JSON()
                if CacheAttribute == .none || CacheAttribute == .tableSetup{
                    ArrJSONseq = value as! Array<JSON>
                } else {
                    jsonseq = value as! JSON
                }
              
                if  response.response?.statusCode == 200 {
//                    json.isSuccess
//                        || !api.contains(APIUrl)
//                        ||
                    if CacheAttribute == .none || CacheAttribute == .tableSetup {
                        responseHandler.handleArrSuccess(value: ArrJSONseq, data: response.data ?? Data())
                    } else {
                        responseHandler.handleSuccess(value: jsonseq, data: response.data ?? Data())
                    }
                   
                    // ??
                    //,data:  Data()
                }else{
                  //  responseHandler.handleFailure(value: json.status_message)
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "Invalid URL".localizedCapitalized)
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "")
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    func uploadRequest(for api : APIEnums,
                       params : JSON,
                       data:JSON, imageName:String = "image")-> APIResponseProtocol {
        let startTime = Date()
        let responseHandler = APIResponseHandler()
        let param = params
       // param["token"] = LocalStorage.shared.getString(key: .accessToken)
     //   dump(param["tableName"])
 
        
        //uberSupport.showProgressInWindow(showAnimation: true)
        print(params)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                let multipartData = value as? Data ?? Data()
               // "\(value)".data(using: String.Encoding.utf8) ?? Data()
                
//                if let tempjsonString = String(data: multipartData, encoding: .utf8) {
//                    print(tempjsonString)
//                    multipartFormData.append(Data(tempjsonString.utf8), withName: "Data")
//                }
                
              
                
                multipartFormData.append(multipartData, withName: key as String)
                _ = String(data: multipartData, encoding: .utf8)
            }
            //"\(value)".data(using: String.Encoding.utf8)!
            
//            let fileName = String(Date().timeIntervalSince1970 * 1000) + "Image.jpg"
//            if data != Data(){
//                multipartFormData.append(data, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
//            }
        }, to: "\(APIUrl)\(api.rawValue)").response { results in
            
            let endTime = Date()
            

            self.networkChecker(with: startTime, EndTime: endTime, ContentData: results.data)
            
            switch results.result{
                
            case .success(let anyData):
                print("Succesfully uploaded")
                print(results.request?.url as Any)
                if let err = results.error{
                    responseHandler.handleFailure(value: err.localizedDescription)
                    //                                       self.appDelegate.createToastMessage(err.localizedDescription, bgColor: .black, textColor: .white)
                    return
                }

                if api == .getReports || api == .getTodayCalls || api == .masterData || api == .checkin || api == .home {
                    var encodedReportsModelData: [ReportsModel]?
                    var encodedDetailedReportsModelData: [DetailedReportsModel]?
                    var encodedMyDayPlanResponseModelData : [MyDayPlanResponseModel]?
                    var checkinModelData : [GeneralResponseModal]?
                    var encodedAdayCalls: [TodayCallsModel]?
                    var encodedDcrDates: [DCRdatesModel]?
                    var encodedPrecalls : [PrecallsModel]?
                    if data["tableName"] as! String == TableName.reports.rawValue {
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [ReportsModel].self) { result in
                           // decodecObj
                            switch result {
                            case .success(let decodecObj):
                                
                                encodedReportsModelData = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedReportsModelData)
    
                                    // Convert Swift object to JSON string
    
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedReportsModelData) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                            }
           
                        }
                    } else if data["tableName"] as! String == TableName.getToadyCalls.rawValue {
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [TodayCallsModel].self) { result in
                            
                            switch result {
                            case .success(let decodecObj):
                                encodedAdayCalls = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedAdayCalls)
                                    
                                    // Convert Swift object to JSON string
                                  
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedAdayCalls) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                            }
                            
                        }
                    }
                    else if data["tableName"] as! String == TableName.detailedReport.rawValue {
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [DetailedReportsModel].self) { result in
                            
                            switch result {
                            case .success(let decodecObj):
                                encodedDetailedReportsModelData = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedDetailedReportsModelData)
                                    
                                    // Convert Swift object to JSON string
                                  
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedDetailedReportsModelData) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                            }
                        }
                    }
                    else if data["tableName"] as! String == TableName.getDayPlan.rawValue || data["tableName"] as! String == TableName.gettodaydcr.rawValue  {
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [MyDayPlanResponseModel].self) { result in
                            switch result {
                            case .success(let decodecObj):
                                encodedMyDayPlanResponseModelData = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedMyDayPlanResponseModelData)
                                    
                                    // Convert Swift object to JSON string
                                  
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedMyDayPlanResponseModelData) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                            }
                            
                            
          
                            
                            
                            
                        }
                    } else if data["tableName"] as! String == TableName.checkin.rawValue {
                        
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [GeneralResponseModal].self){ result in
                            switch result {
                            case .success(let decodecObj):
                                checkinModelData = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(checkinModelData)
                                    
                                    // Convert Swift object to JSON string
                                    
                                    responseHandler.handleSuccess(value: self.convertToDictionary(checkinModelData) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                                
                            }
                            
                            
                            
                        }
                    }else if data["tableName"] as! String == TableName.getdcrdate.rawValue {
                        
                        
                        
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [DCRdatesModel].self) { result in
                            switch result {
                            case .success(let decodecObj):
                                encodedDcrDates = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedDcrDates)
                                    
                                    // Convert Swift object to JSON string
                                    
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedDcrDates) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                                
                            }
                            
                            
                            
                        }
                    }else if data["tableName"] as! String == TableName.getpreCalls.rawValue {
                        
                        self.toConvertDataToObj(responseData: anyData ?? Data(), to: [PrecallsModel].self) { result in
                            switch result {
                            case .success(let decodecObj):
                                encodedPrecalls = decodecObj
                                do {
                                    let jsonData = try JSONEncoder().encode(encodedPrecalls)
                                    
                                    // Convert Swift object to JSON string
                                    
                                    responseHandler.handleSuccess(value: self.convertToDictionary(encodedPrecalls) ?? JSON(), data: jsonData)
                                    print("JSON Data:")
                                    print(jsonData)
                                } catch {
                                    responseHandler.handleFailure(value: "Unable to decode.")
                                    print("Error encoding JSON: \(error)")
                                }
                                
                            case .failure(let error):
                                responseHandler.handleFailure(value: "Unable to decode.")
                                print("Error encoding JSON: \(error)")
                                
                            }
                            
                            
                            
                        }
                    }

 
                } else   {
                    if let data = anyData,
                       let json = JSON(data){
                        
                        if api == .getAllPlansData || api == .getReports || api == .saveDCR || api == .updatePassword  || api == .actionLogin {
                           
                            if json.isEmpty {
                                responseHandler.handleFailure(value: json.status_message)
                            } else {
                                responseHandler.handleSuccess(value: json, data: data)
                            }
                        } else {
                            if json.isSuccess {

                                responseHandler.handleSuccess(value: json, data: data)
                            }else{

                                responseHandler.handleFailure(value: json.status_message)
                            }
                        }
                        
                    }
                }
                

                

            case .failure(let error):
                
                var json = JSON()
                
                json["status_message"] = "An issue occured data will be saved to device"
               
                responseHandler.handleFailure(value: json.status_message)
                print("Error in upload: \(error.localizedDescription)")
                //                               self.appDelegate.createToastMessage(error.localizedDescription, bgColor: .black, textColor: .white)
                if error._code == 1001 {
                    responseHandler.handleFailure(value: "The request timed out.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    func convertToDictionary<T>(_ object: T) -> [String: Any]? where T: Encodable {
        do {
            let data = try JSONEncoder().encode(object)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting to dictionary: \(error)")
            return nil
        }
    }
    
//    func toConvertDataToObj<T: Decodable>(responseData: Data, to modal : T.Type,
//                                          _ result : @escaping Closure<T>) {
//        let decoder = JSONDecoder()
//           do {
//               let decodedObj = try decoder.decode(T.self, from: responseData)
//               dump(decodedObj)
//               result(decodedObj)
//           } catch {
//               print("Error")
//           }
//    }
    
    func toConvertDataToObj<T: Decodable>(responseData: Data, to modal: T.Type,
                                          completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedObj = try decoder.decode(T.self, from: responseData)
            dump(decodedObj)
            completion(.success(decodedObj))
        } catch {
            print("Error: \(error)")
            completion(.failure(error))
        }
    }
    
    
}
    
    
    

