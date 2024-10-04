//
//  SortView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//



import Foundation
import UIKit


protocol SortVIewDelegate: AnyObject {
    
   func didSelected(index: Int? , isTosave: Bool)
    
}

class SortVIew: UIView, UITableViewDelegate, UITableViewDataSource {

    var rowElements : [String]?
    
    var selectedIndex: Int? = nil
    var isFromDayReport: Bool = false

    let btnHolderView: UIStackView = {
        let holderStack = UIStackView()
        holderStack.distribution = .fillEqually
        holderStack.spacing = 5
        return holderStack
    }()
    
    let sotrTable: UITableView = {
        let aTable = UITableView()
        aTable.clipsToBounds = true
        aTable.layer.cornerRadius = 5
        return aTable
    }()
    
    
    let aview: UIView = {
        let aView = UIView()
        aView.backgroundColor = .appWhiteColor
        aView.clipsToBounds = true
        aView.layer.cornerRadius = 5
        aView.layer.borderColor = UIColor.appSelectionColor.cgColor
        aView.elevate(2)
       return aView
    }()
    
    let saveBtn: UIButton = {
        let save = UIButton()
        save.setTitle("Save", for: .normal)
        save.titleLabel?.setFont(font: .medium(size: .BODY))
        save.setTitleColor(.white, for: .normal)
        save.backgroundColor = .appTextColor
        save.tintColor = .appWhiteColor
        save.layer.cornerRadius = 5
   
        return save
    }()
    
    @objc func didTapSave() {
        self.delegate?.didSelected(index:  self.selectedIndex ?? nil, isTosave: true)
    }
    
    @objc func didTapCancel() {
        self.delegate?.didSelected(index:  nil, isTosave: false)
    }
    
    let cancelBtn : UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.titleLabel?.setFont(font: .medium(size: .BODY))
        cancel.setTitleColor(.appTextColor, for: .normal)
        cancel.backgroundColor = .appWhiteColor
        cancel.tintColor = .appTextColor
        cancel.layer.borderColor = UIColor.appTextColor.cgColor
        cancel.layer.borderWidth = 1
        cancel.layer.cornerRadius = 5
        return cancel
    }()
    
    var delegate: SortVIewDelegate?
    var sreArr : [String] = []
    override func layoutSubviews() {
        
        aview.frame = CGRect(x: 5, y: 5, width: self.width - 10, height: self.height - 10)
        
        sotrTable.frame = CGRect(x: 0, y: 0, width: aview.width, height: aview.height - 50)
        btnHolderView.frame = CGRect(x: aview.width / 2 - 5, y: sotrTable.bottom, width: aview.width / 2, height: 40)
        
    }
    
    
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
     //   commonInit()
        setupTableView()
        cellRegistration()
        toLoadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   //    commonInit()
        setupTableView()
        cellRegistration()
        toLoadData()
    }
    

    
    
    private func setupTableView() {
        btnHolderView.addArrangedSubview(cancelBtn)
        btnHolderView.addArrangedSubview(saveBtn)
        addSubview(aview)
        aview.addSubview(sotrTable)
        aview.addSubview(btnHolderView)
        sotrTable.isScrollEnabled = false
        self.layer.cornerRadius = 5
        saveBtn.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }
    

    
    func toLoadData() {
        sreArr = ["Ascending by name", "Descending by name", isFromDayReport ?  "by visit time" : "by submission date"]
        rowElements = sreArr
        sotrTable.delegate = self
        sotrTable.dataSource = self
        sotrTable.reloadData()
    }
    
    func cellRegistration() {
        sotrTable.register(UINib(nibName: "RadioSelectionTVC", bundle: nil), forCellReuseIdentifier: "RadioSelectionTVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowElements?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.clipsToBounds = true
        let headerLabel = UILabel()
        headerLabel.backgroundColor = .clear
        headerLabel.clipsToBounds = true
        headerLabel.text = "Sort"
        headerLabel.textColor = .appTextColor
        headerLabel.setFont(font: .bold(size: .BODY))
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioSelectionTVC = tableView.dequeueReusableCell(withIdentifier: "RadioSelectionTVC", for: indexPath) as! RadioSelectionTVC
        cell.typeTitle.text = rowElements?[indexPath.row]
        cell.selectionStyle = .none
        cell.selectdSection = selectedIndex
        if cell.selectdSection == nil {
            cell.selectionIV.image = UIImage(named: "checkBoxEmpty")
        } else {
            if  cell.selectdSection ?? 0 == indexPath.row {
                cell.selectionIV.image = UIImage(named: "checkBoxSelected")
            } else {
                cell.selectionIV.image = UIImage(named: "checkBoxEmpty")
            }
        }
        

        
        cell.addTap {
            cell.selectdSection = indexPath.row
            self.selectedIndex = indexPath.row
            self.toLoadData()
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
