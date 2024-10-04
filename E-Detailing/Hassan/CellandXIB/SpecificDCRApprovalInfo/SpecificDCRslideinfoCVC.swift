//
//  SpecificDCRslideinfoCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/07/24.
//

import UIKit

class SpecificDCRslideinfoCVC: UICollectionViewCell, RatingStarViewDelegate {

    func didRatingAdded(rating: Float) {
        print("Yet to")
    }
    
    
    @IBOutlet var brandNamelbl: UILabel!
    @IBOutlet var reviewView: UIView!
    @IBOutlet var feedbacView: UIView!
    var selectedIndex: Int = 0
    @IBOutlet var timeline: UILabel!
    var addedreviewView: RatingStarView?
    
    @IBOutlet var infoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeline.textColor = .appBlue
        
    }
    
    func populateCell(model: SlideDetailsResponse) {
        addedreviewView?.isUserInteractionEnabled = false
        brandNamelbl.text = model.productName
       // feedbackLbl.text = model.feedback
        let endTime = model.endTime.toDate()
        let startTime = model.startTime.toDate()
        
        let timeDifference = endTime.timeIntervalSince(startTime)
        let minutes = Int(timeDifference / 60) % 60
        let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))

        //return
        timeline.text = String(format: "%02d:%02d", minutes, seconds)
        
     
        //"\(endTime.toString()) - \(startTime.toString())"
       
    }
    
    override func layoutSubviews() {
        addedreviewView?.frame = reviewView.bounds
    
    }
    
    func setupUI(currentRating: Int, selectedIndex: Int) {
       
        self.selectedIndex = selectedIndex
        addedreviewView = RatingStarView()
        addedreviewView?.currentRating = currentRating
        addedreviewView?.delegate = self
        addedreviewView?.prevValue(value: CGFloat(currentRating))
        self.contentView.subviews.forEach { aUIView in
            if aUIView == addedreviewView {
                addedreviewView?.removeFromSuperview()
            }
        }
        reviewView.addSubview(addedreviewView ?? RatingStarView())
    }


}
