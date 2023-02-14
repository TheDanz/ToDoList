import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameTaskLabel: UILabel!
    
    //var cellDelegate: CellDelegate?
    var task: Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    @IBAction func deleteButtonClick(_ sender: Any) {
//        guard let task = self.task else { return }
//        cellDelegate?.deleteTask(task: task)
//    }
//    
//    @IBAction func taskIsDoneButtonClick(_ sender: Any) {
//        guard let task = self.task else { return }
//        cellDelegate?.taskIsDone(task: task)
//    }
}
