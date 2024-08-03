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
    
     var callListArray =  [CallViewModel]()
     var dcrActivityList = [DcrActivityViewModel]()
    
    func fetchDataAtIndex(index : Int, type : DCRType, searchText : String, isFiltered: Bool, filterscase: FilteredCase?) -> CallViewModel {
        
        
        switch type {
            case .doctor:

            if isFiltered {
                return self.fetchDoctorAtIndex(index: index, type: .doctor, searchText: searchText, filterscase: filterscase)
            } else {
                return self.fetchDoctorAtIndex(index: index, type: .doctor, searchText: searchText, filterscase: nil)
            }
          
            case .chemist:
  
            if isFiltered {
                return self.fetchChemistAtIndex(index: index, type: .chemist, searchText: searchText, filterscase: filterscase)
            } else {
                return self.fetchChemistAtIndex(index: index, type: .chemist, searchText: searchText, filterscase: nil)
            }

            case .stockist:
     
            if isFiltered {
                return self.fetchStockistAtIndex(index: index, type: .stockist, searchText: searchText, filterscase: filterscase)
            } else {
                return self.fetchStockistAtIndex(index: index, type: .stockist, searchText: searchText, filterscase: nil)
            }
            
     
            case .unlistedDoctor:
            if isFiltered {
                return self.fetchUnlistedDoctorAtIndex(index: index, type: .unlistedDoctor, searchText: searchText, filterscase: filterscase)
            } else {
                return self.fetchUnlistedDoctorAtIndex(index: index, type: .unlistedDoctor, searchText: searchText, filterscase: nil)
            }

            
 
            case .hospital:
                let doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
         
            
            let aCallViewmodel = CallViewModel(call: doctor[index], type: .hospital)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
           
            case .cip:
                let doctor = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            let aCallViewmodel = CallViewModel(call: doctor[index], type: .cip)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            
        }
    }
    
    func fetchChemistAtIndex(index : Int, type : DCRType, searchText : String, filterscase: FilteredCase?) -> CallViewModel {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        if appsetup.geoTagNeed == 0 {
            
        }else {
            
        }
        let chemists = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        if let filterscase = filterscase {
            // Access the properties directly and use optional chaining
        //    let categoryCode = filterscase.categoryCode?.name
       
            let territoryCode = filterscase.territoryCode?.name
         
            // Use filter to find the matching doctors
          
     
            
            let filteredChem = chemists.filter { chemist in
//                if let categoryCode = categoryCode, chemist.code != categoryCode {
//                    return false
//                }
//      
                if let territoryCode = territoryCode, chemist.townName != territoryCode {
                    return false
                }

                
                return true
            }
            if !filteredChem.isEmpty {
                if filteredChem.count > index {
                    let chemObj = filteredChem[index]
                    let aCallViewmodel = CallViewModel(call: chemObj , type: .chemist)
                    return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
                } else {
                    return CallViewModel(call: Chemist(), type: .chemist)
                }

            } else {
                return CallViewModel(call: Chemist(), type: .chemist)
            }
         

        } else {
            let chemObj = chemists[index]
            let aCallViewmodel = CallViewModel(call: chemObj , type: .chemist)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
        }
        
        
 
    }
    
    func fetchStockistAtIndex(index : Int, type : DCRType, searchText : String, filterscase: FilteredCase?) -> CallViewModel {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        if appsetup.geoTagNeed == 0 {
            
        }else {
            
        }
        let stockists = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        if let filterscase = filterscase {
            // Access the properties directly and use optional chaining
       //     let categoryCode = filterscase.categoryCode?.name
       
            let territoryCode = filterscase.territoryCode?.name
         
            // Use filter to find the matching doctors
          
     
            
            let filteredstockists = stockists.filter { chemist in
//                if let categoryCode = categoryCode, chemist.code != categoryCode {
//                    return false
//                }
//
                if let territoryCode = territoryCode, chemist.townName != territoryCode {
                    return false
                }

                
                return true
            }
            if !filteredstockists.isEmpty {
                if filteredstockists.count > index {
                    let stockistObj = filteredstockists[index]
                    let aCallViewmodel = CallViewModel(call: stockistObj , type: .stockist)
                    return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
                } else {
                    return CallViewModel(call: Stockist(), type: .stockist)
                }

            } else {
                return CallViewModel(call: Stockist(), type: .stockist)
            }
         

        } else {
            let stockistObj = stockists[index]
            let aCallViewmodel = CallViewModel(call: stockistObj , type: .stockist)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
        }
        
        
 
    }
    func fetchUnlistedDoctorAtIndex(index : Int, type : DCRType, searchText : String, filterscase: FilteredCase?) -> CallViewModel {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        if appsetup.geoTagNeed == 0 {
            
        }else {
            
        }
        let doctors = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        if let filterscase = filterscase {
            // Access the properties directly and use optional chaining
            let categoryCode = filterscase.categoryCode?.name
            let specialityCode = filterscase.specialityCode?.name
            let territoryCode = filterscase.territoryCode?.name
            let doctorClasscode = filterscase.classCode?.code
            // Use filter to find the matching doctors
          
            let filteredDoc = doctors.filter {  doctor in
                if let categoryCode = categoryCode, doctor.category != categoryCode {
                    return false
                }
                if let specialityCode = specialityCode, doctor.specialtyName != specialityCode {
                    return false
                }
                if let territoryCode = territoryCode, doctor.townName != territoryCode {
                    return false
                }
                
                if let doctorClasscode = doctorClasscode, doctor.doctorClassCode != doctorClasscode {
                    return false
                }
                
                return true
            }
            if !filteredDoc.isEmpty {
                let docObj = filteredDoc[index]
                let aCallViewmodel = CallViewModel(call: docObj , type: .unlistedDoctor)
                return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
            } else {
                return CallViewModel(call: DoctorFencing(), type: .doctor)
            }
         

        } else {
            let docObj = doctors[index]
            let aCallViewmodel = CallViewModel(call: docObj , type: .unlistedDoctor)
            return aCallViewmodel.toRetriveDCRdata(dcrcall: aCallViewmodel.call)
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
            let categoryCode = filterscase.categoryCode?.name
            let specialityCode = filterscase.specialityCode?.name
            let territoryCode = filterscase.territoryCode?.name
            let doctorClassCode = filterscase.classCode?.doctorClassName
            // Use filter to find the matching doctors
          
            let filteredDoc = doctors.filter { doctor in
                if let categoryCode = categoryCode, doctor.category != categoryCode {
                    return false
                }
                if let specialityCode = specialityCode, doctor.speciality != specialityCode {
                    return false
                }
                if let territoryCode = territoryCode, doctor.townName != territoryCode {
                    return false
                }
                
                if let doctorClassCode = doctorClassCode, doctor.doctorClassName != doctorClassCode {
                    return false
                }
                
                return true
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
    
    func filteredChemistRows(_ type : DCRType, searchText : String, filterscase: FilteredCase) -> Int {
        
        let doctors = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
       
        let categoryCode = filterscase.chemistCategotyCode?.code
        let territoryCode = filterscase.territoryCode?.code

        return doctors.filter { doctor in
   
            if let categoryCode = categoryCode, doctor.categoryCode != categoryCode {
                return false
            }
            if let territoryCode = territoryCode, doctor.townCode != territoryCode {
                return false
            }
            
            return true
        }.count
    }

    
    func filteredStockistRows(_ type : DCRType, searchText : String, filterscase: FilteredCase) -> Int {
        
        let doctors = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
       
  
        let territoryCode = filterscase.territoryCode?.code

        return doctors.filter { doctor in
   
//            if let specialityCode = specialityCode, doctor.speciality != specialityCode {
//                return false
//            }
            if let territoryCode = territoryCode, doctor.townCode != territoryCode {
                return false
            }
            
            return true
        }.count
    }
    
    func filteredUnlistedDocrows(_ type : DCRType, searchText : String, filterscase: FilteredCase) -> Int {
        
        let doctors = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let categoryCode = filterscase.categoryCode?.code
        let specialityCode = filterscase.specialityCode?.code
        let territoryCode = filterscase.territoryCode?.code
        let doctorClasscode = filterscase.classCode?.code

        // Use filter to find the matching doctors
        // Use filter to find the matching doctors
        return doctors.filter { doctor in
            if let categoryCode = categoryCode, doctor.categoryCode != categoryCode {
                return false
            }
            if let specialityCode = specialityCode, doctor.specialty != specialityCode {
                return false
            }
            if let territoryCode = territoryCode, doctor.townCode != territoryCode {
                return false
            }
            
            if let doctorClasscode = doctorClasscode, doctor.doctorClassCode != doctorClasscode {
                return false
            }
            
            return true
        }.count
       // return doctors.filter { $0.categoryCode ==  categoryCode ?? "" || $0.specialityCode == specialityCode ?? "" || $0.townCode == territoryCode ?? ""}.count
    }
    
    func filteredDCRrows(_ type : DCRType, searchText : String, filterscase: FilteredCase) -> Int {
        
        let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let categoryCode = filterscase.categoryCode?.code
        let specialityCode = filterscase.specialityCode?.code
        let territoryCode = filterscase.territoryCode?.code
        let doctorClassCode = filterscase.classCode?.doctorClassName

        // Use filter to find the matching doctors
        return doctors.filter { doctor in
            if let categoryCode = categoryCode, doctor.categoryCode != categoryCode {
                return false
            }
            if let specialityCode = specialityCode, doctor.specialityCode != specialityCode {
                return false
            }
            if let territoryCode = territoryCode, doctor.townCode != territoryCode {
                return false
            }
            
            if let doctorClassCode = doctorClassCode, doctor.doctorClassName != doctorClassCode {
                return false
            }
            
            return true
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
    var dcrDate : Date?
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
                townName = doccall.townName ?? ""
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
                townName = doccall.townName ?? ""
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
                townName = doccall.townName ?? ""
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
                dob = doccall.dob?.date ?? ""
                dow = doccall.dow?.date ?? ""
                mobile = doccall.mobile ?? ""
                email = doccall.email ?? ""
                address = doccall.addrs ?? ""
              var qualifictions =  DBManager.shared.getQualification()
              let  filteredqualifictions = qualifictions.filter { $0.code == doccall.qual ?? "" }.first?.name
                qualification = filteredqualifictions ?? ""
                townName = doccall.townName ?? ""
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
