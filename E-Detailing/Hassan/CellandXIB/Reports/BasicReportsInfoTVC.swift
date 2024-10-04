//
//  BasicReportsInfoTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/12/23.
//

import UIKit


extension BasicReportsInfoTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WorkPlansInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkPlansInfoCVC", for: indexPath) as! WorkPlansInfoCVC
        
    
        
        
        let model  = self.sessionImages?[indexPath.item]
        cell.plansIV.image = model?.Image
        cell.countsLbl.text = "\(model!.count)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 7, height: 75)
        //Int(collectionView.width) / (sessionImages?.count ?? 0)
    }
    
    
}

func isTohideCheckin(_ model: ReportsModel) -> Bool{
    if model.inaddress == "" || model.intime == "" {
        return true
    }
    return false
}

func isTohideCheckout(_ model: ReportsModel) -> Bool {
    if model.outaddress == "" || model.outtime == "" {
        return true
    }
    return false
}

func isTohideRemarks(_ model: ReportsModel) -> Bool {
    if model.remarks == "" {
        return true
    }
    return false
}
func isTohideplanCollection(count : Int) -> Bool {
    if count == 0 {
        return true
    }
    return false
}

class BasicReportsInfoTVC: UITableViewCell {
    
    func populateCell(_ model: ReportsModel) {
        let setup = AppDefaults.shared.getAppSetUp()
  
   
        var sessionImagesArr = [SessionImages]()
        
        if setup.docNeed == 0 {
             let ListedDoctorsessionImage =  SessionImages(Image: UIImage(named: "ListedDoctor") ?? UIImage(), count: model.drs)
             sessionImagesArr.append(ListedDoctorsessionImage)
         }
        
        if setup.chmNeed == 0 {
            let ChemistsessionImage =  SessionImages(Image: UIImage(named: "Chemist") ?? UIImage(), count: model.chm)
            sessionImagesArr.append(ChemistsessionImage)
        }
        
     if setup.stkNeed == 0 {
             let StockistsessionImage =  SessionImages(Image: UIImage(named: "Stockist") ?? UIImage(), count: model.stk)
             sessionImagesArr.append(StockistsessionImage)
         }
        
//        if setup.hospNeed == 0 {
//            let HospitalsessionImage =  SessionImages(Image: UIImage(named: "hospital") ?? UIImage(), count: model.hos)
//            sessionImagesArr.append(HospitalsessionImage)
//        }
//
//        
//        if setup.cipNeed == 0 {
//            let cipsessionImage =  SessionImages(Image: UIImage(named: "cip") ?? UIImage(), count: model.cip)
//            sessionImagesArr.append(cipsessionImage)
//        }
        
        if setup.unlNeed == 0 {
            let UnlistedDocsessionImage =  SessionImages(Image: UIImage(named: "Doctor") ?? UIImage(), count: model.udr)
            sessionImagesArr.append(UnlistedDocsessionImage)
        }
    
        self.sessionImages = sessionImagesArr
        
        userNameLbl.text = model.sfName
        if model.additionalWorktype.isEmpty {
            WTdescLbl.text = model.wtype
        } else {
            WTdescLbl.text = "\(model.wtype), \(model.additionalWorktype)"
        }
        
        remarksDescLbl.text =  model.remarks == "" ? "No remarks available" :  model.remarks
        checkINinfoLbl.text =  model.intime
        checkOUTinfoLbl.text = model.outtime
        checkINaddrLbl.text =  model.inaddress
        checkOUTaddrLbl.text = model.outaddress
        dateInfoLbl.text =     model.rptdate
        
        let isTohideCheckin = isTohideCheckin(model)
        let isTohideCheckout = isTohideCheckout(model)
        var tempstackHeight = stackHeight
        if isTohideCheckin && isTohideCheckout  {
            inAndoutInfoView.isHidden = true
            inAndoutHeightConst.constant = 0
            tempstackHeight = tempstackHeight - 70
            holderStackHeightConst.constant = tempstackHeight
        } else {
            inAndoutInfoView.isHidden = false
            tempstackHeight = tempstackHeight + 70
            inAndoutHeightConst.constant = 80
        }
        
        checkINtapView.isHidden  = isTohideCheckin
        checkOUTtapView.isHidden = isTohideCheckout
       // remarksAndPlansView
        let isTohideRemarks = isTohideRemarks(model)
        let isTohideplanCollection = isTohideplanCollection(count: self.sessionImages?.count ?? 0)
     
         
        if isTohideRemarks && isTohideplanCollection {
            remarksAndPlansView.isHidden = true
            remarksAndPlansHeightConst.constant = 0
            tempstackHeight = tempstackHeight -  75
           
            holderStackHeightConst.constant = tempstackHeight
        } else {
            remarksAndPlansView.isHidden = false
            remarksAndPlansHeightConst.constant = 75
            holderStackHeightConst.constant = tempstackHeight
        }
        
        switch model.confirmed {
        case 0:
            switch model.typ {
            case 0, 1:
                self.approvalType = .draft
                
            default:
                print("Yet to set approvalType")
            }
        
        case 1:
            
            switch model.typ {
            case 0:
                self.approvalType = .finished
            case 1:
                self.approvalType = .approved
            default:
                print("Yet to set approvalType")
            }
      
        case 2:
            switch model.typ {
            case 0:
                self.approvalType = .rejected
//            case 1:
//                self.approvalType = .rejected
            default:
                print("Yet to set approvalType")
            }
            
        case 3:
            switch model.typ {
            case 0:
                self.approvalType = .reEntry
            case 1:
                self.approvalType = .reEntry
            default:
                print("Yet to set approvalType")
            }
        default:
            print("Yet to set approvalType")
     
        }

        toLoadData()
    }
//    if (status==0 && confirmStatus==0) {
//    holder.status.setText("Draft");
//     holder.status.setBackgroundTintList(ColorStateList.valueOf(context.getColor(R.color.text_dark_15)));
//    } else if ((status==0 || status==1) && confirmStatus==1) {
//    holder.status.setText("Finished");
//     holder.status.setBackgroundTintList(ColorStateList.valueOf(context.getColor(R.color.bg_priority)));
//    } else if ((status==0 || status==1) && confirmStatus==2) {
//    holder.status.setText("Rejected");
//     holder.status.setBackgroundTintList(ColorStateList.valueOf(context.getColor(R.color.pink_15)));
//    } else if ((status==0 || status==1) && confirmStatus==3) {
//    holder.status.setText("ReEntry");
//     holder.status.setBackgroundTintList(ColorStateList.valueOf(context.getColor(R.color.bg_lite_blue)));
//    }
    
    
    enum ApprovalType {
        case draft
        case finished
        case rejected
        case reEntry
        case approved

