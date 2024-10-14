//
//  previewHomeView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/02/24.
//


import Foundation
import UIKit
import CoreData


protocol PreviewHomeViewDelegate: AnyObject {
    func didUserDetailedSlide()
}

extension PreviewHomeView: MenuResponseProtocol {
    func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to implement")
    }
    

    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        print("Yet to implement")
        switch type {
        case .speciality:
            if previewHomeVC.pageType == .detailing {
                self.fetchedSpecialityObject = selectedObject as? Speciality
                self.selectedSpecialityLbl.text = self.fetchedSpecialityObject?.name ?? "-"
                setDoctorSpeciality(specialityCode: self.fetchedSpecialityObject?.code ?? "")
                self.setPreviewType(.speciality)
            }
            
        case .theraptic:
            dump(selectedObject)
            self.fetchedTherapic = selectedObject as? SlideTheraptic
            let specialityCode = fetchedTherapic?.code ?? ""
            // setTherapics(therapicCode:  self.fetchedTherapic?.code ?? "")
            switch self.previewType[previewTypeIndex] {
            case .therapist:

                self.setTherapics(therapicCodes: [specialityCode])
                self.setPreviewType(.therapist)
            default:
                print("Implemented")
            }
            
            
        case .listedDoctor:
            dump(selectedObject)
            self.fetchedObject = selectedObject as? DoctorFencing
            dump(fetchedObject?.mappProducts)
            let docName = fetchedObject?.name ?? ""
            let docSpeciality = fetchedObject?.speciality ?? ""
            let valArr = [docName, docSpeciality].filter { !$0.isEmpty } .joined(separator: " - ")
            self.selectDoctorsLbl.text =  valArr
            //docName + " - \(docSpeciality)"
            let mapProd = fetchedObject?.mappProducts ?? ""
            let mProd = fetchedObject?.mProd ?? ""
            let specialityCode = fetchedObject?.specialityCode ?? ""
            
            switch self.previewType[previewTypeIndex] {
                
            case .home:
                print("Implemented")
                
            case .brand:
                self.brandsMatrixSlideModel = CoreDataManager.shared.retriveGeneralGroupedSlides()
                
                var mapProdCodeArr : [String] = []
                if mapProd != "" {
                    do {
                        let regex = try NSRegularExpression(pattern: "\\b\\d+\\b", options: .caseInsensitive)
                        let matches = regex.matches(in: mapProd, options: [], range: NSRange(location: 0, length: mapProd.utf16.count))
                        
                        
                        for i in stride(from: 0, to: matches.count, by: 2) {
                            let match = matches[i]
                            let number = (mapProd as NSString).substring(with: match.range)
                            mapProdCodeArr.append(number)
                        }
                        
                        print(mapProdCodeArr)
                    } catch {
                        print("Error creating regular expression: \(error.localizedDescription)")
                    }
                }
                
                
                // Split the includedIDs string into an array of individual IDs
                let includedmProdsIDArray = mProd.components(separatedBy: ",").compactMap { ($0) }
                
                // Filter out groupedSlide with slideId in includedIDsArray
                self.brandsMatrixSlideModel?.forEach { brandModel in
                    brandModel.groupedSlide = brandModel.groupedSlide.filter { slide in
                        let cleanedProductDetailCode = slide.productDetailCode.trimmingCharacters(in: CharacterSet(charactersIn: ","))
                        if slide.productDetailCode == "" {
                            return false
                        } else {
                            return mapProdCodeArr.contains("\(slide.code)") || includedmProdsIDArray.contains(cleanedProductDetailCode)
                        }
                        
                        
                    }
                }
                
                self.brandsMatrixSlideModel = brandsMatrixSlideModel?.filter({ aGroupedBrandsSlideModel in
                    return !aGroupedBrandsSlideModel.groupedSlide.isEmpty
                })
                
                self.setPreviewType(.brand)
            case .speciality:
                
                self.specialitySlideModel = CoreDataManager.shared.retriveGeneralGroupedSlides()
                
                self.specialitySlideModel?.forEach { brandModel in
                    
                    brandModel.groupedSlide = brandModel.groupedSlide.filter {
                        
                        let specialityCodes = $0.specialityCode
                        
                        let specialityCodesArray = specialityCodes.components(separatedBy: ",").compactMap { String($0) }
                        
                        return specialityCodesArray.contains(specialityCode)}
                }
                dump(specialitySlideModel)
                self.specialitySlideModel = specialitySlideModel?.filter({ aGroupedBrandsSlideModel in
                    return !aGroupedBrandsSlideModel.groupedSlide.isEmpty
                })
                
                self.setPreviewType(.speciality)
            case .customPresentation:
                print("Implemented")
            case .therapist:
                print("Implemented therapist")
            }
            
            
        default:
            print("Yet to implement")
        }
       
    }
    
    func setDoctorSpeciality(specialityCode: String) {

        let specialityCode = fetchedObject?.specialityCode ?? ""
                self.specialitySlideModel = CoreDataManager.shared.retriveGeneralGroupedSlides()
                
                self.specialitySlideModel?.forEach { brandModel in
                    
                        brandModel.groupedSlide = brandModel.groupedSlide.filter {
                            
                        let specialityCodes = $0.specialityCode
                        
                        let specialityCodesArray = specialityCodes.components(separatedBy: ",").compactMap { String($0) }
                        
                        return specialityCodesArray.contains(specialityCode)}
                }
        dump(self.specialitySlideModel)
        self.specialitySlideModel = specialitySlideModel?.filter({ aGroupedBrandsSlideModel in
            return !aGroupedBrandsSlideModel.groupedSlide.isEmpty
        })
    }
    
    
    func setTherapics(therapicCodes: [String]) {
        // Retrieve the slides from Core Data Manager
        self.therapistSlideModel = CoreDataManager.shared.retriveGeneralGroupedSlides()
        
        // Filter the slides based on the array of therapic codes
        self.therapistSlideModel?.forEach { brandModel in
            brandModel.groupedSlide = brandModel.groupedSlide.filter { slide in
                let specialityCodes = slide.categoryCode
                let specialityCodesArray = specialityCodes.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                
                // Check if any of the therapic codes are present in the speciality codes
                return therapicCodes.contains { therapicCode in
                    specialityCodesArray.contains(therapicCode)
                }
            }
        }
        
        // Filter out any brand models that have empty grouped slides
        self.therapistSlideModel = self.therapistSlideModel?.filter { brandModel in
            !brandModel.groupedSlide.isEmpty
        }
        
        // Print the filtered therapist slide model for debugging
        dump(self.therapistSlideModel)
    }
    
    func mapBrandMatrix(selectedObject: NSObject) {
        dump(selectedObject)
        self.fetchedObject = selectedObject as? DoctorFencing
        dump(fetchedObject?.mappProducts)
        let docName = fetchedObject?.name ?? ""
        let docSpeciality = fetchedObject?.speciality ?? ""
        //self.selectDoctorsLbl.text = docName + docSpeciality
        self.selectDoctorsLbl.text = docName + " - \(docSpeciality)"
        let mapProd = fetchedObject?.mappProducts ?? ""
        let mProd = fetchedObject?.mProd ?? ""
        _ = fetchedObject?.specialityCode ?? ""
        self.brandsMatrixSlideModel = CoreDataManager.shared.retriveGeneralGroupedSlides()
        
        var mapProdCodeArr : [String] = []
        if mapProd != "" {
            do {
                let regex = try NSRegularExpression(pattern: "\\b\\d+\\b", options: .caseInsensitive)
                let matches = regex.matches(in: mapProd, options: [], range: NSRange(location: 0, length: mapProd.utf16.count))

        
                for i in stride(from: 0, to: matches.count, by: 2) {
                    let match = matches[i]
                    let number = (mapProd as NSString).substring(with: match.range)
                    mapProdCodeArr.append(number)
                }

                print(mapProdCodeArr)
            } catch {
                print("Error creating regular expression: \(error.localizedDescription)")
            }
        }
        
        
        // Split the includedIDs string into an array of individual IDs
        let includedmProdsIDArray = mProd.components(separatedBy: ",").compactMap { ($0) }

        // Filter out groupedSlide with slideId in includedIDsArray
        self.brandsMatrixSlideModel?.forEach { brandModel in
            brandModel.groupedSlide = brandModel.groupedSlide.filter { slide in
                let cleanedProductDetailCode = slide.productDetailCode.trimmingCharacters(in: CharacterSet(charactersIn: ","))
                if slide.productDetailCode == "" {
                    return false
                } else {
                    return mapProdCodeArr.contains("\(slide.code)") || includedmProdsIDArray.contains(cleanedProductDetailCode)
                }
              
                
            }
        }
        
        self.brandsMatrixSlideModel = brandsMatrixSlideModel?.filter({ aGroupedBrandsSlideModel in
            return !aGroupedBrandsSlideModel.groupedSlide.isEmpty
        })
    }
    
    func selectedType(_ type: MenuView.CellType, index: Int) {
        self.selectedTypesIndex = index
    }
    
    func routeToView(_ view: UIViewController) {
        print("Yet to implement")
    }
    
    func callPlanAPI() {
        print("Yet to implement")
    }
    
    
}

