import UIKit
import SwiftUI

class TaskCalendarVC: UIViewController {
    
    var model: ToDoItemModel
    private var selectedSection: Int = 0
    
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
    
    lazy var plusButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Мои дела"
        
        setupBarButtonItems()
        setupAllSubviews()
        setupAllConstraints()
    }
    
    @objc
    private func plusButtonClick(_ sender: UIButton) {
        
        let rootView = DetailsView(model: model) {
            DispatchQueue.main.async {
                self.dateCollectionView.reloadData()
                self.taskTableView.reloadData()
            }
        }
        
        let hostingController = UIHostingController(rootView: rootView)
        self.present(hostingController, animated: true)
    }
    
    @objc
    private func backButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func setupBarButtonItems() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.backward.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(backButtonClick(_:))
        )
        
        navigationItem.leftBarButtonItems = [backButton]
    }
    
    private func setupAllSubviews() {
        setupDateCollectionView()
        setupTaskTableView()
        setupPlusButton()
    }
    
    private func setupAllConstraints() {
        setupDateCollectionViewConstraints()
        setupTaskTableViewConstraints()
        setupPlusButtonConstraints()
    }
    
    private func setupDateCollectionView() {
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        dateCollectionView.backgroundColor = UIColor(CustomColor.backLightPrimary)
        dateCollectionView.layer.borderColor = UIColor.gray.cgColor
        dateCollectionView.layer.borderWidth = 0.3
        view.addSubview(dateCollectionView)
    }
    
    private func setupTaskTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        taskTableView.backgroundColor = UIColor(CustomColor.backLightPrimary)
        view.addSubview(taskTableView)
    }
    
    private func setupPlusButton() {
        plusButton.addTarget(self, action: #selector(plusButtonClick(_:)), for: .touchUpInside)
        view.addSubview(plusButton)
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
    
    private func setupPlusButtonConstraints() {
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
}


// MARK: Collection View
extension TaskCalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.row
        selectedSection = section
        taskTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        DispatchQueue.main.async {
            self.dateCollectionView.reloadData()
        }
    }
}

extension TaskCalendarVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.groupedTasksByDeadline.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let separatedDate = sortedDates[indexPath.row].split(separator: " ").map({ String($0) })
        
        if indexPath.row == selectedSection {
            cell.setupContentViewAsSelected()
        } else {
            cell.setupContentViewAsUnselected()
        }
        
        if separatedDate.count == 1 {
            cell.configure(day: "", month: "Другое")
            return cell
        }
        
        cell.configure(day: separatedDate[0], month: separatedDate[1])
        return cell
    }
}

// MARK: Table View
extension TaskCalendarVC: UITableViewDelegate { 
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleSections = taskTableView.indexPathsForVisibleRows?.map { $0.section } ?? []
        if let visibleSection = visibleSections.min(), visibleSection != selectedSection {
            selectedSection = visibleSection
            dateCollectionView.selectItem(at: IndexPath(item: selectedSection, section: 0), animated: true, scrollPosition: .left)
            DispatchQueue.main.async {
                self.dateCollectionView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section != selectedSection {
            selectedSection = section
            dateCollectionView.selectItem(at: IndexPath(item: selectedSection, section: 0), animated: true, scrollPosition: .left)
            DispatchQueue.main.async {
                self.dateCollectionView.reloadData()
            }
        }
    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        
        let sortedDates = model.groupedTasksByDeadline.keys.sorted()
        let date = sortedDates[indexPath.section]
        
        if let task = model.groupedTasksByDeadline[date]?[indexPath.row] {
            config.textProperties.numberOfLines = 3
            config.text = task.text
            if task.isDone {
                let attributedString = NSMutableAttributedString(string: config.text ?? "")
                attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
                config.attributedText = attributedString
                config.textProperties.color = .gray
            }
        }
        
        cell.contentConfiguration = config
        return cell
    }
}