        var color: UIColor {
            switch self {
            case .draft:
                return .appGreyColor
            case .finished:
                return .appBlue
            case .rejected:
                return .red
            case .reEntry:
                return .appLightPink
            case .approved:
                return .appGreen
            }
        }

        var text: String {
            switch self {
            case .draft:
                return "draft"
            case .finished:
                return "Finished"
            case .rejected:
                return "Rejected"
            case .reEntry:
                return "ReEntry"
            case .approved:
                return "Approved"
            }
        }
    }
    

    @IBOutlet var blurVXview: UIVisualEffectView!
    
    var sessionImages: [SessionImages]?
    
    @IBOutlet var userNameLbl: UILabel!
    
    @IBOutlet var WTtitleLbl: UILabel!
    
    @IBOutlet var WTdescLbl: UILabel!
    
    
    @IBOutlet var submittedDateLbl: UILabel!
    
    
    @IBOutlet var dateInfoLbl: UILabel!
    
    @IBOutlet var statusLbl: UILabel!
    
    
    @IBOutlet var statusInfoLbl: UILabel!
    
    @IBOutlet var statisInfoView: UIView!
    
    @IBOutlet var checkINLbl: UILabel!
    
    
    @IBOutlet var checkOUTlLbl: UILabel!
    
    
    @IBOutlet var checkINinfoLbl: UILabel!
    
    
    @IBOutlet var checkOUTinfoLbl: UILabel!
    
    
    @IBOutlet var checkINtapView: UIStackView!
    
    @IBOutlet var checkOUTtapView: UIStackView!
    
    
    @IBOutlet var checkINaddrLbl: UILabel!
    
    @IBOutlet var checkOUTaddrLbl: UILabel!
    
    @IBOutlet var checkINviewLbl: UILabel!
    
    @IBOutlet var checkOUTviewLbl: UILabel!
    
