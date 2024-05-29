//
//  NearMeVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/04/24.
//

import Foundation
import UIKit
import GoogleMaps
import CoreData

extension NearMeVC: MediaDownloaderDelegate {
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float) {
        
        print("Downloading")
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?) {
        Shared.instance.removeLoaderInWindow()
        print("Downloaded")
        Pipelines.shared.isDownloading = false
       
        guard let data = data else {
            self.toCreateToast("No tagged image found")
            return}
        
        viewImageAction(imageData: data)
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: any Error) {
        Shared.instance.removeLoaderInWindow()
    
        print("Error")
    }
    
    
}

extension NearMeVC: addedSubViewsDelegate {
    func didClose() {
       backgroundView.isHidden = true
        backgroundView.alpha = 0.3
        self.view.subviews.forEach { aAddedView in
            
            switch aAddedView {

            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.alpha = 0
                
            default:
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1
                print("Yet to implement")
                
                // aAddedView.alpha = 1
                
            }
            
        }
    }
    
    func didUpdate() {
        print("Yet to implement")
    }
    
    func didUpdateCustomerCheckin(dcrCall: CallViewModel) {
        print("Yet to implement")
    }
    
    func showAlert(desc: String) {
        print("Yet to implement")
    }
    
    func didUpdateFilters(filteredObjects: [NSManagedObject]) {
        print("Yet to implement")
    }
    
    
}

extension NearMeVC : PopOverVCDelegate {
    func didTapRow(_ index: Int, _ SelectedArrIndex: Int) {
        print("Yet to implement")
    }
    
    func logoutAction() {
        print("Yet to implement")
    }
    
    func changePasswordAction() {
        print("Show tagged Image")
       let prefixURL = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageDownloadURL)
        guard let selectedVisitViewModel = self.selectedVisitViewModel else {return}
        if selectedVisitViewModel.imageURL.isEmpty {
            
            self.toCreateToast("No tagged image found")
            return
        }
        
        let remoteURL = prefixURL + selectedVisitViewModel.imageURL
        Shared.instance.showLoaderInWindow()
        Pipelines.shared.downloadData(mediaURL: remoteURL, delegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            Shared.instance.removeLoaderInWindow()
            if Pipelines.shared.isDownloading ?? false {
                self.toCreateToast("Please try again later")
                Pipelines.shared.toStopDownload()
            }
        }
    }
}

extension NearMeVC: GMSMapViewDelegate {

    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let code = marker.snippet else { return false }
        
        
        let fetchedModel = self.visitListViewModel.fetchDataWithCode(code)
         
        guard let fetchedModel = fetchedModel else {return false }
         
         self.selectedVisitViewModel = VisitViewModel(taggedDetail: fetchedModel.taggedDetail)
        
        let position = marker.position
        // Create a transparent button with the same size as the marker icon
        let buttonSize: CGFloat = 48 // Adjust size if needed
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        button.center = mapView.projection.point(for: position)
        button.addTarget(self, action: #selector(markerButtonTapped(_:)), for: .touchUpInside)
        mapView.addSubview(button)
        markerButtonTapped(button)
        return true
    }
    
    
    @objc func markerButtonTapped(_ sender: UIView) {
        // Create and present the popover view controller
        let popoverWidth: CGFloat = self.view.width / 3.5
        let popoverHeight: CGFloat = self.view.height / 4
        let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: popoverWidth, height: popoverHeight), on: sender, pagetype: .customMarker)
        vc.delegate = self
        vc.visitViewModel = selectedVisitViewModel
        self.present(vc, animated: true)
    }

}

enum TaggingType : String {
    case doctor = "D"
    case chemist = "C"
    case stockist = "S"
    case unlistedDoctor = "U"
    
    
    var name : String {
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        
        switch self {
            
        case .doctor:
            return appsetup.docCap ?? ""
        case .chemist:
            return appsetup.chmCap ?? ""
        case .stockist:
            return appsetup.stkCap ?? ""
        case .unlistedDoctor:
            return appsetup.nlCap ?? ""
        }
    }
    
}

