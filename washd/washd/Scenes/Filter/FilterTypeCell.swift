import UIKit

final class FilterTypeCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.semiBold, 14).uiFont
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func constraintSubviews() {
        titleLabel.layout {
            $0.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12)
            $0.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12)
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12)
            $0.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12)
        }
    }
    
    func configure(using title: String) {
        titleLabel.text = title
        layer.cornerRadius = 10
        updateSelection()
    }
    
    private func updateSelection() {
        if isSelected {
            backgroundColor = .washdColors.vividSkyBlue
            titleLabel.textColor = .white
        } else {
            backgroundColor = .white
            titleLabel.textColor = .washdColors.text
        }
    }
}
