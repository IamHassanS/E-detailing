//
//  VisitsCountCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 22/12/23.
//

import UIKit


enum CellType: String {
    case All
    case Doctor
    case Chemist
    case Stockist
    case UnlistedDoctor
    case Hospital
    case CIP
    
    var coclor: UIColor {
        switch self {
            
        case .All:
            return .appTextColor
        case .Doctor:
            return .appGreen
        case .Chemist:
            return .appBlue
        case .Stockist:
            return .appLightPink
        case .Hospital:
            return .appBrown
        case .CIP:
            return .calenderMarkerColor
        case .UnlistedDoctor:
            return .appLightTextColor
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .All:
            return UIImage()
        case .Doctor:
            return UIImage(named: "ListedDoctor") ?? UIImage()
        case .Chemist:
            return UIImage(named: "Chemist") ?? UIImage()
        case .Stockist:
            return UIImage(named: "Stockist") ?? UIImage()
        case .Hospital:
            return UIImage(named: "hospital") ?? UIImage()
        case .CIP:
            return UIImage(named: "cip") ?? UIImage()
        case .UnlistedDoctor:
            return UIImage(named: "Doctor") ?? UIImage()
            
            
        }
    }
    
    var text: String {
        switch self {
            
        default:
            return self.rawValue
        }
    }
    
}

class VisitsCountCVC: UICollectionViewCell {

    

    @IBOutlet var visualBlurView: UIVisualEffectView!
    
    @IBOutlet var holderView: UIView!
    
    @IBOutlet var typesLbl: UILabel!
    @IBOutlet var countsLbl: UILabel!
    @IBOutlet var contsView: UIView!
    var type: CellType = .Doctor
    var selectedIndex: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func toPopulatecell() {
        holderView.layer.cornerRadius = 5
        contsView.layer.cornerRadius = contsView.height / 2
        countsLbl.setFont(font: .regular(size: .SMALL))
        countsLbl.textColor = .appWhiteColor
        typesLbl.setFont(font: .medium(size: .BODY))
        holderView.layer.cornerRadius = 4
       
        switch self.type {
            
        case .All:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .Doctor:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .Chemist:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .Stockist:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .Hospital:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .CIP:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = type.coclor
        case .UnlistedDoctor:
            visualBlurView.backgroundColor = type.coclor
            contsView.backgroundColor = type.coclor
            typesLbl.text = type.text
            typesLbl.textColor = .appTextColor
        }
        
    }

}
