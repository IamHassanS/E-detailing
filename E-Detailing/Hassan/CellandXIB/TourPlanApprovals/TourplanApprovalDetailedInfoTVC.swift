//
//  TourplanApprovalDetailedInfoTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/07/24.
//

import UIKit

extension TourplanApprovalDetailedInfoTVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TourplanApprovalessionInfoTVC = tableView.dequeueReusableCell(withIdentifier: "TourplanApprovalessionInfoTVC", for: indexPath) as! TourplanApprovalessionInfoTVC
        
        cell.selectionStyle = .none
        let model = sessions[indexPath.row]
        let isForFieldWork = model.FWFlg == "F" || model.FWFlg == "Y"  ? true : false
        cell.lblWorkType.text = model.WTName
        cell.lblHeadquaters.text = model.HQNames
        cell.lblCluster.text = model.clusterName
        cell.lblJointCall.text = model.jwName
        cell.lblListedDoctor.text = model.drName
        cell.lblChemist.text = model.chemName
        cell.lblstockist.text = model.stockistName
        cell.lblunlistedDoc.text = model.unListedDrName
        
        cell.lblHQcount.text = countNonEmptyComponents(in: model.HQNames ?? "")
        
        cell.lblClusterCount.text = countNonEmptyComponents(in: model.clusterName ?? "")
        
        cell.lblJWcount.text = countNonEmptyComponents(in: model.jwName ?? "")
        
        cell.lblDocCount.text = countNonEmptyComponents(in: model.drName ?? "")
        
        cell.lblChemCount.text = countNonEmptyComponents(in: model.chemName ?? "")

        cell.lblStockistCount.text = countNonEmptyComponents(in: model.stockistName ?? "")
        
        cell.lblULdocCount.text = countNonEmptyComponents(in: model.unListedDrName ?? "")
        
        cell.remarksDesc.text = model.remarks
        
        var cellStackHeight = CGFloat()
        if  isForFieldWork   {
            cellStackHeight = cellStackHeightforFW
            
            let cellViewArr : [UIView] = [cell.workTypeView, cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.unlistedDocView]
            
            cellViewArr.forEach { view in
                switch view {
                    
                case cell.headQuatersView:
                    if LocalStorage.shared.getBool(key: .isMR) {
                        view.isHidden = false
                    } else {
                      //  view.isHidden = true
                    }
                    
                    
                case cell.jointCallView:
                    if self.isJointCallneeded {
                        view.isHidden = false
                    } else {
                     //   view.isHidden = true
                    }
                    
                case cell.listedDoctorView:
                    if self.isDocNeeded {
                        view.isHidden = false
                    } else {
                    //    view.isHidden = true
                    }
        
                case cell.chemistView:
                    if self.isChemistNeeded {
                        view.isHidden = false
                    } else {
                     //   view.isHidden = true
                    }
                    
                case cell.stockistView:
                    if self.isSockistNeeded {
                        view.isHidden = false
                    } else {
                      //  view.isHidden = true
                    }
                    

                    
                default:
                    view.isHidden = false
                }
            }
        }  else {
            cellStackHeight += 80
            [cell.headQuatersView,cell.clusterView,cell.jointCallView,cell.listedDoctorView, cell.chemistView, cell.stockistView, cell.unlistedDocView].forEach { view in
                view?.isHidden = true
                
            }
            
        }
        
        cell.stackHeight.constant  = cellStackHeight
        return cell
    }
    
    func countNonEmptyComponents(in string: String) -> String {
        // Split the string by the comma delimiter
        let components = string.split(separator: ",")
        
        // Filter out any empty strings and count the resulting non-empty components
        let nonEmptyComponents = components.filter { !$0.isEmpty }
        
        return "\(nonEmptyComponents.count)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = sessions[indexPath.row]
      
        let isForFieldWork = model.FWFlg == "F" || model.FWFlg == "Y" ? true : false
        
        if isForFieldWork {
            return cellEditHeightForFW
        }  else {
            return  cellEditHeightForOthers
            
        }
    }
}


class TourplanApprovalDetailedInfoTVC: UITableViewCell {