class NearMeVC : UIViewController {
    
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet var btnAddtag: ShadowButton!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var viewMapView: GMSMapView!
    
    @IBOutlet weak var viewTaggedList: UIView!
    @IBOutlet weak var viewSegmentControl: UIView!
    @IBOutlet weak var viewVisitDetails: UIView!
    @IBOutlet weak var viewTableView: UIView!
    
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    
    @IBOutlet weak var visitTableView: UITableView!
    
    @IBOutlet weak var widthTableView: NSLayoutConstraint!
    
    
    private var visitListViewModel = VisitListViewModel()
    
    var currentLocation: CLLocationCoordinate2D?
    
    var selectedVisitViewModel : VisitViewModel?
    
    var selectedIndex: Int?
    
    var markers: [GMSMarker] = []
    
    var checkinVIew: CustomerCheckinView?
    
    var tagType : TaggingType = .doctor {
        didSet {
            
            LocationManager.shared.getCurrentLocation{ (coordinate) in
                print("location == \(coordinate)")
                let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
                self.viewMapView.camera =  camera
                self.currentLocation = coordinate
                self.drawCircle()
                self.showAllTaggedList()
            }
            // self.showAllTaggedList()
        }
    }
    
    private var dcrSegmentControl : UISegmentedControl!
    
    // var taggingArray = ["Doctor" , "Chemist" , "Stockist" , "Unlisted Doctor" , "Cip" , "Hospital"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.isHidden = true
        self.updateTitle()
        self.tagType = .doctor
        
        
        self.viewTableView.isHidden = true
        self.widthTableView.constant = 0

        self.viewMapView.isMyLocationEnabled = true

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.headerCollectionView.collectionViewLayout = layout
        
        let location = LocationManager.shared.currentLocation
        print(location as Any)
        
         
        self.visitTableView.register(UINib(nibName: "TagViewCell", bundle: nil), forCellReuseIdentifier: "TagViewCell")
        
        
        [btnLeft,btnRight].forEach { button in
            button.layer.borderColor = AppColors.primaryColorWith_65per_alpha.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 10
        }
        titleLbl.setFont(font: .bold(size: .SUBHEADER))
        btnLeft.isHidden = true
         
        viewMapView.delegate = self
        btnAddtag.tintColor = .appLightPink
        
