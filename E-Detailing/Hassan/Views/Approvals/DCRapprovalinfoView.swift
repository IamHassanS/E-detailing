//
//  DCRapprovalinfoView.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import Foundation
import UIKit
import Combine

extension DCRapprovalinfoView:  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")
            
            
            var filteredlist = [ApprovalDetailsModel]()
            filteredlist.removeAll()
            var isMatched = false
            dcrApprovalinfoVC.allApprovals?.forEach({ list in
                if list.transDetailName.lowercased().contains(newText) {
                    filteredlist.append(list)
                    isMatched = true
                    
                }
            })
            
            if newText.isEmpty {
                dcrApprovalinfoVC.filteredApprovals = dcrApprovalinfoVC.allApprovals
                self.loadApprovalTable()
            } else if isMatched {
                dcrApprovalinfoVC.filteredApprovals = filteredlist
                isSearched = true
                self.selectedBrandsIndex = nil
               // self.approvalDetails = nil
                //self.loadApprovalDetailTable()
                self.loadApprovalTable()
            } else {
                isSearched = false
                self.loadApprovalTable()
                print("Not matched")
            }
            
            return true
        }
        return true
    }
}


extension DCRapprovalinfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
            return 7 + 1

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
            return 1
        case 1:
            return slidesResponseModel.count
        case 2:
            return  productStrArr.count
            
        case 3:
            return inputStrArr.count
            
        case 4:
            return 0
           
            
        case 5:
            
            switch dcrApprovalinfoVC.approvalDetail?.type {
                
            case "DOCTOR":
                if isDoctorRCPAneeded {
                    switch self.cellRCPAType {
                    case .showRCPA:
                        return  rcpaResponseModel.count
                    case .hideRCPA:
                        return 0
                    }
                } else {
                    return 0
                }
                
            case "CHEMIST" :
                if isChemistRCPAneeded {
                    switch self.cellRCPAType {
                    case .showRCPA:
                        return  rcpaResponseModel.count
                    case .hideRCPA:
                        return 0
                    }
                } else {
                    return 0
                }
            case "ULDOCTOR" :
                if isUnListedDoctorRCPAneeded {
                    switch self.cellRCPAType {
                    case .showRCPA:
                        return  rcpaResponseModel.count
                    case .hideRCPA:
                        return 0
                    }
                } else {
                    return 0
                }
            default:
                return 0
            }
            
        case 6:
            switch self.cellEventsType {
            case .showEvents:
                return eventsResponseModel.count
            case .hideEvents:
                return 0
            }
        case 7:
            return 1
           
        default:
            return 0
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.width, height: 160)
        case 1:
            return CGSize(width: collectionView.width, height: 40)
      
        case 2:
            return CGSize(width: collectionView.width, height: 40)
        case 3:
            return CGSize(width: collectionView.width, height: 40)
            
        case 4:
            return CGSize(width: collectionView.width, height: 0)
            
        case 5:
            return CGSize(width: collectionView.width, height: 40)
            
        case 6:
            switch indexPath.row {
            case 0:
                return  CGSize(width: collectionView.width, height: 40)
            default:
                return  CGSize(width: collectionView.width, height: 70)
                
            }
          //  return CGSize(width: collectionView.width, height: 40)

        case 7:
            return CGSize(width: collectionView.width, height: 100)
            
        default:
            return CGSize()
        }
        
        


    }

    
    func collectionView(_ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            
          //
        case 1:
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(DetailedSectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
                guard let typedHeaderView = headerView as? DetailedSectionReusableView else { return headerView
                }

                return typedHeaderView
            default:
                print("No header")
            }
        case 2:
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(ProductSectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
                guard let typedHeaderView = headerView as? ProductSectionReusableView else { return headerView
                }
                switch dcrApprovalinfoVC.approvalDetail?.type {
                case "DOCTOR":
                    if isDoctorRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
                    }
                case "CHEMIST" :
                    if isChemistRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
                    }
                case "ULDOCTOR":
                    if isUnListedDoctorRCPAneeded {
                        typedHeaderView.isRCPAneeded = true
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
            
        case 4:
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(SpecificDCRadditioanCallsinfoReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
                guard let typedHeaderView = headerView as? SpecificDCRadditioanCallsinfoReusableView else { return headerView
                }

                return typedHeaderView
            default:
                print("No header")
            }
            
        case  5, 6:
     
            switch kind {
            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                  withReuseIdentifier: "\(RCPASectionReusableView.self)",
                                  for: indexPath)  // Or simply withReuseIdentifier: "Item1HeaderView"
                headerView.backgroundColor = .clear
             
                guard let typedHeaderView = headerView as? RCPASectionReusableView else { return headerView
                }

                typedHeaderView.sectionHolderView.layer.borderWidth = 1
                typedHeaderView.sectionHolderView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor
       
                switch indexPath.section {
                case 5:
                    typedHeaderView.sectionImage.image =  self.cellRCPAType == .hideRCPA ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
                    typedHeaderView.sectionTitle.text =  "RCPA"
                    typedHeaderView.addTap {
                        if self.cellRCPAType == .showRCPA {
                            self.cellRCPAType =  .hideRCPA
                            self.delegate?.didRCPAtapped(isrcpaTapped: false, index: self.selectedIndex ?? 0, responsecount: 0)
                            self.approvalDetailsCollection.reloadData()
                            return
                        }
   
                        
                        self.dcrApprovalinfoVC.makeRcpaApiCall()  {response in
                            if response.isEmpty {
                                self.toCreateToast("No RCPA found!")
                                return
                            }
                            // self.cellEventsType =  .hideEvents
                             self.cellRCPAType =  self.cellRCPAType == .showRCPA ?  .hideRCPA :  .showRCPA
                             self.delegate?.didRCPAtapped(isrcpaTapped: self.cellRCPAType == .showRCPA ? true :  false, index: self.selectedIndex ?? 0, responsecount: 1)
                             self.approvalDetailsCollection.reloadData()
                         
                        }
                    }
                case 6:
                    typedHeaderView.sectionImage.image =  self.cellEventsType == .hideEvents ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
                    typedHeaderView.sectionTitle.text =  "Captured Event"
                    typedHeaderView.addTap {
                        if self.cellEventsType == .showEvents {
                            self.cellEventsType =  .hideEvents
                            self.delegate?.didEventstapped(isEventstapped: false, index: self.selectedIndex ?? 0, response: [EventResponse()])
                            
                           // self.delegate?.didSlidestapped(isSlidestapped: false, index: self.selectedIndex ?? 0, responsecount: 0)
                            self.approvalDetailsCollection.reloadData()
                            return
                        }

                        self.dcrApprovalinfoVC.makeEventsInfoApiCall()  { response in
                            if response.isEmpty {
                                self.toCreateToast("No Events info found!")
                                return
                            }
                            self.cellEventsType =  .showEvents
                           // self.cellRCPAType = .hideRCPA
                            self.delegate?.didEventstapped(isEventstapped: true, index: self.selectedIndex ?? 0, response: [EventResponse()])
                            self.approvalDetailsCollection.reloadData()
                         
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
        
        if section == 1 {
            switch dcrApprovalinfoVC.approvalDetail?.type {
                
            case "DOCTOR":
                if isDoctorDetailingNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case "CHEMIST" :
                if isChemistDetailingNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                } else {
                    return CGSize()
                }
   
            case "ULDOCTOR":
                if isUnListedDoctorDetailingNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            default:
                return CGSize()
            }
         
        }
        
        if section == 5 {
            switch dcrApprovalinfoVC.approvalDetail?.type {
                
            case "DOCTOR":
                if isDoctorRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
                
            case "CHEMIST" :
                if isChemistRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case "ULDOCTOR" :
                if isUnListedDoctorRCPAneeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            default:
                return CGSize()
            }
        }
        if section == 6 {
            switch dcrApprovalinfoVC.approvalDetail?.type {
                
            case "DOCTOR":
                if isDoctorEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case "CHEMIST" :
                if isChemistEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case "STOCKIST":
                if isStockistEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            case "ULDOCTOR":
                if isUnListedDoctorEventCaptureNeeded {
                    return CGSize(width: collectionView.frame.width, height: 60)
                }
            default:
                return CGSize()
            }
         
        }
        
        
        if section == 2  || section == 3    {
            return CGSize(width: collectionView.frame.width, height: 60)
        } else {
            return CGSize()
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let model = dcrApprovalinfoVC.approvalDetail else {return UICollectionViewCell()}
            let cell: SpecificDCRgeneralinfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificDCRgeneralinfoCVC", for: indexPath) as! SpecificDCRgeneralinfoCVC
            cell.toPopulateCell(model: model)
            return cell
            //Yet to remove
        case 1:
            let cell: SpecificDCRslideinfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificDCRslideinfoCVC", for: indexPath) as! SpecificDCRslideinfoCVC

            return cell
        case 2:
            

                let cell: ProductsDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsDescriptionCVC", for: indexPath) as! ProductsDescriptionCVC
                let modelStr = self.productStrArr[indexPath.row]

            
            switch dcrApprovalinfoVC.approvalDetail?.type {
                
            case "DOCTOR":
                if isDoctorRCPAneeded {
                    cell.isRCPAneeded = true
                }
            case "CHEMIST" :
                if isChemistRCPAneeded {
                    cell.isRCPAneeded = true
                }
    
            case "ULDOCTOR":
                if isUnListedDoctorRCPAneeded {
                    cell.isRCPAneeded = true
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
                let cell: ProductsDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsDescriptionCVC", for: indexPath) as! ProductsDescriptionCVC
//                let modelStr = self.productStrArr[indexPath.row]
//
//                cell.topopulateCell(modelStr: modelStr)
                
                return cell
            
        case 5:
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
                    cell.infoView.addTap {
                        self.didRCPAinfoTapped(view: cell.infoView, model: model)
                    }
                    return cell
                }
            case .hideRCPA:
                return UICollectionViewCell()
            }

          //  SlidesDescriptionCVC
        case 6:
            switch self.cellEventsType {
            case .showEvents:
                switch indexPath.row {
                case 0:
                    let cell: SpecificDCReventsInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificDCReventsInfoCVC", for: indexPath) as! SpecificDCReventsInfoCVC
                    cell.contentHolderView.layer.cornerRadius = 5
                    cell.contentHolderView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
                    return cell
                default:
                    let cell: SpecificDCReventsDescCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificDCReventsDescCVC", for: indexPath) as! SpecificDCReventsDescCVC
                    cell.eventIV.layer.cornerRadius = 3
                    cell.eventIV.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
                    return cell
                }
            case .hideEvents:
                return UICollectionViewCell()
            }
        case 7:
            guard let model = self.dcrApprovalinfoVC.approvalDetail else {return UICollectionViewCell()}
            let cell: SpecificDCRremarksCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificDCRremarksCVC", for: indexPath) as! SpecificDCRremarksCVC
            cell.feedbackDescLbl.text = model.callFeedback
            cell.remarlsDescLbl.text = model.remarks
            return cell
            
        default:
           return UICollectionViewCell()
        }
    }
    
    
}


 
class DCRapprovalinfoView : BaseView {
    
    
    @IBOutlet var approvalTitle: UILabel!
    
    @IBOutlet weak var topNavigationView: UIView!
    
    
    @IBOutlet weak var collectionHolderView: UIView!
    
    @IBOutlet weak var backHolderView: UIView!
    
    
    @IBOutlet weak var approvalDetailsCollection: UICollectionView!
    
    
    @IBOutlet weak var approvalTable: UITableView!
    
    
    @IBOutlet var searchHolderView: UIView!
    
    @IBOutlet var dismissVIew: UIView!
    
    @IBOutlet var searchTF: UITextField!
    

    
    var commentsSubject = PassthroughSubject<Int, Never>()
    
    //@IBOutlet var approveView: UIView!
    var isSearched: Bool = false
    var typeImage : UIImage?
    weak var delegate: ViewAllInfoTVCDelegate?
    var selectedIndex : Int? = nil
    var cellEventsType: cellEventsType = .hideEvents
    var cellSlidesType: CellSlidesType = .hideSlides
    var cellRCPAType: CellRCPAType = .hideRCPA
    var isTohideLocationInfo = false
    var dcrApprovalinfoVC : DCRapprovalinfoVC!
    var slidesResponseModel : [SlideDetailsResponse] = []
    var rcpaResponseModel : [RCPAresonseModel] = []
    var eventsResponseModel : [EventResponse] = []
    var ResponseModel : [EventResponse] = []
    var productStrArr : [SampleProduct] = []
    
    var inputStrArr: [SampleInput] = []
    var selectedBrandsIndex: Int?
    var selectedType: CellType = .Doctor
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.dcrApprovalinfoVC = baseVC as? DCRapprovalinfoVC
        initTaps()
        setupUI()
        toSetDataSourceForInputs()
        toSetDataSourceForProducts()
        cellregistration()
        loadApprovalTable()
        loadApprovalDetailCollection()
        dcrApprovalinfoVC.makeSlidesInfoApiCall { model in
            self.loadApprovalDetailCollection()
        }
    }
    
    func setupUI() {
        self.backgroundColor = .appGreyColor
        collectionHolderView.layer.cornerRadius = 5
        searchHolderView.layer.cornerRadius = 5
        dismissVIew.layer.cornerRadius = 5
      
        dismissVIew.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        dismissVIew.layer.borderWidth = 1
        dismissVIew.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        dcrApprovalinfoVC.reportsVM = ReportsVM()
        searchTF.delegate = self
    }
    
    func loadApprovalTable() {
        approvalTable.delegate = self
        approvalTable.dataSource = self
        approvalTable.reloadData()
    }
    
    func loadApprovalDetailCollection() {
        approvalDetailsCollection.delegate = self
        approvalDetailsCollection.dataSource = self
        approvalDetailsCollection.reloadData()
    }
    
    func didRCPAinfoTapped(view: UIView, model: RCPAresonseModel) {
        print("Tapped -->")
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 7), on: view,  pagetype: .RCPA)

        vc.color = .appTextColor
        vc.rcpaInfo = model
 
        self.dcrApprovalinfoVC?.navigationController?.present(vc, animated: true)
    }
    
    func cellregistration() {
        approvalTable.register(UINib(nibName: "DCRApprovalsTVC", bundle: nil), forCellReuseIdentifier: "DCRApprovalsTVC")
        

//        approvalDetailsCollection.register(UINib(nibName: "VisitInfoCVC", bundle: nil), forCellWithReuseIdentifier: "VisitInfoCVC")
                approvalDetailsCollection.register(UINib(nibName: "SpecificDCRgeneralinfoCVC", bundle: nil), forCellWithReuseIdentifier: "SpecificDCRgeneralinfoCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "SpecificDCRslideinfoCVC", bundle: nil), forCellWithReuseIdentifier: "SpecificDCRslideinfoCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "SpecificDCReventsDescCVC", bundle: nil), forCellWithReuseIdentifier: "SpecificDCReventsDescCVC")
        

