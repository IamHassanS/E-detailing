//
//  OutboxDetailsTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/01/24.
//

import UIKit

protocol OutboxDetailsTVCDelegate: AnyObject {
    func didTapoutboxEdit(dcrCall: TodayCallsModel)
    func didTapOutboxDelete(dcrCall: TodayCallsModel)
    func didTapEventcaptureDelete(event: UnsyncedEventCaptureModel)
}



extension OutboxDetailsTVC: PopOverVCDelegate {
    
    func logoutAction() {
        print("Log out")
    }
    
    func changePasswordAction() {
        print("Change password")
    }
    
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int) {
        if index == 0 {
            if isForCallEdit {
                let model = self.todayCallsModel[SelectedArrIndex]
                self.delegate?.didTapoutboxEdit(dcrCall: model)
            } else {
                let model = self.eventCaptureModel[SelectedArrIndex]
                self.delegate?.didTapEventcaptureDelete(event: model)
            }
     
        }
        
        else if index == 1 {
            let model = self.todayCallsModel[SelectedArrIndex]
            self.delegate?.didTapOutboxDelete(dcrCall: model)
        }
    }
    
    
}

extension OutboxDetailsTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case dcrCallDetailsCollection:
            return self.todayCallsModel.count
        case dcrEventsDetailCollection:
            return self.eventCaptureModel.count
        default:
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CalldetailsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "CalldetailsCVC", for: indexPath) as! CalldetailsCVC
       

        switch collectionView {
        case dcrCallDetailsCollection:
            let callsmodel = self.todayCallsModel[indexPath.row]
            cell.topopulateCell(callsmodel)
            cell.optionsIV.addTap {
                print("Tapped -->")
                self.isForCallEdit = true
                let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 3, height: 90), on: cell.optionsIV, pagetype: .calls)
                 vc.delegate = self
                 vc.selectedIndex = indexPath.row
                self.viewController?.navigationController?.present(vc, animated: true)
            }
            
        case dcrEventsDetailCollection:
            var filteredcallsModelArr = [TodayCallsModel]()
            let eventsModelArr =  self.eventCaptureModel
            let callsmodelArr = self.todayCallsModel
            eventsModelArr.forEach { aEventCaptureModel in
               let filteredCalls = self.todayCallsModel.filter {$0.custCode == aEventCaptureModel.custCode}
                filteredcallsModelArr.append(contentsOf: filteredCalls)
            }
            let eventsmodel = eventsModelArr[indexPath.row]
            if callsmodelArr.isEmpty {
              
                cell.topopulateCell(eventsmodel, nil)
            } else {
                let callsmodel = callsmodelArr[indexPath.row]
                cell.topopulateCell(eventsmodel, callsmodel)
            }
        
            
            cell.eventOptionIV.addTap {
                print("Tapped -->")
                self.isForCallEdit = false
                let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: cell.width / 3, height: 50), on: cell.optionsIV, pagetype: .events)
                 vc.delegate = self
                 vc.selectedIndex = indexPath.row
                self.viewController?.navigationController?.present(vc, animated: true)
            }
        default:
            return UICollectionViewCell()
        }
        
        


        
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
        
        dcrEventsDetailCollection.delegate = self
        dcrEventsDetailCollection.dataSource = self
        dcrEventsDetailCollection.reloadData()
        
    }
    
    enum cellState {
        case callsExpanded
        case callsNotExpanded

    }
    
    enum EventState {
        case eventExpanded
        case eventNotExpanded
    }
    var isForCallEdit: Bool = false
    var callsExpandState: cellState = .callsNotExpanded
    var eventExpandState: EventState = .eventNotExpanded
    var viewController: UIViewController?
    var delegate: OutboxDetailsTVCDelegate?
    var eventCaptureModel: [UnsyncedEventCaptureModel] = []
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
    
    @IBOutlet var eventsViewSeperator: UIView!
    @IBOutlet var eventsHolderViewHeightConst: NSLayoutConstraint!
    @IBOutlet var eventsDetailStackHeightConst: NSLayoutConstraint!
    @IBOutlet var eventsSubdetailVIew: UIView!
    
    @IBOutlet var dcrEventsDetailCollection: UICollectionView!
    @IBOutlet var eventSubdetailHeightConst: NSLayoutConstraint!
    @IBOutlet var eventsOverallInfoVIew: UIView!
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
        
        dcrEventsDetailCollection.register(UINib(nibName: "CalldetailsCVC", bundle: nil), forCellWithReuseIdentifier: "CalldetailsCVC")
        dcrEventsDetailCollection.isScrollEnabled = false
        
    }
    
    func toSetEventsCellheight(callsExpandState: EventState) {
        let count = self.todayCallsModel.count
        let eventsCount = self.eventCaptureModel.count
      
        switch callsExpandState {
        case .eventExpanded:
            self.eventExpandState = callsExpandState
            cellStackHeightConst.constant = CGFloat(290 + 90 * eventsCount)
            eventsSubdetailVIew.isHidden = false
            eventSubdetailHeightConst.constant = CGFloat(90 * eventsCount)
            eventsDetailStackHeightConst.constant = CGFloat(50 + 90 * eventsCount)
            eventsHolderViewHeightConst.constant = CGFloat(50 + 90 * eventsCount)
            eventsViewSeperator.isHidden = false
            
        case .eventNotExpanded:
           
            if self.callsExpandState == .callsExpanded {
                cellStackHeightConst.constant = CGFloat(290 + 90 * count)
            } else if self.callsExpandState == .callsNotExpanded {
                cellStackHeightConst.constant = 290
            }
           
            eventsSubdetailVIew.isHidden = true
            eventSubdetailHeightConst.constant = 0
            eventsHolderViewHeightConst.constant = 50
            eventsDetailStackHeightConst.constant = 50
            eventsViewSeperator.isHidden = true

        }
        
        eventCollapseIV.image = callsExpandState == .eventNotExpanded ? UIImage(named: "chevlon.expand") : UIImage(named: "chevlon.collapse")
    }
    
    
    func toSetCallsCellHeight(callsExpandState: cellState) {
        let count = self.todayCallsModel.count
        let eventsCount = self.eventCaptureModel.count
        switch callsExpandState {
        case .callsExpanded:
            self.callsExpandState = callsExpandState
            cellStackHeightConst.constant = CGFloat(290 + 90 * count)
            callSubDetailVIew.isHidden = false
            callSubdetailHeightConst.constant = CGFloat(90 * count)
            callDetailStackHeightConst.constant = CGFloat(50 + 90 * count)
            callsHolderViewHeightConst.constant = CGFloat(50 + 90 * count)
            callsViewSeperator.isHidden = false
            
            //hide Event
            //toSetEventsCellheight(callsExpandState: .callsNotExpanded)
            
        case .callsNotExpanded:
            self.callsExpandState = callsExpandState
            if self.eventExpandState == .eventExpanded {
                cellStackHeightConst.constant = CGFloat(290 + 90 * eventsCount)
                
            } else if  self.eventExpandState == .eventNotExpanded {
                cellStackHeightConst.constant = 290
            }
            
            callSubDetailVIew.isHidden = true
            callSubdetailHeightConst.constant = 0 //90
            callsHolderViewHeightConst.constant = 50
            callDetailStackHeightConst.constant = 50
            callsViewSeperator.isHidden = true
            
            //hide event


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
        
      
//        callDCRinfoLbl.textColor  = .appTextColor
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
