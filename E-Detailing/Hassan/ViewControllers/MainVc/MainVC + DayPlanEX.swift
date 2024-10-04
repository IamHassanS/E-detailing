//
//  MainVC + DayPlanEX.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 17/02/24.
//

import Foundation
import CoreData
import UIKit


class DayPlanSessions {
    var worktype: WorkType
    var headQuarters: SelectedHQ
    var cluster: [Territory]
    var isSavedSession: Bool
    

    init() {
        worktype = WorkType()
        headQuarters = SelectedHQ()
        cluster = [Territory]()
        isSavedSession = false
       
    }
}

struct Sessions {
    var cluster : [Territory]?
    var workType: WorkType?
    var headQuarters: SelectedDayPlanHQ?
    var isRetrived : Bool?
    var  remarks : String?
    var isRejected: Bool?
    var rejectionReason: String?
    var isFirstCell : Bool?
    var planDate: Date?
    var isSynced: Bool?
}

extension MainVC {
    
    
    func toHighlightAddedCell()  {
        //        if sessions?.count == 2 {
        //
        //            return false
        //        } else {
        guard var nonEmptySession = self.sessions else  {
            return
        }
        
        
        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context),
              let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
              let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }
        
        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        let unsavedSessionsWithIndices = nonEmptySession.enumerated().filter { index, session in
            return !(session.isRetrived ?? false)
        }
        
        let unsavedSessions = unsavedSessionsWithIndices.map { index, session in
            return session
        }
        
        let indices = unsavedSessionsWithIndices.map { index, _ in
            return index
        }
        
        
        
        if unsavedSessions.isEmpty {
            
            var aSession = Sessions()
            
            aSession.cluster  = nil
            aSession.workType = nil
            aSession.headQuarters = nil
            aSession.isRetrived = Bool()
            
            nonEmptySession.insert(aSession, at: 0)
            // nonEmptySession.append(aSession)
            self.sessions = nonEmptySession
            self.unsavedIndex = indices.first
            self.isTohightCell = false
        
        } else {
            
            let unfilledSessionWithIndex = unsavedSessions.enumerated().filter { index, session in
                return  (session.cluster == nil || session.cluster == [temporaryselectedClusterobj] || session.headQuarters == nil ||  session.headQuarters == temporaryselectedHqobj || session.workType == nil || session.workType == temporaryselectedWTobj)
            }
            
            let  unfilledSessions = unfilledSessionWithIndex.map { index, session in
                return session
            }
            
            let unfilledindices = unfilledSessionWithIndex.map { index, _ in
                return index
            }
            
            
            if unfilledSessions.isEmpty {
                
                let unSentSessions = unfilledSessions.filter {($0.isRetrived ?? false)}
                
                if !unSentSessions.isEmpty {
                    var aSession = Sessions()
                    
                    aSession.cluster  = nil
                    aSession.workType = nil
                    aSession.headQuarters = nil
                    aSession.isRetrived = Bool()
                    
                    nonEmptySession.insert(aSession, at: 0)
                    //  nonEmptySession.append(aSession)
                    self.sessions = nonEmptySession
                } else {
                    //   self.toCreateToast("please do save session to add plan")
                    self.unsavedIndex = unfilledindices.first
                    // self.isTohightCell = true
                 
                }
            } else {
                self.unsavedIndex = unfilledindices.first
                //  self.isTohightCell = true
             
            }
            
            
        }
        // }
        
        
    
        
    }
    
    func updateEachDayPlan(isSynced: Bool, planDate: Date, yetToSaveSession: [Sessions], completion: @escaping (Bool) -> ()) {
        // Remove all existing day plans
     //   CoreDataManager.shared.removeAllDayPlans()
        
        // Save sessions as day plans

        
        CoreDataManager.shared.saveSessionAsEachDayPlan(isSynced: isSynced, planDate: planDate, session: yetToSaveSession) { _ in
            // [weak self]
            //   guard let welf = self else { return }
           
                
                
                completion(true)
            
        }
    }

    
    func toFetchExistingPlan(byDate: Date, completion: @escaping ([Sessions]) -> ())  {
    
        var todayPlans : [DayPlan] = []
        CoreDataManager.shared.retriveSavedDayPlans(byDate: byDate) {dayplan in
            todayPlans = dayplan
            
            var aDaysessions : [Sessions] = []
            if !todayPlans.isEmpty {
                if let eachDayPlan = todayPlans.first {
                    
                
                
                    let headQuatersArr =  DBManager.shared.getSubordinate()
                    let workTypeArr = DBManager.shared.getWorkType()
                    
                    
                    guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: self.context),
                          let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: self.context)
                         // let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
                    else {
                        fatalError("Entity not found")
                    }
                    
                    let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                    let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
                  //  let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
                    
                    
                    if eachDayPlan.fwFlg != "" || eachDayPlan.wtCode != "" || eachDayPlan.townCode != "" || eachDayPlan.location != ""  {
                        
                        
                        let clusterArr = DBManager.shared.getTerritory(mapID: eachDayPlan.rsf)
                   
                        var selectedheadQuarters : SelectedDayPlanHQ?
                        var selectedWorkTypes: WorkType?
                        let codes = eachDayPlan.townCode
                        let codesArray = codes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        
                        let filteredTerritories = clusterArr.filter { aTerritory in
                            // Check if any code in codesArray is contained in aTerritory
                            return codesArray.contains { code in
                                return aTerritory.code?.contains(code) ?? false
                            }
                        }
                   

                        workTypeArr.forEach { aWorkType in
                            if aWorkType.code == eachDayPlan.wtCode  {
                                selectedWorkTypes = aWorkType
                            }
                        }
                        
                        headQuatersArr.forEach { aheadQuater in
                            if aheadQuater.id == eachDayPlan.rsf  {
                                
                                let hqModel =   HQModel()
                                hqModel.code = aheadQuater.id ?? ""
                                hqModel.name = aheadQuater.name ?? ""
                                hqModel.reportingToSF = aheadQuater.reportingToSF ?? ""
                                hqModel.steps = aheadQuater.steps ?? ""
                                hqModel.sfHQ = aheadQuater.sfHq ?? ""
                                hqModel.mapId = aheadQuater.mapId ?? ""
                                

                                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: self.context)
                                        
                                else {
                                    fatalError("Entity not found")
                                }
                                
                                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                                
                                temporaryselectedHqobj.code                  = hqModel.code
                                temporaryselectedHqobj.name                 = hqModel.name
                                temporaryselectedHqobj.reportingToSF       = hqModel.reportingToSF
                                temporaryselectedHqobj.steps                 = hqModel.steps
                                temporaryselectedHqobj.sfHq                   = hqModel.sfHQ
                                temporaryselectedHqobj.mapId                  = hqModel.mapId
                                
                                selectedheadQuarters   = temporaryselectedHqobj
                                
                                
                            }
                            
                        }
                        let tempSession = Sessions(cluster: filteredTerritories , workType: selectedWorkTypes ?? temporaryselectedWTobj, headQuarters: selectedheadQuarters ?? temporaryselectedHqobj, isRetrived: eachDayPlan.isRetrived, isRejected: eachDayPlan.isRejected, isFirstCell: true, planDate: eachDayPlan.tpDt.toDate(), isSynced: eachDayPlan.isSynced)
                        aDaysessions.append(tempSession)
                        

                        
                    }
                    
                    if eachDayPlan.fwFlg2 != "" || eachDayPlan.wtCode2 != "" || eachDayPlan.townCode2 != "" || eachDayPlan.location2 != ""  {
                        let clusterArr = DBManager.shared.getTerritory(mapID: eachDayPlan.rsf2)
                    
                        var selectedheadQuarters : SelectedDayPlanHQ?
                        var selectedWorkTypes: WorkType?
                        let codes = eachDayPlan.townCode2
                        let codesArray = codes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        
                        let filteredTerritories = clusterArr.filter { aTerritory in
                            // Check if any code in codesArray is contained in aTerritory
                            return codesArray.contains { code in
                                return aTerritory.code?.contains(code) ?? false
                            }
                        }

                        workTypeArr.forEach { aWorkType in
                            if aWorkType.code == eachDayPlan.wtCode2  {
                                selectedWorkTypes = aWorkType
                            }
                        }
                        
                        headQuatersArr.forEach { aheadQuater in
                            if aheadQuater.id == eachDayPlan.rsf2  {
                                
                             let hqModel =   HQModel()
                                hqModel.code = aheadQuater.id ?? ""
                                hqModel.name = aheadQuater.name ?? ""
                                hqModel.reportingToSF = aheadQuater.reportingToSF ?? ""
                                hqModel.steps = aheadQuater.steps ?? ""
                                hqModel.sfHQ = aheadQuater.sfHq ?? ""
                                hqModel.mapId = aheadQuater.mapId ?? ""
                                
                                
                                guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedDayPlanHQ", in: self.context)
                           
                                else {
                                    fatalError("Entity not found")
                                }

                                let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedDayPlanHQ
                       
                                temporaryselectedHqobj.code                  = hqModel.code
                                temporaryselectedHqobj.name                 = hqModel.name
                                temporaryselectedHqobj.reportingToSF       = hqModel.reportingToSF
                                temporaryselectedHqobj.steps                 = hqModel.steps
                                temporaryselectedHqobj.sfHq                   = hqModel.sfHQ
                                temporaryselectedHqobj.mapId                  = hqModel.mapId
                            
                                selectedheadQuarters   = temporaryselectedHqobj
                                

                            }
                            
                        }
                        
                        
                        let tempSession = Sessions(cluster: filteredTerritories , workType: selectedWorkTypes ?? temporaryselectedWTobj, headQuarters: selectedheadQuarters ?? temporaryselectedHqobj, isRetrived: eachDayPlan.isRetrived2, isRejected: eachDayPlan.isRejected, isFirstCell: false, planDate: eachDayPlan.tpDt.toDate(), isSynced: eachDayPlan.isSynced)
                      
                        aDaysessions.append(tempSession)
                    }
                    
        
                }
                
               // completion(aDaysessions)
            }
            
            completion(aDaysessions)
        }

     
        
    }
    
    func removeAllAddedCalls() {
        let fetchRequest: NSFetchRequest<AddedDCRCall> = NSFetchRequest(entityName: "AddedDCRCall")

        do {
            let slideBrands = try context.fetch(fetchRequest)
            for brand in slideBrands {
                context.delete(brand)
            }

            try context.save()
        } catch {
            print("Error deleting addedcalls: \(error)")
        }
    }
    
    
    func editDCRcall(call: AnyObject, type: DCRType) {
       // removeAllAddedCalls()
        let vc = AddCallinfoVC.initWithStory(viewmodel: self.userststisticsVM ?? UserStatisticsVM())
      
        vc.isForEdit = true
        
        guard let callvm = call as? CallViewModel else {
          
          return
        }
        let updatedCallVM = callvm.toRetriveDCRdata(dcrcall: callvm.call)
        vc.dcrCall = updatedCallVM
        
        CoreDataManager.shared.tofetchaSavedCalls(editDate: updatedCallVM.dcrDate ?? Date(), callID: updatedCallVM.code) { addedDCRcall in
            
            
            
            dump(addedDCRcall)
            
            
            let context = self.context
         
            guard let addedDCRcalls = addedDCRcall else {
                self.toCreateToast("Unable to edit selected call")
                return
            }
            
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
            guard (ftchedDCRcall != nil) else {return}
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
                
                vc.eventCaptureListViewModel = eventCaptureListViewModel
                
            
            
            
            
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
                    vc.detailedSlides = detailedSlides
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

                vc.additionalCallListViewModel = aAdditionalcallVM
                
            }
            
            //feecback
            if let userfeedback  =  ftchedDCRcall?.overAllFeedBack {
                if let entityDescription = NSEntityDescription.entity(forEntityName: "Feedback", in: context) {
                    let aFeedback = Feedback(entity: entityDescription, insertInto: context)
                    aFeedback.name = userfeedback.name
                    aFeedback.id = userfeedback.id
                    aFeedback.index = userfeedback.index
                    vc.overallFeedback = aFeedback
                }
            }

            //remarks || pob
            if let rematksValue  =  ftchedDCRcall?.overallRemarks {
                vc.overallRemarks = rematksValue
            }
            
            if let pobValue  =  ftchedDCRcall?.pobValue {
                vc.pobValue = pobValue
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
                vc.inputSelectedListViewModel = inputSelectedListViewModel
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
                vc.productSelectedListViewModel = productSelectedListViewModel
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
                vc.jointWorkSelectedListViewModel = jwSelectedListViewModel
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
                vc.rcpaDetailsModel = rcpaDetailsModelArr
               
            }

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func toAddnewSession() {
        var aSession = Sessions()
        
        aSession.cluster  = nil
        aSession.workType = nil
        aSession.headQuarters = nil
        aSession.isRetrived = Bool()
        aSession.isFirstCell = true
        aSession.planDate = self.selectedRawDate == nil ? Date() : self.selectedRawDate
        
       // setDateLbl(date: aSession.planDate ?? Date())
        
        self.sessions?.insert(aSession, at: 0)
    }
    
    func toEnableSaveBtn(sessionindex: Int, istoHandeleAddedSession: Bool) -> Bool {
        guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "SelectedHQ", in: context),
              let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
              let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
        else {
            fatalError("Entity not found")
        }
        var index: Int = 0
        index = sessionindex
        let temporaryselectedHqobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! SelectedHQ
        let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
        let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
        
        guard let nonNillSession = self.sessions else {return false}
        
        switch index {
        case 0, 1 :
            
            
            let model = nonNillSession[index]
            
            if model.workType == nil || model.workType == WorkType() || model.workType == temporaryselectedWTobj {
                return false
            }
            
            if model.workType?.fwFlg  != nil && model.workType?.fwFlg  != "F"  {
                return true
            } else {
                if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
                    
                    if (model.cluster ==  nil || model.cluster == [temporaryselectedClusterobj]) || model.cluster  == [Territory]() || model.cluster?[0].code == nil || (model.workType == nil ||  model.workType == temporaryselectedWTobj) {
                        return false
                    } else {
                        if nonNillSession[index].isRetrived ?? false {
                            return false
                        } else {
                            return true
                        }
                        
                        
                    }
                    
                } else {
                    
                    
                    
                    if (model.headQuarters ==  nil || model.headQuarters == temporaryselectedHqobj) || (model.cluster == nil || model.cluster == [temporaryselectedClusterobj]) || model.cluster  == [Territory]() || model.cluster?[0].code == nil || (model.workType == nil ||  model.workType == temporaryselectedWTobj)  {
                        return false
                    } else {
                        if nonNillSession[index].isRetrived ?? false {
                            if istoHandeleAddedSession {
                                return true
                            } else {
                                return false
                            }
                            
                            
                        } else {
                            return true
                        }
                    }
                    
                    
                }
            }
            
        default:
            return false
        }
        
    }
    
    func toConfigureMydayPlan(planDate: Date, isRetrived: Bool? = false, completion: @escaping () -> ()) {
        
        
        
        toFetchExistingPlan(byDate: planDate) { existingSessions in
            self.sessions = existingSessions
            if !(self.sessions?.isEmpty ?? false) {
                self.planSubmitted = true
               // self.setDateLbl(date: self.sessions?[0].planDate ?? Date())
                
                self.sessions?.enumerated().forEach { index, aSession in
                    switch index {
                    case 0:
                        dump(aSession.headQuarters?.code)
                        self.fetchedHQObject1 =  self.getSubordinate(hqCode: aSession.headQuarters?.code ?? "")
                        self.fetchedWorkTypeObject1 = aSession.workType
                        self.fetchedClusterObject1 = aSession.cluster
                        
                    case 1:
                        dump(aSession.headQuarters?.code)
                        self.fetchedHQObject2 =  self.getSubordinate(hqCode: aSession.headQuarters?.code ?? "")
                        self.fetchedWorkTypeObject2 = aSession.workType
                        self.fetchedClusterObject2 = aSession.cluster
                    default:
                        print("<----->")
                    }
                    
                }
            } else {
                self.selectedRawDate =  self.selectedRawDate  == nil ? Date() : self.selectedRawDate
                self.toAddnewSession()
            }
            
            
            
            guard let nonNilSessons = self.sessions else {
                
                self.configureAddplanBtn(false)
                self.configureSaveplanBtn(false)
                return
            }
            var isPlan1filled : Bool = false
            var isPlan2filled : Bool = false
            
            var istoEnableSaveBtn: Bool = false
            var istoEnableAddPlanBtn: Bool = false
            
            nonNilSessons.enumerated().forEach { index, aSession in
                switch index {
                case 0:

                    if aSession.isRetrived == true {
                        isPlan1filled =  true
                        
                        if nonNilSessons.count == 1 {
                            istoEnableAddPlanBtn = true
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableAddPlanBtn = false
                            istoEnableSaveBtn = false
                        }
                        
                    } else {
                        
                        isPlan1filled = self.toEnableSaveBtn(sessionindex: index, istoHandeleAddedSession: false)
                        //(aSession.cluster != nil || aSession.cluster != [] || aSession.workType != nil  || aSession.workType != WorkType() || aSession.headQuarters != nil || aSession.headQuarters != SelectedHQ())
                    }
                    
                    if isPlan1filled {
                        
                        if aSession.isRetrived == true {
                            
                            if nonNilSessons.count == 1 {
                                istoEnableAddPlanBtn = true
                            } else {
                                istoEnableAddPlanBtn = false
                            }
                            
                        } else {
                            istoEnableAddPlanBtn = false
                        }
                        
                        
                        
                        if aSession.isRetrived == true {
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableSaveBtn = true
                        }
                        
                    } else {
                        istoEnableAddPlanBtn = false
                        istoEnableSaveBtn = false
                    }
     
                case 1:
                    
                    if aSession.isRetrived == true {
                        isPlan2filled =  true
                        
                        if nonNilSessons.count == 1 {
                            istoEnableAddPlanBtn = true
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableAddPlanBtn = false
                            istoEnableSaveBtn = false
                        }
                        
                    } else {
                        isPlan2filled = self.toEnableSaveBtn(sessionindex: index, istoHandeleAddedSession: false)
                    }
                    
                    if isPlan2filled {
                        if aSession.isRetrived == true {
                            
                            if nonNilSessons.count == 1 {
                                istoEnableAddPlanBtn = true
                            } else {
                                istoEnableAddPlanBtn = false
                            }
                            
                        } else {
                            istoEnableAddPlanBtn = false
                        }
                        if aSession.isRetrived == true {
                            istoEnableSaveBtn = false
                        } else {
                            istoEnableSaveBtn = true
                        }
                    } else {
                        istoEnableAddPlanBtn = false
                        istoEnableSaveBtn = false
                    }
                    
                default:
                    isPlan1filled = false
                    isPlan2filled = false
                }
                
                
            }
            self.configureAddplanBtn(istoEnableAddPlanBtn)
            self.configureSaveplanBtn(istoEnableSaveBtn)
            self.toLoadWorktypeTable()
            completion()
            
        }
        
    }

}


