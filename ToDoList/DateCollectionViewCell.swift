import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "DateCollectionViewCell"
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .gray
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(monthLabel)
        
        setupAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(day: String, month: String) {
        dayLabel.text = day
        monthLabel.text = month
    }
    
    func setupContentViewAsSelected() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.00).cgColor
        contentView.backgroundColor = UIColor(red: 0.84, green: 0.84, blue: 0.79, alpha: 1.00)
    }
    
    func setupContentViewAsUnselected() {
        contentView.layer.cornerRadius = 0
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
        contentView.backgroundColor = nil
    }
    
    private func setupAllConstraints() {
        setupDayLabelConstraints()
        setupMonthLabelConstraints()
    }
    
    private func setupDayLabelConstraints() {
        dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    private func setupMonthLabelConstraints() {
        monthLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}
