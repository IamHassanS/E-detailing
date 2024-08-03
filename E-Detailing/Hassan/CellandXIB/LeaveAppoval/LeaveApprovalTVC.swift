//
//  LeaveApprovalTVC.swift
//  SAN ZEN
//
//  Created by San eforce on 24/07/24.
//

import UIKit

protocol LeaveApprovalTVCDelegate: AnyObject {
    func diduserApprove(index: Int)
    func diduserReject(index: Int)
}

class LeaveApprovalTVC: UITableViewCell {
    @IBOutlet var contentHolderView: UIView!
    @IBOutlet var empCodeTitle: UILabel!
    
    @IBOutlet var yettoArroverName: UILabel!
    @IBOutlet var approveView: UIView!
    @IBOutlet var rejectView: UIView!
    @IBOutlet var reasonDesc: UILabel!
    @IBOutlet var reasonTitle: UILabel!
    @IBOutlet var addressonDesc: UILabel!
    @IBOutlet var addressonTitle: UILabel!
    @IBOutlet var noofDaysDesc: UILabel!
    @IBOutlet var noofDaysTitle: UILabel!
    @IBOutlet var toDesc: UILabel!
    @IBOutlet var toTitle: UILabel!
    @IBOutlet var fromDesc: UILabel!
    @IBOutlet var fromTitlr: UILabel!
    @IBOutlet var leaveTypeDesc: UILabel!
    @IBOutlet var leaveTypeTitle: UILabel!
    @IBOutlet var empCodeDesc: UILabel!
    weak var delegate: LeaveApprovalTVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func toPopulateCell(model: LeaveApprovalDetail) {
        yettoArroverName.text = model.sfName
        empCodeDesc.text = model.sfCode
        leaveTypeDesc.text = model.lType
        fromDesc.text = model.fromDate.date.toDate().toString(format: "yyyy/MM/dd")
        toDesc.text = model.toDate.date.toDate().toString(format: "yyyy/MM/dd")
        noofDaysDesc.text = model.noOfDays
        addressonDesc.text = model.address
        reasonDesc.text = model.reason
    }
    
    func setupUI() {
        contentHolderView.layer.cornerRadius = 5
        contentHolderView.elevate(2)
        approveView.layer.cornerRadius = 5
        rejectView.layer.cornerRadius = 5
        approveView.backgroundColor = .appGreen
        rejectView.backgroundColor = .appLightPink
        [toTitle, fromTitlr, empCodeTitle, leaveTypeTitle, noofDaysTitle, addressonTitle, reasonTitle].forEach { label in
            label?.setFont(font: .medium(size: .BODY))
            label?.textColor = .appLightTextColor
        }
        
        [toDesc, fromDesc, empCodeDesc, leaveTypeDesc, noofDaysDesc, addressonDesc, reasonDesc].forEach { label in
            label?.setFont(font: .bold(size: .BODY))
            label?.textColor = .appTextColor
        }
        
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
