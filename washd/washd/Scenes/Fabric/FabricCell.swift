import UIKit

final class FabricCell: UICollectionViewCell {
    
    private var fabric: Fabric?
    private var currentItemCount = 0
    private var pickerLeadingConstraint: NSLayoutConstraint?
    
    let fabricImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    let containerView = UIView()
    
    
    let nameBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.regular, 11).uiFont
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let photoMargin: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        addSubviews()
        constraintSubviews()
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(fabricImageView)
        containerView.addSubview(nameBackground)
        containerView.addSubview(nameLabel)
    }
    
    private func constraintSubviews() {
        
        containerView.layout(using: [
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 0),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 0),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -0),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -0),
        ])
        
        fabricImageView.layout(using: [
            fabricImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor),
            fabricImageView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            fabricImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            fabricImageView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
        ])
        
        nameBackground.layout(using: [
            nameBackground.bottomAnchor.constraint(equalTo: fabricImageView.bottomAnchor),
            nameBackground.leadingAnchor.constraint(equalTo: fabricImageView.leadingAnchor),
            nameBackground.trailingAnchor.constraint(equalTo: fabricImageView.trailingAnchor),
            nameBackground.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        nameLabel.layout(using: [
            nameLabel.widthAnchor.constraint(equalTo: nameBackground.widthAnchor, multiplier: 0.9),
            nameLabel.centerXAnchor.constraint(equalTo: nameBackground.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameBackground.centerYAnchor)
        ])
    }
    
    func configure(using fabric: Fabric) {
        self.fabric = fabric
        nameLabel.text = fabric.name
        fabricImageView.image = fabric.image
    }
}
