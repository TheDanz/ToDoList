import UIKit
import CoreData
import Foundation

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var index: Int64
    @NSManaged public var color: UIColor?

}

extension Task : Identifiable {

}
