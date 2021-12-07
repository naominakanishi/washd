import UIKit

final class TopButton: UIView {
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "top-buttons-bg")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var buttonImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var buttonLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.appFont.montserrat(.semiBold, 12).uiFont
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private lazy var textBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        return view
    }()
    
    init(image: String, label: String) {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 7.0
        self.layer.masksToBounds =  false
        self.clipsToBounds = true
        buttonImage.image = UIImage(named: image)
        buttonLabel.text = label
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(backgroundImage)
        self.addSubview(buttonImage)
        self.addSubview(textBackground)
        self.addSubview(buttonLabel)
    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo:leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        buttonImage.layout(using: [
            buttonImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            buttonImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            buttonImage.heightAnchor.constraint(equalTo: buttonImage.widthAnchor),
            buttonImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        textBackground.layout(using: [
            textBackground.topAnchor.constraint(equalTo: buttonImage.bottomAnchor, constant: 15),
            textBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            textBackground.leadingAnchor.constraint(equalTo:leadingAnchor),
            textBackground.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        buttonLabel.layout(using: [
            buttonLabel.topAnchor.constraint(equalTo: buttonImage.bottomAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: textBackground.centerYAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo:leadingAnchor),
            buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
}
