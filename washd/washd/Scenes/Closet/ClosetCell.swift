import UIKit

final class ClosetCell: UICollectionViewCell, ClothingCell {
    
    private var clothing: Clothing?
    private var currentItemCount = 0
    private var pickerLeadingConstraint: NSLayoutConstraint?
    
    let photoImageView: UIImageView = {
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
        containerView.addSubview(photoImageView)
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
    }
    
    func configure(using clothing: Clothing) {
        self.clothing = clothing
        nameLabel.text = clothing.name
        photoImageView.image = UIImage(fileNamed: clothing.image)
    }
    
//    @objc func didAdd() {
//        currentItemCount += 1
//        renderPickerState()
//        if let clothing = clothing {
//            BasketDatabase.shared.add(clothing: clothing)
//        }
//    }
//
//    @objc func didRemove() {
//        if let clothing = clothing {
//            BasketDatabase.shared.remove(clothing: clothing)
//        }
//        guard currentItemCount > 0 else { return }
//        currentItemCount -= 1
//        renderPickerState()
//    }
//
//    func renderPickerState() {
//        let shouldPresentPicker = currentItemCount <= 0
//        countLabel.text = "\(currentItemCount)"
//        pickerLeadingConstraint?.isActive = !shouldPresentPicker
//        UIView.animate(withDuration: 0.1) {
//            self.countLabel.isHidden = shouldPresentPicker
//            self.removeFromBasketButton.isHidden = shouldPresentPicker
//            self.removeFromBasketButton.setImage(
//                .init(systemName: self.currentItemCount > 1 ? "minus" : "trash"),
//                for: .normal)
//            self.layoutIfNeeded()
//        }
//    }
}

//extension UIImage {
//    convenience init?(data: Data?) {
//        guard let data = data else { return nil }
//        self.init(data: data)
//    }
//}