extension PreviewHomeView:  SelectedPreviewTypesCVCDelegate {

    
    func didPlayTapped(playerModel: [SlidesModel], pageState: PlayPresentationView.PageState) {
        let vc = PlayPresentationVC.initWithStory(model:  playerModel, pagetype: self.previewHomeVC.pageType, pagestate: pageState)
        if previewHomeVC.pageType == .detailing {
            vc.previewTypeIndex = self.previewTypeIndex
            vc.delegete = self
            vc.pageState = pageState
            self.previewHomeVC.navigationController?.pushViewController(vc, animated: false)
        } else {
            self.previewHomeVC.navigationController?.pushViewController(vc, animated: true)
        }

       
    }
    
    
}



extension PreviewHomeView:  PlayPresentationViewDelegate {
    
    
    func setupSegmentsSlides(kind: PreviewType) {
        var allSlides: [SlidesModel] = []
        switch kind {
         
        case .home:
            allSlides.removeAll()
            self.groupedBrandsSlideModel =  CoreDataManager.shared.retriveGeneralGroupedSlides()
            self.groupedBrandsSlideModel?.forEach({ aGroupedBrandsSlideModel in
                allSlides.append(contentsOf: aGroupedBrandsSlideModel.groupedSlide)
            })
            print(allSlides.count)
          
        case .brand:
            guard let docCall = self.previewHomeVC.dcrCall?.call as? DoctorFencing else {return}
            self.mapBrandMatrix(selectedObject: docCall)
            allSlides.removeAll()
            self.brandsMatrixSlideModel?.forEach({ aGroupedBrandsSlideModel in
                allSlides.append(contentsOf: aGroupedBrandsSlideModel.groupedSlide)
            })
            print(allSlides.count)
        case .speciality:
            guard let docCall = self.previewHomeVC.dcrCall?.call as? DoctorFencing else {return}
            self.setDoctorSpeciality(specialityCode: docCall.specialityCode ?? "")
            allSlides.removeAll()
            self.specialitySlideModel?.forEach({ aGroupedBrandsSlideModel in
                allSlides.append(contentsOf: aGroupedBrandsSlideModel.groupedSlide)
            })
            print(allSlides.count)
        case .customPresentation:
            retriveSavedPresentations()
            allSlides = toSetupAllPlayerModel()
            
        case .therapist:
            allSlides.removeAll()
            self.therapistSlideModel?.forEach({ aGroupedBrandsSlideModel in
                allSlides.append(contentsOf: aGroupedBrandsSlideModel.groupedSlide)
            })
            print(allSlides.count)
            
        }
        
        didPlayTapped(playerModel: allSlides, pageState: .minimized)
    }
    
