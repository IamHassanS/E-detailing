//
//  RcpaSelectedCompetitorView.swift
//  E-Detailing
//
//  Created by SANEFORCE on 08/09/23.
//

import Foundation
import UIKit


class RcpaSelectedCompetitorView : UIView {
    
    
    
    @IBOutlet weak var lblCompetitorCompany: UILabel!
    @IBOutlet weak var lblCompetitorBrand: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblRemarks: UILabel!
    
    
    
    var rcpa : RcpaHeaderData! {
        didSet {
            self.lblCompetitorCompany.text = rcpa.competitorCompanyName
            self.lblCompetitorBrand.text = rcpa.competitorBrandName
            self.lblQty.text = rcpa.competitorQty
            self.lblRate.text = rcpa.competitorRate
            self.lblValue.text = rcpa.competitorTotal
            self.lblRemarks.text = rcpa.remarks
        }
    }
    
       
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    class func instanceFromNib() -> RcpaSelectedCompetitorView{
        return Bundle.main.loadNibNamed("RcpaSelectedCompetitorView", owner: self, options: nil)?.first as! RcpaSelectedCompetitorView
    }
    
}
