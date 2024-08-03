//
//  VideoPlayerCVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 29/01/24.
//

import UIKit
import AVFoundation

protocol VideoPlayerCVCDelegate: AnyObject {
    func videoplayingSatatus(isplaying: Bool)
}

class VideoPlayerCVC: UICollectionViewCell {
    
    
    let playpauseHolderView: UIView = {
        let aVIew = UIView()
        aVIew.clipsToBounds = true
        aVIew.backgroundColor = .clear
        return aVIew
    }()
    
    let playpauseView: UIView = {
        let aVIew = UIView()
        aVIew.clipsToBounds = true
        aVIew.backgroundColor = .clear
        return aVIew
    }()
    
    weak var delegate: VideoPlayerCVCDelegate?
    
    let playIV: UIImageView = {
        let aImage = UIImageView()
        aImage.tintColor = .appTextColor
        aImage.contentMode = .center
        aImage.image =  UIImage(systemName: "pause.fill")
        return aImage
    }()
    
    let vxVIew: UIVisualEffectView = {
        let avxVIew  = UIVisualEffectView()
        avxVIew.clipsToBounds = true
        avxVIew.backgroundColor = .lightGray
        avxVIew.alpha = 0.3
        return avxVIew
    }()
    
    var slider: UISlider!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPlaying: Bool = true
    var state: PlayPresentationView.PageState = .minimized
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playpauseView.layer.cornerRadius = playpauseView.height / 2
        
        playpauseView.isHidden = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewMinimized), name: Notification.Name("viewminimized"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewMaximized), name: Notification.Name("viewExpanded"), object: nil)
        
        self.contentView.addTap {
            self.videoTapped()
        }
        
        self.playpauseHolderView.addTap {
            self.videoTapped()
        }
        
        self.contentView.triggerSwipeDownActionHandleBlocks()
        
        
        
    }
    
    @objc func viewMinimized() {
        state = .minimized
        slider.frame =  CGRect(x: 20, y: contentView.height - contentView.bottom / 3, width: contentView.width - 40, height: 30)
    }
    
    
    @objc func viewMaximized() {
        state = .expanded
        slider.frame =  CGRect(x: 20, y: contentView.height - contentView.bottom / 8, width: contentView.width - 40, height: 30)
    }
    
    
    func toHideShowPlayPasuse() {
        
        playpauseView.isHidden = false
        
        playIV.image = isPlaying ? UIImage(systemName: "pause.fill") :  UIImage(systemName: "play.fill" )
        
        self.isPlaying = !self.isPlaying
        self.isPlaying ? self.player?.pause() :  self.player?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.playpauseView.isHidden = self.isPlaying ? false : true
                // self.slider.isHidden = self.isPlaying ? false : true
            })
        }
        
        if !self.isPlaying {
            self.playpauseView.addTap {
                self.videoTapped()
            }
        }
        
        delegate?.videoplayingSatatus(isplaying: isPlaying)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        self.addSubview(playpauseHolderView)
        playpauseHolderView.addSubview(playpauseView)
        
        playpauseHolderView.frame = CGRect(x: contentView.frame.size.width / 2 - (100 / 2), y: contentView.frame.size.height / 2 - (100 / 2), width: 100, height: 100)
        playpauseView.frame = playpauseHolderView.bounds
       // playpauseView.center = contentView.center
        playpauseView.layer.cornerRadius = playpauseView.height / 2
        playpauseView.addSubview(vxVIew)
        playpauseView.addSubview(playIV)
        vxVIew.frame = playpauseView.bounds
        playIV.frame = playpauseView.bounds
        switch self.state {
        case .expanded:
            slider.frame =  CGRect(x: 20, y: contentView.height - contentView.bottom / 8, width: contentView.width - 40, height: 30)
        case .minimized:
            slider.frame =  CGRect(x: 20, y: contentView.height - contentView.bottom / 3, width: contentView.width - 40, height: 30)
            
        }

        
        self.addSubview(slider)
    }
    
    func setupPlayer(data: Data) {
        let videoData = data
        
        
        let asset = AVAsset(url: createTemporaryFile(withData: videoData))
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
        
        // Add any additional UI elements, e.g., play button, progress bar, etc.
        // ...
        // Set up UISlider
        slider = UISlider()
        slider.tintColor = .red
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
     
        // Add observer for player item status
        playerItem.addObserver(self, forKeyPath: "status", options: [], context: nil)
        
        playIV.image = UIImage(systemName: "play.fill" )
        
  
        
      //  playVideo()
        
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let seekTime = CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: seekTime)
    }
    
    // Observer method to check player item status
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            if playerItem.status == .readyToPlay {
                // Set up UISlider with valid duration
                DispatchQueue.main.async {
                    self.slider.minimumValue = 0
                    self.slider.maximumValue = Float(CMTimeGetSeconds(playerItem.duration))
                    self.slider.value = 0
                    
                    // Add time observer to update slider value
                    let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                    self.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                        self?.slider.value = Float(CMTimeGetSeconds(time))
                    }
                }
            }
        }
    }
    
    
    @objc private func playerDidFinishPlaying() {
        // Handle the end of video playback
        player?.seek(to: .zero)
        player?.play()
    }
    
    func playVideo() {
        player?.play()
    }
    
    private func createTemporaryFile(withData data: Data) -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let temporaryFileURL = temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
        
        do {
            try data.write(to: temporaryFileURL)
            return temporaryFileURL
        } catch {
            fatalError("Error creating temporary file: \(error)")
        }
    }
    
    func videoTapped() {
        // Pause the video when tapped
        toHideShowPlayPasuse()
        
    }
    
    
    
    func pauseVideo() {
        player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Stop and deallocate the player when the cell is reused
        player?.pause()
        player = nil
    }
    
}
