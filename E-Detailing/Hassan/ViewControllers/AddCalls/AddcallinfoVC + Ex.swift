////
////  AddcallinfoVC + Ex.swift
////  SAN ZEN
////
////  Created by San eforce on 21/06/24.
////
//
//import Foundation
//extension AddCallinfoVC {
//    
//    func getRequiredData() {
//        do {
//            let sharedPref = SharedPref()
//            
//            let sfType = sharedPref.getSfType(self)
//            let sfCode = sharedPref.getSfCode(self)
//            let sfName = sharedPref.getSfName(self)
//            let divCode = sharedPref.getDivisionCode(self)
//            let subDivisionCode = sharedPref.getSubdivisionCode(self)
//            let designation = sharedPref.getDesig(self)
//            let stateCode = sharedPref.getStateCode(self)
//            let rcpaCompetitorAdd = sharedPref.getRcpaCompetitorAdd(self)
//            let eventCapMandatory = sharedPref.getCipEventMd(self)
//            
//            if let custDetails = CallActivityCustDetails.first {
//                switch custDetails.type {
//                case "1":
//                    capPrd = sharedPref.getDocProductCaption(self)
//                    capInp = sharedPref.getDocInputCaption(self)
//                    CapSamQty = sharedPref.getDrSmpQCap(self)
//                    CapRxQty = sharedPref.getDrRxQCap(self)
//                    CapPob = sharedPref.getDocPobCaption(self)
//                    
//                    ProductNeed = sharedPref.getDpNeed(self)
//                    InputNeed = sharedPref.getDiNeed(self)
//                    RCPANeed = sharedPref.getRcpaNd(self)
//                    PobNeed = sharedPref.getDocPobNeed(self)
//                    OverallFeedbackNeed = sharedPref.getDfNeed(self)
//                    EventCaptureNeed = sharedPref.getDeNeed(self)
//                    JwNeed = sharedPref.getDocJointworkNeed(self)
//                    PrdSamNeed = sharedPref.getDrSampNd(self)
//                    PrdRxNeed = sharedPref.getDrRxNd(self)
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    CusCheckInOutNeed = sharedPref.getCustSrtNd(self)
//                    AdditionalCallNeed = sharedPref.getAdditionalCallNeed(self)
//                    
//                    PrdMandatory = sharedPref.getDrPrdMd(self)
//                    InpMandatory = sharedPref.getDrInpMd(self)
//                    SamQtyMandatory = sharedPref.getDrSmpQMd(self)
//                    RxQtyMandatory = sharedPref.getDrRxQMd(self)
//                    RcpaMandatory = sharedPref.getRcpaMd(self)
//                    MgrRcpaMandatory = sharedPref.getRcpaMdMgr(self)
//                    EventCapMandatory = sharedPref.getDrEventMd(self)
//                    PobMandatory = sharedPref.getDocPobMandatoryNeed(self)
//                    FeedbackMandatory = sharedPref.getDrFeedMd(self)
//                    JwMandatory = sharedPref.getDocJointworkMandatoryNeed(self)
//                    RemarkMandatory = sharedPref.getTempNd(self)
//                    
//                case "2":
//                    capPrd = sharedPref.getChmProductCaption(self)
//                    capInp = sharedPref.getChmInputCaption(self)
//                    CapSamQty = sharedPref.getChmSmpCap(self)
//                    CapRxQty = sharedPref.getChmQCap(self)
//                    CapPob = sharedPref.getChmPobCaption(self)
//                    
//                    ProductNeed = sharedPref.getCpNeed(self)
//                    InputNeed = sharedPref.getCiNeed(self)
//                    RCPANeed = sharedPref.getChmRcpaNeed(self)
//                    PobNeed = sharedPref.getChmPobNeed(self)
//                    EventCaptureNeed = sharedPref.getCeNeed(self)
//                    OverallFeedbackNeed = sharedPref.getCfNeed(self)
//                    JwNeed = sharedPref.getChmJointworkNeed(self)
//                    PrdSamNeed = sharedPref.getChmsamqtyNeed(self)
//                    PrdRxNeed = sharedPref.getChmRxQty(self)
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    CusCheckInOutNeed = sharedPref.getChmSrtNd(self)
//                    
//                    PobMandatory = sharedPref.getChmPobMandatoryNeed(self)
//                    EventCapMandatory = sharedPref.getChmEventMd(self)
//                    JwMandatory = sharedPref.getChmJointworkMandatoryNeed(self)
//                    RcpaMandatory = sharedPref.getChmRcpaMd(self)
//                    MgrRcpaMandatory = sharedPref.getChmRcpaMdMgr(self)
//                    
//                case "3":
//                    capPrd = sharedPref.getStkProductCaption(self)
//                    capInp = sharedPref.getStkInputCaption(self)
//                    CapSamQty = "Samples"
//                    CapRxQty = sharedPref.getStkQCap(self)
//                    CapPob = sharedPref.getStkPobCaption(self)
//                    
//                    ProductNeed = sharedPref.getSpNeed(self)
//                    InputNeed = sharedPref.getSiNeed(self)
//                    OverallFeedbackNeed = sharedPref.getSfNeed(self)
//                    EventCaptureNeed = sharedPref.getSeNeed(self)
//                    JwNeed = sharedPref.getStkJointworkNeed(self)
//                    PrdSamNeed = "0"
//                    PrdRxNeed = sharedPref.getStkPobNeed(self)
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    CusCheckInOutNeed = "1"
//                    PobNeed = sharedPref.getStockistPobNeed(self)
//                    
//                    PobMandatory = sharedPref.getStkPobMandatoryNeed(self)
//                    EventCapMandatory = sharedPref.getStkEventMd(self)
//                    JwMandatory = sharedPref.getStkJointworkMandatoryNeed(self)
//                    
//                case "4":
//                    ProductNeed = sharedPref.getNpNeed(self)
//                    InputNeed = sharedPref.getNiNeed(self)
//                    capPrd = sharedPref.getUlProductCaption(self)
//                    capInp = sharedPref.getUlInputCaption(self)
//                    CapSamQty = sharedPref.getNlSmpQCap(self)
//                    CapRxQty = sharedPref.getNlRxQCap(self)
//                    CapPob = sharedPref.getUldocPobCaption(self)
//                    CusCheckInOutNeed = sharedPref.getUnlistSrtNd(self)
//                    
//                    OverallFeedbackNeed = sharedPref.getNfNeed(self)
//                    EventCaptureNeed = sharedPref.getNeNeed(self)
//                    JwNeed = sharedPref.getUlJointworkNeed(self)
//                    PrdSamNeed = "0"
//                    PrdRxNeed = sharedPref.getUlPobNeed(self)
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    CusCheckInOutNeed = "1"
//                    PobNeed = sharedPref.getUnlistedDoctorPobNeed(self)
//                    
//                    PobMandatory = sharedPref.getUlPobMandatoryNeed(self)
//                    EventCapMandatory = sharedPref.getUldrEventMd(self)
//                    JwMandatory = sharedPref.getUlJointworkMandatoryNeed(self)
//                    
//                case "5":
//                    CapPob = sharedPref.getCipPobCaption(self)
//                    
//                    PobNeed = sharedPref.getCipPNeed(self)
//                    OverallFeedbackNeed = sharedPref.getCipFNeed(self)
//                    EventCaptureNeed = sharedPref.getCipEventMd(self)
//                    JwNeed = sharedPref.getCipJointworkNeed(self)
//                    PrdSamNeed = "0"
//                    PrdRxNeed = "0"
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    CusCheckInOutNeed = sharedPref.getCipSrtNd(self)
//                    
//                    EventCapMandatory = sharedPref.getCipEventMd(self)
//                    PobMandatory = sharedPref.getCipPNeed(self)
//                    
//                case "6":
//                    CapPob = sharedPref.getHospPobCaption(self)
//                    CusCheckInOutNeed = "1"
//                    
//                    PobNeed = sharedPref.getHosPobNd(self)
//                    OverallFeedbackNeed = sharedPref.getHfNeed(self)
//                    EventCaptureNeed = sharedPref.getHospEventMd(self)
//                    JwNeed = "0"
//                    PrdSamNeed = "0"
//                    PrdRxNeed = "0"
//                    PrdRcpaQtyNeed = sharedPref.getRcpaQtyNeed(self)
//                    
//                    EventCapMandatory = sharedPref.getHospEventMd(self)
//                    
//                default:
//                    break
//                }
//                
//                SampleValidation = sharedPref.getSampleValidation(self)
//                InputValidation = sharedPref.getInputValidation(self)
//                GeoChk = sharedPref.getGeoChk(self)
//                HosNeed = sharedPref.getHospNeed(self)
//                
//                SamQtyRestriction = sharedPref.getSampleValQty(self) == "0" ? "1" : "0"
//                SamQtyRestrictValue = sharedPref.getSampleValQty(self)
//                
//                InpQtyRestriction = sharedPref.getInputValQty(self) == "0" ? "1" : "0"
//                InpQtyRestrictValue = sharedPref.getInputValQty(self)
//                
//                if let isFromActivity = isFromActivity, isFromActivity == "new" {
//                    TodayPlanSfCode = sfType == "1" ? sfCode : sharedPref.getHqCode(self)
//                    if TodayPlanSfCode.isEmpty {
//                        let jsonArray = masterDataDao.getMasterDataTableOrNew(Constants.SUBORDINATE).getMasterSyncDataJsonArray()
//                        if let jsonHQList = jsonArray.first as? [String: Any] {
//                            TodayPlanSfCode = jsonHQList["id"] as? String ?? ""
//                        }
//                    }
//                }
//                
//                if let isFromActivity = isFromActivity, isFromActivity == "edit_local" {
//                    if let json = try? JSONSerialization.jsonObject(with: CallActivityCustDetails.first?.jsonArray ?? Data(), options: []) as? [String: Any] {
//                        if sfType == "2" {
//                            TodayPlanSfCode = json["AppUserSF"] as? String ?? ""
//                        } else {
//                            TodayPlanSfCode = sfCode
//                        }
//                        
//                        if let jsonPrdArray = json["Products"] as? [[String: Any]] {
//                            for js in jsonPrdArray {
//                                if js["Group"] as? String == "1" {
//                                    isDetailingRequired = "true"
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                if let isFromActivity = isFromActivity, isFromActivity == "edit_online" {
//                    if let json = try? JSONSerialization.jsonObject(with: CallActivityCustDetails.first?.jsonArray ?? Data(), options: []) as? [String: Any] {
//                        if sfType == "2" {
//                            if let jsonSfCode = json["DCRDetail"] as? [[String: Any]], let js = jsonSfCode.first {
//                                TodayPlanSfCode = js["DataSF"] as? String ?? ""
//                            }
//                        } else {
//                            TodayPlanSfCode = sfCode
//                        }
//                        
//                        if let jsonPrdSlides = json["DigitalHead"] as? [[String: Any]], !jsonPrdSlides.isEmpty {
//                            for jsSlidesPrds in jsonPrdSlides {
//                                if jsSlidesPrds["GroupID"] as? String == "1" {
//                                    isDetailingRequired = "true"
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                if CusCheckInOutNeed == "0" {
//                    // DialogCheckOut()
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    public boolean CheckRequiredFunctions() {
//
//        switch (CallActivityCustDetails.get(0).getType()) {
//            case "1":
//                if(ProductNeed.equalsIgnoreCase("0")) {
//                    if(PrdMandatory.equalsIgnoreCase("1")) {
//                        if(CheckProductListAdapter.saveCallProductListArrayList.isEmpty()) {
//                            commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s", getString(R.string.enter_the).trim(), capPrd));
//                            moveToPage(capPrd);
//                            return false;
//                        }
//
//                        if(PrdSamNeed.equalsIgnoreCase("1") && SamQtyMandatory.equalsIgnoreCase("1")) {
//                            if(CheckProductListAdapter.saveCallProductListArrayList.isEmpty()) {
//                                commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s", getString(R.string.enter_the).trim(), capPrd));
//                                moveToPage(capPrd);
//                                return false;
//                            }else {
//                                for (int i = 0; i<CheckProductListAdapter.saveCallProductListArrayList.size(); i++) {
//                                    if(!CheckProductListAdapter.saveCallProductListArrayList.get(i).getCategory().equalsIgnoreCase("Sale") && (CheckProductListAdapter.saveCallProductListArrayList.get(i).getSample_qty().isEmpty())) {
//                                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s %s", getString(R.string.enter_the).trim(), CapSamQty, getString(R.string.value)));
//                                        moveToPage(capPrd);
//                                        return false;
//                                    }
//                                }
//                            }
//                        }
//
//                        if(PrdRxNeed.equalsIgnoreCase("1") && RxQtyMandatory.equalsIgnoreCase("1")) {
//                            if(CheckProductListAdapter.saveCallProductListArrayList.isEmpty()) {
//                                commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s", getString(R.string.enter_the).trim(), capPrd));
//                                moveToPage(capPrd);
//                                return false;
//                            }else {
//                                for (int i = 0; i<CheckProductListAdapter.saveCallProductListArrayList.size(); i++) {
//                                    if(!CheckProductListAdapter.saveCallProductListArrayList.get(i).getCategory().equalsIgnoreCase("Sample") && (CheckProductListAdapter.saveCallProductListArrayList.get(i).getRx_qty().isEmpty())) {
//                                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s %s", getString(R.string.enter_the).trim(), CapRxQty, getString(R.string.value)));
//                                        moveToPage(capPrd);
//                                        return false;
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//                if(InputNeed.equalsIgnoreCase("0")) {
//                    if(InpMandatory.equalsIgnoreCase("1")) {
//                        if(CheckInputListAdapter.saveCallInputListArrayList.isEmpty()) {
//                            commonUtilsMethods.showToastMessage(DCRCallActivity.this, String.format("%s %s", getString(R.string.enter_the).trim(), capInp));
//                            moveToPage(capInp);
//                            return false;
//                        }
//                    }
//                }
//                if(!validateInput()) return false;
//
//                if (SfType.equalsIgnoreCase("1")) {
//                    if (RCPANeed.equalsIgnoreCase("0") && RcpaMandatory.equalsIgnoreCase("0")) {
//                        if(!validateRCPA()) return false;
//                    }
//
//                } else {
//                    if (RCPANeed.equalsIgnoreCase("0") && MgrRcpaMandatory.equalsIgnoreCase("0")) {
//                        if(!validateRCPA()) return false;
//                    }
//                }
//
//                if (PobNeed.equalsIgnoreCase("0") && PobMandatory.equalsIgnoreCase("0")) {
//                    if (Objects.requireNonNull(jwOthersBinding.edPob.getText()).toString().isEmpty() || jwOthersBinding.edPob.getText().toString().equalsIgnoreCase("")) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.add_pob_values));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (FeedbackMandatory.equalsIgnoreCase("1")) {
//                    if (jwOthersBinding.tvFeedback.getText().toString().isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.add_feedback));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (RemarkMandatory.equalsIgnoreCase("0")) {
//                    if (Objects.requireNonNull(jwOthersBinding.edRemarks.getText()).toString().isEmpty() || jwOthersBinding.edRemarks.getText().toString().equalsIgnoreCase("")) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.add_remark));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (EventCaptureNeed.equalsIgnoreCase("0") && EventCapMandatory.equalsIgnoreCase("0")) {
//                    if(callCaptureImageLists.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.event_capture_needed));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (JwMandatory.equalsIgnoreCase("0")) {
//                    if (JWOthersFragment.callAddedJointList.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.jointwork_need));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                break;
//            case "2":
//                if (SfType.equalsIgnoreCase("1")) {
//                    if (RCPANeed.equalsIgnoreCase("0") && RcpaMandatory.equalsIgnoreCase("0")) {
//                        if(!validateRCPA()) return false;
//                    }
//                } else {
//                    if (MgrRcpaMandatory.equalsIgnoreCase("0")) {
//                        if(!validateRCPA()) return false;
//                    }
//                }
//
//                if (PobNeed.equalsIgnoreCase("0") && PobMandatory.equalsIgnoreCase("0")) {
//                    if (Objects.requireNonNull(jwOthersBinding.edPob.getText()).toString().isEmpty() || jwOthersBinding.edPob.getText().toString().equalsIgnoreCase("")) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.add_pob_values));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (EventCaptureNeed.equalsIgnoreCase("0") && EventCapMandatory.equalsIgnoreCase("0")) {
//                    if (callCaptureImageLists.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.event_capture_needed));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                if (JwMandatory.equalsIgnoreCase("0")) {
//                    if (JWOthersFragment.callAddedJointList.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.jointwork_need));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//
//                break;
//            case "3":
//            case "4":
//                if (PobNeed.equalsIgnoreCase("0") && PobMandatory.equalsIgnoreCase("0")) {
//                    if (Objects.requireNonNull(jwOthersBinding.edPob.getText()).toString().isEmpty() || jwOthersBinding.edPob.getText().toString().equalsIgnoreCase("")) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.add_pob_values));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//                if (EventCaptureNeed.equalsIgnoreCase("0") && EventCapMandatory.equalsIgnoreCase("0")) {
//                    if (callCaptureImageLists.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.event_capture_needed));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//                if (JwMandatory.equalsIgnoreCase("0")) {
//                    if (JWOthersFragment.callAddedJointList.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.jointwork_need));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//                break;
//            case "5":
//                if (EventCaptureNeed.equalsIgnoreCase("0") && EventCapMandatory.equalsIgnoreCase("0")) {
//                    if (callCaptureImageLists.isEmpty()) {
//                        commonUtilsMethods.showToastMessage(DCRCallActivity.this, getString(R.string.event_capture_needed));
//                        moveToPage("JFW/Others");
//                        return false;
//                    }
//                }
//                break;
//        }
//        return true;
//    }
//}
