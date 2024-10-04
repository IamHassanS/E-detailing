//
//  VisitsCountTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import UIKit


protocol VisitsCountTVCDelegate: AnyObject {
    func typeChanged(index: Int, type: CellType)
}

extension VisitsCountTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: VisitsCountCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitsCountCVC", for: indexPath) as! VisitsCountCVC

        let model = self.visitsInfo[indexPath.row]
        cell.type = model.type
        cell.countsLbl.text = "\(model.count)"
        cell.toPopulatecell()

        cell.holderView.layer.borderWidth = 0
        selectedIndex.keys.forEach { type in
            if type ==   cell.type {
                cell.holderView.layer.borderColor = model.type.coclor.cgColor
                cell.holderView.layer.borderWidth = 1
            }
        }
        
        cell.addTap {
            self.selectedIndex = [:]
            self.selectedIndex[model.type] = true
            cell.selectedIndex = indexPath.row
            self.visitTypesCVC.reloadData()
            self.delegate?.typeChanged(index: indexPath.row, type: model.type)
         
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:visitsInfo[indexPath.item].type.rawValue.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: collectionView.height)
        
     //   return CGSize(width: collectionView.width / 8, height: collectionView.height)
    }
    
    
}

class VisitsCountTVC: UITableViewCell {
    
    struct VisitCount {
        let type: CellType
        let count : Int
    }
    

    @IBOutlet var visitTypesCVC: UICollectionView!
    var wtModel:  ReportsModel?
    weak var delegate: VisitsCountTVCDelegate?
    var selectedIndex : [CellType : Bool] = [:]
    var type: [CellType] = [.All, .Doctor, .Chemist, .Stockist, .Hospital]
    var visitsInfo : [VisitCount] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellRegistration()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellRegistration() {
        
        if let layout = self.visitTypesCVC.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.isScrollEnabled = false
        }
        
        visitTypesCVC.register(UINib(nibName: "VisitsCountCVC", bundle: nil), forCellWithReuseIdentifier: "VisitsCountCVC")
    }
    
    
    func toPopulateCell(model: [ApprovalDetailsModel]) {
        let setups = AppDefaults.shared.getAppSetUp()
        type.removeAll()
        type.append(.All)
        
        if setups.docNeed == 0 {
            type.append(.Doctor)
        }
        
        if setups.chmNeed == 0 {
            type.append(.Chemist)
        }
        
        if setups.stkNeed == 0 {
            type.append(.Stockist)
        }
        
        if setups.unlNeed == 0 {
            type.append(.UnlistedDoctor)
        }
        
        var totalVisitCount: Int = 0
        let  docCount = model.filter { $0.type == "DOCTOR"}.count
        let chmCount = model.filter { $0.type == "CHEMIST"}.count
        let  stkCount = model.filter { $0.type == "STOCKIST"}.count
        let cipCount = model.filter { $0.type == "CIP"}.count
        let unlistCount =  model.filter { $0.type == "ULDOCTOR"}.count
        let hospCount = model.filter { $0.type == "HOSPITAL"}.count

        totalVisitCount = docCount + chmCount + stkCount + hospCount + cipCount + unlistCount
        visitsInfo.removeAll()
        self.type.forEach { cellType in
            switch cellType {
                
            case .All:
                let avisitsInfo = VisitCount(type: cellType, count: totalVisitCount)
                visitsInfo.append(avisitsInfo)
            case .Doctor:
                let avisitsInfo = VisitCount(type: cellType, count: docCount)
                visitsInfo.append(avisitsInfo)
            case .Chemist:
                let avisitsInfo = VisitCount(type: cellType, count: chmCount)
                visitsInfo.append(avisitsInfo)
            case .Stockist:
                let avisitsInfo = VisitCount(type: cellType, count: stkCount)
                visitsInfo.append(avisitsInfo)
            case .Hospital:
                let avisitsInfo = VisitCount(type: cellType, count: hospCount)
                visitsInfo.append(avisitsInfo)
            case .CIP:
                let avisitsInfo = VisitCount(type: cellType, count: cipCount)
                visitsInfo.append(avisitsInfo)
            case .UnlistedDoctor:
                let avisitsInfo = VisitCount(type: cellType, count: unlistCount)
                visitsInfo.append(avisitsInfo)
            }
          
        }
        
        toloadData()
        
    }
    
    func topopulateCell(model: ReportsModel) {
        let setups = AppDefaults.shared.getAppSetUp()
        type.removeAll()
        type.append(.All)
        
        if setups.docNeed == 0 {
            type.append(.Doctor)
        }
        
        if setups.chmNeed == 0 {
            type.append(.Chemist)
        }
        
        if setups.stkNeed == 0 {
            type.append(.Stockist)
        }
        
        if setups.unlNeed == 0 {
            type.append(.UnlistedDoctor)
        }
        
        var totalVisitCount: Int = 0
        let  docCount = model.drs
        let chmCount = model.chm
        let  stkCount = model.stk
        let cipCount = model.cip
        let unlistCount = model.udr
        let hospCount = model.hos

         totalVisitCount = docCount + chmCount + stkCount + hospCount + cipCount + unlistCount
        visitsInfo.removeAll()
        self.type.forEach { cellType in
            switch cellType {
                
            case .All:
                let avisitsInfo = VisitCount(type: cellType, count: totalVisitCount)
                visitsInfo.append(avisitsInfo)
            case .Doctor:
                let avisitsInfo = VisitCount(type: cellType, count: docCount)
                visitsInfo.append(avisitsInfo)
            case .Chemist:
                let avisitsInfo = VisitCount(type: cellType, count: chmCount)
                visitsInfo.append(avisitsInfo)
            case .Stockist:
                let avisitsInfo = VisitCount(type: cellType, count: stkCount)
                visitsInfo.append(avisitsInfo)
            case .Hospital:
                let avisitsInfo = VisitCount(type: cellType, count: hospCount)
                visitsInfo.append(avisitsInfo)
            case .CIP:
                let avisitsInfo = VisitCount(type: cellType, count: cipCount)
                visitsInfo.append(avisitsInfo)
            case .UnlistedDoctor:
                let avisitsInfo = VisitCount(type: cellType, count: unlistCount)
                visitsInfo.append(avisitsInfo)
            }
          
        }
        
       
        toloadData()
        
    }
    
    func toloadData() {
        visitTypesCVC.delegate = self
        visitTypesCVC.dataSource = self
        visitTypesCVC.reloadData()
    }
    
}
