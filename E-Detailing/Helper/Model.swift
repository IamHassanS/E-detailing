import Foundation

struct Section {
    var date: String
    var items: [TodayCallsModel]
    var isCallExpanded: Bool
    var collapsed: Bool
    var isLoading = Bool()
    
    init(items: [TodayCallsModel] , collapsed: Bool = true, isCallExpanded: Bool = false, date: String) {
    self.items = items
    self.collapsed = collapsed
    self.isCallExpanded = isCallExpanded
    self.date = date
  }
}
    
var obj_sections : [Section] = []
