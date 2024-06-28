import SwiftUI
import Foundation

final class ToDoItemModel: ObservableObject {
    @Published var toDoItems: [ToDoItem] = [
        ToDoItem(id: "1", text: "task 1", importance: .unimportant, deadline: Date(), color: .red),
        ToDoItem(id: "2", text: "task 2", importance: .normal, deadline: Date(), color: .green),
        ToDoItem(id: "3", text: "task 3", importance: .important, deadline: Date(), color: .brown),
        ToDoItem(id: "4", text: "task 4", importance: .unimportant, color: .orange),
        ToDoItem(id: "5", text: "task 5", importance: .normal, color: .yellow),
        ToDoItem(id: "6", text: "task 6", importance: .important, color: .blue)
    ]
    
    func addItem(text: String, importance: ToDoItem.Importance = .normal, deadline: Date? = nil) {
        let newItem = ToDoItem(text: text, importance: importance, deadline: deadline)
        toDoItems.append(newItem)
    }
    
    func deleteItem(id: String) {
        toDoItems.removeAll { $0.id == id }
    }
    
    func updateToDoItem(
        id: String,
        newText: String? = nil,
        newImportance: ToDoItem.Importance? = nil,
        newDeadline: Date? = nil,
        newIsDone: Bool? = nil,
        newColor: Color?
    ) {
        if let index = toDoItems.firstIndex(where: { $0.id == id }) {
            var item = toDoItems[index]
            item = ToDoItem(
                id: item.id,
                text: newText ?? item.text,
                importance: newImportance ?? item.importance,
                deadline: newDeadline,
                isDone: newIsDone ?? item.isDone,
                modificationDate: Date(),
                color: newColor ?? item.color
            )
            toDoItems[index] = item
        }
    }
    
    enum SortBy {
        case creationDate
        case importance
    }
    
    func sort(by: SortBy) {
        toDoItems = toDoItems.sorted(by: { lhs, rhs in
            switch by {
            case .creationDate:
                return lhs.creationDate < rhs.creationDate
            case .importance:
                return lhs.importance.rawValue > rhs.importance.rawValue
            }
        })
    }
}
