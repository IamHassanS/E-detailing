//
//  MainVC + TourplanEX.swift
//  SAN ZEN
//
//  Created by San eforce on 10/09/24.
//

import Foundation
extension MainVC {
    
    func findDateExistsinTPrange() -> Bool {
        
        if !isTPmandatoryNeeded {
            return false
        }
        
        let tpStartDate =  appSetups.tpstartDate ?? 0
        let tpEndDate = appSetups.tpEndDate ?? 0
        guard  tpStartDate != 0 && tpEndDate != 0 else { return false }
        
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.day], from: today)
        
        guard let day = components.day else  { return false }
        
        if day >= tpEndDate && isAllPlansApproved()  {
            return true
        }
        
        let range : Array<Int> = Array(tpStartDate...tpEndDate)
        
        if range.contains(where: { aDay in
            aDay == day && isAllPlansApproved()
        }) {
         return true
        }

        return false
    }
    
    func isAllPlansApproved() -> Bool {
        guard let tpApprovals = returnApprovals() else { return false }
         
        let approvedMonths = tpApprovals.filter { $0.approvalStatus == "3" }
         
         if approvedMonths.isEmpty {
             print("Non approved content exists")
             return false
         } else {
             return true
         }
    }
    
    func returnApprovals() ->  [SentToApprovalModel]? {

        do {
            // Read the data from the file URL
            let data = try Data(contentsOf:  SentToApprovalModelArr.ArchiveURL)
            
            // Attempt to unarchive EachDatePlan directly
            if let approvalModel = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data)  {
                
                if let approvalModel = approvalModel as? [SentToApprovalModel] {
                   // LocalStorage.shared.sentToApprovalModelArr = approvalModel
                    return approvalModel
                } else {
                    print("unable to convert to SentToApprovalModelArr")
                }
            } else {
                // Fallback to default initialization if unarchiving fails
                print("Failed to unarchive SentToApprovalModelArr: Data is nil or incorrect class type")
           
            }
        } catch {
            // Handle any errors that occur during reading or unarchiving
            print("Unable to unarchive: \(error)")
           
        }
        return nil
    }
    

}
