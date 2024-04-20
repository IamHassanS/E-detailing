//
//  ViewAllInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/12/23.
//

import UIKit

extension ViewAllInfoTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch self.cellType {
            
        case .showRCPA:
           
            //MARK: - rcpa cell (+1 section)
            return 7
        case .hideRCPA:
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch section {
        case 1:
            if self.isTohideLocationInfo {
                return 0
            } else {
                return 1
            }
        case 2:
            return  productStrArr.count
        case 3:
            return 1
        default:
            switch self.cellType {
                
            case .showRCPA:
                switch section {
                    //MARK: - rcpa cell (+1 section)
                case 4:
                    return 3
                default:
                    return 1
                }
            case .hideRCPA:
                switch section {
                default:
                    return 1
                }
            }
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
            return CGSize(width: collectionView.width, height: 60)
        default:
            switch self.cellType {
                
            case .showRCPA:
                switch indexPath.section {

                    
                    //MARK: - rcpa cell (+1 section)
                case 4:
                    return CGSize(width: collectionView.width, height: 40)
                    
                case 5:
                    return CGSize(width: collectionView.width, height: 75)
                case 6:
                    return CGSize(width: collectionView.width, height: 50)
                default:
                    return CGSize()
                }
            case .hideRCPA:
                switch indexPath.section {
                case 4:
                    return CGSize(width: collectionView.width, height: 75)
                case 5:
                    return CGSize(width: collectionView.width, height: 50)
                default:
                    return CGSize()
                }
            }
        }
        
        


    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Create and return the header view
        if indexPath.section == 2 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.identifier, for: indexPath) as! CustomHeaderView
                headerView.titleLabel.text = "Product"
                return headerView
            }
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Return the size of your header
        if section == 2 {
            return CGSize(width: collectionView.frame.width, height: 50)
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
            
            
            switch indexPath.row {
            case 0:
                let cell: ProductSectionTitleCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSectionTitleCVC", for: indexPath) as! ProductSectionTitleCVC
                cell.holderVoew.backgroundColor = .appGreyColor
                return cell
            default:
                let cell: ProductsDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsDescriptionCVC", for: indexPath) as! ProductsDescriptionCVC
                let modelStr = self.productStrArr[indexPath.row]

                cell.topopulateCell(modelStr: modelStr)
                
                return cell
            }
        case 3:
            let cell: rcpaCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "rcpaCVC", for: indexPath) as! rcpaCVC
            cell.addTap {
                self.cellType =   self.cellType == .showRCPA ?  .hideRCPA : .showRCPA
                self.delegate?.didLessTapped(islessTapped: false, isrcpaTapped: self.cellType  == .hideRCPA ?  false : true, index: self.selectedIndex ?? 0)
                //self.cellType == .showRCPA ? true : false
                self.extendedInfoCollection.reloadData()
            }
            return cell
        default:
            switch self.cellType {
                
            case .showRCPA:
                switch indexPath.section {
                    //MARK: - rcpa cell (+1 section)
                case 4:
                    switch indexPath.row {
                    case 0:
                        let cell: ProductSectionTitleCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSectionTitleCVC", for: indexPath) as! ProductSectionTitleCVC
                        cell.holderVoew.backgroundColor = .appGreyColor
                        return cell
                    default:
                        let cell: ProductsDescriptionCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsDescriptionCVC", for: indexPath) as! ProductsDescriptionCVC
                        cell.topopulateCell(modelStr: SampleProduct(prodName: "-", isPromoted: false, noOfSamples: "-", rxQTY: "-", rcpa: "-", isDemoProductCell: true))
                        return cell
                    }
                case 5:
                    let cell: ReportsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportsCVC", for: indexPath) as! ReportsCVC
                    return cell
                    
                    
                case 6:
                    let cell: ViewmoreCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewmoreCVC", for: indexPath) as! ViewmoreCVC
                    cell.addTap {
                        
                        self.delegate?.didLessTapped(islessTapped: true, isrcpaTapped: false, index: self.selectedIndex ?? 0)
                    }
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            case .hideRCPA:
                switch indexPath.section {
                case 4:
                    let cell: ReportsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportsCVC", for: indexPath) as! ReportsCVC
                    return cell
                case 5:
                    let cell: ViewmoreCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewmoreCVC", for: indexPath) as! ViewmoreCVC
                    cell.addTap {
                        
                        self.delegate?.didLessTapped(islessTapped: true, isrcpaTapped: false, index: self.selectedIndex ?? 0)
                    }
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            }
        }
        

        
    }
    
    
}

