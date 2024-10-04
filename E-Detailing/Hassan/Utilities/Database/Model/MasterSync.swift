//
//  MasterSync.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 28/12/23.
//

import Foundation


enum LoadingStatus {
    case isLoading
    case loaded
    case error
}

enum MasterCellType : Int {
    
    case syncAll = 0
    case listedDoctor = 1
    case chemist = 2
    case stockist = 3
    case unLstDoctor = 4
    case cluster = 5
    case input = 6
    case Product = 7
    case leave = 8
    case dcr = 9
    case tourPlan = 10
    case workType = 11
    case slides = 12
    case subordinate = 13
    case other = 14
    case setup = 15
    case hospital = 16
    case cip = 17

    
    var name : String {
     
        switch self {
            
        case .syncAll:
            return "Sync All"
        case .listedDoctor:
            return LocalStorage.shared.getString(key: .doctor)
        case .chemist:
            return  LocalStorage.shared.getString(key: .chemist)
        case .stockist:
            return  LocalStorage.shared.getString(key: .stockist)
        case .unLstDoctor:
            return  LocalStorage.shared.getString(key: .unlistedDoctor)
        case .cip:
            return "CIP"
        case .hospital:
            return "Hospital"
        case .subordinate:
            return "Subordinate"
        case .slides:
            return "Slides"
        case .Product:
            return "Product"
        case .input:
            return "input"
        case .cluster:
            return  LocalStorage.shared.getString(key: .cluster)

        case .dcr:
            return "DCR"
        case .tourPlan:
            return "Tour plan"
        case .leave:
            return "Leave"
        case .workType:
            return "Work type"
        case .other:
            return "Other"
        case .setup:
            return "Setup"
        }
    }
    
