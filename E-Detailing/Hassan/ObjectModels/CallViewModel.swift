//
//  CallViewModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 11/04/24.
//

import Foundation


class CallListViewModel {
    
    private var callListArray =  [CallViewModel]()
    private var dcrActivityList = [DcrActivityViewModel]()
    
    func fetchDataAtIndex(index : Int, type : DCRType, searchText : String, isFiltered: Bool, filterscase: FilteredCase?) -> CallViewModel {
        
        
        switch type {
            case .doctor:
//                let doctors = searchText == "" ? DBManager.shared.getDoctor() :  DBManager.shared.getDoctor().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
//                    return CallViewModel(call: doctors[index], type: .doctor)
            if isFiltered {
                return self.fetchDoctorAtIndex(index: index, type: .doctor, searchText: searchText, filterscase: filterscase)
            } else {
                return self.fetchDoctorAtIndex(index: index, type: .doctor, searchText: searchText, filterscase: nil)
            }
          
            case .chemist:
                let chemists = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            
            
            
            if let filterscase = filterscase {
                // Access the properties directly and use optional chaining
                let categoryCode = filterscase.categoryCode?.code
                let specialityCode = filterscase.specialityCode?.code
                let territoryCode = filterscase.territoryCode?.code

                // Use filter to find the matching doctors
                let filteredDoc = chemists.filter {
                  //  $0.categoryCode == categoryCode ?? "" ||
                  //  $0.specialityCode == specialityCode ?? "" ||
                    $0.townCode == territoryCode ?? ""
                }
                let docObj = filteredDoc[index]
                let aCallViewmodel = CallViewModel(call: docObj, type: .chemist)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)

            } else {
                let aCallViewmodel = CallViewModel(call: chemists[index], type: .chemist)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            }
            
            
            
 
              //  return CallViewModel(call: chemists[index], type: .chemist)
            case .stockist:
                let stockists = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            
            if let filterscase = filterscase {
                // Access the properties directly and use optional chaining
                let categoryCode = filterscase.categoryCode?.code
                let specialityCode = filterscase.specialityCode?.code
                let territoryCode = filterscase.territoryCode?.code

                // Use filter to find the matching doctors
                let filteredDoc = stockists.filter {
                  //  $0.categoryCode == categoryCode ?? "" ||
                  //  $0.specialityCode == specialityCode ?? "" ||
                    $0.townCode == territoryCode ?? ""
                }
                let docObj = filteredDoc[index]
                let aCallViewmodel = CallViewModel(call: docObj, type: .stockist)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)

            } else {
                let aCallViewmodel = CallViewModel(call: stockists[index], type: .stockist)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            }
            
            
              //  return CallViewModel(call: stockists[index], type: .stockist)
            case .unlistedDoctor:
                let unlistedDoctor = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            
            
            
            if let filterscase = filterscase {
                // Access the properties directly and use optional chaining
                let categoryCode = filterscase.categoryCode?.code
                let specialityCode = filterscase.specialityCode?.code
                let territoryCode = filterscase.territoryCode?.code

                // Use filter to find the matching doctors
                let filteredDoc = unlistedDoctor.filter {
                   // $0.categoryCode == categoryCode ?? "" ||
                 //   $0.specialityCode == specialityCode ?? "" ||
                    $0.townCode == territoryCode ?? ""
                }
                let docObj = filteredDoc[index]
                let aCallViewmodel = CallViewModel(call: docObj, type: .unlistedDoctor)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)

            } else {
                let aCallViewmodel = CallViewModel(call: unlistedDoctor[index], type: .unlistedDoctor)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            }
            
            

            
              //  return CallViewModel(call: unlistedDoctor[index], type: .unlistedDoctor)
            case .hospital:
                let doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
             //   return CallViewModel(call: doctor[index], type: .hospital)
            
            let aCallViewmodel = CallViewModel(call: doctor[index], type: .hospital)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
           
            case .cip:
                let doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            let aCallViewmodel = CallViewModel(call: doctor[index], type: .cip)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            
               // return CallViewModel(call: doctor[index], type: .cip)
        }
    }
    
    func fetchDoctorAtIndex(index : Int, type : DCRType, searchText : String, filterscase: FilteredCase?) -> CallViewModel {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        if appsetup.geoTagNeed == 0 {
            
        }else {
            
        }
        let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        if let filterscase = filterscase {
            // Access the properties directly and use optional chaining
            let categoryCode = filterscase.categoryCode?.code
            let specialityCode = filterscase.specialityCode?.code
            let territoryCode = filterscase.territoryCode?.code

            // Use filter to find the matching doctors
            let filteredDoc = doctors.filter {
                var shouldInclude = true
                
                if let categoryCode = categoryCode {
                    shouldInclude = shouldInclude && ($0.categoryCode == categoryCode)
                }
                
                if let specialityCode = specialityCode {
                    shouldInclude = shouldInclude && ($0.specialityCode == specialityCode)
                }
                
                if let territoryCode = territoryCode {
                    shouldInclude = shouldInclude && ($0.townCode == territoryCode)
                }
                
                return shouldInclude
            }
            if !filteredDoc.isEmpty {
                let docObj = filteredDoc[index]
                let aCallViewmodel = CallViewModel(call: docObj , type: .doctor)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            } else {
                return CallViewModel(call: DoctorFencing(), type: .doctor)
            }
         

        } else {
            let docObj = doctors[index]
            let aCallViewmodel = CallViewModel(call: docObj , type: .doctor)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
        }
        
        
 
    }
    
    
