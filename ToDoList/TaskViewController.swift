import UIKit

class TaskViewController: UIViewController {
    
    weak var saveTaskDeleagate: SaveUserTaskDelegate?

    @IBOutlet weak var userTaskField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTaskClick(_ sender: Any) {
        if let task = userTaskField.text {
                if !task.isEmpty {
                  let task = TaskModel(taskName: task, taskCellColor: .white)
                  saveTaskDeleagate?.saveTask(task: task)
                  dismiss(animated: true, completion: nil)
                }
        }
    }
}
