//
//  SlidesModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import Foundation
import Foundation
import MobileCoreServices



    
    
    
    class GroupedBrandsSlideModel: Codable {
        var uuid: UUID
        var groupedSlide : [SlidesModel]
        var priority: Int
        var updatedDate: DateInfo
        var divisionCode: Int
        var productBrdCode: Int
        var subdivisionCode: Int
        var createdDate: DateInfo
        var id: Int
        
        
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.groupedSlide = try container.decode([SlidesModel].self, forKey: .groupedSlide)
            self.priority = try container.decode(Int.self, forKey: .priority)
            self.updatedDate = try container.decode(DateInfo.self, forKey: .updatedDate)
            self.divisionCode = try container.decode(Int.self, forKey: .divisionCode)
            self.productBrdCode = try container.decode(Int.self, forKey: .productBrdCode)
            self.subdivisionCode = try container.decode(Int.self, forKey: .subdivisionCode)
            self.createdDate = try container.decode(DateInfo.self, forKey: .createdDate)
            self.id = try container.decode(Int.self, forKey: .id)
            self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        }
        
        
        init() {
            self.groupedSlide = [SlidesModel]()
            self.priority = Int()
            self.updatedDate = DateInfo()
            self.divisionCode = Int()
            self.productBrdCode = Int()
            self.subdivisionCode = Int()
            self.createdDate = DateInfo()
            self.id = Int()
            self.uuid = UUID()
        }
        
    }
    
    
    class  BrandSlidesModel: Codable {
        var uuid : UUID
        var priority: Int
       // var updatedDate: DateInfo
        var divisionCode: Int
        var productBrdCode: Int
        var subdivisionCode: Int
      //  var createdDate: DateInfo
        var id: Int
        
        private enum CodingKeys: String, CodingKey {
            case priority = "Priority"
           // case updatedDate = "Updated_Date"
            case divisionCode = "Division_Code"
            case productBrdCode = "Product_Brd_Code"
            case subdivisionCode = "Subdivision_Code"
           // case createdDate = "Created_Date"
            case id = "ID"
            case uuid
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.productBrdCode = container.safeDecodeValue(forKey: .productBrdCode)
            self.priority = container.safeDecodeValue(forKey: .priority)
           // self.updatedDate =  try container.decodeIfPresent(DateInfo.self, forKey: .updatedDate) ?? DateInfo()
            self.divisionCode = container.safeDecodeValue(forKey: .divisionCode)
          
            self.subdivisionCode = container.safeDecodeValue(forKey: .subdivisionCode)
          //  self.createdDate =  try container.decodeIfPresent(DateInfo.self, forKey: .createdDate) ?? DateInfo()
            self.id =  container.safeDecodeValue(forKey: .id)
            self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        }
        
        
        init() {
            uuid = UUID()
            priority = Int()
           // updatedDate = DateInfo()
            divisionCode = Int()
            productBrdCode = Int()
            subdivisionCode = Int()
          //  createdDate = DateInfo()
            id = Int()
            
            
            
            
        }
    }
    
    
    class SlidesModel: NSObject, Codable, NSItemProviderWriting {
        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(uuid)
//        }
        
        
        // MARK: - NSItemProviderWriting

        static var writableTypeIdentifiersForItemProvider: [String] {
            return [kUTTypeData as String]
        }

        func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(self)
                completionHandler(jsonData, nil)
            } catch {
                completionHandler(nil, error)
            }
            return nil
        }
        
       var code: Int
       var camp: Int
       var index: Int
       var productDetailCode: String
       var filePath: String
       var group: Int
       var specialityCode: String
       var uuid: UUID
       var slideId: Int
       var fileType: String
       var effFrom: DateInfo
       var categoryCode: String
       var name: String
       var noofSamples: Int
       var effTo: DateInfo
       var ordNo: Int
       var priority: Int
       var slideData: Data
       var utType : String
       var isSelected : Bool
       var fileName: String
       var isDownloadCompleted: Bool
        var isFailed: Bool
        var imageData: Data
        enum CodingKeys: String, CodingKey {
            case code              = "Code"
            case camp               = "Camp"
            case productDetailCode = "Product_Detail_Code"
            case filePath           = "FilePath"
            case group               = "Group"
            case specialityCode      = "Speciality_Code"
            case slideId = "SlideId"
            case fileType = "FileTyp"
            case effFrom = "Eff_from"
            case categoryCode = "Category_Code"
            case name = "Name"
            case noofSamples = "NoofSamples"
            case effTo = "EffTo"
            case ordNo = "OrdNo"
            case priority = "Priority"
            case slideData
            case utType
            case isSelected
            case uuid
            case fileName
            case isDownloadCompleted
            case isFailed
            case index
            case imageData
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            self.code               = container.safeDecodeValue(forKey: .code)
            self.camp               = container.safeDecodeValue(forKey: .camp)
            self.productDetailCode  = container.safeDecodeValue(forKey: .productDetailCode)
            self.filePath           = container.safeDecodeValue(forKey: .filePath)
            self.group              = container.safeDecodeValue(forKey: .group)
            self.specialityCode     = container.safeDecodeValue(forKey: .specialityCode)
            self.slideId            = container.safeDecodeValue(forKey: .slideId)
            self.fileType           = container.safeDecodeValue(forKey: .fileType)
            self.effFrom            = try container.decodeIfPresent(DateInfo.self, forKey: .effFrom) ?? DateInfo()
            self.categoryCode       = container.safeDecodeValue(forKey: .categoryCode)
            self.name               = container.safeDecodeValue(forKey: .name)
            self.noofSamples        = container.safeDecodeValue(forKey: .noofSamples)
            self.effTo              =   try container.decodeIfPresent(DateInfo.self, forKey: .effTo) ?? DateInfo()
            self.ordNo              = container.safeDecodeValue(forKey: .ordNo)
            self.priority           = container.safeDecodeValue(forKey: .priority)
            self.slideData          =  try container.decodeIfPresent(Data.self, forKey: .slideData) ?? Data()
            self.utType             = container.safeDecodeValue(forKey: .utType)
            self.isSelected         = container.safeDecodeValue(forKey: .isSelected)
            self.uuid               = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
            self.fileName               = try container.decodeIfPresent(String.self, forKey: .fileName) ?? String()
            self.isDownloadCompleted     = try container.decodeIfPresent(Bool.self, forKey: .isDownloadCompleted) ?? Bool()
            self.isFailed = try container.decodeIfPresent(Bool.self, forKey: .isFailed) ?? Bool()
            self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData) ?? Data()
            
            self.index = try container.decodeIfPresent(Int.self, forKey: .index) ?? Int()
        }
        
        
        
        
        override init() {
            code              = Int()
            camp              = Int()
            productDetailCode = String()
            filePath          = String()
            group             = Int()
            specialityCode    = String()
            slideId           = Int()
            fileType          = String()
            effFrom            = DateInfo()
            categoryCode       = String()
            name              = String()
            noofSamples        = Int()
            effTo            = DateInfo()
            ordNo             = Int()
            priority          = Int()
            slideData         = Data()
            utType             = String()
            isSelected          = Bool()
            uuid                = UUID()
            fileName = String()
            isDownloadCompleted = Bool()
            isFailed = Bool()
            index = Int()
            imageData = Data()
        }
    }
    
//extension SlidesModel: Equatable {
//    static func == (lhs: SlidesModel, rhs: SlidesModel) -> Bool {
//        return lhs.slideId == rhs.slideId
//    }
//}

    class DateInfo: Codable {
        let date: String
        let timezone: String
        let timezoneType: Int
        
        enum CodingKeys: String, CodingKey {
            case date
            case timezone
            case  timezoneType = "timezone_type"
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            self.date = container.safeDecodeValue(forKey: .date)
            self.timezone = container.safeDecodeValue(forKey: .timezone)
            self.timezoneType = container.safeDecodeValue(forKey: .timezoneType)
        }
        
        init() {
            
            date = String()
            timezone = String()
            timezoneType = Int()
            
            
            
        }
        
        
    }






class SavedPresentation: Codable {
    var groupedBrandsSlideModel : [GroupedBrandsSlideModel]
    var uuid: UUID
    var name: String
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupedBrandsSlideModel = try container.decode([GroupedBrandsSlideModel].self, forKey: .groupedBrandsSlideModel)
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.name = container.safeDecodeValue(forKey: .name)
    }
    
    init() {
        self.groupedBrandsSlideModel = [GroupedBrandsSlideModel]()
        self.uuid = UUID()
        self.name = String()
    }
}
