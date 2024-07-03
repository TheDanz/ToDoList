import SwiftUI

struct TaskCalendarVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = TaskCalendarVC
    
    var model: ToDoItemModel
    
    func makeUIViewController(context: Context) -> TaskCalendarVC {
        let taskCalendarVC = TaskCalendarVC()
        taskCalendarVC.model = model
        return taskCalendarVC
    }
    
    func updateUIViewController(_ uiViewController: TaskCalendarVC, context: Context) {
        uiViewController.model = model
    }
}
