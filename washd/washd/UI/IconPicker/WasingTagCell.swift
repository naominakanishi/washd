import UIKit

final class WasingTagCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    private lazy var symbolLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.light, 9).uiFont
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    
    struct Model {
        let image: UIImage?
        let name: String?
    }
    
    
    func configure(using model: Model) {
        imageView.image = model.image
        symbolLabel.text = model.name
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        contentView.addSubview(symbolLabel)
        imageView.layout {
            $0.topAnchor.constraint(
                equalTo: contentView.topAnchor
            )
            $0.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            )
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            )
            $0.widthAnchor.constraint(equalToConstant: 50)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
        }
        
        symbolLabel.layout {
            $0.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5)
            $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

