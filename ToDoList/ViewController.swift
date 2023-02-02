import UIKit

var tasks: [(String, Bool)] = []

func moveTask(from: Int, to: Int) {
    let taskFrom = tasks[from]
    tasks.remove(at: from)
    tasks.insert(taskFrom, at: to)
}

class ViewController: UIViewController {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func addNewTaskButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your task here..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let taskName = alert.textFields?[0].text else {
                return
            }
            
            tasks.append((taskName, false))
            self.tableView.reloadData()
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    @IBAction func editButtonClick(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let editON = UIImage(systemName: "pencil.slash")
        let editOFF = UIImage(systemName: "pencil")
        editButton.setImage(tableView.isEditing ? editON : editOFF, for: .normal)
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveTask(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.index = indexPath.row
        cell.nameTaskLabel.text = tasks[indexPath.row].0
        cell.cellDelegate = self
        if tasks[indexPath.row].1 {
            cell.backgroundColor = #colorLiteral(red: 0.4666666667, green: 0.7607843137, blue: 0.7019607843, alpha: 1)
        }
        return cell
    }
}

extension ViewController: CellDelegate {
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
        tableView.reloadData()
    }
    
    func taskIsDone(at index: Int) {
        tasks[index].1 = true
        tableView.reloadData()
    }
}

protocol CellDelegate {
    func deleteTask(at index: Int)
    func taskIsDone(at index: Int)
}
