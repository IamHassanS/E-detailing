//
//  DCRAllApprovalsTVC.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import UIKit

extension DCRAllApprovalsTVC: DCRApprovalsInfoTVCDelegate {
    func didDCRinfoTapped(index: Int) {
        guard let approvalDetails = self.approvalDetails, let approvalList = self.selectedapproval else {return}
        pushDetailsVC(model: approvalDetails[index], allapprovals: approvalDetails, slectedList: approvalList)
    }
    
    func pushDetailsVC(model: ApprovalDetailsModel, allapprovals: [ApprovalDetailsModel], slectedList: ApprovalsListModel) {
        guard let rootVC = self.rootController else {return}
        let vc = DCRapprovalinfoVC.initWithStory(model: model, allApprovals: allapprovals, selectedList: slectedList)
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DCRAllApprovalsTVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let approvalDetails = approvalDetails else {return 0}
        return approvalDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DCRApprovalsInfoTVC = tableView.dequeueReusableCell(withIdentifier: "DCRApprovalsInfoTVC", for: indexPath) as! DCRApprovalsInfoTVC
        
        guard let approvalDetails = approvalDetails else {return UITableViewCell()}
        guard approvalDetails.count > indexPath.row else {return UITableViewCell()}
        let model = approvalDetails[indexPath.row]
        cell.delegate = self
        cell.populateDCRArroval(model: model)
        
        cell.selectionStyle = .none
        
        cell.addTap {
            cell.delegate?.didDCRinfoTapped(index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


 
class DCRAllApprovalsTVC: UITableViewCell {

    @IBOutlet var allApprovalsTable: UITableView!
    var rootController : UIViewController?
    var selectedapproval: ApprovalsListModel?
    var approvalDetails : [ApprovalDetailsModel]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellRegistration()
    }
    func cellRegistration() {
        allApprovalsTable.register(UINib(nibName: "DCRApprovalsInfoTVC", bundle: nil), forCellReuseIdentifier: "DCRApprovalsInfoTVC")
    }
    
    func populateCell(model: [ApprovalDetailsModel]) {
        self.approvalDetails = model
        toLoadTable()
    }
    
    func toLoadTable()
    {
        allApprovalsTable.delegate = self
        allApprovalsTable.dataSource = self
        allApprovalsTable.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
