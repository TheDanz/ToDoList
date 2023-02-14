import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var dataStorageManager = DataStorageManager()
    var fetchResultController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDecriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.fetchLimit = 15
        fetchRequest.sortDescriptors = [sortDecriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataStorageManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
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
            
            let task = Task(context: self.dataStorageManager.viewContext)
            task.name = taskName
            
            try! self.dataStorageManager.viewContext.save()
            
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let count = fetchResultController.fetchedObjects?.count ?? 0
        
        var array: [Int] = []
        for i in 0..<count {
            array.append(i)
        }
        
        let newElement = array.remove(at: sourceIndexPath.row)
        array.insert(newElement, at: destinationIndexPath.row)
        
        for i in 0..<count {
            let task = fetchResultController.object(at: IndexPath(row: i, section: 0))
            
            let newPosition = array.firstIndex(of: i)!
            task.index = Int64(newPosition)
        }
        
        try! dataStorageManager.viewContext.save()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = fetchResultController.object(at: indexPath)
            dataStorageManager.viewContext.delete(task)
            try! dataStorageManager.viewContext.save()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TableViewCell else {
            return UITableViewCell()
        }
        
        let task = fetchResultController.object(at: indexPath)
        task.index = Int64(indexPath.row)
        try! dataStorageManager.viewContext.save()
        
        cell.nameTaskLabel.text = task.name
        cell.backgroundColor = task.color
        cell.cellDelegate = self
        cell.task = task
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath,
               let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}

// MARK: - CellDelegate

extension ViewController: CellDelegate {
    
    func deleteTask(task: Task) {
        
        let taskToDelete = fetchResultController.object(at: IndexPath(row: Int(task.index), section: 0))
        dataStorageManager.viewContext.delete(taskToDelete)
        try! dataStorageManager.viewContext.save()
        tableView.reloadData()
    }

    func taskIsDone(task: Task) {
        
        let task = fetchResultController.object(at: IndexPath(row: Int(task.index), section: 0))
        task.color = #colorLiteral(red: 0.4666666667, green: 0.7607843137, blue: 0.7019607843, alpha: 1)
        tableView.reloadData()
    }
}

protocol CellDelegate {
    func deleteTask(task: Task)
    func taskIsDone(task: Task)
}
