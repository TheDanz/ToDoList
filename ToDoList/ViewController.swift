import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [(String, Bool)] = []
    
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
            
            self.tasks.append((taskName, false))
            self.tableView.reloadData()
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}


extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.nameTaskLabel.text = tasks[indexPath.row].0
        return cell
    }
}
