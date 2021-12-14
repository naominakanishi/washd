import UIKit

final class UnderstandingSymbolsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SymbolCell.self)
        view.registerAuxiliary(SymbolHeaderView.self)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var allTags: [WashingTag] { TagDatabase.allTags() }
    private var sections: [TagCategory] {
        allTags.map { $0.category }.unique
    }
    private lazy var openSectionFlags: [Bool] = .init(repeating: true, count: sections.count)
    
    func tags(for category: TagCategory) -> [WashingTag] {
        allTags.filter { $0.category == category }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        openSectionFlags[section] ? tags(for: sections[section]).count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SymbolCell.self, at: indexPath)
        let section = sections[indexPath.section]
        let tag = tags(for: section)[indexPath.row]
        cell.configure(using: .init(
            image: UIImage(named: tag.imageNames.first),
            name: tag.name
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(SymbolHeaderView.self)
        let category = sections[section]
        header?.configure(using: .init(title: category.name))
        header?.toggleSection = { [weak self] in
            guard let self = self else { return }
            self.openSectionFlags[section] = !self.openSectionFlags[section]

            let change : ([IndexPath], UITableView.RowAnimation) -> Void = !self.openSectionFlags[section] ?
                tableView.deleteRows :
                tableView.insertRows
            change(self.tags(for: category).indices.map {
                .init(item: $0, section: section)
            }, .bottom)
        }
        return header
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.constraintToSuperview()
    }
}

final class SymbolHeaderView: UITableViewHeaderFooterView {
    struct Model {
        let title: String
    }
    
    
    var toggleSection: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = .init(systemName: "chevron.up")
        view.tintColor = .black
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        constraintSubviews()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
    }
    
    func constraintSubviews() {
        titleLabel.constraintToSuperview()
        chevronImageView.layout {
            $0.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor)
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16)
            $0.widthAnchor.constraint(
                equalToConstant: 16)
            $0.heightAnchor.constraint(
                equalTo: $0.widthAnchor)
        }
    }
    
    func configure(using model: Model) {
        titleLabel.text = model.title
    }
    
    @objc func handleTap() {
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.chevronImageView.transform = self.chevronImageView.transform == .identity ?
                .identity.rotated(by: .pi) :
                .identity
        } completion: { _ in }
        
        self.toggleSection?()
    }
}

final class SymbolCell: UITableViewCell {
    
    struct Model {
        let image: UIImage?
        let name: String
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubviews(iconImageView, descriptionLabel)
    }
    func constraintSubviews() {
        containerView.constraintToSuperview()
        
        iconImageView.layout {
            $0.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 8)
            $0.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 16)
            $0.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -16)
            $0.widthAnchor.constraint(equalToConstant: 60)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
        }
        
        descriptionLabel.layout {
            $0.centerYAnchor.constraint(
                equalTo: iconImageView.centerYAnchor)
            $0.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 8)
            $0.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                         constant: -8)
        }
    }
    
    func configure(using model: Model) {
        iconImageView.image = model.image
        descriptionLabel.text = model.name
    }
}

extension UIImage {
    convenience init?(named: String?) {
        guard let named = named else {
            return nil
        }
        self.init(named: named)
    }
}

extension UIView {
    func constraintToSuperview() {
        guard let superview = superview else {
            return
        }
        layout {
            $0.topAnchor.constraint(equalTo: superview.topAnchor)
            $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        }
    }
}
