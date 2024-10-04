//
//  OutboxParamParser.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 11/07/24.
//

import Foundation
import CoreData
import UIKit


struct OutboxModel {

    var rcpaDetailsModel =  [RCPAdetailsModal]()
    var eventCaptureListViewModel = EventCaptureListViewModel()
    var jointWorkSelectedListViewModel = JointWorksListViewModel()
    var productSelectedListViewModel = ProductSelectedListViewModel()
    var additionalCallListViewModel = AdditionalCallsListViewModel()
    var inputSelectedListViewModel = InputSelectedListViewModel()
    var detailedSlides = [DetailedSlide]()
    var pobValue: String?
    var overallRemarks: String?
    var overallFeedback: Feedback?
    var amc: String?
    var latitude: String?
    var longitude: String?
    var address: String?
}




class DCRCallObjectParser {
    
    static let instance = DCRCallObjectParser()
    var dcrCall: CallViewModel?
    private init(){}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let appsetup = AppDefaults.shared.getAppSetUp()
    
    func toSetDCRParam(outboxModel: OutboxModel, competion: @escaping (JSON?) -> ()) {
        guard let dcrCall = self.dcrCall?.toRetriveDCRdata(dcrcall: dcrCall) else {
            competion(nil)
            return }

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

        switch dcrCall.type {
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
        

        let productValue = outboxModel.productSelectedListViewModel.productData()
        let inputValue = outboxModel.inputSelectedListViewModel.inputData()
        let jointWorkValue = outboxModel.jointWorkSelectedListViewModel.getJointWorkData()
        let additionalCallValue = outboxModel.additionalCallListViewModel.getAdditionalCallData()
        let rcpaValue =  outboxModel.rcpaDetailsModel
        let evenetCaptureValue = outboxModel.eventCaptureListViewModel
        
       
        
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

        let mappedArray =   outboxModel.detailedSlides
        //Shared.instance.detailedSlides

            var addedDetailedProducts = [[String: Any]]()
            addedDetailedProducts.removeAll()
            
            dump(mappedArray)

            
            mappedArray.forEach { detailedSlideArr in
                let groupSlides: [SlidesModel] = detailedSlideArr.groupedSlides ?? []

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
                    aproduct["SamQty"] = product.sampleCount
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
       
        
        


        var addedJointWorks  : [[String: Any]] = [[:]]
     
       
        let selectedJWs =  outboxModel.jointWorkSelectedListViewModel.getJointWorkData()
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
        var date = Shared.instance.selectedDate.toString(format: "yyyy-MM-dd HH:mm:ss")
      
      
        if let callDate =  dcrCall.dcrDate {
            date = callDate.toString(format: "yyyy-MM-dd HH:mm:ss")
        }
        
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
        addedDCRCallsParam["town_code"] = dcrCall.townCode
        addedDCRCallsParam["town_name"] = dcrCall.townName
        addedDCRCallsParam["ModTime"] = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        addedDCRCallsParam["ReqDt"] = date
        addedDCRCallsParam["vstTime"] = date
        addedDCRCallsParam["Remarks"] =  outboxModel.overallRemarks ?? ""
        //self.txtRemarks.textColor == .lightGray ? "" : self.txtRemarks.text ?? ""

        addedDCRCallsParam["hospital_code"] = ""
        addedDCRCallsParam["hospital_name"] = ""
        addedDCRCallsParam["sample_validation"]  = "0"
        addedDCRCallsParam["input_validation"]  = "0"
        addedDCRCallsParam["sign_path"] = ""
        addedDCRCallsParam["SignImageName"] = ""
        addedDCRCallsParam["DCSUPOB"] =  outboxModel.pobValue
        addedDCRCallsParam["day_flag"] = "0"
        addedDCRCallsParam["amc"] = outboxModel.amc

        if let overallFeedback = outboxModel.overallFeedback {
            
            if let id = overallFeedback.id   {
                addedDCRCallsParam["Drcallfeedbackcode"] = id
                addedDCRCallsParam["Drcallfeedbackname"] = overallFeedback.name ?? ""
            }
     
        }
        addedDCRCallsParam["sample_validation"] = "0"
        addedDCRCallsParam["input_validation"] = "0"

        addedDCRCallsParam["address"] =  dcrCall.customerCheckOutAddress
        
        
        toRetriveFieldWorks(date: date) { [weak self] workTypeinfo in
            guard let welf = self  else {return}
            if let workTypeinfo = workTypeinfo {
                addedDCRCallsParam["WT_code"] = workTypeinfo.code
                addedDCRCallsParam["WTName"] = workTypeinfo.name
                addedDCRCallsParam["FWFlg"] = "F"
            }
            addedDCRCallsParam["address"] = outboxModel.address ?? "No address found"
            addedDCRCallsParam["Entry_location"] = "\(outboxModel.latitude ?? ""):\(outboxModel.longitude ?? "")"
            
//            if geoFencingEnabled {
//                welf.fetchLocations() {[weak self] locationInfo in
//                    guard let welf = self  else {return}
//                    guard let locationInfo = locationInfo else {
//                    competion(nil)
//                        return
//                    }
//                    addedDCRCallsParam["Entry_location"] = "\(locationInfo.latitude):\(locationInfo.longitude)"
//                    addedDCRCallsParam["address"] = locationInfo.address
//                    competion(addedDCRCallsParam)
//
//                }
//            } else {
                competion(addedDCRCallsParam)
           // }
            
        }
        

        


      
    }
    
    
    func toReturnModelobjects(call: AnyObject, type: DCRType, completion: @escaping (OutboxModel) -> ()) {
        
        guard let callvm = call as? CallViewModel else {
          
          return
        }
       
        let updatedCallVM = callvm.toRetriveDCRdata(dcrcall: callvm.call)
      //  vc.dcrCall = updatedCallVM
        var outboxModel = OutboxModel()
        self.dcrCall = updatedCallVM
        CoreDataManager.shared.tofetchaSavedCalls(editDate: updatedCallVM.dcrDate ?? Date(), callID: updatedCallVM.code) { addedDCRcall in
            
            dump(addedDCRcall)
            
            guard let addedDCRcalls = addedDCRcall else {
               // self.toCreateToast("Unable to edit selected call")
                completion(OutboxModel())
                return
            }
            
            let context = self.context
         

            
            var filteredcalls: [AddedDCRCall] = []
            
            addedDCRcalls.forEach { aAddedDCRCall in
                let dcrCalldate = aAddedDCRCall.callDate
                let dateStr = dcrCalldate?.toString(format: "yyyy-MM-dd")
                let editDate = callvm.dcrDate ?? Date()
                let editDateStr = editDate.toString(format: "yyyy-MM-dd")
                if dateStr == editDateStr {
                    filteredcalls.append(aAddedDCRCall)
                }
            }
             let ftchedDCRcall = filteredcalls.first
            guard (ftchedDCRcall != nil) else {
                completion(outboxModel)
                return}
            //[AdditionalCallViewModel]
            //Additional call
            
            let eventCaptureListViewModel = EventCaptureListViewModel()
         
                if let detailedSlidesCDEntity = ftchedDCRcall?.capturedEvents {
                    detailedSlidesCDEntity.capturedEvents?.forEach({ eventCaptureCDM in
                        if let aEventCaptureCDM = eventCaptureCDM as? EventCaptureCDM {
                            var aEventCapture = EventCapture()
                            aEventCapture.image =  UIImage(data: aEventCaptureCDM.image ?? Data())
                            aEventCapture.description = aEventCaptureCDM.imageDescription ?? ""
                            aEventCapture.imageUrl = aEventCaptureCDM.imageUrl ?? ""
                            aEventCapture.time = aEventCaptureCDM.time ?? ""
                            aEventCapture.timeStamp = aEventCaptureCDM.timeStamp ?? ""
                            aEventCapture.title = aEventCaptureCDM.title ?? ""
                            
                            
                            let aEventCaptureViewModel = EventCaptureViewModel(eventCapture: aEventCapture)
                            eventCaptureListViewModel.addEventCapture(aEventCaptureViewModel)
                        }
                    })
                        
                    }
                
            outboxModel.eventCaptureListViewModel = eventCaptureListViewModel
                
            
            
            
            
            var detailedSlides = [DetailedSlide]()
        
                
                //let detailedSlideCDEntity = DetailedSlideCDEntity(entity: entityDescription, insertInto: context)
                
                if let detailedSlidesCDEntity = ftchedDCRcall?.detailedSlides {
                    detailedSlidesCDEntity.detailedSlides?.forEach({ aDetailedSlideCD in
                        if let aDetailedSlideCDM = aDetailedSlideCD as? DetailedSlideCDM {
                            var aDetailedSlide = DetailedSlide()
                            
                            aDetailedSlide.brandCode = Int(aDetailedSlideCDM.brandCode ?? "0")
                            aDetailedSlide.endTime = aDetailedSlideCDM.endTime
                            aDetailedSlide.isDisliked = aDetailedSlideCDM.isDisliked
                            aDetailedSlide.isLiked = aDetailedSlideCDM.isLiked
                            aDetailedSlide.isShared = aDetailedSlideCDM.isShared
                            aDetailedSlide.remarks = aDetailedSlideCDM.remarks
                            aDetailedSlide.remarksValue = aDetailedSlideCDM.remarksValue
                            aDetailedSlide.slideID =  Int(aDetailedSlideCDM.slideID ?? "0")
                            aDetailedSlide.startTime = aDetailedSlideCDM.startTime
                         
                            
               
                             
                                if let slidesModel = aDetailedSlideCDM.slidesModel {
                                    
                               
                                        
                                    //    let aSlidesCDModelEntity = SlidesCDModel(entity: entityDescription, insertInto: context)
                                        let aViewedSlide = SlidesModel()
                                        aViewedSlide.code = Int(slidesModel.code)
                                        aViewedSlide.camp = Int(slidesModel.camp)
                                        aViewedSlide.productDetailCode = slidesModel.productDetailCode ?? ""
                                        aViewedSlide.filePath = slidesModel.filePath ?? ""
                                        aViewedSlide.group = Int(slidesModel.group)
                                        aViewedSlide.specialityCode = slidesModel.specialityCode ?? ""
                                        aViewedSlide.slideId = Int(slidesModel.slideId)
                                        aViewedSlide.fileType = slidesModel.fileType ?? ""
                                        aViewedSlide.categoryCode = slidesModel.categoryCode ?? ""
                                        aViewedSlide.name = slidesModel.name ?? ""
                                        aViewedSlide.noofSamples = Int(slidesModel.noofSamples)
                                        aViewedSlide.ordNo = Int(slidesModel.ordNo)
                                        aViewedSlide.priority = Int(slidesModel.priority)
                                        aViewedSlide.slideData =  Data() //aCacheSlide.slideData ??
                                        aViewedSlide.utType = slidesModel.utType ?? ""
                                        aViewedSlide.isSelected = slidesModel.isSelected
                                        aViewedSlide.isFailed = slidesModel.isFailed
                                        aViewedSlide.isDownloadCompleted = slidesModel.isDownloadCompleted
                                        
                                        
                                        aDetailedSlide.slidesModel = aViewedSlide
                                    
                                }
                            
                            detailedSlides.append(aDetailedSlide)
                        }
                        
                  
                    })
                    outboxModel.detailedSlides = detailedSlides
                }
 
                
        
            
            let aAdditionalcallVM =     AdditionalCallsListViewModel()
            
            if let additionalCallEntityDescription  = NSEntityDescription.entity(forEntityName: "AdditionalCallViewModelCDEntity", in: context) {
                let additionalCallCDEntity = ftchedDCRcall?.additionalCallViewModel ?? AdditionalCallViewModelCDEntity(entity: additionalCallEntityDescription, insertInto: context)
                
                
                
                
                if let addedAdditionalCall = additionalCallCDEntity.additionalCallViewModel {
                    addedAdditionalCall.forEach { additionalCallCDModel in
                        if let additionalCallCDModel = additionalCallCDModel as? AdditionalCallCDModel {
                            let aAdditionalCall = AdditionalCallViewModel(additionalCall: nil, isView: false)
                            aAdditionalCall.additionalCall = additionalCallCDModel.additionalCall
                            if let productViewModelEntityDescription  = NSEntityDescription.entity(forEntityName: "ProductViewModelCDEntity", in: context) {
                                
                                let productSelectedListViewModel = ProductSelectedListViewModel()
                                var productViewModelArr = [ProductViewModel]()
                                
                                let productSelectedListViewModelntity = additionalCallCDModel.productSelectedListViewModel ?? ProductViewModelCDEntity(entity: productViewModelEntityDescription, insertInto: context)
                                if let productViewModelEntityArr = productSelectedListViewModelntity.productViewModelArr {
                                    productViewModelEntityArr.forEach({ productDataCDModel in
                                        if let productDataCDModel = productDataCDModel as? ProductDataCDModel {
                                            var aProductData = ProductData(isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "", stockistName: "", stockistCode: "")
                                            
                                            
                                            aProductData.isDetailed = productDataCDModel.isDetailed
                                            aProductData.sampleCount = productDataCDModel.sampleCount ?? ""
                                            aProductData.rxCount = productDataCDModel.rxCount ?? ""
                                            aProductData.rcpaCount = productDataCDModel.rcpaCount ?? ""
                                            aProductData.availableCount = productDataCDModel.availableCount ?? ""
                                            aProductData.totalCount = productDataCDModel.totalCount ?? ""
                                            aProductData.stockistName = productDataCDModel.stockistName ?? ""
                                            aProductData.stockistCode = productDataCDModel.stockistCode ?? ""
                                            
                                            aProductData.product =  productDataCDModel.product
                                            
                                            let aproductViewModel = ProductViewModel(product: aProductData)
                                            
                                            productViewModelArr.append(aproductViewModel)
                                        }
                                    })
                                    productSelectedListViewModel.productViewModel = productViewModelArr
                                }
                                aAdditionalCall.productSelectedListViewModel = productSelectedListViewModel
                            }
                            
                            
                            
                            
                            if let inputViewModelEntityDescription  = NSEntityDescription.entity(forEntityName: "InputViewModelCDEntity", in: context) {
                                let inputSelectedListViewModelEntity = additionalCallCDModel.inputSelectedListViewModel ?? InputViewModelCDEntity(entity: inputViewModelEntityDescription, insertInto: context)
                                let inputSelectedListViewModel = InputSelectedListViewModel()
                                var inputViewModelArr = [InputViewModel]()
                                
                                if let inputViewModelEntityArr = inputSelectedListViewModelEntity.inputViewModelArr {
                                    inputViewModelEntityArr.forEach({ inputDataCDModel in
                                        if let inputDataCDModel = inputDataCDModel as? InputDataCDModel {
                                            
                                            var  aInputData = InputData(availableCount: "", inputCount: "")
                                            aInputData.availableCount = inputDataCDModel.availableCount ?? ""
                                            aInputData.inputCount = inputDataCDModel.inputCount ?? ""
                                            aInputData.input = inputDataCDModel.input
                                            let inputViewModel = InputViewModel(input: aInputData)
                                            inputViewModelArr.append(inputViewModel)
                                            
                                        }
                                    })
                                    inputSelectedListViewModel.inputViewModel = inputViewModelArr
                                }
                                
                                aAdditionalCall.inputSelectedListViewModel = inputSelectedListViewModel
                            }
                            
                            
                            if let inpuEntityDescription  = NSEntityDescription.entity(forEntityName: "InputDataCDModel", in: context) {
                                _ = additionalCallCDModel.inputs ?? InputDataCDModel(entity: inpuEntityDescription, insertInto: context)
                                
                                var inputs  = [InputViewModel]()
                                
                                if let  inputDataCDModelArr = additionalCallCDModel.inputs {
                                    inputDataCDModelArr.forEach { inputDataCDModel in
                                        if let inputDataCDModel = inputDataCDModel as? InputDataCDModel {
                                            
                                            var  aInputData = InputData(availableCount: "", inputCount: "")
                                            aInputData.availableCount = inputDataCDModel.availableCount ?? ""
                                            aInputData.inputCount = inputDataCDModel.inputCount ?? ""
                                            aInputData.input = inputDataCDModel.input
                                            
                                            
                                            let ainput = InputViewModel(input: aInputData)
                                            inputs.append(ainput)
                                        }
                                    }
                                }
                                aAdditionalCall.inputs = inputs
                            }
                            
                            
                            if let productEntityDescription  = NSEntityDescription.entity(forEntityName: "ProductDataCDModel", in: context) {
                                _ = additionalCallCDModel.products ?? ProductDataCDModel(entity: productEntityDescription, insertInto: context)
                                
                                var products = [ProductViewModel]()
                                
                                if let  productDataCDModelArr = additionalCallCDModel.products {
                                    
                                    productDataCDModelArr.forEach { productDataCDModel in
                                        if let productDataCDModel = productDataCDModel as? ProductDataCDModel {
                                            var aProductData = ProductData(isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "", stockistName: "", stockistCode: "")
                                            
                                            
                                            aProductData.isDetailed = productDataCDModel.isDetailed
                                            aProductData.sampleCount = productDataCDModel.sampleCount ?? ""
                                            aProductData.rxCount = productDataCDModel.rxCount ?? ""
                                            aProductData.rcpaCount = productDataCDModel.rcpaCount ?? ""
                                            aProductData.availableCount = productDataCDModel.availableCount ?? ""
                                            aProductData.totalCount = productDataCDModel.totalCount ?? ""
                                            aProductData.stockistName = productDataCDModel.stockistName ?? ""
                                            aProductData.stockistCode = productDataCDModel.stockistCode ?? ""
                                            
                                            aProductData.product =  productDataCDModel.product
                                            
                                            let aproductViewModel = ProductViewModel(product: aProductData)
                                            
                                            products.append(aproductViewModel)
                                        }
                                    }
                                    
                                }
                                aAdditionalCall.products = products
                            }
                            
                            
                            aAdditionalcallVM.addAdditionalCallViewModel(aAdditionalCall)
                        }
                    }
                }

                outboxModel.additionalCallListViewModel = aAdditionalcallVM
                
            }
            
            //feecback
            if let userfeedback  =  ftchedDCRcall?.overAllFeedBack {
                if let entityDescription = NSEntityDescription.entity(forEntityName: "Feedback", in: context) {
                    let aFeedback = Feedback(entity: entityDescription, insertInto: context)
                    aFeedback.name = userfeedback.name
                    aFeedback.id = userfeedback.id
                    aFeedback.index = userfeedback.index
                    outboxModel.overallFeedback = aFeedback
                }
            }

            //remarks || pob
            if let rematksValue  =  ftchedDCRcall?.overallRemarks {
                outboxModel.overallRemarks = rematksValue
            }
            
            if let pobValue  =  ftchedDCRcall?.pobValue {
                outboxModel.pobValue = pobValue
            }
            
            
            
            //Input
            if let inputEntityDescription  = NSEntityDescription.entity(forEntityName: "InputViewModelCDEntity", in: context) {
                let inputDetailsCDEntity = ftchedDCRcall?.inputViewModel ?? InputViewModelCDEntity(entity: inputEntityDescription, insertInto: context)
                
                let inputSelectedListViewModel = InputSelectedListViewModel()
                inputSelectedListViewModel.uuid = inputDetailsCDEntity.uuid
                
                var inputViewModelArr =  [InputViewModel]()
                if let inputViewModelCDArr = inputDetailsCDEntity.inputViewModelArr {
                    inputViewModelCDArr.forEach { inputDataCDModel in
                        var aProductData = InputData(availableCount: "", inputCount: "")
                        if let ainputDataCDModel = inputDataCDModel as? InputDataCDModel {
                          
                            aProductData.availableCount = ainputDataCDModel.availableCount ?? ""
                            aProductData.inputCount = ainputDataCDModel.inputCount ?? ""
                            aProductData.input = ainputDataCDModel.input
                            
                          let inputViewModel = InputViewModel(input: aProductData)
                          inputViewModelArr.append(inputViewModel)
                        }
                    }
                }
                inputSelectedListViewModel.inputViewModel = inputViewModelArr
                outboxModel.inputSelectedListViewModel = inputSelectedListViewModel
            }
            
            //Product
            if let producEntityDescription  = NSEntityDescription.entity(forEntityName: "ProductViewModelCDEntity", in: context) {
                let productDetailsCDEntity = ftchedDCRcall?.productViewModel ?? ProductViewModelCDEntity(entity: producEntityDescription, insertInto: context)
                ///ProductSelectedListViewModel
                
                let productSelectedListViewModel = ProductSelectedListViewModel()
                productSelectedListViewModel.uuid = productDetailsCDEntity.uuid
                
                
                var productViewModelArr =  [ProductViewModel]()
                
                if let productViewModelCDArr =  productDetailsCDEntity.productViewModelArr {
                    productViewModelCDArr.forEach { productDetailsCDModel in
                        var aProductData = ProductData(isDetailed: false, sampleCount: "", rxCount: "", rcpaCount: "", availableCount: "", totalCount: "", stockistName: "", stockistCode: "")
                
                        if let aproductDetailsCDModel = productDetailsCDModel as? ProductDataCDModel {
                            
                            aProductData.product = aproductDetailsCDModel.product
                            
                            aProductData.availableCount = aproductDetailsCDModel.availableCount ?? ""
                            aProductData.isDetailed = aproductDetailsCDModel.isDetailed
                            aProductData.rcpaCount = aproductDetailsCDModel.rcpaCount ?? ""
                            aProductData.rxCount = aproductDetailsCDModel.rxCount ?? ""
                            aProductData.sampleCount = aproductDetailsCDModel.sampleCount ?? ""
                            aProductData.stockistCode = aproductDetailsCDModel.stockistCode ?? ""
                            aProductData.stockistName = aproductDetailsCDModel.stockistName ?? ""
                            aProductData.totalCount = aproductDetailsCDModel.totalCount ?? ""
                            
                            let productViewModel = ProductViewModel(product: aProductData)
                            productViewModelArr.append(productViewModel)
                        }
                    }
                }
                productSelectedListViewModel.productViewModel = productViewModelArr
                outboxModel.productSelectedListViewModel = productSelectedListViewModel
            }
            
            
            //Jointwork
            if let jwEntityDescription  = NSEntityDescription.entity(forEntityName: "JointWorkViewModelCDEntity", in: context) {
                let jwDetailsCDEntity = ftchedDCRcall?.jointWorkViewModel ?? JointWorkViewModelCDEntity(entity: jwEntityDescription, insertInto: context)
                ///ProductSelectedListViewModel
                
                let jwSelectedListViewModel = JointWorksListViewModel()
                
                
                
                var jwViewModelArr =  [JointWorkViewModel]()
                
                if let jwViewModelCDArr =  jwDetailsCDEntity.jointWorkViewModelArr {
                    jwViewModelCDArr.forEach { jwDetailsCDModel in
                       
                
                        if let ajwDetailsCDModel = jwDetailsCDModel as? JointWorkDataCDModel {
                            
                            if let jointWork = ajwDetailsCDModel.jointWork {
                                let ajwData = JointWorkViewModel(jointWork: jointWork)
                                jwViewModelArr.append(ajwData)
                                jwSelectedListViewModel.addJointWorkViewModel(ajwData)
                            }
                         
                        }
                        
                    }
                  
                }
               // productSelectedListViewModel.productViewModel = productViewModelArr
                outboxModel.jointWorkSelectedListViewModel = jwSelectedListViewModel
            }
            
            //RCPA
            if let rcpaEntityDescription = NSEntityDescription.entity(forEntityName: "RCPAdetailsCDEntity", in: context) {
                // dispatchGroup.enter()
                let rcpaDetailsCDEntity = ftchedDCRcall?.rcpaDetailsModel ?? RCPAdetailsCDEntity(entity: rcpaEntityDescription, insertInto: context)
                
                
                ///[RCPAdetailsModal]
                var rcpaDetailsModelArr = [RCPAdetailsModal]()

                if let rcpaDetailsCDModelArr = rcpaDetailsCDEntity.rcpadtailsCDModelArr  {
                    
                    rcpaDetailsCDModelArr.forEach { aRCPAdetailsCDModel in
                        
                        ///RCPAdetailsModal
                        let rcpaDetailsModel =  RCPAdetailsModal()
                        
                        if let aRCPAdetailsCDModel = aRCPAdetailsCDModel as? RCPAdetailsCDModel {
                            let addedChemist = aRCPAdetailsCDModel.addedChemist
                            rcpaDetailsModel.addedChemist = addedChemist
                            
                            ///ProductDetails
                            var aproductDetails = ProductDetails()
                            
                            if let  productDetailsCDModel = aRCPAdetailsCDModel.addedProductDetails {
                          
                                
                                aproductDetails.addedQuantity = productDetailsCDModel.addedQuantity
                                aproductDetails.addedRate =   productDetailsCDModel.addedRate
                                aproductDetails.addedTotal = productDetailsCDModel.addedTotal
                                aproductDetails.addedValue =  productDetailsCDModel.addedValue
                              
                                ///[ProductWithCompetiors]
                                var  addedProductsArr = [ProductWithCompetiors]()
                                
                                if let addedProductArr = productDetailsCDModel.addedProductArr {
                                    addedProductArr.forEach { addedProductWithCompetitor in
                                        
                                        ///ProductWithCompetiors
                                        var addedProduct = ProductWithCompetiors()
                                        
                                        if let addedProductWithCompetitor = addedProductWithCompetitor as? ProductWithCompetiorsCDModel {
        
                                            addedProduct.addedProduct = addedProductWithCompetitor.addedProduct
                                            
                                            ///AdditionalCompetitorsInfo
                                            var additionalCompetitorsInfoArr =  [AdditionalCompetitorsInfo]()
                                            
                                            if let competitorsInfoArr = addedProductWithCompetitor.competitorsInfoArr {
                                                competitorsInfoArr.forEach { additionalCompetitorsInfoCDModel in
                                                    
                                                    if let additionalCompetitorsInfoCDModel = additionalCompetitorsInfoCDModel as? AdditionalCompetitorsInfoCDModel {
                                                        
                                                        ///AdditionalCompetitorsInfo
                                                        
                                                        var additionalCompetitorsInfo = AdditionalCompetitorsInfo()
                                                        
                                                        additionalCompetitorsInfo.competitor =  additionalCompetitorsInfoCDModel.competitor
                                                        additionalCompetitorsInfo.qty =  additionalCompetitorsInfoCDModel.qty
                                                        additionalCompetitorsInfo.rate = additionalCompetitorsInfoCDModel.rate
                                                        additionalCompetitorsInfo.remarks = additionalCompetitorsInfoCDModel.remarks
                                                        additionalCompetitorsInfo.value = additionalCompetitorsInfoCDModel.value
                                                        additionalCompetitorsInfoArr.append(additionalCompetitorsInfo)
                                                    }
                                                }
                                                addedProduct.competitorsInfo = additionalCompetitorsInfoArr
                                            }
                                           
                                        }
                                        addedProductsArr.append(addedProduct)
                                        
                                    }
                                    aproductDetails.addedProduct = addedProductsArr
                                }
                                
                                rcpaDetailsModel.addedProductDetails = aproductDetails
                            }
                        }
                        rcpaDetailsModelArr.append(rcpaDetailsModel)
                    }
                    
                }
                 dump(rcpaDetailsModelArr)
                outboxModel.rcpaDetailsModel = rcpaDetailsModelArr
               
            }

            completion(outboxModel)
        }
    }
    
    struct LocationInfo {
        let latitude: Double
        let longitude: Double
        let address: String
    }
    
    func fetchLocations(completion: @escaping(LocationInfo?) -> ()) {
        Pipelines.shared.requestAuth() {[weak self] coordinates  in
            guard let welf = self else {return}
            
            if geoFencingEnabled {
                guard coordinates != nil else {
                    
                    completion(nil)
                    return
                }
            }

            if LocalStorage.shared.getBool(key: .isConnectedToNetwork) {
                Pipelines.shared.getAddressString(latitude: coordinates?.latitude ?? Double(), longitude:  coordinates?.longitude ?? Double()) { [weak self] address in
                    guard let welf = self else {return}

                    
                    completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address: address ?? "No address found"))
                }
            } else {
                
                completion(LocationInfo(latitude: coordinates?.latitude ?? Double(), longitude: coordinates?.longitude ?? Double(), address:  "No address found"))
            }
            
        }
    }
    
    struct wortTypeInfo {
        let code: String
        let name: String
    }
    
    func toRetriveFieldWorks(date: String, completion: @escaping (wortTypeInfo?) -> () ) {
        CoreDataManager.shared.retriveSavedDayPlans(byDate: date.toDate(format: "yyyy-MM-dd HH:mm:ss")) {dayplan in
            let filteredfieldWorks =  dayplan.filter { $0.fwFlg == "F" }.first
            guard let fieldWorks = filteredfieldWorks else {
                completion(nil)
                return }
            completion(wortTypeInfo(code:   fieldWorks.wtCode, name: fieldWorks.wtName))
          
            
            
        }
    }
    
}



