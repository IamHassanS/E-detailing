//
//  CompetitorsFooter.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/03/24.
//

import UIKit
import CoreData

extension CompetitorsFooter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowcount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CompetitorsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "CompetitorsDetailsCell", for: indexPath) as! CompetitorsDetailsCell
        if let competitors = self.competitors {
            cell.competitor =  competitors[indexPath.row]
        }
    
        cell.selectionStyle = .none
        cell.deleteHolder.addTap {
           // self.delegate?.didTapdeleteCompetitor(section: section, index: indx, competitorIndex: <#T##Int#>)
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


protocol CompetitorsFooterDelegate: AnyObject {
    func didTapdeleteCompetitor(competitor: Competitor, section: Int, index: Int, competitorIndex: Int)
    func didTapEditCompetitor(competitor: Competitor, section: Int, index: Int, competitorIndex: Int)
    func didUpdateComperirorValue(additionalCompetitorsInfo: AdditionalCompetitorsInfo , section: Int, index: Int, competitorIndex: Int)
}

class CompetitorsFooter: UITableViewHeaderFooterView {
    @IBOutlet var viewAddcompetitor: UIView!
    
    @IBOutlet var curvedViewHeightConstraint: NSLayoutConstraint! //50 default
    @IBOutlet var curvedView: UIView!
    @IBOutlet var addcompetitorCXview: UIVisualEffectView!
    
    @IBOutlet var btnAddcompetitor: UIButton!
    @IBOutlet var competitorsTable: UITableView!
    var rowcount: Int?
    var section: Int?
    weak var delegate: CompetitorsFooterDelegate?
    var competitors: [Competitor]?
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
    
    func cellregistration() {
        competitorsTable.register(UINib(nibName: "CompetitorsDetailsCell", bundle: nil), forCellReuseIdentifier: "CompetitorsDetailsCell")
        
        competitorsTable.register(UINib(nibName: "CompetitorsDetailsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CompetitorsDetailsHeader")
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
