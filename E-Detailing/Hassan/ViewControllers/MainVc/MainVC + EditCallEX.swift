//
//  MainVC + EditCallEX.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/05/24.
//

import Foundation
import CoreData
import UIKit
extension MainVC {
    
    struct FetchedProductInfo {
        let product: String?
        let stock: String?
        let sample: String?
        let rxQty: String?
        let rcpa: String?
        
    }
    
    struct FetchedInputInfo {
        let input: String?
        let count: String?
        
    }
    
    struct AdditionalInfo {
        var feedback: Feedback?
        var pobValue: String?
        var overallRemarks: String?
        var amc: String?
    }
    
    func toCallEditAPI(dcrCall: TodayCallsModel) {
       
     //   {"headerno":"DP8-681","detno":"DP8-816","sfcode":"MR5940","division_code":"63,","Rsf":"MR5940","sf_type":"1","Designation":"MR","state_code":"2","subdivision_code":"86,","cusname":"A JAIN --- [ Doctor ]","custype":"1","pob":"1"}
        var dcrCalls: AnyObject?
        var   type:  DCRType?
        switch dcrCall.custType {
        case 1:
            let listedDocters = DBManager.shared.getDoctor()
           let filteredDoctores = listedDocters.filter { aDoctorFencing in
                aDoctorFencing.code == dcrCall.custCode
            }
            type = .doctor
            Shared.instance.selectedDCRtype = .Doctor
            dcrCalls = filteredDoctores.first
        case 2:
            let listedChemist = DBManager.shared.getChemist()
           let filteredChemist = listedChemist.filter { aChemist in
               aChemist.code == dcrCall.custCode
            }
            type = .chemist
            Shared.instance.selectedDCRtype = .Chemist
            dcrCalls = filteredChemist.first
            
        case 3:
            let listedStockist = DBManager.shared.getStockist()
           let filteredStockist = listedStockist.filter { aStockist in
               aStockist.code == dcrCall.custCode
            }
            type = .stockist
            Shared.instance.selectedDCRtype = .Stockist
            dcrCalls = filteredStockist.first
            
            
        case 4:
            let listedCustomers = DBManager.shared.getUnListedDoctor()
           let filteredCustomers = listedCustomers.filter { aCustomer in
               aCustomer.code == dcrCall.custCode
            }
            type = .unlistedDoctor
            Shared.instance.selectedDCRtype = .UnlistedDoctor
            dcrCalls = filteredCustomers.first
            
            
        default:
            print("Yet to")
        }
        guard let nonNilDcrCalls = dcrCalls else{return}
        Shared.instance.showLoaderInWindow()
        let aCallVM = CallViewModel(call: nonNilDcrCalls , type: type ?? .doctor)
        var param = [String: Any]()
        param["headerno"] = dcrCall.transSlNo 
        param["detno"] = dcrCall.aDetSLNo
        param["sfcode"] = appSetups.sfCode
        param["division_code"] = appSetups.divisionCode
        param["Rsf"] = LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appSetups.sfType
        param["Designation"] = appSetups.desig
        param["state_code"] = appSetups.stateCode
        param["subdivision_code"] = appSetups.subDivisionCode
        param["cusname"] = dcrCall.custName
        param["custype"] = dcrCall.custType
        param["pob"] = "1"
        let jsonDatum = ObjectFormatter.shared.convertJson2Data(json: param)
        var toSendData = [String: Any]()
        toSendData["data"] = jsonDatum
        print(param)
        self.userststisticsVM?.toEditAddedCall(params: toSendData, api: .editCall, paramData: param) {[weak self] result in
            guard let welf = self else {return}
            Shared.instance.removeLoaderInWindow()
            switch result {
                
            case .success(let response):
                dump(response)
                welf.toCreateViewModels(call: aCallVM, model: response)
            case .failure(let failure):
                welf.toCreateToast(failure.localizedDescription)
            }
        }
    }
    
