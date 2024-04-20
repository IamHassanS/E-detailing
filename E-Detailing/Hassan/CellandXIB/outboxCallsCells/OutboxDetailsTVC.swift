//
//  OutboxDetailsTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/01/24.
//

import UIKit

extension OutboxDetailsTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayCallsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalldetailsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "CalldetailsCVC", for: indexPath) as! CalldetailsCVC
        let model = self.todayCallsModel[indexPath.row]
        cell.topopulateCell(model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 90)
    }
    
}

class OutboxDetailsTVC: UITableViewCell {
    
    func toLoadData() {
        dcrCallDetailsCollection.delegate = self
        dcrCallDetailsCollection.dataSource = self
        dcrCallDetailsCollection.reloadData()
    }
    
    enum cellState {
        case callsExpanded
        case callsNotExpanded
        case eventExpanded
        case eventNotExpanded
    }
    
    var callsExpandState: cellState = .callsNotExpanded
    var eventExpandState: cellState = .eventNotExpanded
    var todayCallsModel: [TodayCallsModel] = []  {
        didSet {
            let intime = self.todayCallsModel.first?.vstTime ?? ""
            
            let inDateStr = intime.toDate(format: "yyyy-MM-dd HH:mm:ss")
            
           
            
            checkinLbl.text =  "Check IN - \(inDateStr.toString(format: "hh:mm a"))"
            
            
            let outtime = self.todayCallsModel.last?.vstTime ?? ""
            let outDateStr = outtime.toDate(format: "yyyy-MM-dd HH:mm:ss")
            checkoutinfoLbl.text = "Check OUT - \(outDateStr.toString(format: "hh:mm a"))"
        }
    }
    
    @IBOutlet var dcrCallDetailsCollection: UICollectionView!
    
    
///Stack
    @IBOutlet var cellStackHeightConst: NSLayoutConstraint!
    @IBOutlet var cellStack: UIStackView!
    
///Checkin
    @IBOutlet var checkinVIew: UIView!
    @IBOutlet var checkinRefreshVIew: UIView!
    @IBOutlet var checkinLbl: UILabel!
    
///Workplan
    @IBOutlet var workPlanView: UIView!
    
    @IBOutlet var workPlanRefreshView: UIView!
    
    @IBOutlet var workPlanTitLbl: UILabel!
    ///Calls
    @IBOutlet var callsoverallInfoVIew: UIView!
    
    @IBOutlet var callsOverallinfoVIewHeightConst: NSLayoutConstraint! // 50 always
    
    @IBOutlet var callsHolderViewHeightConst: NSLayoutConstraint! //50 when collapsed, 50 + (90 * count) while expanded
    
    @IBOutlet var callCountVXview: UIVisualEffectView!
    @IBOutlet var callDetailStackHeightConst: NSLayoutConstraint! // //50 when collapsed, 50 + (90 * count) while expanded
    
    @IBOutlet var callSubDetailVIew: UIView!
    
    @IBOutlet var callSubdetailHeightConst: NSLayoutConstraint! //0 when collapsed, 90 * count when expanded
    
    
    
    @IBOutlet var callDetailView: UIView!
    
    @IBOutlet var callCountHolderView: UIView!
    
    @IBOutlet var callsRefreshVIew: UIView!
    
    @IBOutlet var callsCollapseView: UIView!
    
    @IBOutlet var callsCollapseIV: UIImageView!
    
    @IBOutlet var callsCountLbl: UILabel!
    @IBOutlet var callsTitLbl: UILabel!
    
    @IBOutlet var callsViewSeperator: UIView!
    
    
    //Event Capture
    
    @IBOutlet var eventscountVxview: UIVisualEffectView!
    @IBOutlet var eventCaptureVIew: UIView!
    
    
    @IBOutlet var eventTitLbl: UILabel!
    
    @IBOutlet var eventCOuntLbl: UILabel!
    
