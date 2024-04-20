//
//  WorkType + Extension.swift
//  E-Detailing
//
//  Created by SANEFORCE on 26/06/23.
//

import Foundation
import CoreData
//anslNo: String?
//custCode: String?
//custName: String?
//custType: String?
//dcr_dt: String?
//dcr_flag: String?
//fw_Indicator: String
//index: Int16
//mnth: String?
//month_name: String?
//sf_Code: String?
//town_code: String?
//town_name: String?
//trans_SlNo: String?
//yr: String?


extension UnsyncedHomeData {
    func setValues(fromDictionary dictionary: [String:Any])    {
        
        
        if let codeValue = dictionary["CustCode"] as? String{
            custCode = codeValue
        }
        
        if let codeValue = dictionary["CustType"] as? String {
            custType = codeValue
        }
        if let eTabsValue = dictionary["FW_Indicator"] as? String{
            fw_Indicator = eTabsValue
        }
        if let fwFlgValue = dictionary["Dcr_dt"] as? String  {
            dcr_dt = fwFlgValue
        }
        if let sfCodeValue = dictionary["month_name"] as? String{
            month_name = sfCodeValue
        }
        if let tpDCRValue = dictionary["Mnth"] as? Int{
            mnth = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["Yr"] as? Int{
            yr = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["CustName"] as? String{
            custName = tpDCRValue
        }
        if let tpDCRValue = dictionary["town_code"] as? String{
            town_code = tpDCRValue
        }
        if let tpDCRValue = dictionary["town_name"] as? String{
            town_name = tpDCRValue
        }
        if let tpDCRValue = dictionary["Dcr_flag"] as? Int{
            dcr_flag = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["SF_Code"] as? String{
            sf_Code = tpDCRValue
        }
        if let tpDCRValue = dictionary["Trans_SlNo"] as? String{
            trans_SlNo = tpDCRValue
        }
        if let tpDCRValue = dictionary["AMSLNo"] as? String{
            anslNo = tpDCRValue
        }

        if let tpDCRValue = dictionary["isDataSentToAPI"] as? String {
            isDataSentToAPI = tpDCRValue
        }
        
        
        if let checkin = dictionary["checkinTime"] as? String {
            checkintime = checkin
        }
        
        if let checkout = dictionary["checkOutTime"] as? String {
            checkoutTime = checkout
        }
   
    }
}

extension HomeData {
    func setValues(fromDictionary dictionary: [String:Any])    {
        
        
        if let codeValue = dictionary["CustCode"] as? String{
            custCode = codeValue
        }
        
        if let codeValue = dictionary["CustType"] as? String {
            custType = codeValue
        }
        if let eTabsValue = dictionary["FW_Indicator"] as? String{
            fw_Indicator = eTabsValue
        }
        if let fwFlgValue = dictionary["Dcr_dt"] as? String  {
            dcr_dt = fwFlgValue
        }
        if let sfCodeValue = dictionary["month_name"] as? String{
            month_name = sfCodeValue
        }
        if let tpDCRValue = dictionary["Mnth"] as? Int{
            mnth = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["Yr"] as? Int{
            yr = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["CustName"] as? String{
            custName = tpDCRValue
        }
        if let tpDCRValue = dictionary["town_code"] as? String{
            town_code = tpDCRValue
        }
        if let tpDCRValue = dictionary["town_name"] as? String{
            town_name = tpDCRValue
        }
        if let tpDCRValue = dictionary["Dcr_flag"] as? Int{
            dcr_flag = String(tpDCRValue)
        }
        if let tpDCRValue = dictionary["SF_Code"] as? String{
            sf_Code = tpDCRValue
        }
        if let tpDCRValue = dictionary["Trans_SlNo"] as? String{
            trans_SlNo = tpDCRValue
        }
        if let tpDCRValue = dictionary["AMSLNo"] as? String{
            anslNo = tpDCRValue
        }

        if let tpDCRValue = dictionary["isDataSentToAPI"] as? String {
            isDataSentToAPI = tpDCRValue
        }
        
    }
}


extension Holidays {
    func setValues(fromDictionary dictionary: [String:Any])    {
        
        
        if let codeValue = dictionary["day_name"] as? String{
            day_name = codeValue
        }
        
        if let codeValue = dictionary["Flag"] as? String {
            flag = codeValue
        }
        if let eTabsValue = dictionary["Hday"] as? String{
            hday = eTabsValue
        }
        if let fwFlgValue = dictionary["Holiday_Date"] as? String  {
            holiday_Date = fwFlgValue
        }
        if let sfCodeValue = dictionary["Holiday_month"] as? String{
            holiday_month = sfCodeValue
        }
        if let tpDCRValue = dictionary["Holiday_Name"] as? String{
            holiday_Name = tpDCRValue
        }
        if let tpDCRValue = dictionary["month_name"] as? String{
            month_name = tpDCRValue
        }
        if let tpDCRValue = dictionary["WTcode"] as? String{
            wtcode = tpDCRValue
        }
        if let tpDCRValue = dictionary["WTname"] as? String{
            wtname = tpDCRValue
        }

    }
}

extension Weeklyoff {
    func setValues(fromDictionary dictionary: [String:Any])    {
        
        
        if let codeValue = dictionary["State_Code"] as? Int{
            state_Code = String(codeValue)
        }
        
        if let codeValue = dictionary["Division_Code"] as? Int{
            division_Code = String(codeValue)
        }
        if let eTabsValue = dictionary["Flag"] as? String{
            flag = eTabsValue
        }
        if let fwFlgValue = dictionary["Holiday_Mode"] as? Int  {
            holiday_Mode = String(fwFlgValue)
        }
        if let sfCodeValue = dictionary["WTcode"] as? String{
            wtcode = sfCodeValue
        }
        if let tpDCRValue = dictionary["WTname"] as? String{
            wtname = tpDCRValue
        }

    }
}

extension TableSetup {
    
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let codeValue = dictionary["AddsessionCount"] as? String{
            addsessionCount = codeValue
        }
        if let eTabsValue = dictionary["AddsessionNeed"] as? String{
            addsessionNeed = eTabsValue
        }
        if let fwFlgValue = dictionary["ChmNeed"] as? String{
            chmNeed = fwFlgValue
        }
        if let nameValue = dictionary["Cip_Need"] as? String{
            cip_Need = nameValue
        }
        if let sfCodeValue = dictionary["ClusterNeed"] as? String{
            clusterNeed = sfCodeValue
        }
        if let tpDCRValue = dictionary["clustertype"] as? String{
            clustertype = tpDCRValue
        }
        if let codeValue = dictionary["div"] as? String{
            div = codeValue
        }
        if let terrslFlgValue = dictionary["FW_meetup_mandatory"] as? String{
            fw_meetup_mandatory = terrslFlgValue
        }
        
        if let terrslFlgValue = dictionary["Holiday_Editable"] as? String{
            holiday_Editable = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["HospNeed"] as? String{
            hospNeed = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["JWNeed"] as? String{
            jwNeed = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["max_doc"] as? String{
            max_doc = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["SF_code"] as? String{
            sf_code = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["StkNeed"] as? String{
            stkNeed = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["tp_objective"] as? String{
            tp_objective = terrslFlgValue
        }
        if let terrslFlgValue = dictionary["UnDrNeed"] as? String{
            unDrNeed = terrslFlgValue
        }
        
        if let terrslFlgValue = dictionary["Weeklyoff_Editable"] as? String{
            weeklyoff_Editable = terrslFlgValue
        }
        
    }
    
}


extension WorkType {
    
    func setValues(fromDictionary dictionary: [String:Any])    {
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let eTabsValue = dictionary["ETabs"] as? String{
            eTabs = eTabsValue
        }
        if let fwFlgValue = dictionary["FWFlg"] as? String{
            fwFlg = fwFlgValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let sfCodeValue = dictionary["SF_Code"] as? String{
            sfCode = sfCodeValue
        }
        if let tpDCRValue = dictionary["TP_DCR"] as? String{
            tpDCR = tpDCRValue
        }
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let terrslFlgValue = dictionary["TerrSlFlg"] as? String{
            terrslFlg = terrslFlgValue
        }
    }
    
}


extension Territory {
    
    func setValues(fromDictionary dictionary: [String:Any],mapID : String)    {
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        if let latValue = dictionary["Lat"] as? String{
            lat = latValue
        }
        if let longValue = dictionary["Long"] as? String{
            long = longValue
        }
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        if let sfCodeValue = dictionary["SF_Code"] as? String{
            sfCode = sfCodeValue
        }
        mapId = mapID
    }
}
