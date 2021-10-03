import UIKit

final class DropdownPicker: UIView {
    
    enum LayoutMetrics {
        static let margin: CGFloat = 15
    }
    
    enum State {
        case opened
        case closed
    }
    
    private var currentState: State = .closed {
        didSet {
            dataSource?.stateDidChange()
        }
    }
    private var currentSelectedOption: DropdownOption?
    
    weak var dataSource: DropdownDataSource?
    
    let selectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Selecionar"
        label.font = UIFont(name: "Montserrat-Regular", size: 14)
        label.textColor = .washdColors.hintText
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let chevron: UIImageView = {
        let chevron = UIImageView()
        chevron.image = UIImage(systemName: "chevron.down")
        chevron.isUserInteractionEnabled = true
        
        return chevron
    }()
    
    let headerStackView: UIStackView = {
        let header = UIStackView()
        header.axis = .horizontal
        header.distribution = .fill
        header.translatesAutoresizingMaskIntoConstraints = false
        header.isUserInteractionEnabled = true
        header.setContentHuggingPriority(.required, for: .horizontal)
        return header
    }()
    
    lazy var optionsTableView: UITableView = {
        let view = SelfSizingTableView()
        
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(headerStackView)
        self.addSubview(optionsTableView)
        headerStackView.addArrangedSubview(selectionLabel)
        headerStackView.addArrangedSubview(chevron)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: LayoutMetrics.margin
            ),
            headerStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: LayoutMetrics.margin
            ),
            headerStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -LayoutMetrics.margin
            ),
            optionsTableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: LayoutMetrics.margin),
            optionsTableView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -LayoutMetrics.margin),
            optionsTableView.topAnchor.constraint(
                equalTo: headerStackView.bottomAnchor,
                constant: 0),
            optionsTableView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -LayoutMetrics.margin),
        ])
        
        chevron.layout(using: [
            chevron.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureAdditionalSettings() {
        backgroundColor = .washdColors.lightGray
        layer.cornerRadius = 10
        headerStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleToggleMode)))
    }
    
    @objc
    private func handleToggleMode() {
        if currentState == .closed {
            render(state: .opened)
        } else {
            render(state: .closed)
        }
    }
    
    private func render(state: State) {
        currentState = state
        let targetMatrix: CGAffineTransform = state == .closed ?
            .identity :
            .identity.rotated(by: -.pi)
        UIView.animate(withDuration: 0.3) {
            self.chevron.transform = targetMatrix
            self.optionsTableView.reloadData()
        }
        
        if let currentOption = currentSelectedOption {
            selectionLabel.text = currentOption.name
        } else {
            selectionLabel.text = "Selecionar"
        }
        
//        selectionLabel.alpha = currentState == .opened ? 0 : 1
    }
}

extension DropdownPicker: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentState == .opened, let dataSource = dataSource {
            return dataSource.numberOfOptions(self)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else {
            return .init()
        }
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "OptionCell",
                for: indexPath) as? OptionCell
        else {
            return .init()
        }
        let currentOption = dataSource.option(self, at: indexPath)
        cell.configure(using: currentOption)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = dataSource?.option(self, at: indexPath)
        currentSelectedOption = option
        render(state: .closed)
    }
}

extension UIScrollView {

    func resizeScrollViewContentSize() {
        let contentRect: CGRect = subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        contentSize = contentRect.size
    }

}
