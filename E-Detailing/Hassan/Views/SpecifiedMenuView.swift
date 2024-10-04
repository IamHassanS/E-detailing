//
//  SpecifiedMenuView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/02/24.
//

import Foundation
import UIKit
import CoreData

extension SpecifiedMenuView:UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle the text change
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string).lowercased()
            print("New text: \(newText)")

            switch self.cellType {
        
            case .workType, .WorkTypeInfo:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [WorkType]()
                filteredWorkType.removeAll()
                var isMatched = false
              workTypeArr?.forEach({ workType in
                    if workType.name!.lowercased().contains(newText) {
                        filteredWorkType.append(workType)
                        isMatched = true
                        
                    }
                })
                
                if newText.isEmpty {
                  //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    self.noresultsView.isHidden = true
                    //self.selectAllView.isHidden = true
                   // self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.workTypeArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            case .cluster, .clusterInfo:
                if newText.isEmpty && selectedClusterID.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [Territory]()
                filteredWorkType.removeAll()
                var isMatched = false
               clusterArr?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                if newText.isEmpty && selectedClusterID.isEmpty  {

                    self.noresultsView.isHidden = true

                    isSearched = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    if isMatched {
                        self.clusterArr = filteredWorkType
                        isSearched = true
                        self.noresultsView.isHidden = true
                        self.menuTable.isHidden = false
                        self.menuTable.reloadData()
                    } else if !selectedClusterID.isEmpty && !isMatched {
                        self.toLoadRequiredData()
                        toLOadData()
                    } else {
                        print("Not matched")
                        self.noresultsView.isHidden = false
                        isSearched = true
                        self.menuTable.isHidden = true
                    }
                }
  
            case .headQuater:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [Subordinate]()
                filteredWorkType.removeAll()
                var isMatched = false
                self.headQuatersArr?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true

                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.headQuatersArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
            case .jointCall:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [JointWork]()
                filteredWorkType.removeAll()
                var isMatched = false
              jointWorkArr?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                if newText.isEmpty {
             
                    self.noresultsView.isHidden = true

                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    jointWorkArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true

                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false

                    self.menuTable.isHidden = true
                }

            case .listedDoctor, .doctorInfo:
                if newText.isEmpty {
                    self.toLoadRequiredData(isfromTF: true)
                    toLOadData()
                }
                var filteredWorkType = [DoctorFencing]()
                filteredWorkType.removeAll()
                var isMatched = false
            listedDocArr?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        
                        isMatched = true
                    }
                })
                
                if newText.isEmpty {
        
                    self.noresultsView.isHidden = true
                    noresultsLbl.text = ""
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    listedDocArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    noresultsLbl.text = ""
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    noresultsLbl.text = "No results found"
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .competitors:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [Competitor]()
                filteredWorkType.removeAll()
                var isMatched = false
              competitorsArr?.forEach({ cluster in
                    if cluster.ourProductName!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {
                
                    self.noresultsView.isHidden = true

                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    competitorsArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }

            case .chemist, .chemistInfo:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [Chemist]()
                filteredWorkType.removeAll()
                var isMatched = false
              chemistArr?.forEach({ cluster in
                    if cluster.name!.lowercased().contains(newText) {
                        filteredWorkType.append(cluster)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {
                
                    self.noresultsView.isHidden = true

                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    chemistArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .stockist, .stockistInfo:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Stockist]()
                filteredWorkType.removeAll()
                var isMatched = false
  stockistArr?.forEach({ stockist in
                    if stockist.name!.lowercased().contains(newText) {
                        filteredWorkType.append(stockist)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                   stockistArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            case .unlistedDoctor, .unlistedDoctorinfo:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [UnListedDoctor]()
                filteredWorkType.removeAll()
                var isMatched = false
 unlisteedDocArr?.forEach({ newDocs in
                    if newDocs.name!.lowercased().contains(newText) {
                        filteredWorkType.append(newDocs)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    noresultsLbl.text = "No results found"
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                 unlisteedDocArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    noresultsLbl.text = ""
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    noresultsLbl.text = "No results found"
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            case .inputs:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Input]()
                filteredWorkType.removeAll()
                var isMatched = false
                inputsArr?.forEach({ input in
                    if input.name!.lowercased().contains(newText) {
                        filteredWorkType.append(input)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    inputsArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            case .product:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Product]()
                filteredWorkType.removeAll()
                var isMatched = false
                productArr?.forEach({ product in
                    if product.name!.lowercased().contains(newText) {
                        filteredWorkType.append(product)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    productArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
              
            case .doctorVisit:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [VisitControl]()
                filteredWorkType.removeAll()
                var isMatched = false
                visitControlArr?.forEach({ visit in
                    if visit.custName!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    visitControlArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .qualification:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Qualifications]()
                filteredWorkType.removeAll()
                var isMatched = false
                qualifications?.forEach({ visit in
                    if visit.name!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    qualifications = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .feedback:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Feedback]()
                filteredWorkType.removeAll()
                var isMatched = false
                feedback?.forEach({ visit in
                    if visit.name!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    feedback = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            case .speciality:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [Speciality]()
                filteredWorkType.removeAll()
                var isMatched = false
                speciality?.forEach({ visit in
                    if visit.name!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    speciality = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .category:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [DoctorCategory]()
                filteredWorkType.removeAll()
                var isMatched = false
                category?.forEach({ visit in
                    if visit.name!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    category = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .chemistCategory:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                }
                var filteredWorkType = [ChemistCategory]()
                filteredWorkType.removeAll()
                var isMatched = false
                chemistcategory?.forEach({ visit in
                    if visit.name!.lowercased().contains(newText) {
                        filteredWorkType.append(visit)
                        isMatched = true
                    }
                })

                
                if newText.isEmpty {

                    self.noresultsView.isHidden = true
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    chemistcategory = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .leave:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredLeaveType = [LeaveType]()
                filteredLeaveType.removeAll()
                var isMatched = false
              leaveArr?.forEach({ workType in
                    if workType.leaveName!.lowercased().contains(newText) {
                        filteredLeaveType.append(workType)
                        isMatched = true
                        
                    }
                })
                
                if newText.isEmpty {
                  //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    self.noresultsView.isHidden = true
                    //self.selectAllView.isHidden = true
                   // self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.leaveArr = filteredLeaveType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .doctorClass:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredDoctorClass = [DoctorClass]()
                filteredDoctorClass.removeAll()
                var isMatched = false
              doctorClassArr?.forEach({ workType in
                    if workType.doctorClassName!.lowercased().contains(newText) {
                        filteredDoctorClass.append(workType)
                        isMatched = true
                        
                    }
                })
                
                if newText.isEmpty {
                  //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    self.noresultsView.isHidden = true
                    //self.selectAllView.isHidden = true
                   // self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.doctorClassArr = filteredDoctorClass
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
            case .theraptic:
                if newText.isEmpty {
                    self.toLoadRequiredData()
                    toLOadData()
                }
                var filteredWorkType = [SlideTheraptic]()
                filteredWorkType.removeAll()
                var isMatched = false
              therapicArr?.forEach({ workType in
                    if workType.name!.lowercased().contains(newText) {
                        filteredWorkType.append(workType)
                        isMatched = true
                        
                    }
                })
                
                if newText.isEmpty {
                  //  self.sessionDetailsArr.sessionDetails?[self.selectedSession].workType = self.workTypeArr
                    self.noresultsView.isHidden = true
                    //self.selectAllView.isHidden = true
                   // self.selectAllHeightConst.constant = 0
                    isSearched = false
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else if isMatched {
                    self.therapicArr = filteredWorkType
                    isSearched = true
                    self.noresultsView.isHidden = true
                    self.menuTable.isHidden = false
                    self.menuTable.reloadData()
                } else {
                    print("Not matched")
                    self.noresultsView.isHidden = false
                    isSearched = false
                    self.menuTable.isHidden = true
                }
                
                
            default:
                print("Yet to implement")
            }
            // You can update your UI or perform other actions based on the filteredArray
        }

        return true
    }
}
 
extension SpecifiedMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellType {
    
        case .workType:
            return self.workTypeArr?.count ?? 0
        case .cluster:
            return self.clusterArr?.count ?? 0
            
        case .competitors:
            return self.competitorsArr?.count ?? 0
        case .headQuater:
            return self.headQuatersArr?.count ?? 0
        case .jointCall:
            return self.jointWorkArr?.count ?? 0
        case .listedDoctor:
           return self.listedDocArr?.count ?? 0
        case .chemist:
            return self.chemistArr?.count ?? 0
        case .stockist:
            print("Yet to omplement")
        case .unlistedDoctor:
            print("Yet to omplement")
        case .doctorInfo:
            return self.listedDocArr?.count ?? 0
            
        case .WorkTypeInfo:
            return self.workTypeArr?.count ?? 0
            
        case .theraptic:
            return self.therapicArr?.count ?? 0
        case .chemistInfo:
            return self.chemistArr?.count ?? 0
            
        case .stockistInfo:
            return self.stockistArr?.count ?? 0
        case .unlistedDoctorinfo:
            return self.unlisteedDocArr?.count ?? 0
            
        case .inputs:
            return self.inputsArr?.count ?? 0
        case .product:
            return self.productArr?.count ?? 0
        case .clusterInfo:
            return self.clusterArr?.count ?? 0
        case .doctorVisit:
            return self.visitControlArr?.count ?? 0
            
        case .qualification:
            return self.qualifications?.count ?? 0
            
        case .feedback:
            return self.feedback?.count ?? 0
        case .speciality:
            return self.speciality?.count ?? 0
        case.category:
            return self.category?.count ?? 0
        case.chemistCategory:
            return self.chemistcategory?.count ?? 0
        case .leave:
            return self.leaveArr?.count ?? 0
        case .doctorClass:
            return self.doctorClassArr?.count ?? 0
        default:
            print("Yet to implement")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellType {
    
        case .workType:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            titleLbl.text = "Select Worktype"
            let model =  self.workTypeArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            if self.selectedObject != nil {
               let doctorObj = self.selectedObject as! WorkType
                if doctorObj.id == model?.id {
                   // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    cell.lblName.textColor = .appGreen
                }
            } else {
                if self.isSearched {
                    if self.selectedSpecifiedTypeID ==  model?.code {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                } else {
                    if indexPath.row == self.selectecIndex {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                }
            }
            

            
   
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
//                if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
//                    if welf.specifiedMenuVC.selectedObject  == model {
//                        self?.toCreateToast("Two plan works for same day is restricted.")
//                        return
//                    }
//                }
                welf.selectedObject = model
                welf.specifiedMenuVC.selectedObject = model
                if welf.isSearched {
                    welf.selectedSpecifiedTypeID = model?.code ?? ""
               
                } else {
                    welf.selectecIndex = indexPath.row
                  
                }
               
              
              //  welf.specifiedMenuVC.menuDelegate?.selectedType(welf.cellType, selectedObject: model ?? Territory(), selectedObjects: [NSManagedObject]())
                welf.endEditing(true)
                welf.hideMenuAndDismiss()
            }
            return cell
            
        case .competitors:
            let cell: CompetitorsMultiselectionTVC = tableView.dequeueReusableCell(withIdentifier: "CompetitorsMultiselectionTVC", for: indexPath) as!  CompetitorsMultiselectionTVC
            cell.selectionStyle = .none
      
            titleLbl.text = "Select Competitors"
            let model =  self.competitorsArr?[indexPath.row]
            cell.competitorProduct.text = model?.compProductName ?? ""
            cell.competitorCompany.text = model?.compName ?? ""
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            self.competitorsArr?.forEach({ cluster in
                //  dump(cluster.code)
                selectedCompetitorID.forEach { id, isSelected in
                    if id == cluster.compProductSlNo {

                        if isSelected  {
                            if cluster.compProductName ==  cell.competitorProduct?.text {
                                cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                            }
                            
                        } else {
                            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        }
                    } else {
                    }
                }
            })

            cell.addTap { [weak self] in
                guard let welf = self else {return}
                 var selectedCompetitorID = welf.selectedCompetitorID
                
                if let _ = selectedCompetitorID[model?.compProductSlNo ?? ""] {

                    selectedCompetitorID[model?.compProductSlNo ?? ""] =
                        !(selectedCompetitorID[model?.compProductSlNo ?? ""] ?? false)

                    if selectedCompetitorID[model?.compProductSlNo ?? ""] == false {
                        selectedCompetitorID.removeValue(forKey: model?.compProductSlNo ?? "")
                    }

                } else {
                    selectedCompetitorID[model?.compProductSlNo ?? ""] = true
                }
                
                welf.selectedCompetitorID = selectedCompetitorID
                tableView.reloadData()
            }
            return cell
            
            
            
            
        case .cluster:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            cell.setCheckBox(isToset: true)
            titleLbl.text = "Select \(LocalStorage.shared.getString(key: .cluster))"
            let model =  self.clusterArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            
            self.clusterArr?.forEach({ cluster in
                //  dump(cluster.code)
                selectedClusterID.forEach { id, isSelected in
                    if id == cluster.code {

                        if isSelected  {
                            if cluster.name ==  cell.lblName?.text {
                                cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                            }
                            
                        } else {
                            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        }
                    } else {
                    }
                }
            })

            cell.addTap { [weak self] in
                guard let welf = self else {return}
                 var selectedClusterID = welf.selectedClusterID
                
                if let _ = selectedClusterID[model?.code ?? ""] {

                    selectedClusterID[model?.code ?? ""] =
                        !(selectedClusterID[model?.code ?? ""] ?? false)

                    if selectedClusterID[model?.code ?? ""] == false {
                        selectedClusterID.removeValue(forKey: model?.code ?? "")
                    }

                } else {
                    selectedClusterID[model?.code ?? ""] = true
                }
                
                welf.selectedClusterID = selectedClusterID
                tableView.reloadData()
            }
            return cell
            
        case .headQuater:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            print("Yet to omplement")
            
            titleLbl.text = "Select HQ"
            let model =  self.headQuatersArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            if self.previouslySelectdObj != nil {
                let doctorObj = self.previouslySelectdObj as! Subordinate
                 if doctorObj.id == model?.id {
                    // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                     cell.lblName.textColor = .appLightGrey
                 }
            }
            
            if self.selectedObject != nil {
               let doctorObj = self.selectedObject as! Subordinate
                if doctorObj.id == model?.id {
                   // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    if specifiedMenuVC.isFromMasterSync  {
                        cell.lblName.textColor = .appGreen
                    }
               
                }
            } else {
                if self.isSearched {
                    if self.selectedSpecifiedTypeID ==  model?.id {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                } else {
                    if indexPath.row == self.selectecIndex {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                }
            }
            

            
   
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedObject = model
                if welf.specifiedMenuVC.previousselectedObj != nil {
                    if  (welf.specifiedMenuVC.previousselectedObj as! Subordinate).id ==   (welf.selectedObject as! Subordinate).id {
                        welf.toCreateToast("Please select diffent HQ")
                        return
                    }
                }

                welf.specifiedMenuVC.selectedObject = model
                if welf.isSearched {
                    welf.selectedSpecifiedTypeID = model?.id ?? ""
               
                } else {
                    welf.selectecIndex = indexPath.row
                  
                }

                welf.endEditing(true)
                welf.hideMenuAndDismiss()
            }
            
            return cell
        case .jointCall:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            cell.setCheckBox(isToset: true)
            titleLbl.text = "Select Joint work"
            let model =  self.jointWorkArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            
            self.jointWorkArr?.forEach({ cluster in
                //  dump(cluster.code)
                selectedJwID.forEach { id, isSelected in
                    if id == cluster.code {

                        if isSelected  {
                            if cluster.name ==  cell.lblName?.text {
                                cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                            }
                            
                        } else {
                            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        }
                    } else {
                    }
                }
            })

            cell.addTap { [weak self] in
                guard let welf = self else {return}
                 var selectedClusterID = welf.selectedJwID
                
                if let _ = selectedClusterID[model?.code ?? ""] {

                    selectedClusterID[model?.code ?? ""] =
                        !(selectedClusterID[model?.code ?? ""] ?? false)

                    if selectedClusterID[model?.code ?? ""] == false {
                        selectedClusterID.removeValue(forKey: model?.code ?? "")
                    }

                } else {
                    selectedClusterID[model?.code ?? ""] = true
                }
                
                welf.selectedJwID = selectedClusterID
                tableView.reloadData()
            }
            return cell

        case .listedDoctor:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            titleLbl.text = "Select Doctor"
            let model =  self.listedDocArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
            cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            if self.selectedObject != nil {
               let doctorObj = self.selectedObject as! DoctorFencing
                if doctorObj.code == model?.code {
                   // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    cell.lblName.textColor = .appGreen
                }
            } else {
                if self.isSearched {
                    if self.selectedSpecifiedTypeID ==  model?.code {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                } else {
                    if indexPath.row == self.selectecIndex {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                }
            }
            

            
   
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedObject = model
                welf.specifiedMenuVC.selectedObject = model
                if welf.isSearched {
                    welf.selectedSpecifiedTypeID = model?.code ?? ""
               
                } else {
                    welf.selectecIndex = indexPath.row
                  
                }

              
                welf.specifiedMenuVC.menuDelegate?.selectedType(welf.cellType, selectedObject: model ?? DoctorFencing(), selectedObjects: [NSManagedObject]())
                welf.endEditing(true)
                welf.hideMenuAndDismiss()
            }
            return cell
        case .chemist:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            titleLbl.text = "Select Chemist"
            let model =  self.chemistArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            if self.selectedObject != nil {
               let doctorObj = self.selectedObject as! Chemist
                if doctorObj.id == model?.id {
                   // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    cell.lblName.textColor = .appGreen
                }
            } else {
                if self.isSearched {
                    if self.selectedSpecifiedTypeID ==  model?.code {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                } else {
                    if indexPath.row == self.selectecIndex {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                }
            }
            

            
   
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
                welf.selectedObject = model
                welf.specifiedMenuVC.selectedObject = model
                if welf.isSearched {
                    welf.selectedSpecifiedTypeID = model?.code ?? ""
               
                } else {
                    welf.selectecIndex = indexPath.row
                  
                }
               
              
                welf.specifiedMenuVC.menuDelegate?.selectedType(welf.cellType, selectedObject: model ?? Chemist(), selectedObjects: [NSManagedObject]())
                welf.endEditing(true)
                welf.hideMenuAndDismiss()
            }
            return cell
        case .stockist:
            print("Yet to omplement")
        case .unlistedDoctor:
            print("Yet to omplement")
        case .doctorInfo:
            let resourcecell: resourceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "resourceInfoTVC", for: indexPath) as!  resourceInfoTVC
            resourcecell.selectionStyle = .none
            titleLbl.text = "Listed Doctors"
            var yetTopassModal: NSManagedObject?
            if let modelArr = self.listedDocArr {
                let model: DoctorFencing = modelArr[indexPath.row]
                yetTopassModal = model
                resourcecell.populateCell(model: model)
                resourcecell.setupHeight(type: cellType)
            }
            resourcecell.countLbl.text = "\(indexPath.row + 1)."
            resourcecell.btnEdit.addTap { [weak self] in
                guard let welf = self else {return}
                
              
                    welf.navigateToDetails(type: .doctor, model: yetTopassModal ?? NSManagedObject())
                
                
  
            }
          
            return resourcecell
            
        case .WorkTypeInfo:
            let resourcecell: resourceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "resourceInfoTVC", for: indexPath) as!  resourceInfoTVC
            resourcecell.selectionStyle = .none
            titleLbl.text = "Work type"
            var yetTopassModal: NSManagedObject?
            if let modelArr = self.workTypeArr {
                let model: WorkType = modelArr[indexPath.row]
                yetTopassModal = model
                resourcecell.populateCell(model: model)
                resourcecell.setupHeight(type: cellType)
            }
            resourcecell.countLbl.text = "\(indexPath.row + 1)."
            resourcecell.btnEdit.addTap { [weak self] in
                guard let welf = self else {return}
                
              
                    welf.navigateToDetails(type: .chemist, model: yetTopassModal ?? NSManagedObject())
                
                
              
            }
          
            return resourcecell
            
        case .theraptic:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            cell.selectionStyle = .none
            titleLbl.text = "Select Worktype"
            let model =  self.therapicArr?[indexPath.row]
            cell.lblName.text = model?.name
            cell.lblName.textColor = .appTextColor
            cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
            
         //   cell.setupUI(model: model ?? DoctorFencing(), isForspecialty: self.previewType != nil)
            
            if self.selectedObject != nil {
               let doctorObj = self.selectedObject as! WorkType
                if doctorObj.id == model?.id {
                   // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                    cell.lblName.textColor = .appGreen
                }
            } else {
                if self.isSearched {
                    if self.selectedSpecifiedTypeID ==  model?.code {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                      //  cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                } else {
                    if indexPath.row == self.selectecIndex {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxSelected")
                        cell.lblName.textColor = .appGreen
                    } else {
                       // cell.menuIcon?.image = UIImage(named: "checkBoxEmpty")
                        cell.lblName.textColor = .appTextColor
                    }
                }
            }
            

            
   
            
            cell.addTap { [weak self] in
                guard let welf = self else {return}
//                if !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isMR) {
//                    if welf.specifiedMenuVC.selectedObject  == model {
//                        self?.toCreateToast("Two plan works for same day is restricted.")
//                        return
//                    }
//                }
                welf.selectedObject = model
                welf.specifiedMenuVC.selectedObject = model
                if welf.isSearched {
                    welf.selectedSpecifiedTypeID = model?.code ?? ""
               
                } else {
                    welf.selectecIndex = indexPath.row
                  
                }
               
              
              //  welf.specifiedMenuVC.menuDelegate?.selectedType(welf.cellType, selectedObject: model ?? Territory(), selectedObjects: [NSManagedObject]())
                welf.endEditing(true)
                welf.hideMenuAndDismiss()
            }
            return cell
            
        case .chemistInfo:
            let resourcecell: resourceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "resourceInfoTVC", for: indexPath) as!  resourceInfoTVC
            resourcecell.selectionStyle = .none
            titleLbl.text = "Chemists"
            var yetTopassModal: NSManagedObject?
            if let modelArr = self.chemistArr {
                let model: Chemist = modelArr[indexPath.row]
                yetTopassModal = model
                resourcecell.populateCell(model: model)
                resourcecell.setupHeight(type: cellType)
            }
            resourcecell.countLbl.text = "\(indexPath.row + 1)."
            resourcecell.btnEdit.addTap { [weak self] in
                guard let welf = self else {return}
                
              
                    welf.navigateToDetails(type: .chemist, model: yetTopassModal ?? NSManagedObject())
                
                
              
            }
          
            return resourcecell
            
            
        case .stockistInfo:
            let resourcecell: resourceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "resourceInfoTVC", for: indexPath) as!  resourceInfoTVC
            resourcecell.selectionStyle = .none
            titleLbl.text = "Stockists"
            var yetTopassModal: NSManagedObject?
            if let modelArr = self.stockistArr {
                let model: Stockist = modelArr[indexPath.row]
                yetTopassModal = model
                resourcecell.populateCell(model: model)
                resourcecell.setupHeight(type: cellType)
            }
            resourcecell.countLbl.text = "\(indexPath.row + 1)."
            resourcecell.btnEdit.addTap { [weak self] in
                guard let welf = self else {return}
             
                    welf.navigateToDetails(type: .stockist, model: yetTopassModal ?? NSManagedObject())
                
            }
          
            return resourcecell
            
        case .unlistedDoctorinfo:
            let resourcecell: resourceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "resourceInfoTVC", for: indexPath) as!  resourceInfoTVC
            resourcecell.selectionStyle = .none
            titleLbl.text = "Unlisted Doctors"
            var yetTopassModal: NSManagedObject?
            if let modelArr = self.unlisteedDocArr {
                let model: UnListedDoctor = modelArr[indexPath.row]
                yetTopassModal = model
                resourcecell.populateCell(model: model)
                resourcecell.setupHeight(type: cellType)
            }
            resourcecell.countLbl.text = "\(indexPath.row + 1)."
            resourcecell.btnEdit.addTap { [weak self] in
                guard let welf = self else {return}
           
                    welf.navigateToDetails(type: .unlistedDoctor, model: yetTopassModal ?? NSManagedObject())
                
            }
          
            return resourcecell
            
            
        case .inputs:
            let cell: CommonResouceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "CommonResouceInfoTVC", for: indexPath) as!  CommonResouceInfoTVC
            titleLbl.text = "Inputs"
            cell.selectionStyle = .none
   
            cell.itemCountLbl.text = "\(indexPath.row + 1)."
            
            if let modelArr = self.inputsArr {
                let model: Input = modelArr[indexPath.row]
                cell.populateCell(model: model)
                cell.setupHeight(type: cellType)
            }
            
            
         
            return cell
            
        case .product:
            let cell: CommonResouceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "CommonResouceInfoTVC", for: indexPath) as!  CommonResouceInfoTVC
            titleLbl.text = "Product"
            cell.selectionStyle = .none
            var yetTosendModel: NSManagedObject?
           cell.itemCountLbl.text = "\(indexPath.row + 1)."
            
            if let modelArr = self.productArr {
                let model: Product = modelArr[indexPath.row]
                yetTosendModel = model
                cell.populateCell(model: model)
                cell.setupHeight(type: cellType)
            }
            
            if specifiedMenuVC.isFromfilter {
                
                
                cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(self.cellType, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            }
            
            return cell
            
        case .clusterInfo:
            let cell: CommonResouceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "CommonResouceInfoTVC", for: indexPath) as!  CommonResouceInfoTVC
            titleLbl.text = "Cluster"
            cell.selectionStyle = .none
            var yetTosendModel: NSManagedObject?
           cell.itemCountLbl.text = "\(indexPath.row + 1)."
       
            if let modelArr = self.clusterArr {
                let model: Territory = modelArr[indexPath.row]
                yetTosendModel = model
                cell.populateCell(model: model)
                cell.setupHeight(type: cellType)
            }
            
            if specifiedMenuVC.isFromfilter {
                
                cell.itemCountLbl.isHidden = true
                cell.itemNameLBl.setFont(font: .medium(size: .BODY))
                
                cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.speciality, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            }
            
            
            return cell
            
            
            
            
            
        case .doctorVisit:
            let cell: CommonResouceInfoTVC = tableView.dequeueReusableCell(withIdentifier: "CommonResouceInfoTVC", for: indexPath) as!  CommonResouceInfoTVC
            titleLbl.text = "Doctor Visit"
            cell.selectionStyle = .none

           cell.itemCountLbl.text = "\(indexPath.row + 1)."
            
            if let modelArr = self.visitControlArr {
                let model: VisitControl = modelArr[indexPath.row]
                cell.populateCell(model: model)
                cell.setupHeight(type: cellType)
            }
            return cell
            
            
        case .speciality:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            titleLbl.text = "Speciality"
            cell.selectionStyle = .none
            var yetTosendModel: NSManagedObject?
             if let modelArr = self.speciality {
                 let model: Speciality = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
           
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.speciality, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
            
            
        case .qualification:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            titleLbl.text = "Qualification"
            cell.selectionStyle = .none
        
            var yetTosendModel: NSManagedObject?
             if let modelArr = self.qualifications {
                 let model: Qualifications = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
              //   cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.qualification, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
            
        case .feedback:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            titleLbl.text = "Feedback"
            cell.selectionStyle = .none
        
            var yetTosendModel: NSManagedObject?
             if let modelArr = self.feedback {
                 let model: Feedback = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
              //   cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.feedback, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
        case .category:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            titleLbl.text = "Category"
            cell.selectionStyle = .none
           
            var yetTosendModel: NSManagedObject?
             if let modelArr = self.category {
                 let model: DoctorCategory = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
                // cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.category, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
            
        case .chemistCategory:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
            titleLbl.text = "Category"
            cell.selectionStyle = .none
           
            var yetTosendModel: NSManagedObject?
             if let modelArr = self.chemistcategory {
                 let model: ChemistCategory = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
                // cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.chemistCategory, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
            
            
        case .leave:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
           
            cell.selectionStyle = .none
           
            var yetTosendModel: NSManagedObject?
            if let modelArr = self.leaveArr, !modelArr.isEmpty {
                 let model: LeaveType = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
                // cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.leave, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
            
        case .doctorClass:
            let cell: SpecifiedMenuTCell = tableView.dequeueReusableCell(withIdentifier: "SpecifiedMenuTCell", for: indexPath) as!  SpecifiedMenuTCell
           
            cell.selectionStyle = .none
           
            var yetTosendModel: NSManagedObject?
            if let modelArr = self.doctorClassArr, !modelArr.isEmpty {
                 let model: DoctorClass = modelArr[indexPath.row]
                 yetTosendModel = model
                 cell.populateCell(model: model)
                // cell.setupHeight(type: cellType)
             }
            
            cell.addTap {
                self.specifiedMenuVC.menuDelegate?.selectedType(.doctorClass, selectedObject: yetTosendModel ?? NSManagedObject(), selectedObjects: [NSManagedObject]())
                self.hideMenuAndDismiss()
            }
            
            return cell
        default:
            print("Yet to implement")
        }
        
        return UITableViewCell()
    }
    
    func navigateToDetails(type: DCRdetailViewEditVC.EditTypes, model: NSManagedObject) {
        let vc  = DCRdetailViewEditVC.initWithStory(type: type, model: model)
        vc.view.backgroundColor = .appGreyColor
        specifiedMenuVC.presentInFullScreen(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellType {
            

        case .doctorInfo, .unlistedDoctorinfo:
            return 110
         
        case  .stockistInfo, .chemistInfo, .WorkTypeInfo:
            
            return 110 - 33.3
            
        case .product, .doctorVisit, .inputs:
            
            return 60 + 10
            
        case  .clusterInfo, .speciality, .qualification, .category, .theraptic, .chemistCategory:
            
            return 30 + 10
        case .competitors:
            return 60
            
        default:
            return UITableView.automaticDimension
        }
    }
    
}

class SpecifiedMenuView: BaseView {
    
    @IBOutlet var saveLbl: UILabel!
    
    @IBOutlet var clearLbl: UILabel!
    
    @IBOutlet var clearView: UIView!
    
    @IBOutlet var bottomHolderHeight: NSLayoutConstraint!
    @IBOutlet var bottomContentsView: UIView!
    @IBOutlet weak var sideMenuHolderView : UIView!
    @IBOutlet weak var menuTable : UITableView!
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var closeTapView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet var clearTFView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var searchHolderVIew: UIView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var noresultsView: UIView!
    
    @IBOutlet var noresultsLbl: UILabel!
    
    @IBOutlet var rejectionTitle: UILabel!
    @IBOutlet var rejectionReason: UILabel!
    @IBOutlet var rejectionVIew: UIView!
    
    @IBOutlet var addCompetitorsVIew: UIView!
    
    @IBOutlet var addCompetitorsIV: UIImageView!
    
    @IBOutlet var searchStackTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var backgroundView: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedSpecifiedTypeID : String = ""
    var cellType : MenuView.CellType = .listedDoctor
    var specifiedMenuVC :  SpecifiedMenuVC!
    var addCompetitorsSubiew: AddCompetitorsView?
    
    var workTypeArr : [WorkType]?
    var headQuatersArr : [Subordinate]?
    var clusterArr : [Territory]?
    var jointWorkArr : [JointWork]?
    var listedDocArr : [DoctorFencing]?
    var chemistArr : [Chemist]?
    var stockistArr : [Stockist]?
    var unlisteedDocArr : [UnListedDoctor]?
    var filteredTerritories: [Territory]?
    var filteredCompetitors: [Competitor]?
    var filteredClass : [DoctorClass]?
    var filteredTherapic: [SlideTheraptic]?
    var filteredLeave : [LeaveType]?
    var filteredJfw: [JointWork]?
    var inputsArr: [Input]?
    var productArr: [Product]?
    var visitControlArr : [VisitControl]?
    var category: [DoctorCategory]?
    var chemistcategory: [ChemistCategory]?
    var speciality: [Speciality]?
    var qualifications: [Qualifications]?
    var feedback : [Feedback]?
    var competitorsArr : [Competitor]?
    var doctorClassArr : [DoctorClass]?
    var leaveArr: [LeaveType]?
    var therapicArr: [SlideTheraptic]?
    var selectecIndex: Int? = nil
    var isSearched: Bool = false
    var selectedObject: NSManagedObject?
    var previouslySelectdObj: NSManagedObject?
    var selectedCode: Int?
    var previewType: String?
    var selectedClusterID = [String: Bool]()
    var selectedLeaveID = [String: Bool]()
    var selectedClassID = [String: Bool]()
    var selectedTherapicID = [String: Bool]()
    var selectedJwID = [String: Bool]()
    var selectedCompetitorID = [String: Bool]()
    var isRejected = Bool()
    //MARK: UDF, gestures  and animations
    var restrictedIndex: Int? = nil
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    
//    enum CellType {
//
//        case workType
//        case cluster
//        case headQuater
//        case jointCall
//        case listedDoctor
//        case chemist
//        case stockist
//        case unlistedDoctor
//
//    }
    
    //MARK: - life cycle
    override func didLoad(baseVC: BaseViewController) {
        self.specifiedMenuVC = baseVC as? SpecifiedMenuVC
        //self.initView()
        //self.initGestures()
       // self.ThemeUpdate()
       // setTheme()
        self.cellType = specifiedMenuVC.celltype
        self.showMenu()
        initGestures()
        setupUI()
        cellRegistration()
        toLoadRequiredData()
    }
    
    override func didLayoutSubviews(baseVC: BaseViewController) {
        super.didLayoutSubviews(baseVC: baseVC)
        
        let changePasswordViewwidth = self.bounds.width / 2.7
        let changePasswordViewheight = self.bounds.height / 1.7
        
        let changePasswordViewcenterX = self.bounds.midX - (changePasswordViewwidth / 2)
        let changePasswordViewcenterY = self.bounds.midY - (changePasswordViewheight / 2)
        
        self.addCompetitorsSubiew?.frame = CGRect(x: changePasswordViewcenterX, y: changePasswordViewcenterY, width: changePasswordViewwidth, height: changePasswordViewheight)
        
    }
    
    func addCompetitorsAction() {
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case addCompetitorsSubiew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
            default:
                
                print("Yet to implement")
                aAddedView.isUserInteractionEnabled = false
                
                
            }
            
        }
        
        addCompetitorsSubiew = self.specifiedMenuVC.loadCustomView(nibname: XIBs.addCompetitorsVIew) as? AddCompetitorsView
        addCompetitorsSubiew?.delegate = self
        
       
        addCompetitorsSubiew?.setupUI()
        self.addSubview(addCompetitorsSubiew ?? AddCompetitorsView())
    }

    
    func setupUI() {
        backgroundView.isHidden = true
        searchStackTrailingConstraint.constant = 5
        addCompetitorsVIew.isHidden = true
        addCompetitorsIV.tintColor = .appGreen
        saveLbl.setFont(font: .bold(size: .BODY))
        clearLbl.setFont(font: .bold(size: .BODY))
        saveView.layer.cornerRadius = 5
        saveView.backgroundColor = .appTextColor
        noresultsView.isHidden = true
        clearView.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        clearView.layer.cornerRadius = 5
        clearView.layer.borderColor = UIColor.appTextColor.cgColor
        clearView.layer.borderWidth = 1
       
        
        
        menuTable.separatorStyle = .singleLine
        self.titleLbl.setFont(font: .bold(size:  .BODY))
        self.titleLbl.textColor = .appTextColor
        searchTF.delegate = self
        searchTF.font = UIFont(name: "Satoshi-Bold", size: 14)
        self.searchTF.text = ""
        self.searchTF.placeholder = "Search"
        searchHolderVIew.layer.borderWidth = 1
        searchHolderVIew.layer.borderColor = UIColor.appTextColor.cgColor
        searchHolderVIew.layer.cornerRadius = 5
    }
    
    func initGestures() {
        
        backgroundView.addTap {
            self.didClose()
        }
        
        addCompetitorsVIew.addTap {
            self.addCompetitorsAction()
        }
        
        clearView.addTap {
            
            self.specifiedMenuVC.selectedCompetitorsID = nil
            self.selectedCompetitorID = [String: Bool]()
            
            self.specifiedMenuVC.selectedClusterID = nil
            
            self.selectedClusterID = [String: Bool]()
            
            
            self.specifiedMenuVC.selectedJwID = [String: Bool]()
            
          //  self.filteredJfw = nil
            self.selectedJwID = [String: Bool]()
            
            self.menuTable.reloadData()
            
            
           
        }
        
        saveView.addTap { [weak self] in
            
            guard let welf = self else {return}
           
            
            welf.hideMenuAndDismiss()
        }
        
        clearTFView.addTap { [weak self] in
            guard let welf = self else {return}
            welf.selectedObject = nil
            welf.selectecIndex = nil
            welf.searchTF.text = ""
            welf.isSearched = false
            welf.endEditing(true)
            welf.toLoadRequiredData(isfromTF: true)
            welf.toLOadData()
        }
        
        closeTapView.addTap { [weak self] in
            guard let welf = self else {return}
            let rtlValue : CGFloat = 1
            let width = welf.width
            welf.hideAnimation(width: width, rtlValue: rtlValue)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
    
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
        let rtlValue : CGFloat = 1
        //isRTL ? 1 :
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
        //        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
        case .began,.changed:
            guard  ( xMovement > 0)  else {return}
          //  ||  (xMovement < 0)
           // isRTL && || !isRTL &&
            
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        default:
            let velocity = gesture.velocity(in: self.sideMenuHolderView).x
            self.animationDuration = Double(velocity)
            if abs(xMovement) <= self.frame.width * 0.25{//show
                self.sideMenuHolderView.transform = .identity
                self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
            }else{//hide
                
                self.hideAnimation(width: width, rtlValue: rtlValue)
          
            }
            
        }
    }
    
    func showMenu(){
       // let isRTL = isRTLLanguage
        let _ : CGFloat =  -1
        //isRTL ? 1 :
        let width = self.frame.width
        self.sideMenuHolderView.transform =  CGAffineTransform(translationX: width,y: 1)
        //isRTL ? CGAffineTransform(translationX: 1 * width,y: 0)  :
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = .identity
                        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
                       }, completion: nil)
    }
    
    func hideMenuAndDismiss(type: MenuView.CellType? = nil , index: Int? = nil){
       
        let rtlValue : CGFloat = 1
      //  isRTL ? 1 :
        let width = self.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        
     filteredTerritories = clusterArr?.filter { territory in
            guard let code = territory.code else {
                return false
            }
            return selectedClusterID[code] == true
        }
        

  
        filteredCompetitors = competitorsArr?.filter { territory in
            guard let code = territory.compProductSlNo else {
                return false
            }
            return selectedCompetitorID[code] == true
        }
        
        filteredTherapic = therapicArr?.filter { territory in
            guard let code = territory.code else {
                return false
            }
            return selectedTherapicID[code] == true
        }
        
        
       filteredLeave = leaveArr?.filter { leave in
            guard let code = leave.leaveCode else {
                return false
            }
            return selectedLeaveID[code] == true
        }
        
        filteredClass = doctorClassArr?.filter { leave in
             guard let code = leave.code else {
                 return false
             }
             return selectedClassID[code] == true
         }
        
        filteredJfw = jointWorkArr?.filter { territory in
                  guard let code = territory.code else {
                      return false
                  }
                return selectedJwID[code] == true
              }

            
            guard let selectedHqentity = NSEntityDescription.entity(forEntityName: "Subordinate", in: context),
                  let selectedWTentity = NSEntityDescription.entity(forEntityName: "WorkType", in: context),
                  let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context),
                  let selectedCompetitorentity = NSEntityDescription.entity(forEntityName: "Competitor", in: context),
                    let selectedJointWorkentity = NSEntityDescription.entity(forEntityName: "JointWork", in: context),
                    let selectedTherapicentity = NSEntityDescription.entity(forEntityName: "SlideTheraptic", in: context)
            else {
                fatalError("Entity not found")
            }
            
            
            let temporaryselectedSubordinateobj = NSManagedObject(entity: selectedHqentity, insertInto: nil)  as! Subordinate
            let temporaryselectedWTobj = NSManagedObject(entity: selectedWTentity, insertInto: nil)  as! WorkType
            let temporaryselectedClusterobj = NSManagedObject(entity: selectedClusterentity, insertInto: nil)  as! Territory
            let temporaryselectedCompetitorsobj = NSManagedObject(entity: selectedCompetitorentity, insertInto: nil)  as! Competitor
        let temporaryselectedJointWorkobj = NSManagedObject(entity: selectedJointWorkentity, insertInto: nil)  as! JointWork
        let temporaryselectedTherapticobj = NSManagedObject(entity: selectedTherapicentity, insertInto: nil)  as! SlideTheraptic
   
            switch cellType {
                
//            case .cluster:
//                  specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: model ?? Territory(), selectedObjects: [NSManagedObject]())
                
            case .headQuater:
                
                if selectedSpecifiedTypeID == "" &&  selectecIndex  == nil {
                    hideAnimation(width: width, rtlValue: rtlValue)
                    return
                }
               
                
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedSubordinateobj, selectedObjects: [temporaryselectedClusterobj])
            case .cluster:
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedClusterobj, selectedObjects: filteredTerritories ?? [temporaryselectedClusterobj])
                
            case .workType:
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedWTobj, selectedObjects: [temporaryselectedClusterobj])
                
            case .competitors:
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedCompetitorsobj, selectedObjects: filteredCompetitors ?? [temporaryselectedCompetitorsobj])
                
            case .jointCall:
                
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedJointWorkobj, selectedObjects: filteredJfw ?? [temporaryselectedJointWorkobj])
                
            case .theraptic:
                specifiedMenuVC.menuDelegate?.selectedType(cellType, selectedObject: specifiedMenuVC.selectedObject ?? temporaryselectedJointWorkobj, selectedObjects: filteredTherapic ?? [temporaryselectedTherapticobj])
                
            default:
                print("Yet to implement")
            }
        
        hideAnimation(width: width, rtlValue: rtlValue)

        
        
    }
    
    func hideAnimation(width: CGFloat, rtlValue: CGFloat) {
        self.specifiedMenuVC.dismiss(animated: false)
//        UIView.animate(withDuration: animationDuration,
//                       delay: aniamteionWaitTime,
//                       usingSpringWithDamping: animationDampning,
//                       initialSpringVelocity: animationVelocity,
//                       options: [.curveEaseOut,.allowUserInteraction],
//                       animations: {
//                        self.sideMenuHolderView.transform = CGAffineTransform(translationX: width * rtlValue,
//                                                                              y: 0)
//                        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//                       }) { (val) in
//            
//                           self.specifiedMenuVC.dismiss(animated: true)
//        }
    }
    
    func toLOadData() {
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.reloadData()
    }
    
    func toLoadRequiredData(isfromTF: Bool? = false) {
        var selectedIndex : Int?
      if  self.selectedClusterID.isEmpty {
          self.selectedClusterID = specifiedMenuVC.selectedClusterID ?? [String: Bool]()
      } 
        //
      
       switch self.cellType {
         
           
       case .category:
           bottomHolderHeight.constant = 0
           category = DBManager.shared.getCategory()
           
       case .chemistCategory:
           bottomHolderHeight.constant = 0
           chemistcategory = DBManager.shared.getChemistCategory()
           
       case .speciality:
           bottomHolderHeight.constant = 0
          speciality = DBManager.shared.getSpeciality()
       case . qualification:
           bottomHolderHeight.constant = 0
           qualifications =  DBManager.shared.getQualification()
       case .feedback:
           bottomHolderHeight.constant = 0
           feedback =  DBManager.shared.getFeedback()
      
       case .inputs:
           searchTF.placeholder = "Search Input name"
           bottomHolderHeight.constant = 0
           self.inputsArr = DBManager.shared.getInput()
           inputsArr = inputsArr?.filter {$0.code != "-1"}
           
           self.inputsArr = self.inputsArr?.sorted(by: { $0.name ?? "" < $1.name ?? "" })
           
       case . product:
           searchTF.placeholder = "Search Product name"
           bottomHolderHeight.constant = 0
           self.productArr = DBManager.shared.getProduct()
           
           if specifiedMenuVC.previousselectedObj != nil {
               self.previouslySelectdObj = specifiedMenuVC.previousselectedObj as! Product
               let docObj =  self.previouslySelectdObj as! Product
               self.productArr?.enumerated().forEach({ index, chemist in
                   if chemist.id  == docObj.id {
                       selectedIndex = index
                   }
               })
              
      
           }
           
       case . doctorVisit:
           bottomHolderHeight.constant = 0
           self.visitControlArr = DBManager.shared.getVisitControl()
           
       case .workType:
           bottomHolderHeight.constant = 0
           self.workTypeArr = DBManager.shared.getWorkType()
           if specifiedMenuVC.selectedObject != nil {
               let docObj  = specifiedMenuVC.selectedObject as! WorkType
               self.workTypeArr?.enumerated().forEach({ index, doctor in
                   if doctor.code  == docObj.code {
                       self.workTypeArr?.remove(at: index)
                   }
               })
           }
//           if specifiedMenuVC.selectedObject != nil {
//               self.selectedObject = specifiedMenuVC.selectedObject as! WorkType
//               let docObj =  self.selectedObject as! WorkType
//               if !(isfromTF ?? false) {
//                   self.searchTF.text = docObj.name
//               }
//              
//               self.listedDocArr?.enumerated().forEach({ index, doctor in
//                   if doctor.id  == docObj.id {
//                       selectedIndex = index
//                   }
//               })
//
//           }
           
       case .WorkTypeInfo:
           searchTF.placeholder = "Search Work type name"
           bottomHolderHeight.constant = 0
           self.workTypeArr = DBManager.shared.getWorkType()
           
           self.workTypeArr = self.workTypeArr?.sorted(by: { $0.name ?? "" < $1.name ?? "" })
       case .clusterInfo:
           searchTF.placeholder = "Search Cluster name"
           bottomHolderHeight.constant = 0
           self.clusterArr = DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
           
       case .leave:
           titleLbl.text = "Select leave type"
           bottomHolderHeight.constant = 0
           self.leaveArr = DBManager.shared.getLeaveType()
           
       case .doctorClass:
           titleLbl.text = "Select Class"
           bottomHolderHeight.constant = 0
           self.doctorClassArr = DBManager.shared.getDoctorClass()
           
       case .theraptic:
           titleLbl.text = "Select Therapic type"
           bottomHolderHeight.constant = 0
           self.therapicArr = DBManager.shared.getSlideTheraptic()
           
           
       case .competitors:
           searchStackTrailingConstraint.constant = 30
           addCompetitorsVIew.isHidden = false
           bottomHolderHeight.constant = 80
           var tempCompetitor: [MapCompDet] = []
           var mappedCompetitor = [Competitor]()
           let competitorArr  =  DBManager.shared.getMapCompDet()
           if let product = self.specifiedMenuVC.selectedObject as? Product {
               
               tempCompetitor = competitorArr.filter {$0.ourProductCode == product.code}
               tempCompetitor.forEach { aMapCompDet in
                  let parstedArr = parseCompetitors(from: aMapCompDet.competitorProductBulk ?? "", ourProductCode:  product.code ?? "" , ourProductName: product.name ?? "")
                   mappedCompetitor.append(contentsOf: parstedArr)
               }
           }

       
    
           self.competitorsArr = mappedCompetitor
       case .cluster:
           searchTF.placeholder = "Search Cluster name"
           bottomHolderHeight.constant = 80
           self.clusterArr = DBManager.shared.getTerritory(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
           if specifiedMenuVC.selectedObject != nil {
               self.selectedObject = specifiedMenuVC.selectedObject as! Territory
               let docObj =  self.selectedObject as! Territory
               if !(isfromTF ?? false) {
                   self.searchTF.text = docObj.name
               }
              
               self.clusterArr?.enumerated().forEach({ index, doctor in
                   if doctor.id  == docObj.id {
                       selectedIndex = index
                   }
               })
              
      
           }
           
          // self.clusterArr = self.clusterArr?.sorted(by: { $0.name ?? "" < $1.name ?? "" })
       case .headQuater:
           bottomHolderHeight.constant = 0
           self.headQuatersArr =  DBManager.shared.getSubordinate()
           if specifiedMenuVC.selectedObject != nil {
               self.selectedObject = specifiedMenuVC.selectedObject as! Subordinate
               let docObj =  self.selectedObject as! Subordinate
               if !(isfromTF ?? false) {
                   if specifiedMenuVC.isFromMasterSync  {
                       self.searchTF.text = docObj.name
                   }
                  
               }
              
               self.headQuatersArr?.enumerated().forEach({ index, doctor in
                   if doctor.id  == docObj.id {
                       restrictedIndex = index
                   }
               })
              
      
           }
           
           
           if specifiedMenuVC.previousselectedObj != nil {
               self.previouslySelectdObj = specifiedMenuVC.previousselectedObj as! Subordinate
               let docObj =  self.previouslySelectdObj as! Subordinate
               self.headQuatersArr?.enumerated().forEach({ index, doctor in
                   if doctor.id  == docObj.id {
                       selectedIndex = index
                   }
               })
              
      
           }
        
       case .jointCall:
           bottomHolderHeight.constant = 80
           self.selectedJwID = specifiedMenuVC.selectedJwID ?? [String: Bool]()
           self.jointWorkArr = DBManager.shared.getJointWork()

           
       case .listedDoctor, .doctorInfo:
           searchTF.placeholder = "Search Listed Doctor name"
           if specifiedMenuVC.previewType != nil {
               switch specifiedMenuVC.previewType {
               case .speciality  :
                   print("Yet to implement")
                   self.previewType = specifiedMenuVC.previewType?.rawValue
                   bottomHolderHeight.constant = 0
               default:
                   bottomHolderHeight.constant = 0
                   print("Yet to implement")
               }
           } else {
               bottomHolderHeight.constant = 0
           }
           self.listedDocArr = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
           if specifiedMenuVC.selectedObject != nil {
               self.selectedObject = specifiedMenuVC.selectedObject as! DoctorFencing
               let docObj =  self.selectedObject as! DoctorFencing
               if !(isfromTF ?? false) {
                   self.searchTF.text = docObj.name
               }
              
               self.listedDocArr?.enumerated().forEach({ index, doctor in
                   if doctor.code  == docObj.code {
                       selectedIndex = index
                   }
               })
              
      
           }
       case .chemist, .chemistInfo:
           searchTF.placeholder = "Search Chemist name"
           bottomHolderHeight.constant = 0
           self.chemistArr = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
           
           if specifiedMenuVC.previousselectedObj != nil {
               self.previouslySelectdObj = specifiedMenuVC.previousselectedObj as! Chemist
               let docObj =  self.previouslySelectdObj as! Chemist
               self.chemistArr?.enumerated().forEach({ index, chemist in
                   if chemist.id  == docObj.id {
                       selectedIndex = index
                   }
               })
              
      
           }
           
       case .stockist, .stockistInfo:
           searchTF.placeholder = "Search Stockist name"
           bottomHolderHeight.constant = 0
           self.stockistArr =  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
       case .unlistedDoctor, .unlistedDoctorinfo:
           searchTF.placeholder = "Search Unlisted Doctor name"
           bottomHolderHeight.constant = 0
           self.unlisteedDocArr = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
       default:
           bottomHolderHeight.constant = 0
           print("Yet to implement")
       }
        toLOadData()
        guard let selectedIndex = selectedIndex else {
            return
        }
        let toScrollIndex: IndexPath = IndexPath(row: selectedIndex, section: 0)
        self.menuTable.scrollToRow(at: toScrollIndex, at: .middle, animated: true)
    }
    
    func cellRegistration() {
       // menuTable.register(UINib(nibName: "SpecifiedMenuTCell", bundle: nil), forCellReuseIdentifier: "SpecifiedMenuTCell")
        
        menuTable.register(UINib(nibName: "resourceInfoTVC", bundle: nil), forCellReuseIdentifier: "resourceInfoTVC")
        
        menuTable.register(UINib(nibName: "CommonResouceInfoTVC", bundle: nil), forCellReuseIdentifier: "CommonResouceInfoTVC")
        
        menuTable.register(UINib(nibName: "CompetitorsMultiselectionTVC", bundle: nil), forCellReuseIdentifier: "CompetitorsMultiselectionTVC")
        
        
    }
    
    func parseCompetitors(from string: String, ourProductCode: String, ourProductName: String) -> [Competitor] {
        let entries = string.components(separatedBy: "/")
        var competitors: [Competitor] = []
        
        for entry in entries {
            let components = entry.components(separatedBy: "~")
            if components.count == 2 {
                let productComponents = components[0].components(separatedBy: "#")
                let brandComponents = components[1].components(separatedBy: "$")
                if productComponents.count == 2 && brandComponents.count == 2 {
                    let compProductName = productComponents[1]
                    let compProductSlNo = productComponents[0]
                    let compName = brandComponents[1]
                    let compSlNo = brandComponents[0]
                
                    guard let competitorEntity = NSEntityDescription.entity(forEntityName: "Competitor", in: self.context)
                         // let selectedClusterentity = NSEntityDescription.entity(forEntityName: "Territory", in: context)
                    else {
                        fatalError("Entity not found")
                    }
                    
                    let temporaryCompetitor = NSManagedObject(entity: competitorEntity, insertInto: nil)  as! Competitor
                    
                   // let acompetitor = Competitor()
                    temporaryCompetitor.compProductName = compProductName
                    temporaryCompetitor.compProductSlNo = compProductSlNo
                    temporaryCompetitor.compName = compName
                    temporaryCompetitor.compSlNo = compSlNo
                    temporaryCompetitor.ourProductCode = ourProductCode
                    temporaryCompetitor.ourProductName = ourProductName
                    //(compProductName: compProductName, compProductSlNo: compProductSlNo, compName: compName, compSlNo: compSlNo)
                    competitors.append(temporaryCompetitor)
                }
            }
        }
        dump(competitors)
        return competitors
    }

    
}


class SpecifiedMenuTCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var holderView: UIView!
    static let identifier = "SpecifiedMenuTCell"
  
    @IBOutlet var lblNameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var brandMatrisIndicator: UIView!
    
    @IBOutlet var specialityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNameLeadingConstraint.constant = 15
        menuIcon.isHidden = true
        menuIcon.isHidden = true
        lblName.textColor = .appTextColor
        lblName.setFont(font: .medium(size: .SMALL))
        brandMatrisIndicator.layer.cornerRadius = brandMatrisIndicator.height / 2
        brandMatrisIndicator.backgroundColor = .appGreen
        brandMatrisIndicator.isHidden = true
        specialityLbl.isHidden = true
    }
    
    func populateCell(model: LeaveType) {
        lblName.text = model.leaveName
      //  itemTypeLbl.text = model.productMode
    }
    
    func populateCell(model: DoctorClass) {
        lblName.text = model.doctorClassName
      //  itemTypeLbl.text = model.productMode
    }
    
    func populateCell(model: Speciality) {
        lblName.text = model.name
      //  itemTypeLbl.text = model.productMode
    }
    
    func populateCell(model: ChemistCategory) {
        lblName.text = model.name
      //  itemTypeLbl.text = model.productMode
    }
    
    func populateCell(model: DoctorCategory) {
        lblName.text = model.name
      //  itemTypeLbl.text = model.productMode
    }
    
    
    
    
    func populateCell(model: Qualifications) {
        lblName.text = model.name
      //  itemTypeLbl.text = model.productMode
    }
    
    func  populateCell(model: Feedback) {
        lblName.text = model.name
    }
    
    func  populateCell(model: Competitor) {
        lblName.text = model.compName
      //  itemTypeLbl.text = model.ourProductName
    }
    
    func  populateCell(model: JointWork) {
        lblName.text = model.name
        
    }
    
    
    func setupUI(model: DoctorFencing, isForspecialty: Bool) {
        
        if isForspecialty {
            specialityLbl.isHidden = false
            specialityLbl.setFont(font: .bold(size: .BODY))
            specialityLbl.textColor = .appLightTextColor
            specialityLbl.text = model.speciality
        } else {
            if model.mappProducts == "" {
                brandMatrisIndicator.isHidden = true
            } else {
                brandMatrisIndicator.isHidden = false
            }
        }
        

    }
    
    
   func setCheckBox(isToset: Bool) {
       lblNameLeadingConstraint.constant = 15 + 30
       menuIcon.isHidden = false
    }
    
}


extension SpecifiedMenuView : addedSubViewsDelegate {
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("yes action")
    }
    
    

    
    func showCustomAlert(desc: String) {
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: AppName, alertDescription: desc, okAction: "Ok")
        commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            
            
        }
    }
    

    
    func showAlert(desc: String) {

        showCustomAlert(desc: desc)
    }
    
    func didClose() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            
            switch aAddedView {
            case addCompetitorsSubiew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    

    
    func didUpdate() {
        backgroundView.isHidden = true
        self.subviews.forEach { aAddedView in
            switch aAddedView {
            case addCompetitorsSubiew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                self.toLoadRequiredData()
                showCustomAlert(desc: "Competitor Added successfully")
                
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    
}