//    func fetchFilteredDoctors(type : DCRType, searchText : String) -> CallViewModel {
//        let appsetup = AppDefaults.shared.getAppSetUp()
//        
//        
//        if appsetup.geoTagNeed == 0 {
//            
//        }else {
//            
//        }
//        let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
//        
//        let docObj = doctors[index]
//        let aCallViewmodel = CallViewModel(call: docObj , type: .doctor)
//        return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
//    }
    
    
    func filteredDCRrows(_ type : DCRType, searchText : String, filterscase: FilteredCase) -> Int {
        
        let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let categoryCode = filterscase.categoryCode?.code
        let specialityCode = filterscase.specialityCode?.code
        let territoryCode = filterscase.territoryCode?.code

        // Use filter to find the matching doctors
        return doctors.filter {
            var shouldInclude = true
            
            if let categoryCode = categoryCode {
                shouldInclude = shouldInclude && ($0.categoryCode == categoryCode)
            }
            
            if let specialityCode = specialityCode {
                shouldInclude = shouldInclude && ($0.specialityCode == specialityCode)
            }
            
            if let territoryCode = territoryCode {
                shouldInclude = shouldInclude && ($0.townCode == territoryCode)
            }
            
            return shouldInclude
        }.count
       // return doctors.filter { $0.categoryCode ==  categoryCode ?? "" || $0.specialityCode == specialityCode ?? "" || $0.townCode == territoryCode ?? ""}.count
    }
    
    func numberofDoctorsRows(_ type : DCRType, searchText : String) -> Int {
        switch type {
        case .doctor:
            let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            return doctors.count
        case .chemist:
            let chemists = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            return chemists.count
        case .stockist:
            let stockists = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            return stockists.count
        case .unlistedDoctor:
            let unlistedDoctors = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            return unlistedDoctors.count
        case .hospital:
            return DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
        case .cip:
            return DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).count
        }
    }
    
    func addDcrActivity(_ vm : DcrActivityViewModel){
        dcrActivityList.append(vm)
    }
    
    func fetchAtIndex(_ index : Int) -> DcrActivityViewModel {
        return dcrActivityList[index]
    }
    
    func numberofDcrs() -> Int {
        return dcrActivityList.count
    }
}


