import Foundation

class FileCache {
    private(set) var toDoItems: [ToDoItem] = []
    
    func append(item: ToDoItem) -> Bool {
        
        if toDoItems.contains(where: { $0.id == item.id }) {
            return false
        }
        toDoItems.append(item)
        return true
    }
    
    func remove(id: String) -> ToDoItem? {
        for i in 0..<toDoItems.count {
            if toDoItems[i].id == id {
                return toDoItems.remove(at: i)
            }
        }
        return nil
    }
    
    func exportJSONToFile(fileURL: URL) {
        let jsons = toDoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsons, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }
    
    func importJSONFromFile(fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
            for json in jsonArray {
                if let toDoItem = ToDoItem.parse(json: json) {
                    if !append(item: toDoItem) {
                        print("New item with \(toDoItem.id) ID not added: Duplicate ID!")
                    }
                }
            }
        } catch {
            print("Error reading ToDo items from file: \(error.localizedDescription)")
        }
    }
    
    func exportCSVToFile(fileURL: URL) {
        let csvs = toDoItems.map { $0.csv }
        do {
            let joinedStrings = csvs.joined(separator: "\n")
            try joinedStrings.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }
    
    func importCSVFromFile(fileURL: URL, isHeaders: Bool) {
        do {
            let csvData = try String(contentsOf: fileURL)
            var lines = csvData.components(separatedBy: .newlines)
            
            if isHeaders {
                lines.removeFirst()
            }
            
            var parsedToDoItems: [ToDoItem] = []
            for line in lines {
                if let toDoItem = ToDoItem.parse(csv: line) {
                    parsedToDoItems.append(toDoItem)
                }
            }
            
            self.toDoItems.append(contentsOf: parsedToDoItems)
            
        } catch {
            print("Error reading CSV file: \(error.localizedDescription)")
        }
    }
}
