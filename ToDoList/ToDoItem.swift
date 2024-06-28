import SwiftUI
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
    let color: Color
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .normal,
         deadline: Date? = nil,
         isDone: Bool = false,
         modificationDate: Date? = nil,
         color: Color = .white
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = Date()
        self.modificationDate = modificationDate
        self.color = color
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


// MARK: ToDoItem - CSV
extension ToDoItem {
    static var csvSeparator = ";"
    
    var csv: String {
        
        var csvString = ""
        csvString += "'" + id + "'" + Self.csvSeparator
        csvString += "'" + text + "'" + Self.csvSeparator
        csvString += "'" + importance.rawValue + "'" + Self.csvSeparator
        csvString += "'" + (deadline?.ISO8601Format() ?? "") + "'" + Self.csvSeparator
        csvString += "'" + String(isDone) + "'"
        
        return csvString
    }
    
    static func parse(csv: String) -> ToDoItem? {
        
        var cells: [String] = []
        var currentCell = ""
        var insideQuotes = false
        
        for char in csv {
            if char == "'" {
                insideQuotes.toggle()
            } else if String(char) == Self.csvSeparator && !insideQuotes {
                cells.append(currentCell)
                currentCell = ""
            } else {
                currentCell.append(char)
            }
        }
        cells.append(currentCell)
                
        guard let importance = Importance(rawValue: cells[2].lowercased()),
              let isDone = Bool(cells[4])
        else { return nil }
        
        let formatter = ISO8601DateFormatter()
        let currentDate = Date()
        
        let toDoItem = ToDoItem(
            id: cells[0],
            text: cells[1],
            importance: importance,
            deadline: formatter.date(from: cells[3]),
            isDone: isDone,
            modificationDate: currentDate
        )
        
        return toDoItem
    }
}