public class CallViewModel {
    
    let call : AnyObject
    var type : DCRType
    
    var dcrCheckinTime: String = ""
    var dcrCheckOutTime: String = ""
    var checkinlatitude: Double = Double()
    var checkinlongitude:  Double = Double()
    var checkOutlatitude: Double = Double()
    var checkOutlongitude:  Double = Double()
    var customerCheckinAddress : String = String()
    var customerCheckOutAddress : String = String()
    var name: String = ""
    var code: String = ""
    var dob: String = ""
    var dow: String = ""
    var mobile: String = ""
    var email: String = ""
    var address: String = ""
    var qualification: String = ""
    var category: String = ""
    var speciality: String = ""
    var territory: String = ""
    var cateCode: String = ""
    var specialityCode : String = ""
    var townCode : String = ""
    var townName : String = ""
    init(call: AnyObject, type: DCRType) {
        self.call = call
        self.type = type
    }
    
    func toRetriveDCRdata(dcrcall: AnyObject?) -> CallViewModel {
        switch self.type {
            
        case .doctor:
            if let doccall = dcrcall as? DoctorFencing {
                type = .doctor
               name = doccall.name ?? ""
              
               code = doccall.code ?? ""
               dob = doccall.dob ?? ""
               dow = doccall.dow ?? ""
               mobile = doccall.mobile ?? ""
               email = doccall.docEmail ?? ""
               address = doccall.addrs ?? ""
               qualification = doccall.docDesig ?? ""
               category = doccall.category ?? ""
               speciality = doccall.speciality ?? ""
                territory = doccall.townName ?? ""
                townCode = doccall.townCode ?? ""
                specialityCode = doccall.specialityCode ?? ""
                cateCode = doccall.categoryCode ?? ""
            }
        case .chemist:
            if let doccall = dcrcall as? Chemist {
                type = .chemist
               name = doccall.name ?? ""
               code = doccall.code ?? ""
  
               mobile = doccall.chemistMobile ?? ""
               email = doccall.chemistEmail ?? ""
               address = doccall.addr ?? ""
            
               category =  ""
               speciality =  ""
                territory = doccall.townName ?? ""
                townCode = doccall.townCode ?? ""
                specialityCode = ""
                cateCode = ""
            }
        case .stockist:
            if let doccall = dcrcall as? Stockist {
                type = .stockist
               name = doccall.name ?? ""
               code = doccall.code ?? ""
       
               mobile = doccall.stkMobile ?? ""
               email = doccall.stkEmail ?? ""
               address = doccall.addr ?? ""
            
               category =  ""
               speciality =  ""
                territory = doccall.townName ?? ""
                townCode = doccall.townCode ?? ""
                specialityCode = ""
                cateCode = ""
                
            }
        case .unlistedDoctor:
            if let doccall = dcrcall as? UnListedDoctor {
                type = .unlistedDoctor
               name = doccall.name ?? ""
               code = doccall.code ?? ""
               dob = ""
               dow = ""
               mobile = doccall.mobile ?? ""
               email = doccall.email ?? ""
               address = doccall.addrs ?? ""
               qualification =  ""
                
               category = doccall.category ?? ""
               speciality = doccall.specialtyName ?? ""
                territory = doccall.townName ?? ""
                townCode = doccall.townCode ?? ""
                specialityCode = ""
                cateCode = ""
            }
        case .hospital:
            type = .hospital
            print("Yet yo implement")
        case .cip:
            type = .cip
            print("Yet yo implement")
        }
        return self
    }
    

}


class DcrActivityViewModel {
    
    let activityType : DcrActivityType
    
    init(activityType: DcrActivityType) {
        self.activityType = activityType
    }
    
    var name : String {
        return activityType.name
    }
    
    var type : DCRType {
        return activityType.type
    }
}
 
struct DcrActivityType {
    
    var name : String
    var type : DCRType
}
