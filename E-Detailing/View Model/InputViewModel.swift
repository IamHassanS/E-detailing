//
//  InputViewModel.swift
//  E-Detailing
//
//  Created by SANEFORCE on 16/08/23.
//

import Foundation

class InputSelectedListViewModel {
    
    private var inputViewModel = [InputViewModel]()
    
    
    func fetchAllInput() -> [Input]? {
        return inputViewModel.map { $0.input.input ?? Input() }
        
    }
    
    
    func fetchInputData(_ index : Int, searchText : String) -> Objects {
        let input = searchText == "" ? DBManager.shared.getInput() : DBManager.shared.getInput().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
        
        let value = self.inputData()
        
        let isSelected = value.filter{$0.code.contains(input[index].code ?? "")}
        return Objects(Object:input[index], isSelected: isSelected.isEmpty ? false : true, priority: "")
    }
    
    func numberOfInputs (searchText : String) -> Int{
        let inputs = searchText == "" ? DBManager.shared.getInput() : DBManager.shared.getInput().filter{($0.name?.lowercased() ?? "").contains(searchText.lowercased())}
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
