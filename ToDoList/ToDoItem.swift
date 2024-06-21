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


// MARK: ToDoItem - CSV
extension ToDoItem {
    
    init?(csvLine: String, separator: Character) {
        
        var cells: [String] = []
        var currentCell = ""
        var insideQuotes = false
        
        for char in csvLine {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == separator && !insideQuotes {
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
        
        self.id = cells[0]
        self.text = cells[1]
        self.importance = importance
        self.deadline = formatter.date(from: cells[3])
        self.isDone = isDone
        self.creationDate = currentDate
        self.modificationDate = currentDate
    }
    
    static func parseCSV(fileURL: URL, isHeaders: Bool) -> [ToDoItem] {
        do {
            let csvData = try String(contentsOf: fileURL)
            var lines = csvData.components(separatedBy: .newlines)
            
            if isHeaders {
                lines.removeFirst()
            }
            
            var parsedToDoItems: [ToDoItem] = []
            for line in lines {
                if let toDoItem = ToDoItem(csvLine: line, separator: ";") {
                    parsedToDoItems.append(toDoItem)
                }
            }
            
            return parsedToDoItems
        } catch {
            print("Error reading CSV file: \(error.localizedDescription)")
            return []
        }
    }
}
