//
//  CalldetailsCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 18/01/24.
//

import UIKit

extension CalldetailsCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let  model = self.unsuncedModel, let capturedEvents = model.capturedEvents else {return 0}
        if capturedEvents.count >= 4 {
            return 4
        } else {
            return capturedEvents.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let  model = self.unsuncedModel, let capturedEvents = model.capturedEvents else {return UICollectionViewCell()}
        let cell: UnsyncedEventsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "UnsyncedEventsCVC", for: indexPath) as!  UnsyncedEventsCVC
        switch indexPath.row {
        case 3:
            cell.captureIV.isHidden = true
            cell.countsView.isHidden = false
            cell.countsLbl.text = "+" + "\(capturedEvents.count - 3)"
            cell.countsView.layer.cornerRadius = 2
            return cell
        default:
            cell.captureIV.layer.cornerRadius = 2
            cell.countsView.isHidden = true
            cell.captureIV.isHidden = false
            let model = capturedEvents[indexPath.item]
            cell.captureIV.image = model.image
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let  model = self.unsuncedModel, let capturedEvents = model.capturedEvents else {return CGSize()}
        if capturedEvents.count == 1 {
            return CGSize(width: collectionView.width, height: collectionView.height)
        }   else if capturedEvents.count == 2 {
            return CGSize(width: collectionView.width / 2, height: collectionView.height)
        } else {
            return CGSize(width: collectionView.width / 2, height: collectionView.height / 2)
        }
     
    }
    
    
}

class CalldetailsCVC: UICollectionViewCell {
    @IBOutlet var callSubDetailVIew: UIView!
    @IBOutlet var callSubdetailHeightConst: NSLayoutConstraint! //90
    
    @IBOutlet var eventsStack: UIStackView!
    @IBOutlet var viewEvents: UIView!
    @IBOutlet var eventsCollection: UICollectionView!
    
    @IBOutlet var eventOptionIV: UIImageView!
    @IBOutlet var eventsName: UILabel!
    
    @IBOutlet var eventsDesc: UILabel!
    
    @IBOutlet var eventsStatus: UILabel!
    
    @IBOutlet var eventStatusVIew: UIView!
    @IBOutlet var callStack: UIStackView!
    @IBOutlet var optionsIV: UIImageView!
    @IBOutlet var optionsHolderView: UIView!
    @IBOutlet var callsDCR_IV: UIImageView!
    
  
    @IBOutlet var viewCalls: UIView!
    @IBOutlet var callDCRinfoLbl: UILabel!
    
    @IBOutlet var timeinfoLbl: UILabel!
    
    @IBOutlet var callStatusLbl: UILabel!
    
 
    @IBOutlet var callStatusVxVIew: UIVisualEffectView!
    var unsuncedModel: UnsyncedEventCaptureModel?
    var todayCallsModel: TodayCallsModel?
    @IBOutlet var statusView: UIView!
    
    func toLoadCollection() {
        eventsCollection.delegate = self
        eventsCollection.dataSource = self
        eventsCollection.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // eventOptionIV.isHidden = false
                if let layout = self.eventsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.collectionView?.isScrollEnabled = true
        
                }
        // Initialization code
        eventsCollection.register(UINib(nibName: "UnsyncedEventsCVC", bundle: nil), forCellWithReuseIdentifier: "UnsyncedEventsCVC")
        
        callStatusVxVIew.backgroundColor = .appLightPink
        callDCRinfoLbl.setFont(font: .medium(size: .BODY))
        callDCRinfoLbl.textColor = .appTextColor
        timeinfoLbl.setFont(font: .medium(size: .SMALL))
        timeinfoLbl.textColor = .appLightTextColor
        callStatusLbl.setFont(font: .bold(size: .BODY))
        callStatusLbl.textColor = .appLightPink
        statusView.layer.cornerRadius = 3
        
        eventStatusVIew.layer.cornerRadius = 3
        eventsStatus.textColor = .appLightPink
        eventsStatus.setFont(font: .bold(size: .BODY))
        eventsDesc.setFont(font: .medium(size: .SMALL))
        eventsName.setFont(font: .medium(size: .BODY))
    }
    
    
    func topopulateCell(_ model: UnsyncedEventCaptureModel, _ todaysmodel: TodayCallsModel?) {
        self.unsuncedModel = model
        self.todayCallsModel = todaysmodel
        toLoadCollection()
        callStack.isHidden = true
        eventsStack.isHidden = false
        if let todaysmodel = todaysmodel {
            eventsName.text = "\(todaysmodel.name)(\(todaysmodel.designation))"
        } else {
            eventsName.text = ""
        }
       
        guard let capturedEvents = model.capturedEvents else {return}
        eventsDesc.text = "\(capturedEvents.count)" + " events not synced"
        eventsStatus.text = "Waiting to sync"
    }
    
    func topopulateCell(_ model: TodayCallsModel) {
        callStack.isHidden = false
        eventsStack.isHidden = true
        callDCRinfoLbl.text = "\(model.name)"
        timeinfoLbl.text = model.vstTime.toDate(format: "yyyy-MM-dd HH:mm:ss").toString(format: "MMM d, h:mm a")
        callStatusLbl.text = model.submissionStatus
        if model.designation == "Doctor" {
            callsDCR_IV.image = UIImage(named: "ListedDoctor")
        } else if model.designation == "Chemist" {
            callsDCR_IV.image = UIImage(named: "Chemist")
        } else if model.designation == "CIP" {
            callsDCR_IV.image = UIImage(named: "cip")
        } else if model.designation == "UnlistedDr." {
            callsDCR_IV.image = UIImage(named: "Doctor")
        } else if model.designation == "hospital" {
            callsDCR_IV.image = UIImage(named: "hospital")
        } else if model.designation == "Stockist" {
            callsDCR_IV.image = UIImage(named: "Stockist")
        }
        
    }

}
