//
//  DCRApprovalsTVC.swift
//  SAN ZEN
//
//  Created by San eforce on 22/07/24.
//

import UIKit

class DCRApprovalsTVC: UITableViewCell {

    @IBOutlet var contentHolderView: UIView!
    @IBOutlet var accessoryIV: UIImageView!
    @IBOutlet var mrNameLbl: UILabel!
    
    @IBOutlet var dateHolderView: UIView!
    @IBOutlet var approcalDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mrNameLbl.setFont(font: .bold(size: .BODY))
        approcalDateLbl.setFont(font: .medium(size: .BODY))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(_ model: ApprovalsListModel) {
        self.mrNameLbl.text = model.sfName
        self.approcalDateLbl.text = model.activityDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
    }
    
    func populateCell(_ model: ApprovalDetailsModel) {
        self.mrNameLbl.text = model.transDetailName
      //  self.approcalDateLbl.text = model.visitTime.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
    }
    
    func populateCell(_ model: TourPlanApprovalModel) {
        self.mrNameLbl.text = model.sfName
        self.approcalDateLbl.text = "\(model.mnth) \(model.yr)"
    }
    
}
