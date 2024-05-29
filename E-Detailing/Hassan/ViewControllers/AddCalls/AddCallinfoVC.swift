//
//  swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/03/24.
//

import Foundation
import UIKit
import CoreData
class AddCallinfoVC: BaseViewController {
    
    @IBOutlet var addCallinfoView: AddCallinfoView!
    let appsetup = AppDefaults.shared.getAppSetUp()
    var dcrCall : CallViewModel!
    var userStatisticsVM: UserStatisticsVM?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pobValue: String?
    var overallRemarks: String?
    var overallFeedback: Feedback?
    var rcpaDetailsModel :  [RCPAdetailsModal] = []
    var eventCaptureListViewModel = EventCaptureListViewModel()
    var jointWorkSelectedListViewModel = JointWorksListViewModel()
    var productSelectedListViewModel = ProductSelectedListViewModel()
    var additionalCallListViewModel = AdditionalCallsListViewModel()
    var inputSelectedListViewModel = InputSelectedListViewModel()
    var detailedSlides = [DetailedSlide]()
    var outBoxDataArr : [TodayCallsModel]?
    var unsyncedhomeDataArr = [UnsyncedHomeData]()
    class func initWithStory(viewmodel: UserStatisticsVM) -> AddCallinfoVC {
        let reportsVC : AddCallinfoVC = UIStoryboard.Hassan.instantiateViewController()
        reportsVC.userStatisticsVM = viewmodel
       // reportsVC.pageType = pageType
        return reportsVC
    }
    
    
    func setupParam(dcrCall: CallViewModel) {
        
        
        let persistentContainer = appdelegate.persistentContainer
        let managedObjectContext = persistentContainer.viewContext
        var savedPath : String = ""
        if let persistentStore = managedObjectContext.persistentStoreCoordinator?.persistentStores.first {
            if let storeURL = persistentStore.url {
                print("Core Data SQLite file path: \(storeURL)")
                savedPath = "\(storeURL)"
            }
        }
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
        

        let productValue = self.addCallinfoView.productSelectedListViewModel.productData()
        let inputValue = self.addCallinfoView.inputSelectedListViewModel.inputData()
        let jointWorkValue = self.addCallinfoView.jointWorkSelectedListViewModel.getJointWorkData()
        let additionalCallValue = self.addCallinfoView.additionalCallListViewModel.getAdditionalCallData()
        
        let rcpaValue =  self.addCallinfoView.rcpaDetailsModel
        let evenetCaptureValue = self.addCallinfoView.eventCaptureListViewModel
        
       
        
        var addedDCRCallsParam: [String: Any] = [:]
        
        //Joint works
        var addedJointworks = [[String: Any]]()
        addedJointworks.removeAll()

        for jointWork in jointWorkValue{
            
            var aJointwork = [String: Any]()
            aJointwork["Code"] = jointWork.code
            aJointwork["Name"] = jointWork.name
            
            addedJointworks.append(aJointwork)
        }
        
        addedDCRCallsParam["JointWork"] = addedJointworks
        
        
        //Inputs
        var addedInput = [[String: Any]]()
        for input in inputValue{
            var aInput = [String: Any]()
            aInput["Code"] = input.code
            aInput["Name"] = input.name
            aInput["IQty"] = input.inputCount
            addedInput.append(aInput)
        }
        
        
        
        
        addedDCRCallsParam["Inputs"] = addedInput
        //Products Detailed
        // Assuming you have detailedSlides array
 //       var detailedSlides = Shared.instance.detailedSlides

        
//        var addedDetailedProducts = [[String: Any]]()
//        addedDetailedProducts.removeAll()
//
//        detailedSlides.forEach { aDetailedSlide in
//                var aproduct : [String : Any] = [:]
//                // groupedSlides.forEach
//                aproduct["Code"] = aDetailedSlide.brandCode
//                aproduct["Group"] = "1"
//                aproduct["ProdFeedbk"] = ""
//                aproduct["Rating"] = ""
//                aproduct["Appver"] = "Test.S.1.0"
//                aproduct["Mod"] = "iOS-Edet"
//                aproduct["Type"] = cusType
//                var timesLine = [String: Any]()
//                timesLine["sTm"] = aDetailedSlide.startTime ?? ""
//                timesLine["eTm"] = aDetailedSlide.endTime ?? ""
//                aproduct["Timesline"] = timesLine
//                
//                aproduct["Slides"] = [[String: Any]]()
//                var aslideParamArr = [[String: Any]]()
//            
//                aDetailedSlide.groupedSlides?.enumerated().forEach {index, aSlide in
//                    
//                    aproduct["Name"] = aSlide.name
//                    var aSlideParam: [String :Any] = [:]
//                    aSlideParam["Slide"] = aSlide.name
//                    aSlideParam["SlidePath"] = savedPath
//                    aSlideParam["Scribbles"] = ""
//                    aSlideParam["SlideRemarks"] = aDetailedSlide.remarks
//                    aSlideParam["SlideType"] =  aSlide.fileType
//                    aSlideParam["SlideRating"] = aDetailedSlide.remarksValue
//                    aSlideParam["Times"] = [[String: Any]]()
//                    var previewTimeArr:  [[String : Any]] = [[:]]
//                    previewTimeArr.removeAll()
//                    var previewTime : [String: Any] = [:]
//                    previewTime.removeAll()
//                    previewTime["sTm"] = aDetailedSlide.startTime
//                    previewTime["eTm"] = aDetailedSlide.endTime
//                    previewTimeArr.append(previewTime)
//                    aSlideParam["Times"] = previewTimeArr
//                    aslideParamArr.append(aSlideParam)
//                  
//                }
//                aproduct["Slides"] = aslideParamArr
//                addedDetailedProducts.append(aproduct)
//            
//        }
//        dump(addedDetailedProducts)
        var detailedSlides = Shared.instance.detailedSlides

            // Create a dictionary to group slides by brandCode
            var groupedSlides: [Int: [SlidesModel]] = [:]

            // Group slides by brandCode
            for slide in detailedSlides {
                if let brandCode = slide.brandCode {
                    if groupedSlides[brandCode] == nil {
                        groupedSlides[brandCode] = []
                    }
                    if let slides = slide.groupedSlides {
                        groupedSlides[brandCode]?.append(contentsOf: slides)
                    }
                }
            }

            // Iterate through the detailedSlides array and update each DetailedSlide object
            for (index, detailedSlide) in detailedSlides.enumerated() {
                if let groupedSlidesForBrand = groupedSlides[detailedSlide.brandCode ?? Int()] {
                    detailedSlides[index].groupedSlides = groupedSlidesForBrand
                }
            }

            // Create a dictionary to group DetailedSlides by brandCode
            var groupedDetailedSlides: [Int: [DetailedSlide]] = [:]

            // Group DetailedSlides by brandCode
            for slide in detailedSlides {
                if let brandCode = slide.brandCode {
                    if groupedDetailedSlides[brandCode] == nil {
                        groupedDetailedSlides[brandCode] = []
                    }
                    groupedDetailedSlides[brandCode]?.append(slide)
                }
            }

            // Convert the groupedSlides dictionary into an array of arrays
        let mappedArray =  Shared.instance.detailedSlides
        //groupedDetailedSlides.values.map { $0 }

            
            
            
            var addedDetailedProducts = [[String: Any]]()
            addedDetailedProducts.removeAll()
            
            dump(mappedArray)
    //        mappedArray.forEach { DetailedSlide in
    //
    //        }
            
            mappedArray.forEach { detailedSlideArr in
                let groupSlides: [SlidesModel] = detailedSlideArr.groupedSlides ?? []
//                detailedSlideArr.forEach { aDetailedSlide in
//                    if let aSlideModel = aDetailedSlide.slidesModel {
//                        groupSlides.append(aSlideModel)
//                    }
//                }
    
                //detailedSlideArr.first
               
                    var aproduct : [String : Any] = [:]
                    // groupedSlides.forEach
                    aproduct["Code"] =  detailedSlideArr.brandCode
                    //aDetailedSlide.brandCode
                    aproduct["Group"] = "1"
                    aproduct["ProdFeedbk"] = detailedSlideArr.remarks
                    aproduct["Rating"] = detailedSlideArr.remarksValue
                    aproduct["Appver"] = "Test.S.1.0"
                    aproduct["Mod"] = "iOS-Edet"
                    aproduct["Type"] = cusType
                    var timesLine = [String: Any]()
                    timesLine["sTm"] = detailedSlideArr.startTime ?? ""
                    timesLine["eTm"] = detailedSlideArr.endTime ?? ""
                    aproduct["Timesline"] = timesLine
                    
                    aproduct["Slides"] = [[String: Any]]()
                    var aslideParamArr = [[String: Any]]()
                    groupSlides.enumerated().forEach {index, aSlide in

                        
                        aproduct["Name"] = aSlide.name
                        var aSlideParam: [String :Any] = [:]
                        aSlideParam["Slide"] = aSlide.name
                        aSlideParam["SlidePath"] = savedPath
                        aSlideParam["Scribbles"] = ""
                        aSlideParam["SlideRemarks"] = detailedSlideArr.remarks
                        aSlideParam["SlideType"] =  aSlide.fileType
                        aSlideParam["SlideRating"] = detailedSlideArr.remarksValue
                        aSlideParam["Times"] = [[String: Any]]()
                        var previewTimeArr:  [[String : Any]] = [[:]]
                        previewTimeArr.removeAll()
                        var previewTime : [String: Any] = [:]
                        previewTime.removeAll()
                        previewTime["sTm"] = detailedSlideArr.startTime
                        previewTime["eTm"] = detailedSlideArr.endTime
                        previewTimeArr.append(previewTime)
                        aSlideParam["Times"] = previewTimeArr
                        aslideParamArr.append(aSlideParam)
                      
                    }
                    aproduct["Slides"] = aslideParamArr
                    addedDetailedProducts.append(aproduct)
                
            }
            dump(addedDetailedProducts)
        
        //Products not Detailed
        var addedProducts = [[String: Any]]()
        addedProducts.removeAll()
      //  let slides : [String : Any] = ["Slide" : "", "SlidePath" : "", "SlideRemarks" : "", "SlideType" : "", "SlideRating" : "", "Times" : "times"]
        
        
        for product in productValue {
            var aproduct : [String : Any] = [:]
            aproduct["Code"] = product.code
            aproduct["Name"] =  product.name
            aproduct["Group"] = "0"
            aproduct["ProdFeedbk"] = ""
            aproduct["Rating"] = ""
            var timesLine = [String: Any]()
            timesLine["sTm"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
            timesLine["eTm"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
            aproduct["Timesline"] = timesLine
            aproduct["Appver"] = "Test.S.1.0"
            aproduct["Mod"] = "iOS-Edet"
            aproduct["SmpQty"] = product.sampleCount
            aproduct["RcpaQty"] = product.rcpaCount
            aproduct["RxQty"] = product.rxCount
            aproduct["Promoted"] = product.isDetailed ? "0" : "1"
            aproduct["Type"] = cusType
            aproduct["StockistName"] = product.stockistName
            aproduct["StockistCode"] = product.stockistCode
            aproduct["Slides"] = [[String: Any]]()
            addedProducts.append(aproduct)
        }
        
        addedDCRCallsParam["Products"] = addedProducts + addedDetailedProducts
        
        //Additional Customers
        var additionalCustomerParams = [[String: Any]]()
        additionalCustomerParams.removeAll()
        additionalCallValue.enumerated().forEach { index, call in
            var aAdditioanlcall : [String : Any] = [:]
            aAdditioanlcall["Code"] = call.docCode
            aAdditioanlcall["Name"] = call.docName
            aAdditioanlcall["town_code"] = call.docTownCode
            aAdditioanlcall["town_name"] = call.docTownName
          
            //Additional call products
            if let productValue = call.productSelectedListViewModel.fetchAllProductData() {
                var products: [[String: Any]] = [[:]]
                products.removeAll()
                for product in productValue {
                    var aproduct : [String : Any] = [:]
                    aproduct["Code"] = product.product?.code
                    aproduct["Name"] =  product.product?.name
                    aproduct["SmpQty"] = product.sampleCount
                    products.append(aproduct)
                }
                aAdditioanlcall["Products"] = products
            }

            
            //Additional call Inputs
            if  let inputValue = call.inputSelectedListViewModel.fetchAllInputData() {
                var addedInput = [[String: Any]]()
                for input in inputValue{
                    var aInput = [String: Any]()
                    aInput["Code"] = input.input?.code
                    aInput["Name"] = input.input?.name
                    aInput["InpQty"] = input.inputCount
                    addedInput.append(aInput)
                }
                aAdditioanlcall["Inputs"] = addedInput
            }

            additionalCustomerParams.append(aAdditioanlcall)
        }
        
        addedDCRCallsParam["AdCuss"] = additionalCustomerParams
        

        
        
        var rcpaEntry = [[String: Any]]()

        for rcpa in rcpaValue {
            guard let addedChemist = rcpa.addedChemist,
                  let addedProductDetails = rcpa.addedProductDetails,
                  let addedProducts = addedProductDetails.addedProduct,
                  let addedQuantities = addedProductDetails.addedQuantity,
                  let addedRates = addedProductDetails.addedRate,
                  let addedValues = addedProductDetails.addedValue,
                  let addedTotals = addedProductDetails.addedTotal else {
                continue
            }
            
            for (index, productWithCompetitors) in addedProducts.enumerated() {
                var entryRCPAparam = [String: Any]()
                
                // Chemist information
                var chemistArr = [[String: Any]]()
                var rcpaChemist = [String: Any]()
                rcpaChemist["Name"] = addedChemist.name
                rcpaChemist["Code"] = addedChemist.code
                chemistArr.append(rcpaChemist)
                entryRCPAparam["Chemists"] = chemistArr
                
                // Product information
                if let addedProduct = productWithCompetitors.addedProduct {
                    entryRCPAparam["OPCode"] = addedProduct.code ?? ""
                    entryRCPAparam["OPName"] = addedProduct.name ?? ""
                }
                entryRCPAparam["OPQty"] = addedQuantities[index]
                entryRCPAparam["OPRate"] = addedRates[index]
                entryRCPAparam["OPValue"] = addedValues[index]
                entryRCPAparam["OPTotal"] = addedTotals[index]
                
                // Competitors information
                var competitorArr = [[String: Any]]()
                if let competitorsInfo = productWithCompetitors.competitorsInfo {
                    for competitorInfo in competitorsInfo {
                        var competitorEntry = [String: Any]()
                        competitorEntry["CPQty"] = competitorInfo.qty ?? ""
                        competitorEntry["CPRate"] = competitorInfo.rate ?? ""
                        competitorEntry["CPValue"] = competitorInfo.value ?? ""
                        competitorEntry["CompCode"] = competitorInfo.competitor?.compSlNo ?? ""
                        competitorEntry["CompName"] = competitorInfo.competitor?.compName ?? ""
                        competitorEntry["CompPCode"] = competitorInfo.competitor?.compProductSlNo ?? ""
                        competitorEntry["CompPName"] = competitorInfo.competitor?.compProductName ?? ""
                        competitorEntry["Chemname"] = addedChemist.name
                        competitorEntry["Chemcode"] = addedChemist.code
                        competitorEntry["CPRemarks"] = competitorInfo.remarks ?? ""
                        competitorArr.append(competitorEntry)
                    }
                }
                entryRCPAparam["Competitors"] = competitorArr
                
                rcpaEntry.append(entryRCPAparam)
            }
        }
        
        
    //    if isCompetitorExist {
            addedDCRCallsParam["RCPAEntry"] = rcpaEntry
    //    }
       
        
        
//Joint works

        var addedJointWorks  : [[String: Any]] = [[:]]
     
       
        let selectedJWs =  self.addCallinfoView.jointWorkSelectedListViewModel.getJointWorkData()
        for aJointWork in selectedJWs {
            var ajointWorkParam: [String: Any] = [:]
            ajointWorkParam["Code"] = aJointWork.code
            ajointWorkParam["Name"] = aJointWork.name
            addedJointWorks.append(ajointWorkParam)
        }
        addedDCRCallsParam["JWWrk"] = addedJointWorks
        
        addedDCRCallsParam["EventCapture"] = [[String: Any]]()
        var addedDCRCallsParamArr : [[String: Any]] = [[:]]
        addedDCRCallsParamArr.removeAll()
        let aEventDatum = evenetCaptureValue.EventCaptureData()
        aEventDatum.forEach { eventCaptureViewModel in
            var aCapturedEvent: [String: Any] = [:]

            // Mark EventCapture as "True"
            aCapturedEvent["EventCapture"] = "True"



            // Combine the components of the EventImageName
            let code = self.appsetup.sfCode ?? ""
            let uuid = eventCaptureViewModel.eventCapture.imageUrl.replacingOccurrences(of: "-", with: "")
            let eventImageName = code + "_" + dcrCall.code + uuid + ".jpeg"

            // Assign the EventImageName to aCapturedEvent
            aCapturedEvent["EventImageName"] = eventImageName

            // Set EventImageTitle and EventImageDescription
            aCapturedEvent["EventImageTitle"] = eventCaptureViewModel.title
            aCapturedEvent["EventImageDescription"] = eventCaptureViewModel.description

            // Set Eventfilepath
            aCapturedEvent["Eventfilepath"] = savedPath

            // Append aCapturedEvent to addedDCRCallsParamArr
            addedDCRCallsParamArr.append(aCapturedEvent)
        }
        addedDCRCallsParam["EventCapture"]  = addedDCRCallsParamArr
        
        let divisionCode = appsetup.divisionCode!.replacingOccurrences(of: ",", with: "")
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        
        addedDCRCallsParam["tableName"] = "postDCRdata"
        addedDCRCallsParam["CateCode"] = dcrCall.cateCode
        addedDCRCallsParam["CusType"] = cusType
        addedDCRCallsParam["CustCode"] = dcrCall.code
        addedDCRCallsParam["CustName"] = dcrCall.name
     
        addedDCRCallsParam["sfcode"] = appsetup.sfCode ?? ""
        addedDCRCallsParam["Rsf"] =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        addedDCRCallsParam["sf_type"] = "\(appsetup.sfType ?? 0)"
        addedDCRCallsParam["Designation"] = appsetup.dsName ?? ""
        addedDCRCallsParam["state_code"] = appsetup.stateCode ?? ""
        addedDCRCallsParam["subdivision_code"] = appsetup.subDivisionCode ?? ""
        addedDCRCallsParam["division_code"] = divisionCode
        addedDCRCallsParam["AppUserSF"] = appsetup.sfCode ?? ""
        addedDCRCallsParam["SFName"] = appsetup.sfName ?? ""
        addedDCRCallsParam["SpecCode"] = dcrCall.specialityCode
        addedDCRCallsParam["mappedProds"] = ""
        addedDCRCallsParam["mode"]  = "0"
        addedDCRCallsParam["Appver"] = "iEdet.1.1"
        addedDCRCallsParam["Mod"] = "ios-Edet-New"
        addedDCRCallsParam["WT_code"] = "2748"
        addedDCRCallsParam["WTName"] = "Field Work"
        addedDCRCallsParam["FWFlg"] = "F"
        addedDCRCallsParam["town_code"] = dcrCall.townCode
        addedDCRCallsParam["town_name"] = dcrCall.townName
        addedDCRCallsParam["ModTime"] = date
        addedDCRCallsParam["ReqDt"] = date
        addedDCRCallsParam["vstTime"] = date
        addedDCRCallsParam["Remarks"] =  self.addCallinfoView.overallRemarks ?? ""
        //self.txtRemarks.textColor == .lightGray ? "" : self.txtRemarks.text ?? ""
        addedDCRCallsParam["amc"] = ""
        addedDCRCallsParam["hospital_code"] = ""
        addedDCRCallsParam["hospital_name"] = ""
        addedDCRCallsParam["sample_validation"]  = "0"
        addedDCRCallsParam["input_validation"]  = "0"
        addedDCRCallsParam["sign_path"] = ""
        addedDCRCallsParam["SignImageName"] = ""
        addedDCRCallsParam["DCSUPOB"] =  self.addCallinfoView.pobValue
       // addedDCRCallsParam["checkout"] = dcrCall.dcrCheckinTime
       // addedDCRCallsParam["checkin"] = date
        //self.txtPob.text ?? ""
        if let overallFeedback = self.addCallinfoView.overallFeedback {
            
            if let id = overallFeedback.id   {
                addedDCRCallsParam["Drcallfeedbackcode"] = id
                addedDCRCallsParam["Drcallfeedbackname"] = overallFeedback.name ?? ""
            }
     
        }
        addedDCRCallsParam["sample_validation"] = "0"
        addedDCRCallsParam["input_validation"] = "0"

            if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isConnectedToNetwork) {
                    addedDCRCallsParam["address"] =  self.dcrCall.customerCheckOutAddress
                    let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: addedDCRCallsParam)
                    var toSendData = [String : Any]()
                    toSendData["data"] = jsonDatum
                    postDCRData(toSendData: toSendData, addedDCRCallsParam: addedDCRCallsParam, cusType: cusType, outboxParam: jsonDatum) { completion in
                        NotificationCenter.default.post(name: NSNotification.Name("callsAdded"), object: nil)
                        self.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
                    }
            } else {
                Shared.instance.showLoaderInWindow()
                addedDCRCallsParam["address"] =  ""
                toSaveaDCRcall(addedCallID: dcrCall.code, isDataSent: false) {[weak self] isSaved in
                    guard let welf = self else {return}
                    welf.saveCallsToDB(issussess: false, appsetup: welf.appsetup, cusType: cusType, param: addedDCRCallsParam) {
                        welf.toCacheCapturedEvents() { iscached in
                            Shared.instance.removeLoaderInWindow()
                            NotificationCenter.default.post(name: NSNotification.Name("callsAdded"), object: nil)
                            welf.popToBack(MainVC.initWithStory(isfromLaunch: false, ViewModel: UserStatisticsVM()))
                        }
                    
                    }
               
                }
              
            }
    }
    
    
    func toCacheCapturedEvents(completion: @escaping (Bool)->()) {
        var param = [String: Any]()
        param["tableName"] = "uploadphoto"
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        let dcrCall  = dcrCall.toRetriveDCRdata(dcrcall: dcrCall.call)
        param["custCode"] = dcrCall.code
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        if !addCallinfoView.eventCaptureListViewModel.eventCaptureViewModel.isEmpty {
           cacheUnsyncedEvents(eventcaputreDate: Date(), eventcaptureparam: jsonDatum) { isSaved in
                completion(true)
            }
        } else {
            completion(true)
        }

    }
    
