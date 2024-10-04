//
//  RcpaAddedListTableViewCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/04/24.
//

import Foundation
import UIKit


extension RcpaAddedListTableViewCell: CompetitorsDetailsCellDelagate {
    func didUpdateQuantity(qty: String, index: Int) {
        self.competitorsInfo?[index].qty = qty
        
        if let quantity = Int(qty) {
            let rate = (Int(competitorRate ?? "0") ?? 0) * quantity
            self.competitorsInfo?[index].rate = "\(rate)"
            
            let value = (Int(competirorValue ?? "0") ?? 0) * quantity
            self.competitorsInfo?[index].value = "\(value)"
            
        }
        
        
        
        self.delegate?.didUpdateComperirorValue(additionalCompetitorsInfo: self.competitorsInfo![index], section: section!, index: self.index!, competitorIndex: index)
        

        
        self.toloadData()
    }

    
    
}


extension RcpaAddedListTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return string == numberFiltered && newString.length <= maxLength

    }
}

extension RcpaAddedListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowcount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CompetitorsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "CompetitorsDetailsCell", for: indexPath) as! CompetitorsDetailsCell
        if let competitors = self.competitors {
            cell.competitor =  competitors[indexPath.row]
        }
        cell.qtyTF.delegate = self
        //cell.setupUI()
        cell.delegate = self
        cell.index = indexPath.row
        
        cell.qtyTF.text =  self.competitorsInfo?[indexPath.row].qty == "" ? "1" :  self.competitorsInfo?[indexPath.row].qty
        if let quantity = Float(cell.qtyTF.text ?? "1") {
           // let rate = (Int(competitorRate ?? "0") ?? 0) * quantity
            cell.rateLbl.text = competitorRate
            
            let value = (Float(competirorValue ?? "0") ?? 0) * quantity
            cell.valueLbl.text = "\(value)"
            
        } else {
            cell.rateLbl.text = competitorRate
            cell.valueLbl.text = competirorValue
        }
        
    
        cell.selectionStyle = .none
        cell.commentsIV.tintColor = .appTextColor
        if let competitorsInfo = self.competitorsInfo {
            let selectedCompetitorsInfo = competitorsInfo[indexPath.row]
            cell.commentsIV.alpha =   selectedCompetitorsInfo.remarks != "" || selectedCompetitorsInfo.remarks != nil ?  1 : 0.5
            if let remarksStr = selectedCompetitorsInfo.remarks {
               // let remarksStr = selectedCompetitorsInfo.remarks
                cell.didCommentsAdded = !remarksStr.isEmpty ?  true : false
            } else {
                cell.didCommentsAdded  = false
            }
         
        }
        
        cell.deleteHolder.addTap {
            guard let section = self.section, let index = self.index else {return}
            self.delegate?.didTapdeleteCompetitor(competitor:  cell.competitor, section: section, index: index, competitorIndex: indexPath.row)
        }
      
        cell.commentsHolder.addTap {
            guard let section = self.section, let index = self.index else {return}
            self.delegate?.didTapEditCompetitor(competitor:  cell.competitor , section: section, index: index, competitorIndex: indexPath.row)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CompetitorsDetailsHeader") as? CompetitorsDetailsHeader else {
 
            return UIView()
        }



        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}

class RcpaAddedListTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet var lblValue: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!

    
    @IBOutlet var viewQtyHolder: UIView!
    @IBOutlet var viewRateHolder: UIView!
    
    @IBOutlet var viewTotalHolder: UIView!
    
    @IBOutlet var viewValueHolder: UIView!
    
    @IBOutlet var btnAddCompetitor: UIButton!
    weak var delegate: CompetitorsFooterDelegate?
    
    @IBOutlet var viewAddcompetitor: UIView!
    @IBOutlet var curvedView: UIView!
    @IBOutlet var competitorsTable: UITableView!
    @IBOutlet var curvedViewHeightConstraint: NSLayoutConstraint! //50 default
    var rowcount: Int?
    var section: Int?
    var index: Int?
    var competitorquantity: String?
    var competitorRate: String?
    var competirorValue: String?
    var competitors: [Competitor]?
    var competitorsInfo : [AdditionalCompetitorsInfo]?
    func setupAddedCompetitors(count: Int, competitors: [Competitor]) {
        //50 - header
        //50 - addbtn
        //10 - top bottom padding
        //50 * count - each cell height

        let tableHeight: CGFloat = count == 0 ?  CGFloat(50) : CGFloat((count * 50) + 50 + 50 + 10)
        curvedViewHeightConstraint.constant = tableHeight
        if count > 0 {
            rowcount = count
            self.competitors = competitors
            toloadData()
        }

   
    }
    
    func toloadData() {
        competitorsTable.delegate = self
        competitorsTable.dataSource = self
        competitorsTable.reloadData()
    }
    
    var rcpaProduct : RCPAdetailsModal! {

        didSet {
              
        }
    }
    
    
    func cellregistration() {
        competitorsTable.register(UINib(nibName: "CompetitorsDetailsCell", bundle: nil), forCellReuseIdentifier: "CompetitorsDetailsCell")
        
        competitorsTable.register(UINib(nibName: "CompetitorsDetailsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CompetitorsDetailsHeader")
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        competitorsTable.showsVerticalScrollIndicator = false
        competitorsTable.isScrollEnabled = false
        btnDelete.setTitle("", for: .normal)
        viewQtyHolder.layer.cornerRadius = 3
        viewRateHolder.layer.cornerRadius = 3
        viewTotalHolder.layer.cornerRadius = 3
        viewValueHolder.layer.cornerRadius = 3
        
        viewRateHolder.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        viewValueHolder.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        viewTotalHolder.backgroundColor = .appLightTextColor.withAlphaComponent(0.2)
        viewQtyHolder.layer.borderWidth = 1
        viewQtyHolder.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor

        
        cellregistration()
        competitorsTable.separatorStyle = .none

        // Initialization code
        viewAddcompetitor.layer.cornerRadius = 5
        viewAddcompetitor.layer.borderWidth = 1
        viewAddcompetitor.layer.borderColor = UIColor.appGreen.cgColor
        curvedView.layer.cornerRadius = 5
        curvedView.layer.borderWidth = 1
        curvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
        
    }
    
}