protocol ViewAllInfoTVCDelegate: AnyObject {
    func didLessTapped(islessTapped: Bool, isrcpaTapped: Bool, index: Int)
        
    
}

struct SampleProduct {
    let prodName: String
    let isPromoted: Bool
    let noOfSamples : String
    let rxQTY: String
    let rcpa: String
    let isDemoProductCell: Bool
}

class ViewAllInfoTVC: UITableViewCell {

    enum CellType {
        case showRCPA
        case hideRCPA
    }
    
    

    
    @IBOutlet var extendedInfoCollection: UICollectionView!
    weak var delegate: ViewAllInfoTVCDelegate?
    var rcpaTapped: Bool = false
    //var selectedType: CellType = .All
    var cellType: CellType = .hideRCPA
    var reportModel: ReportsModel?
    var detailedReportModel: DetailedReportsModel?
    var productStrArr : [SampleProduct] = []
    var typeImage: UIImage?
    var isTohideLocationInfo = false
    var selectedIndex : Int? = nil
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
    
    func toSetDataSourceForProducts() {
        productStrArr.removeAll()
        productStrArr.append(SampleProduct(prodName: "", isPromoted: false, noOfSamples: "", rxQTY: "", rcpa: "", isDemoProductCell: true))
        
       if detailedReportModel?.products != "" {
           var prodArr =  detailedReportModel?.products.components(separatedBy: ",")
           if prodArr?.last == "" {
               prodArr?.removeLast()
           }
           prodArr?.forEach { prod in
               var prodString : [String] = []
               prodString.append(contentsOf: prod.components(separatedBy: "("))
               prodString = prodString.map({ aprod in
                   aprod.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
               })
               var name: String = ""
               var isPromoted: String = ""
               var noOfsamples: String = ""
               var rxQty: String = ""
               var rcpa: String  = ""
               prodString.enumerated().forEach {prodindex, prod in
             
                  // let sampleProduct: SampleProduct
                   switch prodindex {
                   case 0 :
                       name = prod
                   case 1:
                       isPromoted = prod
                   case 2:
                       noOfsamples = prod
                   case 3:
                       rxQty = prod
                   case 4:
                       rcpa = prod
                   default:
                       print("default")
                   }
               }
               let aProduct = SampleProduct(prodName: name, isPromoted: isPromoted.replacingOccurrences(of: " ", with: "") == "0" ? true : false, noOfSamples: noOfsamples, rxQTY: rxQty, rcpa: rcpa, isDemoProductCell: false)
               
             //  let aProduct = SampleProduct(prodName: prodString[0].isEmpty ? "" : prodString[0] , isPromoted: prodString[1].isEmpty ? false : prodString[1].contains("0") ? true : false, noOfSamples:  prodString[2].isEmpty ? "" : prodString[2] , rxQTY:  prodString[3].isEmpty ? "" : prodString[3] , rcpa:  prodString[4].isEmpty ? "" : prodString[4])
               productStrArr.append(aProduct)
           }
       } else {
           productStrArr.append(SampleProduct(prodName: "-", isPromoted: false, noOfSamples: "-", rxQTY: "-", rcpa: "-", isDemoProductCell: true))
       }

        
        //productStrArr.append(contentsOf: detailedReportModel?.products.components(separatedBy: ",") ?? [])
  
        
        
         
    }
    
    func toLoadData() {
        extendedInfoCollection.delegate = self
        extendedInfoCollection.dataSource = self
        extendedInfoCollection.reloadData()
    }
    
    func cellRegistration() {
        
        extendedInfoCollection.register(UINib(nibName: "VisitInfoCVC", bundle: nil), forCellWithReuseIdentifier: "VisitInfoCVC")
        extendedInfoCollection.register(UINib(nibName: "TimeInfoCVC", bundle: nil), forCellWithReuseIdentifier: "TimeInfoCVC")
        extendedInfoCollection.register(UINib(nibName: "ProductSectionTitleCVC", bundle: nil), forCellWithReuseIdentifier: "ProductSectionTitleCVC")
        extendedInfoCollection.register(UINib(nibName: "rcpaCVC", bundle: nil), forCellWithReuseIdentifier: "rcpaCVC")
        extendedInfoCollection.register(UINib(nibName: "ReportsCVC", bundle: nil), forCellWithReuseIdentifier: "ReportsCVC")
        extendedInfoCollection.register(UINib(nibName: "ViewmoreCVC", bundle: nil), forCellWithReuseIdentifier: "ViewmoreCVC")
        
        extendedInfoCollection.register(UINib(nibName: "ProductsDescriptionCVC", bundle: nil), forCellWithReuseIdentifier: "ProductsDescriptionCVC")
        
        extendedInfoCollection.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
