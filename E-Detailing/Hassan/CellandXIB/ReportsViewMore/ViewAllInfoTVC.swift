//
//  ViewAllInfoTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit
import Combine

extension ViewAllInfoTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
            return 7 + 1 + 1

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            return 1
        case 1:
            if self.isTohideLocationInfo {
                return 0
            } else {
                return 1
            }
        case 2:
            return  productStrArr.count
            
        case 3:
            return inputStrArr.count
            
        case 4:
            switch self.cellRCPAType {
            case .showRCPA:
                return rcpaResponseModel.count
            case .hideRCPA:
                return 0
            }
           
            
        case 5:
            switch self.cellSlidesType {
            case .showSlides:
                return slidesResponseModel.count
            case .hideSlides:
                return 0
            }
            
        case 6:
            switch self.cellEventsType {
            case .showEvents:
                return 0
            case .hideEvents:
                return 0
            }
        case 7:
            return 1
           
        case 8:
            return 1
        default:
            return 0
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.width, height: 190)
            
            
        case 1:
            return CGSize(width: collectionView.width, height: 100)
      
        case 2:
            return CGSize(width: collectionView.width, height: 40)
        case 3:
            return CGSize(width: collectionView.width, height: 40)
            
        case 4:
            return CGSize(width: collectionView.width, height: 40)
            
        case 5:
            return CGSize(width: collectionView.width, height: 40)
            
        case 6:
            return CGSize(width: collectionView.width, height: 40)

        case 7:
            return CGSize(width: collectionView.width, height: 75)
        case 8:
            return CGSize(width: collectionView.width, height: 50)
            
        default:
            return CGSize()
        }
        
        


    }

    
    func collectionView(_ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 2:
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(ProductSectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
                guard let typedHeaderView = headerView as? ProductSectionReusableView else { return headerView
                }
        
                switch Shared.instance.selectedDCRtype {
                    
                case .Doctor:
                    typedHeaderView.productLbl.text = " \(appSetup.docProductCaption ?? "Products")"
                    typedHeaderView.samplesLbl.text =    appSetup.docSampleQCap
                    typedHeaderView.rxQTYlbl.text = appSetup.docRxQCap
                    if isDoctorRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
                    }
                    
                    if isDoctorProductRXneeded {
                        typedHeaderView.isrxNeeded = true
                    }

                    if isDoctorProductSampleNeeded {
                        typedHeaderView.isSampleNeeded = true
                    }
                    
                case .Chemist :
                    typedHeaderView.productLbl.text =  " \(appSetup.chmProductCaption ?? "Products")"
                    typedHeaderView.samplesLbl.text =  appSetup.chmSampleCap ?? "Sample"
                    typedHeaderView.rxQTYlbl.text =  appSetup.chmQcap ?? "Rx Qty"
                    if isChemistRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
                    }

                    
                    if isChemistProductRXneeded {
                        typedHeaderView.isrxNeeded = true
                    }
                    
                    if isChemistProductSampleNeeded {
                        typedHeaderView.isSampleNeeded = true
                    }
          
                case .UnlistedDoctor:
                    typedHeaderView.productLbl.text =  " \(appSetup.ulProductCaption ?? "Products")"
                    typedHeaderView.samplesLbl.text =  appSetup.nlSampleQCap ?? "Sample"
                    typedHeaderView.rxQTYlbl.text = appSetup.nlRxQCap ?? "Rx Qty"
                    if isUnListedDoctorRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
                    }
          
                    if isUnListedDoctorProductRXneeded {
                        typedHeaderView.isrxNeeded = true
                    }
                    
                    if  isUnListedDoctorProductSampleNeeded {
                        typedHeaderView.isSampleNeeded = true
                    }
                case .Stockist :
                    typedHeaderView.productLbl.text =  " \(appSetup.stkProductCaption ?? "Products")"
                    typedHeaderView.samplesLbl.text =  "Sample"
                    typedHeaderView.rxQTYlbl.text = appSetup.stkQCap ?? "Rx Qty"
                    if isStockistProductRXneeded {
                        typedHeaderView.isrxNeeded = true
                    }
          
                    typedHeaderView.isRCPAneeded = false
                    
                    if  isStockistProductSampleNeeded {
                        typedHeaderView.isSampleNeeded = true
                    }
                    
                    
                default:
                    typedHeaderView.isRCPAneeded = false
                }
                typedHeaderView.layoutSubviews()
                return typedHeaderView
            default:
                print("No header")
            }
        case 3:
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(InputSectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
                guard let typedHeaderView = headerView as? InputSectionReusableView else { return headerView
                }

                return typedHeaderView
            default:
                print("No header")
            }
            
        case 4, 5, 6:
     
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(RCPASectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
             
                guard let typedHeaderView = headerView as? RCPASectionReusableView else { return headerView
                }

                typedHeaderView.sectionHolderView.layer.borderWidth = 1
                typedHeaderView.sectionHolderView.layer.borderColor = UIColor.appLightTextColor.withAlphaComponent(0.1).cgColor
       
                switch indexPath.section {
                case 4:
                    typedHeaderView.sectionImage.image =  self.cellRCPAType == .hideRCPA ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
                    typedHeaderView.sectionTitle.text =  "RCPA"
                    typedHeaderView.addTap {
                        if self.cellRCPAType == .showRCPA {
                            self.cellRCPAType =  .hideRCPA
                            self.delegate?.didRCPAtapped(isrcpaTapped: false, index: self.selectedIndex ?? 0, responsecount: 0)
                            self.extendedInfoCollection.reloadData()
                            return
                        }
                        self.makeRcpaApiCall()  {response in
                            if response.isEmpty {
                                self.toCreateToast("No RCPA found!")
                                return
                            }
                            self.cellSlidesType =  .hideSlides
                            self.cellRCPAType =  self.cellRCPAType == .showRCPA ?  .hideRCPA :  .showRCPA
                            self.delegate?.didRCPAtapped(isrcpaTapped: self.cellRCPAType == .showRCPA ? true :  false, index: self.selectedIndex ?? 0, responsecount: response.count)
                            self.extendedInfoCollection.reloadData()
                         
                        }
                    }
                case 5:
                    typedHeaderView.sectionImage.image =  self.cellSlidesType == .hideSlides ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
                    typedHeaderView.sectionTitle.text =  "Slide Details"
                    typedHeaderView.addTap {
                        if self.cellSlidesType == .showSlides {
                            self.cellSlidesType =  .hideSlides
                            self.delegate?.didSlidestapped(isSlidestapped: false, index: self.selectedIndex ?? 0, responsecount: 0)
                            self.extendedInfoCollection.reloadData()
                            return
                        }
                        
                        self.makeSlidesInfoApiCall()  { response in
                            if response.isEmpty {
                                self.toCreateToast("No slide info found!")
                                return
                            }
                            self.cellSlidesType =  .showSlides
                            self.cellRCPAType = .hideRCPA
                            self.delegate?.didSlidestapped(isSlidestapped: true, index: self.selectedIndex ?? 0, responsecount: response.count)
                            //(isrcpaTapped: true, index: self.selectedIndex ?? 0, responsecount: response.count)
                            self.extendedInfoCollection.reloadData()
                         
                        }
                    }
                    
                case 6:
                    typedHeaderView.sectionImage.image =  self.cellEventsType == .hideEvents ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
                    typedHeaderView.sectionTitle.text =  "Event capture"
                    typedHeaderView.addTap {
                        
                        self.makeEventsInfoApiCall { response in
                            if response.isEmpty {
                                self.toCreateToast("No captured events found!")
                                return
                            }
                            self.cellRCPAType =  .showRCPA
                            
                            self.delegate?.didEventstapped(isEventstapped: true, index: self.selectedIndex ?? 0, response: response)
                            self.extendedInfoCollection.reloadData()
                         
                        }
                    }
                default:
                    print("No header")
                }
            
            
                return typedHeaderView
            default:
                print("No header")
            }
            
        default:
            return UICollectionReusableView()
        }


      return UICollectionReusableView()
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Return the size of your header
 
        if  section == 4  {
            switch Shared.instance.selectedDCRtype {
            case .Doctor:
                if isDoctorRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case .Chemist:
                if isChemistRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case .UnlistedDoctor:
                if isUnListedDoctorRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            default:
                return CGSize()
            }
        }
        if  section == 5  {
            switch Shared.instance.selectedDCRtype {
            case .Doctor:
                if isDoctorDetailingNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case .Chemist:
                if isChemistDetailingNeeded{
                    return CGSize(width: collectionView.frame.width, height: 60)
                }

            case .UnlistedDoctor:
                if isUnListedDoctorDetailingNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            default:
                return CGSize()
            }
        }
        if  section == 6  {
            switch Shared.instance.selectedDCRtype{
            case .Doctor:
                if isDoctorEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case .Chemist:
                if isChemistEventCaptureNeeded{
                    return CGSize(width: collectionView.frame.width, height: 60)
                   
                }
            case .Stockist:
                if isStockistEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case .UnlistedDoctor:
                if isUnListedDoctorEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
             
                }
            default:
                return CGSize()
            }
        }
        
        if section == 2 || section == 3   {
            return CGSize(width: collectionView.frame.width, height: 60)
        } else {
            return CGSize()
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: VisitInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitInfoCVC", for: indexPath) as! VisitInfoCVC
            cell.typeIV.image = self.typeImage ?? UIImage()
            cell.toPopulateCell(model: self.detailedReportModel ?? DetailedReportsModel())
            return cell
            
        case 1:
            let cell: TimeInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeInfoCVC", for: indexPath) as! TimeInfoCVC
            cell.toPopulateCell(model: self.reportModel ?? ReportsModel())
            return cell
        case 2:
                let cell: ProductsDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsDescriptionCVC", for: indexPath) as! ProductsDescriptionCVC
                let modelStr = self.productStrArr[indexPath.row]

            switch Shared.instance.selectedDCRtype {
                
            case .Doctor:
                if isDoctorRCPAneeded{
                    cell.isRCPAneeded = true
                }
                
                if isDoctorProductRXneeded {
                    cell.isrxNeeded = true
                }
                
                if isDoctorProductSampleNeeded {
                    cell.isSampleNeeded = true
                }
                
                
                
            case .Chemist :
                if isChemistRCPAneeded {
                    cell.isRCPAneeded = true
                }
                
                if isChemistProductRXneeded {
                    cell.isrxNeeded = true
                }
                
                if isChemistProductSampleNeeded {
                    cell.isSampleNeeded = true
                }
                
                
            case .Stockist:
            
                
                if isStockistProductRXneeded {
                    cell.isrxNeeded = true
                }
                
                if isStockistProductSampleNeeded {
                    cell.isSampleNeeded = true
                }
                
                cell.isRCPAneeded  = false
     
            case .UnlistedDoctor:
                if isUnListedDoctorRCPAneeded{
                    cell.isRCPAneeded = true
                }
                
                if isUnListedDoctorProductRXneeded {
                    cell.isrxNeeded = true
                }
                
                if isUnListedDoctorProductSampleNeeded {
                    cell.isSampleNeeded = true
                }
                
            default:
                cell.isRCPAneeded = false
            }
            
                cell.topopulateCell(modelStr: modelStr)
                
                return cell
            
        case 3:
            

                let cell: InputDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "InputDescriptionCVC", for: indexPath) as! InputDescriptionCVC
                let modelStr = self.inputStrArr[indexPath.row]

                cell.topopulateCell(modelStr: modelStr)
                
                return cell
       
        case 4:
            switch self.cellRCPAType {
            case .showRCPA:
                switch indexPath.row {
                case 0:
                    let cell: RCPAdetailsInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "RCPAdetailsInfoCVC", for: indexPath) as! RCPAdetailsInfoCVC
                    return cell
                default:
                    let cell: RCPAdetailsDesctiptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "RCPAdetailsDesctiptionCVC", for: indexPath) as! RCPAdetailsDesctiptionCVC
                    let model = rcpaResponseModel[indexPath.row]
                    
                    cell.populateCell(model: model)
                    
                    cell.commentSubject.sink { index in
                        print("index tapped: \(index)")
                     //   cell.commentsSubject.send(index)
                        print(model.remarks)
//                        if model.remarks.isEmpty {
//                            self.toCreateToast("No comments found")
//                            return
//                        }
                        //model.remarks
                        self.delegate?.didRCPACommentsTapped(view: cell.commentsIV, comments: model.remarks)
                    }.store(in: &observer)
                    
                    cell.commentsIV.addTap {
                        cell.commentSubject.send(indexPath.row)
                    }
                    
                    cell.infoView.addTap {
                        self.delegate?.didRCPAinfoTapped(view: cell.infoView, model: model)
                    }
                    return cell
                }
            case .hideRCPA:
                return UICollectionViewCell()
            }

          //  SlidesDescriptionCVC
        case 5:
            switch self.cellSlidesType {
            case .showSlides:
                switch indexPath.row {
                case 0:
                    let cell: SlidesInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidesInfoCVC", for: indexPath) as! SlidesInfoCVC
                    return cell
                default:
                    let cell: SlidesDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidesDescriptionCVC", for: indexPath) as! SlidesDescriptionCVC
                    let model = self.slidesResponseModel[indexPath.row]
                    cell.setupUI(currentRating: model.rating, selectedIndex: 0)
                    cell.populateCell(model: model)
                    cell.infoView.addTap {
                        self.delegate?.didDurationInfoTapped(view: cell.infoView, startTime: model.startTime, endTime: model.endTime)
                    }
                    return cell
                }
            case .hideSlides:
                return UICollectionViewCell()
            }
        case 6:
            return UICollectionViewCell()
        case 7:
            let cell: ReportsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportsCVC", for: indexPath) as! ReportsCVC
            cell.remarksDesc.text = detailedReportModel?.remarks
            cell.remarksDesc.addTap {
                self.delegate?.didRCPACommentsTapped(view: cell.remarksDesc, comments: self.detailedReportModel?.remarks ?? "")
            }
            
            return cell
            
        case 8:
            let cell: ViewmoreCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewmoreCVC", for: indexPath) as! ViewmoreCVC
            cell.addTap {
                
                self.delegate?.didLessTapped(islessTapped: true, index: self.selectedIndex ?? 0)
            }
            return cell
            
        default:
           return UICollectionViewCell()
        }
    }
    
    
}

