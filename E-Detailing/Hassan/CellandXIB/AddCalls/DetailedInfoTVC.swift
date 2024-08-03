//
//  DetailedInfoTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 25/04/24.
//

import UIKit

protocol DetailedInfoTVCDelegate: AnyObject {
    func didRatingAdded(rating: Float, index: Int)
}
 

class DetailedInfoTVC: UITableViewCell, RatingStarViewDelegate {
    func didRatingAdded(rating: Float) {
        self.delegate?.didRatingAdded(rating: rating, index: selectedIndex)
    }
    
    @IBOutlet var brandName: UILabel!
    
    @IBOutlet var reviewView: UIView!
    
    @IBOutlet var commentsIV: UIImageView!
    
    @IBOutlet var timeLine: UILabel!
    var selectedIndex: Int = 0
    var addedreviewView: RatingStarView?
    var delegate: DetailedInfoTVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
  
    }
    
    func setupUI(currentRating: Int, selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        addedreviewView = RatingStarView()
        addedreviewView?.currentRating = currentRating
        addedreviewView?.delegate = self
        addedreviewView?.prevValue(value: CGFloat(currentRating))
    }
    
    override func layoutSubviews() {
        addedreviewView?.frame = reviewView.bounds
        reviewView.addSubview(addedreviewView ?? RatingStarView())
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol RatingStarViewDelegate: AnyObject {
    func didRatingAdded(rating: Float)
}


class RatingStarView: UIView {
    
    var arrImageViews = [UIImageView]()
    let starStackView = UIStackView()
    var delegate: RatingStarViewDelegate?
    var currentRating: Int = 0
    var maxRating: Int = 5
    var minRating: Int = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Assuming you have a RatingStarView instance named ratingStarView
        self.handleTouchAtLocation(withTouches: touches)
    }
    
    // Custom initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStarStack()
        //setUpSwipeGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpStarStack()
    }
    
    private func setUpStarStack() {
        
        // Add items to stack view and apply constraints
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.alignment = .fill
        starStackView.spacing = 0
        starStackView.tag = 5007
        
        for i in 0...4 {
            let imageView = UIImageView()
            imageView.tintColor = .appYellow
            imageView.contentMode = .scaleAspectFit
           // imageView.image = UIImage(systemName: "star")
            if i == 0 {
                imageView.tag = 5009
            }
            starStackView.addArrangedSubview(imageView)
            arrImageViews.append(imageView)
        }
        
        addSubview(starStackView)
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: topAnchor),
            starStackView.leftAnchor.constraint(equalTo: leftAnchor),
            starStackView.widthAnchor.constraint(equalTo: widthAnchor),
            starStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
      
    }
    
    func prevValue(value: CGFloat) {
        let filledStarsCount = min(arrImageViews.count, Int(value))
        
        for (index, imageView) in arrImageViews.enumerated() {
            if index < filledStarsCount {
                imageView.image = UIImage(systemName: "star.fill")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }
    
    func handleTouchAtLocation(withTouches touches: Set<UITouch>) {
        guard let touchLocation = touches.first, touchLocation.view?.tag == 5007 else {
            return
        }
        
        let location = touchLocation.location(in: starStackView)
        var intRating: Int = currentRating
        
        for imageView in arrImageViews {
            imageView.tintColor = .appYellow
            
            if location.x > imageView.frame.origin.x {
                if let index = arrImageViews.firstIndex(of: imageView) {
                    intRating = index + 1
                    imageView.image = UIImage(systemName: "star.fill")
                }
            } else {
                if imageView.tag != 5009 {
                    //intRating -= 1
                    imageView.image = UIImage(systemName: "star")
                }
            }
        }
        
        delegate?.didRatingAdded(rating: Float(intRating))
    }


   
}