    func postDCRData(toSendData: JSON, addedDCRCallsParam: JSON, cusType: String, isConnectedToNW: Bool? = true, outboxParam: Data? = nil, completion: @escaping (Bool) -> ()) {
        Shared.instance.showLoaderInWindow()
        
        
        
        var param = [String: Any]()
        param["tableName"] = "uploadphoto"
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        toSaveaDCRcall(addedCallID: dcrCall.code, isDataSent: false, OutboxParam: outboxParam ?? Data()) {[weak self] isSaved in
            guard let welf = self else {return}
            welf.callDCRScaeapi(toSendData: toSendData, params: addedDCRCallsParam, cusType: cusType) { isPosted in
                Shared.instance.removeLoaderInWindow()
                if !isPosted {
                    welf.saveCallsToDB(issussess: isPosted, appsetup: welf.appsetup, cusType: cusType, param: addedDCRCallsParam) {
                        welf.toCacheCapturedEvents() { isCached in
                            completion(true)
                        }
                    }
                } else {
                    let dispatchGroup = DispatchGroup()
                    welf.addCallinfoView.eventCaptureListViewModel.eventCaptureViewModel.forEach { aEventCaptureViewModel in
                        dispatchGroup.enter()
                        welf.callSaveimageAPI(param: param, paramData: jsonDatum, evencaptures: aEventCaptureViewModel) { result in
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        welf.toRemoveEditedCallOnline(param: addedDCRCallsParam) { _ in
                            NotificationCenter.default.post(name: NSNotification.Name("callsAdded"), object: nil)
                            completion(true)
                        }
                    }
                    
              
                }
             
                
            }
        }
    }
  
    
    func callSaveimageAPI(param: JSON, paramData: Data, evencaptures: EventCaptureViewModel, _ completion : @escaping (Result<GeneralResponseModal, UserStatisticsError>) -> Void) {
        
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

        userStatisticsVM?.toUploadCapturedImage(params: param, uploadType: .eventCapture, api: .imageUpload, image: [evencaptures.image!], imageName: [evencaptures.eventCapture.imageUrl], paramData: jsonDatum, custCode: dcrCall.code) { result in
                
                switch result {
                    
                case .success(let json):
                    dump(json)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let generalResponse = try JSONDecoder().decode(GeneralResponseModal.self, from: jsonData)
                       print(generalResponse)
                          if generalResponse.isSuccess ?? false {
                              self.toCreateToast("Image upload completed")
                              completion(.success(generalResponse))
                          } else {
//                              self.showAlertToEnableLocation(desc: "Image upload failed try again", istoToreTry: true) { isCompleted in
//                                  completion(.failure(UserStatisticsError.failedTouploadImage))
//                              }
                              self.toCreateToast("Image upload failed try again")
                              completion(.failure(UserStatisticsError.failedTouploadImage))
                          }
                    } catch {
                        
                        print("Unable to decode")
                    }

                case .failure(let error):
                    dump(error)
                    let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
                    self.cacheUnsyncedEvents(eventcaputreDate: Date(), eventcaptureparam: jsonDatum) { isSaved in
                        completion(.failure(UserStatisticsError.failedTouploadImage))
                
                    }
                    
                }
            }

        
        
    }
    
    
    func cacheUnsyncedEvents(eventcaputreDate: Date, eventcaptureparam: Data, completion: @escaping (Bool) -> ()) {
        let eventCaptures = self.addCallinfoView.eventCaptureListViewModel.EventCaptureData().map { $0.eventCapture }
        
        let fetchRequest: NSFetchRequest<UnsyncedEventCaptures> = UnsyncedEventCaptures.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", self.dcrCall.code)
        
        do {
            let results = try context.fetch(fetchRequest)
            let eventCapturesCDM: UnsyncedEventCaptures
            if let existingEventCapture = results.first {
                // Update existing entity
            
                let dispatchGroup = DispatchGroup()
                eventCapturesCDM = existingEventCapture
                existingEventCapture.eventcaptureParamData = eventcaptureparam
                dispatchGroup.enter()
                CoreDataManager.shared.toReturnEventcaptureEntity(eventCaptures: eventCaptures) { eventCaptureViewModelCDEntity in
                    eventCapturesCDM.unsyncedCapturedEvents = eventCaptureViewModelCDEntity
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) {
                    do {
                        try self.context.save()
                        completion(true)
                    } catch {
                        print("Failed to save to Core Data: \(error)")
                        completion(false)
                    }
                }
            } else {
                // Create new entity
                guard let eventCapturesNSEntityDescription = NSEntityDescription.entity(forEntityName: "UnsyncedEventCaptures", in: context) else {
                    completion(false)
                    return
                }
                eventCapturesCDM = UnsyncedEventCaptures(entity: eventCapturesNSEntityDescription, insertInto: context)
            }
            
            let dispatchGroup = DispatchGroup()
            
            eventCapturesCDM.eventcaptureDate = eventcaputreDate
            eventCapturesCDM.custCode = self.dcrCall.code
            eventCapturesCDM.eventcaptureParamData = eventcaptureparam
            
            dispatchGroup.enter()
            CoreDataManager.shared.toReturnEventcaptureEntity(eventCaptures: eventCaptures) { eventCaptureViewModelCDEntity in
                eventCapturesCDM.unsyncedCapturedEvents = eventCaptureViewModelCDEntity
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                do {
                    try self.context.save()
                    completion(true)
                } catch {
                    print("Failed to save to Core Data: \(error)")
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch or update entity: \(error)")
            completion(false)
        }
    }
    
//    func cacheUnsyncedEvents(eventcaputreDate: Date, eventcaptureparam: Data, completion: @escaping (Bool) -> ()) {
//        var eventCaptures = [EventCapture]()
//        let eventCaptureData = self.addCallinfoView.eventCaptureListViewModel.EventCaptureData()
//        
//        eventCaptureData.forEach { aEventCaptureViewModel in
//            eventCaptures.append(aEventCaptureViewModel.eventCapture)
//        }
//        
//        if let eventCapturesNSEntityDescription = NSEntityDescription.entity(forEntityName: "UnsyncedEventCaptures", in: context) {
//            
//            let eventCapturesCDM = UnsyncedEventCaptures(entity: eventCapturesNSEntityDescription, insertInto: context)
//            let dispatchGroup = DispatchGroup()
//           
//            eventCapturesCDM.eventcaptureDate  = eventcaputreDate
//            eventCapturesCDM.custCode = self.dcrCall.code
//            eventCapturesCDM.eventcaptureParamData = eventcaptureparam
//            dispatchGroup.enter()
//            CoreDataManager.shared.toReturnEventcaptureEntity(eventCaptures: eventCaptures) { eventCaptureViewModelCDEntity in
//                eventCapturesCDM.unsyncedCapturedEvents = eventCaptureViewModelCDEntity
//                dispatchGroup.leave()
//            }
//            
//     
//            
//            dispatchGroup.notify(queue: .main) {
//                do {
//                    try self.context.save()
//                    completion(true)
//                } catch {
//                    print("Failed to save to Core Data: \(error)")
//                    completion(false)
//                }
//                
//                
//            }
//        } else {
//            completion(false)
//        }
//        
//
//    }
    
    func toRemoveEditedCallOnline(param: JSON, completion: @escaping (Bool) -> ()) {
        let identifier = param["CustCode"] as? String // Assuming "identifier" is a unique identifier in HomeData
        
        CoreDataManager.shared.removeUnsyncedEventCaptures(withCustCode: identifier ?? "") { _ in}
   
        let context = DBManager.shared.managedContext()

        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = UnsyncedHomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", identifier ?? "")

        do {
            let results = try context.fetch(fetchRequest)
            if let existingObject = results.first {
                
                context.delete(existingObject)

                DBManager.shared.saveContext()
            } else {
                // Object not found, handle accordingly
                completion(true)
            }
        } catch {
            // Handle fetch error
            completion(true)
        }
        

       // let paramData = LocalStorage.shared.getData(key: LocalStorage.LocalValue.outboxParams)
        
        
        CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
            guard let aoutboxCDM = outboxCDMs.first else {
                completion(false)
                return
            }
            
            let coreparamDatum = aoutboxCDM.unSyncedParams
            
            guard let paramData = coreparamDatum else {
                completion(false)
                return}
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
            

            toSaveaParamData(jsonDatum: jsonDatum) {
                

                
                completion(true)
                
            }

        }

        
    }
    

    
    func showAlertToEnableLocation(desc: String, istoToreTry: Bool, completion: @escaping (Bool) -> ()) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Cancel",cancelAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            print("no action")
            // self.toDeletePresentation()
            
        }
        commonAlert.addAdditionalCancelAction {
            print("yes action")
            if istoToreTry {
                Shared.instance.showLoaderInWindow()
                var param = [String: Any]()
                param["tableName"] = "uploadphoto"
                param["sfcode"] = self.appsetup.sfCode
                param["division_code"] =  self.appsetup.divisionCode
                param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
                param["sf_type"] =  self.appsetup.sfType
                param["Designation"] =  self.appsetup.desig
                param["state_code"] =  self.appsetup.stateCode
                param["subdivision_code"] =  self.appsetup.subDivisionCode

                let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)

                var taskCompletion: Bool = false
                let dispatchGroup = DispatchGroup()

                var showAlert = true // Flag to show alert only once

                self.addCallinfoView.eventCaptureListViewModel.eventCaptureViewModel.forEach { aEventCaptureViewModel in
                    dispatchGroup.enter()
                    self.callSaveimageAPI(param: param, paramData: jsonDatum, evencaptures: aEventCaptureViewModel) { result in
                       
                        switch result {
                        
                        case .success(let json):
                            dump(json)
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                                let generalResponse = try JSONDecoder().decode(GeneralResponseModal.self, from: jsonData)
                                print(generalResponse)
                                if generalResponse.isSuccess ?? false {
                                    self.toCreateToast("Image upload completed")
                                    taskCompletion = true
                                } else {
                                    taskCompletion = false
                                }
                            } catch {
                                taskCompletion = false
                                print("Unable to decode")
                            }
                            dispatchGroup.leave()
                        case .failure(let error):
                            dump(error)
                            taskCompletion = false
                            dispatchGroup.leave()
                        }
                        
                        if showAlert && !taskCompletion { // Only show alert if showAlert is true and taskCompletion is false
                            showAlert = false
                            self.showAlertToEnableLocation(desc: "Image upload failed try again", istoToreTry: true, completion: completion)
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    completion(taskCompletion)
                }
            } else {
                self.redirectToSettings()
            }
           
            
        }
    }
    
    func redirectToSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    
    func showAlert() {
        showAlertToEnableLocation(desc: "Please enable location services in Settings.", istoToreTry: false) {_ in }
    }
    
    
        private func popToBack<T>(_ VC : T) {
            let mainVC = navigationController?.viewControllers.first{$0 is T}
    
            if let vc = mainVC {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    
    func callDCRScaeapi(toSendData: JSON, params: JSON, cusType: String, completion: @escaping (Bool) -> ()) {

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
 
    }
    
    func postDCTdata(_ param: [String: Any], paramData: JSON, _ completion : @escaping (Result<DCRCallesponseModel, UserStatisticsError>) -> Void)  {
       
        userStatisticsVM?.saveDCRdata(params: param, api: .saveDCR, paramData: paramData) { result in
            completion(result)
        }
    }
    
    func saveCallsToDB(issussess: Bool, appsetup: AppSetUp, cusType : String, param: [String: Any], completion: @escaping() -> ()) {

        
        if !issussess {
           // saveParamoutboxParamtoDefaults(param: param)
            saveParamoutboxParamtoCoreData(param: param, issussess: issussess, appsetup: appsetup, cusType: cusType) {isSaved in
            
                completion()
            }
        }
    }
    
    
    func toCheckandRemoveCoredataCallInstance() {
        
        
        
        
        
    }
    
    func toSaveunsyncedHomeData(issussess: Bool, appsetup: AppSetUp, cusType : String) {
        
        
        // Define the unique identifier
        let custCode = dcrCall.code
        
        // Fetch existing UnsyncedHomeData entity with the same CustCode
        let context = DBManager.shared.managedContext()
        let fetchRequest: NSFetchRequest<UnsyncedHomeData> = UnsyncedHomeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "custCode == %@", custCode)

        do {
            let existingEntities = try context.fetch(fetchRequest)
            
            if let existingEntity = existingEntities.first {
                existingEntity.custCode = dcrCall.code
                existingEntity.custType = cusType
                existingEntity.fw_Indicator = "F"
                existingEntity.dcr_dt = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
                existingEntity.month_name = Date().toString(format: "MMMM")
                existingEntity.mnth = Date().toString(format: "MM")
                existingEntity.yr =  Date().toString(format: "YYYY")
                existingEntity.custName = dcrCall.name
                existingEntity.town_code = dcrCall.townCode
                existingEntity.town_name = dcrCall.territory
                existingEntity.dcr_flag = ""
                existingEntity.sf_Code = appsetup.sfCode
                existingEntity.trans_SlNo = ""
                existingEntity.anslNo = ""
                existingEntity.isDataSentToAPI = issussess == true ?  "1" : "0"
                existingEntity.rejectionReason = issussess ?   "Call already exists." : "Waiting to sync"
                //dbparam["successMessage"] = issussess ? "call Aldready Exists" : "Waiting to sync"
                existingEntity.checkintime = dcrCall.dcrCheckinTime
                existingEntity.checkoutTime = dcrCall.dcrCheckOutTime
                
                if  self.dcrCall.type == .chemist {
                    existingEntity.custType = "2"
                  }
                  if  self.dcrCall.type == .stockist {
                      existingEntity.custType = "3"
                    }
                  if  self.dcrCall.type == .doctor {
                      existingEntity.custType = "1"
                    }
                  if  self.dcrCall.type == .hospital {
                      existingEntity.custType = "6"
                    }
                  if  self.dcrCall.type == .unlistedDoctor {
                      existingEntity.custType = "4"
                    }
                  if  self.dcrCall.type == .cip
                  {
                      existingEntity.custType = "5"
                    }
                
                DBManager.shared.saveContext()
                return
            }
        } catch {
            // Handle fetch error
        }
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
    }
    
    
    func touUdateOutboxandDefaultParams(param: JSON, completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
            guard let aoutboxCDM = outboxCDMs.first else {
                completion(false)
                return
            }
            
            let coreparamDatum = aoutboxCDM.unSyncedParams
            
            guard let paramData = coreparamDatum else {
                completion(false)
                return
            }
            
            var localParamArr = [String: [[String: Any]]]()
            do {
                localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
                dump(localParamArr)
            } catch {
                self.toCreateToast("unable to retrive")
            }
            
            let custCodeToUpdate = param["CustCode"] as! String
            
            // Iterate through the dictionary and update elements with the specified CustCode
            localParamArr = localParamArr.mapValues { callsArray in
                return callsArray.map { call in
                    var updatedCall = call
                    if let custCode = call["CustCode"] as? String, custCode == custCodeToUpdate {
                        // Update properties of the call
                        // For example:
                        // updatedCall["PropertyKey"] = newValue
                        updatedCall = param
                    }
                    return updatedCall
                }
            }
            
            // Convert the modified dictionary back to JSON data
            let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
            
            // Update the existing OutBoxParam entity
            if let entityDescription = NSEntityDescription.entity(forEntityName: "OutBoxParam", in: context) {
                let OutBoxParamCDModel = OutBoxParam(entity: entityDescription, insertInto: context)
                
                OutBoxParamCDModel.unSyncedParams = jsonDatum
                
                // Save to Core Data
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save to Core Data: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func toSaveaParamData(jsonDatum: Data, completion: @escaping () -> ()) {
        let managedObjectContext = DBManager.shared.managedContext() // Assuming DBManager.shared.managedContext() returns the managed object context
        
        // Fetch existing OutBoxParam entities and delete them
        let fetchRequest: NSFetchRequest<OutBoxParam> = OutBoxParam.fetchRequest()
        do {
            let existingParams = try managedObjectContext.fetch(fetchRequest)
            for param in existingParams {
                managedObjectContext.delete(param)
            }
        } catch {
            print("Failed to fetch existing OutBoxParam entities: \(error)")
            // Handle error
            completion()
            return
        }
        
        // Create a new OutBoxParam entity and assign the jsonDatum
        if let entityDescription = NSEntityDescription.entity(forEntityName: "OutBoxParam", in: managedObjectContext) {
            let outBoxParam = OutBoxParam(entity: entityDescription, insertInto: managedObjectContext)
            outBoxParam.unSyncedParams = jsonDatum
            
            // Save to Core Data
            do {
                try managedObjectContext.save()
                completion()
            } catch {
                print("Failed to save to Core Data: \(error)")
                // Handle error
            }
        } else {
            print("Entity description not found.")
            // Handle error
        }
    }
    
    func saveParamoutboxParamtoCoreData(param: JSON, issussess: Bool, appsetup: AppSetUp, cusType : String, completion: @escaping (Bool)->Void){
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

        CoreDataManager.shared.toFetchAllOutboxParams { outboxCDMs in
            guard let aoutboxCDM = outboxCDMs.first else {
                CoreDataManager.shared.removeAllOutboxParams()
                toSaveunsyncedHomeData(issussess: false, appsetup: self.appsetup, cusType:  cusType)
                toSaveaParamData(jsonDatum: jsonDatum) {
                    completion(true)
                   
                }
                return
               }
            
            let coreparamDatum = aoutboxCDM.unSyncedParams
            
            guard let paramData = coreparamDatum else {return
                
            }
           
            
            var localParamArr = [String: [[String: Any]]]()
            
            do {
                localParamArr  = try JSONSerialization.jsonObject(with: paramData, options: []) as? [String: [[String: Any]]] ?? [String: [[String: Any]]]()
                dump(localParamArr)
            //    let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: localParamArr)
                
            } catch {
                self.toCreateToast("unable to retrive")
            }
            if paramData.isEmpty {
                toSaveaParamData(jsonDatum: jsonDatum) {
                    completion(true)
                }
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
                        toSaveunsyncedHomeData(issussess: false, appsetup: self.appsetup, cusType:  cusType)
                        touUdateOutboxandDefaultParams(param: param) {_ in
                            completion(true)
                            return
                        }
                        
                        
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
                toSaveunsyncedHomeData(issussess: false, appsetup: self.appsetup, cusType:  cusType)
                
                toSaveaParamData(jsonDatum: jsonDatum) {
                    completion(true)
                }

            }
            
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
    
    func removeAllAddedCall(id: String) {
        let fetchRequest: NSFetchRequest<AddedDCRCall> = AddedDCRCall.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "addedCallID == %@", id)

        do {
            let existingCalls = try context.fetch(fetchRequest)
            for call in existingCalls {
                context.delete(call)
            }

            try context.save()
        } catch {
            print("Error deleting existing calls: \(error)")
        }
    }
    
    func toSaveaDCRcall(addedCallID: String, isDataSent: Bool, OutboxParam: Data? = nil , completion: @escaping (Bool) -> Void) {
        
        removeAllAddedCall(id: addedCallID)
        
        let context = self.context

        guard let entityDescription = NSEntityDescription.entity(forEntityName: "AddedDCRCall", in: context) else {
            print("Failed to get entity description")
            completion(false)
            return
        }
        
        let aDCRCallEntity = AddedDCRCall(entity: entityDescription, insertInto: context)
        aDCRCallEntity.addedCallID = addedCallID
        aDCRCallEntity.isDataSent = isDataSent
        
        let dispatchGroup = DispatchGroup()
        
        var productViewModel: ProductViewModelCDEntity?
        var inputViewModel: InputViewModelCDEntity?
        var jointWorkViewModel: JointWorkViewModelCDEntity?
        var additionalCallViewModel: AdditionalCallViewModelCDEntity?
        var rcpaDetailsModel : RCPAdetailsCDEntity?
        var detailSlidesModel :  DetailedSlideCDEntity?
        var eventCaptureViewModel : EventCaptureViewModelCDEntity?
        // Enter dispatch group for each CoreDataManager function
        dispatchGroup.enter()
        CoreDataManager.shared.toReturnProductViewModelCDModel(addedProducts: self.addCallinfoView.productSelectedListViewModel) { viewModel in
            productViewModel = viewModel
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        CoreDataManager.shared.toReturnInputViewModelCDModel(addedinputs: self.addCallinfoView.inputSelectedListViewModel) { viewModel in
            inputViewModel = viewModel
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        CoreDataManager.shared.toReturnJointWorkViewModelCDModel(addedJonintWorks: self.addCallinfoView.jointWorkSelectedListViewModel) { viewModel in
            jointWorkViewModel = viewModel
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        CoreDataManager.shared.toReturnAdditionalCallVM(addedAdditionalCalls: self.addCallinfoView.additionalCallListViewModel) { viewModel in
            additionalCallViewModel = viewModel
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        
        CoreDataManager.shared.toReturnRCPAdetailsCDEntity(rcpadtailsCDModels: self.addCallinfoView.rcpaDetailsModel) { viewModel in
            rcpaDetailsModel = viewModel
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        CoreDataManager.shared.toReturnDetailedSlideEntity(detailedSlides: Shared.instance.detailedSlides) { viewModel in
            Shared.instance.detailedSlides = []
            detailSlidesModel = viewModel
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        var eventCaptures = [EventCapture]()
        let eventCaptureData = self.addCallinfoView.eventCaptureListViewModel.EventCaptureData()
        
        eventCaptureData.forEach { aEventCaptureViewModel in
            eventCaptures.append(aEventCaptureViewModel.eventCapture)
        }
        
        CoreDataManager.shared.toReturnEventcaptureEntity(eventCaptures: eventCaptures) {  viewModel in
            eventCaptureViewModel = viewModel
            dispatchGroup.leave()
        }
        
        
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Feedback", in: context) {
            let aFeedback = Feedback(entity: entityDescription, insertInto: context)
            let userFeedback = self.addCallinfoView.overallFeedback
            
            aFeedback.name = userFeedback?.name
            aFeedback.id = userFeedback?.id
            aFeedback.index = userFeedback?.index ?? 0
            
            aDCRCallEntity.overAllFeedBack = aFeedback
        }
        
        aDCRCallEntity.overallRemarks = self.addCallinfoView.overallRemarks ?? ""
        aDCRCallEntity.pobValue =  self.addCallinfoView.pobValue
        aDCRCallEntity.outBoxParam = OutboxParam
        // Notify completion when all tasks in the dispatch group are completed
        dispatchGroup.notify(queue: .main) {
            // Assign retrieved view models to entity
            if let viewModel = productViewModel {
                aDCRCallEntity.productViewModel = viewModel
            }
            if let viewModel = inputViewModel {
                aDCRCallEntity.inputViewModel = viewModel
            }
            if let viewModel = jointWorkViewModel {
                aDCRCallEntity.jointWorkViewModel = viewModel
            }
            if let viewModel = additionalCallViewModel {
                aDCRCallEntity.additionalCallViewModel = viewModel
            }
            
            if let viewModel = rcpaDetailsModel {
                aDCRCallEntity.rcpaDetailsModel = viewModel
            }
            
            if let viewModel = detailSlidesModel {
                aDCRCallEntity.detailedSlides = viewModel
            }
            
            if let viewModel = eventCaptureViewModel {
                aDCRCallEntity.capturedEvents = viewModel
            }
            
            // Save to Core Data
            do {
                try context.save()
                completion(true)
            } catch {
                print("Failed to save to Core Data: \(error)")
                completion(false)
            }
        }
    }

    

    
}



struct SelectionList{

    var name : String
    var code : String

}
