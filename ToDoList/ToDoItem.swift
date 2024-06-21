import Foundation

struct ToDoItem {
    enum Importance: String {
        case important = "important"
        case normal = "normal"
        case unimportant = "unimportant"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .normal,
         deadline: Date? = nil,
         isDone: Bool = false,
         modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = Date()
        self.modificationDate = modificationDate
    }
}


// MARK: ToDoItem - JSON
extension ToDoItem {
    var json: Any {
        
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone
        ]
        
        if importance != .normal {
            dict["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline.ISO8601Format()
        }
        
        return dict
    }
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dict = json as? [String: Any],
              let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["isDone"] as? Bool
        else { return nil }
        
        var importance: Importance?
        if let unwrappedImportance = dict["importance"] as? String {
            importance = Importance(rawValue: unwrappedImportance.lowercased())
        }
                
        var deadline: Date?
        if let unwrappedDeadline = dict["deadline"] as? String {
            let formatter = ISO8601DateFormatter()
            deadline = formatter.date(from: unwrappedDeadline)
        }
        
        let toDoItem = ToDoItem(id: id,
                                text: text,
                                importance: importance ?? .normal,
                                deadline: deadline,
                                isDone: isDone
        )
        return toDoItem
    }
}
