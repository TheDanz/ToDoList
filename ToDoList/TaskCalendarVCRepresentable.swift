import SwiftUI

struct TaskCalendarVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = TaskCalendarVC
    
    var model: ToDoItemModel
    
    func makeUIViewController(context: Context) -> TaskCalendarVC {
        return TaskCalendarVC(model: model)
    }
    
    func updateUIViewController(_ uiViewController: TaskCalendarVC, context: Context) {
        uiViewController.model = model
    }
}
