//
//  EventCaptureCVC.swift
//  SAN ZEN
//
//  Created by San eforce on 31/05/24.
//

import UIKit

protocol EventCaptureCVCDelegate: AnyObject {
    func didDownloadCompletedatindex(index: Int, image: Data)
}

class EventCaptureCVC: UICollectionViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var eventsIMage: UIImageView!
    
    @IBOutlet var descriptionLbl: UILabel!
    weak var delegate : EventCaptureCVCDelegate?
    var index: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        eventsIMage.layer.cornerRadius = 5
        // Initialization code
    }
    
    func toDownloadimage(model: EventResponse) {
        Shared.instance.showLoaderInWindow()
        titleLbl.text = "Title: \(model.title.isEmpty ? "" : model.title)"
        descriptionLbl.text = "Description: \(model.remarks.isEmpty ? "" : model.title)"
        let prefixURL = LocalStorage.shared.getString(key: LocalStorage.LocalValue.ImageDownloadURL)
        let modifiedUrlString = prefixURL.replacingOccurrences(of: "photos/", with: "")
        let remoteURL = modifiedUrlString + model.eventImg
        Pipelines.shared.downloadData(mediaURL: remoteURL, delegate: self)
    }

}
extension EventCaptureCVC: MediaDownloaderDelegate {
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
        DispatchQueue.main.async {
            guard let nonNilindex = self.index else {return}
            self.delegate?.didDownloadCompletedatindex(index: nonNilindex, image: data)
        
        }
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: any Error) {
        Shared.instance.removeLoaderInWindow()
    
        print("Error")


    }
    
    
}
