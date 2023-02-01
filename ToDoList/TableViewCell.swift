import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var nameTaskLabel: UILabel!
    
    var index = 0
    var cellDelegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        cellDelegate?.deleteTask(at: index)
    }
}
