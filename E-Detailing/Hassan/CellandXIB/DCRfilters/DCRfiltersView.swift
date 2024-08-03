//
//  DCRfiltersView.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 16/03/24.
//

import UIKit
import CoreData


extension DCRfiltersView:  MenuResponseProtocol {
    func passProductsAndInputs( additioncall: AdditionalCallsListViewModel, index: Int) {
        print("Yet to implement")
    }
    

    
    func routeToView(_ view: UIViewController) {
        print("")
    }
    
    func callPlanAPI() {
        print("")
    }
    
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject]) {
        switch self.filtertype {
            
        case .category:
            switch self.type {
            case .chemist:
                self.selectedChemistCategory = selectedObject as? ChemistCategory
            default:
                self.selectedcategoty = selectedObject as? DoctorCategory
            }
           
        case .dcrClass:
            self.selecteddocClass = selectedObject as? DoctorClass
        case .speciality:
            self.selectedspeciality = selectedObject as? Speciality
        case .territory:
            self.selectedterritory = selectedObject as? Territory
            

        case .none:
              print("--><--")
        }
        
       // self.removeTable()
        self.toLOadData()
    }
    
    
}

protocol DCRfiltersViewDelegate: AnyObject {
    func isFiltersupdated(_ addedFiltercount: Int, isItemAdded: Bool)
}


extension DCRfiltersView: collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.addedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: addedFiltersCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "addedFiltersCVC", for: indexPath) as! addedFiltersCVC
        
        switch self.type {
            
        case .doctor:
            switch indexPath.row {
            case 0:
       
                cell.filtersTit.text = self.selectedspeciality != nil ?  self.selectedspeciality?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 1:
       
                cell.filtersTit.text = self.selectedcategoty != nil ?  self.selectedcategoty?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 2:
       
                cell.filtersTit.text = self.selectedterritory != nil ?  self.selectedterritory?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 3:
       
                cell.filtersTit.text = self.selecteddocClass != nil ?  self.selecteddocClass?.name : self.addedFilters[indexPath.row].rawValue
                
            default:
                print("Yet to implemeny")
            }
        case .chemist:
            switch indexPath.row {
            case 0:
                cell.filtersTit.text = self.selectedterritory != nil ?  self.selectedterritory?.name : self.addedFilters[indexPath.row].rawValue
            case 1:
                cell.filtersTit.text = self.selectedChemistCategory != nil ?  self.selectedChemistCategory?.name : self.addedFilters[indexPath.row].rawValue
            default:
                return UICollectionViewCell()
            }
        case .stockist:
            switch indexPath.row {
            case 0:
                cell.filtersTit.text = self.selectedterritory != nil ?  self.selectedterritory?.name : self.addedFilters[indexPath.row].rawValue
            default:
                return UICollectionViewCell()
            }
        case .unlistedDoctor:
            switch indexPath.row {
            case 0:
       
                cell.filtersTit.text = self.selectedspeciality != nil ?  self.selectedspeciality?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 1:
       
                cell.filtersTit.text = self.selectedcategoty != nil ?  self.selectedcategoty?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 2:
       
                cell.filtersTit.text = self.selectedterritory != nil ?  self.selectedterritory?.name : self.addedFilters[indexPath.row].rawValue
                
                
            case 3:
       
                cell.filtersTit.text = self.selecteddocClass != nil ?  self.selecteddocClass?.name : self.addedFilters[indexPath.row].rawValue
                
            default:
                print("Yet to implemeny")
            }
        case .hospital:
            print("Yet to")
        case .cip:
            print("Yet to")
        }
        

        
        
        cell.addTap { [weak self] in
            guard let welf = self else {return}
            welf.removeTable()
            switch welf.self.addedFilters[indexPath.row] {
                
            case .speciality:
                welf.filtertype = .speciality
              //  welf.addFiltersTable(type: .speciality, view: cell)
                welf.showMenu(type: .speciality)
            case .category:
                welf.filtertype = .category
                switch welf.type {
                  
                case .chemist:
                    welf.showMenu(type: .chemistCategory)
                default:
                    welf.showMenu(type: .category)
                }
               
              //  welf.addFiltersTable(type: .category, view: cell)
                welf.showMenu(type: .category)
            case .territory:
                welf.filtertype = .territory
              //  welf.addFiltersTable(type: .territory, view: cell)
                welf.showMenu(type: .clusterInfo)
            case .dcrClass:
                welf.filtertype = .dcrClass
               // welf.addFiltersTable(type: .dcrClass, view: cell)
                welf.showMenu(type: .doctorClass)
            }
        }
        return cell
        
    }
    
    
    func showMenu(type: MenuView.CellType) {
        
        let vc = SpecifiedMenuVC.initWithStory(self, celltype: type)
        vc.isFromfilter = true
        rootVC?.modalPresentationStyle = .custom
        rootVC?.present(vc, animated: false)
        
        
    }
    
    func removeTable() {
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case self.filterstable:
                aAddedView.removeFromSuperview()
            default:
                print("Yet to implement")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        switch self.type {
            
        case .doctor:
            switch self.addedIndex {
            case 1, 2:
                height = 60
            case 3, 4:
                height = 130 / 2
            default:
                print("Yet to implment")
            }
        case .chemist:
            height = 60
        case .stockist:
            height = 60
        case .unlistedDoctor:
            switch self.addedIndex {
            case 1, 2:
                height = 60
            case 3, 4:
                height = 130 / 2
            default:
                print("Yet to implment")
            }
        case .hospital:
            print("Yet to")
        case .cip:
            print("Yet to")
        }

        
//        if   self.addedFilters.count % 2 == 0 {
//            height = collectionView.height  / 2
//        } else {
//       
//            height = collectionView.height
//        }
        
        return CGSize(width: collectionView.width / 2.1, height: height)
    }
    
}

