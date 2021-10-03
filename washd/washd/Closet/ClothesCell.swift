import UIKit

final class ClothesCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.bold, 18).uiFont
        view.textColor = .black
        view.textAlignment = .left
        return view
    }()
    
    let photoMargin: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        constraintSubviews()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
    }
    
    func constraintSubviews() {
        photoImageView.layout(using: [
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: photoMargin),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -photoMargin),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: photoMargin),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        nameLabel.layout(using: [
            nameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: photoMargin),
            
        ])
    }
}
