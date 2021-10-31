import UIKit

class TaskTableViewCell: UITableViewCell {
    
    weak var removeTaskDelegate: RemoveTaskDelegate?
    weak var taskCompletedDelegate: TaskCompletedDelegate?
    var task: TaskModel?

    @IBOutlet weak var someTask: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellData(task: TaskModel) {
        someTask.text = task.taskName
        viewCell.backgroundColor = task.taskCellColor
        self.task = task
      }

    @IBAction func removeTaskClick(_ sender: Any) {
        guard let task = task else { return }
        removeTaskDelegate?.removeTask(task: task)
    }
    
    @IBAction func executeTaskClick(_ sender: Any) {
        guard let task = task else { return }
        taskCompletedDelegate?.taskComplete(task: task)
    }
}