    @IBOutlet var eventCountVIew: UIView!
    
    @IBOutlet var eventRefreshView: UIView!
    
    @IBOutlet var eventCollapseView: UIView!
    
    @IBOutlet var eventCollapseIV: UIImageView!
    
    
    //Checkout
    
    @IBOutlet var checkoutVIew: UIView!
    @IBOutlet var checkoutRefreshView: UIView!
    
    @IBOutlet var checkoutinfoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        cellRegistration()
        //toLoadData()
        // Initialization code
    }
    
    func cellRegistration() {
        dcrCallDetailsCollection.register(UINib(nibName: "CalldetailsCVC", bundle: nil), forCellWithReuseIdentifier: "CalldetailsCVC")
    }
    
    
    func toSetCellHeight(callsExpandState: cellState) {
        let count = self.todayCallsModel.count
        switch callsExpandState {
        case .callsExpanded:
            self.callsExpandState = callsExpandState
            cellStackHeightConst.constant = CGFloat(290 + 90 * count)
            callSubDetailVIew.isHidden = false
            callSubdetailHeightConst.constant = 90 * 2
            callDetailStackHeightConst.constant = CGFloat(50 + 90 * count)
            callsHolderViewHeightConst.constant = CGFloat(50 + 90 * count)
            callsViewSeperator.isHidden = false
        case .callsNotExpanded:
            self.callsExpandState = callsExpandState
            cellStackHeightConst.constant = 290
            callSubDetailVIew.isHidden = true
            callSubdetailHeightConst.constant = 0 //90
            callsHolderViewHeightConst.constant = 50
            callDetailStackHeightConst.constant = 50
            callsViewSeperator.isHidden = true
        case .eventExpanded:
            print("Yet to implement")
        case .eventNotExpanded:
            print("Yet to implement")
        }
        callsCollapseIV.image = callsExpandState == .callsNotExpanded ? UIImage(named: "chevlon.expand") : UIImage(named: "chevlon.collapse")
    }
    
    func setupUI() {
     //   setupHeight(.callsNotExpanded)
        let titLbls : [UILabel] = [checkinLbl, workPlanTitLbl, callsTitLbl, eventTitLbl, checkoutinfoLbl]
        
        titLbls.forEach { lbl in
            lbl.setFont(font: .bold(size: .BODY))
            lbl.textColor = .appTextColor
        }
        
        let refreshViews : [UIView] = [checkinRefreshVIew, checkoutRefreshView, checkoutRefreshView, workPlanRefreshView, callsRefreshVIew]
        
        refreshViews.forEach { view in
            view.layer.cornerRadius = 3
        }
        
        let elevateViews: [UIView] = [checkinVIew, workPlanView, callDetailView, eventCaptureVIew, checkoutVIew]
        
        elevateViews.forEach { view in
            view.backgroundColor = .appGreyColor
            view.layer.cornerRadius = 5
        }
        
        callCountHolderView.layer.cornerRadius = 3
        callCountVXview.backgroundColor = .appGreyColor
        eventscountVxview.backgroundColor = .appGreyColor
        
        
        callsCountLbl.setFont(font: .medium(size: .BODY))
        eventCOuntLbl.setFont(font: .medium(size: .BODY))
        
        callsCountLbl.textColor = .appTextColor
        eventCOuntLbl.textColor = .appTextColor
        
//        callDCRinfoLbl.textColor = .appTextColor
//        callDCRinfoLbl.setFont(font: .medium(size: .BODY))
        
        
//        timeinfoLbl.textColor = .appLightTextColor
//        timeinfoLbl.setFont(font: .medium(size: .SMALL))
        
        
//        callStatusLbl.setFont(font: .medium(size: .BODY))
        
//        callststusView.layer.cornerRadius = 3
//        callStatusVxVIew.backgroundColor = .appLightPink
//        callStatusLbl.textColor = .appLightPink
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
