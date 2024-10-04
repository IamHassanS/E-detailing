//
//  DCRApprovalsWorkTypeTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/07/24.
//

import UIKit

extension DCRApprovalsWorkTypeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      //  let count = self.wtModel?.wtype
        
//        if self.wtModel?.halfDayFWType != "" {
//            return 2
//        } else {
//            return 1
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DCRApprovalsWorkSheetsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "DCRApprovalsWorkSheetsCVC", for: indexPath) as! DCRApprovalsWorkSheetsCVC

        guard let model = self.listModel else {return UICollectionViewCell()}
        var routes: [String] = []
        self.detailsmodel?.forEach({ approvalDetailsModel in
            if !routes.contains(where: { $0 == approvalDetailsModel.sdpName
            }) {
                routes.append(approvalDetailsModel.sdpName)
            }
        })
        cell.populateCell(model: model, routes: routes.joined(separator: ", "))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 80)
    }
    

    
}

class DCRApprovalsWorkTypeTVC: UITableViewCell {
    @IBOutlet var tableHolderView: UIView!
    
    @IBOutlet var worktypeCollection: UICollectionView!
    
    @IBOutlet var mrNameLbl: UILabel!
    @IBOutlet var submittedDateLbl: UILabel!
    @IBOutlet var activityDateLbl: UILabel!
    
    var detailsmodel:  [ApprovalDetailsModel]?
    var listModel: ApprovalsListModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        cellRegistration()
        
    }
    
    func toPopulatecell(detailsmodel: [ApprovalDetailsModel], listModel: ApprovalsListModel) {
        mrNameLbl.text = listModel.sfName
        submittedDateLbl.text =   listModel.submissionDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
        activityDateLbl.text =  listModel.activityDate.toDate(format: "dd/MM/yyyy").toString(format: "d MMM yyyy")
        self.detailsmodel = detailsmodel
        self.listModel = listModel
        self.toloadData()
    }
    
    func setupUI() {
        worktypeCollection.isScrollEnabled = false
        tableHolderView.layer.cornerRadius = 5
        tableHolderView.layer.borderWidth = 1
        tableHolderView.layer.borderColor = UIColor.appGreyColor.cgColor

    }
    
    func toloadData() {
        worktypeCollection.delegate = self
        worktypeCollection.dataSource = self
        worktypeCollection.reloadData()
    }
    func cellRegistration() {
        worktypeCollection.register(UINib(nibName: "DCRApprovalsWorkSheetsCVC", bundle: nil), forCellWithReuseIdentifier: "DCRApprovalsWorkSheetsCVC")
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

