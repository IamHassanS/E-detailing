//
//  ObjectFormatter.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/01/24.
//

import Foundation
import UIKit
import PDFKit
import AVFoundation



class ObjectFormatter {
    
    static let shared = ObjectFormatter()
    
    
    func convertData2Obj(data: Data) -> JSON {
        

        
        
        return JSON()
    }
    
    
    func convertDataToJsonArr(data: Data) -> [JSON]? {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [JSON] {
                return jsonObject
            } else {
                print("Failed to convert data to JSON object")
                return nil
            }
        } catch {
            print("Error converting data to JSON: \(error)")
            return nil
        }
    }
    
    func convertDataToJson(data: Data) -> JSON? {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                return jsonObject
            } else {
                print("Failed to convert data to JSON object")
                return nil
            }
        } catch {
            print("Error converting data to JSON: \(error)")
            return nil
        }
    }
    
    func convertJson2String(json: JSON) -> String? {
        
       

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
         
           
            // Convert JSON data to a string
            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
                print(tempjsonString)
                return tempjsonString
            }

        } catch {
            print("Error converting parameter to JSON: \(error)")
        }
        
        return nil
    }
    
    func convertJson2Data(json: JSON) -> Data {
        
        var jsonDatum = Data()

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            jsonDatum = jsonData
           
            // Convert JSON data to a string
            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
                print(tempjsonString)

            }
            return jsonDatum

        } catch {
            print("Error converting parameter to JSON: \(error)")
        }
        
        return Data()
    }
    
    
    func convertJsonArr2Data(json: [JSON]) -> Data {
        
        var jsonDatum = Data()

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            jsonDatum = jsonData
           
            // Convert JSON data to a string
            if let tempjsonString = String(data: jsonData, encoding: .utf8) {
                print(tempjsonString)

            }
            return jsonDatum

        } catch {
            print("Error converting parameter to JSON: \(error)")
        }
        
        return Data()
    }
    
    
    
    
    func loadImageDataInBackground(utType: String?, data: Data?, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self, let data = data else {
                completion(nil)
                return
            }
            
            var imageData: Data?
            
            autoreleasepool {
                if let utType = utType {
                    switch utType {
                    case "image/jpeg", "image/png", "image/jpg", "image/bmp", "text/html", "image/gif":
                        // Just pass the data through
                        
                        imageData =   self.getImageDataFromRawData(data:data)
                        
                       // imageData = data
                    case "video/mp4":
                        // Handle video thumbnail generation here if needed
                        // For now, let's just pass the original data
                        
                        imageData  = self.generateThumbnailData(for: data)
                    case "application/pdf":
                        // Handle PDF thumbnail generation here if needed
                        // For now, let's just pass the original data
                        self.getImageDataFromPDF(data: data) { data in
                             imageData = data
                          
                        }
                    default:
                        // Unsupported type, return nil
                        imageData = nil
                    }
                } else {
                    // No type specified, return nil
                    imageData = nil
                }
            }
            
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    func loadImageInBackground(utType: String?, data: Data?, presentationIV: UIImageView, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let welf = self else {return}
            autoreleasepool {
                var displayImage: UIImage?
                
                if let utType = utType, let data = data {
                    switch utType {
                    case "image/jpeg", "image/png", "image/jpg", "image/bmp", "text/html", "image/gif":
                        if let thumbnailImage = UIImage(data: data)?.resize(to: CGSize(width: presentationIV.width, height: presentationIV.height)) {
                            // Load a thumbnail (adjust the size as needed)
                            displayImage = thumbnailImage
                        } else {
                            // Failed to create a thumbnail
                            displayImage = nil
                        }
                    case "video/mp4":
                        displayImage = welf.displayThumbnail(for: data)
                        
                    case "application/pdf":
                        var pdfView : PDFView?
                        let pdfData = data
                        DispatchQueue.main.async {
                            if let pdfDocument = PDFDocument(data: pdfData) {
                                pdfView = PDFView()
                                pdfView?.document = pdfDocument
                                let pdfPage = pdfDocument.page(at: 0)
                                // Convert the PDF page to an image
                                if let pdfImage = pdfPage?.thumbnail(of: CGSize(width: pdfPage?.bounds(for: .mediaBox).width ?? 0, height: pdfPage?.bounds(for: .mediaBox).height ?? 0), for: .mediaBox) {
                                    // Display the image in the UIImageView
                                    
                                    if let thumbnailImage = pdfImage.resize(to: CGSize(width: presentationIV.width, height: presentationIV.height)) {
                                        // Load a thumbnail (adjust the size as needed)
                                        displayImage = thumbnailImage
                                        
                                        pdfView = nil
                                        displayImage = pdfImage
                                        
                                    }
                                }
                              
                            } else {
                                print("Failed to create PDF document from data.")
                            }
                        }

                    default:
                        displayImage = nil
                    }
                } else {
                    displayImage = nil
                }

                DispatchQueue.main.async {
                    completion(displayImage)
                }
            }
        }
    }
    
    
    
    func getImageDataFromRawData(data: Data) -> Data {
        // Define the desired thumbnail size
        let thumbnailSize = CGSize(width: 100, height: 100)
        
        // Create a UIImage from the raw data
        guard let image = UIImage(data: data) else {
            return Data()
        }
        
        // Resize the image to the desired thumbnail size
        guard let thumbnailImage = image.resize(to: thumbnailSize) else {
            return Data()
        }
        
        // Convert the resized image to data
        if let imageData = thumbnailImage.pngData() {
            return imageData
        } else {
            return Data()
        }
    }
    
    func getImageDataFromPDF(data: Data, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            if let pdfDocument = PDFDocument(data: data) {
                let pdfView = PDFView()
                pdfView.document = pdfDocument
                let pdfPage = pdfDocument.page(at: 0)
                // Convert the PDF page to an image
                if let pdfImage = pdfPage?.thumbnail(of: CGSize(width: pdfPage?.bounds(for: .mediaBox).width ?? 0, height: pdfPage?.bounds(for: .mediaBox).height ?? 0), for: .mediaBox) {
                    // Resize the image to match the UIImageView size
                    if let thumbnailImage = pdfImage.resize(to: CGSize(width: 100, height: 100)) {
                        // Convert UIImage to data
                        if let imageData = thumbnailImage.pngData() {
                            // Return the image data
                            completion(imageData)
                            return
                        }
                    }
                }
            } else {
                print("Failed to create PDF document from data.")
            }
            // Return nil if image data couldn't be obtained
            completion(nil)
        }
    }
    

    func displayThumbnail(for videoData: Data) -> UIImage? {
        // Create a temporary file URL to write the video data
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
        do {
            // Write video data to temporary file
            try videoData.write(to: tempFileURL)
            
            // Create an AVAsset from the file URL
            let asset = AVAsset(url: tempFileURL)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            
            // Generate the thumbnail at time = 0
            let time = CMTime(seconds: 0, preferredTimescale: 600)
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            
            // Convert CGImage to UIImage
            let thumbnail = UIImage(cgImage: cgImage)
            
            // Delete the temporary file
            try FileManager.default.removeItem(at: tempFileURL)
            
            return thumbnail
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
//    func displayThumbnail(for videoData: Data) -> UIImage {
//        guard let videoURL = saveVideoDataToTemporaryFile(data: videoData) else {
//            return UIImage()
//        }
//        
//        let asset = AVAsset(url: videoURL)
//        let generator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//            let cgImage = try generator.copyCGImage(at: CMTimeMake(value: 1, timescale: 2), actualTime: nil)
//            let thumbnailImage = UIImage(cgImage: cgImage)
//          //  deleteTemporaryFile(at: videoURL)
//           return thumbnailImage
//          //  self.contentMode = .scaleAspectFill
//      
//        } catch {
//            print("Error generating thumbnail: \(error.localizedDescription)")
//        }
//        return UIImage()
//    }
    
    
    func generateThumbnailData(for videoData: Data) -> Data? {
        // Create a temporary file URL to write the video data
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
        do {
            // Write video data to temporary file
            try videoData.write(to: tempFileURL)
            
            // Create an AVAsset from the file URL
            let asset = AVAsset(url: tempFileURL)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            
            // Generate the thumbnail at time = 0
            let time = CMTime(seconds: 0, preferredTimescale: 10)
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            
            // Convert CGImage to UIImage
            let thumbnail = UIImage(cgImage: cgImage)
            
            // Convert UIImage to Data
            if let imageData = thumbnail.jpegData(compressionQuality: 1.0) {
                // Delete the temporary file
                try FileManager.default.removeItem(at: tempFileURL)
                return imageData
            } else {
                // Delete the temporary file in case of conversion failure
                try FileManager.default.removeItem(at: tempFileURL)
                return nil
            }
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
//    func generateThumbnailData(for videoData: Data) -> Data {
//        guard let videoURL = saveVideoDataToTemporaryFile(data: videoData) else {
//            return Data()
//        }
//        
//        let asset = AVAsset(url: videoURL)
//        let generator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//            let cgImage = try generator.copyCGImage(at: CMTimeMake(value: 1, timescale: 2), actualTime: nil)
//            let thumbnailImage = UIImage(cgImage: cgImage)
//          //  deleteTemporaryFile(at: videoURL)
//            return thumbnailImage.pngData() ?? Data() // Convert UIImage to data
//        } catch {
//            print("Error generating thumbnail: \(error.localizedDescription)")
//            return Data()
//        }
//    }
    
    func saveVideoDataToTemporaryFile(data: Data) -> URL? {
        do {
            let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("temp_video.mp4")
            try data.write(to: temporaryFileURL)
            return temporaryFileURL
        } catch {
            print("Error saving video data to temporary file: \(error.localizedDescription)")
            return nil
        }
        
    }
    

}
