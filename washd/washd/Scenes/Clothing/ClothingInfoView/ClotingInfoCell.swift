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
        selectionStyle = .none
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
            $0.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        }
        
        contentLabel.layout {
            $0.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16)
            $0.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -16)
            $0.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16)
        }
    }

    func configure(using model: Model) {
        contentLabel.text = model.title
    }
}