protocol ViewAllInfoTVCDelegate: AnyObject {
    func didRCPAtapped(isrcpaTapped: Bool, index: Int, responsecount: Int)
    func didEventstapped(isEventstapped: Bool, index: Int, response: [EventResponse])
    func didSlidestapped(isSlidestapped: Bool, index: Int, responsecount: Int)
    func didLessTapped(islessTapped: Bool, index: Int)
    func didDurationInfoTapped(view: UIView, startTime: String, endTime: String)
    func didRCPAinfoTapped(view: UIView, model: RCPAresonseModel)
    func didRCPACommentsTapped(view: UIView, comments: String)
    
}

struct SampleProduct {
    let prodName: String
    let isPromoted: Bool?
    let noOfSamples : String
    let rxQTY: String
    let rcpa: String
    let isDemoProductCell: Bool
    let remarks: String?
}

struct SampleInput {
    let prodName: String
    let noOfSamples : String
}

enum CellRCPAType {
    case showRCPA
    case hideRCPA

}

enum cellEventsType {
    case showEvents
    case hideEvents
}

enum CellSlidesType {
    
         case showSlides
         case hideSlides
}

class ViewAllInfoTVC: UITableViewCell {

    let appSetup = AppDefaults.shared.getAppSetUp()
    @IBOutlet var extendedInfoCollection: UICollectionView!
    weak var delegate: ViewAllInfoTVCDelegate?
    var rcpaTapped: Bool = false
    //var selectedType: CellType = .All
    var cellRCPAType: CellRCPAType = .hideRCPA
    var cellEventsType: cellEventsType = .hideEvents
    var cellSlidesType: CellSlidesType = .hideSlides
    var reportModel: ReportsModel?
    var reportsVM: ReportsVM?
    var detailedReportModel: DetailedReportsModel?
    var slidesResponseModel : [SlideDetailsResponse] = []
    var rcpaResponseModel : [RCPAresonseModel] = []
    var eventsResponseModel : [EventResponse] = []
    var ResponseModel : [EventResponse] = []
    var productStrArr : [SampleProduct] = []
    var inputStrArr: [SampleInput] = []
    var typeImage: UIImage?
    var isTohideLocationInfo = false
    var selectedIndex : Int? = nil
    var observer: [AnyCancellable] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        extendedInfoCollection.elevate(4)
        extendedInfoCollection.layer.cornerRadius = 5
        extendedInfoCollection.isScrollEnabled = false
        cellRegistration()
        // toLoadData()
    }
    
    func hideLocationSection() {
        if reportModel?.intime == "" &&  reportModel?.outtime == "" &&  reportModel?.inaddress == "" && reportModel?.outaddress == "" {
            isTohideLocationInfo = true
        }
    }
    
    func toSetDataSourceForInputs()   {
        inputStrArr.removeAll()
        //detailedReportModel?.gifts
        if detailedReportModel?.gifts != "" {
            var inputArr = [String]()
            
            inputArr = detailedReportModel?.gifts.components(separatedBy: ",") ?? [String]()
            inputArr.removeLast()
            if inputArr.count == 0 {
                inputArr.append(detailedReportModel?.gifts ?? String())
            }
          
            
            let filteredComponents = inputArr.map { anElement -> String in
                var modifiedElement = anElement
                if modifiedElement.first == " " {
                    modifiedElement.removeFirst()
                }
                return modifiedElement
            }
            filteredComponents.forEach { prod in
                var prodString : [String] = []
                prodString.append(contentsOf: prod.components(separatedBy: "("))
                prodString = prodString.map({ aprod in
                    aprod.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                })
                var name: String = ""
            
                var noOfsamples: String = ""

                prodString.enumerated().forEach {prodindex, prod in
              
                   // let sampleProduct: SampleProduct
                    switch prodindex {
                    case 0 :
                        name = prod
                    case 1:
                        noOfsamples = prod
                    default:
                        print("default")
                    }
                }
                
         
                
                
                let aInput = SampleInput(prodName: name, noOfSamples: noOfsamples)

                self.inputStrArr.append(aInput)
            }

        } else {
            inputStrArr.append(SampleInput(prodName: "No inputs", noOfSamples: ""))
        }
            
            
    }
    
    func toSetDataSourceForProducts() {
        productStrArr.removeAll()
     //   productStrArr.append(SampleProduct(prodName: "", isPromoted: false, noOfSamples: "", rxQTY: "", rcpa: "", isDemoProductCell: true))
        
       if detailedReportModel?.products != "" {
           var prodArr =  detailedReportModel?.products.components(separatedBy: ",")
     
               prodArr?.removeLast()
      
           
           let filteredComponents = prodArr?.map { anElement -> String in
               var modifiedElement = anElement
               if modifiedElement.first == " " {
                   modifiedElement.removeFirst()
               }
               return modifiedElement
           }
           
           filteredComponents?.forEach { prod in
               var prodString : [String] = []
               prodString.append(contentsOf: prod.components(separatedBy: "("))
               prodString = prodString.map({ aprod in
                   aprod.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
               })
               var name: String = ""
               var isPromoted: Bool = false
               var noOfsamples: String = ""
               var rxQty: String = ""
               var rcpa: String  = ""
               prodString.enumerated().forEach {prodindex, prod in
             
                  // let sampleProduct: SampleProduct
                   switch prodindex {
                   case 0 :
                       name = prod
                   case 1:
                       noOfsamples = prod
                   case 2:
                       rxQty = prod
                   case 3:
                       if let index = prod.firstIndex(of: "^") {
                           let startIndex = prod.index(after: index)
                           let numberString = String(prod[startIndex...])
                           rcpa = numberString
                           print(numberString) // This will print "5"
                       } else {
                           print("'^' not found in the expression.")
                           rcpa = "-"
                       }
                      
   
                   default:
                       print("default")
                   }
               }
               
        
               let promotdProduct = self.detailedReportModel?.promotedProducts
               guard let promotdProduct = promotdProduct, promotdProduct != "" else {
                   let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false, remarks: detailedReportModel?.remarks ?? "-")
                   
                   productStrArr.append(aProduct)
                   
                   return}
      
               // Split the promotedProduct string by the "$" delimiter
               let components = promotdProduct.components(separatedBy: "$")

               // Process each component to remove "#" character
               let namesWithoutHash = components.map { $0.replacingOccurrences(of: "#", with: "") }

               // Extract words after the "$" sign and flatten the resulting array
               let words = namesWithoutHash.flatMap { $0.components(separatedBy: " ") }

   
              //  Check if any of the extracted words matches the name
               if namesWithoutHash[1] == name.trimmingCharacters(in: .whitespaces) {
                   print("The 'promotedProduct' contains '\(name)'")
                   _ = DBManager.shared.getProduct().filter { $0.code ==  words[0]}.first
                   isPromoted = true
               } else {
                   print("The 'promotedProduct' does not contain '\(name)'")
                   isPromoted = false
               }
               
               
               let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false, remarks: detailedReportModel?.remarks ?? "-")
               
               productStrArr.append(aProduct)
           }
       } else {
           productStrArr.append(SampleProduct(prodName: "-", isPromoted: nil, noOfSamples: "-", rxQTY: "-", rcpa: "-", isDemoProductCell: true, remarks: "-"))
       }

        dump(productStrArr)
         
    }
    
    func toLoadData() {
        extendedInfoCollection.delegate = self
        extendedInfoCollection.dataSource = self
        extendedInfoCollection.reloadData()
    }
    
    func cellRegistration() {
        
        extendedInfoCollection.register(UINib(nibName: "VisitInfoCVC", bundle: nil), forCellWithReuseIdentifier: "VisitInfoCVC")
        extendedInfoCollection.register(UINib(nibName: "TimeInfoCVC", bundle: nil), forCellWithReuseIdentifier: "TimeInfoCVC")
//        extendedInfoCollection.register(UINib(nibName: "ProductSectionTitleCVC", bundle: nil), forCellWithReuseIdentifier: "ProductSectionTitleCVC")
        extendedInfoCollection.register(UINib(nibName: "rcpaCVC", bundle: nil), forCellWithReuseIdentifier: "rcpaCVC")
        extendedInfoCollection.register(UINib(nibName: "ReportsCVC", bundle: nil), forCellWithReuseIdentifier: "ReportsCVC")
        extendedInfoCollection.register(UINib(nibName: "ViewmoreCVC", bundle: nil), forCellWithReuseIdentifier: "ViewmoreCVC")
        
        extendedInfoCollection.register(UINib(nibName: "ProductsDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "ProductsDescriptionCVC")
        
        extendedInfoCollection.register(UINib(nibName: "InputDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "InputDescriptionCVC")
        
        
        extendedInfoCollection.register(UINib(nibName: "RCPAsectionHeader", bundle: nil), forCellWithReuseIdentifier: "RCPAsectionHeader")
        
        
        extendedInfoCollection.register(UINib(nibName: "RCPAdetailsDesctiptionCVC", bundle: nil), forCellWithReuseIdentifier: "RCPAdetailsDesctiptionCVC")
        
        extendedInfoCollection.register(UINib(nibName: "RCPAdetailsInfoCVC", bundle: nil), forCellWithReuseIdentifier: "RCPAdetailsInfoCVC")
        
        extendedInfoCollection.register(UINib(nibName: "SlidesDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "SlidesDescriptionCVC")
        extendedInfoCollection.register(UINib(nibName: "SlidesInfoCVC", bundle: nil), forCellWithReuseIdentifier: "SlidesInfoCVC")
        
        
        extendedInfoCollection.register(RCPASectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RCPASectionReusableView")
        
        extendedInfoCollection.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        
        extendedInfoCollection.register(ProductSectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductSectionReusableView")
        
        extendedInfoCollection.register(InputSectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InputSectionReusableView")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeRcpaApiCall(completion: @escaping ([RCPAresonseModel]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
        
        var param: [String: Any] = [:]
        param["tableName"] = "getdcr_rcpa"
        param["dcrdetail_cd"] = detailedReportModel?.transDetailSlno
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = reportModel?.sfCode ?? ""
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getDetailedRCPAdetais(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.rcpaResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                let aRCPAresonseModel = RCPAresonseModel()
                self.rcpaResponseModel.append(aRCPAresonseModel)
                self.rcpaResponseModel.append(contentsOf: response)
                completion(self.rcpaResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }

    
    func makeSlidesInfoApiCall(completion: @escaping ([SlideDetailsResponse]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
        // {"tableName":"getslidedet","ACd":"KS134-306","Mslcd":"KS134-73","sfcode":"MR7224","division_code":"47","Rsf":"MR7224","sf_type":"1","Designation":"0","state_code":"15","subdivision_code":"84,"}
        var param: [String: Any] = [:]
        param["tableName"] = "getslidedet"
        param["Mslcd"] = detailedReportModel?.code
        param["ACd"] = reportModel?.aCode
        
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] =  reportModel?.sfCode ?? ""
        //LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getSlideDetails(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.slidesResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                let aRCPAresonseModel = SlideDetailsResponse()
                self.slidesResponseModel.append(aRCPAresonseModel)
                self.slidesResponseModel.append(contentsOf: response)
                completion(self.slidesResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    func makeEventsInfoApiCall(completion: @escaping ([EventResponse]) -> ()) {

        let appsetup = AppDefaults.shared.getAppSetUp()
        
      //  {"tableName":"getevent_rpt","dcr_cd":"DP3-819","dcrdetail_cd":"DP3-1288","sfcode":"MGR0941","division_code":"63,","Rsf":"MGR0941","sf_type":"2","Designation":"MGR","state_code":"13","subdivision_code":"86,"}
        var param: [String: Any] = [:]
        param["tableName"] = "getevent_rpt"
        param["dcr_cd"] = reportModel?.aCode
        //detailedReportModel?.a
        param["dcrdetail_cd"] = detailedReportModel?.transDetailSlno
        
        param["sfcode"] = appsetup.sfCode
        param["division_code"] = appsetup.divisionCode
        param["Rsf"] = reportModel?.sfCode ?? ""
        param["sf_type"] = appsetup.sfType
        param["Designation"] = appsetup.desig
        param["state_code"] = appsetup.stateCode
        param["subdivision_code"] = appsetup.subDivisionCode
        let paramData = ObjectFormatter.shared.convertJson2Data(json: param)
        let toSendData: [String: Any] = ["data" :  paramData]
        Shared.instance.showLoaderInWindow()
        reportsVM?.getDetailedEventsdetais(params: toSendData, api: .getReports, paramData: param) { result in
            Shared.instance.removeLoaderInWindow()
            switch result {
            case .success(let response):
                dump(response)
                self.eventsResponseModel.removeAll()
                if response.isEmpty {
                    completion(response)
                    return
                }
                self.eventsResponseModel.append(contentsOf: response)
                completion(self.eventsResponseModel)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                self.toCreateToast("Error while fetching response from server.")
                
            }
        }
    }
    
}
