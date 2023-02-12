import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let model = Model()
    
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
            
            let task = Task(name: taskName)
            self.model.addTask(task)
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
        model.moveTask(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            model.deleteTask(task: model.tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TableViewCell else {
            return UITableViewCell()
        }
        model.tasks[indexPath.row].index = indexPath.row
        let task = model.tasks[indexPath.row]
        cell.nameTaskLabel.text = model.filteredTasks[indexPath.row].name
        cell.backgroundColor = model.filteredTasks[indexPath.row].color
        cell.cellDelegate = self
        cell.task = task
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.filteredTasks = []
        
        if searchText == "" {
            model.filteredTasks = model.tasks
        } else {
            model.search(searchTextValue: searchText)
        }
        
        tableView.reloadData()
    }
}

extension ViewController: CellDelegate {
    func deleteTask(task: Task) {
        model.deleteTask(task: task)
        tableView.reloadData()
    }
    
    func taskIsDone(task: Task) {
        task.color = #colorLiteral(red: 0.4666666667, green: 0.7607843137, blue: 0.7019607843, alpha: 1)
        tableView.reloadData()
    }
}
