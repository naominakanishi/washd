import UIKit

final class ClothesCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override var alignmentRectInsets: UIEdgeInsets {
        .init(top: 100, left: 100, bottom: -100, right: -100)
    }
    
    let containerView = UIView()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.bold, 18).uiFont
        view.textColor = .black
        view.textAlignment = .left
        return view
    }()
    
    let clothingColor: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let iconsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    let photoMargin: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        addSubviews()
        constraintSubviews()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(clothingColor)
        containerView.addSubview(iconsStackView)
    }
    
    private func constraintSubviews() {
        
        containerView.layout(using: [
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10),
        ])
        
        photoImageView.layout(using: [
            photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: photoMargin),
            photoImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -photoMargin),
            photoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: photoMargin),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        nameLabel.layout(using: [
            nameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: photoMargin),
        ])
        
        clothingColor.layout(using: [
            clothingColor.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -photoMargin),
            clothingColor.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: photoMargin),
            clothingColor.widthAnchor.constraint(equalToConstant: 24),
            clothingColor.heightAnchor.constraint(equalTo: clothingColor.widthAnchor),
        ])
        
        iconsStackView.layout(using: [
            iconsStackView.topAnchor.constraint(
                equalTo: clothingColor.topAnchor),
            iconsStackView.bottomAnchor.constraint(
                equalTo: clothingColor.bottomAnchor),
            iconsStackView.leadingAnchor.constraint(
                equalTo: clothingColor.trailingAnchor,
                constant: 8),
        ])
    }
    
    func configure(using clothing: Clothing) {
        nameLabel.text = clothing.name
        photoImageView.image = UIImage(data: clothing.image) ?? .init(named: clothing.type.imageName)
        clothingColor.image = UIImage(named: clothing.color.rawValue)
        
        clothing.washingTags.forEach {
            let imageView = UIImageView(image: .init(named: $0.imageNames.first!))
            iconsStackView.addArrangedSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.layout(using: [
                imageView.widthAnchor.constraint(
                    equalTo: imageView.heightAnchor
                )
            ])
        }
    }
}

extension UIImage {
    convenience init?(data: Data?) {
        guard let data = data else { return nil }
        self.init(data: data)
    }
}
