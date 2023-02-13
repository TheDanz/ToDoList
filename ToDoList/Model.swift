import UIKit
import Foundation

//class Task {
//    var name: String
//    var index: Int?
//    var color: UIColor?
//
//    init(name: String) {
//        self.name = name
//    }
//}

class Model {
    var tasks: [Task] = [] {
        didSet {
            filteredTasks = tasks
        }
    }
    var filteredTasks: [Task] = []
    
    func moveTask(from: Int, to: Int) {
        let taskFrom = tasks[from]
        tasks.remove(at: from)
        tasks.insert(taskFrom, at: to)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(task: Task) {
        if let index = task.index {
            tasks.remove(at: index)
        }
    }
    
    func search(searchTextValue: String) {
        filteredTasks = tasks.filter { task in
            task.name.lowercased().contains(searchTextValue.lowercased())
        }
    }
}

protocol CellDelegate {
    func deleteTask(task: Task)
    func taskIsDone(task: Task)
}
