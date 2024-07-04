import UIKit

class TaskCalendarVC: UIViewController {
    
    var model: ToDoItemModel
    
    init(model: ToDoItemModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dateCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
        
    lazy var taskTableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Мои дела"
        
        setupAllSubviews()
        setupAllConstraints()
    }
    
    private func setupAllSubviews() {
        setupDateCollectionView()
        setupTaskTableView()
    }
    
    private func setupAllConstraints() {
        setupDateCollectionViewConstraints()
        setupTaskTableViewConstraints()
    }
    
    private func setupDateCollectionView() {
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(dateCollectionView)
    }
    
    private func setupTaskTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        view.addSubview(taskTableView)
    }
    
    private func setupDateCollectionViewConstraints() {
        dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        dateCollectionView.bottomAnchor.constraint(equalTo: taskTableView.topAnchor, constant: 0).isActive = true
        dateCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        dateCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        dateCollectionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
}
    
    private func setupTaskTableViewConstraints() {
        taskTableView.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 0).isActive = true
        taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}


// MARK: Collection View
extension TaskCalendarVC: UICollectionViewDelegate { }

extension TaskCalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.groupedTasksByDeadline.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let date = sortedDates[indexPath.row]
        
        let title = UILabel()
        title.frame = cell.bounds
        title.text = date
        cell.contentView.addSubview(title)
        
        return cell
    }
}

// MARK: Table View
extension TaskCalendarVC: UITableViewDelegate { }

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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let currentDate = sortedDates[indexPath.section]
        
        guard let swipedItem = model.groupedTasksByDeadline[currentDate]?[indexPath.row] else { return nil }
        
        let contextualAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            
            if self.model.toDoItems.firstIndex(where: { $0.id == swipedItem.id }) != nil {
                self.model.updateToDoItem(id: swipedItem.id, newIsDone: true)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
            completionHandler(true)
        }
        contextualAction.image = UIImage(systemName: "checkmark.circle.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextualAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let currentDate = sortedDates[indexPath.section]
        
        guard let swipedItem = model.groupedTasksByDeadline[currentDate]?[indexPath.row] else { return nil }
        
        let contextualAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            
            if self.model.toDoItems.firstIndex(where: { $0.id == swipedItem.id }) != nil {
                self.model.updateToDoItem(id: swipedItem.id, newIsDone: false)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
            completionHandler(true)
        }
        contextualAction.image = UIImage(systemName: "arrow.uturn.backward.circle.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextualAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let date = sortedDates[indexPath.section]
        if let task = model.groupedTasksByDeadline[date]?[indexPath.row] {
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.text = task.text
            if task.isDone {
                let attributedString = NSMutableAttributedString(string: cell.textLabel!.text!)
                attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
                cell.textLabel!.attributedText = attributedString
            }
        }
        return cell
    }
}
