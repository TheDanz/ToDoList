import SQLite
import Foundation
import CocoaLumberjackSwift

extension FileCache {
    
    private func createTable() {
        let toDoItemsTable = Table("ToDoItems")
        let id = Expression<String>("id")
        let text = Expression<String>("text")
        let deadline = Expression<Date?>("deadline")
        let isDone = Expression<Bool>("isDone")
        let creationDate = Expression<Date>("creationDate")
        
        do {
            try sqlDatabase.run(toDoItemsTable.create { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(deadline)
                table.column(isDone)
                table.column(creationDate)
            })
        } catch {
            DDLogVerbose("\(Date()): Table already exists: \(error)")
        }
    }
    
    func connectDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("database").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.sqlDatabase = database
            createTable()
        } catch {
            DDLogVerbose("\(Date()): Cannot connect to database: \(error)")
        }
    }
    
    func fetchFromSQLite() -> [ToDoItemDB] {
        var toDoItems: [ToDoItemDB] = []
        let toDoItemsTable = Table("ToDoItems")
        let id = Expression<String>("id")
        let text = Expression<String>("text")
        let deadline = Expression<Date?>("deadline")
        let isDone = Expression<Bool>("isDone")
        let creationDate = Expression<Date>("creationDate")
        
        do {
            for toDoItem in try sqlDatabase.prepare(toDoItemsTable) {
                let fetchedItem = ToDoItemDB(id: toDoItem[id], text: toDoItem[text], deadline: toDoItem[deadline], isDone: toDoItem[isDone], creationDate: toDoItem[creationDate])
                toDoItems.append(fetchedItem)
            }
        } catch {
            DDLogVerbose("\(Date()): Fetch failed: \(error)")
        }
        
        return toDoItems
    }
    
    func insertInSQLite(_ toDoItem: ToDoItemDB) {
        let toDoItemsTable = Table("ToDoItems")
        let id = Expression<String>("id")
        let text = Expression<String>("text")
        let deadline = Expression<Date?>("deadline")
        let isDone = Expression<Bool>("isDone")
        let creationDate = Expression<Date>("creationDate")
        
        let insertQuery = toDoItemsTable.insert(
            id <- toDoItem.id,
            text <- toDoItem.text,
            deadline <- toDoItem.deadline,
            isDone <- toDoItem.isDone,
            creationDate <- toDoItem.creationDate
        )
        
        do {
            try sqlDatabase.run(insertQuery)
        } catch {
            DDLogVerbose("\(Date()): Insert failed: \(error)")
        }
    }
    
    func deleteFromSQLite(with id: String) {
        let toDoItemsTable = Table("ToDoItems")
        let idExpression = Expression<String>("id")
        let toDoItemToDelete = toDoItemsTable.filter(id == idExpression)
        do {
            if try sqlDatabase.run(toDoItemToDelete.delete()) > 0 {
                DDLogVerbose("\(Date()): ToDoItem with ID \(id) deleted")
            } else {
                DDLogVerbose("\(Date()): ToDoItem with ID \(id) not found")
            }
        } catch {
            DDLogVerbose("\(Date()): Deleting failed: \(error.localizedDescription)")
        }
    }
    
    func updateInSQLite(_ toDoItem: ToDoItemDB) {
        let toDoItemsTable = Table("ToDoItems")
        let id = Expression<String>("id")
        let text = Expression<String>("text")
        let deadline = Expression<Date?>("deadline")
        let isDone = Expression<Bool>("isDone")
        let creationDate = Expression<Date>("creationDate")
        
        let itemToUpdate = toDoItemsTable.filter(id == toDoItem.id)
        let update = itemToUpdate.update(
            text <- toDoItem.text,
            deadline <- toDoItem.deadline,
            isDone <- toDoItem.isDone,
            creationDate <- toDoItem.creationDate
        )
        do {
            if try sqlDatabase.run(update) > 0 {
                DDLogVerbose("\(Date()): ToDoItem with ID \(toDoItem.id) updated")
            } else {
                DDLogVerbose("\(Date()): ToDoItem with ID \(toDoItem.id) not found")
            }
        } catch {
            DDLogVerbose("\(Date()): Updating failed: \(error.localizedDescription)")
        }
    }
}
