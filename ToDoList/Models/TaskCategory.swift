import UIKit

struct TaskCategory {
    var name: String
    var color: UIColor
    
    static func defaultCategory() -> TaskCategory {
        return TaskCategory(name: "Другое", color: .clear)
    }
}
