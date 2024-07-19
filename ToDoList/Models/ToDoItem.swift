import SwiftUI
import Foundation
import TaskCategory

struct ToDoItem: Identifiable {
    enum Importance: String {
        case important = "low"
        case normal = "basic"
        case unimportant = "important"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    let color: Color
    let category: TaskCategory
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .normal,
         deadline: Date? = nil,
         isDone: Bool = false,
         modificationDate: Date? = nil,
         color: Color = .white,
         categoty: TaskCategory = .defaultCategory()
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = Date()
        self.modificationDate = modificationDate
        self.color = color
        self.category = categoty
    }
}

// MARK: ToDoItem - JSON
extension ToDoItem {
    var json: Any {
        
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "done": isDone
        ]
        
        if let deadline = deadline {
            dict["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        
        dict["importance"] = importance.rawValue
        dict["color"] = color.toHex
        dict["created_at"] = Int(creationDate.timeIntervalSince1970)
        dict["changed_at"] = Int(modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        dict["last_updated_by"] = "me"
        
        return dict
    }
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dict = json as? [String: Any],
              let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["done"] as? Bool
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
        
        var color: Color = .white
        if let unwrappedColor = dict["color"] as? String {
            color = Color(hex: unwrappedColor)
        }
        
        var modificationDate: Date?
        if let unwrappedModificationDate = dict["changed_at"] as? Int {
            modificationDate = Date(timeIntervalSince1970: TimeInterval(unwrappedModificationDate))
        }
        
        let toDoItem = ToDoItem(
            id: id,
            text: text,
            importance: importance ?? .normal,
            deadline: deadline,
            isDone: isDone,
            modificationDate: modificationDate,
            color: color,
            categoty: .defaultCategory()
        )
        
        return toDoItem
    }
}

// MARK: ToDoItem - CSV
extension ToDoItem {
    static let csvSeparator = ";"
    
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
