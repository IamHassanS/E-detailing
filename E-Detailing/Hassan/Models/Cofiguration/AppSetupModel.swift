//
//  AppSetupModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/01/24.
//

import Foundation



class AppSetUp : Codable {
    var successMessage : String?
    var isSuccess : Bool?
    var activityNeed : Int?
    var androidApp : Int?
    var androidDetailing : Int?
    var apprMandatoryNeed : Int?
    var approvalNeed : Int?
    var attendance : Int?
    var appDeviceId : String?
    var callFeedEnterable : Int?
    var callReport : String?
    var callReportFromDate : String?
    var callReportToDate : String?
    var chmAdQty : Int?
    var chmSampleQtyNeed : Int?
    var cipNeed : Int?
    var circular : Int?
    var cntRemarks : Int?
    var currentDay : Int?
    var ceNeed : Int?
    var cfNeed : Int?
    var cheBase :Int?
    var ciNeed : Int?
    var cipPobMdNeed : Int?
    var cipPobNeed : Int?
    var cipCaption : String?
    var cipENeed : Int?
    var cipFNeed : Int?
    var cipINeed : Int?
    var cipPNeed : Int?
    var cipQNeed :Int?
    var cipJointWrkNeed : Int?
    var cpNeed : Int?
    var cqNeed : Int?
    var campNeed : Int?
    var catNeed : Int?
    var chmCap : String?
    var chmEventMdNeed : Int?
    var chmNeed : Int?
    var chmQcap :String?
    var chmRcpaCompetitorNeed : Int?
    var chmRxQtyNeed : Int?
    var chmSampleCap : String?
    var chmInputCaption : String?
    var chmPobMandatoryNeed : Int?
    var chmPobNeed : Int?
    var chmProductCaption : String?
    var chmRcpaNeed : Int?
    var chmClusterBased :Int?
    var chmJointWrkMdNeed : Int?
    var chmJointWrkNeed : Int?
    var cipEventMdNeed : Int?
    var cipSrtNd : Int?
    var clusterCap : String?
    var cmpgnNeed : Int?
    var currentdayTpPlanned : Int?
    var custSrtNeed : Int?
    var deNeed : Int?
    var dfNeed :Int?
    var diNeed : Int?
    var dpNeed : Int?
    var dqNeed : Int?
    var dsName : String?
    var dcrLockDays : Int?
    var dcrFirstSelfieNeed : Int?
    var desig : String?
    var detailingChem : Int?
    var detailingstk : Int?
    var detailingUdr : Int?
    
    var detailingType :Int?
    var deviceIdNeed : Int?
    var deviceRegId : String?
    var disRad : String?
    var divisionCode : String?
    var divisionName :String?
    var dlyCtrl : Int?
    var docInputCaption : String?
    var docPobMandatoryNeed : Int?
    var docPobNeed : Int?
    var  unListedDocPobNeed : Int?
    var docProductCaption :String?
    var docClusterBased : Int?
    var docJointWrkMdNeed :Int?
    var docAdditionalCallNeed : Int?
    var docJointWrkNeed : Int?
    var docCap : String?
    var docEventMdNeed : Int?
    var docFeedMdNeed : Int?
    var docInputMdNeed : Int?
    var docNeed : Int?
    var docProductMdNeed : Int?
    var docRcpaCompetitorNeed : Int?
    var docRcpaQMdNeed : Int?
    var docRxNeed :Int?
    var docRxQCap : String?
    var docRxQMd :Int?
    var docSampleNeed : Int?
    var docSampleQCap : String?
    var docSampleQMdNeed : Int?
    var dashboard : Int?
    var dayplanTpBased : Int?
    var days : Int?
    var dcrDocBusinessProduct : Int?
    var desigCode : String?
    var docBusinessProduct : Int?
    var docBusinessValue : Int?
    var doctorDobDow : Int?
    var expenceNeed : Int?
    var expenceMdNeed : Int?
    var expenseNeed : Int?
    var editHoliday : Int?
    var editWeeklyOff : Int?
    var entryformMgr : Int?
    var entryFormNeed : Int?
    var expense_Need : Int?
    var faq : Int?
    var geoTagNeed : Int?
    var geoTagNeedChe : Int?
    var geoTagNeedStock :Int?
    var geoTagNeedUnList : Int?
    var geoCheck :Int?
    var geoNeed : Int?
    var geoTagNeedCip : Int?
    var gstOption : Int?
    var geoTagImg : Int?
    var heNeed : Int?
    var hfNeed : Int?
    var hiNeed : Int?
    var hpNeed : Int?
    var hqName : String?
    var hqNeed :Int?
    var hosPobMdNeed : Int?
    var hosPobNeed :Int?
    var hospEventNeed : Int?
    var hospCaption : String?
    var hospNeed : Int?
    var inputValQty : Int?
    var inputValidation : Int?
    var leaveStatus : Int?
    var leaveEntitlementNeed : Int?
    var locationTrack : Int?
    var iosApp : Int?
    var iosDetailing : Int?
    var mclDet : Int?
    var mgrHlfDy : Int?
    var mrHlfDy : Int?
    var msdEntry :Int?
    var mailNeed : Int?
    var miscExpenseNeed : Int?
    var missedDateMdNeed : Int?
    var multiClusterNeed : Int?
    var multipleDocNeed : Int?
    var mydayplanNeed : Int?
    var myPlnRmrksMand : Int?
    var neNeed : Int?
    var nfNeed :Int?
    var niNeed : Int?
    var nlCap : String?
    var nlRxQCap : String?
    var nlSampleQCap : String?
    var npNeed : Int?
    var nqNeed : Int?
    var nextVst : Int?
    var nextVstMdNeed : Int?
    var noOfTpView :Int?
    var orderCaption : String?
    var orderManagement :Int?
    var otherNeed : Int?
    var primaryOrder : Int?
    var primaryOrderCap : String?
    var prodStkNeed : Int?
    var productRateEditable : Int?
    var pwdSetup : Int?
    var pastLeavePost : Int?
    var pobMinValue : Int?
    var productFeedBack : Int?
    var primarySecNeed : Int?
    var proDetNeed : Int?
    var prodDetNeed : Int?
    var productRemarkNeed : Int?
    var productRemarkMdNeed : Int?
    var productPobNeed : Int?
    var productPobNeedMsg : String?
    var quesNeed : Int?
    var quizHeading : String?
    var quizNeed : Int?
    var quizMandNeed : Int?
    var quoteText : String?
    var rcpaQtyNeed : Int?
    var rcpaUnitNeed : Int?
    var rcpaMdNeed :Int?
    var chmRcpaMd : Int?
    var rcpaMgrMdNeed : Int?
    var rcpaNeed :Int?
    var rcpaCompetitorExtra : Int?
    var remainderCallCap : String?
    var remainderGeo : Int?
    var remainderProductMd : Int?
    var rmdrNeed : Int?
    var rcpaextra : Int?
    var refDoc : Int?
    var seNeed : Int?
    var sfNeed : Int?
    var sfStat : String?
  //  var sfTpDate : Double?
    var sfCode : String?
    var sfName :String?
    var sfPassword : String?
    var sfUserName : String?
    var sfEmail : String?
    var sfMobile : String?
    var sfEmpId : String?
    var sfType : Int?
    var stp : Int?
    var siNeed : Int?
    var spNeed : Int?
    var sqNeed : Int?
    var sampleValQty : Int?
    var sampleValidation : Int?
    var secondaryOrder : Int?
    var secondaryOrderCaption : String?
    var secondaryOrderDiscount : Int?
    var sepRcpaNeed :Int?
    
