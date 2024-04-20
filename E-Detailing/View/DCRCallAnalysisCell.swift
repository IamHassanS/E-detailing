//
//  DCRCallAnalysisCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 24/07/23.
//

import UIKit
import UICircularProgressRing

class DCRCallAnalysisCell : UICollectionViewCell {
    
    
    enum CellType {
        case MR
        case Manager
    }
    
    
    func setCellType(cellType: CellType) {
       
        
        switch cellType {
            
        case .MR:
            viewManager.isHidden = true
            viewDoctor.isHidden = false
            setupUIforMR()
        case .Manager:
            viewManager.isHidden = false
            viewDoctor.isHidden = true
            setupUIforManager()
        }
    }
    
    
    @IBOutlet var viewManager: UIView!
    
    @IBOutlet var callsTitleLbl: UILabel!
    
    @IBOutlet var callsDescLbl: UILabel!
    
    @IBOutlet var callsIV: UIImageView!
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    
    @IBOutlet weak var viewDoctor: UIView!
    @IBOutlet weak var viewChart: UICircularProgressRing!
    
    
    @IBOutlet weak var imgArrow: UIImageView!
    var selectedIndex : Int? = nil
    var cellType: CellType = .MR
    var dcrCount : DcrCount!
    
    func setupUIforManager() {
        viewManager.layer.cornerRadius = 5
        callsTitleLbl.textColor = .appWhiteColor
        callsDescLbl.textColor = .appWhiteColor
        callsTitleLbl.setFont(font: .bold(size: .BODY))
        callsDescLbl.setFont(font: .medium(size: .BODY))
        callsIV.layer.cornerRadius = callsIV.height / 2
        viewManager.backgroundColor = self.dcrCount.color
        callsTitleLbl.text = "\(self.dcrCount.name)"
        callsDescLbl.text =  "\(dcrCount.callsCount)"
        imgArrow.tintColor = self.dcrCount.color
        callsIV.image =  self.dcrCount.image
    }
    
    
    
    func setupUIforMR() {
        viewDoctor.layer.cornerRadius = 5
        self.viewChart.startAngle = -90.0
        self.viewChart.isClockwise = true
        self.viewChart.font = UIFont(name: "Satoshi-Medium", size: 14)!
        self.viewChart.fontColor = .appWhiteColor
        if #available(iOS 13.0, *) {
            self.viewChart.outerRingColor = UIColor.systemGray4
        } else {
            self.viewChart.outerRingColor = UIColor.lightGray
            // Fallback on earlier versions
        }
        
        self.viewChart.innerRingColor = .appWhiteColor
        self.viewChart.innerRingWidth = 2.0
        self.viewChart.style = .bordered(width: 0.0, color: .black)
        self.viewChart.outerRingWidth = 1.0
        
        let part = dcrCount.callsCount
        let whole = self.dcrCount.count

        let percentage = (Double(part) / (Double(whole) ?? 0)) * 100
        print(percentage) // This will give you the percentage
 
        
        self.viewChart.maxValue = CGFloat(truncating: 100)
        
        self.viewChart.startProgress(to: CGFloat(truncating: percentage as NSNumber), duration: 0)
        imgArrow.tintColor = self.dcrCount.color
        viewDoctor.backgroundColor = self.dcrCount.color
        lblName.setFont(font: .bold(size: .BODY))
        lblCount.setFont(font: .medium(size: .BODY))
        lblName.textColor = .appWhiteColor
        lblCount.textColor = .appWhiteColor
        lblName.text = self.dcrCount.name
        lblCount.text = "\(dcrCount.callsCount) / "+"\(self.dcrCount.count)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // setCellType(cellType: self.cellType)
      
        
    }
    
    
}


