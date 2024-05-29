//
//  DayReportsSortView.swift
//  E-Detailing
//
//  Created by San eforce on 27/05/24.
//

import Foundation
import UIKit


import Foundation
import UIKit


protocol DayReportsSortViewDelegate: AnyObject {
    func userDidSort(sorted index: Int?)
    func userDidCancel()
}

extension DayReportsSortView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
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
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioSelectionTVC = tableView.dequeueReusableCell(withIdentifier: "RadioSelectionTVC", for: indexPath) as! RadioSelectionTVC
        cell.typeTitle.text = sortOptions[indexPath.row]
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
            self.toloadTable()
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

class DayReportsSortView: UIView{
  
 
    @IBOutlet var btnCancel: ShadowButton!
    
    @IBOutlet var btnSave: ShadowButton!
    
    @IBOutlet var sortOptionsTable: UITableView!
    var callVM: CallViewModel?

    var isFromDayReport: Bool = false
    var selectedIndex: Int? = nil
    var sortOptions: [String] = []
    weak var delegate: DayReportsSortViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
       
     }
    
    func toloadTable() {

        sortOptionsTable.delegate = self
        sortOptionsTable.dataSource = self
        sortOptionsTable.reloadData()
    }
    
    func setupUI() {
        self.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        btnSave.layer.cornerRadius = 5
        sortOptions = ["Ascending by name", "Descending by name", isFromDayReport ?  "Visit time" : "Submission date"]
        sortOptionsTable.register(UINib(nibName: "RadioSelectionTVC", bundle: nil), forCellReuseIdentifier: "RadioSelectionTVC")
        toloadTable()
        btnCancel.addTap {
            self.delegate?.userDidCancel()
        }
        
        
        btnSave.addTap {
           
            self.delegate?.userDidSort(sorted: self.selectedIndex)
        }
    }
}
