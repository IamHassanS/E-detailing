//
//  Login.swift
//  E-Detailing
//
//  Created by SANEFORCE on 16/06/23.
//

import Foundation


//struct AppSetUp {
//    
//    var activityNeed : Int!
//    var androidApp : Int!
//    var androidDetailing : Int!
//    var apprMandatoryNeed : Int!
//    var approvalNeed : Int!
//    var attendance : Int!
//    var appDeviceId : String!
//    
//    var callFeedEnterable : Int!
//    var callReport : String!
//    var callReportFromDate : String!
//    var callReportToDate : String!
//    var chmAdQty : Int!
//    var chmSampleQtyNeed : Int!
//    var cipNeed : Int!
//    var circular : Int!
//    var cntRemarks : Int!
//    var currentDay : Int!
//    var ceNeed : Int!
//    var cfNeed : Int!
//    var cheBase :Int!
//    var ciNeed : Int!
//    var cipPobMdNeed : Int!
//    var cipPobNeed : Int!
//    var cipCaption : String!
//    var cipENeed : Int!
//    var cipFNeed : Int!
//    var cipINeed : Int!
//    var cipPNeed : Int!
//    var cipQNeed :Int!
//    var cipJointWrkNeed : Int!
//    var cpNeed : Int!
//    var cqNeed : Int!
//    var campNeed : Int!
//    var catNeed : Int!
//    var chmCap : String!
//    var chmEventMdNeed : Int!
//    var chmNeed : Int!
//    var chmQcap :String!
//    var chmRcpaCompetitorNeed : Int!
//    var chmRxQtyNeed : Int!
//    var chmSampleCap : String!
//    var chmInputCaption : String!
//    var chmPobMandatoryNeed : Int!
//    var chmPobNeed : Int!
//    var chmProductCaption : String!
//    var chmRcpaNeed : Int!
//    var chmClusterBased :Int!
//    var chmJointWrkMdNeed : Int!
//    var chmJointWrkNeed : Int!
//    var cipEventMdNeed : Int!
//    var cipSrtNd : Int!
//    var clusterCap : String!
//    var cmpgnNeed : Int!
//    var currentdayTpPlanned : Int!
//    var custSrtNeed : Int!
//    
//    var deNeed : Int!
//    var dfNeed :Int!
//    var diNeed : Int!
//    var dpNeed : Int!
//    var dqNeed : Int!
//    var dsName : String!
//    var dcrLockDays : Int!
//    var dcrFirstSelfieNeed : Int!
//    var desig : String!
//    var detailingChem : Int!
//    var detailingType :Int!
//    var deviceIdNeed : Int!
//    var deviceRegId : String!
//    var disRad : String!
//    var divisionCode : String!
//    var dlyCtrl : Int!
//    var docInputCaption : String!
//    var docPobMandatoryNeed : Int!
//    var docPobNeed : Int!
//    var docProductCaption :String!
//    var docClusterBased : Int!
//    var docJointWrkMdNeed :Int!
//    var docJointWrkNeed : Int!
//    var docCap : String!
//    var docEventMdNeed : Int!
//    var docFeedMdNeed : Int!
//    var docInputMdNeed : Int!
//    var docNeed : Int!
//    var docProductMdNeed : Int!
//    var docRcpaCompetitorNeed : Int!
//    var docRcpaQMdNeed : Int!
//    var docRxNeed :Int!
//    var docRxQCap : String!
//    var docRxQMd :Int!
//    var docSampleNeed : Int!
//    var docSampleQCap : String!
//    var docSampleQMdNeed : Int!
//    var dashboard : Int!
//    var dayplanTpBased : Int!
//    var days : Int!
//    var dcrDocBusinessProduct : Int!
//    var desigCode : String!
//    var docBusinessProduct : Int!
//    var docBusinessValue : Int!
//    var doctorDobDow : Int!
//    
//    var expenceNeed : Int!
//    var expenceMdNeed : Int!
//    var expenseNeed : Int!
//    var editHoliday : Int!
//    var editWeeklyOff : Int!
//    var entryformMgr : Int!
//    var entryFormNeed : Int!
//    var expense_Need : Int!
//    
//    var faq : Int!
//    
//    var geoTagNeed : Int!
//    var geoTagNeedChe : Int!
//    var geoTagNeedStock :Int!
//    var geoTagNeedUnList : Int!
//    var geoCheck :Int!
//    var geoNeed : Int!
//    var geoTagNeedCip : Int!
//    var gstOption : Int!
//    var geoTagImg : Int!
//    
//    var heNeed : Int!
//    var hfNeed : Int!
//    var hiNeed : Int!
//    var hpNeed : Int!
//    var hqName : String!
//    var hqNeed :Int!
//    
//    var hosPobMdNeed : Int!
//    var hosPobNeed :Int!
//    var hospEventNeed : Int!
//    var hospCaption : String!
//    var hospNeed : Int!
//    
//    
//    var inputValQty : Int!
//    var inputValidation : Int!
//    var leaveStatus : Int!
//    var leaveEntitlementNeed : Int!
//    var locationTrack : Int!
//    var iosApp : Int!
//    var iosDetailing : Int!
//    
//    
//    var mclDet : Int!
//    var mgrHlfDy : Int!
//    var mrHlfDy : Int!
//    var msdEntry :Int!
//    var mailNeed : Int!
//    var miscExpenseNeed : Int!
//    var missedDateMdNeed : Int!
//    var multiClusterNeed : Int!
//    var multipleDocNeed : Int!
//    var mydayplanNeed : Int!
//    var myPlnRmrksMand : Int!
//    
//    var neNeed : Int!
//    var nfNeed :Int!
//    var niNeed : Int!
//    var nlCap : String!
//    var nlRxQCap : String!
//    var nlSampleQCap : String!
//    var npNeed : Int!
//    var nqNeed : Int!
//    var nextVst : Int!
//    var nextVstMdNeed : Int!
//    var noOfTpView :Int!
//    
//    var orderCaption : String!
//    var orderManagement :Int!
//    var otherNeed : Int!
//    
//    var primaryOrder : Int!
//    var primaryOrderCap : String!
//    var prodStkNeed : Int!
//    var productRateEditable : Int!
//    var pwdSetup : Int!
//    var pastLeavePost : Int!
//    var pobMinValue : Int!
//    var productFeedBack : Int!
//    var primarySecNeed : Int!
//    var proDetNeed : Int!
//    var prodDetNeed : Int!
//    var productRemarkNeed : Int!
//    var productRemarkMdNeed : Int!
//    var productPobNeed : Int!
//    var productPobNeedMsg : String!
//    
//    var quesNeed : Int!
//    var quizHeading : String!
//    var quizNeed : Int!
//    var quizMandNeed : Int!
//    var quoteText : String!
//    
//    var rcpaQtyNeed : Int!
//    var rcpaUnitNeed : Int!
//    var rcpaMdNeed :Int!
//    var rcpaMgrMdNeed : Int!
//    var rcpaNeed :Int!
//    var rcpaCompetitorExtra : Int!
//    var remainderCallCap : String!
//    var remainderGeo : Int!
//    var remainderProductMd : Int!
//    var rmdrNeed : Int!
//    var rcpaextra : Int!
//    var refDoc : Int!
//    
//    var seNeed : Int!
//    var sfNeed : Int!
//    var sfStat : String!
//    
//    var sfTpDate : Double!
//    
//    var sfCode : String!
//    var sfName :String!
//    var sfPassword : String!
//    var sfUserName : String!
//    var sfEmail : String!
//    var sfMobile : String!
//    var sfEmpId : String!
//    var sfType : Int!
//    var stp : Int!
//    var siNeed : Int!
//    var spNeed : Int!
//    var sqNeed : Int!
//    var sampleValQty : Int!
//    var sampleValidation : Int!
//    var secondaryOrder : Int!
//    var secondaryOrderCaption : String!
//    var secondaryOrderDiscount : Int!
//    var sepRcpaNeed :Int!
//    var sequentailDcr : Int!
//    var srtNeed : Int!
//    var stateCode : Int!
//    var stkCap :String!
//    var stkEventMdNeed : Int!
//    var stkNeed :Int!
//    var stkQCap : String!
//    var stkInputCaption : String!
//    var stkPobMdNeed : Int!
//    var stkPobNeed : Int!
//    var stkProductCaption : String!
//    var stkClusterBased : Int!
//    var stkJointWrkMdNeed : Int!
//    var stkJointWrkNeed :Int!
//    var surveyNeed : Int!
//    var success : Int!
//    var subDivisionCode : String!
//    
//    var tBase :Int!
//    var tpdcrDeviation : Int!
//    var tpdcrDeviationApprStatus : Int!
//    var tpdcrMgrAppr : Int!
//    var tpMdNeed : Int!
//    var tpBasedDcr : Int!
//    var targetReportNeed : Int!
//    var targetReportMdNeed : Int!
//    var taxNameCaption :String!
//    var tempNeed : Int!
//    var terrBasedTag :Int!
//    var terrotoryVisitNeed : Int!
//    var tpEndDate : Int!
//    var tpstartDate : Int!
//    var tpNeed : Int!
//    var tpnew : Int!
//    var trackingTime : String!
//    var travelDistanceNeed : Int!
//    
//    var unlNeed : Int!
//    var ulDocClusterBased : Int!
//    var ulDocEventMd : Int!
//    var ulInputCaption : String!
//    var ulPobMdNeed :Int!
//    var ulPobNeed : Int!
//    var ulProductCaption :String!
//    var ulJointWrlMdNeed : Int!
//    var ulJointWrlNeed : Int!
//    var usrDfdUserName : String!
//    
//    var visitNeed : Int!
//    
//    var workAreaName : String!
//    
//    
//    init(fromDictionary dictionary: [String:Any]) {
//        
//        if let activityNd = dictionary["ActivityNd"] as? Int {
//            activityNeed = activityNd
//        }else if let activityNd = dictionary["ActivityNd"] as? String {
//            activityNeed = Int(activityNd)
//        }
//        
//        if let androidAppMode = dictionary["Android_App"] as? Int {
//            androidApp = androidAppMode
//        }else if let androidAppMode = dictionary["Android_App"] as? String {
//            androidApp = Int(androidAppMode)
//        }
//        
//        if let androidDetMode = dictionary["Android_Detailing"] as? Int {
//            androidDetailing = androidDetMode
//        }else if let androidDetMode = dictionary["Android_Detailing"] as? String {
//            androidDetailing = Int(androidDetMode)
//        }
//        
//        if let apprMandatoryNd = dictionary["Appr_Mandatory_Need"] as? Int {
//            apprMandatoryNeed = apprMandatoryNd
//        }else if let apprMandatoryNd = dictionary["Appr_Mandatory_Need"] as? String {
//            apprMandatoryNeed = Int(apprMandatoryNd)
//        }
//        
//        if let approvalNd = dictionary["Approveneed"] as? Int {
//            approvalNeed = approvalNd
//        }else if let approvalNd = dictionary["Approveneed"] as? String {
//            approvalNeed = Int(approvalNd)
//        }
//        
//        if let attendanceNd = dictionary["Attendance"] as? Int {
//            attendance = attendanceNd
//        }else if let attendanceNd = dictionary["Attendance"] as? String {
//            attendance = Int(attendanceNd)
//        }
//        
//        appDeviceId = dictionary["app_device_id"] as? String
//        
//        if let callFdEnterable = dictionary["call_feed_enterable"] as? Int {
//            callFeedEnterable = callFdEnterable
//        }else if let callFdEnterable = dictionary["call_feed_enterable"] as? String {
//            callFeedEnterable = Int(callFdEnterable)
//        }
//        
//        
//        callReport = dictionary["call_report"] as? String
//        callReportFromDate = dictionary["call_report_from_date"] as? String
//        callReportToDate = dictionary["call_report_to_date"] as? String
//        
//        if let chmAdqty = dictionary["chm_ad_qty"] as? Int {
//            chmAdQty = chmAdqty
//        }else if let chmAdqty = dictionary["chm_ad_qty"] as? String {
//            chmAdQty = Int(chmAdqty)
//        }
//        
//        if let chmSampleQtyNd = dictionary["chmsamQty_need"] as? Int {
//            chmSampleQtyNeed = chmSampleQtyNd
//        }else if let chmSampleQtyNd = dictionary["chmsamQty_need"] as? String {
//            chmSampleQtyNeed = Int(chmSampleQtyNd)
//        }
//        
//        if let cipNd = dictionary["cip_need"] as? Int {
//            cipNeed = cipNd
//        }else if let cipNd = dictionary["cip_need"] as? String {
//            cipNeed = Int(cipNd)
//        }
//        
//        if let circularNd = dictionary["circular"] as? Int {
//            circular = circularNd
//        }else if let circularNd = dictionary["circular"] as? String {
//            circular = Int(circularNd)
//        }
//        
//        if let cntRemarksVal = dictionary["cntRemarks"] as? Int {
//            cntRemarks = cntRemarksVal
//        }else if let cntRemarksVal = dictionary["cntRemarks"] as? String {
//            cntRemarks = Int(cntRemarksVal)
//        }
//        
//        if let currentDayVal = dictionary["currentDay"] as? Int {
//            currentDay = currentDayVal
//        }else if let currentDayVal = dictionary["currentDay"] as? String {
//            currentDay = Int(currentDayVal)
//        }
//        
//        if let ceNd = dictionary["CENeed"] as? Int {
//            ceNeed = ceNd
//        }else if let ceNd = dictionary["CENeed"] as? String {
//            ceNeed = Int(ceNd)
//        }
//        
//        if let cfNd = dictionary["CFNeed"] as? Int {
//            cfNeed = cfNd
//        }else if let cfNd = dictionary["CFNeed"] as? String {
//            cfNeed = Int(cfNd)
//        }
//        
//        if let cheBaseVal = dictionary["CHEBase"] as? Int {
//            cheBase = cheBaseVal
//        }else if let cheBaseVal = dictionary["CHEBase"] as? String {
//            cheBase = Int(cheBaseVal)
//        }
//        
//        if let ciNd = dictionary["CINeed"] as? Int {
//            ciNeed = ciNd
//        }else if let ciNd = dictionary["CINeed"] as? String {
//            ciNeed = Int(ciNd)
//        }
//        
//        if let cipPobMdNd = dictionary["CIPPOBMd"] as? Int {
//            cipPobMdNeed = cipPobMdNd
//        }else if let cipPobMdNd = dictionary["CIPPOBMd"] as? String {
//            cipPobMdNeed = Int(cipPobMdNd)
//        }
//        
//        if let cipPobNd = dictionary["CIPPOBNd"] as? Int {
//            cipPobNeed = cipPobNd
//        }else if let cipPobNd = dictionary["CIPPOBNd"] as? String {
//            cipPobNeed = Int(cipPobNd)
//        }
//        
//        cipCaption = dictionary["CIP_Caption"] as? String
//        
//        if let cipENd = dictionary["CIP_ENeed"] as? Int {
//            cipENeed = cipENd
//        }else if let cipENd = dictionary["CIP_ENeed"] as? String {
//            cipENeed = Int(cipENd)
//        }
//        
//        if let cipFNd = dictionary["CIP_FNeed"] as? Int {
//            cipFNeed = cipFNd
//        }else if let cipFNd = dictionary["CIP_FNeed"] as? String {
//            cipFNeed = Int(cipFNd)
//        }
//        
//        if let cipINd = dictionary["CIP_INeed"] as? Int {
//            cipINeed = cipINd
//        }else if let cipINd = dictionary["CIP_INeed"] as? String {
//            cipINeed = Int(cipINd)
//        }
//        
//        if let cipPNd = dictionary["CIP_PNeed"] as? Int {
//            cipPNeed = cipPNd
//        }else if let cipPNd = dictionary["CIP_PNeed"] as? String {
//            cipPNeed = Int(cipPNd)
//        }
//        
//        if let cipQNd = dictionary["CIP_QNeed"] as? Int {
//            cipQNeed = cipQNd
//        }else if let cipQNd = dictionary["CIP_QNeed"] as? String {
//            cipQNeed = Int(cipQNd)
//        }
//        
//        if let cipJointWrkNd = dictionary["CIP_jointwork_Need"] as? Int {
//            cipJointWrkNeed = cipJointWrkNd
//        }else if let cipJointWrkNd = dictionary["CIP_jointwork_Need"] as? String {
//            cipJointWrkNeed = Int(cipJointWrkNd)
//        }
//        
//        if let cpNd = dictionary["CPNeed"] as? Int {
//            cpNeed = cpNd
//        }else if let cpNd = dictionary["CPNeed"] as? String {
//            cpNeed = Int(cpNd)
//        }
//        
//        if let cqNd = dictionary["CQNeed"] as? Int {
//            cqNeed = cqNd
//        }else if let cqNd = dictionary["CQNeed"] as? String {
//            cqNeed = Int(cqNd)
//        }
//        
//        if let campNd = dictionary["Campneed"] as? Int {
//            campNeed = campNd
//        }else if let campNd = dictionary["Campneed"] as? String {
//            campNeed = Int(campNd)
//        }
//        
//        if let catNd = dictionary["Catneed"] as? Int {
//            catNeed = catNd
//        }else if let catNd = dictionary["Catneed"] as? String {
//            catNeed = Int(catNd)
//        }
//        
//        chmCap = dictionary["ChmCap"] as? String
//        
//        if let chmEventMdNd = dictionary["ChmEvent_Md"] as? Int {
//            chmEventMdNeed = chmEventMdNd
//        }else if let chmEventMdNd = dictionary["ChmEvent_Md"] as? String {
//            chmEventMdNeed = Int(chmEventMdNd)
//        }
//        
//        if let chmNd = dictionary["ChmNeed"] as? Int {
//            chmNeed = chmNd
//        }else if let chmNd = dictionary["ChmNeed"] as? String {
//            chmNeed = Int(chmNd)
//        }
//        
//        chmQcap = dictionary["ChmQCap"] as? String
//        
//        if let chmRcpaCompetitorNd = dictionary["ChmRCPA_competitor_Need"] as? Int {
//            chmRcpaCompetitorNeed = chmRcpaCompetitorNd
//        }else if let chmRcpaCompetitorNd = dictionary["ChmRCPA_competitor_Need"] as? String {
//            chmRcpaCompetitorNeed = Int(chmRcpaCompetitorNd)
//        }
//        
//        if let chmRxQtyNd = dictionary["ChmRxQty"] as? Int {
//            chmRxQtyNeed = chmRxQtyNd
//        }else if let chmRxQtyNd = dictionary["ChmRxQty"] as? String {
//            chmRxQtyNeed = Int(chmRxQtyNd)
//        }
//        
//        chmSampleCap = dictionary["ChmSmpCap"] as? String
//        
//        chmInputCaption = dictionary["Chm_Input_caption"] as? String
//        
//        if let chmPobMandatoryNd = dictionary["Chm_Pob_Mandatory_Need"] as? Int {
//            chmPobMandatoryNeed = chmPobMandatoryNd
//        }else if let chmPobMandatoryNd = dictionary["Chm_Pob_Mandatory_Need"] as? String {
//            chmPobMandatoryNeed = Int(chmPobMandatoryNd)
//        }
//        
//        if let chmPobNd = dictionary["Chm_Pob_Need"] as? Int {
//            chmPobNeed = chmPobNd
//        }else if let chmPobNd = dictionary["Chm_Pob_Need"] as? String {
//            chmPobNeed = Int(chmPobNd)
//        }
//        
//        chmProductCaption = dictionary["Chm_Product_caption"] as? String
//        
//        if let chmRcpaNd = dictionary["Chm_RCPA_Need"] as? Int {
//            chmRcpaNeed = chmRcpaNd
//        }else if let chmRcpaNd = dictionary["Chm_RCPA_Need"] as? String {
//            chmRcpaNeed = Int(chmRcpaNd)
//        }
//        
//        if let chmClusBased = dictionary["Chm_cluster_based"] as? Int {
//            chmClusterBased = chmClusBased
//        }else if let chmClusBased = dictionary["Chm_cluster_based"] as? String {
//            chmClusterBased = Int(chmClusBased)
//        }
//        
//        if let chmJointWrkMdNd = dictionary["Chm_jointwork_Mandatory_Need"] as? Int {
//            chmJointWrkMdNeed = chmJointWrkMdNd
//        }else if let chmJointWrkMdNd = dictionary["Chm_jointwork_Mandatory_Need"] as? String {
//            chmJointWrkMdNeed = Int(chmJointWrkMdNd)
//        }
//        
//        if let chmJointWrkNd = dictionary["Chm_jointwork_Need"] as? Int {
//            chmJointWrkNeed = chmJointWrkNd
//        }else if let chmJointWrkNd = dictionary["Chm_jointwork_Need"] as? String {
//            chmRcpaNeed = Int(chmJointWrkNd)
//        }
//        
//        if let cipEventMdNd = dictionary["CipEvent_Md"] as? Int {
//            cipEventMdNeed = cipEventMdNd
//        }else if let cipEventMdNd = dictionary["CipEvent_Md"] as? String {
//            cipEventMdNeed = Int(cipEventMdNd)
//        }
//        
//        if let cipSrtNeed = dictionary["CipSrtNd"] as? Int {
//            cipSrtNd = cipSrtNeed
//        }else if let cipSrtNeed = dictionary["CipSrtNd"] as? String {
//            cipSrtNd = Int(cipSrtNeed)
//        }
//        
//        clusterCap = dictionary["Cluster_Cap"] as? String
//        
//        if let cmpgnNd = dictionary["CmpgnNeed"] as? Int {
//            cmpgnNeed = cmpgnNd
//        }else if let cmpgnNd = dictionary["CmpgnNeed"] as? String {
//            cmpgnNeed = Int(cmpgnNd)
//        }
//        
//        if let currentdayTpPlan = dictionary["Currentday_TPplanned"] as? Int {
//            currentdayTpPlanned = currentdayTpPlan
//        }else if let currentdayTpPlan = dictionary["Currentday_TPplanned"] as? String {
//            currentdayTpPlanned = Int(currentdayTpPlan)
//        }
//        
//        if let custSrtNd = dictionary["CustSrtNd"] as? Int {
//            custSrtNeed = custSrtNd
//        }else if let custSrtNd = dictionary["CustSrtNd"] as? String {
//            custSrtNeed = Int(custSrtNd)
//        }
//        
//        if let deNd = dictionary["DENeed"] as? Int {
//            deNeed = deNd
//        }else if let deNd = dictionary["DENeed"] as? String {
//            deNeed = Int(deNd)
//        }
//        
//        if let dfNd = dictionary["DFNeed"] as? Int {
//            dfNeed = dfNd
//        }else if let dfNd = dictionary["DFNeed"] as? String {
//            dfNeed = Int(dfNd)
//        }
//        
//        if let diNd = dictionary["DINeed"] as? Int {
//            diNeed = diNd
//        }else if let diNd = dictionary["DINeed"] as? String {
//            diNeed = Int(diNd)
//        }
//        
//        if let dpNd = dictionary["DPNeed"] as? Int {
//            dpNeed = dpNd
//        }else if let dpNd = dictionary["DPNeed"] as? String {
//            dpNeed = Int(dpNd)
//        }
//        
//        if let dqNd = dictionary["DQNeed"] as? Int {
//            dqNeed = dqNd
//        }else if let dqNd = dictionary["DQNeed"] as? String {
//            dqNeed = Int(dqNd)
//        }
//        
//        dsName = dictionary["DS_name"] as? String
//        
//        if let dcrLockDaysVal = dictionary["DcrLockDays"] as? Int {
//            dcrLockDays = dcrLockDaysVal
//        }else if let dcrLockDaysVal = dictionary["DcrLockDays"] as? String {
//            dcrLockDays = Int(dcrLockDaysVal)
//        }
//        
//        if let dcrFirstSelfieNd = dictionary["Dcr_firstselfie"] as? Int {
//            dcrFirstSelfieNeed = dcrFirstSelfieNd
//        }else if let dcrFirstSelfieNd = dictionary["Dcr_firstselfie"] as? String {
//            dcrFirstSelfieNeed = Int(dcrFirstSelfieNd)
//        }
//        
//        desig = dictionary["Desig"] as? String
//        
//        if let detailingChemVal = dictionary["Detailing_chem"] as? Int {
//            detailingChem = detailingChemVal
//        }else if let detailingChemVal = dictionary["Detailing_chem"] as? String {
//            detailingChem = Int(detailingChemVal)
//        }
//        
//        if let detailingTypeVal = dictionary["Detailing_type"] as? Int {
//            detailingType = detailingTypeVal
//        }else if let detailingTypeVal = dictionary["Detailing_type"] as? String {
//            detailingType = Int(detailingTypeVal)
//        }
//        
//        if let deviceIdNd = dictionary["DeviceId_Need"] as? Int {
//            deviceIdNeed = deviceIdNd
//        }else if let deviceIdNd = dictionary["DeviceId_Need"] as? String {
//            deviceIdNeed = Int(deviceIdNd)
//        }
//        
//        deviceRegId = dictionary["DeviceRegId"] as? String
//        
//        
//        if let disRadValue = dictionary["DisRad"] as? String {
//            disRad = disRadValue
//        }else if let disRadValue = dictionary["DisRad"] as? Float {
//            disRad = "\(disRadValue)"
//        }else if let disRadValue = dictionary["DisRad"] as? Double {
//            disRad = "\(disRadValue)"
//        }else if let disRadValue = dictionary["DisRad"] as? Int {
//            disRad = "\(disRadValue)"
//        }
//        
//       // disRad = dictionary["DisRad"] as? String
//        
//        divisionCode = dictionary["Division_Code"] as? String
//        
//        if let dlyCtrlNeed = dictionary["DlyCtrl"] as? Int {
//            dlyCtrl = dlyCtrlNeed
//        }else if let dlyCtrlNeed = dictionary["DlyCtrl"] as? String {
//            dlyCtrl = Int(dlyCtrlNeed)
//        }
//        
//        docInputCaption = dictionary["Doc_Input_caption"] as? String
//        
//        if let docPobMdNd = dictionary["Doc_Pob_Mandatory_Need"] as? Int {
//            docPobMandatoryNeed = docPobMdNd
//        }else if let docPobMdNd = dictionary["Doc_Pob_Mandatory_Need"] as? String {
//            docPobMandatoryNeed = Int(docPobMdNd)
//        }
//        
//        if let docPobNd = dictionary["Doc_Pob_Need"] as? Int {
//            docPobNeed = docPobNd
//        }else if let docPobNd = dictionary["Doc_Pob_Need"] as? String {
//            docPobNeed = Int(docPobNd)
//        }
//        
//        docProductCaption = dictionary["Doc_Product_caption"] as? String
//        
//        if let docClusBased = dictionary["Doc_cluster_based"] as? Int {
//            docClusterBased = docClusBased
//        }else if let docClusBased = dictionary["Doc_cluster_based"] as? String {
//            docClusterBased = Int(docClusBased)
//        }
//        
//        if let docJointWrkMdNd = dictionary["Doc_jointwork_Mandatory_Need"] as? Int {
//            docJointWrkMdNeed = docJointWrkMdNd
//        }else if let docJointWrkMdNd = dictionary["Doc_jointwork_Mandatory_Need"] as? String {
//            docJointWrkMdNeed = Int(docJointWrkMdNd)
//        }
//        
//        if let docJointWrkNd = dictionary["Doc_jointwork_Need"] as? Int {
//            docJointWrkNeed = docJointWrkNd
//        }else if let docJointWrkNd = dictionary["Doc_jointwork_Need"] as? String {
//            docJointWrkNeed = Int(docJointWrkNd)
//        }
//        
//        docCap = dictionary["DrCap"] as? String
//        
//        if let docEventMdNd = dictionary["DrEvent_Md"] as? Int {
//            docEventMdNeed = docEventMdNd
//        }else if let docEventMdNd = dictionary["DrEvent_Md"] as? String {
//            docEventMdNeed = Int(docEventMdNd)
//        }
//        
//        if let docFeedMdNd = dictionary["DrFeedMd"] as? Int {
//            docFeedMdNeed = docFeedMdNd
//        }else if let docFeedMdNd = dictionary["DrFeedMd"] as? String {
//            docFeedMdNeed = Int(docFeedMdNd)
//        }
//        
//        if let docInputMdNd = dictionary["DrInpMd"] as? Int {
//            docInputMdNeed = docInputMdNd
//        }else if let docInputMdNd = dictionary["DrInpMd"] as? String {
//            docInputMdNeed = Int(docInputMdNd)
//        }
//        
//        if let docNd = dictionary["DrNeed"] as? Int {
//            docNeed = docNd
//        }else if let docNd = dictionary["DrNeed"] as? String {
//            docNeed = Int(docNd)
//        }
//        
//        if let docProductMdNd = dictionary["DrPrdMd"] as? Int {
//            docProductMdNeed = docProductMdNd
//        }else if let docProductMdNd = dictionary["DrPrdMd"] as? String {
//            docProductMdNeed = Int(docProductMdNd)
//        }
//        
//        if let docRcpaCompetitorNd = dictionary["DrRCPA_competitor_Need"] as? Int {
//            docRcpaCompetitorNeed = docRcpaCompetitorNd
//        }else if let docRcpaCompetitorNd = dictionary["DrRCPA_competitor_Need"] as? String {
//            docRcpaCompetitorNeed = Int(docRcpaCompetitorNd)
//        }
//        
//        if let docRcpaQMdNd = dictionary["DrRcpaQMd"] as? Int {
//            docRcpaQMdNeed = docRcpaQMdNd
//        }else if let docRcpaQMdNd = dictionary["DrRcpaQMd"] as? String {
//            docRcpaQMdNeed = Int(docRcpaQMdNd)
//        }
//        
//        if let docRxNd = dictionary["DrRxNd"] as? Int {
//            docRxNeed = docRxNd
//        }else if let docRxNd = dictionary["DrRxNd"] as? String {
//            docRxNeed = Int(docRxNd)
//        }
//        
//        docRxQCap = dictionary["DrRxQCap"] as? String
//        
//        if let docRxQMdNd = dictionary["DrRxQMd"] as? Int {
//            docRxQMd = docRxQMdNd
//        }else if let docRxQMdNd = dictionary["DrRxQMd"] as? String {
//            docRxQMd = Int(docRxQMdNd)
//        }
//        
//        if let docSampleNd = dictionary["DrSampNd"] as? Int {
//            docSampleNeed = docSampleNd
//        }else if let docSampleNd = dictionary["DrSampNd"] as? String {
//            docSampleNeed = Int(docSampleNd)
//        }
//        
//        docSampleQCap = dictionary["DrSmpQCap"] as? String
//        
//        if let docSampleQMdNd = dictionary["DrSmpQMd"] as? Int {
//            docSampleQMdNeed = docSampleQMdNd
//        }else if let docSampleQMdNd = dictionary["DrSmpQMd"] as? String {
//            docSampleQMdNeed = Int(docSampleQMdNd)
//        }
//        
//        if let dashboardNd = dictionary["dashboard"] as? Int {
//            dashboard = dashboardNd
//        }else if let dashboardNd = dictionary["dashboard"] as? String {
//            dashboard = Int(dashboardNd)
//        }
//        
//        if let dayplanTpBasedNd = dictionary["dayplan_tp_based"] as? Int {
//            dayplanTpBased = dayplanTpBasedNd
//        }else if let dayplanTpBasedNd = dictionary["dayplan_tp_based"] as? String {
//            dayplanTpBased = Int(dayplanTpBasedNd)
//        }
//        
//        if let daysVal = dictionary["days"] as? Int {
//            days = daysVal
//        }else if let daysVal = dictionary["days"] as? String {
//            days = Int(daysVal)
//        }
//        
//        if let dcrDocBusinessProductNd = dictionary["dcr_doc_business_product"] as? Int {
//            dcrDocBusinessProduct = dcrDocBusinessProductNd
//        }else if let dcrDocBusinessProductNd = dictionary["dcr_doc_business_product"] as? String {
//            dcrDocBusinessProduct = Int(dcrDocBusinessProductNd)
//        }
//        
//        desigCode = dictionary["desig_Code"] as? String
//        
//        if let docBusinessProductNd = dictionary["doc_business_product"] as? Int {
//            docBusinessProduct = docBusinessProductNd
//        }else if let docBusinessProductNd = dictionary["doc_business_product"] as? String {
//            docBusinessProduct = Int(docBusinessProductNd)
//        }
//        
//        if let docBusinessVal = dictionary["doc_business_value"] as? Int {
//            docBusinessValue = docBusinessVal
//        }else if let docBusinessVal = dictionary["doc_business_value"] as? String {
//            docBusinessValue = Int(docBusinessVal)
//        }
//
//        if let doctorDobDowVal = dictionary["doctor_dobdow"] as? Int {
//            doctorDobDow = doctorDobDowVal
//        }else if let doctorDobDowVal = dictionary["doctor_dobdow"] as? String {
//            doctorDobDow = Int(doctorDobDowVal)
//        }
//        
//        if let expenceNd = dictionary["ExpenceNd"] as? Int {
//            expenceNeed = expenceNd
//        }else if let expenceNd = dictionary["ExpenceNd"] as? String {
//            expenceNeed = Int(expenceNd)
//        }
//        
//        if let expenceMdNd = dictionary["ExpenceNd_mandatory"] as? Int {
//            expenceMdNeed = expenceMdNd
//        }else if let expenceMdNd = dictionary["ExpenceNd_mandatory"] as? String {
//            expenceMdNeed = Int(expenceMdNd)
//        }
//
//        if let expenseNd = dictionary["Expenseneed"] as? Int {
//            expenseNeed = expenseNd
//        }else if let expenseNd = dictionary["Expenseneed"] as? String {
//            expenseNeed = Int(expenseNd)
//        }
//        
//        if let editHolidayVal = dictionary["edit_holiday"] as? Int {
//            editHoliday = editHolidayVal
//        }else if let editHolidayVal = dictionary["edit_holiday"] as? String {
//            editHoliday = Int(editHolidayVal)
//        }
//        
//        if let editWeeklyOffVal = dictionary["edit_weeklyoff"] as? Int {
//            editWeeklyOff = editWeeklyOffVal
//        }else if let editWeeklyOffVal = dictionary["edit_weeklyoff"] as? String {
//            editWeeklyOff = Int(editWeeklyOffVal)
//        }
//
//        if let entryformMgrVal = dictionary["entryFormMgr"] as? Int {
//            entryformMgr = entryformMgrVal
//        }else if let entryformMgrVal = dictionary["entryFormMgr"] as? String {
//            entryformMgr = Int(entryformMgrVal)
//        }
//        
//        if let entryFormNd = dictionary["entryFormNeed"] as? Int {
//            entryFormNeed = entryFormNd
//        }else if let entryFormNd = dictionary["entryFormNeed"] as? String {
//            entryFormNeed = Int(entryFormNd)
//        }
//        
//        if let expense_Nd = dictionary["expense_need"] as? Int {
//            expense_Need = expense_Nd
//        }else if let expense_Nd = dictionary["expense_need"] as? String {
//            expense_Need = Int(expense_Nd)
//        }
//
//        if let faqNd = dictionary["faq"] as? Int {
//            faq = faqNd
//        }else if let faqNd = dictionary["faq"] as? String {
//            faq = Int(faqNd)
//        }
//        
//        if let geoTagNd = dictionary["GEOTagNeed"] as? Int {
//            geoTagNeed = geoTagNd
//        }else if let geoTagNd = dictionary["GEOTagNeed"] as? String {
//            geoTagNeed = Int(geoTagNd)
//        }
//        
//        if let geoTagNdChe = dictionary["GEOTagNeedche"] as? Int {
//            geoTagNeedChe = geoTagNdChe
//        }else if let geoTagNdChe = dictionary["GEOTagNeedche"] as? String {
//            geoTagNeedChe = Int(geoTagNdChe)
//        }
//
//        if let geoTagNdStock = dictionary["GEOTagNeedstock"] as? Int {
//            geoTagNeedStock = geoTagNdStock
//        }else if let geoTagNdStock = dictionary["GEOTagNeedstock"] as? String {
//            geoTagNeedStock = Int(geoTagNdStock)
//        }
//        
//        if let geoTagNdUnList = dictionary["GEOTagNeedunlst"] as? Int {
//            geoTagNeedUnList = geoTagNdUnList
//        }else if let geoTagNdUnList = dictionary["GEOTagNeedunlst"] as? String {
//            geoTagNeedUnList = Int(geoTagNdUnList)
//        }
//        
//        if let geoCheckNd = dictionary["GeoChk"] as? Int {
//            geoCheck = geoCheckNd
//        }else if let geoCheckNd = dictionary["GeoChk"] as? String {
//            geoCheck = Int(geoCheckNd)
//        }
//
//        if let geoNd = dictionary["GeoNeed"] as? Int {
//            geoNeed = geoNd
//        }else if let geoNd = dictionary["GeoNeed"] as? String {
//            geoNeed = Int(geoNd)
//        }
//        
//        if let geoTagNdCip = dictionary["GeoTagNeedcip"] as? Int {
//            geoTagNeedCip = geoTagNdCip
//        }else if let geoTagNdCip = dictionary["GeoTagNeedcip"] as? String {
//            geoTagNeedCip = Int(geoTagNdCip)
//        }
//
//        if let gstOptionNd = dictionary["Gst_option"] as? Int {
//            gstOption = gstOptionNd
//        }else if let gstOptionNd = dictionary["Gst_option"] as? String {
//            gstOption = Int(gstOptionNd)
//        }
//        
//        if let geoTagImgNd = dictionary["geoTagImg"] as? Int {
//            geoTagImg = geoTagImgNd
//        }else if let geoTagImgNd = dictionary["geoTagImg"] as? String {
//            geoTagImg = Int(geoTagImgNd)
//        }
//        
//        if let geoTagNdCip = dictionary["GeoTagNeedcip"] as? Int {
//            geoTagNeedCip = geoTagNdCip
//        }else if let geoTagNdCip = dictionary["GeoTagNeedcip"] as? String {
//            geoTagNeedCip = Int(geoTagNdCip)
//        }
//
//        if let gstOptionNd = dictionary["Gst_option"] as? Int {
//            gstOption = gstOptionNd
//        }else if let gstOptionNd = dictionary["Gst_option"] as? String {
//            gstOption = Int(gstOptionNd)
//        }
//        
//        if let geoTagImgNd = dictionary["geoTagImg"] as? Int {
//            geoTagImg = geoTagImgNd
//        }else if let geoTagImgNd = dictionary["geoTagImg"] as? String {
//            geoTagImg = Int(geoTagImgNd)
//        }
//        
//        if let heNd = dictionary["HENeed"] as? Int {
//            heNeed = heNd
//        }else if let heNd = dictionary["HENeed"] as? String {
//            heNeed = Int(heNd)
//        }
//
//        if let hfNd = dictionary["HFNeed"] as? Int {
//            hfNeed = hfNd
//        }else if let hfNd = dictionary["HFNeed"] as? String {
//            hfNeed = Int(hfNd)
//        }
//        
//        if let hiNd = dictionary["HINeed"] as? Int {
//            hiNeed = hiNd
//        }else if let hiNd = dictionary["HINeed"] as? String {
//            hiNeed = Int(hiNd)
//        }
//        
//        if let hpNd = dictionary["HPNeed"] as? Int {
//            hpNeed = hpNd
//        }else if let hpNd = dictionary["HPNeed"] as? String {
//            hpNeed = Int(hpNd)
//        }
//
//        
//        hqName = dictionary["HQName"] as? String
//        
//        if let hqNd = dictionary["HQNeed"] as? Int {
//            hqNeed = hqNd
//        }else if let hqNd = dictionary["HQNeed"] as? String {
//            hqNeed = Int(hqNd)
//        }
//        
//        if let hosPobMdNd = dictionary["HosPOBMd"] as? Int {
//            hosPobMdNeed = hosPobMdNd
//        }else if let hosPobMdNd = dictionary["HosPOBMd"] as? String {
//            hosPobMdNeed = Int(hosPobMdNd)
//        }
//        
//        if let hosPobNd = dictionary["HosPOBNd"] as? Int {
//            hosPobNeed = hosPobNd
//        }else if let hosPobNd = dictionary["HosPOBNd"] as? String {
//            hosPobNeed = Int(hosPobNd)
//        }
//        
//        if let hospEventNd = dictionary["HospEvent_Md"] as? Int {
//            hospEventNeed = hospEventNd
//        }else if let hospEventNd = dictionary["HospEvent_Md"] as? String {
//            hospEventNeed = Int(hospEventNd)
//        }
//        
//        hospCaption = dictionary["hosp_caption"] as? String
//        
//        if let hospNd = dictionary["hosp_need"] as? Int {
//            hospNeed = hospNd
//        }else if let hospNd = dictionary["hosp_need"] as? String {
//            hospNeed = Int(hospNd)
//        }
//        
//        if let inputValueQty = dictionary["Input_Val_Qty"] as? Int {
//            inputValQty = inputValueQty
//        }else if let inputValueQty = dictionary["Input_Val_Qty"] as? String {
//            inputValQty = Int(inputValueQty)
//        }
//        
//        if let inputValidationNd = dictionary["input_validation"] as? Int {
//            inputValidation = inputValidationNd
//        }else if let inputValidationNd = dictionary["input_validation"] as? String {
//            inputValidation = Int(inputValidationNd)
//        }
//        
//        if let leaveStatusNd = dictionary["LeaveStatus"] as? Int {
//            leaveStatus = leaveStatusNd
//        }else if let leaveStatusNd = dictionary["LeaveStatus"] as? String {
//            leaveStatus = Int(leaveStatusNd)
//        }
//        
//        if let leaveEntitlementNd = dictionary["Leave_entitlement_need"] as? Int {
//            leaveEntitlementNeed = leaveEntitlementNd
//        }else if let leaveEntitlementNd = dictionary["Leave_entitlement_need"] as? String {
//            leaveEntitlementNeed = Int(leaveEntitlementNd)
//        }
//        
//        if let locationTrackNd = dictionary["Location_track"] as? Int {
//            locationTrack = locationTrackNd
//        }else if let locationTrackNd = dictionary["Location_track"] as? String {
//            locationTrack = Int(locationTrackNd)
//        }
//        
//        if let iosAppVal = dictionary["ios_app"] as? Int {
//            iosApp = iosAppVal
//        }else if let iosAppVal = dictionary["ios_app"] as? String {
//            iosApp = Int(iosAppVal)
//        }
//        
//        if let iosDetailingVal = dictionary["ios_Detailing"] as? Int {
//            iosDetailing = iosDetailingVal
//        }else if let iosDetailingVal = dictionary["ios_Detailing"] as? String {
//            iosDetailing = Int(iosDetailingVal)
//        }
//        
//        if let mclDetVal = dictionary["MCLDet"] as? Int {
//            mclDet = mclDetVal
//        }else if let mclDetVal = dictionary["MCLDet"] as? String {
//            mclDet = Int(mclDetVal)
//        }
//        
//        if let mgrHlfDyVal = dictionary["MGRHlfDy"] as? Int {
//            mgrHlfDy = mgrHlfDyVal
//        }else if let mgrHlfDyVal = dictionary["MGRHlfDy"] as? String {
//            mgrHlfDy = Int(mgrHlfDyVal)
//        }
//        
//        if let mrHlfDyVal = dictionary["MRHlfDy"] as? Int {
//            mrHlfDy = mrHlfDyVal
//        }else if let mrHlfDyVal = dictionary["MRHlfDy"] as? String {
//            mrHlfDy = Int(mrHlfDyVal)
//        }
//        
//        if let msdEntryVal = dictionary["MsdEntry"] as? Int {
//            msdEntry = msdEntryVal
//        }else if let msdEntryVal = dictionary["MsdEntry"] as? String {
//            msdEntry = Int(msdEntryVal)
//        }
//        
//        if let mailNd = dictionary["mailneed"] as? Int {
//            mailNeed = mailNd
//        }else if let mailNd = dictionary["mailneed"] as? String {
//            mailNeed = Int(mailNd)
//        }
//        
//        if let miscExpenseNd = dictionary["misc_expense_need"] as? Int {
//            miscExpenseNeed = miscExpenseNd
//        }else if let miscExpenseNd = dictionary["misc_expense_need"] as? String {
//            miscExpenseNeed = Int(miscExpenseNd)
//        }
//        
//        if let missedDateMdNd = dictionary["missedDateMand"] as? Int {
//            missedDateMdNeed = missedDateMdNd
//        }else if let missedDateMdNd = dictionary["missedDateMand"] as? String {
//            missedDateMdNeed = Int(missedDateMdNd)
//        }
//        
//        if let multiClusterNd = dictionary["multi_cluster"] as? Int {
//            multiClusterNeed = multiClusterNd
//        }else if let multiClusterNd = dictionary["multi_cluster"] as? String {
//            multiClusterNeed = Int(multiClusterNd)
//        }
//        
//        if let multipleDocNd = dictionary["multiple_doc_need"] as? Int {
//            multipleDocNeed = multipleDocNd
//        }else if let multipleDocNd = dictionary["multiple_doc_need"] as? String {
//            multipleDocNeed = Int(multipleDocNd)
//        }
//        
//        if let mydayplanNd = dictionary["mydayplan_need"] as? Int {
//            mydayplanNeed = mydayplanNd
//        }else if let mydayplanNd = dictionary["mydayplan_need"] as? String {
//            mydayplanNeed = Int(mydayplanNd)
//        }
//        
//        if let myPlnRmrksMandNd = dictionary["myplnRmrksMand"] as? Int {
//            myPlnRmrksMand = myPlnRmrksMandNd
//        }else if let myPlnRmrksMandNd = dictionary["myplnRmrksMand"] as? String {
//            myPlnRmrksMand = Int(myPlnRmrksMandNd)
//        }
//        
//        if let neNd = dictionary["NENeed"] as? Int {
//            neNeed = neNd
//        }else if let neNd = dictionary["NENeed"] as? String {
//            neNeed = Int(neNd)
//        }
//        
//        if let nfNd = dictionary["NFNeed"] as? Int {
//            nfNeed = nfNd
//        }else if let nfNd = dictionary["NFNeed"] as? String {
//            nfNeed = Int(nfNd)
//        }
//        
//        if let niNd = dictionary["NINeed"] as? Int {
//            niNeed = niNd
//        }else if let niNd = dictionary["NINeed"] as? String {
//            niNeed = Int(niNd)
//        }
//        
//        nlCap = dictionary["NLCap"] as? String
//        
//        nlRxQCap = dictionary["NLRxQCap"] as? String
//        
//        nlSampleQCap = dictionary["NLSmpQCap"] as? String
//        
//        if let npNd = dictionary["NPNeed"] as? Int {
//            npNeed = npNd
//        }else if let npNd = dictionary["NPNeed"] as? String {
//            npNeed = Int(npNd)
//        }
//        
//        if let nqNd = dictionary["NQNeed"] as? Int {
//            nqNeed = nqNd
//        }else if let nqNd = dictionary["NQNeed"] as? String {
//            nqNeed = Int(nqNd)
//        }
//        
//        if let nextVstNd = dictionary["NextVst"] as? Int {
//            nextVst = nextVstNd
//        }else if let nextVstNd = dictionary["NextVst"] as? String {
//            nextVst = Int(nextVstNd)
//        }
//        
//        if let nextVstMdNd = dictionary["NextVst_Mandatory_Need"] as? Int {
//            nextVstMdNeed = nextVstMdNd
//        }else if let nextVstMdNd = dictionary["NextVst_Mandatory_Need"] as? String {
//            nextVstMdNeed = Int(nextVstMdNd)
//        }
//        
//        if let noOfTpViewVal = dictionary["No_of_TP_View"] as? Int {
//            noOfTpView = noOfTpViewVal
//        }else if let noOfTpViewVal = dictionary["No_of_TP_View"] as? String {
//            noOfTpView = Int(noOfTpViewVal)
//        }
//        
//        orderCaption = dictionary["Order_caption"] as? String
//        
//        if let orderManagementNd = dictionary["Order_management"] as? Int {
//            orderManagement = orderManagementNd
//        }else if let orderManagementNd = dictionary["Order_management"] as? String {
//            orderManagement = Int(orderManagementNd)
//        }
//        
//        if let otherNd = dictionary["OtherNd"] as? Int {
//            otherNeed = otherNd
//        }else if let otherNd = dictionary["OtherNd"] as? String {
//            otherNeed = Int(otherNd)
//        }
//        
//        if let primaryOrderNd = dictionary["Primary_order"] as? Int {
//            primaryOrder = primaryOrderNd
//        }else if let primaryOrderNd = dictionary["Primary_order"] as? String {
//            primaryOrder = Int(primaryOrderNd)
//        }
//        
//        primaryOrderCap = dictionary["Primary_order_caption"] as? String
//        
//        if let prodStkNd = dictionary["Prod_Stk_Need"] as? Int {
//            prodStkNeed = prodStkNd
//        }else if let prodStkNd = dictionary["Prod_Stk_Need"] as? String {
//            prodStkNeed = Int(prodStkNd)
//        }
//        
//        if let productRateEditableVal = dictionary["Product_Rate_Editable"] as? Int {
//            productRateEditable = productRateEditableVal
//        }else if let productRateEditableVal = dictionary["Product_Rate_Editable"] as? String {
//            productRateEditable = Int(productRateEditableVal)
//        }
//        
//        if let pwdSetupVal = dictionary["Pwdsetup"] as? Int {
//            pwdSetup = pwdSetupVal
//        }else if let pwdSetupVal = dictionary["Pwdsetup"] as? String {
//            pwdSetup = Int(pwdSetupVal)
//        }
//        
//        if let pastLeavePostVal = dictionary["past_leave_post"] as? Int {
//            pastLeavePost = pastLeavePostVal
//        }else if let pastLeavePostVal = dictionary["past_leave_post"] as? String {
//            pastLeavePost = Int(pastLeavePostVal)
//        }
//        
//        if let pobMinVal = dictionary["pob_minvalue"] as? Int {
//            pobMinValue = pobMinVal
//        }else if let pobMinVal = dictionary["pob_minvalue"] as? String {
//            pobMinValue = Int(pobMinVal)
//        }
//        
//        if let productFeedBackNd = dictionary["prdfdback"] as? Int {
//            productFeedBack = productFeedBackNd
//        }else if let productFeedBackNd = dictionary["prdfdback"] as? String {
//            productFeedBack = Int(productFeedBackNd)
//        }
//        
//        if let primarySecNd = dictionary["primarysec_need"] as? Int {
//            primarySecNeed = primarySecNd
//        }else if let primarySecNd = dictionary["primarysec_need"] as? String {
//            primarySecNeed = Int(primarySecNd)
//        }
//        
//        if let proDetNd = dictionary["pro_det_need"] as? Int {
//            proDetNeed = proDetNd
//        }else if let proDetNd = dictionary["pro_det_need"] as? String {
//            proDetNeed = Int(proDetNd)
//        }
//        
//        if let prodDetNd = dictionary["prod_det_need"] as? Int {
//            prodDetNeed = prodDetNd
//        }else if let prodDetNd = dictionary["prod_det_need"] as? String {
//            prodDetNeed = Int(prodDetNd)
//        }
//        
//        if let productRemarkNd = dictionary["prod_remark"] as? Int {
//            productRemarkNeed = productRemarkNd
//        }else if let productRemarkNd = dictionary["prod_remark"] as? String {
//            productRemarkNeed = Int(productRemarkNd)
//        }
//        
//        if let productRemarkMdNd = dictionary["prod_remark_md"] as? Int {
//            productRemarkMdNeed = productRemarkMdNd
//        }else if let productRemarkMdNd = dictionary["prod_remark_md"] as? String {
//            productRemarkMdNeed = Int(productRemarkMdNd)
//        }
//        
//        if let productPobNd = dictionary["product_pob_need"] as? Int {
//            productPobNeed = productPobNd
//        }else if let productPobNd = dictionary["product_pob_need"] as? String {
//            productPobNeed = Int(productPobNd)
//        }
//        
//        productPobNeedMsg = dictionary["product_pob_need_msg"] as? String
//        
//        if let quesNd = dictionary["ques_need"] as? Int {
//            quesNeed = quesNd
//        }else if let quesNd = dictionary["ques_need"] as? String {
//            quesNeed = Int(quesNd)
//        }
//        
//        quizHeading = dictionary["quiz_heading"] as? String
//        
//        if let quizNd = dictionary["quiz_need"] as? Int {
//            quizNeed = quizNd
//        }else if let quizNd = dictionary["quiz_need"] as? String {
//            quizNeed = Int(quizNd)
//        }
//        
//        if let quizMandNd = dictionary["quiz_need_mandt"] as? Int {
//            quizMandNeed = quizMandNd
//        }else if let quizMandNd = dictionary["quiz_need_mandt"] as? String {
//            quizMandNeed = Int(quizMandNd)
//        }
//        
//        quoteText = dictionary["quote_Text"] as? String
//        
//        if let rcpaQtyNd = dictionary["RCPAQty_Need"] as? Int {
//            rcpaQtyNeed = rcpaQtyNd
//        }else if let rcpaQtyNd = dictionary["RCPAQty_Need"] as? String {
//            rcpaQtyNeed = Int(rcpaQtyNd)
//        }
//        
//        if let rcpaUnitNd = dictionary["RCPA_unit_nd"] as? Int {
//            rcpaUnitNeed = rcpaUnitNd
//        }else if let rcpaUnitNd = dictionary["RCPA_unit_nd"] as? String {
//            rcpaUnitNeed = Int(rcpaUnitNd)
//        }
//        
//        if let rcpaMdNd = dictionary["RcpaMd"] as? Int {
//            rcpaMdNeed = rcpaMdNd
//        }else if let rcpaMdNd = dictionary["RcpaMd"] as? String {
//            rcpaMdNeed = Int(rcpaMdNd)
//        }
//        
//        if let rcpaMgrMdNd = dictionary["RcpaMd_Mgr"] as? Int {
//            rcpaMgrMdNeed = rcpaMgrMdNd
//        }else if let rcpaMgrMdNd = dictionary["RcpaMd_Mgr"] as? String {
//            rcpaMgrMdNeed = Int(rcpaMgrMdNd)
//        }
//        
//        if let rcpaNd = dictionary["RcpaNd"] as? Int {
//            rcpaNeed = rcpaNd
//        }else if let rcpaNd = dictionary["RcpaNd"] as? String {
//            rcpaNeed = Int(rcpaNd)
//        }
//        
//        if let rcpaCompetitorExtraVal = dictionary["Rcpa_Competitor_extra"] as? Int {
//            rcpaCompetitorExtra = rcpaCompetitorExtraVal
//        }else if let rcpaCompetitorExtraVal = dictionary["Rcpa_Competitor_extra"] as? String {
//            rcpaCompetitorExtra = Int(rcpaCompetitorExtraVal)
//        }
//        
//        remainderCallCap = dictionary["Remainder_call_cap"] as? String
//        
//        if let remainderGeoVal = dictionary["Remainder_geo"] as? Int {
//            remainderGeo = remainderGeoVal
//        }else if let remainderGeoVal = dictionary["Remainder_geo"] as? String {
//            remainderGeo = Int(remainderGeoVal)
//        }
//        
//        if let remainderProductMdNd = dictionary["Remainder_prd_Md"] as? Int {
//            remainderProductMd = remainderProductMdNd
//        }else if let remainderProductMdNd = dictionary["Remainder_prd_Md"] as? String {
//            remainderProductMd = Int(remainderProductMdNd)
//        }
//        
//        if let rmdrNd = dictionary["RmdrNeed"] as? Int {
//            rmdrNeed = rmdrNd
//        }else if let rmdrNd = dictionary["RmdrNeed"] as? String {
//            rmdrNeed = Int(rmdrNd)
//        }
//        
//        if let rcpaextraVal = dictionary["rcpaextra"] as? Int {
//            rcpaextra = rcpaextraVal
//        }else if let rcpaextraVal = dictionary["rcpaextra"] as? String {
//            rcpaextra = Int(rcpaextraVal)
//        }
//        
//        if let refDocVal = dictionary["refDoc"] as? Int {
//            refDoc = refDocVal
//        }else if let refDocVal = dictionary["refDoc"] as? String {
//            refDoc = Int(refDocVal)
//        }
//        
//        if let seNd = dictionary["SENeed"] as? Int {
//            seNeed = seNd
//        }else if let seNd = dictionary["SENeed"] as? String {
//            seNeed = Int(seNd)
//        }
//        
//        if let sfNd = dictionary["SFNeed"] as? Int {
//            sfNeed = sfNd
//        }else if let sfNd = dictionary["SFNeed"] as? String {
//            sfNeed = Int(sfNd)
//        }
//        
//        sfStat = dictionary["SFStat"] as? String
//        
//        sfCode = dictionary["SF_Code"] as? String
//        
//        sfName = dictionary["SF_Name"] as? String
//        
//        sfPassword = dictionary["SF_Password"] as? String
//        
//        sfUserName = dictionary["SF_User_Name"] as? String
//        
//        
//        sfEmail = dictionary["sfEmail"] as? String
//        
//        sfMobile = dictionary["sfMobile"] as? String
//        
//        sfEmpId = dictionary["sf_emp_id"] as? String
//        
//        
//        
//        if let sfTypeValue = dictionary["sf_type"] as? Int {
//            sfType = sfTypeValue
//        }else if let sfTypeValue = dictionary["sf_type"] as? String {
//            sfType = Int(sfTypeValue)
//        }
//        
//        if let stpVal = dictionary["stp"] as? Int {
//            stp = stpVal
//        }else if let stpVal = dictionary["stp"] as? String {
//            stp = Int(stpVal)
//        }
//        
//        if let siNd = dictionary["SINeed"] as? Int {
//            siNeed = siNd
//        }else if let siNd = dictionary["SINeed"] as? String {
//            siNeed = Int(siNd)
//        }
//        
//        if let spNd = dictionary["SPNeed"] as? Int {
//            spNeed = spNd
//        }else if let spNd = dictionary["SPNeed"] as? String {
//            spNeed = Int(spNd)
//        }
//        
//        if let sqNd = dictionary["SQNeed"] as? Int {
//            sqNeed = sqNd
//        }else if let sqNd = dictionary["SQNeed"] as? String {
//            sqNeed = Int(sqNd)
//        }
//        
//        if let sampleValueQty = dictionary["Sample_Val_Qty"] as? Int {
//            sampleValQty = sampleValueQty
//        }else if let sampleValueQty = dictionary["Sample_Val_Qty"] as? String {
//            sampleValQty = Int(sampleValueQty)
//        }
//        
//        if let sampleValidationNd = dictionary["sample_validation"] as? Int {
//            sampleValidation = sampleValidationNd
//        }else if let sampleValidationNd = dictionary["sample_validation"] as? String {
//            sampleValidation = Int(sampleValidationNd)
//        }
//        
//        if let secondaryOrderNd = dictionary["Secondary_order"] as? Int {
//            secondaryOrder = secondaryOrderNd
//        }else if let secondaryOrderNd = dictionary["Secondary_order"] as? String {
//            secondaryOrder = Int(secondaryOrderNd)
//        }
//        
//        secondaryOrderCaption = dictionary["Secondary_order_caption"] as? String
//        
//        if let secondaryOrderDiscountVal = dictionary["secondary_order_discount"] as? Int {
//            secondaryOrderDiscount = secondaryOrderDiscountVal
//        }else if let secondaryOrderDiscountVal = dictionary["secondary_order_discount"] as? String {
//            secondaryOrderDiscount = Int(secondaryOrderDiscountVal)
//        }
//        
//        if let sepRcpaNd = dictionary["Sep_RcpaNd"] as? Int {
//            sepRcpaNeed = sepRcpaNd
//        }else if let sepRcpaNd = dictionary["Sep_RcpaNd"] as? String {
//            sepRcpaNeed = Int(sepRcpaNd)
//        }
//        
//        if let sequentailDcrNd = dictionary["sequential_dcr"] as? Int {
//            sequentailDcr = sequentailDcrNd
//        }else if let sequentailDcrNd = dictionary["sequential_dcr"] as? String {
//            sequentailDcr = Int(sequentailDcrNd)
//        }
//        
//        if let srtNd = dictionary["SrtNd"] as? Int {
//            srtNeed = srtNd
//        }else if let srtNd = dictionary["SrtNd"] as? String {
//            srtNeed = Int(srtNd)
//        }
//        
// //       stateCode = dictionary["State_Code"] as? String
//        
//        
//        if let stateCodeValue = dictionary["State_Code"] as? Int {
//            stateCode = stateCodeValue
//        }else if let stateCodeValue = dictionary["State_Code"] as? String {
//            stateCode = Int(stateCodeValue)
//        }
//        
//        stkCap = dictionary["StkCap"] as? String
//        
//        if let stkEventMdNd = dictionary["StkEvent_Md"] as? Int {
//            stkEventMdNeed = stkEventMdNd
//        }else if let stkEventMdNd = dictionary["StkEvent_Md"] as? String {
//            stkEventMdNeed = Int(stkEventMdNd)
//        }
//        
//        if let stkNd = dictionary["StkNeed"] as? Int {
//            stkNeed = stkNd
//        }else if let stkNd = dictionary["StkNeed"] as? String {
//            stkNeed = Int(stkNd)
//        }
//        
//        stkQCap = dictionary["StkQCap"] as? String
//        
//        stkInputCaption = dictionary["Stk_Input_caption"] as? String
//        
//        if let stkPobMdNd = dictionary["Stk_Pob_Mandatory_Need"] as? Int {
//            stkPobMdNeed = stkPobMdNd
//        }else if let stkPobMdNd = dictionary["Stk_Pob_Mandatory_Need"] as? String {
//            stkPobMdNeed = Int(stkPobMdNd)
//        }
//        
//        if let stkPobNd = dictionary["Stk_Pob_Need"] as? Int {
//            stkPobNeed = stkPobNd
//        }else if let stkPobNd = dictionary["Stk_Pob_Need"] as? String {
//            stkPobNeed = Int(stkPobNd)
//        }
//        
//        stkProductCaption = dictionary["Stk_Product_caption"] as? String
//        
//        if let stkClusterBasedNd = dictionary["Stk_cluster_based"] as? Int {
//            stkClusterBased = stkClusterBasedNd
//        }else if let stkClusterBasedNd = dictionary["Stk_cluster_based"] as? String {
//            stkClusterBased = Int(stkClusterBasedNd)
//        }
//        
//        if let stkJointWrkMdNd = dictionary["Stk_jointwork_Mandatory_Need"] as? Int {
//            stkJointWrkMdNeed = stkJointWrkMdNd
//        }else if let stkJointWrkMdNd = dictionary["Stk_jointwork_Mandatory_Need"] as? String {
//            stkJointWrkMdNeed = Int(stkJointWrkMdNd)
//        }
//        
//        if let stkJointWrkNd = dictionary["Stk_jointwork_Need"] as? Int {
//            stkJointWrkNeed = stkJointWrkNd
//        }else if let stkJointWrkNd = dictionary["Stk_jointwork_Need"] as? String {
//            stkJointWrkNeed = Int(stkJointWrkNd)
//        }
//        
//        if let surveyNd = dictionary["SurveyNd"] as? Int {
//            surveyNeed = surveyNd
//        }else if let surveyNd = dictionary["SurveyNd"] as? String {
//            surveyNeed = Int(surveyNd)
//        }
//        
//        if let successVal = dictionary["success"] as? Int {
//            success = successVal
//        }else if let successVal = dictionary["success"] as? String {
//            success = Int(successVal)
//        }
//        
//        subDivisionCode = dictionary["subdivision_code"] as? String
//        
//        if let tBaseVal = dictionary["TBase"] as? Int {
//            tBase = tBaseVal
//        }else if let tBaseVal = dictionary["TBase"] as? String {
//            tBase = Int(tBaseVal)
//        }
//        
//        if let tpdcrDeviationNd = dictionary["TPDCR_Deviation"] as? Int {
//            tpdcrDeviation = tpdcrDeviationNd
//        }else if let tpdcrDeviationNd = dictionary["TPDCR_Deviation"] as? String {
//            tpdcrDeviation = Int(tpdcrDeviationNd)
//        }
//        
//        if let tpdcrDeviationApprStatusVal = dictionary["TPDCR_Deviation_Appr_Status"] as? Int {
//            tpdcrDeviationApprStatus = tpdcrDeviationApprStatusVal
//        }else if let tpdcrDeviationApprStatusVal = dictionary["TPDCR_Deviation_Appr_Status"] as? String {
//            tpdcrDeviationApprStatus = Int(tpdcrDeviationApprStatusVal)
//        }
//        
//        if let tpdcrMgrApprVal = dictionary["TPDCR_MGRAppr"] as? Int {
//            tpdcrMgrAppr = tpdcrMgrApprVal
//        }else if let tpdcrMgrApprVal = dictionary["TPDCR_MGRAppr"] as? String {
//            tpdcrMgrAppr = Int(tpdcrMgrApprVal)
//        }
//        
//        if let tpMdNd = dictionary["TP_Mandatory_Need"] as? Int {
//            tpMdNeed = tpMdNd
//        }else if let tpMdNd = dictionary["TP_Mandatory_Need"] as? String {
//            tpMdNeed = Int(tpMdNd)
//        }
//        
//        if let tpBasedDcrVal = dictionary["TPbasedDCR"] as? Int {
//            tpBasedDcr = tpBasedDcrVal
//        }else if let tpBasedDcrVal = dictionary["TPbasedDCR"] as? String {
//            tpBasedDcr = Int(tpBasedDcrVal)
//        }
//        
//        if let targetReportNd = dictionary["Target_report_Nd"] as? Int {
//            targetReportNeed = targetReportNd
//        }else if let targetReportNd = dictionary["Target_report_Nd"] as? String {
//            targetReportNeed = Int(targetReportNd)
//        }
//        
//        if let targetReportMdNd = dictionary["Target_report_md"] as? Int {
//            targetReportMdNeed = targetReportMdNd
//        }else if let targetReportMdNd = dictionary["Target_report_md"] as? String {
//            targetReportMdNeed = Int(targetReportMdNd)
//        }
//        
//        taxNameCaption = dictionary["Taxname_caption"] as? String
//        
//        if let tempNd = dictionary["TempNd"] as? Int {
//            tempNeed = tempNd
//        }else if let tempNd = dictionary["TempNd"] as? String {
//            tempNeed = Int(tempNd)
//        }
//        
//        if let terrBasedTagVal = dictionary["Terr_based_Tag"] as? Int {
//            terrBasedTag = terrBasedTagVal
//        }else if let terrBasedTagVal = dictionary["Terr_based_Tag"] as? String {
//            terrBasedTag = Int(terrBasedTagVal)
//        }
//        
//        if let terrotoryVisitNd = dictionary["Territory_VstNd"] as? Int {
//            terrotoryVisitNeed = terrotoryVisitNd
//        }else if let terrotoryVisitNd = dictionary["Territory_VstNd"] as? String {
//            terrotoryVisitNeed = Int(terrotoryVisitNd)
//        }
//        
//        if let tpEndDateVal = dictionary["Tp_End_Date"] as? Int {
//            tpEndDate = tpEndDateVal
//        }else if let tpEndDateVal = dictionary["Tp_End_Date"] as? String {
//            tpEndDate = Int(tpEndDateVal)
//        }
//        
//        if let tpstartDateVal = dictionary["Tp_Start_Date"] as? Int {
//            tpstartDate = tpstartDateVal
//        }else if let tpstartDateVal = dictionary["Tp_Start_Date"] as? String {
//            tpstartDate = Int(tpstartDateVal)
//        }
//        
//        if let tpNd = dictionary["tp_need"] as? Int {
//            tpNeed = tpNd
//        }else if let tpNd = dictionary["tp_need"] as? String {
//            tpNeed = Int(tpNd)
//        }
//        
//        if let tpnewVal = dictionary["tp_new"] as? Int {
//            tpnew = tpnewVal
//        }else if let tpnewVal = dictionary["tp_new"] as? String {
//            tpnew = Int(tpnewVal)
//        }
//         
//        trackingTime = dictionary["tracking_time"] as? String
//        
//        if let travelDistanceNd = dictionary["travelDistance_Need"] as? Int {
//            travelDistanceNeed = travelDistanceNd
//        }else if let travelDistanceNd = dictionary["travelDistance_Need"] as? String {
//            travelDistanceNeed = Int(travelDistanceNd)
//        }
//        
//        if let unlNd = dictionary["UNLNeed"] as? Int {
//            unlNeed = unlNd
//        }else if let unlNd = dictionary["UNLNeed"] as? String {
//            unlNeed = Int(unlNd)
//        }
//        
//        if let ulDocClusterBasedNd = dictionary["UlDoc_cluster_based"] as? Int {
//            ulDocClusterBased = ulDocClusterBasedNd
//        }else if let ulDocClusterBasedNd = dictionary["UlDoc_cluster_based"] as? String {
//            ulDocClusterBased = Int(ulDocClusterBasedNd)
//        }
//        
//        if let ulDocEventMdNd = dictionary["UlDrEvent_Md"] as? Int {
//            ulDocEventMd = ulDocEventMdNd
//        }else if let ulDocEventMdNd = dictionary["UlDrEvent_Md"] as? String {
//            ulDocEventMd = Int(ulDocEventMdNd)
//        }
//        
//        ulInputCaption = dictionary["Ul_Input_caption"] as? String
//        
//        if let ulPobMdNd = dictionary["Ul_Pob_Mandatory_Need"] as? Int {
//            ulPobMdNeed = ulPobMdNd
//        }else if let ulPobMdNd = dictionary["Ul_Pob_Mandatory_Need"] as? String {
//            ulPobMdNeed = Int(ulPobMdNd)
//        }
//        
//        if let ulPobNd = dictionary["Ul_Pob_Need"] as? Int {
//            ulPobNeed = ulPobNd
//        }else if let ulPobNd = dictionary["Ul_Pob_Need"] as? String {
//            ulPobNeed = Int(ulPobNd)
//        }
//        
//        ulProductCaption = dictionary["Ul_Product_caption"] as? String
//        
//        if let ulJointWrlMdNd = dictionary["Ul_jointwork_Mandatory_Need"] as? Int {
//            ulJointWrlMdNeed = ulJointWrlMdNd
//        }else if let ulJointWrlMdNd = dictionary["Ul_jointwork_Mandatory_Need"] as? String {
//            ulJointWrlMdNeed = Int(ulJointWrlMdNd)
//        }
//        
//        if let ulJointWrlNd = dictionary["Ul_jointwork_Need"] as? Int {
//            ulJointWrlNeed = ulJointWrlNd
//        }else if let ulJointWrlNd = dictionary["Ul_jointwork_Need"] as? String {
//            ulJointWrlNeed = Int(ulJointWrlNd)
//        }
//        
//        usrDfdUserName = dictionary["UsrDfd_UserName"] as? String
//        
//        if let visitNd = dictionary["VstNd"] as? Int {
//            visitNeed = visitNd
//        }else if let visitNd = dictionary["VstNd"] as? String {
//            visitNeed = Int(visitNd)
//        }
//        
//        workAreaName = dictionary["wrk_area_Name"] as? String
// 
//    }
//    
//    
//    
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        
//        if activityNeed != nil{
//            dictionary["ActivityNd"] = activityNeed
//        }
//        if androidApp != nil{
//            dictionary["Android_App"] = androidApp
//        }
//        if androidDetailing != nil{
//            dictionary["Android_Detailing"] = androidDetailing
//        }
//        if apprMandatoryNeed != nil{
//            dictionary["Appr_Mandatory_Need"] = apprMandatoryNeed
//        }
//        if approvalNeed != nil{
//            dictionary["Approveneed"] = approvalNeed
//        }
//        if attendance != nil{
//            dictionary["Attendance"] = attendance
//        }
//        if appDeviceId != nil{
//            dictionary["app_device_id"] = appDeviceId
//        }
//        if callFeedEnterable != nil{
//            dictionary["call_feed_enterable"] = callFeedEnterable
//        }
//        if callReport != nil{
//            dictionary["call_report"] = callReport
//        }
//        if callReportFromDate != nil{
//            dictionary["call_report_from_date"] = callReportFromDate
//        }
//        if callReportToDate != nil{
//            dictionary["call_report_to_date"] = callReportToDate
//        }
//        if chmAdQty != nil{
//            dictionary["chm_ad_qty"] = chmAdQty
//        }
//        if chmSampleQtyNeed != nil{
//            dictionary["chmsamQty_need"] = chmSampleQtyNeed
//        }
//        if cipNeed != nil{
//            dictionary["cip_need"] = cipNeed
//        }
//        if circular != nil{
//            dictionary["circular"] = circular
//        }
//        if cntRemarks != nil{
//            dictionary["cntRemarks"] = cntRemarks
//        }
//        if currentDay != nil{
//            dictionary["currentDay"] = currentDay
//        }
//        if ceNeed != nil{
//            dictionary["CENeed"] = ceNeed
//        }
//        if cfNeed != nil{
//            dictionary["CFNeed"] = cfNeed
//        }
//        if cheBase != nil{
//            dictionary["CHEBase"] = cheBase
//        }
//        if ciNeed != nil{
//            dictionary["CINeed"] = ciNeed
//        }
//        if cipPobMdNeed != nil{
//            dictionary["CIPPOBMd"] = cipPobMdNeed
//        }
//        if cipPobNeed != nil{
//            dictionary["CIPPOBNd"] = cipPobNeed
//        }
//        if cipCaption != nil{
//            dictionary["CIP_Caption"] = cipCaption
//        }
//        if cipENeed != nil{
//            dictionary["CIP_ENeed"] = cipENeed
//        }
//        if cipFNeed != nil{
//            dictionary["CIP_FNeed"] = cipFNeed
//        }
//        if cipINeed != nil{
//            dictionary["CIP_INeed"] = cipINeed
//        }
//        if cipPNeed != nil{
//            dictionary["CIP_PNeed"] = cipPNeed
//        }
//        if cipQNeed != nil{
//            dictionary["CIP_QNeed"] = cipQNeed
//        }
//        if cipJointWrkNeed != nil{
//            dictionary["CIP_jointwork_Need"] = cipJointWrkNeed
//        }
//        if cpNeed != nil{
//            dictionary["CPNeed"] = cpNeed
//        }
//        if cqNeed != nil{
//            dictionary["CQNeed"] = cqNeed
//        }
//        if campNeed != nil{
//            dictionary["Campneed"] = campNeed
//        }
//        if catNeed != nil{
//            dictionary["Catneed"] = catNeed
//        }
//        if chmCap != nil{
//            dictionary["ChmCap"] = chmCap
//        }
//        if chmEventMdNeed != nil{
//            dictionary["ChmEvent_Md"] = chmEventMdNeed
//        }
//        if chmNeed != nil{
//            dictionary["ChmNeed"] = chmNeed
//        }
//        if chmQcap != nil{
//            dictionary["ChmQCap"] = chmQcap
//        }
//        if chmRcpaCompetitorNeed != nil{
//            dictionary["ChmRCPA_competitor_Need"] = chmRcpaCompetitorNeed
//        }
//        if chmRxQtyNeed != nil{
//            dictionary["ChmRxQty"] = chmRxQtyNeed
//        }
//        if chmSampleCap != nil{
//            dictionary["ChmSmpCap"] = chmSampleCap
//        }
//        if chmInputCaption != nil{
//            dictionary["Chm_Input_caption"] = chmInputCaption
//        }
//        if chmPobMandatoryNeed != nil{
//            dictionary["Chm_Pob_Mandatory_Need"] = chmPobMandatoryNeed
//        }
//        if chmPobNeed != nil{
//            dictionary["Chm_Pob_Need"] = chmPobNeed
//        }
//        if chmProductCaption != nil{
//            dictionary["Chm_Product_caption"] = chmProductCaption
//        }
//        if chmRcpaNeed != nil{
//            dictionary["Chm_RCPA_Need"] = chmRcpaNeed
//        }
//        if chmClusterBased != nil{
//            dictionary["Chm_cluster_based"] = chmClusterBased
//        }
//        if chmJointWrkMdNeed != nil{
//            dictionary["Chm_jointwork_Mandatory_Need"] = chmJointWrkMdNeed
//        }
//        if chmJointWrkNeed != nil{
//            dictionary["Chm_jointwork_Need"] = chmJointWrkNeed
//        }
//        if cipEventMdNeed != nil{
//            dictionary["CipEvent_Md"] = cipEventMdNeed
//        }
//        if cipSrtNd != nil{
//            dictionary["CipSrtNd"] = cipSrtNd
//        }
//        if clusterCap != nil{
//            dictionary["Cluster_Cap"] = clusterCap
//        }
//        if cmpgnNeed != nil{
//            dictionary["CmpgnNeed"] = cmpgnNeed
//        }
//        if currentdayTpPlanned != nil{
//            dictionary["Currentday_TPplanned"] = currentdayTpPlanned
//        }
//        if custSrtNeed != nil{
//            dictionary["CustSrtNd"] = custSrtNeed
//        }
//        if deNeed != nil{
//            dictionary["DENeed"] = deNeed
//        }
//        if dfNeed != nil{
//            dictionary["DFNeed"] = dfNeed
//        }
//        if diNeed != nil{
//            dictionary["DINeed"] = diNeed
//        }
//        if dpNeed != nil{
//            dictionary["DPNeed"] = dpNeed
//        }
//        if dqNeed != nil{
//            dictionary["DQNeed"] = dqNeed
//        }
//        if dsName != nil{
//            dictionary["DS_name"] = dsName
//        }
//        if dcrLockDays != nil{
//            dictionary["DcrLockDays"] = dcrLockDays
//        }
//        if dcrFirstSelfieNeed != nil{
//            dictionary["Dcr_firstselfie"] = dcrFirstSelfieNeed
//        }
//        if desig != nil{
//            dictionary["Desig"] = desig
//        }
//        if detailingChem != nil{
//            dictionary["Detailing_chem"] = detailingChem
//        }
//        if detailingType != nil{
//            dictionary["Detailing_type"] = detailingType
//        }
//        if deviceIdNeed != nil{
//            dictionary["DeviceId_Need"] = deviceIdNeed
//        }
//        if deviceRegId != nil{
//            dictionary["DeviceRegId"] = deviceRegId
//        }
//        if disRad != nil{
//            dictionary["DisRad"] = disRad
//        }
//        if divisionCode != nil{
//            dictionary["Division_Code"] = divisionCode
//        }
//        if dlyCtrl != nil{
//            dictionary["DlyCtrl"] = dlyCtrl
//        }
//        if docInputCaption != nil{
//            dictionary["Doc_Input_caption"] = docInputCaption
//        }
//        if docPobMandatoryNeed != nil{
//            dictionary["Doc_Pob_Mandatory_Need"] = docPobMandatoryNeed
//        }
//        if docPobNeed != nil{
//            dictionary["Doc_Pob_Need"] = docPobNeed
//        }
//        if docProductCaption != nil{
//            dictionary["Doc_Product_caption"] = docProductCaption
//        }
//        if docClusterBased != nil{
//            dictionary["Doc_cluster_based"] = docClusterBased
//        }
//        if docJointWrkMdNeed != nil{
//            dictionary["Doc_jointwork_Mandatory_Need"] = docJointWrkMdNeed
//        }
//        if docJointWrkNeed != nil{
//            dictionary["Doc_jointwork_Need"] = docJointWrkNeed
//        }
//        if docCap != nil{
//            dictionary["DrCap"] = docCap
//        }
//        if docEventMdNeed != nil{
//            dictionary["DrEvent_Md"] = docEventMdNeed
//        }
//        if docFeedMdNeed != nil{
//            dictionary["DrFeedMd"] = docFeedMdNeed
//        }
//        if docInputMdNeed != nil{
//            dictionary["DrInpMd"] = docInputMdNeed
//        }
//        if docNeed != nil{
//            dictionary["DrNeed"] = docNeed
//        }
//        if docProductMdNeed != nil{
//            dictionary["DrPrdMd"] = docProductMdNeed
//        }
//        if docRcpaCompetitorNeed != nil{
//            dictionary["DrRCPA_competitor_Need"] = docRcpaCompetitorNeed
//        }
//        if docRcpaQMdNeed != nil{
//            dictionary["DrRcpaQMd"] = docRcpaQMdNeed
//        }
//        if docRxNeed != nil{
//            dictionary["DrRxNd"] = docRxNeed
//        }
//        if docRxQCap != nil{
//            dictionary["DrRxQCap"] = docRxQCap
//        }
//        if docRxQMd != nil{
//            dictionary["DrRxQMd"] = docRxQMd
//        }
//        if docSampleNeed != nil{
//            dictionary["DrSampNd"] = docSampleNeed
//        }
//        if docSampleQCap != nil{
//            dictionary["DrSmpQCap"] = docSampleQCap
//        }
//        if docSampleQMdNeed != nil{
//            dictionary["DrSmpQMd"] = docSampleQMdNeed
//        }
//        if dashboard != nil{
//            dictionary["dashboard"] = dashboard
//        }
//        if dayplanTpBased != nil{
//            dictionary["dayplan_tp_based"] = dayplanTpBased
//        }
//        if days != nil{
//            dictionary["days"] = days
//        }
//        if dcrDocBusinessProduct != nil{
//            dictionary["dcr_doc_business_product"] = dcrDocBusinessProduct
//        }
//        if desigCode != nil{
//            dictionary["desig_Code"] = desigCode
//        }
//        if docBusinessProduct != nil{
//            dictionary["doc_business_product"] = docBusinessProduct
//        }
//        if docBusinessValue != nil{
//            dictionary["doc_business_value"] = docBusinessValue
//        }
//        if doctorDobDow != nil{
//            dictionary["doctor_dobdow"] = doctorDobDow
//        }
//        if expenceNeed != nil{
//            dictionary["ExpenceNd"] = expenceNeed
//        }
//        if expenceMdNeed != nil{
//            dictionary["ExpenceNd_mandatory"] = expenceMdNeed
//        }
//        if expenseNeed != nil{
//            dictionary["Expenseneed"] = expenseNeed
//        }
//        if editHoliday != nil{
//            dictionary["edit_holiday"] = editHoliday
//        }
//        if editWeeklyOff != nil{
//            dictionary["edit_weeklyoff"] = editWeeklyOff
//        }
//        if entryformMgr != nil{
//            dictionary["entryFormMgr"] = entryformMgr
//        }
//        if entryFormNeed != nil{
//            dictionary["entryFormNeed"] = entryFormNeed
//        }
//        if expense_Need != nil{
//            dictionary["expense_need"] = expense_Need
//        }
//        if faq != nil{
//            dictionary["faq"] = faq
//        }
//        if geoTagNeed != nil{
//            dictionary["GEOTagNeed"] = geoTagNeed
//        }
//        if geoTagNeedChe != nil{
//            dictionary["GEOTagNeedche"] = geoTagNeedChe
//        }
//        if geoTagNeedStock != nil{
//            dictionary["GEOTagNeedstock"] = geoTagNeedStock
//        }
//        if geoTagNeedUnList != nil{
//            dictionary["GEOTagNeedunlst"] = geoTagNeedUnList
//        }
//        if geoCheck != nil{
//            dictionary["GeoChk"] = geoCheck
//        }
//        if geoNeed != nil{
//            dictionary["GeoNeed"] = geoNeed
//        }
//        if geoTagNeedCip != nil{
//            dictionary["GeoTagNeedcip"] = geoTagNeedCip
//        }
//        if gstOption != nil{
//            dictionary["Gst_option"] = gstOption
//        }
//        if geoTagImg != nil{
//            dictionary["geoTagImg"] = geoTagImg
//        }
//        if heNeed != nil{
//            dictionary["HENeed"] = heNeed
//        }
//        if hfNeed != nil{
//            dictionary["HFNeed"] = hfNeed
//        }
//        if hiNeed != nil{
//            dictionary["HINeed"] = hiNeed
//        }
//        if hpNeed != nil{
//            dictionary["HPNeed"] = hpNeed
//        }
//        if hqName != nil{
//            dictionary["HQName"] = hqName
//        }
//        if hqNeed != nil{
//            dictionary["HQNeed"] = hqNeed
//        }
//        if hosPobMdNeed != nil{
//            dictionary["HosPOBMd"] = hosPobMdNeed
//        }
//        if hosPobNeed != nil{
//            dictionary["HosPOBNd"] = hosPobNeed
//        }
//        if hospEventNeed != nil{
//            dictionary["HospEvent_Md"] = hospEventNeed
//        }
//        if hospCaption != nil{
//            dictionary["hosp_caption"] = hospCaption
//        }
//        if hospNeed != nil{
//            dictionary["hosp_need"] = hospNeed
//        }
//        if inputValQty != nil{
//            dictionary["Input_Val_Qty"] = inputValQty
//        }
//        if inputValidation != nil{
//            dictionary["input_validation"] = inputValidation
//        }
//        if leaveStatus != nil{
//            dictionary["LeaveStatus"] = leaveStatus
//        }
//        if leaveEntitlementNeed != nil{
//            dictionary["Leave_entitlement_need"] = leaveEntitlementNeed
//        }
//        if locationTrack != nil{
//            dictionary["Location_track"] = locationTrack
//        }
//        if iosApp != nil{
//            dictionary["ios_app"] = iosApp
//        }
//        if iosDetailing != nil{
//            dictionary["ios_Detailing"] = iosDetailing
//        }
//        if mclDet != nil{
//            dictionary["MCLDet"] = mclDet
//        }
//        if mgrHlfDy != nil{
//            dictionary["MGRHlfDy"] = mgrHlfDy
//        }
//        if mrHlfDy != nil{
//            dictionary["MRHlfDy"] = mrHlfDy
//        }
//        if msdEntry != nil{
//            dictionary["MsdEntry"] = msdEntry
//        }
//        if mailNeed != nil{
//            dictionary["mailneed"] = mailNeed
//        }
//        if miscExpenseNeed != nil{
//            dictionary["misc_expense_need"] = miscExpenseNeed
//        }
//        if missedDateMdNeed != nil{
//            dictionary["missedDateMand"] = missedDateMdNeed
//        }
//        if multiClusterNeed != nil{
//            dictionary["multi_cluster"] = multiClusterNeed
//        }
//        if multipleDocNeed != nil{
//            dictionary["multiple_doc_need"] = multipleDocNeed
//        }
//        if mydayplanNeed != nil{
//            dictionary["mydayplan_need"] = mydayplanNeed
//        }
//        if myPlnRmrksMand != nil{
//            dictionary["myplnRmrksMand"] = myPlnRmrksMand
//        }
//        if neNeed != nil{
//            dictionary["NENeed"] = neNeed
//        }
//        if nfNeed != nil{
//            dictionary["NFNeed"] = nfNeed
//        }
//        if niNeed != nil{
//            dictionary["NINeed"] = niNeed
//        }
//        if nlCap != nil{
//            dictionary["NLCap"] = nlCap
//        }
//        if nlRxQCap != nil{
//            dictionary["NLRxQCap"] = nlRxQCap
//        }
//        if nlSampleQCap != nil{
//            dictionary["NLSmpQCap"] = nlSampleQCap
//        }
//        if npNeed != nil{
//            dictionary["NPNeed"] = npNeed
//        }
//        if nqNeed != nil{
//            dictionary["NQNeed"] = nqNeed
//        }
//        if nextVst != nil{
//            dictionary["NextVst"] = nextVst
//        }
//        if nextVstMdNeed != nil{
//            dictionary["NextVst_Mandatory_Need"] = nextVstMdNeed
//        }
//        if noOfTpView != nil{
//            dictionary["No_of_TP_View"] = noOfTpView
//        }
//        if orderCaption != nil{
//            dictionary["Order_caption"] = orderCaption
//        }
//        if orderManagement != nil{
//            dictionary["Order_management"] = orderManagement
//        }
//        if otherNeed != nil{
//            dictionary["OtherNd"] = otherNeed
//        }
//        if primaryOrder != nil{
//            dictionary["Primary_order"] = primaryOrder
//        }
//        if primaryOrderCap != nil{
//            dictionary["Primary_order_caption"] = primaryOrderCap
//        }
//        if prodStkNeed != nil{
//            dictionary["Prod_Stk_Need"] = prodStkNeed
//        }
//        if productRateEditable != nil{
//            dictionary["Product_Rate_Editable"] = productRateEditable
//        }
//        if pwdSetup != nil{
//            dictionary["Pwdsetup"] = pwdSetup
//        }
//        if pastLeavePost != nil{
//            dictionary["past_leave_post"] = pastLeavePost
//        }
//        if pobMinValue != nil{
//            dictionary["pob_minvalue"] = pobMinValue
//        }
//        if productFeedBack != nil{
//            dictionary["prdfdback"] = productFeedBack
//        }
//        if primarySecNeed != nil{
//            dictionary["primarysec_need"] = primarySecNeed
//        }
//        if prodDetNeed != nil{
//            dictionary["pro_det_need"] = prodDetNeed
//        }
//        if prodDetNeed != nil{
//            dictionary["prod_det_need"] = prodDetNeed
//        }
//        if productRemarkNeed != nil{
//            dictionary["prod_remark"] = productRemarkNeed
//        }
//        if productRemarkMdNeed != nil{
//            dictionary["prod_remark_md"] = productRemarkMdNeed
//        }
//        if productPobNeed != nil{
//            dictionary["product_pob_need"] = productPobNeed
//        }
//        if productPobNeedMsg != nil{
//            dictionary["product_pob_need_msg"] = productPobNeedMsg
//        }
//        if quesNeed != nil{
//            dictionary["ques_need"] = quesNeed
//        }
//        if quizHeading != nil{
//            dictionary["quiz_heading"] = quizHeading
//        }
//        if quizNeed != nil{
//            dictionary["quiz_need"] = quizNeed
//        }
//        if quizMandNeed != nil{
//            dictionary["quiz_need_mandt"] = quizMandNeed
//        }
//        if quoteText != nil{
//            dictionary["quote_Text"] = quoteText
//        }
//        if rcpaQtyNeed != nil{
//            dictionary["RCPAQty_Need"] = rcpaQtyNeed
//        }
//        if rcpaUnitNeed != nil{
//            dictionary["RCPA_unit_nd"] = rcpaUnitNeed
//        }
//        if rcpaMdNeed != nil{
//            dictionary["RcpaMd"] = rcpaMdNeed
//        }
//        if rcpaMgrMdNeed != nil{
//            dictionary["RcpaMd_Mgr"] = rcpaMgrMdNeed
//        }
//        if rcpaNeed != nil{
//            dictionary["RcpaNd"] = rcpaNeed
//        }
//        if rcpaCompetitorExtra != nil{
//            dictionary["Rcpa_Competitor_extra"] = rcpaCompetitorExtra
//        }
//        if remainderCallCap != nil{
//            dictionary["Remainder_call_cap"] = remainderCallCap
//        }
//        if remainderGeo != nil{
//            dictionary["Remainder_geo"] = remainderGeo
//        }
//        if remainderProductMd != nil{
//            dictionary["Remainder_prd_Md"] = remainderProductMd
//        }
//        if rmdrNeed != nil{
//            dictionary["RmdrNeed"] = rmdrNeed
//        }
//        if rcpaextra != nil{
//            dictionary["rcpaextra"] = rcpaextra
//        }
//        if refDoc != nil{
//            dictionary["refDoc"] = refDoc
//        }
//        if seNeed != nil{
//            dictionary["SENeed"] = seNeed
//        }
//        if sfNeed != nil{
//            dictionary["SFNeed"] = sfNeed
//        }
//        if sfStat != nil{
//            dictionary["SFStat"] = sfStat
//        }
//        if sfCode != nil{
//            dictionary["SF_Code"] = sfCode
//        }
//        if sfName != nil{
//            dictionary["SF_Name"] = sfName
//        }
//        if sfPassword != nil{
//            dictionary["SF_Password"] = sfPassword
//        }
//        if sfUserName != nil{
//            dictionary["SF_User_Name"] = sfUserName
//        }
//        if sfEmail != nil{
//            dictionary["sfEmail"] = sfEmail
//        }
//        if sfMobile != nil{
//            dictionary["sfMobile"] = sfMobile
//        }
//        if sfEmpId != nil{
//            dictionary["sf_emp_id"] = sfEmpId
//        }
//        if sfType != nil{
//            dictionary["sf_type"] = sfType
//        }
//        if stp != nil{
//            dictionary["stp"] = stp
//        }
//        if siNeed != nil{
//            dictionary["SINeed"] = siNeed
//        }
//        if spNeed != nil{
//            dictionary["SPNeed"] = spNeed
//        }
//        if sqNeed != nil{
//            dictionary["SQNeed"] = sqNeed
//        }
//        if sampleValQty != nil{
//            dictionary["Sample_Val_Qty"] = sampleValQty
//        }
//        if sampleValidation != nil{
//            dictionary["sample_validation"] = sampleValidation
//        }
//        if secondaryOrder != nil{
//            dictionary["Secondary_order"] = secondaryOrder
//        }
//        if secondaryOrderCaption != nil{
//            dictionary["Secondary_order_caption"] = secondaryOrderCaption
//        }
//        if secondaryOrderDiscount != nil{
//            dictionary["secondary_order_discount"] = secondaryOrderDiscount
//        }
//        if sepRcpaNeed != nil{
//            dictionary["Sep_RcpaNd"] = sepRcpaNeed
//        }
//        if sequentailDcr != nil{
//            dictionary["sequential_dcr"] = sequentailDcr
//        }
//        if srtNeed != nil{
//            dictionary["SrtNd"] = srtNeed
//        }
//        if stateCode != nil{
//            dictionary["State_Code"] = stateCode
//        }
//        if stkCap != nil{
//            dictionary["StkCap"] = stkCap
//        }
//        if stkEventMdNeed != nil{
//            dictionary["StkEvent_Md"] = stkEventMdNeed
//        }
//        if stkNeed != nil{
//            dictionary["StkNeed"] = stkNeed
//        }
//        if stkQCap != nil{
//            dictionary["StkQCap"] = stkQCap
//        }
//        if stkInputCaption != nil{
//            dictionary["Stk_Input_caption"] = stkInputCaption
//        }
//        if stkPobMdNeed != nil{
//            dictionary["Stk_Pob_Mandatory_Need"] = stkPobMdNeed
//        }
//        if stkPobNeed != nil{
//            dictionary["Stk_Pob_Need"] = stkPobNeed
//        }
//        if stkProductCaption != nil{
//            dictionary["Stk_Product_caption"] = stkProductCaption
//        }
//        if stkClusterBased != nil{
//            dictionary["Stk_cluster_based"] = stkClusterBased
//        }
//        if stkJointWrkMdNeed != nil{
//            dictionary["Stk_jointwork_Mandatory_Need"] = stkJointWrkMdNeed
//        }
//        if stkJointWrkNeed != nil{
//            dictionary["Stk_jointwork_Need"] = stkJointWrkNeed
//        }
//        if surveyNeed != nil{
//            dictionary["SurveyNd"] = surveyNeed
//        }
//        if success != nil{
//            dictionary["success"] = success
//        }
//        if subDivisionCode != nil{
//            dictionary["subdivision_code"] = subDivisionCode
//        }
//        if tBase != nil{
//            dictionary["TBase"] = tBase
//        }
//        if tpdcrDeviation != nil{
//            dictionary["TPDCR_Deviation"] = tpdcrDeviation
//        }
//        if tpdcrDeviationApprStatus != nil{
//            dictionary["TPDCR_Deviation_Appr_Status"] = tpdcrDeviationApprStatus
//        }
//        if tpdcrMgrAppr != nil{
//            dictionary["TPDCR_MGRAppr"] = tpdcrMgrAppr
//        }
//        if tpMdNeed != nil{
//            dictionary["TP_Mandatory_Need"] = tpMdNeed
//        }
//        if tpBasedDcr != nil{
//            dictionary["TPbasedDCR"] = tpBasedDcr
//        }
//        if targetReportNeed != nil{
//            dictionary["Target_report_Nd"] = targetReportNeed
//        }
//        if targetReportMdNeed != nil{
//            dictionary["Target_report_md"] = targetReportMdNeed
//        }
//        if taxNameCaption != nil{
//            dictionary["Taxname_caption"] = taxNameCaption
//        }
//        if tempNeed != nil{
//            dictionary["TempNd"] = tempNeed
//        }
//        if terrBasedTag != nil{
//            dictionary["Terr_based_Tag"] = terrBasedTag
//        }
//        if terrotoryVisitNeed != nil{
//            dictionary["Territory_VstNd"] = terrotoryVisitNeed
//        }
//        if tpEndDate != nil{
//            dictionary["Tp_End_Date"] = tpEndDate
//        }
//        if tpstartDate != nil{
//            dictionary["Tp_Start_Date"] = tpstartDate
//        }
//        if tpNeed != nil{
//            dictionary["tp_need"] = tpNeed
//        }
//        if tpnew != nil{
//            dictionary["tp_new"] = tpnew
//        }
//        if trackingTime != nil{
//            dictionary["tracking_time"] = trackingTime
//        }
//        if travelDistanceNeed != nil{
//            dictionary["travelDistance_Need"] = travelDistanceNeed
//        }
//        if tpstartDate != nil{
//            dictionary["Tp_Start_Date"] = tpstartDate
//        }
//        if tpNeed != nil{
//            dictionary["tp_need"] = tpNeed
//        }
//        if tpnew != nil{
//            dictionary["tp_new"] = tpnew
//        }
//        if trackingTime != nil{
//            dictionary["tracking_time"] = trackingTime
//        }
//        if travelDistanceNeed != nil{
//            dictionary["travelDistance_Need"] = travelDistanceNeed
//        }
//        if unlNeed != nil{
//            dictionary["UNLNeed"] = unlNeed
//        }
//        if ulDocClusterBased != nil{
//            dictionary["UlDoc_cluster_based"] = ulDocClusterBased
//        }
//        if ulDocEventMd != nil{
//            dictionary["UlDrEvent_Md"] = ulDocEventMd
//        }
//        if ulInputCaption != nil{
//            dictionary["Ul_Input_caption"] = ulInputCaption
//        }
//        if ulPobMdNeed != nil{
//            dictionary["Ul_Pob_Mandatory_Need"] = ulPobMdNeed
//        }
//        if ulPobNeed != nil{
//            dictionary["Ul_Pob_Need"] = ulPobNeed
//        }
//        if ulProductCaption != nil{
//            dictionary["Ul_Product_caption"] = ulProductCaption
//        }
//        if ulJointWrlMdNeed != nil{
//            dictionary["Ul_jointwork_Mandatory_Need"] = ulJointWrlMdNeed
//        }
//        if ulJointWrlNeed != nil{
//            dictionary["Ul_jointwork_Need"] = ulJointWrlNeed
//        }
//        if usrDfdUserName != nil{
//            dictionary["UsrDfd_UserName"] = usrDfdUserName
//        }
//        if visitNeed != nil{
//            dictionary["VstNd"] = visitNeed
//        }
//        if workAreaName != nil{
//            dictionary["wrk_area_Name"] = workAreaName
//        }
//        
//        return dictionary
//    }
//    
//    
//}
