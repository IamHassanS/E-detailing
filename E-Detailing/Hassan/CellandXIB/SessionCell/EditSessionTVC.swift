//
//  SessionInfoTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 10/01/24.
//

import UIKit
//import

 
class EditSessionTVC: UITableViewCell {
    
    @IBOutlet var titleHolderView: UIView!
    @IBOutlet var elevationStack: UIStackView!
    
    @IBOutlet var stackHeight: NSLayoutConstraint!
    
    @IBOutlet var overallContentsHolder: UIView!
    @IBOutlet weak var lblName: UILabel!

    ///Worktype outlets
    
    @IBOutlet var worktyprTitle: UILabel!
    @IBOutlet weak var workTypeView: UIView!
    
    @IBOutlet weak var workselectionHolder: UIView!
    
    @IBOutlet var lblWorkType: UILabel!
    
    ///cluster type outlets
    @IBOutlet var clusterTitle: UILabel!
    @IBOutlet weak var clusterView: UIView!
    
  
    
    @IBOutlet weak var clusterselectionHolder: UIView!
    
    
    @IBOutlet var lblCluster: UILabel!
    
    ///headQuaters type outlets
    @IBOutlet var headQuartersTitle: UILabel!
    @IBOutlet var headQuatersView: UIView!
    
    @IBOutlet var headQuatersSelectionHolder: UIView!
    
    @IBOutlet var lblHeadquaters: UILabel!
    
    
    ///jointCall type outlets
    @IBOutlet var jointCallTitle: UILabel!
    @IBOutlet var jointCallView: UIView!
    
    @IBOutlet var jointCallSelectionHolder: UIView!
    
    
    @IBOutlet var lblJointCall: UILabel!
    
    ///listedDoctor type outlets
    @IBOutlet var listedDocTitle: UILabel!
    @IBOutlet var listedDoctorView: UIView!
    
    @IBOutlet var listedDoctorSelctionHolder: UIView!
    
    @IBOutlet var lblListedDoctor: UILabel!
    
    
    ///chemist type outlets
    @IBOutlet var chemistTitle: UILabel!
    @IBOutlet var chemistView: UIView!
    
    @IBOutlet var chemistSelectionHolder: UIView!
    
    @IBOutlet var lblChemist: UILabel!
    
    ///Stockist type outlets
    @IBOutlet var stockistTitle: UILabel!
    @IBOutlet var stockistView: UIView!
    
    @IBOutlet var chemistSectionHolder: UIView!
    
    @IBOutlet var lblstockist: UILabel!
    
    
    ///NewCustoers type outlet
    @IBOutlet var newCustomersTitle: UILabel!
    @IBOutlet var unlistedDocView: UIView!
    
    @IBOutlet var unlistedDocHolder: UIView!
    
    @IBOutlet var lblunlistedDoc: UILabel!
    
    @IBOutlet var remarksContentHolder: UIView!
    
    @IBOutlet var remarksView: UIView!
    
    @IBOutlet var remarksHeightConst: NSLayoutConstraint!
    
    @IBOutlet var remarksTitle: UILabel!
    
    @IBOutlet var remarksDesc: UILabel!
    
    @IBOutlet var wtSeperator: UIView!
    
    @IBOutlet var hqSeperator: UIView!
    
    @IBOutlet var clusterSerperator: UIView!
    
    @IBOutlet var jointcallSeperator: UIView!
    
    @IBOutlet var docSeperator: UIView!
    
    @IBOutlet var chemistSeperator: UIView!
    
    @IBOutlet var stockistSeperator: UIView!
    
    @IBOutlet var unlistedDocSeperator: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupUI()
       
    }
    
    
    func setupUI() {
        clusterTitle.text = LocalStorage.shared.getString(key: .cluster)
        listedDocTitle.text = LocalStorage.shared.getString(key: .doctor)
        chemistTitle.text = LocalStorage.shared.getString(key: .chemist)
        stockistTitle.text = LocalStorage.shared.getString(key: .stockist)
        newCustomersTitle.text = LocalStorage.shared.getString(key: .unlistedDoctor)
        
        let seperators : [UIView] =  [wtSeperator, hqSeperator, clusterSerperator, jointcallSeperator, docSeperator, chemistSeperator, stockistSeperator, unlistedDocSeperator]
        
        seperators.forEach { view in
            view.backgroundColor = .appSelectionColor
        }
        
        let labels : [UILabel] = [lblWorkType, lblCluster, lblHeadquaters, lblJointCall, lblListedDoctor, lblChemist, lblstockist, lblunlistedDoc, remarksDesc]
        labels.forEach { label in
            label.textColor = .appTextColor
            label.setFont(font: .medium(size: .BODY))
        }
        
        let titleLabels : [UILabel] = [worktyprTitle, clusterTitle, headQuartersTitle, jointCallTitle, listedDocTitle,  chemistTitle, stockistTitle, newCustomersTitle, remarksTitle]
        titleLabels.forEach { label in
            label.textColor = .appLightTextColor
            label.setFont(font: .bold(size: .SMALL))
        }
        
        lblName.textColor = .appTextColor
        lblName.setFont(font: .bold(size: .BODY))
        
        elevationStack.backgroundColor = .appGreyColor.withAlphaComponent(0.5)
            //.appSelectionColor
        
        elevationStack.setSpecificCornersForBottom(cornerRadius: 5)
        
        overallContentsHolder.backgroundColor = .appWhiteColor
       // overallContentsHolder.layer.cornerRadius = 5
        
        titleHolderView.backgroundColor = .appGreyColor.withAlphaComponent(0.5)
            //.appSelectionColor
        titleHolderView.setSpecificCornersForTop(cornerRadius: 5)
        
        remarksView.backgroundColor = .appWhiteColor
        
        remarksContentHolder.backgroundColor = .appGreyColor.withAlphaComponent(0.5)
            //.appSelectionColor
        remarksContentHolder.layer.cornerRadius = 5
       // lblName.setFont(font: .bold(size: .SUBHEADER))
        
        
       
    }
    
    override func prepareForReuse() {
       /// deinit {
            NotificationCenter.default.removeObserver(self)
       /// }
    }
    



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
