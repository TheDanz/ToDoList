import SwiftUI
import Foundation

final class ToDoItemModel: ObservableObject {
    @Published var toDoItems: [ToDoItem] = [
        ToDoItem(
            id: "1",
            text: "task 1",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            color: .red
        ),
        ToDoItem(
            id: "2",
            text: "task 2",
            importance: .normal,
            deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            color: .green
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
            deadline: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
            color: .orange
        ),
        ToDoItem(
            id: "5",
            text: "task 5",
            importance: .normal,
            color: .yellow
        ),
        ToDoItem(
            id: "6",
            text: "task 6\ntask 6\ntask 6",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            color: .blue
        ),
        ToDoItem(
            id: "7",
            text: "task 7\ntask 7\ntask 7",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 6, to: Date()),
            color: .red
        ),
        ToDoItem(
            id: "8",
            text: "task 8\ntask 8\ntask 8",
            importance: .normal,
            deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            color: .green
        ),
        ToDoItem(
            id: "9",
            text: "task 9\ntask 9\ntask 9",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 8, to: Date()),
            color: .brown
        ),
        ToDoItem(
            id: "10",
            text: "task 10\ntask 10\ntask 10",
            importance: .unimportant,
            deadline: Calendar.current.date(byAdding: .day, value: 8, to: Date()),
            color: .orange
        ),
        ToDoItem(
            id: "11",
            text: "task 11\ntask 11\ntask 11",
            importance: .normal,
            color: .yellow
        ),
        ToDoItem(
            id: "12",
            text: "task 12\ntask 12\ntask 12",
            importance: .important,
            deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            color: .blue
        )
    ]
    
    var groupedTasksByDeadline: Dictionary<String, [ToDoItem]> {
        var dict = Dictionary<String, [ToDoItem]>()
        
        for item in toDoItems {
            if let deadline = item.deadline {
                dict[getDayAndMonth(from: deadline), default: []].append(item)
            } else {
                dict["Другое", default: []].append(item)
            }
        }
        
        return dict
    }
    
    func addItem(text: String, importance: ToDoItem.Importance = .normal, deadline: Date? = nil, color: Color = .white) {
        let newItem = ToDoItem(text: text, importance: importance, deadline: deadline, color: color)
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
        newColor: Color? = nil
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