//        extendedInfoCollection.register(UINib(nibName: "ProductSectionTitleCVC", bundle: nil), forCellWithReuseIdentifier: "ProductSectionTitleCVC")
        approvalDetailsCollection.register(UINib(nibName: "rcpaCVC", bundle: nil), forCellWithReuseIdentifier: "rcpaCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "SpecificDCRremarksCVC", bundle: nil), forCellWithReuseIdentifier: "SpecificDCRremarksCVC")

        
        approvalDetailsCollection.register(UINib(nibName: "ProductsDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "ProductsDescriptionCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "InputDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "InputDescriptionCVC")
        
        
        approvalDetailsCollection.register(UINib(nibName: "RCPAsectionHeader", bundle: nil), forCellWithReuseIdentifier: "RCPAsectionHeader")
        
        
        approvalDetailsCollection.register(UINib(nibName: "RCPAdetailsDesctiptionCVC", bundle: nil), forCellWithReuseIdentifier: "RCPAdetailsDesctiptionCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "RCPAdetailsInfoCVC", bundle: nil), forCellWithReuseIdentifier: "RCPAdetailsInfoCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "SlidesInfoCVC", bundle: nil), forCellWithReuseIdentifier: "SlidesInfoCVC")
        
        approvalDetailsCollection.register(UINib(nibName: "SpecificDCReventsInfoCVC", bundle: nil), forCellWithReuseIdentifier: "SpecificDCReventsInfoCVC")
        
        
        
        
        approvalDetailsCollection.register(RCPASectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RCPASectionReusableView")
        
        approvalDetailsCollection.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        
        
        
        
        approvalDetailsCollection.register(SpecificDCRadditioanCallsinfoReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SpecificDCRadditioanCallsinfoReusableView")
        
        approvalDetailsCollection.register(DetailedSectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailedSectionReusableView")
        
        approvalDetailsCollection.register(ProductSectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductSectionReusableView")
        
        approvalDetailsCollection.register(InputSectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InputSectionReusableView")
        
    }

    
    func initTaps() {
        backHolderView.addTap {
            self.dcrApprovalinfoVC.navigationController?.popViewController(animated: true)
        }
        
        dismissVIew.addTap {
            self.dcrApprovalinfoVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func toSetDataSourceForInputs()   {
        guard let approvadetail = self.dcrApprovalinfoVC.approvalDetail else {return}
        inputStrArr.removeAll()
        //detailedReportModel?.gifts
        if approvadetail.gifts != "" {
            var inputArr = [String]()
            
            inputArr = approvadetail.gifts.components(separatedBy: ",")
            inputArr.removeLast()
            if inputArr.count == 0 {
                inputArr.append(approvadetail.gifts)
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
        guard let approvadetail = self.dcrApprovalinfoVC.approvalDetail else {return}
        productStrArr.removeAll()
     //   productStrArr.append(SampleProduct(prodName: "", isPromoted: false, noOfSamples: "", rxQTY: "", rcpa: "", isDemoProductCell: true))
        
       if approvadetail.products != "" {
           var prodArr =  approvadetail.products.components(separatedBy: ",")
     
           prodArr.removeLast()
      
           
           let filteredComponents = prodArr.map { anElement -> String in
               var modifiedElement = anElement
               if modifiedElement.first == " " {
                   modifiedElement.removeFirst()
               }
               return modifiedElement
           }
           
   
           filteredComponents.forEach { prod in
               var prodString: [String] = []
               prodString.append(contentsOf: prod.components(separatedBy: "("))
               prodString = prodString.map({ aprod in
                   aprod.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
               })

               var name: String = ""
               var isPromoted: Bool = false
               var noOfsamples: String = ""
               var rxQty: String = ""
               var rcpa: String = ""

               prodString.enumerated().forEach { prodindex, prod in
                   switch prodindex {
                   case 0:
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

               let promotdProduct: String? = approvadetail.promotedProduct
               guard let promotdProduct = promotdProduct, promotdProduct != "" else {
                   let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false, remarks: approvadetail.remarks)

                   productStrArr.append(aProduct)

                   return
               }

               // Split the promotedProduct string by the "$" delimiter
               let components = promotdProduct.components(separatedBy: "$")

               // Process each component to remove "#" character
               let namesWithoutHash = components.map { $0.replacingOccurrences(of: "#", with: "") }

               // Extract words after the "$" sign and flatten the resulting array
               let words = namesWithoutHash.flatMap { $0.components(separatedBy: " ") }

               // Check if any of the extracted words matches the name
               if namesWithoutHash[1] == name.trimmingCharacters(in: .whitespaces) {
                   print("The 'promotedProduct' contains '\(name)'")
                   _ = DBManager.shared.getProduct().filter { $0.code == words[0] }.first
                   isPromoted = true
               } else {
                   print("The 'promotedProduct' does not contain '\(name)'")
                   isPromoted = false
               }

               let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false, remarks: approvadetail.remarks)

               productStrArr.append(aProduct)
           }
       } else {
           productStrArr.append(SampleProduct(prodName: "-", isPromoted: nil, noOfSamples: "-", rxQTY: "-", rcpa: "-", isDemoProductCell: true, remarks: "-"))
       }

        dump(productStrArr)
         
    }
    
}

extension DCRapprovalinfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let approvals = isSearched ? dcrApprovalinfoVC.filteredApprovals : dcrApprovalinfoVC.allApprovals else {return 0}
        return approvals.count


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return tableView.height / 11

        
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let approvals =  isSearched ? dcrApprovalinfoVC.filteredApprovals : dcrApprovalinfoVC.allApprovals else {return UITableViewCell()}
            let cell: DCRApprovalsTVC = approvalTable.dequeueReusableCell(withIdentifier: "DCRApprovalsTVC", for: indexPath) as! DCRApprovalsTVC
            cell.selectionStyle = .none
            cell.approcalDateLbl.textColor = .appTextColor
            cell.mrNameLbl.textColor = .appTextColor
            cell.contentHolderView.backgroundColor = .appWhiteColor
            cell.contentHolderView.layer.cornerRadius = 5
            cell.accessoryIV.image = UIImage(named: "chevlon.right")
            cell.accessoryIV.tintColor = .appTextColor
            cell.dateHolderView.isHidden = true
            let model = approvals[indexPath.row]
            cell.populateCell(model)
            if selectedBrandsIndex == indexPath.row {
                cell.contentHolderView.backgroundColor = .appTextColor
                cell.mrNameLbl.textColor = .appWhiteColor
                cell.accessoryIV.tintColor = .appWhiteColor
            }
            
            cell.addTap {[weak self] in
                guard let welf = self else {return}
                welf.selectedBrandsIndex = indexPath.row
                welf.approvalTable.reloadData()
                welf.dcrApprovalinfoVC.approvalDetail = welf.dcrApprovalinfoVC.allApprovals?[indexPath.row]
                welf.toSetDataSourceForInputs()
                welf.toSetDataSourceForProducts()
                welf.loadApprovalDetailCollection()
            }
            
     return cell

    }
    
    
}
