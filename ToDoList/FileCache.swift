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
    
    func remove(id: String) {
        for i in 0..<toDoItems.count {
            if toDoItems[i].id == id {
                toDoItems.remove(at: i)
                break
            }
        }
    }
    
    func exportToFile(fileURL: URL) {
        let jsons = toDoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsons, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing ToDo items to file: \(error.localizedDescription)")
        }
    }
    
    func importFromFile(fileURL: URL) {
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
}
