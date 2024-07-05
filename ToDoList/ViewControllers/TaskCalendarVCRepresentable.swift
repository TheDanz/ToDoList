import SwiftUI

struct TaskCalendarVCRepresentable: UIViewControllerRepresentable {
    
    var model: ToDoItemModel
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let taskCalendarVC = TaskCalendarVC(model: model)
        let navigationController = UINavigationController(rootViewController: taskCalendarVC)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let taskCalendarVC = uiViewController.viewControllers.first as? TaskCalendarVC {
            taskCalendarVC.model = model
        }
    }
}
