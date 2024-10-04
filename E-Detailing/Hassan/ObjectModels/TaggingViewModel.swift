//
//  TaggingViewModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 30/04/24.
//

import Foundation



class CustomerListViewModel {
    
    let customerListViewModel = [CustomerViewModel]()
    
    
    func fetchDataAtIndex(_ index : Int , type : TaggingType, searchText : String) -> CustomerViewModel {
        
        
        switch type {
            
            case .doctor:
                let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) : DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return CustomerViewModel(tag: doctors[index], type: .doctor)
            case .chemist:
                let chemists = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return CustomerViewModel(tag: chemists[index], type: .chemist)
            case .stockist:
                let stockists = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return CustomerViewModel(tag: stockists[index], type: .stockist)
            case .unlistedDoctor:
                let unListedDoctors = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return CustomerViewModel(tag: unListedDoctors[index], type: .unlistedDoctor)
        }
    }
    
    
    func numberOfRows (_ type : TaggingType , searchText : String) -> Int{
        
        switch type {
            
            case .doctor:
                let doctors = searchText == "" ? DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return doctors.count
            case .chemist:
                let chemists = searchText == "" ? DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getChemist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return chemists.count
            case .stockist:
                let stockists = searchText == "" ? DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getStockist(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
                return stockists.count
            case .unlistedDoctor:
                let unListedDoctors = searchText == "" ? DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)) :  DBManager.shared.getUnListedDoctor(mapID: LocalStorage.shared.getString(key: LocalStorage.LocalValue.selectedRSFID)).filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
            return unListedDoctors.count
        }
    }
    
    
    
}

class CustomerViewModel {
    
    let tag : AnyObject
    let type : TaggingType
    
    
    init(tag: AnyObject, type: TaggingType) {
        self.tag = tag
        self.type = type
    }
    
    var sfCode: String {
        if type == TaggingType.doctor {
            return tag.sfcode ?? ""
        } else if type == TaggingType.chemist {
            if let tag = tag as? Chemist {
                return tag.sfCode ?? ""
            }
        } else if type == TaggingType.stockist {
            if let tag = tag as? Stockist {
                return tag.sfCode ?? ""
            }
        }
 
        return  ""
    }
    var name : String {
        return tag.name ?? ""
    }
    
    var code : String {
        return tag.code ?? ""
    }
    
    var category : String {
        if type == TaggingType.doctor {
            return tag.category ?? ""
        } else if type == TaggingType.chemist {
        
            if let tag = tag as? Chemist {
               let chemCat = DBManager.shared.getChemistCategory()
               let filteredCat = chemCat.filter{ $0.code ==  tag.categoryCode  }.first
                return filteredCat?.categoryName ?? ""
            }
       
        } else if type == TaggingType.stockist {
          //  if let tag = tag as? Stockist {
                return ""
          //  }
        }
        else if type == TaggingType.unlistedDoctor {
            if let tag = tag as? UnListedDoctor {
                return tag.category ?? ""
            }
        }
        return ""
    }
    
    var townName : String {
        return tag.townName ?? ""
    }
    
    var townCode : String {
        return tag.townCode ?? ""
    }
    
    var speciality : String {
        if type == TaggingType.doctor {
            return tag.speciality ?? ""
        } else if type == TaggingType.chemist {
           // if let tag = tag as? Chemist {
                return ""
          //  }
        } else if type == TaggingType.stockist {
          //  if let tag = tag as? Stockist {
                return ""
          //  }
        }
        else if type == TaggingType.unlistedDoctor {
            if let tag = tag as? UnListedDoctor {
                return tag.specialtyName ?? ""
            }
        }
        return ""
    }
    
    var geoCount : String {
        if type == TaggingType.doctor {
            return tag.geoTagCnt ?? ""
        } else if type == TaggingType.chemist {
            if let tag = tag as? Chemist {
                return tag.geoTagCnt ?? ""
            }
        } else if type == TaggingType.stockist {
            if let tag = tag as? Stockist {
                return tag.geoTagCnt ?? ""
            }
        }
        else if type == TaggingType.unlistedDoctor {
            if let tag = tag as? UnListedDoctor {
                return tag.geoTagCnt ?? ""
            }
        }
        return ""
    }
    
    var maxCount : String {
        if type == TaggingType.doctor {
            return tag.maxGeoMap ?? ""
        } else if type == TaggingType.chemist {
            if let tag = tag as? Chemist {
                return tag.maxGeoMap ?? ""
            }
        } else if type == TaggingType.stockist {
            if let tag = tag as? Stockist {
                return tag.maxGeoMap ?? ""
            }
        }
        else if type == TaggingType.unlistedDoctor {
            if let tag = tag as? UnListedDoctor {
                return tag.maxGeoMap ?? ""
            }
        }
        return ""
    }
    
    var tagType : String {
        return type.rawValue
    }
    
    
    
}
