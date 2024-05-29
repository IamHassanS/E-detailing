//
//  outboxCollapseTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/01/24.
//

import UIKit
protocol outboxCollapseTVCDelegate: AnyObject {
    func didTapRefresh(_ refreshIndex: Int)
}


class outboxCollapseTVC: UITableViewHeaderFooterView {

    @IBOutlet var backgroundVXview: UIVisualEffectView!
    @IBOutlet var refreshBtn: UIButton!
    @IBOutlet var headerRefreshView: UIView!
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var collapseIV: UIImageView!
    @IBOutlet var syncIV: UIImageView!
    @IBOutlet var vxView: UIVisualEffectView!
    @IBOutlet var dateLbl: UILabel!
     var delegate: CollapsibleTableViewHeaderDelegate?
     var refreshdelegate:  outboxCollapseTVCDelegate?
    var section: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        refreshBtn.setTitle("", for: .normal)
        headerRefreshView.layer.cornerRadius = 3
        seperatorView.backgroundColor = .appLightTextColor
        self.refreshBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        dateLbl.setFont(font: .bold(size: .BODY))
        dateLbl.textColor = .appTextColor
        vxView.backgroundColor = .appLightPink
        
    }
    
    @objc func buttonTapped() {
        print("Button tapped!")
        // Perform any actions you want when the button is tapped
        refreshdelegate?.didTapRefresh(self.section)
    }

    func populateCell() {
        
    }

    
}