    func didUserDetailedSlides() {
      //  self.previewHomeVC.navigationController?.popViewController(animated: false)
      //  self.previewHomeVC.delegate?.didUserDetailedSlide()
        
        
    }
    
    func popAndRefresh(kind: PreviewType) {
        setupSegmentsSlides(kind: kind)
    }
    
    
}

extension PreviewHomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: collectionView.height / 20)
//    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case previewTypeCollection:
            return previewType.count
            case presentationCollectionVIew:
            return 1
        default:
            return 0
        }
   
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case previewTypeCollection:
            let cell: PreviewTypeCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewTypeCVC", for: indexPath) as! PreviewTypeCVC
            
        
            cell.selectionView.isHidden =  previewTypeIndex == indexPath.row ? false : true
            cell.titleLbl.textColor =  previewTypeIndex == indexPath.row ? .appTextColor : .appLightTextColor
            cell.titleLbl.text = previewType[indexPath.row].rawValue
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.previewTypeIndex  = indexPath.row
              
                welf.previewTypeCollection.reloadData()
               
                
                switch welf.previewType[welf.previewTypeIndex] {
                    
                case .home:
                    welf.setPreviewType(welf.previewType[welf.previewTypeIndex])
                case .brand , .speciality:
                    if welf.fetchedObject != nil {
                        welf.selectedType(.listedDoctor, selectedObject: welf.fetchedObject ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                    } else {
                        welf.setPreviewType(welf.previewType[welf.previewTypeIndex])
                    }
        
                case .customPresentation:
                    welf.setPreviewType(welf.previewType[welf.previewTypeIndex])
                case .therapist:
                 
                    welf.setPreviewType(welf.previewType[welf.previewTypeIndex])
                }
                
              //  welf.presentationCollectionVIew.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
   
                }
               
            return cell
        case presentationCollectionVIew:
            let cell: SelectedPreviewTypesCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPreviewTypesCVC", for: indexPath) as! SelectedPreviewTypesCVC
            cell.delegate = self
            switch self.previewType[previewTypeIndex] {
        
            case .home:
                cell.toPopulateCell(groupedBrandsSlideModel ?? [GroupedBrandsSlideModel](), type: .home, state: self.sortState)
            case .brand:
                cell.toPopulateCell(brandsMatrixSlideModel ?? [GroupedBrandsSlideModel](), type: .brand,  state: self.sortState)
            case .speciality:
                cell.toPopulateCell(specialitySlideModel ?? [GroupedBrandsSlideModel](), type: .speciality,  state: self.sortState)
            case .customPresentation:
                cell.toPopulateCell(model: savePresentationArr ?? [SavedPresentation](), type: .customPresentation,  state: self.sortState)
            case .therapist:

                cell.toPopulateCell(therapistSlideModel ?? [GroupedBrandsSlideModel](), type: .therapist,  state: self.sortState)
            }

            return cell
        default:
            return UICollectionViewCell()
        }

    }
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Calculate the index based on the current content offset and item size
//
//        if let collect = scrollView as? UICollectionView {
//            if collect == self.presentationCollectionVIew {
//                let pageWidth = collect.frame.size.width
//                let currentPage = Int(collect.contentOffset.x / pageWidth)
//                print("Current Page: \(currentPage)")
//                self.previewTypeIndex = Int(currentPage)
//                self.setPreviewType(previewType[currentPage])
//                self.previewTypeCollection.reloadData()
//                let indexPath: IndexPath = IndexPath(item: Int(currentPage), section: 0)
//                self.previewTypeCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//             //   self.presentationCollectionVIew.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//            }
//        }
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case previewTypeCollection:
            return CGSize(width: previewType[indexPath.item].rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
          //  return CGSize(width: collectionView.width / 9, height: collectionView.height)
        case presentationCollectionVIew:
            return CGSize(width: collectionView.width , height: collectionView.height)

        default:
            return CGSize()
        }
    }
    
    
}