    func toCreateViewModels(call: AnyObject, model: EditCallinfoModel) {
     
        let vc = AddCallinfoVC.initWithStory(viewmodel: self.userststisticsVM ?? UserStatisticsVM())
        
        vc.isForEdit = true
        if let rcpaHeadArr = model.rcpaHeadArr  {
            vc.rcpaDetailsModel =  toCreateRCPAdetailsModel(rcpa: rcpaHeadArr )
        }
    
        
        vc.productSelectedListViewModel = tocreateProductsViewModal(fetchedproducts: model.dcrDetailArr)
        
        vc.inputSelectedListViewModel = tocreateInputsViewModal(fetchedinputs: model.dcrDetailArr)
        
        vc.jointWorkSelectedListViewModel = toCreateJointWorksViewmodel(fetchedproducts: model.dcrDetailArr)
        
        vc.detailedSlides = toReturnFetchedDetailedSlides(fetchedDetails: model.digitalHeadArr)
        
       let fetchedAdditionalInfo = toReturnAdditionalAttributes(details: model.dcrDetailArr)
        
        vc.pobValue = fetchedAdditionalInfo.pobValue
        vc.overallFeedback = fetchedAdditionalInfo.feedback
        vc.overallRemarks = fetchedAdditionalInfo.overallRemarks
        vc.amc = fetchedAdditionalInfo.amc ?? ""
        vc.isForEdit = true
        vc.eventCaptureListViewModel = toCreateEventcaptureViewModel(fetchedCaptures: model.eventCaptureArr)
        
        guard let callvm = call as? CallViewModel else {
          
          return
            
        }
        let updatedCallVM = callvm.toRetriveDCRdata(dcrcall: callvm.call)
        
        vc.dcrCall = updatedCallVM
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func toReturnAdditionalAttributes(details: [DCRDetail]) -> AdditionalInfo{
        
        var fetchedInfo = AdditionalInfo()
        
        details.forEach { aDCRDetail in
            fetchedInfo.overallRemarks = aDCRDetail.activityRemarks
            fetchedInfo.pobValue = "\(aDCRDetail.pob)"
            
            
            let cacheFeedback = DBManager.shared.getFeedback()
            let fechedFeedback = cacheFeedback.filter { aFeedback in
                aFeedback.id == aDCRDetail.drCallFeedbackCode
            }.first
            
            fetchedInfo.feedback = fechedFeedback
            fetchedInfo.amc =  "\(aDCRDetail.transactionDetailSerialNumber)"
            
        }
        
        return fetchedInfo
    }
    
    func transformStringToProductObjects(_ inputString: String) -> [FetchedProductInfo] {
        var productInfoArray: [FetchedProductInfo] = []

        // Split the input string by '#'
        let components = inputString.components(separatedBy: "#")

        // Process each component
        for component in components {
            let parts = component.components(separatedBy: "~")

            if parts.count >= 2 {
                let product = parts[0]
                let details = parts[1].components(separatedBy: "^")

                if details.count >= 2 { // Ensure there are at least four elements in 'details'
                    let sample = details[0].components(separatedBy: "$")[0] // Extract sample
                    let stock = details[0].components(separatedBy: "$")[2] // Extract stock
                    let rxQty = details[0].components(separatedBy: "$")[1] // Extract rxQty
                    let rcpa = details[1] // Extract rcpa

                    // Create a FetchedProductInfo object and append it to the array
                    let productInfo = FetchedProductInfo(product: product, stock: stock, sample: sample, rxQty: rxQty, rcpa: rcpa)
                    productInfoArray.append(productInfo)
                }
            }
        }


        return productInfoArray
    }
    
    func transformStringToInputObjects(_ inputString: String) -> [FetchedInputInfo] {
        var inputInfoArray: [FetchedInputInfo] = []

        // Split the input string by '#'
        let components = inputString.components(separatedBy: "#")

        // Process each component
        for component in components {
            let parts = component.components(separatedBy: "~")

            if parts.count >= 2 {
                let input = parts[0]
                let count = parts[1]

                // Create a FetchedInputInfo object and append it to the array
                let inputInfo = FetchedInputInfo(input: input, count: count)
                inputInfoArray.append(inputInfo)
            }
        }

        return inputInfoArray
    }
    
    func toReturnPromotedProductCodes(promotedProductsString: String) -> [String] {
        var productCodes: [String] = []
        
        // Split the promotedProductsString by "#"
        let components = promotedProductsString.components(separatedBy: "#")
        
        // Process each component
        for component in components {
            // Split the component by "$"
            let parts = component.components(separatedBy: "$")
            
            // If there is at least one part, extract the product code
            if let productCode = parts.first {
                productCodes.append(productCode)
            }
        }
        
        return productCodes
    }
    
    
    func toReturnJointWorksCodes(jointWorkString: String) -> [String] {
        var jwCodes: [String] = []
        
        // Split the promotedProductsString by "#"
        let components = jointWorkString.components(separatedBy: "$$")
        
        // Process each component
        for component in components {
 
     
                jwCodes.append(component)
            
        }
        
        return jwCodes
    }
    
    func isURL(_ string: String) -> Bool {
        // Check if the string can be converted to a URL
        if let url = URL(string: string) {
            // Check if the URL has a valid scheme and host
            return url.scheme != nil && url.host != nil
        }
        return false
    }

    func toCreateEventcaptureViewModel(fetchedCaptures: [EventCaptureResponse]) -> EventCaptureListViewModel {
        let fetchedEventCaptureListViewModel = EventCaptureListViewModel()
        fetchedCaptures.forEach { aEventCaptureResponse in
            var aEventCapture = EventCapture()
            //https://sanffa.info/photos/MR5940_16793999AEB87DE4A764ECC915623D2040B2B71.jpeg
            let prefixURL = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageDownloadURL)
            var imageURLstr = aEventCaptureResponse.imageUrl
            if  !isURL(aEventCaptureResponse.imageUrl) {
                 imageURLstr = String(prefixURL + aEventCaptureResponse.imageUrl)
            }
            
            aEventCapture.image = nil
            //UIImage(systemName: "arrow.down.circle.dotted")
            aEventCapture.title = aEventCaptureResponse.title
            aEventCapture.description = aEventCaptureResponse.remarks
            aEventCapture.imageUrl = imageURLstr
           // aEventCapture.time =
          //  aEventCapture.timeStamp =
            
            
            
            let aEventCaptureViewModel = EventCaptureViewModel(eventCapture: aEventCapture)
            fetchedEventCaptureListViewModel.addEventCapture(aEventCaptureViewModel)
        }
        
        return fetchedEventCaptureListViewModel
    }
    
    
    func toCreateJointWorksViewmodel(fetchedproducts: [DCRDetail]) -> JointWorksListViewModel {
        
       // var jointworks = [JointWork]()
        let fetchedJointWorksListViewModel = JointWorksListViewModel()
        
        fetchedproducts.forEach { aDCRDetail in
           let jwCodeString = aDCRDetail.workedWithCode
            
           let jwCodes = toReturnJointWorksCodes(jointWorkString: jwCodeString)
            
            
            let cacheJointWork = DBManager.shared.getJointWork()
            
            let jointworks = cacheJointWork.filter { aJointWork in
                return jwCodes.contains(aJointWork.code ?? "")
            }
            jointworks.forEach { aJointWork in
                let aJointWorkViewModel = JointWorkViewModel(jointWork: aJointWork)
                fetchedJointWorksListViewModel.addJointWorkViewModel(aJointWorkViewModel)
            }
           
        }
        
        
        
        return fetchedJointWorksListViewModel
    }
    
    
    func toReturnFetchedDetailedSlides(fetchedDetails:  [DigitalHead]) -> [DetailedSlide] {
        
        var fetchedDetailedProduct = [DetailedSlide]()
        
       let detailedProducts = fetchedDetails.filter { aDigitalHead in
            aDigitalHead.groupID == "1"
        }
        
        detailedProducts.forEach { aDigitalHead in
           
            var aDetailedSlide = DetailedSlide()
            aDetailedSlide.brandCode = Int(aDigitalHead.productCode)
            aDetailedSlide.startTime = aDigitalHead.startTime.date
            aDetailedSlide.endTime = aDigitalHead.endTime.date
            
            
            let cacheBrand =  DBManager.shared.getBrands()
            let detailedBrand =   cacheBrand.filter { aBrand in
                aBrand.code == aDigitalHead.productCode
            }.first
            aDetailedSlide.brand = detailedBrand
            aDetailedSlide.brandCode = Int(aDigitalHead.productCode)
            aDetailedSlide.remarks = aDigitalHead.feedbackStatus
            aDetailedSlide.remarksValue = Float(aDigitalHead.rating)
            aDetailedSlide.groupedSlides  = [SlidesModel]()
            aDigitalHead.digitalDet.forEach { aDigitalDet in
                let aslidesModel: SlidesModel = SlidesModel()
                aslidesModel.name = aDigitalDet.slideName
                aslidesModel.fileType = aDigitalDet.slideType
                aDetailedSlide.groupedSlides?.append(aslidesModel)
            }
            fetchedDetailedProduct.append(aDetailedSlide)
        }
        
        return fetchedDetailedProduct
    }
    
    
    func tocreateProductsViewModal(fetchedproducts: [DCRDetail]) -> ProductSelectedListViewModel {
        var fetchedProductInfoArr: [FetchedProductInfo] = []
        
        
        let fetchedProductSelectedListViewModel = ProductSelectedListViewModel()
        fetchedproducts.forEach { aDCRDetail in
            let productCode = aDCRDetail.productCode + aDCRDetail.additionalProductCode
            
            fetchedProductInfoArr =  self.transformStringToProductObjects(productCode)
            
            fetchedProductInfoArr.forEach { aFetchedProductInfo in
                
                let cacheProducts = DBManager.shared.getProduct()
                let addedProduct = cacheProducts.filter { aProduct in
                    aProduct.code == aFetchedProductInfo.product
                }.first
                
                let promotedProductString = aDCRDetail.promotedProduct
                let promotedProductCodes = toReturnPromotedProductCodes(promotedProductsString: promotedProductString)
                //promotedProduct.components(separatedBy: "#")
                
                let aProductData = ProductData(product: addedProduct, isDetailed: promotedProductCodes.contains(aFetchedProductInfo.product ?? ""), sampleCount: aFetchedProductInfo.sample ?? "", rxCount: aFetchedProductInfo.rxQty ?? "", rcpaCount: aFetchedProductInfo.rcpa ?? "", availableCount: "", totalCount: "", stockistName: "", stockistCode: "")
                 let aProductVIewmodel = ProductViewModel(product: aProductData)
                
                fetchedProductSelectedListViewModel.addProductViewModel(aProductVIewmodel)
                
            }
            
        }
        return fetchedProductSelectedListViewModel
        
    }
    
    
    func tocreateInputsViewModal(fetchedinputs: [DCRDetail]) -> InputSelectedListViewModel {
        var fetchedInputInfoArr: [FetchedInputInfo] = []
        
        let cacheInputs = DBManager.shared.getInput()
        
        let fetchedInputSelectedListViewModel = InputSelectedListViewModel()
        fetchedinputs.forEach { aDCRDetail in
            //Main gifts
            let giftCode = aDCRDetail.giftCode +  aDCRDetail.additionalGiftCode
            let addedInput = cacheInputs.filter { aInput in
                aInput.code == giftCode
            }.first
         
            if let addedInput = addedInput {
                let aInputData = InputData(input: addedInput, availableCount: "", inputCount: aDCRDetail.giftQty)
                let aInputewmodel = InputViewModel(input: aInputData)
                fetchedInputSelectedListViewModel.addInputViewModel(aInputewmodel)
            }
          

            //Additional gifts
            let additionalinputCode = aDCRDetail.additionalGiftCode
            fetchedInputInfoArr =  self.transformStringToInputObjects(additionalinputCode)
            
            fetchedInputInfoArr.forEach { aFetchedInputInfo in
                
             
                let addedInput = cacheInputs.filter { aInput in
                    aInput.code == aFetchedInputInfo.input
                }.first
                let aInputData = InputData(input: addedInput, availableCount: "", inputCount: aFetchedInputInfo.count ?? "")
                let aInputewmodel = InputViewModel(input: aInputData)
                
                fetchedInputSelectedListViewModel.addInputViewModel(aInputewmodel)
                
            }
            
        }
        
        
        
        return fetchedInputSelectedListViewModel
        
    }
    