        backgroundView.addTap {
            self.didClose()
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let checkinVIewwidth = view.bounds.width / 3.5
        let checkinVIewheight = view.bounds.height / 2
        
        let checkinVIewcenterX = view.bounds.midX - (checkinVIewwidth / 2)
        let checkinVIewcenterY = view.bounds.midY - (checkinVIewheight / 2)

        checkinVIew?.frame = CGRect(x: checkinVIewcenterX, y: checkinVIewcenterY, width: checkinVIewwidth, height: checkinVIewheight)
        
    }
    
    
    func viewImageAction(imageData: Data) {
        
    
        backgroundView.isHidden = false
        backgroundView.alpha = 0.3
        //  backgroundView.toAddBlurtoVIew()
        self.view.subviews.forEach { aAddedView in
            switch aAddedView {
            case checkinVIew:
                aAddedView.removeFromSuperview()
                aAddedView.isUserInteractionEnabled = true
                aAddedView.alpha = 1

            case backgroundView:
                aAddedView.isUserInteractionEnabled = true
              
            default:
                print("Yet to implement")
          
                
                aAddedView.isUserInteractionEnabled = false
              
                
            }
            
        }
        
        checkinVIew = self.loadCustomView(nibname: XIBs.customerCheckinVIew) as? CustomerCheckinView
        checkinVIew?.delegate = self
        checkinVIew?.setupTaggeImage(fetchedImageData: imageData)
        self.view.addSubview(checkinVIew ?? CustomerCheckinView())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            print("location == \(coordinate)")
            let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            self.viewMapView.camera =  camera
            self.currentLocation = coordinate
            self.drawCircle()
            self.showAllTaggedList()
        }
        
    }
    
    
    deinit {
        print("NearMeVC deallocated")
    }
    
    @objc func tagView (_ sender : UITapGestureRecognizer) {
        
        print("Taggggg")
        print(viewMapView.selectedMarker?.title ?? "Good")
    }
    
    
    func updateTitle() {
        let appsetUp = AppDefaults.shared.getAppSetUp()
        
        self.visitListViewModel.addTitleViewModel(TagTitleViewModel(tagTitle: tagTitle(name: appsetUp.docCap ?? "", type: .doctor)))
        
        if appsetUp.docNeed == 0 {
           // self.visitListViewModel.addTitleViewModel(TagTitleViewModel(tagTitle: tagTitle(name: appsetUp.docCap ?? "", type: .doctor)))
        }
        
        if appsetUp.chmNeed == 0 {
            self.visitListViewModel.addTitleViewModel(TagTitleViewModel(tagTitle: tagTitle(name: appsetUp.chmCap ?? "", type: .chemist)))
        }
        if appsetUp.stkNeed == 0 {
            self.visitListViewModel.addTitleViewModel(TagTitleViewModel(tagTitle: tagTitle(name: appsetUp.stkCap ?? "", type: .stockist)))
        }
        if appsetUp.unlNeed == 0 {
            self.visitListViewModel.addTitleViewModel(TagTitleViewModel(tagTitle: tagTitle(name: appsetUp.nlCap ?? "", type: .unlistedDoctor)))
        }
        
        self.headerCollectionView.reloadData()
    }
    
    
    func drawCircle(){
        let appsetup = AppDefaults.shared.getAppSetUp()
        var radiusL = CLLocationDistance()
        if let radius = appsetup.disRad{
            if let radiusFloat = Float(radius){
                let radiusmeter = radiusFloat * 1000
                radiusL = CLLocationDistance(radiusmeter)
            }
        }
        
        print(appsetup.disRad ?? "nothing")
        
        if let currentLocation = self.currentLocation{
            let geoFenceCircle = GMSCircle()
            geoFenceCircle.radius = radiusL
            geoFenceCircle.position = currentLocation
            geoFenceCircle.fillColor = UIColor.systemPink.withAlphaComponent(0.05)
            geoFenceCircle.strokeWidth = 3
            geoFenceCircle.strokeColor = UIColor.systemPink.withAlphaComponent(0.7)
            geoFenceCircle.map = viewMapView
        }
    }
    

    private func showAllTaggedList() {
    self.markers.removeAll()
       self.viewMapView.clear()
        self.drawCircle()
        
        self.visitListViewModel.removeAll()
        
        let appsetup = AppDefaults.shared.getAppSetUp()
        var radiusL = CLLocationDistance()
        if let radius = appsetup.disRad{
            if let radiusFloat = Float(radius){
                let radiusmeter = radiusFloat * 10000
                radiusL = CLLocationDistance(radiusmeter)
            }
        }
        
        
        switch self.tagType {
        case .doctor:
            let doctors = DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            for doctor in doctors {
                if let latitude = doctor.lat,let longitude = doctor.long,let doubleLat = Double(latitude),let doubleLongitude = Double(longitude) {
                    let location = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLongitude)
                    
                    if let currentLocation = self.currentLocation{
                        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        let place = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        let distance = current.distance(from: place)
                        
                        print("distance : \(distance)")
                    
                        if distance <= radiusL {
                            let marker = GMSMarker()
                            marker.position = location
                            marker.icon = UIImage(named: "locationRed")
                            marker.iconView?.frame.size = CGSize(width: 10, height: 10)
                            marker.title = doctor.name ?? ""
                            marker.snippet = doctor.code ?? ""
                            marker.map = viewMapView
                            
                            
                            let distanceRound = Double(round(1000 * distance) / 1000)
                            
                            self.visitListViewModel.addVisitViewModel(VisitViewModel(taggedDetail: TaggedDetails(name: doctor.name ?? "", address: doctor.addrs ?? "", meter: "\(distanceRound)", coordinates: location, custCode: doctor.code ?? "", imageURL: doctor.imageName ?? "", tagType: self.tagType)))
                            markers.append(marker)
                        }
                    }
                }
            }
            
        case .chemist:
            let chemists = DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            for chemist in chemists {
                if let latitude = chemist.lat , let longitude = chemist.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    
                    if let currentLocation = self.currentLocation{
                        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        let place = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        let distance = current.distance(from: place)
                        
                        print("distance : \(distance)")
                        
                        if distance <= radiusL {
                            let marker = GMSMarker()
                            marker.position = location
                            marker.icon = UIImage(named: "locationRed")
                            marker.title = chemist.name ?? ""
                            marker.snippet = chemist.code ?? ""
                            marker.map = viewMapView
                            
                            let distanceRound = Double(round(1000 * distance) / 1000)
                            
                            self.visitListViewModel.addVisitViewModel(VisitViewModel(taggedDetail: TaggedDetails(name:  chemist.name ?? "", address: chemist.addr ?? "", meter: "\(distanceRound)", coordinates: location, custCode: chemist.code ?? "", imageURL: chemist.imgName ?? "", tagType: self.tagType)))
                            markers.append(marker)
                        }
                    }
                }
            }
            
        case .stockist:
            let stockists = DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            for stockist in stockists {
                if let latitude = stockist.lat , let longitude = stockist.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    
                    if let currentLocation = self.currentLocation{
                        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        let place = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        let distance = current.distance(from: place)
                        
                        print("distance : \(distance)")
                        
                        if distance <= radiusL {
                            let marker = GMSMarker()
                            marker.position = location
                            marker.icon = UIImage(named: "locationRed")
                            marker.title = stockist.name ?? ""
                            marker.snippet = stockist.code ?? ""
                            marker.map = viewMapView
                            
                            let distanceRound = Double(round(1000 * distance) / 1000)
                            
                            self.visitListViewModel.addVisitViewModel(VisitViewModel(taggedDetail: TaggedDetails(name: stockist.name ?? "", address: stockist.addr ?? "", meter: "\(distanceRound)", coordinates: location, custCode: stockist.code ?? "", imageURL: stockist.imgName ?? "", tagType: self.tagType)))
                            markers.append(marker)
                        }
                    }
                }
            }
            
        case .unlistedDoctor:
            let unlistedDoctors = DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID))
            
            for unlistedDoctor in unlistedDoctors {
                if let latitude = unlistedDoctor.lat , let longitude = unlistedDoctor.long, let douableLat = Double(latitude), let doubleLong = Double(longitude) {
                    
                    let location = CLLocationCoordinate2D(latitude: douableLat, longitude: doubleLong)
                    
                    if let currentLocation = self.currentLocation{
                        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        let place = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        let distance = current.distance(from: place)
                        
                        
                        print("distance : \(distance)")
                        
                        if distance <= radiusL {
                            let marker = GMSMarker()
                            marker.position = location
                            marker.icon = UIImage(named: "locationRed")
                            marker.title = unlistedDoctor.name ?? ""
                            marker.snippet = unlistedDoctor.code ?? ""
                            marker.map = viewMapView
                            
                            let distanceRound = Double(round(1000 * distance) / 1000)
                            
                            self.visitListViewModel.addVisitViewModel(VisitViewModel( taggedDetail: TaggedDetails(name: unlistedDoctor.name ?? "", address: unlistedDoctor.addrs ?? "", meter: "\(distanceRound)", coordinates: location, custCode: unlistedDoctor.code ?? "", imageURL: unlistedDoctor.imgName ?? "", tagType: self.tagType)))
                            markers.append(marker)
                        }
                    }
                }
            }
        }
        self.visitTableView.reloadData()
    }
    
    
    private func att() {
        print("value")
    }
    
    
    @IBAction func addTagAction(_ sender: UIButton) {
        
        let taggingListVC = UIStoryboard.taggingListVC
        taggingListVC.type = self.tagType

        self.navigationController?.pushViewController(taggingListVC, animated: true)
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func leftViewAction(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 1.5) {
            self.viewTableView.isHidden = false
            self.widthTableView.constant = 300
            
            self.btnRight.isHidden = true
            self.btnLeft.isHidden = false
        }
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            print("location == \(coordinate)")
            let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            self.viewMapView.camera =  camera
            self.currentLocation = coordinate
            self.drawCircle()
            self.showAllTaggedList()
        }
    }
    
    
    
    @IBAction func locationSettingAction(_ sender: UIButton) {
        
        LocationManager.shared.getCurrentLocation{ (coordinate) in
            print("location == \(coordinate)")
            let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            self.viewMapView.camera =  camera
            self.currentLocation = coordinate
            self.drawCircle()
            self.showAllTaggedList()
        }
    }
    
    
    
    @IBAction func hideTableViewAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1.5) {
            self.viewTableView.isHidden = true
            self.widthTableView.constant = 0
            
            self.btnLeft.isHidden = true
            self.btnRight.isHidden = false
        }
    }
    
    
}

