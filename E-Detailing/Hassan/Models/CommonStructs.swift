//
//  CommonStructs.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 14/02/24.
//

import Foundation
import UIKit


struct LocationInfo {
    let latitude: Double
    let longitude: Double
    let address: String
}

struct QuicKLink {
    
    var color : UIColor
    var name : String
    var image : UIImage
}


struct DcrCount {
    
    var name : String
    var color : UIColor
    var count : String
    var image: UIImage
    var callsCount : Int
}


struct Section {
    var date: String
    var items: [TodayCallsModel]
    var eventCaptures: [UnsyncedEventCaptureModel]
    var myDayplans: [Sessions]
    var dayStatus: [EachDayStatus]
    var isCallExpanded: Bool
    var isEventEcpanded: Bool
    var collapsed: Bool
    var isLoading = Bool()
    
    init(items: [TodayCallsModel] , eventCaptures: [UnsyncedEventCaptureModel], collapsed: Bool = true, isCallExpanded: Bool = false, isEventEcpanded: Bool = false, date: String, sessions: [Sessions], eachDayStatus: [EachDayStatus]) {
    self.items = items
    self.collapsed = collapsed
    self.isCallExpanded = isCallExpanded
    self.date = date
    self.eventCaptures = eventCaptures
    self.isEventEcpanded = isEventEcpanded
    self.myDayplans = sessions
        self.dayStatus = eachDayStatus
  }
}
    
var obj_sections : [Section] = []

protocol CollapsibleTableViewHeaderDelegate {

    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0

    let titleLabel = UILabel()
    let arrowLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
    
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.frame = CGRect(x: 250, y: 15, width: 100, height: 20)
        arrowLabel.textColor = UIColor.black
        arrowLabel.font = UIFont(name: "Satoshi-Bold", size: 15)

        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.frame = CGRect(x: 20, y: 15, width: 150, height: 20)
        titleLabel.font = UIFont(name: "Satoshi-Bold", size: 15)

        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
        
    }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