    @IBOutlet var remarksLbl: UILabel!
    
    
    @IBOutlet var remarksDescLbl: UILabel!
    
    @IBOutlet var overAllContentsHolderView: UIView!
    
    @IBOutlet var workPlansCollection: UICollectionView!
    
    
    
    //Views and height constraints

    
    @IBOutlet var inAndoutInfoView: UIView!
    
    @IBOutlet var inAndoutHeightConst: NSLayoutConstraint!
    
    @IBOutlet var holderStackHeightConst: NSLayoutConstraint!
    
    @IBOutlet var remarksAndPlansView: UIView!
    
    @IBOutlet var remarksAndPlansHeightConst: NSLayoutConstraint!
    
    @IBOutlet var nextActionVIew: UIView!
    @IBOutlet var seperatorView: UIView!
    let stackHeight: CGFloat = 255
    var approvalType: ApprovalType = .rejected {
         didSet {
             setArrovalView()
           //  approvalLabel.text = "Approval Status: \(approvalType.rawValue)"
         }
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
       // populateCell()
       
        

    }
    
    func toLoadData() {
        workPlansCollection.delegate = self
        workPlansCollection.dataSource = self
        workPlansCollection.reloadData()
        
    }
    
    func cellRegistration() {
        workPlansCollection.register(UINib(nibName: "WorkPlansInfoCVC", bundle: nil), forCellWithReuseIdentifier: "WorkPlansInfoCVC")
        //WorkPlansInfoCVC
    }
    
    func setupUI() {
        cellRegistration()
        blurVXview.backgroundColor = .systemGreen
       
      //  overAllContentsHolderView.elevate(2)
        overAllContentsHolderView.layer.cornerRadius = 5
        overAllContentsHolderView.backgroundColor = .appWhiteColor
        
        
        statisInfoView.layer.cornerRadius = 2
        statisInfoView.backgroundColor = .appSelectionColor
        
        seperatorView.backgroundColor = .appSelectionColor
        
        userNameLbl.textColor = .appLightPink
        userNameLbl.setFont(font: .bold(size: .BODY))
        
        let titLbls : [UILabel] = [WTtitleLbl, submittedDateLbl, statusLbl, checkINLbl, checkOUTlLbl, remarksLbl]
        
        titLbls.forEach { label in
            label.textColor = .appLightTextColor
            label.setFont(font: .medium(size: .BODY))
        }
        
        let descLbls : [UILabel] = [WTdescLbl, dateInfoLbl, statusInfoLbl, checkINinfoLbl, checkOUTinfoLbl, checkINaddrLbl, checkOUTaddrLbl, remarksDescLbl, checkINviewLbl, checkOUTviewLbl]
        
        descLbls.forEach { label in
            if label == statusInfoLbl {
                label.setFont(font: .medium(size: .BODY))
            } else {
                label.setFont(font: .bold(size: .BODY))
            }
            
            if label == checkINviewLbl ||  label == checkOUTviewLbl {
                label.textColor = .appLightPink
            } else {
                label.textColor = .appTextColor
            }
            
          
            
        }
        

    }

    func setArrovalView() {
        blurVXview.alpha = 0.1
        switch self.approvalType {
            
        case .draft:
          //  statisInfoView.backgroundColor = approvalType.color
            statusInfoLbl.text = approvalType.text
            statusInfoLbl.textColor = .appTextColor
            blurVXview.backgroundColor = approvalType.color
        case .finished:
          //  statisInfoView.backgroundColor = approvalType.color
            statusInfoLbl.text = approvalType.text
            statusInfoLbl.textColor = approvalType.color
            blurVXview.backgroundColor = approvalType.color
        case .rejected:
          //  statisInfoView.backgroundColor = approvalType.color
            statusInfoLbl.text = approvalType.text
            statusInfoLbl.textColor = approvalType.color
            blurVXview.backgroundColor = approvalType.color
        case .reEntry:
          //  statisInfoView.backgroundColor = approvalType.color
            statusInfoLbl.text = approvalType.text
            statusInfoLbl.textColor = approvalType.color
            blurVXview.backgroundColor = approvalType.color
        case .approved:
            statusInfoLbl.text = approvalType.text
            statusInfoLbl.textColor = approvalType.color
            blurVXview.backgroundColor = approvalType.color
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
