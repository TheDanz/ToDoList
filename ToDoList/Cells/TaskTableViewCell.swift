import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static var identifier = "TaskTableViewCell"
    
    lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.backgroundColor = .none
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(CustomColor.backDarkSecondary) : UIColor(CustomColor.backLightSecondary)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryView)
        setupTitleLabelConstraints()
        setupCategoryViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func makeСornersRoundedAtTop() {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func makeСornersRoundedAtBottom() {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func makeСornersRoundedAtTopAndBootom() {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func removeCornerRounding() {
        layer.mask = nil
    }

    
    private func setupTitleLabelConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: -20).isActive = true
    }
    
    private func setupCategoryViewConstraints() {
        categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        categoryView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        categoryView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        categoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
