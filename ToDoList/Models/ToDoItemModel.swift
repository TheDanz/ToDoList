import SwiftUI
import TaskCategory
import Foundation
import CocoaLumberjackSwift

@MainActor
final class ToDoItemModel: ObservableObject {
    @Published var toDoItems: [ToDoItem] = []
    @Published var isLoading = false
    private let defaultNetworkingService = DefaultNetworkingService()
    private var isDirty = false
    
    init() {
        Task(priority: .background) {
            await fetchToDoItems()
        }
    }
    
    func fetchToDoItems() async {
        do {
            isLoading = true
            let items = try await defaultNetworkingService.fetchList()
            self.toDoItems = items
            isLoading = false
        } catch {
            isDirty = true
            DDLogVerbose("\(Date()): Error fetching items: \(error.localizedDescription)")
        }
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
        Task(priority: .background) {
            do {
                isLoading = true
                if isDirty {
                    await fetchToDoItems()
                    isDirty = false
                }
                try await defaultNetworkingService.addElement(newItem)
                isLoading = false
            } catch {
                isDirty = true
                DDLogVerbose("\(Date()): Error adding item: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteItem(id: String) {
        toDoItems.removeAll { $0.id == id }
        Task(priority: .background) {
            do {
                isLoading = true
                if isDirty {
                    await fetchToDoItems()
                    isDirty = false
                }
                try await defaultNetworkingService.deleteElement(by: id)
                isLoading = false
            } catch {
                isDirty = true
                DDLogVerbose("\(Date()): Error deleting item: \(error.localizedDescription)")
            }
        }
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
            Task(priority: .background) { [item] in
                do {
                    isLoading = true
                    if isDirty {
                        await fetchToDoItems()
                    }
                    try await defaultNetworkingService.updateElement(item)
                    isLoading = false
                } catch {
                    isDirty = true
                    DDLogVerbose("\(Date()): Error updating item: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @Published var categories: [TaskCategory] = [
        TaskCategory(name: "Работа", color: .red),
        TaskCategory(name: "Учеба", color: .blue),
        TaskCategory(name: "Хобби", color: .green),
        TaskCategory.defaultCategory()
    ]
    
    var groupedTasksByDeadline: [String: [ToDoItem]] {
        var groupedTasks: [String: [ToDoItem]] = [:]
        
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
