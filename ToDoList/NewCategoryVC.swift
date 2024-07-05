import UIKit

class NewCategoryViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    var model: ToDoItemModel
    
    lazy var containerView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var textField = {
        let textField = UITextField()
        textField.placeholder = "Название категории"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var colorPickerButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать цвет", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var colorDisplayView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var confirmButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedColor: UIColor = .white
    
    init(model: ToDoItemModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        colorDisplayView.backgroundColor = selectedColor
        
        colorPickerButton.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(colorPickerButton)
        containerView.addSubview(colorDisplayView)
        containerView.addSubview(confirmButton)
        
        setupAllConstraints()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorDisplayView.backgroundColor = selectedColor
    }
    
    @objc func openColorPicker() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        self.present(colorPickerVC, animated: true, completion: nil)
    }
    
    @objc func confirm() {
        let name = textField.text ?? ""
        if !name.isEmpty {
            let newCategory = TaskCategory(name: name, color: selectedColor)
            model.categories.append(newCategory)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupAllConstraints() {
        setupContainerViewConstraints()
        setupTextFieldConstraints()
        setupColorPickerButtonConstraints()
        setupColorDisplayViewConstraints()
        setupConfirmButtonConstraints()
    }
    
    private func setupContainerViewConstraints() {
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func setupTextFieldConstraints() {
        textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupColorPickerButtonConstraints() {
        colorPickerButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        colorPickerButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    private func setupColorDisplayViewConstraints() {
        colorDisplayView.topAnchor.constraint(equalTo: colorPickerButton.bottomAnchor, constant: 20).isActive = true
        colorDisplayView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorDisplayView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorDisplayView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    private func setupConfirmButtonConstraints() {
        confirmButton.topAnchor.constraint(equalTo: colorDisplayView.bottomAnchor, constant: 20).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
}