class PreviewHomeView : BaseView {
    
    enum pageType {
        case preview
        case detailing
    }
    
    enum PreviewType: String {
        case home = "All Brands"
        case brand = "Brand Matrix"
        case speciality = "Speciality"
        case customPresentation = "My Presentation"
        case therapist = "Therapist"
    }
    
    enum PageType {
        case exists
        case empty
    }
    
    func setPreviewType(_ previewType: PreviewType) {
        self.selectedPreviewType = previewType
        switch previewType {
           
        case .home:
            selectSpecialityView.isHidden = true
            infoView.isHidden = true
            doctorSelectorVIewHeight.constant = 0
            self.groupedBrandsSlideModel =  CoreDataManager.shared.retriveGeneralGroupedSlides()
            if groupedBrandsSlideModel?.count == 0 {
                self.toSetPageType(pageType: .empty)
            } else {
                self.toSetPageType(pageType: .exists)
            }
        case .brand:
            selectSpecialityView.isHidden = true
            if self.previewHomeVC.pageType == .detailing {
                if let docCall = previewHomeVC.dcrCall?.call as? DoctorFencing {
                    self.fetchedObject = docCall
                    guard let fetchedObject = self.fetchedObject else {return}
                    mapBrandMatrix(selectedObject: fetchedObject)
                   
                }
                infoView.isHidden = false
                doctorSelectionVIew.isHidden = true
            } else {
                infoView.isHidden = true
                doctorSelectionVIew.isHidden = false
            }
            
            if self.fetchedObject == nil {
                self.selectNotifyLbl.text = "Select listed doctors to view content"
            } else {
                self.selectNotifyLbl.text = "No brands preview found for selected doctor"
            }
          
            doctorSelectorVIewHeight.constant = 50
           // groupedBrandsSlideModel  = brandsMatrixSlideModel
//            if brandsMatrixSlideModel != nil {
//                brandsMatrixSlideModel =  brandsMatrixSlideModel?.filter{
//                    !$0.groupedSlide.isEmpty
//                }
//               if brandsMatrixSlideModel?.count == 0 {
//                   self.toSetPageType(pageType: .empty)
//               } else {
//                   self.toSetPageType(pageType: .exists)
//               }
//            
//            } else {
//                self.toSetPageType(pageType: .empty)
//            }
            
            guard let brandsMatrixSlideModel = self.brandsMatrixSlideModel else {
                self.toSetPageType(pageType: .empty)
                return
            }
            if brandsMatrixSlideModel.isEmpty {
                self.toSetPageType(pageType: .empty)
            } else {
                self.toSetPageType(pageType: .exists)
            }
          
          
        case .speciality:
            selectSpecialityView.isHidden = false
            if self.previewHomeVC.pageType == .detailing {
                if let docCall = previewHomeVC.dcrCall?.call as? DoctorFencing {
                    self.fetchedObject = docCall
                    guard let fetchedObject = self.fetchedObject else {return}
                    if let fetchedSpecialityObject = self.fetchedSpecialityObject {
                        selectedSpecialityLbl.text = fetchedSpecialityObject.name ?? "-"
                    } else {
                        selectedSpecialityLbl.text = fetchedObject.speciality ?? "-"
                    }
            
                    setDoctorSpeciality(specialityCode: fetchedObject.specialityCode ?? "")
                   
                }
                infoView.isHidden = false
                doctorSelectionVIew.isHidden = true
            } else {
                infoView.isHidden = true
                doctorSelectionVIew.isHidden = false
            }
            
            if self.fetchedObject == nil {
                self.selectNotifyLbl.text = "Select listed doctors to view content"
            } else {
                self.selectNotifyLbl.text = "No brands preview found for selected doctor"
            }
            doctorSelectorVIewHeight.constant = 50
            
//            if specialitySlideModel != nil {
//                   self.toSetPageType(pageType: .exists)
//            } else {
//                self.toSetPageType(pageType: .empty)
//            }
            
            guard let specialitySlideModel = self.specialitySlideModel else {
                self.toSetPageType(pageType: .empty)
                return
            }
            if specialitySlideModel.isEmpty {
                self.toSetPageType(pageType: .empty)
            } else {
                self.toSetPageType(pageType: .exists)
            }
            
          
        case .customPresentation:
            selectSpecialityView.isHidden = true
            infoView.isHidden = true
            self.selectNotifyLbl.text = "No saved presentation found!"
            doctorSelectorVIewHeight.constant = 0
            retriveSavedPresentations()
          
        case .therapist:
            infoView.isHidden = false
            selectSpecialityView.isHidden = false
            infoLbl.isHidden = false
            infoSperator.isHidden = false
          
            doctorSelectionVIew.isHidden = false
            if let therapic = self.fetchedTherapic {
                selectedSpecialityLbl.text = therapic.name
                
            } else {
                selectedSpecialityLbl.text = "All"
               let cacheTerapics = DBManager.shared.getSlideTheraptic()
                
                let terapicCodes = cacheTerapics.compactMap { aSlideTheraptic in
                    return aSlideTheraptic.code
                }
                setTherapics(therapicCodes: terapicCodes)
             //   self.setPreviewType(.therapist)
                
            }

            doctorSelectorVIewHeight.constant = 50
            guard let therapistSlideModel = self.therapistSlideModel else {
                self.selectNotifyLbl.text = "No brands preview found for selected therapic"
                self.toSetPageType(pageType: .empty)
                return
            }
            if therapistSlideModel.isEmpty {
                self.selectNotifyLbl.text = "No brands preview found for selected therapic"
                self.toSetPageType(pageType: .empty)
            } else {
                self.toSetPageType(pageType: .exists)
            }

            
        }
    }
    
