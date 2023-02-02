class Task {
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool) {
        self.name = name
        self.isDone = isDone
    }
}

class Model {
    var tasks: [Task] = []
    var count: Int {
        return tasks.count
    }
    
    func moveTask(from: Int, to: Int) {
        let taskFrom = tasks[from]
        tasks.remove(at: from)
        tasks.insert(taskFrom, at: to)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
    }
}

protocol CellDelegate {
    func deleteTask(at index: Int)
    func taskIsDone(at index: Int)
}