    var groupDetail : [MasterInfo] {
        switch self {
            
        case .syncAll:
            return [MasterInfo.slides,MasterInfo.worktype]
            //MasterInfo.departments
        case .listedDoctor:
            return [MasterInfo.doctorFencing,MasterInfo.speciality,MasterInfo.qualifications, MasterInfo.category,MasterInfo.doctorClass, MasterInfo.empty, MasterInfo.syncAll]
            //MasterInfo.category,
        case .chemist:
            return [MasterInfo.chemists, MasterInfo.chemistCategory, MasterInfo.empty,MasterInfo.syncAll]
        case .stockist:
            return [MasterInfo.stockists,MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
        case .unLstDoctor:
            return [MasterInfo.unlistedDoctors,MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
        case .cip:
            return [MasterInfo.subordinate,MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
        case .hospital:
            //MasterInfo.subordinateMGR,
            return [MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
        case .subordinate:
            //MasterInfo.subordinateMGR,
            return [MasterInfo.subordinate,MasterInfo.jointWork,MasterInfo.empty,MasterInfo.syncAll]
        case .slides:
            return [MasterInfo.slides, MasterInfo.slideSpeciality, MasterInfo.slideBrand, MasterInfo.slideTheraptic, MasterInfo.empty,  MasterInfo.empty, MasterInfo.syncAll]
        case .Product:
            // MasterInfo.competitors,
            //MasterInfo.productcategory,
            //, MasterInfo.empty,  MasterInfo.empty,
            return [MasterInfo.products,  MasterInfo.brands, MasterInfo.mappedCompetitors, MasterInfo.syncAll]
        case .input:
            return [MasterInfo.inputs,   MasterInfo.empty,  MasterInfo.empty, MasterInfo.syncAll]
        case .cluster:
            return [MasterInfo.clusters,MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
//, MasterInfo.stockBalance
        case .dcr:
            return [MasterInfo.homeSetup, MasterInfo.dcrDateSync, MasterInfo.myDayPlan, MasterInfo.visitControl, MasterInfo.empty, MasterInfo.empty, MasterInfo.syncAll]
        case .tourPlan:
            return [MasterInfo.tourPlanSetup , MasterInfo.getTP, MasterInfo.empty ,MasterInfo.syncAll]
        case .leave:
            return [MasterInfo.leaveType,MasterInfo.empty,MasterInfo.empty,MasterInfo.syncAll]
        case .workType:
            return [MasterInfo.worktype, MasterInfo.holidays, MasterInfo.weeklyOff, MasterInfo.syncAll]
        case .other:
            return [MasterInfo.docFeedback, MasterInfo.empty, MasterInfo.empty, MasterInfo.syncAll]
            //MasterInfo.customSetup
        case .setup:
            return [MasterInfo.setups,  MasterInfo.empty, MasterInfo.empty, MasterInfo.syncAll]
        }
    }
}

//[MasterInfo.slides,MasterInfo.doctorFencing,MasterInfo.chemists,MasterInfo.stockists,MasterInfo.unlistedDoctors,MasterInfo.worktype,MasterInfo.clusters,MasterInfo.myDayPlan,MasterInfo.subordinate,MasterInfo.subordinateMGR,MasterInfo.jointWork,MasterInfo.products,
//                   MasterInfo.inputs,MasterInfo.brands,MasterInfo.competitors,MasterInfo.slideSpeciality,MasterInfo.slideBrand,MasterInfo.speciality,MasterInfo.departments,MasterInfo.category,MasterInfo.qualifications,MasterInfo.doctorClass,MasterInfo.setups,MasterInfo.customSetup]


class MasterInfoState {
    static var loadingStatusDict: [MasterInfo: LoadingStatus] = MasterInfo.loadingStatusDict
}

enum `MasterInfo` : String, CaseIterable {
    
    var dynamicTitle: String {
        switch self {
        case .doctorFencing:
            return LocalStorage.shared.getString(key: .doctor)
        case .chemists:
            return LocalStorage.shared.getString(key: .chemist)
        case .stockists:
            return LocalStorage.shared.getString(key: .stockist)
        case .unlistedDoctors:
            return LocalStorage.shared.getString(key: .unlistedDoctor)
            
        case .clusters:
            return LocalStorage.shared.getString(key: .cluster)
        default:
            return ""
        }
    }
    
    case myDayPlan = "My Day Plan"
    case worktype = "Work Types"
    case headquartes = "Headquarters"
    //case competitors = "Competitor Product"
    case mappedCompetitors = "Mapped Competitor Product"
    case inputs = "Inputs"
    case slideBrand = "Brand slides"
    case products = "Products"
    case slides = "Product slides"
    case slideSpeciality = "Speciality Slides"
    case slideTheraptic = "Theraptic slides"
    case brands = "Brands"
    //case departments = "Departments"
    case speciality = "Speciality"
    case category = "Category"
    //case productcategory = "Product Category"
    case qualifications = "Qualifications"
    case doctorClass = "Class"
    case docTypes = "DocTypes"
    case ratingDetails = "Rating Details"
    case ratingFeedbacks = "Rating Feedbacks"
    case speakerList = "Speaker List"
    case participantList = "Participant List"
    case indicationList = "Indication List"
    case setups = "Setups"
    case clusters = "Clusters"
    case doctors = "Doctors"
    case chemists = "Chemists"
    case chemistCategory = "Chemists Category"
    case stockists = "Stockists"
    case unlistedDoctors = "Unlisted Doctors"
    case institutions = "Institutions"
    case jointWork = "Jointworks"
    
    case subordinate = "Subordinate"
   // case subordinateMGR = "Subordinate MGR"
    
    case doctorFencing = "Listed Doctor"
    case docFeedback = "Feedback"
    
   // case customSetup = "Custom Setup"
    case leaveType = "Leave Type"
    case tourPlanStatus = "Tour Plan Status"
    case visitControl = "Visit Control"
    //case stockBalance = "Stock Balance"
    case empty = "Empty"
    case syncAll = "Sync All"
    case getTP = "Tour Plan"
    case holidays = "Holidays"
    case weeklyOff = "Weekly Off"
    case apptableSetup = "Table Setup"
    case tourPlanSetup = "Tour plan setup"
    case homeSetup = "Call Sync"
    case callSync = "DCR"
    case dcrDateSync = "Date Sync"
   

    


    // Define a dictionary to store SectionInfo for each case
    static var loadingStatusDict: [MasterInfo: LoadingStatus] = {
        var dict = [MasterInfo: LoadingStatus]()
        for caseValue in MasterInfo.allCases {
            dict[caseValue] = .loaded
        }
        return dict
    }()
    
    static func setLoadingStatus(for caseValue: MasterInfo, to status: LoadingStatus) {
        loadingStatusDict[caseValue] = status
    }
    
    // Computed property to get SectionInfo for a case
    var loadingStatus: LoadingStatus {
        return MasterInfo.loadingStatusDict[self] ?? .loaded
    }



    
    var getUrl : String {
        
        let mainUrl =  LocalStorage.shared.getString(key: .AppMainURL)
        //AppDefaults.shared.webUrl + AppDefaults.shared.iosUrl
        
        switch self {
            
        case .headquartes:
            return String(format: "%@GET/HQ", mainUrl)
        case .ratingDetails:
            return String(format: "%@GET/RatingInf", mainUrl)
        case .ratingFeedbacks:
            return String(format: "%@GET/RatingFeedbk", mainUrl)
        case .speakerList:
            return String(format: "%@GET/Speaker", mainUrl)
        case .participantList:
            return String(format: "%@GET/Participant", mainUrl)
        case .indicationList:
            return String(format: "%@GET/Indication", mainUrl)
            //.customSetup
        case .setups:
            return String(format: "%@table/setups", mainUrl)
        case .doctors:
            return String(format: "%@GET/Doctors", mainUrl)
        case .institutions:
            return String(format: "%@GET/Hospitals", mainUrl)
        case .leaveType:
            return String(format: "%@get/leave", mainUrl)
            //.stockBalance
        case .tourPlanStatus,.visitControl,.mappedCompetitors:
            return String(format: "%@table/additionaldcrmasterdata", mainUrl)
        
        case .products,.inputs,.brands :
            //,.competitors
            return String(format: "%@table/products", mainUrl)
        
        case .subordinate , .jointWork:
            // .subordinateMGR,
            return String(format: "%@table/subordinates", mainUrl)
            //.speciality,.departments,
            
        case .doctorFencing ,.chemists , .chemistCategory, .stockists,.unlistedDoctors,.worktype ,.clusters,.myDayPlan,.doctorClass,.docTypes,.qualifications,.category,.docFeedback,.speciality :
            return String(format: "%@table/dcrmasterdata", mainUrl)
        case .tourPlanSetup:
            return String(format: "%@table/setups", mainUrl)
            
        case .weeklyOff:
            return String(format: "%@table/dcrmasterdata", mainUrl)
            
        case .holidays:
            return String(format: "%@table/dcrmasterdata", mainUrl)
            
        case .getTP:
            return String(format: "%@get/tp", mainUrl)
            
        case .homeSetup:
            return String(format: "%@home", mainUrl)
            
        case .slides, .slideBrand, .slideSpeciality, .slideTheraptic:
            return String(format: "%@table/slides", mainUrl)
            
        default :
            return String(format: "%@home", mainUrl)
        }
    }
    
    var getParams  : [String : Any] {
        
        switch self{
            
        case .worktype:
            return MasterSyncParams.workTypeParams
//        case .competitors:
//            return MasterSyncParams.competitorParams
        case .inputs:
            return MasterSyncParams.inputParams
        case .slideBrand:
            return MasterSyncParams.slideBrandParams
        case .products:
            return MasterSyncParams.productParams
        case .slides:
            return MasterSyncParams.productSlideParams
        case .brands:
            return MasterSyncParams.brandParams
//        case .departments:
//            return MasterSyncParams.departsParams
        case .speciality:
            return MasterSyncParams.specialityParams
        case .category:
            return MasterSyncParams.categoryParams
        case .qualifications:
            return MasterSyncParams.qualificationParams
        case .doctorClass:
            return MasterSyncParams.classParams
        case .docTypes:
            return MasterSyncParams.typeParams
        case .ratingDetails:
            return [String : Any]()
        case .ratingFeedbacks:
            return [String : Any]()
        case .speakerList:
            return [String : Any]()
        case .participantList:
            return [String : Any]()
        case .indicationList:
            return [String : Any]()
        case .headquartes:
            return [String : Any]()
        case .setups:
            return MasterSyncParams.setupParams
        case .clusters:
            return MasterSyncParams.territoryParams
        case .doctors:
            return [String : Any]()
        case .chemists:
            return MasterSyncParams.chemistParams
        case .stockists:
            return MasterSyncParams.stockistParams
        case .unlistedDoctors:
            return MasterSyncParams.unListedDoctorParams
        case .institutions:
            return [String : Any]()
        case .jointWork:
            return MasterSyncParams.jointWorkParams
        case .subordinate:
            return MasterSyncParams.subordinateParams
//        case .subordinateMGR:
//            return MasterSyncParams.subordinateMgrParams
        case .doctorFencing:
            return MasterSyncParams.doctorFencingParams
        case .myDayPlan:
            return MasterSyncParams.myDayPlanParams
        case .syncAll:
            return [String : Any]()
        case .slideSpeciality:
            return MasterSyncParams.slideSpecialityParams
        case .docFeedback:
            return MasterSyncParams.docFeedBackParams
//        case .customSetup:
//            return MasterSyncParams.customSetupParams
        case .leaveType:
            return MasterSyncParams.leaveTypeParams
        case .tourPlanStatus:
            return MasterSyncParams.tpStatusParams
        case .visitControl:
            return MasterSyncParams.visitControlParams
//        case .stockBalance:
//            return MasterSyncParams.stockBalanceParams
        case .mappedCompetitors:
            return MasterSyncParams.mapCompdetParams
        case .empty:
            return [String : Any]()
        case .apptableSetup:
           // return MasterSyncParams.tableSetupParams
            return [String: Any]()
        case .weeklyOff:
            return MasterSyncParams.weelyoffSetupParams
        case .holidays:
            return MasterSyncParams.holidaySetupParams
        case .getTP:
            return MasterSyncParams.tourPlanSetupParams
        case .homeSetup:
            return MasterSyncParams.homeDataSetupParams
        case .callSync:
            return [String : Any]()
        case .dcrDateSync:
            return [String: Any]()
        case .tourPlanSetup:
            return MasterSyncParams.tourplanSetupParams

        case .slideTheraptic:
            return MasterSyncParams.slideTherapticParams
        case .chemistCategory:
            return MasterSyncParams.chemistCategoryParams
        }
 
    }
}

struct MasterSyncParams {
    
    static var productSlideParams : [String : Any ] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getprodslides"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
   // {"tableName":"getprodslides","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"ASM","state_code":"13","subdivision_code":"86,"}
    }
    
    static var subordinateParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getsubordinate"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var subordinateMgrParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getsubordinatemgr"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var doctorFencingParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
//        let sfCode = MasterSyncVC.shared.getSFCode
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode ?? "" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        
        var param = [String: Any]()
        param["tableName"] = "getdoctors"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var chemistParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode ?? "" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        var param = [String: Any]()
        param["tableName"] = "getchemist"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var stockistParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
   
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode! :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        var param = [String: Any]()
        param["tableName"] = "getstockist"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var unListedDoctorParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode ?? "" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        var param = [String: Any]()
        param["tableName"] = "getunlisteddr"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var workTypeParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getworktype"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var territoryParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode ?? "" :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        var param = [String: Any]()
        param["tableName"] = "getterritory"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    
    static var myDayPlanParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let date = Date().toString(format: "yyyy-MM-dd 00:00:00")
        var param = [String: Any]()
        
        
        param["tableName"] = "getmydayplan"
        param["ReqDt"] = date
        param["sfcode"] = "\(appsetup.sfCode!)"
        param["division_code"] = "\(appsetup.divisionCode!)"
        param["Rsf"] = "\(appsetup.sfCode!)"
        param["sf_type"] = "\(appsetup.sfType!)"
        param["Designation"] = "\(appsetup.dsName!)"
        param["state_code"] = "\(appsetup.stateCode!)"
        param["subdivision_code"] = "\(appsetup.subDivisionCode!)"
        
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum

      //  "tableName":"getmydayplan","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,","ReqDt":"2024-02-15 15:27:16"}"
        return toSendData
    }
    
//    static var myDayPlanParams : [String : Any] {
//        let appsetup = AppDefaults.shared.getAppSetUp()
//
//        let date = Date().toString(format: "yyyy-MM-dd 00:00:00")
//
//        let paramString = "{\"tableName\":\"gettodaytpnew\",\"ReqDt\":\"\(date)\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"
//
//        return ["data" : paramString]
//    }
    
    static var jointWorkParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let rsf = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID) == String() ? appsetup.sfCode! :  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        var param = [String: Any]()
        param["tableName"] = "getjointwork"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = rsf
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var productParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getproducts"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var inputParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getinputs"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var brandParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getbrands"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var competitorParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
//        
//        let paramString = "{\"tableName\":\"getcompdet\",\"sfcode\":\"\(appsetup.sfCode!)\",\"division_code\":\"\(appsetup.divisionCode!)\",\"Rsf\":\"\(appsetup.sfCode!)\",\"sf_type\":\"\(appsetup.sfType!)\",\"Designation\":\"\(appsetup.dsName!)\",\"state_code\":\"\(appsetup.stateCode!)\",\"subdivision_code\":\"\(appsetup.subDivisionCode!)\"}"
        var param = [String: Any]()
        param["tableName"] = "getcompdet"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
       
        
        let paramString = ObjectFormatter.shared.convertJson2String(json: param)
        
        return ["data" : paramString ?? ""]
    } 
    
    // getmap_compdet getcompdet
    
    static var slideSpecialityParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getslidespeciality"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
        
        let paramString = ObjectFormatter.shared.convertJson2String(json: param)
        
        return ["data" : paramString ?? ""]
    }
    
