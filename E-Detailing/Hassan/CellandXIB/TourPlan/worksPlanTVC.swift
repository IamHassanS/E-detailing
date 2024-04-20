//
//  worksPlanTVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/11/23.
//

import UIKit

extension worksPlanTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WorkPlansInfoCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkPlansInfoCVC", for: indexPath) as! WorkPlansInfoCVC
       // cell.toPopulateCell(self.session?.sessionDetails[indexPath.item])
        let model  = self.sessionImages?[indexPath.item]
        cell.plansIV.image = model?.Image
        cell.countsLbl.text = "\(model!.count)"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 5, height: 75)
    }
    
    
}


struct SessionImages {
    let Image: UIImage
    let count: Int
}

class worksPlanTVC: UITableViewCell {

    @IBOutlet var overallContentsHolderView: UIView!
    
    @IBOutlet var dateLbl: UILabel!
    
    @IBOutlet var optionsIV: UIImageView!
    
    @IBOutlet var workTitLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var seperatorView: UIView!
    
    @IBOutlet var workPlansInfoCollection: UICollectionView!
    
    var detailsArr = [[String]]()
    var session : SessionDetailsArr?
    var sessionImages: [SessionImages]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.overallContentsHolderView.elevate(2)
        self.overallContentsHolderView.layer.cornerRadius = 5
        overallContentsHolderView.backgroundColor = .appGreyColor.withAlphaComponent(0.3)
        dateLbl.setFont(font: .bold(size: .SUBHEADER))
        workTitLbl.setFont(font: .medium(size: .BODY))
        nameLbl.setFont(font: .medium(size: .BODY))
        if let layout = self.workPlansInfoCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.collectionView?.isScrollEnabled = false
        }
        cellRegistration()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellRegistration() {
        workPlansInfoCollection.register(UINib(nibName: "WorkPlansInfoCVC", bundle: nil), forCellWithReuseIdentifier: "WorkPlansInfoCVC")
    }
    
    func toPopulateCell(_ session: SessionDetailsArr) {
        self.session = session
        var isForfieldWork = Bool()
        var isFieldWorkExist = [Bool]()
        var workTypestr = [String]()
        var jointCallstr = [String]()
        var headQuartersstr = [String]()
        var clusterstr  = [String]()
        var jointcallstr  = [String]()
        var doctorsstr  = [String]()
        var chemiststr  = [String]()
        var stockiststr = [String]()
        var unlistedDocstr = [String]()
        
        self.dateLbl.text = session.date
      
        sessionImages = [SessionImages]()
        session.sessionDetails?.forEach { session in
            if  session.WTName != "" {
                  workTypestr.append(session.WTName ?? "")
                
              }
            if session.isForFieldWork ?? false {
                isFieldWorkExist.append(true)
                  if  session.jwName != "" {
                      jointCallstr.append(session.jwName ?? "")
                    }
                  if  session.HQCodes != "" {
                      headQuartersstr.append(session.HQCodes ?? "")
                    }
                  if  session.clusterCode != "" {
                      clusterstr.append(session.clusterName ?? "")
                    }
                  if  session.jwCode != "" {
                      jointcallstr.append(session.jwCode ?? "")
                    }
                  if  session.drCode != "" {
                      doctorsstr.append(session.drCode ?? "")
                    }
                  if  session.chemCode != "" {
                      chemiststr.append(session.chemCode ?? "")
                    }
                  if session.stockistCode != "" {
                      stockiststr.append(session.stockistCode ?? "")
                  }
                  if session.unListedDrCode != "" {
                      unlistedDocstr.append(session.unListedDrCode ?? "")
                  } else {
                      
                  }
            } else {
                isFieldWorkExist.append(false)
            }

            isFieldWorkExist.forEach { workexist in
                if workexist {
                    isForfieldWork = workexist
                }
            }
        }
        if isForfieldWork {
            if headQuartersstr.count > 0 {
                var count = 0
                headQuartersstr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "HeadQuarter") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
//            if clusterstr.count > 0 {
//                var count = 0
//                clusterstr.forEach { str in
//                   let countstr = str.components(separatedBy: ",")
//                    count += countstr.count
//                }
//                let sessionImage =  SessionImages(Image: UIImage(named: "Cluster") ?? UIImage(), count: count)
//                sessionImages?.append(sessionImage)
//            }
            
            if jointcallstr.count > 0 {
                var count = 0
                jointcallstr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "JointWork") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
            
            if doctorsstr.count > 0 {
                var count = 0
                doctorsstr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "ListedDoctor") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
            
            if chemiststr.count > 0 {
                var count = 0
                chemiststr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "Chemist") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
            
             
            
            if stockiststr.count > 0 {
                var count = 0
                stockiststr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "Stockist") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
            
            if unlistedDocstr.count > 0 {
                var count = 0
                unlistedDocstr.forEach { str in
                   let countstr = str.components(separatedBy: ",")
                    count += countstr.count
                }
                let sessionImage =  SessionImages(Image: UIImage(named: "Doctor") ?? UIImage(), count: count)
                sessionImages?.append(sessionImage)
            }
            dump(detailsArr)
            self.workTitLbl.text = workTypestr.joined(separator: ", ")
            self.nameLbl.text = clusterstr.joined(separator: ", ")
            self.seperatorView.isHidden = false
            self.nameLbl.isHidden = false
            self.workPlansInfoCollection.isHidden = false
            self.toLOadData()
        } else {
            dump(detailsArr)
            self.workTitLbl.text = workTypestr.joined(separator: ", ")
          //  self.nameLbl.text = jointCallstr.joined(separator: ", ")
            seperatorView.isHidden = true
            self.nameLbl.isHidden = true
            self.workPlansInfoCollection.isHidden = true
           // self.toLOadData()
        }

        
//        [headQuartersstr, clusterstr, jointcallstr, doctorsstr, chemiststr].forEach { elements in
//            if elements.count > 0 {
//                self.detailsArr.append(elements)
//
//            }
//        }
      
    }
    
    func toLOadData() {
        workPlansInfoCollection.delegate = self
        workPlansInfoCollection.dataSource = self
        workPlansInfoCollection.reloadData()
    }
    
}
