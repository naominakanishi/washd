import UIKit

protocol ClothingCell: UICollectionViewCell {
    func configure(using clothing: Clothing)
}

final class WashingCell: UICollectionViewCell, ClothingCell {
    
    private var clothing: Clothing?
    private var currentItemCount = 0
    private var pickerLeadingConstraint: NSLayoutConstraint?
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let containerView = UIView()
    
    
    let nameBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.regular, 11).uiFont
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let addToBasketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didAdd), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    let removeFromBasketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.addTarget(self, action: #selector(didRemove), for: .touchUpInside)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    let countLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.semiBold, 10).uiFont
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    let itemPickingStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        
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
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameBackground)
        containerView.addSubview(nameLabel)
        containerView.addSubview(itemPickingStackView)
        itemPickingStackView.addArrangedSubviews(
            removeFromBasketButton,
            countLabel,
            addToBasketButton
        )
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
        
        photoImageView.layout(using: [
            photoImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor),
            photoImageView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
        ])
        
        nameBackground.layout(using: [
            nameBackground.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            nameBackground.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            nameBackground.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            nameBackground.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        nameLabel.layout(using: [
            nameLabel.widthAnchor.constraint(equalTo: nameBackground.widthAnchor, multiplier: 0.9),
            nameLabel.centerXAnchor.constraint(equalTo: nameBackground.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameBackground.centerYAnchor)
        ])
        
        itemPickingStackView.layout(using: [
            itemPickingStackView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 10),
            itemPickingStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -10),
            itemPickingStackView.heightAnchor.constraint(
                equalTo: containerView.heightAnchor,
                multiplier: 0.17),
        ])
        
        addToBasketButton.layout(using: [
            addToBasketButton.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 1/3.5),
            addToBasketButton.heightAnchor.constraint(
                equalTo: addToBasketButton.widthAnchor)
        ])
        
        removeFromBasketButton.layout(using: [
            removeFromBasketButton.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 1/3.5),
            removeFromBasketButton.heightAnchor.constraint(
                equalTo: removeFromBasketButton.widthAnchor,
                constant: 38 / 47)
        ])
        
        pickerLeadingConstraint = itemPickingStackView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 10)
    }
    
    func configure(using clothing: Clothing) {
        self.clothing = clothing
        nameLabel.text = clothing.name
        photoImageView.image = UIImage(fileNamed: clothing.image)
    }
    
    @objc func didAdd() {
        currentItemCount += 1
        renderPickerState()
        if let clothing = clothing {
            BasketDatabase.shared.add(clothing: clothing)
        }
    }
    
    @objc func didRemove() {
        if let clothing = clothing {
            BasketDatabase.shared.remove(clothing: clothing)
        }
        guard currentItemCount > 0 else { return }
        currentItemCount -= 1
        renderPickerState()
    }
    
    func renderPickerState() {
        let shouldPresentPicker = currentItemCount <= 0
        countLabel.text = "\(currentItemCount)"
        pickerLeadingConstraint?.isActive = !shouldPresentPicker
        UIView.animate(withDuration: 0.1) {
            self.countLabel.isHidden = shouldPresentPicker
            self.removeFromBasketButton.isHidden = shouldPresentPicker
            self.removeFromBasketButton.setImage(
                .init(systemName: self.currentItemCount > 1 ? "minus" : "trash"),
                for: .normal)
            self.layoutIfNeeded()
        }
    }
}

extension UIImage {
    convenience init?(data: Data?) {
        guard let data = data else { return nil }
        self.init(data: data)
    }
}
