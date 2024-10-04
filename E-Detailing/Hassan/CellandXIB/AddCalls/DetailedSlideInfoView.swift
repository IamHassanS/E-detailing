//
//  DetailedSlideInfoView.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 25/04/24.
//

import Foundation
import UIKit

protocol DetailedSlideInfoViewDelegate: AnyObject {
    func didCommentTapped(comments: String, index: Int)
    func didRatingTapped(rating: Int, index: Int)
    
}

extension DetailedSlideInfoView: DetailedInfoTVCDelegate {
    func didRatingAdded(rating: Float, index: Int) {
        self.delegate?.didRatingTapped(rating: Int(rating), index: index)
    }
}

extension DetailedSlideInfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.instance.detailedSlides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailedInfoTVC = tableView.dequeueReusableCell(withIdentifier: "DetailedInfoTVC", for: indexPath) as! DetailedInfoTVC
        let model =  Shared.instance.detailedSlides[indexPath.row]
        let name =  model.slidesModel?.name
        if let brand = model.brand as? Brand {
            cell.brandName.text = brand.name
        } else {
            cell.brandName.text = name
        }
       
        cell.delegate = self
        cell.commentsIV.alpha = model.remarks == nil || model.remarks == "" ? 0.5 : 1
        cell.commentsIV.tintColor = model.remarks == nil || model.remarks == "" ?  .label : .appLightPink
        cell.setupUI(currentRating: Int(model.remarksValue ?? 0), selectedIndex: indexPath.row)
        let startTimeStr = model.startTime ?? ""
        let endtimeStr = model.endTime ?? ""
        let startTime = startTimeStr.toDate()
        let endTime = endtimeStr.toDate()
        cell.timeLine.text = "\(startTime.toString(format: "HH:mm:ss", timeZone: nil)) - \(endTime.toString(format: "HH:mm:ss", timeZone: nil))"
       // let remarksStr =   Shared.instance.detailedSlides[indexPath.row].remarks
        cell.commentsIV.addTap {
            self.delegate?.didCommentTapped(comments: model.remarks ?? "", index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = detailedInfoTable.dequeueReusableHeaderFooterView(withIdentifier: "DetailedInfoHeader") as? DetailedInfoHeader else {
 
            return UIView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 10
    }
}
 
class DetailedSlideInfoView: UIView {
    
    @IBOutlet var detailedInfoTable: UITableView!
    var delegate: DetailedSlideInfoViewDelegate?
    var detailedSlides : [DetailedSlide] = Shared.instance.detailedSlides
    func setupui() {
        self.backgroundColor = .clear
        self.detailedInfoTable.layer.cornerRadius = 5
        toGroupSlidesbrandWise()
        cellRegistration()
        toLoadData()

       
    }
    
    
    func toGroupSlidesbrandWise() {
        
        var capturedBrandWiseGroupedSlides = [Int: [DetailedSlide]]()

        detailedSlides.forEach { aDetailedSlide in
            if let brandCode = aDetailedSlide.brandCode {
                if var slidesArray = capturedBrandWiseGroupedSlides[brandCode] {
                    slidesArray.append(aDetailedSlide)
                    capturedBrandWiseGroupedSlides[brandCode] = slidesArray
                } else {
                    capturedBrandWiseGroupedSlides[brandCode] = [aDetailedSlide]
                }
            }
        }
        let brands = capturedBrandWiseGroupedSlides.count
        
        
        var brandWiseCategorizedSlides = [DetailedSlide]()
        var startTime: [String] = []
        var endTime: [String] = []
        for (brandCode, detailedSlide) in capturedBrandWiseGroupedSlides {
           
            
            // Find the minimum start time and maximum end time
            let startTimes = detailedSlide.compactMap { $0.startTime }
            let endTimes = detailedSlide.compactMap { $0.endTime }
            let startRawTimes : [Date] = startTimes.map { aString in
               let date = aString.toDate()
                return date
            }
            let endRawTimes : [Date] = endTimes.map { aString in
               let date = aString.toDate()
                return date
            }
            
//  startRawTimes.min()
 //     endTimes.max()
     
            
            var aDetailedSlide = DetailedSlide()
            var filteredBrand : Brand?
            if let cachedetailedSlide = detailedSlide.first {
                aDetailedSlide = cachedetailedSlide
                let cacheBrand = DBManager.shared.getBrands()
                filteredBrand = cacheBrand.filter{ $0.code ==  "\(cachedetailedSlide.brandCode ?? 0)" }.first
                aDetailedSlide.startTime =  startRawTimes.min()?.toString(format: "yyyy-MM-dd HH:mm:ss")
                //cachedetailedSlide.startTime
            }
            aDetailedSlide.endTime = endRawTimes.max()?.toString(format: "yyyy-MM-dd HH:mm:ss")
//            if let lastSlide = detailedSlide.last {
//                aDetailedSlide.endTime = lastSlide.endTime
//            }
 
            var groupedSlide = [SlidesModel]()
            
            detailedSlide.forEach { cacheSlides in
                if let slidesModel = cacheSlides.slidesModel {
                    slidesModel.slideData = Data()
                    groupedSlide.append(slidesModel)
                }
            }
        
            aDetailedSlide.groupedSlides = groupedSlide
            aDetailedSlide.brand = filteredBrand
            brandWiseCategorizedSlides.append(aDetailedSlide)
        }
         dump(brandWiseCategorizedSlides)
        Shared.instance.detailedSlides = brandWiseCategorizedSlides
      
    }

    
    func toLoadData() {
        detailedInfoTable.delegate = self
        detailedInfoTable.dataSource = self
        detailedInfoTable.reloadData()
    }
    
    func cellRegistration() {
        self.detailedInfoTable.register(UINib(nibName: "DetailedInfoHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DetailedInfoHeader")
        self.detailedInfoTable.register(UINib(nibName: "DetailedInfoTVC", bundle: nil), forCellReuseIdentifier: "DetailedInfoTVC")
        
    }
    
}
