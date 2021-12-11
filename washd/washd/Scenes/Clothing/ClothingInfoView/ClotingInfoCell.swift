import UIKit

class ClothingInfoCell: UITableViewCell {
    
    struct Model {
        let title: String
    }
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.regular, 16).uiFont
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       // contentView.backgroundColor = .clear
        addSubviews()
        constraintSubviews()
        backgroundColor = .clear
      //  configure(using: Wash)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(contentsView)
        contentsView.addSubview(contentLabel)

    }
    
    func constraintSubviews() {
        contentsView.layout {
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        }
        
        contentLabel.layout {
            $0.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 5)
            $0.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -5)
            $0.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 15)
            $0.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -5)
        }
    }

    func configure(using model: Model) {
        contentLabel.text = model.title
    }
}