    @IBOutlet var presentationHolderVIew: UIView!
    @IBOutlet var navigationVIew: UIView!
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var selectedSpecialityLbl: UILabel!
    @IBOutlet var selectSpecialityView: UIView!
    
    @IBOutlet var infoLbl: UILabel!
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var infoSperator: UIView!
    @IBOutlet var doctorSelectionVIew: UIView!
    @IBOutlet var previewTypeCollection: UICollectionView!
    
    @IBOutlet var presentationCollectionVIew: UICollectionView!
    var previewTypeIndex: Int = 0
    var previewType: [PreviewType] = []
    @IBOutlet var selectDoctorsLbl: UILabel!
    @IBOutlet var selectNotifyLbl: UILabel!
    @IBOutlet var noPresentationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var z2aView: UIView!
    @IBOutlet var a2zView: UIView!
    @IBOutlet var sortSwitchStack: UIStackView!
    @IBOutlet var seperatorView: UIView!
  
    @IBOutlet var doctorSelectorVIewHeight: NSLayoutConstraint!
    @IBOutlet var decendingIV: UIImageView!
    @IBOutlet var ascendingIV: UIImageView!
    
    @IBOutlet var doctorsLbl: UILabel!
    @IBOutlet var viewFinishDetailing: UIView!
    var fetchedObject:  DoctorFencing?
    var fetchedSpecialityObject: Speciality?
    var fetchedTherapic: SlideTheraptic?
    enum SortState {
        case ascending
        case decending
        case none
    }
    var selectedTypesIndex: Int? = nil
    var selectedPreviewType : PreviewType = .home
    var  listedDocArr : [DoctorFencing]?
    var savePresentationArr : [SavedPresentation]?
    var selectedSlides: [SlidesModel]?
    var groupedBrandsSlideModel : [GroupedBrandsSlideModel]?
    var brandsMatrixSlideModel : [GroupedBrandsSlideModel]?
    var specialitySlideModel : [GroupedBrandsSlideModel]?
    var therapistSlideModel : [GroupedBrandsSlideModel]?
    var sortState: SortState = .none
    var pageType: pageType = .preview
    func setBrandsData() {
        self.listedDocArr = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
    }
    
