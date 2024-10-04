//
//  SlideDownloaderCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/05/24.
//


import UIKit

protocol SlideDownloaderCellDelegate: AnyObject {
    func didDownloadCompleted(arrayOfAllSlideObjects : [SlidesModel], index: Int, isForSingleSelection: Bool, isfrorBackgroundTask: Bool, istoreturn: Bool, didEncounterError: Bool, completion: @escaping (Bool) -> Void)
    
}

extension SlideDownloaderCell: MediaDownloaderDelegate {
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?) {
        print("Download completed")
        let params = model[index]
         let data = data
            params.slideData = data ?? Data()
            params.isDownloadCompleted = true
            params.isFailed = false
            lblDataBytes.text = "Download completed"
            btnRetry.isHidden = true
        delegate?.didDownloadCompleted(arrayOfAllSlideObjects: model, index: index, isForSingleSelection: self.isForSingleSelection ?? false, isfrorBackgroundTask: false, istoreturn: false, didEncounterError: false) {_ in}
        
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: Error) {
       let error = error
            let params = model[index]
            params.slideData =  Data()
            params.isDownloadCompleted = false
            params.isFailed = true
           progressView.progressTintColor = .appLightPink
            print("Error downloading media: \(error)")
            lblDataBytes.text = "Error downloading media"
            btnRetry.isHidden = false
        LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: true)

        delegate?.didDownloadCompleted(arrayOfAllSlideObjects: model, index: index, isForSingleSelection: self.isForSingleSelection ?? false, isfrorBackgroundTask: false, istoreturn: false, didEncounterError: true) {_ in}
    }
    
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float) {
        if progress >= 0.0 && progress < 0.25 {
            progressView.progressTintColor = .appLightPink
        } else if progress >= 0.25 && progress < 0.65 {
            progressView.progressTintColor = .systemYellow
        } else if progress >= 0.65 && progress <= 1.0 {
            progressView.progressTintColor = .appGreen
        }
        self.progressView.progress = progress
        let progressPercentage = Int(progress * 100)
        lblDataBytes.text = "Downloading: \(progressPercentage)%"
    }
    
 
    
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data) {
        

            //  completion(true)
        
    }
    
    
}

class SlideDownloaderCell : UITableViewCell  {
    
    
    // MARK: URLSessionDownloadDelegate
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDataBytes: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnRetry: UIButton!
    weak var delegate: SlideDownloaderCellDelegate?
    var model = [SlidesModel]()
    var index: Int = 0
    var isForSingleSelection: Bool? = false
    // var arrayOfAllSlideObjects = [SlidesModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
      //  NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        lblName.setFont(font: .medium(size: .BODY))
        lblDataBytes.setFont(font: .medium(size: .SMALL))
       
        lblName.textColor = .appTextColor
        lblDataBytes.textColor = .appLightTextColor
        btnRetry.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func toSetupDoenloadedCell(_ istoHide: Bool) {
        self.btnRetry.isHidden = istoHide
        isUserInteractionEnabled = istoHide ? false : true
        progressView.setProgress(1, animated: false)
        progressView.progressTintColor = .appGreen
        lblDataBytes.text = "Download completed"
    }
    
    func toSetupErrorCell(_ istoHide: Bool) {
        self.btnRetry.isHidden = istoHide
        isUserInteractionEnabled = true
        progressView.setProgress(1, animated: false)
        progressView.progressTintColor = .appLightPink
        lblDataBytes.text = "Download failed."
    }
    
    
    func toSetupDownloadingCell(_ istoHide: Bool) {
        self.btnRetry.isHidden = istoHide
        isUserInteractionEnabled = istoHide ? false : true
        progressView.setProgress(1, animated: false)
        progressView.progressTintColor = .systemYellow
        lblDataBytes.text = "Waiting to download.."
    }
    
    func toSetupNoNetworkCell() {
        self.btnRetry.isHidden = true
        isUserInteractionEnabled = false
        progressView.setProgress(0.2, animated: false)
        progressView.progressTintColor = .appLightPink
        lblDataBytes.text = "Unable to connect to network"
    }
    
    func toSendParamsToAPISerially(index: Int, items: [SlidesModel], isForsingleRetry: Bool? = false) {
        self.isForSingleSelection = isForsingleRetry
        // self.arrayOfAllSlideObjects = items
        self.model = items
        self.index = index
        self.lblDataBytes.text = "Downloading..."
        btnRetry.isHidden = true
        let params = items[index]
        let filePath = params.filePath
        let url =  LocalStorage.shared.getString(key: LocalStorage.LocalValue.SlideURL)+filePath
        print(url)
        let type = mimeTypeForPath(path: url)
        params.utType = type
        
        // https://sanffa.info/Edetailing_files/DP/download/CC_VA_2021_.jpg
        
       // self.downloadData(mediaURL : url)
        Pipelines.shared.downloadData(mediaURL: url, delegate: self)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.setProgress(0, animated: false)
        self.lblDataBytes.text = "Yet to download.."
    }
    
    func downloadData(mediaURL: String) {
        //, completion: @escaping (Data?, Error?) -> Void
        guard let url = URL(string: mediaURL) else {
           // completion(nil, NSError(domain: "E-Detailing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let downloader = MediaDownloader()
        downloader.delegate = self
        downloader.downloadMedia(from: url)
    }
}






class listView : UIView {
    
    init(){
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



    

protocol MediaDownloaderDelegate: AnyObject {
    func mediaDownloader(_ downloader: MediaDownloader, didUpdateProgress progress: Float)
    func mediaDownloader(_ downloader: MediaDownloader, didFinishDownloadingData data: Data?)
    func mediaDownloader(_ downloader: MediaDownloader, didEncounterError error: Error)
}



extension MediaDownloader: URLSessionDownloadDelegate {
    

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let httpResponse = downloadTask.response as? HTTPURLResponse else {
            // Handle the case where the response is not an HTTP response
            return
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            // The HTTP status code is in the success range, proceed with processing the downloaded file
            do {
                let data = try Data(contentsOf: location)
                delegate?.mediaDownloader(self, didFinishDownloadingData: data)
            } catch {
                print("Error reading downloaded data: \(error.localizedDescription)")
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isSlidesDownloadPending, value: true)
                delegate?.mediaDownloader(self, didEncounterError: error)
            }
        } else {
            // The HTTP status code indicates an error, handle it accordingly
            let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
            delegate?.mediaDownloader(self, didEncounterError: error)
        }
        
        Shared.instance.isSlideDownloading = false
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate?.mediaDownloader(self, didUpdateProgress: progress)
    }
}

class MediaDownloader: NSObject {

    weak var delegate: MediaDownloaderDelegate?
    var session: URLSession?
    func downloadMedia(from url: URL) {
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let downloadTask = session?.downloadTask(with: url)
        downloadTask?.resume()
    }
    func toStopDownload() {
        session?.invalidateAndCancel()
    }
    
}