    static var slideBrandParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getslidebrand"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    
    static var slideTherapticParams : [String : Any] {
        //{"tableName":"gettheraptic","sfcode":"MR8170","division_code":"70,","Rsf":"MR8170","sf_type":"1","ReqDt":"2024-06-11 12:29:33.3660","Designation":"MR","state_code":"2","subdivision_code":"103,","versionNo":"Test.H.3","mod":"Android-Edet","Device_version":"10","Device_name":"LENOVO - Lenovo TB-X505X","AppName":"SAN ZEN","language":"en"}
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "gettheraptic"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["ReqDt"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var specialityParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getspeciality"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var departsParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getdeparts"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var categoryParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getcategorys"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var chemistCategoryParams : [String : Any] {
        //{"tableName":"getchem_categorys","sfcode":"MR1651","division_code":"44,","Rsf":"MR1651","sf_type":"1","ReqDt":"2024-06-20 11:02:24.9350","Designation":"MR","state_code":"4","subdivision_code":"170,","versionNo":"Test.H.4","mod":"Android-Edet","Device_version":"10","Device_name":"LENOVO - Lenovo TB-X606V","AppName":"SAN ZEN","language":"en"}
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getchem_categorys"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["ReqDt"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var qualificationParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getquali"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var classParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getclass"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var typeParams : [String : Any] {
      //  let appsetup = AppDefaults.shared.getAppSetUp()
        
        let paramString = "{\"tableName\":\"gettypes\",\"sfcode\":\"MR0026\",\"division_code\":\"8,\",\"Rsf\":\"MR0026\",\"sf_type\":\"1\",\"Designation\":\"TBM\",\"state_code\":\"28\",\"subdivision_code\":\"62,\"}"
        
        return ["data" : paramString]
    }
    
    static var docFeedBackParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getdrfeedback"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var setupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getsetups"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var customSetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getcustomsetup"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    
    static var leaveTypeParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getleavetype"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var tpStatusParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "gettpstatus"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var stockBalanceParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getstockbalance"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var visitControlParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "getvisit_contro"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }

    
    static var mapCompdetParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
       // {"tableName":"getmapcompdet","sfcode":"MR5940","division_code":"63,","Rsf":"","sf_type":"1","ReqDt":"2024-04-28 13:46:13.5770","Designation":"MR","state_code":"2","subdivision_code":"86,"}
        var param = [String: Any]()
        param["tableName"] = "getmapcompdet"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    static var tourplanSetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        var param = [String: Any]()
        param["tableName"] = "gettpsetup"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
    }
    
    
    static var weelyoffSetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let year = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year
        
        var param = [String: Any]()
        param["tableName"] = "getweeklyoff"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
        param["year"] = year ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
        

    }
    
    
    static var homeDataSetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
      
        var param = [String: Any]()
        param["tableName"] = "gethome"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
        


    }
    
    static var holidaySetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        let year = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year
        
        var param = [String: Any]()
        param["tableName"] = "getholiday"
        param["sfcode"] = appsetup.sfCode ?? ""
        param["division_code"] = appsetup.divisionCode ?? ""
        param["Rsf"] = appsetup.sfCode ?? ""
        param["sf_type"] = appsetup.sfType ?? ""
        param["Designation"] = appsetup.dsName ?? ""
        param["state_code"] = appsetup.stateCode ?? ""
        param["subdivision_code"] = appsetup.subDivisionCode ?? ""
        param["year"] = year ?? ""

        let paramString = ObjectFormatter.shared.convertJson2String(json: param)

        return ["data": paramString ?? ""]
        
      //  {"tableName":"getholiday","sfcode":"MR0026","division_code":"8,","Rsf":"MR0026","sf_type":"1","Designation":"TBM","state_code":"28","subdivision_code":"62,","year":"2023"}

    }
    
    
    static var tourPlanSetupParams : [String : Any] {
        let appsetup = AppDefaults.shared.getAppSetUp()
        var param = [String: Any]()
        param["tableName"] = "getall_tp"
        param["sfcode"] = "\(appsetup.sfCode!)"
        param["division_code"] = "\(appsetup.divisionCode!)"
        param["Rsf"] = "\(appsetup.sfCode!)"
        param["sf_type"] = "\(appsetup.sfType!)"
        param["Designation"] = "\(appsetup.dsName!)"
        param["state_code"] = "\(appsetup.stateCode!)"
        param["subdivision_code"] = "\(appsetup.subDivisionCode!)"
        
        let currentDate = Date()
        let calendar = Calendar.current

        // Get the current month and year components
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)

        // Convert the components to strings and add them to your parameters
        param["tp_month"] = "\(month),"
        param["tp_year"] = "\(year),"
        
      //  param["tp_month"] = "12,"
      //  param["tp_year"] = "2023,"
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum

        
        return toSendData
    }
}


