//
//  ListedWorkTypesTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import UIKit

extension ListedWorkTypesTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      //  let count = self.wtModel?.wtype
        
        if self.wtModel?.halfDayFWType != "" {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WTsheetCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "WTsheetCVC", for: indexPath) as! WTsheetCVC
       
        
        if self.wtModel?.halfDayFWType != "" {
            if indexPath.row == 1 {
                cell.isLastElement = true
            } else {
                cell.isLastElement = false
            }
        } else {
            cell.isLastElement = true
        }
        cell.populateCell(model: self.wtModel ?? ReportsModel())

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 60)
    }
    

    
}

class ListedWorkTypesTVC: UITableViewCell {
    @IBOutlet var tableHolderView: UIView!
    
    @IBOutlet var worktypeCollection: UICollectionView!
    var wtModel:  ReportsModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        cellRegistration()
        
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
        worktypeCollection.register(UINib(nibName: "WTsheetCVC", bundle: nil), forCellWithReuseIdentifier: "WTsheetCVC")
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