    func toSetPageType(pageType: PageType) {
        switch pageType {

        case .exists:
        
            self.noPresentationView.isHidden = true
            presentationCollectionVIew.isHidden = false
            toLoadPreviewLoadedCollection()

        case .empty:

           toLoadPreviewLoadedCollection()
           self.noPresentationView.isHidden = false
            presentationCollectionVIew.isHidden = true
        }
    }
    
    var previewHomeVC : PreviewHomeVC!
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.previewHomeVC = baseVC as? PreviewHomeVC
        setupUI()
        initView()
        setPreviewType(.home)
        initgestures()
    }
    
    func initgestures() {
        presentationHolderVIew.addAction(for: .swipe_left)  { [weak self] in
            guard let welf = self else {return}
            let index = welf.previewType.firstIndex { $0.rawValue == welf.selectedPreviewType.rawValue }
            let count = welf.previewType.count
            guard let index = index, index < count - 1 else {
                return
            }
            welf.previewTypeIndex = index + 1
            welf.setPreviewType(welf.previewType[index + 1])
            welf.previewTypeCollection.reloadData()
        }
        
        presentationHolderVIew.addAction(for: .swipe_right)  { [weak self] in
            guard let welf = self else {return}
            let index = welf.previewType.firstIndex { $0.rawValue == welf.selectedPreviewType.rawValue }
         //   let count = welf.previewType.count
            guard let index = index,  index - 1 >= 0 else {
                return
            }
            welf.previewTypeIndex = index - 1
            welf.setPreviewType(welf.previewType[index - 1])
            welf.previewTypeCollection.reloadData()
        }
    }
    
    func retriveSavedPresentations()  {
      //  Shared.instance.showLoaderInWindow()
        CoreDataManager.shared.retriveSavedPresentations { savedPresentationArr in
            self.savePresentationArr = savedPresentationArr
           // Shared.instance.removeLoaderInWindow()
        }
        
        if let savePresentationArr =   self.savePresentationArr {
            dump(savePresentationArr)
            if savePresentationArr.count == 0 {
                toSetPageType(pageType: .empty)
            } else {
                toSetPageType(pageType: .exists)
                //self.setPreviewType(previewType[previewTypeIndex])
            }
        }
        
       
 
    }
    
    func toSetupPlayerModel(_ index: Int) -> [SlidesModel] {
        var selectedSlidesModelArr = [SlidesModel]()
        if let savePresentationArr = self.savePresentationArr {
            let selectedPresentation = savePresentationArr[index]
            selectedPresentation.groupedBrandsSlideModel.forEach({ aGroupedBrandsSlideModel in
                let selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                    aSlidesModel.isSelected == true
                }
              
                selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
            })
         
        }
      
        selectedSlidesModelArr.sort{$0.index < $1.index}
        return selectedSlidesModelArr
        
    }
    
    func toSetupAllPlayerModel() -> [SlidesModel] {
        var selectedSlidesModelArr = [SlidesModel]()
        if let savePresentationArr = self.savePresentationArr {
            savePresentationArr.forEach { selectedPresentation in
                selectedPresentation.groupedBrandsSlideModel.forEach({ aGroupedBrandsSlideModel in
                    let selectedSlidesModelElement = aGroupedBrandsSlideModel.groupedSlide.filter { aSlidesModel in
                        aSlidesModel.isSelected == true
                    }
                  
                    selectedSlidesModelArr.append(contentsOf: selectedSlidesModelElement)
                })
            }
        }
      
        selectedSlidesModelArr.sort{$0.index < $1.index}
        return selectedSlidesModelArr
        
    }
    
    
 
    
    func toLoadPreviewCollection() {
        previewTypeCollection.delegate = self
        previewTypeCollection.dataSource = self
        previewTypeCollection.reloadData()
    }
    
    
    func toLoadPreviewLoadedCollection() {
        presentationCollectionVIew.delegate = self
        presentationCollectionVIew.dataSource = self
        presentationCollectionVIew.reloadData()
    }
    
    func toUnloadPreviewLoadedCollection() {
        presentationCollectionVIew.delegate = nil
        presentationCollectionVIew.dataSource = nil
    }
    
    func cellRegistration() {
        if let layout = self.presentationCollectionVIew.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.collectionView?.isScrollEnabled = true
            layout.scrollDirection = .vertical
        }

        
        presentationCollectionVIew.register(EmptyReusableVIew.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyReusableVIew")
        
        presentationCollectionVIew.register(EmptyReusableVIew.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "EmptyReusableVIew")
        
        presentationCollectionVIew.register(UINib(nibName: "SelectedPreviewTypesCVC", bundle: nil), forCellWithReuseIdentifier: "SelectedPreviewTypesCVC")
        
        previewTypeCollection.register(UINib(nibName: "PreviewTypeCVC", bundle: nil), forCellWithReuseIdentifier: "PreviewTypeCVC")
    }
    
    func setSortVIew() {
        switch self.sortState {
            
        case .ascending:
            a2zView.backgroundColor =  .appTextColor
            z2aView.backgroundColor =  .appWhiteColor
            ascendingIV.tintColor = .appWhiteColor
            decendingIV.tintColor = .appTextColor

        case .decending:
            a2zView.backgroundColor =  .appWhiteColor
            z2aView.backgroundColor =  .appTextColor
            ascendingIV.tintColor = .appTextColor
            decendingIV.tintColor = .appWhiteColor
        case .none:
            a2zView.backgroundColor =  .appWhiteColor
            z2aView.backgroundColor =  .appWhiteColor
            ascendingIV.tintColor = .appTextColor
            decendingIV.tintColor = .appTextColor
        }
    
        
        setPreviewType(self.previewType[previewTypeIndex])
    }
    
    func initView() {
        
        self.infoView.addTap {
            [weak self] in
                guard let welf = self else {return}

            let menuvc = SpecifiedMenuVC.initWithStory(welf, celltype: welf.previewType[welf.previewTypeIndex] == .speciality ? .speciality : .theraptic)
                menuvc.selectedObject = welf.fetchedSpecialityObject
                menuvc.previewType = welf.previewType[welf.previewTypeIndex]
                welf.previewHomeVC.modalPresentationStyle = .custom
                welf.previewHomeVC.navigationController?.present(menuvc, animated: false)
        }
        
        self.doctorSelectionVIew.addTap { [weak self] in
            guard let welf = self else {return}

            let menuvc = SpecifiedMenuVC.initWithStory(welf, celltype: .listedDoctor)
            menuvc.selectedObject = welf.fetchedObject
            menuvc.previewType = welf.previewType[welf.previewTypeIndex]
            welf.previewHomeVC.modalPresentationStyle = .custom
            welf.previewHomeVC.navigationController?.present(menuvc, animated: false)
        }
        
        backHolderView.addTap {
            Shared.instance.detailedSlides = []
            self.previewHomeVC.navigationController?.popViewController(animated: true)
        }
        
        a2zView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.sortState = .ascending
            welf.setSortVIew()
        }
        
        z2aView.addTap {
            [weak self] in
                guard let welf = self else {return}
            welf.sortState = .decending
                welf.setSortVIew()
        }
        
        viewFinishDetailing.addTap {
            self.previewHomeVC.navigationController?.popViewController(animated: false)
            self.previewHomeVC.delegate?.didUserDetailedSlide()
        }
  
    }
    
    func setupUI() {
        
        selectSpecialityView.layer.cornerRadius = 5
        selectSpecialityView.layer.borderWidth = 1
        selectSpecialityView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        presentationCollectionVIew.backgroundColor = .clear
        presentationCollectionVIew.isPagingEnabled = false
        sortSwitchStack.layer.cornerRadius = 3
        sortSwitchStack.layer.borderWidth = 1
        sortSwitchStack.layer.borderColor = UIColor.appTextColor.cgColor
        infoLbl.setFont(font: .bold(size: .BODY))
        infoLbl.textColor = .appLightTextColor
        titleLbl.setFont(font: .bold(size: .SUBHEADER))
        titleLbl.textColor = .appWhiteColor
        seperatorView.backgroundColor = .appLightTextColor.withAlphaComponent(0.5)
        presentationHolderVIew.layer.cornerRadius = 5
        self.backgroundColor = .appGreyColor
        presentationHolderVIew.backgroundColor = .appWhiteColor
        selectNotifyLbl.setFont(font: .bold(size:  .BODY))
        selectNotifyLbl.textColor = .appTextColor
        doctorSelectionVIew.layer.borderWidth = 1
        doctorSelectionVIew.layer.cornerRadius = 5
        viewFinishDetailing.layer.cornerRadius = 5
        doctorSelectionVIew.layer.borderColor = UIColor.appTextColor.cgColor
        selectDoctorsLbl.setFont(font: .medium(size: .BODY))
        selectDoctorsLbl.textColor = .appTextColor
        toSetPageType(pageType: .exists)
        previewType = [.home, .brand, .speciality, .customPresentation]
         let setups = AppDefaults.shared.getAppSetUp()
        if setups.therapticNd == "0" {
            previewType.append(.therapist)
        }
        doctorsLbl.text = LocalStorage.shared.getString(key: .doctor)
        setSortVIew()
        cellRegistration()
        toLoadPreviewCollection()
        if  previewHomeVC.pageType == .detailing {
            titleLbl.text = previewHomeVC.dcrCall?.name
            viewFinishDetailing.isHidden = false
        } else {
            titleLbl.text = "Preview"
            viewFinishDetailing.isHidden = true
        }
        //toLoadPreviewLoadedCollection()
    }
}
