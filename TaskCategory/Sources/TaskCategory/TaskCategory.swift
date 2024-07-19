import UIKit

public struct TaskCategory: Sendable {
    public var name: String
    public var color: UIColor
    
    public init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
    public static func defaultCategory() -> TaskCategory {
        return TaskCategory(name: "Другое", color: .clear)
    }
}
