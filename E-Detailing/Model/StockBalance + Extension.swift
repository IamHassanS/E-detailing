//
//  StockBalance + Extension.swift
//  E-Detailing
//
//  Created by SANEFORCE on 13/10/23.
//

import Foundation
import CoreData


extension StockBalance {
    
    func setValues(fromDictionary dictionary: [String:Any],context: NSManagedObjectContext) {
        if  let inputStockArray = dictionary["Input_Stock"] as? [[String: Any]]{
            for dic in inputStockArray {
                let inputStockEntity = NSEntityDescription.entity(forEntityName: "InputStockBalance", in: context)
                let inputStock = InputStockBalance(entity: inputStockEntity!, insertInto: context)
                inputStock.setValues(fromDictionary: dic)
                self.addToInput(inputStock)
            }
        }
        
        if let sampleStocksArray = dictionary["Sample_Stock"] as? [[String:Any]]{
            for dic in sampleStocksArray{
                let sampleStockEntity = NSEntityDescription.entity(forEntityName: "ProductStockBalance", in: context)
                let sampleStock = ProductStockBalance(entity: sampleStockEntity!, insertInto: context)
                sampleStock.setValues(fromDictionary: dic)
                self.addToProduct(sampleStock)

            }
        }
    }
}


extension ProductStockBalance {
    func setValues(fromDictionary dictionary: [String:Any]) {
        
        if let balanceStockValue = dictionary["Balance_Stock"] as? Int32{
            balanceStock = balanceStockValue
        }
        
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        
        if let divisionCodeValue = dictionary["DivisionCode"] as? String{
            divisionCode = divisionCodeValue
        }
        
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        
        if let packValue = dictionary["Pack"] as? String{
            pack = packValue
        }
        
        if let sfCodeValue = dictionary["SF"] as? String{
            sfCode = sfCodeValue
        }
        
    }
}


extension InputStockBalance {
    
    func setValues(fromDictionary dictionary: [String:Any]) {
        
        if let balanceStockValue = dictionary["Balance_Stock"] as? Int32{
            balanceStock = balanceStockValue
        }
        
        if let codeValue = dictionary["Code"] as? String{
            code = codeValue
        }
        
        if let divisionCodeValue = dictionary["DivisionCode"] as? String{
            divisionCode = divisionCodeValue
        }
        
        if let nameValue = dictionary["Name"] as? String{
            name = nameValue
        }
        
        if let sfCodeValue = dictionary["SF"] as? String{
            sfCode = sfCodeValue
        }
        
    }
    
}