extension DCRfiltersView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.filtertype {
            
        case .category:
            return self.categoty?.count ?? 0
        case .dcrClass:
            return self.docClass?.count ?? 0
        case .speciality:
            return self.speciality?.count ?? 0
        case .territory:
            return self.territory?.count ?? 0
        case .none:
           return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell using the reuse identifier
        let cell: WorkTypeCell  = tableView.dequeueReusableCell(withIdentifier: "WorkTypeCell", for: indexPath) as! WorkTypeCell
        cell.selectionStyle = .none
        switch self.filtertype {
            
        case .category:
            cell.workTypeLbl?.text =  self.categoty?[indexPath.row].name
        case .dcrClass:
            cell.workTypeLbl?.text = self.docClass?[indexPath.row].name
        case .speciality:
            cell.workTypeLbl?.text = self.speciality?[indexPath.row].name
        case .territory:
            cell.workTypeLbl?.text = self.territory?[indexPath.row].name
        case .none:
            cell.workTypeLbl?.text = ""
        }
        
        
        cell.addTap {
            
            switch self.filtertype {
                
            case .category:
                self.selectedcategoty = self.categoty?[indexPath.row]
            case .dcrClass:
                self.selecteddocClass = self.docClass?[indexPath.row]
            case .speciality:
                self.selectedspeciality = self.speciality?[indexPath.row]
            case .territory:
                self.selectedterritory = self.territory?[indexPath.row]
            case .none:
                  print("--><--")
            }
            
            self.removeTable()
            self.toLOadData()
          
        }

        return cell
    }
    
    
}

class DCRfiltersView: UIView {
    
    
    func cellregistration() {
        if let layout = self.filtersCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.collectionView?.isScrollEnabled = true
        }
        
      
        