    func toCreateRCPAdetailsModel(rcpa: [RCPAHead]) -> [RCPAdetailsModal] {
        var chemistModelsMap: [String: RCPAdetailsModal] = [:]
        var rcpaDetailsModelArr : [RCPAdetailsModal] = []
        rcpa.forEach { aRCPAHead in
            // Create or retrieve RCPAdetailsModal for the chemist
            var isExistingElement: Bool = false
            let chemistCode = aRCPAHead.chmCode.replacingOccurrences(of: ",", with: "")
            let rcpaDetailsModel: RCPAdetailsModal
            if let existingModel = chemistModelsMap[chemistCode] {
                rcpaDetailsModel = existingModel
                isExistingElement = true
            } else {
                rcpaDetailsModel = RCPAdetailsModal()
                chemistModelsMap[chemistCode] = rcpaDetailsModel
                isExistingElement = false
            }

            // Populate RCPAdetailsModal with chemist details
            let loadedChemists = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            if let selectedChemist = loadedChemists.first(where: { $0.code == chemistCode }) {
                if let aChemistEntity = NSEntityDescription.entity(forEntityName: "Chemist", in: context) {
                    let aChemistCDM = Chemist(entity: aChemistEntity, insertInto: context)
                    aChemistCDM.chemistContact = selectedChemist.chemistContact
                    aChemistCDM.chemistEmail = selectedChemist.chemistEmail
                    aChemistCDM.chemistFax = selectedChemist.chemistFax
                    aChemistCDM.chemistMobile = selectedChemist.chemistMobile
                    aChemistCDM.chemistPhone = selectedChemist.chemistPhone
                    aChemistCDM.code = selectedChemist.code
                    aChemistCDM.geoTagCnt = selectedChemist.geoTagCnt
                    aChemistCDM.lat = selectedChemist.lat
                    aChemistCDM.long = selectedChemist.long
                    aChemistCDM.mapId = selectedChemist.mapId
                    aChemistCDM.maxGeoMap = selectedChemist.maxGeoMap
                    aChemistCDM.name = selectedChemist.name
                    aChemistCDM.sfCode = selectedChemist.sfCode
                    aChemistCDM.townCode = selectedChemist.townCode
                    aChemistCDM.townName = selectedChemist.townName
                    rcpaDetailsModel.addedChemist = aChemistCDM
                }
            }

            // Populate RCPAdetailsModal with product details
            var addedProductWithCompetitors = [ProductWithCompetiors]()
            var aAddedProductWithCompetitor = ProductWithCompetiors()
            let loadedProducts = DBManager.shared.getProduct()
            aAddedProductWithCompetitor.addedProduct = loadedProducts.first(where: { $0.code == aRCPAHead.opCode })
            var competitorsInfoArr = [AdditionalCompetitorsInfo]()
            aRCPAHead.rcpaDet.forEach { aRCPADet in
                var competitorsInfo = AdditionalCompetitorsInfo()
                if let aCompetitorEntity = NSEntityDescription.entity(forEntityName: "Competitor", in: context) {
                    let aCompetitor = Competitor(entity: aCompetitorEntity, insertInto: context)
                    if let ourProduct = aAddedProductWithCompetitor.addedProduct {
                        aCompetitor.compName = aRCPADet.compName
                        aCompetitor.compProductName = aRCPADet.compPName
                        aCompetitor.compProductSlNo = aRCPADet.compPCode
                        aCompetitor.index = Int16()
                        aCompetitor.ourProductCode = ourProduct.code
                        aCompetitor.ourProductName = ourProduct.name
                        competitorsInfo.competitor = aCompetitor
                    }
                }
                competitorsInfo.remarks = aRCPADet.cpRemarks
                competitorsInfo.rate = "\(aRCPADet.cpRate)"
                competitorsInfo.value = "\(aRCPADet.cpValue)"
                competitorsInfo.qty = "\(aRCPADet.cpQty)"
                competitorsInfoArr.append(competitorsInfo)
            }
            aAddedProductWithCompetitor.competitorsInfo = competitorsInfoArr
            addedProductWithCompetitors.append(aAddedProductWithCompetitor)
            if isExistingElement {
                var aProductDetails : ProductDetails = rcpaDetailsModel.addedProductDetails ?? ProductDetails()
                aProductDetails.addedProduct?.append(contentsOf: addedProductWithCompetitors)
                aProductDetails.addedQuantity?.append(contentsOf: ["\(aRCPAHead.opQty)"])
                aProductDetails.addedRate?.append(contentsOf: ["\(aRCPAHead.opRate)"])
                aProductDetails.addedValue?.append(contentsOf: ["\(aRCPAHead.opValue)"])
                aProductDetails.addedTotal?.append(contentsOf: ["\(aRCPAHead.opValue)"])
                rcpaDetailsModel.addedProductDetails = aProductDetails
            }
            else {
                var aProductDetails : ProductDetails = ProductDetails()
                aProductDetails.addedProduct = addedProductWithCompetitors
                aProductDetails.addedQuantity = ["\(aRCPAHead.opQty)"]
                aProductDetails.addedRate = ["\(aRCPAHead.opRate)"]
                aProductDetails.addedValue = ["\(aRCPAHead.opValue)"]
                aProductDetails.addedTotal =  ["\(aRCPAHead.opValue)"]
                rcpaDetailsModel.addedProductDetails = aProductDetails
            }
            if let index = rcpaDetailsModelArr.firstIndex(where: { $0.addedChemist?.code == chemistCode }) {
                rcpaDetailsModelArr[index] = rcpaDetailsModel
        } else {
                rcpaDetailsModelArr.append(rcpaDetailsModel)
            }
        }
        
        // Return the values of the chemistModelsMap
        return rcpaDetailsModelArr
    }
    
    
    func callSaveimageAPI(param: JSON, paramData: Data, evencaptures: EventCaptureViewModel, custCode: String, captureDate: Date, _ completion : @escaping (Result<GeneralResponseModal, UserStatisticsError>) -> Void) {
        
        _ = ObjectFormatter.shared.convertJson2Data(json: param)

        userststisticsVM?.toUploadCapturedImage(params: param, uploadType: .eventCapture, api: .imageUpload, image: [evencaptures.image!], imageName: [evencaptures.eventCapture.imageUrl], paramData: paramData, custCode: custCode) { result in
                
                switch result {
                    
                case .success(let json):
                    dump(json)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let generalResponse = try JSONDecoder().decode(GeneralResponseModal.self, from: jsonData)
                       print(generalResponse)
                          if generalResponse.isSuccess ?? false {
                             // self.toCreateToast("Image upload completed")
                              CoreDataManager.shared.removeUnsyncedEventCaptures(date: captureDate, withCustCode: custCode) { _ in
                                  completion(.success(generalResponse))
                              }
                              
                            
                          } else {
                       
                            //  self.toCreateToast("Image upload failed try again")
                              completion(.failure(UserStatisticsError.failedTouploadImage))
                          }
                    } catch {
                        
                        print("Unable to decode")
                    }

                case .failure(let error):
                    dump(error)
                }
            }

        
        
    }
}
