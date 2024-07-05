import SwiftUI
import Foundation

final class ToDoItemModel: ObservableObject {
    @Published var toDoItems: [ToDoItem] = [
        ToDoItem(
            id: "1",
            text: "task 1",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            color: .red,
            categoty: TaskCategory(name: "Работа", color: .red)
        ),
        ToDoItem(
            id: "2",
            text: "task 2",
            importance: .normal,
            deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            color: .green,
            categoty: TaskCategory(name: "Хобби", color: .green)
        ),
        ToDoItem(
            id: "3",
            text: "task 3",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            color: .brown
        ),
        ToDoItem(
            id: "4",
            text: "task 4",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            color: .orange,
            categoty: TaskCategory(name: "Работа", color: .red)
        ),
        ToDoItem(
            id: "5",
            text: "task 5",
            importance: .normal,
            color: .yellow,
            categoty: TaskCategory(name: "Учеба", color: .blue)
        ),
        ToDoItem(
            id: "6",
            text: "task 6",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            color: .blue
        ),
        ToDoItem(
            id: "7",
            text: "task 7",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 6, to: Date()),
            color: .red
        ),
        ToDoItem(
            id: "8",
            text: "task 8",
            importance: .normal,
            deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            color: .green,
            categoty: TaskCategory(name: "Работа", color: .red)
        ),
        ToDoItem(
            id: "9",
            text: "task 9",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 8, to: Date()),
            color: .brown,
            categoty: TaskCategory(name: "Учеба", color: .blue)
        ),
        ToDoItem(
            id: "10",
            text: "task 10",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 8, to: Date()),
            color: .orange,
            categoty: TaskCategory(name: "Работа", color: .red)
        ),
        ToDoItem(
            id: "11",
            text: "task 11",
            importance: .normal,
            color: .yellow,
            categoty: TaskCategory(name: "Учеба", color: .blue)
        ),
        ToDoItem(
            id: "12",
            text: "task 12",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            color: .blue,
            categoty: TaskCategory(name: "Хобби", color: .green)
        )
    ]
    
    @Published var categories: [TaskCategory] = [
        TaskCategory(name: "Работа", color: .red),
        TaskCategory(name: "Учеба", color: .blue),
        TaskCategory(name: "Хобби", color: .green),
        TaskCategory.defaultCategory()
    ]
    
    var groupedTasksByDeadline: Dictionary<String, [ToDoItem]> {
        var groupedTasks = Dictionary<String, [ToDoItem]>()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        
        for item in toDoItems {
            if let deadline = item.deadline {
                let formattedDeadline = formatter.string(from: deadline)
                groupedTasks[formattedDeadline, default: []].append(item)
            } else {
                groupedTasks["Другое", default: []].append(item)
            }
        }
        
        return groupedTasks
    }
    
    func addItem(
        text: String,
        importance: ToDoItem.Importance = .normal,
        deadline: Date? = nil,
        color: Color = .white,
        category: TaskCategory = .defaultCategory()
    ) {
        let newItem = ToDoItem(
            text: text,
            importance: importance,
            deadline: deadline,
            color: color,
            categoty: category
        )
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
        newColor: Color? = nil,
        newCategory: TaskCategory? = nil
    ) {
        if let index = toDoItems.firstIndex(where: { $0.id == id }) {
            var item = toDoItems[index]
            item = ToDoItem(
                id: item.id,
                text: newText ?? item.text,
                importance: newImportance ?? item.importance,
                deadline: newDeadline ?? item.deadline,
                isDone: newIsDone ?? item.isDone,
                modificationDate: Date(),
                color: newColor ?? item.color,
                categoty: newCategory ?? item.category
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
