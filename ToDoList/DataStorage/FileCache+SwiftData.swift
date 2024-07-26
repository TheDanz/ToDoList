import SwiftData
import CocoaLumberjackSwift

@MainActor
extension FileCache {
    
    func fetch() -> [ToDoItemDB] {
        let fetchDescriptor = FetchDescriptor<ToDoItemDB>()
        do {
            let context = container?.mainContext
            return try context!.fetch(fetchDescriptor)
        } catch {
            DDLogVerbose("\(Date()): FileCache fetch error")
        }
        return []
    }
    
    func fetchSorted(by keyPath: KeyPath<ToDoItemDB, some Comparable>, order: SortOrder) -> [ToDoItemDB] {
        let sortDescriptor = SortDescriptor(keyPath, order: order)
        let fetchDescriptor = FetchDescriptor<ToDoItemDB>(sortBy: [sortDescriptor])
        do {
            let context = container?.mainContext
            return try context!.fetch(fetchDescriptor)
        } catch {
            DDLogVerbose("\(Date()): FileCache fetch error")
        }
        return []
    }
    
    func fetchFiltered(by predicate: Predicate<ToDoItemDB>) -> [ToDoItemDB] {
        let fetchDescriptor = FetchDescriptor<ToDoItemDB>(predicate: predicate)
        do {
            let context = container?.mainContext
            return try context!.fetch(fetchDescriptor)
        } catch {
            DDLogVerbose("\(Date()): FileCache fetch error")
        }
        return []
    }
    
    func insert(_ toDoItem: ToDoItemDB) {
        container?.mainContext.insert(toDoItem)
    }
    
    func delete(_ toDoItem: ToDoItemDB) {
        container?.mainContext.delete(toDoItem)
    }
    
    func update(_ toDoItem: ToDoItemDB) {
        let items = fetch().filter { $0.id == toDoItem.id }
        if !items.isEmpty {
            delete(items[0])
            insert(toDoItem)
        }
    }
}