    var sequentailDcr : Int?
    var srtNeed : Int?
    var stateCode : Int?
    var stkCap :String?
    var stkEventMdNeed : Int?
    var stkNeed :Int?
    var stkQCap : String?
    var stkInputCaption : String?
    var stkPobMdNeed : Int?
    var stkPobNeed : Int?
    var stkProductCaption : String?
    var stkClusterBased : Int?
    var stkJointWrkMdNeed : Int?
    var stkJointWrkNeed :Int?
    var surveyNeed : Int?
    var success : Int?
    var subDivisionCode : String?
    var tBase :Int?
    var tpdcrDeviation : Int?
    var tpdcrDeviationApprStatus : Int?
    var tpdcrMgrAppr : Int?
    var tpMdNeed : Int?
    var tpBasedDcr : Int?
    var targetReportNeed : Int?
    var targetReportMdNeed : Int?
    var taxNameCaption :String?
    var tempNeed : Int?
    var terrBasedTag :Int?
    var terrotoryVisitNeed : Int?
    var tpEndDate : Int?
    var tpstartDate : Int?
    var tpNeed : Int?
    var tpnew : Int?
    var trackingTime : String?
    var travelDistanceNeed : Int?
    var unlNeed : Int?
    var ulDocClusterBased : Int?
    var ulDocEventMd : Int?
    var ulInputCaption : String?
    var ulPobMdNeed :Int?
    var ulPobNeed : Int?
    var ulProductCaption :String?
    var ulJointWrlMdNeed : Int?
    var ulJointWrlNeed : Int?
    var usrDfdUserName : String?
    var visitNeed : Int?
    var workAreaName : String?
    var therapticNd : String?
    