extension NearMeVC : tableViewProtocols {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visitListViewModel.numbersOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagViewCell", for: indexPath) as! TagViewCell
        cell.selectionStyle = .none
        cell.btnInfo.tintColor = .appTextColor
        let model = self.visitListViewModel.fetchDataAtIndex(indexPath.row)
        cell.visitDetail = model
        if let selectedIndex = self.selectedIndex {
            if selectedIndex == indexPath.row {
                cell.btnInfo.tintColor = .appLightPink
            } else {
                cell.btnInfo.tintColor = .appTextColor
            }
         
        }
        
        cell.addTap {
            self.selectedIndex = indexPath.row
            self.selectedVisitViewModel = model
            let selectedMarker = self.getMarkerWithSnippet(model.custCode)
            guard let selectedMarker  = selectedMarker else {return}
            _ = self.mapView(self.viewMapView, didTap: selectedMarker)
            self.visitTableView.reloadData()
        }
        
        return cell
    }
    
    
    func getMarkerWithSnippet(_ snippet: String) -> GMSMarker? {
        // Iterate through all markers on the map
        for marker in markers {
            // Check if the snippet of the current marker matches the desired snippet
            if marker.snippet == snippet {
                // Return the marker if found
                return marker
            }
        }
        // Return nil if no marker with the desired snippet is found
        return nil
    }
    
}


