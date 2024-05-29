//
//  InputViewModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 16/04/24.
//

import Foundation

class InputSelectedListViewModel {
    var uuid: UUID?
    var inputViewModel = [InputViewModel]()
    var filteredInputs: [Input] = {
        var inputs = DBManager.shared.getInput()
        let currentDate = Date()

        var filteredInputs = inputs.filter { input in
            guard let fromDate = input.effF?.date?.toDate(format: "yyyy-MM-dd HH:mm:ss"),
                  let toDate = input.effT?.date?.toDate(format: "yyyy-MM-dd HH:mm:ss") else {
                // If either fromDate or toDate is nil, exclude the input
                return false
            }

            // Check if today's date is within the range defined by fromDate and toDate
            return fromDate <= currentDate && toDate >= currentDate
        }
        return filteredInputs
  //      dump(filteredInputs)
//        let noInput = inputs.filter { aInput in
//            aInput.code == "-1"
//        }
//
//        let existingIP = filteredInputs.filter { aInput in
//            aInput.code == "-1"
//        }
//
//        if existingIP.isEmpty {
//            filteredInputs.insert(contentsOf: noInput, at: 1)
//        } else {
//            return inputs
//        }
//
//        return filteredInputs
    }()
    
    func fetchAllInput() -> [Input]? {
        return inputViewModel.map { $0.input.input ?? Input() }
        
    }
    
    func fetchAllInputData() -> [InputData]? {
        return inputViewModel.map { $0.input  }
        
    }
    
    
    func fetchInputData(_ index : Int, searchText : String) -> Objects {
        let input = searchText == "" ? filteredInputs : filteredInputs.filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let value = self.inputData()
        
        let isSelected = value.filter{$0.code.contains(input[index].code ?? "")}
        return Objects(Object:input[index], isSelected: isSelected.isEmpty ? false : true, priority: "")
    }
    
    func numberOfInputs (searchText : String) -> Int{
        let inputs = searchText == "" ? filteredInputs : filteredInputs.filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        return inputs.count
    }
    
    
    func addInputViewModel(_ vm : InputViewModel){
        inputViewModel.append(vm)
    }
    
    func numberOfRows() -> Int{
        return inputViewModel.count
    }
    
    func inputData() -> [InputViewModel]{
        return inputViewModel
    }
    
    func removeAtIndex(_ index : Int) {
        inputViewModel.remove(at: index)
    }
    
    func removebyId(_ id : String){
        inputViewModel.removeAll{$0.code == id}
    }
    
    func fetchDataAtIndex(_ index : Int) -> InputViewModel{
        return inputViewModel[index]
    }
    
    func setInputCodeAtIndex(_ index : Int , samQty : String){
        inputViewModel[index].input.updateInputCount(samQty)
    }
    
    func setInputAtIndex(_ index : Int , input : Input){
        inputViewModel[index].input.updateInput(input)
    }
    
}

class InputViewModel {
    
    var input : InputData
    
    init(input: InputData){
        self.input = input
    }
    
    var name : String{
        return input.input?.name ?? ""
    }
    
    var code : String{
        return input.input?.code ?? ""
    }
    
    var inputCount : String{
        return input.inputCount
    }
}



struct InputData {
    var input : Input?
    var availableCount : String
    var inputCount : String
    
    mutating func updateInput (_ selectedInput : Input){
        input = selectedInput
    }
    
    mutating func updateInputCount(_ value : String){
        inputCount = value
    }
    
    mutating func availableCount(_ value : String) {
        availableCount = value
    }
}


struct Objects {
    var Object : AnyObject
    var isSelected : Bool
    var priority : String
}

extension Date {
    func isBetween(_ fromDate: Date?, _ toDate: Date?) -> Bool {
        if let fromDate = fromDate, let toDate = toDate {
            return self >= fromDate && self <= toDate
        }
        return false
    }
}