    init() {
        successMessage = ""
        isSuccess = false
        activityNeed = 0
        androidApp = 0
        androidDetailing = 0
        apprMandatoryNeed = 0
        approvalNeed = 0
        attendance = 0
        appDeviceId = ""
        callFeedEnterable = 0
        callReport = ""
        callReportFromDate = ""
        callReportToDate = ""
        chmAdQty = 0
        chmSampleQtyNeed = 0
        cipNeed = 0
        circular = 0
        cntRemarks = 0
        currentDay = 0
        ceNeed = 0
        cfNeed = 0
        cheBase = 0
        ciNeed = 0
        cipPobMdNeed = 0
        cipPobNeed = 0
        cipCaption = ""
        cipENeed = 0
        cipFNeed = 0
        cipINeed = 0
        cipPNeed = 0
        cipQNeed = 0
        cipJointWrkNeed = 0
        cpNeed = 0
        cqNeed = 0
        campNeed = 0
        catNeed = 0
        chmCap = ""
        chmEventMdNeed = 0
        chmNeed = 0
        chmQcap = ""
        chmRcpaCompetitorNeed = 0
        chmRxQtyNeed = 0
        chmSampleCap = ""
        chmInputCaption = ""
        chmPobMandatoryNeed = 0
        chmPobNeed = 0
        chmProductCaption = ""
        chmRcpaNeed = 0
        chmClusterBased = 0
        chmJointWrkMdNeed = 0
        chmJointWrkNeed = 0
        cipEventMdNeed = 0
        cipSrtNd = 0
        clusterCap = ""
        cmpgnNeed = 0
        currentdayTpPlanned = 0
        custSrtNeed = 0
        deNeed = 0
        dfNeed = 0
        diNeed = 0
        dpNeed = 0
        dqNeed = 0
        dsName = ""
        dcrLockDays = 0
        dcrFirstSelfieNeed = 0
        desig = ""
        detailingChem = 0
        detailingstk = 0
        detailingUdr = 0
        detailingType = 0
        deviceIdNeed = 0
        deviceRegId = ""
        disRad = ""
        divisionCode = ""
        divisionName = ""
        dlyCtrl = 0
        docInputCaption = ""
        docPobMandatoryNeed = 0
        docPobNeed = 0
        unListedDocPobNeed = 0
        docProductCaption = ""
        docClusterBased = 0
        docJointWrkMdNeed = 0
        docAdditionalCallNeed = 0
        docJointWrkNeed = 0
        docCap = ""
        docEventMdNeed = 0
        docFeedMdNeed = 0
        docInputMdNeed = 0
        docNeed = 0
        docProductMdNeed = 0
        docRcpaCompetitorNeed = 0
        docRcpaQMdNeed = 0
        docRxNeed = 0
        docRxQCap = ""
        docRxQMd = 0
        docSampleNeed = 0
        docSampleQCap = ""
        docSampleQMdNeed = 0
        dashboard = 0
        dayplanTpBased = 0
        days = 0
        dcrDocBusinessProduct = 0
        desigCode = ""
        docBusinessProduct = 0
        docBusinessValue = 0
        doctorDobDow = 0
        expenceNeed = 0
        expenceMdNeed = 0
        expenseNeed = 0
        editHoliday = 0
        editWeeklyOff = 0
        entryformMgr = 0
        entryFormNeed = 0
        expense_Need = 0
        faq = 0
        geoTagNeed = 0
        geoTagNeedChe = 0
        geoTagNeedStock = 0
        geoTagNeedUnList = 0
        geoCheck = 0
        geoNeed = 0
        geoTagNeedCip = 0
        gstOption = 0
        geoTagImg = 0
        heNeed = 0
        hfNeed = 0
        hiNeed = 0
        hpNeed = 0
        hqName = ""
        hqNeed = 0
        hosPobMdNeed = 0
        hosPobNeed = 0
        hospEventNeed = 0
        hospCaption = ""
        hospNeed = 0
        inputValQty = 0
        inputValidation = 0
        leaveStatus = 0
        leaveEntitlementNeed = 0
        locationTrack = 0
        iosApp = 0
        iosDetailing = 0
        mclDet = 0
        mgrHlfDy = 0
        mrHlfDy = 0
        msdEntry = 0
        mailNeed = 0
        miscExpenseNeed = 0
        missedDateMdNeed = 0
        multiClusterNeed = 0
        multipleDocNeed = 0
        mydayplanNeed = 0
        myPlnRmrksMand = 0
        neNeed = 0
        nfNeed = 0
        niNeed = 0
        nlCap = ""
        nlRxQCap = ""
        nlSampleQCap = ""
        npNeed = 0
        nqNeed = 0
        nextVst = 0
        nextVstMdNeed = 0
        noOfTpView = 0
        orderCaption = ""
        orderManagement = 0
        otherNeed = 0
        primaryOrder = 0
        primaryOrderCap = ""
        prodStkNeed = 0
        productRateEditable = 0
        pwdSetup = 0
        pastLeavePost = 0
        pobMinValue = 0
        productFeedBack = 0
        primarySecNeed = 0
        proDetNeed = 0
        prodDetNeed = 0
        productRemarkNeed = 0
        productRemarkMdNeed = 0
        productPobNeed = 0
        productPobNeedMsg = ""
        quesNeed = 0
        quizHeading = ""
        quizNeed = 0
        quizMandNeed = 0
        quoteText = ""
        rcpaQtyNeed = 0
        rcpaUnitNeed = 0
        rcpaMdNeed = 0
        chmRcpaMd = 0
        rcpaMgrMdNeed = 0
        rcpaNeed = 0
        rcpaCompetitorExtra = 0
        remainderCallCap = ""
        remainderGeo = 0
        remainderProductMd = 0
        rmdrNeed = 0
        rcpaextra = 0
        refDoc = 0
        seNeed = 0
        sfNeed = 0
        sfStat = ""
        //sfTpDate = 0.0
        sfCode = ""
        sfName = ""
        sfPassword = ""
        sfUserName = ""
        sfEmail = ""
        sfMobile = ""
        sfEmpId = ""
        sfType = 0
        stp = 0
        siNeed = 0
        spNeed = 0
        sqNeed = 0
        sampleValQty = 0
        sampleValidation = 0
        secondaryOrder = 0
        secondaryOrderCaption = ""
        secondaryOrderDiscount = 0
        sepRcpaNeed = 0
        sequentailDcr = 0
        srtNeed = 0
        stateCode = 0
        stkCap = ""
        stkEventMdNeed = 0
        stkNeed = 0
        stkQCap = ""
        stkInputCaption = ""
        stkPobMdNeed = 0
        stkPobNeed = 0
        stkProductCaption = ""
        stkClusterBased = 0
        stkJointWrkMdNeed = 0
        stkJointWrkNeed = 0
        surveyNeed = 0
        success = 0
        subDivisionCode = ""
        tBase = 0
        tpdcrDeviation = 0
        tpdcrDeviationApprStatus = 0
        tpdcrMgrAppr = 0
        tpMdNeed = 0
        tpBasedDcr = 0
        targetReportNeed = 0
        targetReportMdNeed = 0
        taxNameCaption = ""
        tempNeed = 0
        terrBasedTag = 0
        terrotoryVisitNeed = 0
        tpEndDate = 0
        tpstartDate = 0
        tpNeed = 0
        tpnew = 0
        trackingTime = ""
        travelDistanceNeed = 0
        unlNeed = 0
        ulDocClusterBased = 0
        ulDocEventMd = 0
        ulInputCaption = ""
        ulPobMdNeed = 0
        ulPobNeed = 0
        ulProductCaption = ""
        ulJointWrlMdNeed = 0
        ulJointWrlNeed = 0
        usrDfdUserName = ""
        visitNeed = 0
        workAreaName = ""
        therapticNd = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSuccess = container.safeDecodeValue(forKey: .isSuccess)
        self.successMessage =  container.safeDecodeValue(forKey: .successMessage)
        self.activityNeed = container.safeDecodeValue(forKey: .activityNeed)
        self.androidApp = container.safeDecodeValue(forKey: .androidApp)
        self.androidDetailing = container.safeDecodeValue(forKey: .androidDetailing)
        self.apprMandatoryNeed = container.safeDecodeValue(forKey: .apprMandatoryNeed)
        self.approvalNeed = container.safeDecodeValue(forKey: .approvalNeed)
        self.attendance = container.safeDecodeValue(forKey: .attendance)
        self.appDeviceId = container.safeDecodeValue(forKey: .appDeviceId)
        self.callFeedEnterable = container.safeDecodeValue(forKey: .callFeedEnterable)
        self.callReport = container.safeDecodeValue(forKey: .callReport)
        self.callReportFromDate = container.safeDecodeValue(forKey: .callReportFromDate)
        self.callReportToDate = container.safeDecodeValue(forKey: .callReportToDate)
        self.chmAdQty = container.safeDecodeValue(forKey: .chmAdQty)
        self.chmSampleQtyNeed = container.safeDecodeValue(forKey: .chmSampleQtyNeed)
        self.cipNeed = container.safeDecodeValue(forKey: .cipNeed)
        self.circular = container.safeDecodeValue(forKey: .circular)
        self.cntRemarks = container.safeDecodeValue(forKey: .cntRemarks)
        self.currentDay = container.safeDecodeValue(forKey: .currentDay)
        self.ceNeed = container.safeDecodeValue(forKey: .ceNeed)
        self.cfNeed = container.safeDecodeValue(forKey: .cfNeed)
        self.cheBase = container.safeDecodeValue(forKey: .cheBase)
        self.ciNeed = container.safeDecodeValue(forKey: .ciNeed)
        self.cipPobMdNeed = container.safeDecodeValue(forKey: .cipPobMdNeed)
        self.cipPobNeed = container.safeDecodeValue(forKey: .cipPobNeed)
        self.cipCaption = container.safeDecodeValue(forKey: .cipCaption)
        self.cipENeed = container.safeDecodeValue(forKey: .cipENeed)
        self.cipFNeed = container.safeDecodeValue(forKey: .cipFNeed)
        self.cipINeed = container.safeDecodeValue(forKey: .cipINeed)
        self.cipPNeed = container.safeDecodeValue(forKey: .cipPNeed)
        self.cipQNeed = container.safeDecodeValue(forKey: .cipQNeed)
        self.cipJointWrkNeed = container.safeDecodeValue(forKey: .cipJointWrkNeed)
        self.cpNeed = container.safeDecodeValue(forKey: .cpNeed)
        self.cqNeed = container.safeDecodeValue(forKey: .cqNeed)
        self.campNeed = container.safeDecodeValue(forKey: .campNeed)
        self.catNeed = container.safeDecodeValue(forKey: .catNeed)
        self.chmCap = container.safeDecodeValue(forKey: .chmCap)
        self.chmEventMdNeed = container.safeDecodeValue(forKey: .chmEventMdNeed)
        self.chmNeed = container.safeDecodeValue(forKey: .chmNeed)
        self.chmQcap = container.safeDecodeValue(forKey: .chmQcap)
        self.chmRcpaCompetitorNeed = container.safeDecodeValue(forKey: .chmRcpaCompetitorNeed)
        self.chmRxQtyNeed = container.safeDecodeValue(forKey: .chmRxQtyNeed)
        self.chmSampleCap = container.safeDecodeValue(forKey: .chmSampleCap)
        self.chmInputCaption = container.safeDecodeValue(forKey: .chmInputCaption)
        self.chmPobMandatoryNeed = container.safeDecodeValue(forKey: .chmPobMandatoryNeed)
        self.chmPobNeed = container.safeDecodeValue(forKey: .chmPobNeed)
        self.chmProductCaption = container.safeDecodeValue(forKey: .chmProductCaption)
        self.chmRcpaNeed = container.safeDecodeValue(forKey: .chmRcpaNeed)
        self.chmClusterBased = container.safeDecodeValue(forKey: .chmClusterBased)
        self.chmJointWrkMdNeed = container.safeDecodeValue(forKey: .chmJointWrkMdNeed)
        self.chmJointWrkNeed = container.safeDecodeValue(forKey: .chmJointWrkNeed)
        self.cipEventMdNeed = container.safeDecodeValue(forKey: .cipEventMdNeed)
        self.cipSrtNd = container.safeDecodeValue(forKey: .cipSrtNd)
        self.clusterCap = container.safeDecodeValue(forKey: .clusterCap)
        self.cmpgnNeed = container.safeDecodeValue(forKey: .cmpgnNeed)
        self.currentdayTpPlanned = container.safeDecodeValue(forKey: .currentdayTpPlanned)
        self.custSrtNeed = container.safeDecodeValue(forKey: .custSrtNeed)
        self.deNeed = container.safeDecodeValue(forKey: .deNeed)
        self.dfNeed = container.safeDecodeValue(forKey: .dfNeed)
        self.diNeed = container.safeDecodeValue(forKey: .diNeed)
        self.dpNeed = container.safeDecodeValue(forKey: .dpNeed)
        self.dqNeed = container.safeDecodeValue(forKey: .dqNeed)
        self.dsName = container.safeDecodeValue(forKey: .dsName)
        self.dcrLockDays = container.safeDecodeValue(forKey: .dcrLockDays)
        self.dcrFirstSelfieNeed = container.safeDecodeValue(forKey: .dcrFirstSelfieNeed)
        self.desig = container.safeDecodeValue(forKey: .desig)
        self.detailingChem = container.safeDecodeValue(forKey: .detailingChem)
        
        self.detailingstk = container.safeDecodeValue(forKey: .detailingstk)
        self.detailingUdr = container.safeDecodeValue(forKey: .detailingUdr)
        
        self.detailingType = container.safeDecodeValue(forKey: .detailingType)
        self.deviceIdNeed = container.safeDecodeValue(forKey: .deviceIdNeed)
        self.deviceRegId = container.safeDecodeValue(forKey: .deviceRegId)
        self.disRad = container.safeDecodeValue(forKey: .disRad)
        self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
        self.dlyCtrl = container.safeDecodeValue(forKey: .dlyCtrl)
        self.docInputCaption = container.safeDecodeValue(forKey: .docInputCaption)
        self.docPobMandatoryNeed = container.safeDecodeValue(forKey: .docPobMandatoryNeed)
        self.docPobNeed = container.safeDecodeValue(forKey: .docPobNeed)
        self.unListedDocPobNeed = container.safeDecodeValue(forKey: .unListedDocPobNeed)
        
        self.docProductCaption = container.safeDecodeValue(forKey: .docProductCaption)
        self.docClusterBased = container.safeDecodeValue(forKey: .docClusterBased)
        self.docJointWrkMdNeed = container.safeDecodeValue(forKey: .docJointWrkMdNeed)
        self.docAdditionalCallNeed = container.safeDecodeValue(forKey: .docAdditionalCallNeed)
        self.docJointWrkNeed = container.safeDecodeValue(forKey: .docJointWrkNeed)
        self.docCap = container.safeDecodeValue(forKey: .docCap)
        self.docEventMdNeed = container.safeDecodeValue(forKey: .docEventMdNeed)
        self.docFeedMdNeed = container.safeDecodeValue(forKey: .docFeedMdNeed)
        self.docInputMdNeed = container.safeDecodeValue(forKey: .docInputMdNeed)
        self.docNeed = container.safeDecodeValue(forKey: .docNeed)
        self.docProductMdNeed = container.safeDecodeValue(forKey: .docProductMdNeed)
        self.docRcpaCompetitorNeed = container.safeDecodeValue(forKey: .docRcpaCompetitorNeed)
        self.docRcpaQMdNeed = container.safeDecodeValue(forKey: .docRcpaQMdNeed)
        self.docRxNeed = container.safeDecodeValue(forKey: .docRxNeed)
        self.docRxQCap = container.safeDecodeValue(forKey: .docRxQCap)
        self.docRxQMd = container.safeDecodeValue(forKey: .docRxQMd)
        self.docSampleNeed = container.safeDecodeValue(forKey: .docSampleNeed)
        self.docSampleQCap = container.safeDecodeValue(forKey: .docSampleQCap)
        self.docSampleQMdNeed = container.safeDecodeValue(forKey: .docSampleQMdNeed)
        self.dashboard = container.safeDecodeValue(forKey: .dashboard)
        self.dayplanTpBased = container.safeDecodeValue(forKey: .dayplanTpBased)
        self.days = container.safeDecodeValue(forKey: .days)
        self.dcrDocBusinessProduct = container.safeDecodeValue(forKey: .dcrDocBusinessProduct)
        self.desigCode = container.safeDecodeValue(forKey: .desigCode)
        self.docBusinessProduct = container.safeDecodeValue(forKey: .docBusinessProduct)
        self.docBusinessValue = container.safeDecodeValue(forKey: .docBusinessValue)
        self.doctorDobDow = container.safeDecodeValue(forKey: .doctorDobDow)
        self.expenceNeed = container.safeDecodeValue(forKey: .expenceNeed)
        self.expenceMdNeed = container.safeDecodeValue(forKey: .expenceMdNeed)
        self.expenseNeed = container.safeDecodeValue(forKey: .expenseNeed)
        self.editHoliday = container.safeDecodeValue(forKey: .editHoliday)
        self.editWeeklyOff = container.safeDecodeValue(forKey: .editWeeklyOff)
        self.entryformMgr = container.safeDecodeValue(forKey: .entryformMgr)
        self.entryFormNeed = container.safeDecodeValue(forKey: .entryFormNeed)
        self.expense_Need = container.safeDecodeValue(forKey: .expense_Need)
        self.faq = container.safeDecodeValue(forKey: .faq)
        self.geoTagNeed = container.safeDecodeValue(forKey: .geoTagNeed)
        self.geoTagNeedChe = container.safeDecodeValue(forKey: .geoTagNeedChe)
        self.geoTagNeedStock = container.safeDecodeValue(forKey: .geoTagNeedStock)
        self.geoTagNeedUnList = container.safeDecodeValue(forKey: .geoTagNeedUnList)
        self.geoCheck = container.safeDecodeValue(forKey: .geoCheck)
        self.geoNeed = container.safeDecodeValue(forKey: .geoNeed)
        self.geoTagNeedCip = container.safeDecodeValue(forKey: .geoTagNeedCip)
        self.gstOption = container.safeDecodeValue(forKey: .gstOption)
        self.geoTagImg = container.safeDecodeValue(forKey: .geoTagImg)
        self.heNeed = container.safeDecodeValue(forKey: .heNeed)
        self.hfNeed = container.safeDecodeValue(forKey: .hfNeed)
        self.hiNeed = container.safeDecodeValue(forKey: .hiNeed)
        self.hpNeed = container.safeDecodeValue(forKey: .hpNeed)
        self.hqName = container.safeDecodeValue(forKey: .hqName)
        self.hqNeed = container.safeDecodeValue(forKey: .hqNeed)
        self.hosPobMdNeed = container.safeDecodeValue(forKey: .hosPobMdNeed)
        self.hosPobNeed = container.safeDecodeValue(forKey: .hosPobNeed)
        self.hospEventNeed = container.safeDecodeValue(forKey: .hospEventNeed)
        self.hospCaption = container.safeDecodeValue(forKey: .hospCaption)
        self.hospNeed = container.safeDecodeValue(forKey: .hospNeed)
        self.inputValQty = container.safeDecodeValue(forKey: .inputValQty)
        self.inputValidation = container.safeDecodeValue(forKey: .inputValidation)
        self.leaveStatus = container.safeDecodeValue(forKey: .leaveStatus)
        self.leaveEntitlementNeed = container.safeDecodeValue(forKey: .leaveEntitlementNeed)
        self.locationTrack = container.safeDecodeValue(forKey: .locationTrack)
        self.iosApp = container.safeDecodeValue(forKey: .iosApp)
        self.iosDetailing = container.safeDecodeValue(forKey: .iosDetailing)
        self.mclDet = container.safeDecodeValue(forKey: .mclDet)
        self.mgrHlfDy = container.safeDecodeValue(forKey: .mgrHlfDy)
        self.mrHlfDy = container.safeDecodeValue(forKey: .mrHlfDy)
        self.msdEntry = container.safeDecodeValue(forKey: .msdEntry)
        self.mailNeed = container.safeDecodeValue(forKey: .mailNeed)
        self.miscExpenseNeed = container.safeDecodeValue(forKey: .miscExpenseNeed)
        self.missedDateMdNeed = container.safeDecodeValue(forKey: .missedDateMdNeed)
        self.multiClusterNeed = container.safeDecodeValue(forKey: .multiClusterNeed)
        self.multipleDocNeed = container.safeDecodeValue(forKey: .multipleDocNeed)
        self.mydayplanNeed = container.safeDecodeValue(forKey: .mydayplanNeed)
        self.myPlnRmrksMand = container.safeDecodeValue(forKey: .myPlnRmrksMand)
        self.neNeed = container.safeDecodeValue(forKey: .neNeed)
        self.nfNeed = container.safeDecodeValue(forKey: .nfNeed)
        self.niNeed = container.safeDecodeValue(forKey: .niNeed)
        self.nlCap = container.safeDecodeValue(forKey: .nlCap)
        self.nlRxQCap = container.safeDecodeValue(forKey: .nlRxQCap)
        self.nlSampleQCap = container.safeDecodeValue(forKey: .nlSampleQCap)
        self.npNeed = container.safeDecodeValue(forKey: .npNeed)
        self.nqNeed = container.safeDecodeValue(forKey: .nqNeed)
        self.nextVst = container.safeDecodeValue(forKey: .nextVst)
        self.nextVstMdNeed = container.safeDecodeValue(forKey: .nextVstMdNeed)
        self.noOfTpView = container.safeDecodeValue(forKey: .noOfTpView)
        self.orderCaption = container.safeDecodeValue(forKey: .orderCaption)
        self.orderManagement = container.safeDecodeValue(forKey: .orderManagement)
        self.otherNeed = container.safeDecodeValue(forKey: .otherNeed)
        self.primaryOrder = container.safeDecodeValue(forKey: .primaryOrder)
        self.primaryOrderCap = container.safeDecodeValue(forKey: .primaryOrderCap)
        self.prodStkNeed = container.safeDecodeValue(forKey: .prodStkNeed)
        self.productRateEditable = container.safeDecodeValue(forKey: .productRateEditable)
        self.pwdSetup = container.safeDecodeValue(forKey: .pwdSetup)
        self.pastLeavePost = container.safeDecodeValue(forKey: .pastLeavePost)
        self.pobMinValue = container.safeDecodeValue(forKey: .pobMinValue)
        self.productFeedBack = container.safeDecodeValue(forKey: .productFeedBack)
        self.primarySecNeed = container.safeDecodeValue(forKey: .primarySecNeed)
        self.proDetNeed = container.safeDecodeValue(forKey: .proDetNeed)
        self.prodDetNeed = container.safeDecodeValue(forKey: .prodDetNeed)
        self.productRemarkNeed = container.safeDecodeValue(forKey: .productRemarkNeed)
        self.productRemarkMdNeed = container.safeDecodeValue(forKey: .productRemarkMdNeed)
        self.productPobNeed = container.safeDecodeValue(forKey: .productPobNeed)
        self.productPobNeedMsg = container.safeDecodeValue(forKey: .productPobNeedMsg)
        self.quesNeed = container.safeDecodeValue(forKey: .quesNeed)
        self.quizHeading = container.safeDecodeValue(forKey: .quizHeading)
        self.quizNeed = container.safeDecodeValue(forKey: .quizNeed)
        self.quizMandNeed = container.safeDecodeValue(forKey: .quizMandNeed)
        self.quoteText = container.safeDecodeValue(forKey: .quoteText)
        self.rcpaQtyNeed = container.safeDecodeValue(forKey: .rcpaQtyNeed)
        self.rcpaUnitNeed = container.safeDecodeValue(forKey: .rcpaUnitNeed)
        self.rcpaMdNeed = container.safeDecodeValue(forKey: .rcpaMdNeed)
        self.chmRcpaMd = container.safeDecodeValue(forKey: .chmRcpaMd)
        
        self.rcpaMgrMdNeed = container.safeDecodeValue(forKey: .rcpaMgrMdNeed)
        self.rcpaNeed = container.safeDecodeValue(forKey: .rcpaNeed)
        self.rcpaCompetitorExtra = container.safeDecodeValue(forKey: .rcpaCompetitorExtra)
        self.remainderCallCap = container.safeDecodeValue(forKey: .remainderCallCap)
        self.remainderGeo = container.safeDecodeValue(forKey: .remainderGeo)
        self.remainderProductMd = container.safeDecodeValue(forKey: .remainderProductMd)
        self.rmdrNeed = container.safeDecodeValue(forKey: .rmdrNeed)
        self.rcpaextra = container.safeDecodeValue(forKey: .rcpaextra)
        self.refDoc = container.safeDecodeValue(forKey: .refDoc)
        self.seNeed = container.safeDecodeValue(forKey: .seNeed)
        self.sfNeed = container.safeDecodeValue(forKey: .sfNeed)
        self.sfStat = container.safeDecodeValue(forKey: .sfStat)
      //  self.sfTpDate = container.safeDecodeValue(Double.self, forKey: .sfTpDate)
        self.sfCode = container.safeDecodeValue(forKey: .sfCode)
        self.sfName = container.safeDecodeValue(forKey: .sfName)
        self.sfPassword = container.safeDecodeValue(forKey: .sfPassword)
        self.sfUserName = container.safeDecodeValue(forKey: .sfUserName)
        self.sfEmail = container.safeDecodeValue(forKey: .sfEmail)
        self.sfMobile = container.safeDecodeValue(forKey: .sfMobile)
        self.sfEmpId = container.safeDecodeValue(forKey: .sfEmpId)
        self.sfType = container.safeDecodeValue(forKey: .sfType)
        self.stp = container.safeDecodeValue(forKey: .stp)
        self.siNeed = container.safeDecodeValue(forKey: .siNeed)
        self.spNeed = container.safeDecodeValue(forKey: .spNeed)
        self.sqNeed = container.safeDecodeValue(forKey: .sqNeed)
        self.sampleValQty = container.safeDecodeValue(forKey: .sampleValQty)
        self.sampleValidation = container.safeDecodeValue(forKey: .sampleValidation)
        self.secondaryOrder = container.safeDecodeValue(forKey: .secondaryOrder)
        self.secondaryOrderCaption = container.safeDecodeValue(forKey: .secondaryOrderCaption)
        self.secondaryOrderDiscount = container.safeDecodeValue(forKey: .secondaryOrderDiscount)
        self.sepRcpaNeed = container.safeDecodeValue(forKey: .sepRcpaNeed)
        self.sequentailDcr = container.safeDecodeValue(forKey: .sequentailDcr)
        self.srtNeed = container.safeDecodeValue(forKey: .srtNeed)
        self.stateCode = container.safeDecodeValue(forKey: .stateCode)
        self.stkCap = container.safeDecodeValue(forKey: .stkCap)
        self.stkEventMdNeed = container.safeDecodeValue(forKey: .stkEventMdNeed)
        self.stkNeed = container.safeDecodeValue(forKey: .stkNeed)
        self.stkQCap = container.safeDecodeValue(forKey: .stkQCap)
        self.stkInputCaption = container.safeDecodeValue(forKey: .stkInputCaption)
        self.stkPobMdNeed = container.safeDecodeValue(forKey: .stkPobMdNeed)
        self.stkPobNeed = container.safeDecodeValue(forKey: .stkPobNeed)
        self.stkProductCaption = container.safeDecodeValue(forKey: .stkProductCaption)
        self.stkClusterBased = container.safeDecodeValue(forKey: .stkClusterBased)
        self.stkJointWrkMdNeed = container.safeDecodeValue(forKey: .stkJointWrkMdNeed)
        self.stkJointWrkNeed = container.safeDecodeValue(forKey: .stkJointWrkNeed)
        self.surveyNeed = container.safeDecodeValue(forKey: .surveyNeed)
      //  self.success = container.safeDecodeValue(forKey: .success)
        self.divisionName = container.safeDecodeValue(forKey: .divisionName)
        self.subDivisionCode = container.safeDecodeValue(forKey: .subDivisionCode)
        self.tBase = container.safeDecodeValue(forKey: .tBase)
        self.tpdcrDeviation = container.safeDecodeValue(forKey: .tpdcrDeviation)
        self.tpdcrDeviationApprStatus = container.safeDecodeValue(forKey: .tpdcrDeviationApprStatus)
        self.tpdcrMgrAppr = container.safeDecodeValue(forKey: .tpdcrMgrAppr)
        self.tpMdNeed = container.safeDecodeValue(forKey: .tpMdNeed)
        self.tpBasedDcr = container.safeDecodeValue(forKey: .tpBasedDcr)
        self.targetReportNeed = container.safeDecodeValue(forKey: .targetReportNeed)
        self.targetReportMdNeed = container.safeDecodeValue(forKey: .targetReportMdNeed)
        self.taxNameCaption = container.safeDecodeValue(forKey: .taxNameCaption)
        self.tempNeed = container.safeDecodeValue(forKey: .tempNeed)
        self.terrBasedTag = container.safeDecodeValue(forKey: .terrBasedTag)
        self.terrotoryVisitNeed = container.safeDecodeValue(forKey: .terrotoryVisitNeed)
        self.tpEndDate = container.safeDecodeValue(forKey: .tpEndDate)
        self.tpstartDate = container.safeDecodeValue(forKey: .tpstartDate)
        self.tpNeed = container.safeDecodeValue(forKey: .tpNeed)
        self.tpnew = container.safeDecodeValue(forKey: .tpnew)
        self.trackingTime = container.safeDecodeValue(forKey: .trackingTime)
        self.travelDistanceNeed = container.safeDecodeValue(forKey: .travelDistanceNeed)
        self.unlNeed = container.safeDecodeValue(forKey: .unlNeed)
        self.ulDocClusterBased = container.safeDecodeValue(forKey: .ulDocClusterBased)
        self.ulDocEventMd = container.safeDecodeValue(forKey: .ulDocEventMd)
        self.ulInputCaption = container.safeDecodeValue(forKey: .ulInputCaption)
        self.ulPobMdNeed = container.safeDecodeValue(forKey: .ulPobMdNeed)
        self.ulPobNeed = container.safeDecodeValue(forKey: .ulPobNeed)
        self.ulProductCaption = container.safeDecodeValue(forKey: .ulProductCaption)
        self.ulJointWrlMdNeed = container.safeDecodeValue(forKey: .ulJointWrlMdNeed)
        self.ulJointWrlNeed = container.safeDecodeValue(forKey: .ulJointWrlNeed)
        self.usrDfdUserName = container.safeDecodeValue(forKey: .usrDfdUserName)
        self.visitNeed = container.safeDecodeValue(forKey: .visitNeed)
        self.workAreaName = container.safeDecodeValue(forKey: .workAreaName)
        self.therapticNd =  container.safeDecodeValue(forKey: .therapticNd)
        self.success = Int()
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDayCheckinEnabled, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isSequentialDCR, value:  self.sequentailDcr == 0 ? true : false)
        //
        
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isGeoFencingEnabled, value:  self.geoCheck == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isCustomerChekinNeeded, value:  self.custSrtNeed == 0 ? true : false)
        

        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistFencingEnabled, value:  self.geoTagNeedChe == 1 ? true : false)
        
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistFencingEnabled, value:  self.geoTagNeedStock == 1 ? true : false)
        
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnlistedDoctorFencingEnabled, value:  self.geoTagNeedUnList == 1 ? true : false)
        
        //MARK: - DCR setups
        ///Listed doctor setups
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorFencingEnabled, value:  self.geoTagNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductNedded, value:  self.dpNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductSampleNeeded, value:  self.docSampleNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductRXneeded, value:  self.docRxNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorInputNeeded, value:  self.diNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorAdditionalCallNeeded, value:  self.docAdditionalCallNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorRCPAneeded, value:  self.rcpaNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorJointWorkNeeded, value:  self.docJointWrkNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorPOBNeeded, value:  self.docPobNeed == 0 ? true : false)
        
       
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorFeedbackNeeded, value:  self.dfNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorEventCaptureNeeded, value:  self.deNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorDetailingNeeded, value: true)
        
        ///Listed doctor Mandatory
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductNeddedMandatory, value:  self.docProductMdNeed == 1 ? true : false)
        
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductSampleNeededMandatory, value:  self.docSampleQMdNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorProductRXneededMandatory, value:  self.docRxQMd == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorInputNeededMandatory, value:  self.docInputMdNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorRCPAneededMandatory, value:  self.rcpaMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorJointWorkNeededMandatory, value:  self.docJointWrkMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorPOBNeededMandatory, value:  self.docPobMandatoryNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorFeedbackNeededMandatory, value:  self.docFeedMdNeed == 1 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorRemarksNeededMandatory, value:  self.tempNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isDoctorEventCaptureNeededMandatory, value:  self.docEventMdNeed == 0 ? true : false)
        
        
        
        ///Chemist setups

        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistProductNedded, value:  self.cpNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistProductSampleNeeded, value:  self.chmSampleQtyNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistProductRXneeded, value:  self.chmRxQtyNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistInputNeeded, value:  self.ciNeed == 0 ? true : false)

        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistRCPAneeded, value:  self.rcpaNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistJointWorkNeeded, value:  self.chmJointWrkNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistPOBNeeded, value:  self.chmPobNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistFeedbackNeeded, value:  self.cfNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistEventCaptureNeeded, value:  self.ceNeed == 0 ? true : false)

        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistDetailingNeeded, value: self.detailingChem == 0 ? true : false)
        
        ///Chemist Mandatory

        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistRCPAneededMandatory, value:  self.chmRcpaMd == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistJointWorkNeededMandatory, value:  self.chmJointWrkMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistPOBNeededMandatory, value:  self.chmPobMandatoryNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isChemistEventCaptureNeededMandatory, value:  self.chmEventMdNeed == 0 ? true : false)
        
        
        ///Stockist setups

        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistProductNedded, value:  self.spNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistProductSampleNeeded, value: true)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistProductRXneeded, value:  self.stkPobNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistInputNeeded, value:  self.siNeed == 0 ? true : false)

        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistJointWorkNeeded, value:  self.stkJointWrkNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistPOBNeeded, value:  self.stkPobNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistFeedbackNeeded, value:  self.sfNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistEventCaptureNeeded, value:  self.seNeed == 0 ? true : false)
        LocalStorage.shared.setBool(LocalStorage.LocalValue.istockisDetailingNeeded, value: self.detailingstk == 0 ? true : false)
        
        ///Stockist Mandatory

        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistJointWorkNeededMandatory, value:  self.stkJointWrkMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistPOBNeededMandatory, value:  self.stkPobMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isStockistEventCaptureNeededMandatory, value:  self.stkEventMdNeed == 0 ? true : false)
        
        
        
        ///UnListed doctor setups

        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductNedded, value:  self.npNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductSampleNeeded, value:  true)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductRXneeded, value:  self.ulPobNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorInputNeeded, value:  self.niNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorAdditionalCallNeeded, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorRCPAneeded, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorJointWorkNeeded, value:  self.ulJointWrlNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorPOBNeeded, value:  self.unListedDocPobNeed  == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorFeedbackNeeded, value:  self.nfNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorEventCaptureNeeded, value:  self.neNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorDetailingNeeded, value: self.detailingUdr == 0 ? true : false)
        
        ///Listed doctor Mandatory
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductNeddedMandatory, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductSampleNeededMandatory, value:   false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorProductRXneededMandatory, value:   false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorInputNeededMandatory, value:   false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorRCPAneededMandatory, value:   false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorJointWorkNeededMandatory, value:  self.ulJointWrlMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorPOBNeededMandatory, value:  self.ulPobMdNeed == 0 ? true : false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorFeedbackNeededMandatory, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorRemarksNeededMandatory, value:  false)
        
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUnListedDoctorEventCaptureNeededMandatory, value:  self.ulDocEventMd == 0 ? true : false)
      
        
    }
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case successMessage = "msg"
        case activityNeed = "ActivityNd"
        case androidApp = "Android_App"
        case androidDetailing = "Android_Detailing"
        case apprMandatoryNeed = "Appr_Mandatory_Need"
        case approvalNeed = "Approveneed"
        case attendance = "Attendance"
        case appDeviceId = "app_device_id"
        case callFeedEnterable = "call_feed_enterable"
        case callReport = "call_report"
        case callReportFromDate = "call_report_from_date"
        case callReportToDate = "call_report_to_date"
        case chmAdQty = "chm_ad_qty"
        case chmSampleQtyNeed = "chmsamQty_need"
        case cipNeed = "cip_need"
        case circular = "circular"
        case cntRemarks = "cntRemarks"
        case currentDay = "currentDay"
        case ceNeed = "CENeed"
        case cfNeed = "CFNeed"
        case cheBase = "CHEBase"
        case ciNeed = "CINeed"
        case cipPobMdNeed = "CIPPOBMd"
        case cipPobNeed = "CIPPOBNd"
        case cipCaption = "CIP_Caption"
        case cipENeed = "CIP_ENeed"
        case cipFNeed = "CIP_FNeed"
        case cipINeed = "CIP_INeed"
        case cipPNeed = "CIP_PNeed"
        case cipQNeed = "CIP_QNeed"
        case cipJointWrkNeed = "CIP_jointwork_Need"
        case cpNeed = "CPNeed"
        case cqNeed = "CQNeed"
        case campNeed = "Campneed"
        case catNeed = "Catneed"
        case chmCap = "ChmCap"
        case chmEventMdNeed = "ChmEvent_Md"
        case chmNeed = "ChmNeed"
        case chmQcap = "ChmQCap"
        case chmRcpaCompetitorNeed = "ChmRCPA_competitor_Need"
        case chmRxQtyNeed = "ChmRxQty"
        case chmSampleCap = "ChmSmpCap"
        case chmInputCaption = "Chm_Input_caption"
        case chmPobMandatoryNeed = "Chm_Pob_Mandatory_Need"
        case chmPobNeed = "Chm_Pob_Need"
        case chmProductCaption = "Chm_Product_caption"
        case chmRcpaNeed = "Chm_RCPA_Need"
        case chmClusterBased = "Chm_cluster_based"
        case chmJointWrkMdNeed = "Chm_jointwork_Mandatory_Need"
        case chmJointWrkNeed = "Chm_jointwork_Need"
        case cipEventMdNeed = "CipEvent_Md"
        case cipSrtNd = "CipSrtNd"
        case clusterCap = "Cluster_Cap"
        case cmpgnNeed = "CmpgnNeed"
        case currentdayTpPlanned = "Currentday_TPplanned"
        case custSrtNeed = "CustSrtNd"
        case deNeed = "DENeed"
        case dfNeed = "DFNeed"
        case diNeed = "DINeed"
        case dpNeed = "DPNeed"
        case dqNeed = "DQNeed"
        case dsName = "DS_name"
        case dcrLockDays = "DcrLockDays"
        case dcrFirstSelfieNeed = "Dcr_firstselfie"
        case desig = "Desig"
        case detailingChem = "Detailing_chem"
        case detailingType = "Detailing_type"
        
        case detailingstk = "Detailing_stk"
        case detailingUdr = "Detailing_undr"
        case deviceIdNeed = "DeviceId_Need"
        case deviceRegId = "DeviceRegId"
        case disRad = "DisRad"
        case divisionCode = "Division_Code"
        case divisionName = "Division_name"
        case dlyCtrl = "DlyCtrl"
        case docInputCaption = "Doc_Input_caption"
        case docPobMandatoryNeed = "Doc_Pob_Mandatory_Need"
        case docPobNeed = "Doc_Pob_Need"
        case unListedDocPobNeed = "Pob_Unlstdr_Nd"
        
        case docProductCaption = "Doc_Product_caption"
        case docClusterBased = "Doc_cluster_based"
        case docJointWrkMdNeed = "Doc_jointwork_Mandatory_Need"
        case docAdditionalCallNeed = "Additional_Call"
        case docJointWrkNeed = "Doc_jointwork_Need"
        case docCap = "DrCap"
        case docEventMdNeed = "DrEvent_Md"
        case docFeedMdNeed = "DrFeedMd"
        case docInputMdNeed = "DrInpMd"
        case docNeed = "DrNeed"
        case docProductMdNeed = "DrPrdMd"
        case docRcpaCompetitorNeed = "DrRCPA_competitor_Need"
        case docRcpaQMdNeed = "DrRcpaQMd"
        case docRxNeed = "DrRxNd"
        case docRxQCap = "DrRxQCap"
        case docRxQMd = "DrRxQMd"
        case docSampleNeed = "DrSampNd"
        case docSampleQCap = "DrSmpQCap"
        case docSampleQMdNeed = "DrSmpQMd"
        case dashboard = "dashboard"
        case dayplanTpBased = "dayplan_tp_based"
        case days = "days"
        case dcrDocBusinessProduct = "dcr_doc_business_product"
        case desigCode = "desig_Code"
        case docBusinessProduct = "doc_business_product"
        case docBusinessValue = "doc_business_value"
        case doctorDobDow = "doctor_dobdow"
        case expenceNeed = "ExpenceNd"
        case expenceMdNeed = "ExpenceNd_mandatory"
        case expenseNeed = "Expenseneed"
        case editHoliday = "edit_holiday"
        case editWeeklyOff = "edit_weeklyoff"
        case entryformMgr = "entryFormMgr"
        case entryFormNeed = "entryFormNeed"
        case expense_Need = "expense_need"
        case faq = "faq"
        case geoTagNeed = "GEOTagNeed"
        case geoTagNeedChe = "GEOTagNeedche"
        case geoTagNeedStock = "GEOTagNeedstock"
        case geoTagNeedUnList = "GEOTagNeedunlst"
        case geoCheck = "GeoChk"
        case geoNeed = "GeoNeed"
        case geoTagNeedCip = "GeoTagNeedcip"
        case gstOption = "Gst_option"
        case geoTagImg = "geoTagImg"
        case heNeed = "HENeed"
        case hfNeed = "HFNeed"
        case hiNeed = "HINeed"
        case hpNeed = "HPNeed"
        case hqName = "HQName"
        case hqNeed = "HQNeed"
        case hosPobMdNeed = "HosPOBMd"
        case hosPobNeed = "HosPOBNd"
        case hospEventNeed = "HospEvent_Md"
        case hospCaption = "hosp_caption"
        case hospNeed = "hosp_need"
        case inputValQty = "Input_Val_Qty"
        case inputValidation = "input_validation"
        case leaveStatus = "LeaveStatus"
        case leaveEntitlementNeed = "Leave_entitlement_need"
        case locationTrack = "Location_track"
        case iosApp = "ios_app"
        case iosDetailing = "ios_Detailing"
        case mclDet = "MCLDet"
        case mgrHlfDy = "MGRHlfDy"
        case mrHlfDy = "MRHlfDy"
        case msdEntry = "MsdEntry"
        case mailNeed = "mailneed"
        case miscExpenseNeed = "misc_expense_need"
        case missedDateMdNeed = "missedDateMand"
        case multiClusterNeed = "multi_cluster"
        case multipleDocNeed = "multiple_doc_need"
        case mydayplanNeed = "mydayplan_need"
        case myPlnRmrksMand = "myplnRmrksMand"
        case neNeed = "NENeed"
        case nfNeed = "NFNeed"
        case niNeed = "NINeed"
        case nlCap = "NLCap"
        case nlRxQCap = "NLRxQCap"
        case nlSampleQCap = "NLSmpQCap"
        case npNeed = "NPNeed"
        case nqNeed = "NQNeed"
        case nextVst = "NextVst"
        case nextVstMdNeed = "NextVst_Mandatory_Need"
        case noOfTpView = "No_of_TP_View"
        case orderCaption = "Order_caption"
        case orderManagement = "Order_management"
        case otherNeed = "OtherNd"
        case primaryOrder = "Primary_order"
        case primaryOrderCap = "Primary_order_caption"
        case prodStkNeed = "Prod_Stk_Need"
        case productRateEditable = "Product_Rate_Editable"
        case pwdSetup = "Pwdsetup"
        case pastLeavePost = "past_leave_post"
        case pobMinValue = "pob_minvalue"
        case productFeedBack = "prdfdback"
        case primarySecNeed = "primarysec_need"
        case proDetNeed = "pro_det_need"
        case prodDetNeed = "prod_det_need"
        case productRemarkNeed = "prod_remark"
        case productRemarkMdNeed = "prod_remark_md"
        case productPobNeed = "product_pob_need"
        case productPobNeedMsg = "product_pob_need_msg"
        case quesNeed = "ques_need"
        case quizHeading = "quiz_heading"
        case quizNeed = "quiz_need"
        case quizMandNeed = "quiz_need_mandt"
        case quoteText = "quote_Text"
        case rcpaQtyNeed = "RCPAQty_Need"
        case rcpaUnitNeed = "RCPA_unit_nd"
        case rcpaMdNeed = "RcpaMd"
        case chmRcpaMd = "ChmRcpaMd"
        
        case rcpaMgrMdNeed = "RcpaMd_Mgr"
        case rcpaNeed = "RcpaNd"
        case rcpaCompetitorExtra = "Rcpa_Competitor_extra"
        case remainderCallCap = "Remainder_call_cap"
        case remainderGeo = "Remainder_geo"
        case remainderProductMd = "Remainder_prd_Md"
        case rmdrNeed = "RmdrNeed"
        case rcpaextra = "rcpaextra"
        case refDoc = "refDoc"
        case seNeed = "SENeed"
        case sfNeed = "SFNeed"
        case sfStat = "SFStat"
     //   case sfTpDate = "SFTPDate"
        case sfCode = "SF_Code"
        case sfName = "SF_Name"
        case sfPassword = "SF_Password"
        case sfUserName = "SF_User_Name"
        case sfEmail = "sfEmail"
        case sfMobile = "sfMobile"
        case sfEmpId = "sf_emp_id"
        case sfType = "sf_type"
        case stp = "stp"
        case siNeed = "SINeed"
        case spNeed = "SPNeed"
        case sqNeed = "SQNeed"
        case sampleValQty = "Sample_Val_Qty"
        case sampleValidation = "sample_validation"
        case secondaryOrder = "Secondary_order"
        case secondaryOrderCaption = "Secondary_order_caption"
        case secondaryOrderDiscount = "secondary_order_discount"
        case sepRcpaNeed = "Sep_RcpaNd"
        case sequentailDcr = "dcr_sequential"
        case srtNeed = "SrtNd"
        case stateCode = "State_Code"
        case stkCap = "StkCap"
        case stkEventMdNeed = "StkEvent_Md"
        case stkNeed = "StkNeed"
        case stkQCap = "StkQCap"
        case stkInputCaption = "Stk_Input_caption"
        case stkPobMdNeed = "Stk_Pob_Mandatory_Need"
        case stkPobNeed = "Stk_Pob_Need"
        case stkProductCaption = "Stk_Product_caption"
        case stkClusterBased = "Stk_cluster_based"
        case stkJointWrkMdNeed = "Stk_jointwork_Mandatory_Need"
        case stkJointWrkNeed = "Stk_jointwork_Need"
        case surveyNeed = "SurveyNd"
       // case success = "success"
        case subDivisionCode = "subdivision_code"
        case tBase = "TBase"
        case tpdcrDeviation = "TPDCR_Deviation"
        case tpdcrDeviationApprStatus = "TPDCR_Deviation_Appr_Status"
        case tpdcrMgrAppr = "TPDCR_MGRAppr"
        case tpMdNeed = "TP_Mandatory_Need"
        case tpBasedDcr = "TPbasedDCR"
        case targetReportNeed = "Target_report_Nd"
        case targetReportMdNeed = "Target_report_md"
        case taxNameCaption = "Taxname_caption"
        case tempNeed = "TempNd"
        case terrBasedTag = "Terr_based_Tag"
        case terrotoryVisitNeed = "Territory_VstNd"
        case tpEndDate = "Tp_End_Date"
        case tpstartDate = "Tp_Start_Date"
        case tpNeed = "tp_need"
        case tpnew = "tp_new"
        case trackingTime = "tracking_time"
        case travelDistanceNeed = "travelDistance_Need"
        case unlNeed = "UNLNeed"
        case ulDocClusterBased = "UlDoc_cluster_based"
        case ulDocEventMd = "UlDrEvent_Md"
        case ulInputCaption = "Ul_Input_caption"
        case ulPobMdNeed = "Ul_Pob_Mandatory_Need"
        case ulPobNeed = "Ul_Pob_Need"
        case ulProductCaption = "Ul_Product_caption"
        case ulJointWrlMdNeed = "Ul_jointwork_Mandatory_Need"
        case ulJointWrlNeed = "Ul_jointwork_Need"
        case usrDfdUserName = "UsrDfd_UserName"
        case visitNeed = "VstNd"
        case workAreaName = "wrk_area_Name"
        case therapticNd = "TherapticNd"
    }
    
}
