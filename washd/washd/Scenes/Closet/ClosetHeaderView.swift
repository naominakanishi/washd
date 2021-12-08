import UIKit

final class ClosetHeaderView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.semiBold, 22).uiFont
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
        addSubview(titleLabel)
    }
    
    func constraintSubviews() {
        titleLabel.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func configure(using title: String) {
        titleLabel.text = title
    }
}

