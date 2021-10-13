import UIKit

final class AreaPicker: UIView {
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.montserrat(.regular, 14).uiFont
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let tapAction: () -> Void
    
    init(image: UIImage?, title: String, text: String, tapAction: @escaping () -> Void) {
        self.tapAction = tapAction
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        
        imageView.image = image
        descriptionLabel.text = text
        titleLabel.text = title
        contentView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        addSubviews(
            contentView,
            titleLabel)
        contentView.addSubviews(contentStackView)
        contentStackView.addArrangedSubviews(imageView, descriptionLabel)
    }
    
    func constraintSubviews() {
        
        titleLabel.layout(using: [
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            )
        ])
        
        contentView.layout(using: [
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            contentView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 24
            )
        ])

        contentStackView.layout(using: [
            contentStackView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            contentStackView.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            contentStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16),
            contentStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16),
        ])
    
        imageView.layout(using: [
            imageView.widthAnchor.constraint(
                equalToConstant: 48
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: 48
            ),
        ])
    }
    
    func renderDoneState(message: String) {
        imageView.image = .strokedCheckmark
        descriptionLabel.text = message
        imageView.tintColor = .washdColors.unitedNationsBlue
    }
    
    @objc
    private func handleTap() {
        tapAction()
    }
}
