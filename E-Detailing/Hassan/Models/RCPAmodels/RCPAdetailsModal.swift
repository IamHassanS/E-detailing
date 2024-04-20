//
//  RCPAdetailsModal.swift
//  E-Detailing
//
//  Created by San eforce on 27/03/24.
//

import Foundation

struct AdditionalCompetitorsInfo {
    var competitor: Competitor?
    var qty: String?
    var remarks: String?
    var rate: String?
    var value: String?
}

struct ProductWithCompetiors {
    var addedProduct : Product?
  //  var competitor: [Competitor]?
    var competitorsInfo: [AdditionalCompetitorsInfo]?
    
//    mutating func removeCompetitorInfo(forCompetitor competitor: Competitor) {
//        // Remove any AdditionalCompetitorsInfo associated with the given competitor
//        competitorsInfo?.removeAll { $0.competitor?.ourProductCode == competitor.ourProductCode }
//    }
//    
//    mutating func addCompetitorInfoIfNeeded(_ competitorInfo: AdditionalCompetitorsInfo) {
//        guard let competitor = competitorInfo.competitor else {
//            return // Exit early if competitor is nil
//        }
//
//        // Check if the competitor already exists in the competitor array
//        guard let existingCompetitors = self.competitor, let index = existingCompetitors.firstIndex(where: { $0.ourProductCode == competitor.ourProductCode }) else {
//            // Competitor doesn't exist, add new competitor info
//            if competitorsInfo == nil {
//                competitorsInfo = [competitorInfo]
//            } else {
//                competitorsInfo?.append(competitorInfo)
//            }
//            return
//        }
//
//        // Replace the existing competitor info with the new one
//        
//        // Replace the existing competitor info with the new one if index is valid, otherwise append
//        if var competitorsInfo = competitorsInfo, index < competitorsInfo.count {
//            competitorsInfo[index] = competitorInfo
//        } else {
//            competitorsInfo?.append(competitorInfo)
//        }
//    }
}



struct ProductDetails {
    var addedProduct: [ProductWithCompetiors]?
    var addedQuantity: [String]?
    var addedRate: [String]?
    var addedValue: [String]?
    var addedTotal: [String]?
}

 class RCPAdetailsModal  {
    
    var addedChemist: Chemist?
    var addedProductDetails : ProductDetails?
  //  var competitor: [Competitor]?
    var totalValue: String?
    
    init() {
    addedChemist = Chemist()

    addedProductDetails = ProductDetails()
 //   competitor = [Competitor]()

        
        
    }
    
    func summonedTotal(rate: String, quantity: String) -> String {
    let rateInt: Int = Int(rate) ?? 0
        let intQuantity: Int = Int(quantity) ?? 0
        
        return "\(rateInt * intQuantity)"
    }
    
}
