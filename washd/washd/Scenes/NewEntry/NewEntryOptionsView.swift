import UIKit

final class NewEntryOptionsView: UIView {
    
    struct Actions {
        let readNFCTapped: () -> Void
        let readQRCodeTapped: () -> Void
        let manualInputTapped: () -> Void
    }
    
    var actions: Actions?
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add-new-background")
        return view
    }()
    
    private lazy var optionsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 15
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.regular, 22).uiFont
        view.text = "Como você gostaria de realizar\no cadastro?"
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var readTagButton: UIButton = {
        let view = UIButton()
        view.configuration = .filled()
        view.configuration?.title = "leitura com tag NFC"
        view.configuration?.baseForegroundColor = .white
        view.configuration?.baseBackgroundColor = .washdColors.vividSkyBlue
        view.configuration?.cornerStyle = .medium
        view.configuration?.buttonSize = .large
        view.configuration?.titleTextAttributesTransformer = .init {
            var outcoming = $0
            outcoming.font = .appFont.montserrat(.bold, 18).uiFont
            return outcoming
        }
        view.addTarget(self, action: #selector(handleSelectedOption), for: .touchUpInside)
        return view
    }()
    
    private lazy var readQRCodeButton: UIButton = {
        let view = UIButton()
        view.configuration = .filled()
        view.configuration?.title = "leitura com QR Code"
        view.configuration?.baseForegroundColor = .white
        view.configuration?.baseBackgroundColor = .washdColors.vividSkyBlue
        view.configuration?.cornerStyle = .medium
        view.configuration?.buttonSize = .large
        view.configuration?.titleTextAttributesTransformer = .init {
            var outcoming = $0
            outcoming.font = .appFont.montserrat(.bold, 18).uiFont
            return outcoming
        }
        view.addTarget(self, action: #selector(handleSelectedOption), for: .touchUpInside)
        return view
    }()
    
    private lazy var manualReadButton: UIButton = {
        let view = UIButton()
        view.configuration = .filled()
        view.configuration?.title = "cadastro manual"
        view.configuration?.baseForegroundColor = .white
        view.configuration?.baseBackgroundColor = .washdColors.vividSkyBlue
        view.configuration?.cornerStyle = .medium
        view.configuration?.buttonSize = .large
        view.configuration?.titleTextAttributesTransformer = .init {
            var outcoming = $0
            outcoming.font = .appFont.montserrat(.bold, 18).uiFont
            return outcoming
        }
        view.addTarget(self, action: #selector(handleSelectedOption), for: .touchUpInside)
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
        addSubview(optionsStackView)
        addSubview(subtitleLabel)
        optionsStackView.addArrangedSubviews(readTagButton,
                                             readQRCodeButton,
                                             manualReadButton)
    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        optionsStackView.layout {
            $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        }
        subtitleLabel.layout {
            $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        }
    }
    
    @objc
    private func handleSelectedOption(_ sender: Any?) {
        guard let sender = sender as? UIButton else { return }
        switch sender {
        case readTagButton:
            actions?.readNFCTapped()
        case readQRCodeButton:
            actions?.readQRCodeTapped()
        case manualReadButton:
            actions?.manualInputTapped()
        default: break
        }
    }
}
