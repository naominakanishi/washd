import UIKit

final class HomeView: UIView {
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        return view
    }()
    
    private lazy var headerLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "washd-logo")
        return view
    }()
    
    private lazy var welcomeMessage: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.bold, 28).uiFont
        view.textColor = .washdColors.text
        view.textAlignment = .center
        view.text = "Bem vinda"
        return view
    }()
    
    private lazy var clothesAmount: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.regular, 18).uiFont
        view.textColor = .washdColors.text
        view.textAlignment = .center
        view.text = "Você já tem x peças cadastradas"
        return view
    }()
    
    private lazy var registerButton: TopButton = {
        let view = TopButton(image: "add-piece", label: "cadastrar peça")
        
        return view
    }()
    
    private lazy var closetButton: TopButton = {
        let view = TopButton(image: "my-closet", label: "minhas roupas")
        return view
    }()
    
    private lazy var washButton: TopButton = {
        let view = TopButton(image: "wash-clothes", label: "lavar roupas")
        return view
    }()
    
    private lazy var topButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(backgroundImage)
        self.addSubview(headerLogo)
        self.addSubview(welcomeMessage)
        self.addSubview(clothesAmount)
        self.addSubview(topButtonsStackView)
        
        topButtonsStackView.addArrangedSubview(registerButton)
        topButtonsStackView.addArrangedSubview(closetButton)
        topButtonsStackView.addArrangedSubview(washButton)

    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        headerLogo.layout(using: [
            headerLogo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerLogo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            headerLogo.heightAnchor.constraint(equalTo: headerLogo.widthAnchor, multiplier: 145 / 457.25),
            headerLogo.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        welcomeMessage.layout(using: [
            welcomeMessage.topAnchor.constraint(equalTo: headerLogo.bottomAnchor, constant: 40),
            welcomeMessage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            welcomeMessage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        clothesAmount.layout(using: [
            clothesAmount.topAnchor.constraint(equalTo: welcomeMessage.bottomAnchor, constant: 15),
            clothesAmount.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            clothesAmount.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        topButtonsStackView.layout(using: [
            topButtonsStackView.topAnchor.constraint(equalTo: clothesAmount.bottomAnchor, constant: 15),
            topButtonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            topButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topButtonsStackView.heightAnchor.constraint(equalToConstant: 130)
           
        ])
   
    }
}
