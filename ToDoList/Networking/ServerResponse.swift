struct ServerResponse {
    var status: String?
    var list: [ToDoItem]?
    var element: ToDoItem?
    var revision: Int?
    
    var json: Any {
        
        var dict: [String: Any] = [:]
        
        if let elementJSON = element?.json {
            dict["element"] = elementJSON
        }
        
        if let list = list {
            let listJSON = list.map { $0.json }
            dict["list"] = listJSON
        }
        
        return dict
    }
    
    static func parse(json: Any) -> ServerResponse? {
        
        guard let dict = json as? [String: Any],
              let status = dict["status"] as? String,
              let revision = dict["revision"] as? Int
        else { return nil }
        
        var list: [ToDoItem]?
        if let listArray = dict["list"] as? [Any] {
            var tempList: [ToDoItem] = []
            for item in listArray {
                if let toDoItem = ToDoItem.parse(json: item) {
                    tempList.append(toDoItem)
                }
            }
            if !tempList.isEmpty {
                list = tempList
            }
        }
        
        var element: ToDoItem?
        if let elementJSON = dict["element"] {
            element = ToDoItem.parse(json: elementJSON)
        }
        
        let serverResponse = ServerResponse(status: status, list: list, element: element, revision: revision)
        return serverResponse
    }
}
