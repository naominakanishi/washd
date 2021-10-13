import UIKit

final class HeaderCell: UICollectionReusableView {
    let titleLabel = UILabel()
    let chevronImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel,
        chevronImageView)
        titleLabel.layout(using: [
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 30
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: chevronImageView.leadingAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
        ])
        
        chevronImageView.layout(using: [
            chevronImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            chevronImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30
            ),
            chevronImageView.heightAnchor.constraint(equalTo: chevronImageView.widthAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        chevronImageView.image = .init(systemName: "chevron.up")
        chevronImageView.tintColor = .black
        titleLabel.font = .appFont.montserrat(.semiBold, 22).uiFont
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var toggleSection: (() -> Void)?
    
    @objc func handleTap() {
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.chevronImageView.transform = self.chevronImageView.transform == .identity ?
                .identity.rotated(by: .pi) :
                .identity
        } completion: { _ in }
        
        self.toggleSection?()
    }
}