extension NearMeVC : collectionViewProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.visitListViewModel.numberofTitles()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DcrTagTitleCell", for: indexPath) as! DcrTagTitleCell
        cell.title = self.visitListViewModel.fetchTitleAtIndex(indexPath.row)
        
        if self.tagType.name == self.visitListViewModel.fetchTitleAtIndex(indexPath.row).name {
            cell.viewTitle.backgroundColor = UIColor.appLightTextColor.withAlphaComponent(0.5) //UIColor.lightGray
        }else {
            cell.viewTitle.backgroundColor = UIColor.clear
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DcrTagTitleCell {
            cell.viewTitle.backgroundColor =  UIColor.label.withAlphaComponent(0.5)
            //UIColor.lightGray
        }
        
        self.tagType = self.visitListViewModel.fetchTitleAtIndex(indexPath.row).type
        
        self.selectedIndex = nil
        
        self.headerCollectionView.reloadData()
        
        self.visitTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DcrTagTitleCell {
            cell.viewTitle.backgroundColor = UIColor.clear
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  let label = UILabel()
      //  label.font = UIFont(name: "Satoshi-Bold", size: 20)!
       // label.text = self.visitListViewModel.fetchTitleAtIndex(indexPath.row).name
       // let sizeLabelFit = label.sizeThatFits(CGSize(width: self.headerCollectionView.frame.width-30, height: 50))

       // let size = CGSize(width: sizeLabelFit.width + 40, height: 50)
        
        return CGSize(width:self.visitListViewModel.fetchTitleAtIndex(indexPath.row).name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: collectionView.height)
        
        
       // return size
    }
}


private enum Constants {
    static let spacing: CGFloat = 1
}