    @IBOutlet var elevationView: UIView!
    @IBOutlet var workTypeDescriptionTable: UITableView!
    @IBOutlet var tableHolderView: UIView!
    @IBOutlet var wtStack: UIStackView!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var chevlonIV: UIImageView!
    @IBOutlet var wtLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    var sessions: [SessionDetail] = []
    var isDocNeeded = true
    var isJointCallneeded = true
    var isChemistNeeded = true
    var isSockistNeeded = true
    var isnewCustomerNeeded = true
    var isHQNeeded = true
    var cellEditHeightForOthers : CGFloat = 100 + 100
    var cellEditHeightForFW :  CGFloat = 670 + 60
    let cellStackHeightfOthers : CGFloat = 80 + 100
    var cellStackHeightforFW : CGFloat = 600
    var cellEditStackHeightfOthers : CGFloat = 80 + 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // contentViewHeightConstraint.constant = 670 + 100 + 10
        setupUI()
    }
    
    func populateCell(model: TourPlanApprovalDetailModel) {
        self.wtLbl.text = model.wtName + ", " + model.wtName2 + ", " + model.wtName3
        self.dateLbl.text = model.day
        guard model.isExtended else {
            contentViewHeightConstraint.constant = 60
            tableHolderView.isHidden = true
            chevlonIV.image = UIImage(named: "chevlon.expand")
            toloadData()
            return
        }
        
        var cellHeight: CGFloat = 0
        sessions = convertToSessionDetails(from: model)
        sessions.forEach { aSessionDetail in
            if aSessionDetail.FWFlg == "Y" || aSessionDetail.FWFlg == "F" {
                cellHeight += 670 + 100
             
           } else {
               cellHeight +=  60 + 20 + 100
           }
        }
        contentViewHeightConstraint.constant = cellHeight + 60
        tableHolderView.isHidden = false
        chevlonIV.image = UIImage(named: "chevlon.collapse")
       // sessions = convertToSessionDetails(from: model)
        toloadData()
    }
    
    func convertToSessionDetails(from model: TourPlanApprovalDetailModel) -> [SessionDetail] {
        var sessionDetails = [SessionDetail]()

        // Create first SessionDetail
        let session1 = SessionDetail()
        session1.workTypeCode = model.wtCode
        session1.FWFlg = model.fwFlg
        session1.HQCodes = model.hqCodes
        session1.HQNames = model.hqNames
        session1.WTCode = model.wtCode
        session1.WTName = model.wtName
        session1.chemCode = model.chemCode
        session1.chemName = model.chemName
        session1.clusterCode = model.clusterCode
        session1.clusterName = model.clusterName
        session1.drCode = model.drCode
        session1.drName = model.drName
        session1.jwCode = model.jwCodes
        session1.jwName = model.jwNames
        session1.remarks = model.dayRemarks
        session1.stockistCode = model.stockistCode
        session1.stockistName = model.stockistName
        sessionDetails.append(session1)

        guard model.wtCode2 != "" else {
            return sessionDetails
        }
        // Create second SessionDetail
        let session2 = SessionDetail()
        session2.workTypeCode = model.wtCode2
        session2.FWFlg = model.fwFlg2
        session2.HQCodes = model.hqCodes2
        session2.HQNames = model.hqNames2
        session2.WTCode = model.wtCode2
        session2.WTName = model.wtName2
        session2.chemCode = model.chemTwoCode
        session2.chemName = model.chemTwoName
        session2.clusterCode = model.clusterCode2
        session2.clusterName = model.clusterName2
        session2.drCode = model.drTwoCode
        session2.drName = model.drTwoName
        session2.jwCode = model.jwCodes2
        session2.jwName = model.jwNames2
        session2.remarks = model.dayRemarks2
        session2.stockistCode = model.stockistTwoCode
        session2.stockistName = model.stockistTwoName
        sessionDetails.append(session2)
        
        guard model.wtCode3 != "" else {
            return sessionDetails
        }
        // Create third SessionDetail
        let session3 = SessionDetail()
        session3.workTypeCode = model.wtCode3
        session3.FWFlg = model.fwFlg3
        session3.HQCodes = model.hqCodes3
        session3.HQNames = model.hqNames3
        session3.WTCode = model.wtCode3
        session3.WTName = model.wtName3
        session3.chemCode = model.chemThreeCode
        session3.chemName = model.chemThreeName
        session3.clusterCode = model.clusterCode3
        session3.clusterName = model.clusterName3
        session3.drCode = model.drThreeCode
        session3.drName = model.drThreeName
        session3.jwCode = model.jwCodes3
        session3.jwName = model.jwNames3
        session3.remarks = model.dayRemarks3
        session3.stockistCode = model.stockistThreeCode
        session3.stockistName = model.stockistThreeName
        sessionDetails.append(session3)

        return sessionDetails
    }
    
    func toloadData() {
        workTypeDescriptionTable.delegate = self
        workTypeDescriptionTable.dataSource = self
        workTypeDescriptionTable.reloadData()
    }
    
    func setupUI() {
        workTypeDescriptionTable.isScrollEnabled = false
        workTypeDescriptionTable.register(UINib(nibName: "TourplanApprovalessionInfoTVC", bundle: nil), forCellReuseIdentifier: "TourplanApprovalessionInfoTVC")
        elevationView.layer.cornerRadius = 5
        elevationView.elevate(2)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
