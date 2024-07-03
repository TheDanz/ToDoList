import UIKit
import SwiftUI

class TaskCalendarVC: UIViewController {
    
    var model: ToDoItemModel
    
    init(model: ToDoItemModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    lazy var taskTableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        view.addSubview(taskTableView)
        
        setupAllConstraints()
    }
    
    private func setupAllConstraints() {
        setupTasksTableViewConstraints()
    }
    
    private func setupTasksTableViewConstraints() {
        taskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}

extension TaskCalendarVC: UITableViewDelegate {
    
}

extension TaskCalendarVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.groupedTasksByDeadline.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        return sortedDates[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let date = sortedDates[section]
        return model.groupedTasksByDeadline[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let date = sortedDates[indexPath.section]
        if let task = model.groupedTasksByDeadline[date]?[indexPath.row] {
            cell.textLabel?.text = task.text
        }
        return cell
    }
}