        filtersCollection.register(UINib(nibName: "addedFiltersCVC", bundle: nil), forCellWithReuseIdentifier: "addedFiltersCVC")
        
    }
    
    enum AddedFilters: String {
        case speciality
        case category
        case territory
        case dcrClass = "Class"
    }
    
    @IBOutlet var titleLbl: UILabel!
    

     @IBOutlet var closeIV: UIImageView!
    
    @IBOutlet var filtersView: UIView!
    
    @IBOutlet var filtersViewHeight: NSLayoutConstraint! // 130
    
    @IBOutlet var viewAddcontion: UIView!
    
    @IBOutlet var filtersCollection: UICollectionView!
    
    @IBOutlet var btnCLear: ShadowButton!
    
    @IBOutlet var btnApply: ShadowButton!
    
    @IBOutlet var removeFiltersIV: UIButton!
    
    var filterstable : UITableView?
    //@IBOutlet var viewAddfiltersHeight: NSLayoutConstraint!
    
    @IBOutlet var filtersCollectionHeight: NSLayoutConstraint! // 60

    var rootVC: UIViewController?
    
    weak var delegate: DCRfiltersViewDelegate?
    weak var addedSubviewDelegate :  addedSubViewsDelegate?
    var addedFilters: [AddedFilters] = []
    var addedIndex: Int = 2
    var speciality: [Speciality]?
    var categoty: [DoctorCategory]?
    var territory: [Territory]?
    var docClass: [DoctorClass]?
    var chemistCategory: [ChemistCategory]?
    
    var selectedspeciality: Speciality?
    var selectedcategoty: DoctorCategory?
    var selectedterritory: Territory?
    var selecteddocClass: DoctorClass?
    var selectedChemistCategory: ChemistCategory?
    var filtertype:  AddedFilters?
    
    var type: DCRType = .doctor
    func addFiltersTable(type: AddedFilters, view: UIView) {
        
    filterstable = {
           let filtersTable = UITableView()
        filtersTable.delegate = self
        filtersTable.dataSource = self
        filtersTable.layer.cornerRadius = 5
        filtersTable.layer.borderWidth = 1
        filtersTable.layer.borderColor = UIColor.appSelectionColor.cgColor
            return filtersTable
        }()
        guard let filterstable = filterstable else {return}
        filterstable.register(UINib(nibName: "WorkTypeCell", bundle: nil), forCellReuseIdentifier: "WorkTypeCell")
        filterstable.frame = CGRect(x: view.left + 10 , y: view.bottom + 60, width: view.width, height: self.height)
        self.addSubview(filterstable)
        switch type {
        case .speciality:
            speciality = DBManager.shared.getSpeciality()
           
        case .category:
            categoty = DBManager.shared.getCategory()
        case .territory:
            territory = DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
        case .dcrClass:
            docClass = DBManager.shared.getDoctorClass()
        }
        
    }
    
    func toLOadData() {
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.reloadData()
    }
    
    
    @IBAction func didtapClearBtn(_ sender: Any) {
        
    selectedspeciality = nil
    selectedcategoty = nil
        selectedChemistCategory = nil
    selectedterritory = nil
    selecteddocClass = nil
    self.toLOadData()
        
        
    }
    
    
    @IBAction func didTapApplyBtn(_ sender: Any) {
        var filteedObj = [NSManagedObject]()
        if let selectedcategoty = selectedcategoty {
            filteedObj.append(selectedcategoty)
        }
        
        if let selectedChemistcategoty = selectedChemistCategory {
            filteedObj.append(selectedChemistcategoty)
        }
        
        if let selectedspeciality = selectedspeciality {
            filteedObj.append(selectedspeciality)
        }
        
        if let selecteddocClass = selecteddocClass {
            filteedObj.append(selecteddocClass)
        }
        
        if let territory = selectedterritory {
            filteedObj.append(territory)
        }
        

            addedSubviewDelegate?.didUpdateFilters(filteredObjects: filteedObj)
   
       
    }
    
    
    func setupUI() {
        

        initTaps()

        cellregistration()
        toLOadData()
        viewAddcontion.layer.borderWidth = 1
        viewAddcontion.layer.borderColor = UIColor.appGreen.cgColor
        viewAddcontion.layer.cornerRadius = 5
        removeFiltersIV.setTitle("", for: .normal)
        self.layer.cornerRadius = 5
      
        btnCLear.backgroundColor = .appSelectionColor
        btnCLear.layer.borderColor = UIColor.gray.cgColor
        btnCLear.layer.borderWidth = 1
        

        
        
        
    }
    
    func initTaps() {
        switch self.type {
            
        case .doctor, .unlistedDoctor:
            self.addedFilters = [.speciality, .category]
                    if let _ = selectedterritory {
                        addedFilters.append(.territory)
                        filtersCollectionHeight.constant = 60 + 60 + 10
                        filtersViewHeight.constant = 130 + 60
                    }
            
                    if let _ = selecteddocClass {
                        if !addedFilters.contains(.territory) {
                            addedFilters.append(.territory)
                        }
            
                        addedFilters.append(.dcrClass)
                        filtersCollectionHeight.constant = 60 + 60 + 10
                        filtersViewHeight.constant = 130 + 60
                    }
            
         
            viewAddcontion.isHidden = false
            removeFiltersIV.isHidden = false
            
            viewAddcontion.addTap {
                
                switch self.type {
                    
                case .doctor, .unlistedDoctor:
                    if self.addedFilters.count == 4 {
                        return
                    }
                case .chemist:
                    if self.addedFilters.count == 2 {
                        return
                    }
                case .stockist:
                    if self.addedFilters.count == 2 {
                        return
                    }
                case .hospital:
                    if self.addedFilters.count == 2 {
                        return
                    }
                case .cip:
                    if self.addedFilters.count == 2 {
                        return
                    }
                }

                self.addedIndex = self.addedFilters.count + 1
                self.toAddorRemoveFilters(istoadd: true, index: self.addedFilters.count + 1)
            }
            
            self.removeFiltersIV.addTap {
                if self.addedFilters.count == 2 {
                    return
                }
                self.addedIndex = self.addedFilters.count - 1
                self.toAddorRemoveFilters(istoadd: false, index: self.addedFilters.count - 1)
            }
            
        case .chemist:
            self.addedFilters = [.territory, .category]
            if let _ = selectedterritory {
                if !addedFilters.contains(.territory) {
                    addedFilters.append(.territory)
                }
    
            }
      
            viewAddcontion.isHidden = true
            removeFiltersIV.isHidden = true
        case .stockist:
            self.addedFilters = [.territory]
            viewAddcontion.isHidden = true
            removeFiltersIV.isHidden = true
        case .hospital:
            print("Yet to")
        case .cip:
            print("Yet to")
        }
        self.closeIV.addTap {
            self.addedSubviewDelegate?.didClose()
        }
    }
    
    func toAddorRemoveFilters(istoadd: Bool, index: Int) {
        
        if istoadd {
            switch index {
                
            case 1,2:
              
                filtersCollectionHeight.constant = 60 + 10
                filtersViewHeight.constant = 130
                
            case 3:
                if !addedFilters.contains(.territory) {
                    addedFilters.append(.territory)
                    filtersCollectionHeight.constant = 60 + 60 + 10
                    filtersViewHeight.constant = 130 + 60
                }
            case 4:
        
                if !addedFilters.contains(.dcrClass) {
                    addedFilters.append(.dcrClass)
                    filtersCollectionHeight.constant = 60 + 60 + 10
                    filtersViewHeight.constant = 130 + 60
                }

            default:
                print("Yet to implement")
            }
            
            delegate?.isFiltersupdated(addedFilters.count, isItemAdded: istoadd)
            self.toLOadData()
        } else {
            
            switch index {
            case 2 :
                filtersCollectionHeight.constant = 60
                filtersViewHeight.constant = 130
                self.selectedterritory = nil
            case 3:
                filtersCollectionHeight.constant = 60 + 60 + 10
                filtersViewHeight.constant = 130 + 60
                self.selecteddocClass = nil
            default:
//                filtersCollectionHeight.constant = 60
//                filtersViewHeight.constant = 130
                print("Yet to implement")
            }
            
        addedFilters.remove(at: index)
  
        delegate?.isFiltersupdated(addedFilters.count, isItemAdded: istoadd)
        self.toLOadData()
        self.filtersCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
}
