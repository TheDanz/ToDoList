import Foundation

protocol NetworkingService {
    func makeURL(withID id: String?) throws -> URL
    
    func fetchList() async throws -> [ToDoItem]
    func updateList(_ list: [ToDoItem]) async throws
    func getElement(by id: String) async throws -> ToDoItem
    func addElement(_ item: ToDoItem) async throws
    func updateElement(_ item: ToDoItem) async throws
    func deleteElement(by id: String) async throws
}
