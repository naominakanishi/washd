import UIKit

final class LearningButton: UIView {
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "learning-button-bg")
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
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    var callback: (() -> Void)?
    
    init(image: String, label: String) {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        shadowAndBorderSettings()
        buttonImage.image = UIImage(named: image)
        buttonLabel.text = label
        addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleTap)))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shadowAndBorderSettings() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 7.0
        self.layer.masksToBounds =  false
        self.clipsToBounds = true
    }
    
    func addSubviews() {
        self.addSubview(backgroundImage)
        self.addSubview(buttonImage)
        self.addSubview(buttonLabel)
    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 95/368),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo:leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        buttonImage.layout(using: [
            buttonImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            buttonImage.heightAnchor.constraint(equalToConstant: 65),
            buttonImage.widthAnchor.constraint(equalTo: buttonImage.heightAnchor),
            
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
       
        buttonLabel.layout(using: [
            buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonLabel.leadingAnchor.constraint(equalTo:buttonImage.trailingAnchor, constant: 24),
            buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
    
    @objc
    private func handleTap() {
        callback?()
    }
}
