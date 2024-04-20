//
//  VisitsCountTVC.swift
//  E-Detailing
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
            if indexPath.row == 0 {
                
            } else {
                self.delegate?.typeChanged(index: indexPath.row, type: model.type)
            }
         
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 8, height: collectionView.height)
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
    
    func topopulateCell(model: ReportsModel) {
        
        var totalVisitCount: Int = 0
        let   docCount = model.drs
        let chmCount = model.chm
        let  stkCount = model.stk
        let cipCount = model.cip
        let hospCount = model.hos
       // visitsInfo.removeAll()
      //  if model.drs != 0 {
           // let type: CellType = .Doctor
          //  let avisitsInfo = VisitCount(type: type, count: model.drs)
          //  visitsInfo.append(avisitsInfo)
          
           // totalVisitCount = totalVisitCount + model.drs
       // }
        
//        if model.chm != 0 {
//            let type: CellType = .Chemist
//            let avisitsInfo = VisitCount(type: type, count: model.chm)
//            visitsInfo.append(avisitsInfo)
//            totalVisitCount = totalVisitCount + model.chm
//        }
//
//
//        if model.stk != 0 {
//            let type: CellType = .Stockist
//            let avisitsInfo = VisitCount(type: type, count: model.stk)
//            visitsInfo.append(avisitsInfo)
//            totalVisitCount = totalVisitCount + model.stk
//        }
//
//        if model.udr != 0 {
//            let type: CellType = .CIP
//            let avisitsInfo = VisitCount(type: type, count: model.udr)
//            visitsInfo.append(avisitsInfo)
//            totalVisitCount = totalVisitCount + model.udr
//        }
//        if model.cip != 0 {
//            let type: CellType = .CIP
//            let avisitsInfo = VisitCount(type: type, count: model.cip)
//            visitsInfo.append(avisitsInfo)
//            totalVisitCount = totalVisitCount + model.cip
//        }
//
//        if model.hos != 0 {
//            let type: CellType = .Hospital
//            let avisitsInfo = VisitCount(type: type, count: model.hos)
//            visitsInfo.append(avisitsInfo)
//            totalVisitCount = totalVisitCount + model.hos
//        }
//
//        if visitsInfo.count > 0 {
//            let type: CellType = .All
//            let avisitsInfo = VisitCount(type: type, count: totalVisitCount)
//            visitsInfo.append(avisitsInfo)
//        }
         totalVisitCount = docCount + chmCount + stkCount + hospCount + cipCount
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
