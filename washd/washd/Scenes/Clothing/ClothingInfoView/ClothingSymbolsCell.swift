import UIKit

class ClothingSymbolsCell: UITableViewCell {
    
  //  private var clothing: Clothing
    
    struct Model {
        let tags: [WashingTag]
    }
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var symbolsStackView: UIStackView = {
        let view = UIStackView()
        view.layer.cornerRadius = 10
        view.axis = .horizontal
        view.backgroundColor = .clear
        view.spacing = 8
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(contentsView)
        contentsView.addSubview(symbolsStackView)
    }
    
    func constraintSubviews() {
        
        contentsView.layout {
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        }
        
        symbolsStackView.layout {
            $0.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 5)
            $0.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -5)
            $0.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 15)
            $0.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -5)
        }
    }

    func configure(using model: Model) {
        model.tags.forEach {
            let imageView = UIImageView(image: .init(named: $0.imageNames.first!))
            symbolsStackView.addArrangedSubview(imageView)
            imageView.layout(using: [
                imageView.widthAnchor.constraint(equalToConstant: 16),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ])
            imageView.contentMode = .scaleAspectFit
        }
    }
}

