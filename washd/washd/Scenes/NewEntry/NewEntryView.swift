import UIKit

final class NewEntryView: UIView, UIScrollViewDelegate  {
    
    struct Actions {
        let openIconPicker: () -> Void
        let openScanner: () -> Void
        let doneAction: () -> Void
        let openCamera: () -> Void
    }
    
    enum LayoutMetrics {
        static let horizontalMargin: CGFloat = 30
        static let interPromptSpacing: CGFloat = 30
        static let innerPromptSpacing: CGFloat = 10
    }
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add-new-background")
        return view
    }()
    
    private lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isDirectionalLockEnabled = true
        view.delegate = self
        view.isDirectionalLockEnabled = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo Registro"
        label.font = .appFont.montserrat(.bold, 34).uiFont
        return label
    }()
    
    private lazy var namePrompt: UILabel = {
        let label = UILabel()
        label.text = "Dê um nome para esse item:"
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private lazy var nameEntryTextField: UITextField = {
        let view = TextField(inset: 15)
        view.backgroundColor = .white
        view.attributedPlaceholder = .init(string: "Descrição básica da peça (ex.: camiseta branca)", attributes: [
            .font: UIFont.appFont.montserrat(.light, 14).uiFont,
            .foregroundColor: UIColor.washdColors.hintText
        ])
        view.font = .appFont.montserrat(.regular, 14).uiFont
        view.layer.cornerRadius = 10
        view.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        return view
    }()
    
    var name: String? { nameEntryTextField.text }
    
    private lazy var categoryPrompt: UILabel = {
        let label = UILabel()
        label.text = "A qual categoria ela pertence?"
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private lazy var categoriesDropdown: DropdownPicker = {
        let view = DropdownPicker()
        view.dataSource = self
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    var selectedType: ClothingType? {
        guard let selected = categoriesDropdown.currentSelectedIndex
        else { return nil }
        return ClothingType.allCases[selected]
    }
    
    private lazy var colorsPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Qual a cor dessa roupa?"
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private lazy var colorsDropdown: DropdownPicker = {
        let view = DropdownPicker()
        view.dataSource = self
        return view
    }()
    
    var selectedColor: ClothingColor? {
        guard let selected = colorsDropdown.currentSelectedIndex
        else { return nil }
        return ClothingColor.allCases[selected]
    }
    
    private lazy var iconsPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Quais os ícones em sua etiqueta?"
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private lazy var openIconPickerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(openIconPicker)
        ))
        
        return view
    }()
    
    private lazy var iconPickerStackView: UIStackView = {
        let view = UIStackView()
        view.layer.cornerRadius = 10
        view.axis = .horizontal
        view.addArrangedSubview(selectedLabel)
        view.addArrangedSubview(chevronImage)
        view.backgroundColor = .white
        view.spacing = 8
        return view
    }()
    
    private lazy var chevronImage = UIImageView(image: .init(systemName: "chevron.right"))
    
    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Selecione"
        label.font = .appFont.montserrat(.light, 14).uiFont
        label.textColor = .washdColors.hintText
        return label
    }()
    
    private lazy var photoPicker = AreaPicker(
        image: .init(systemName: "camera"),
        title: "Escolha uma foto",
        text: "Toque para escolher uma imagem",
        tapAction: { self.actions?.openCamera()}
    )
    
    private lazy var doneButton: UIButton = {
        let view = UIButton()
        view.configuration = .filled()
        view.configuration?.title = "cadastrar peça"
        view.configuration?.baseForegroundColor = .white
        view.configuration?.baseBackgroundColor = .washdColors.vividSkyBlue
        view.configuration?.cornerStyle = .medium
        view.configuration?.buttonSize = .large
        view.configuration?.titleTextAttributesTransformer = .init {
            var outcoming = $0
            outcoming.font = .appFont.montserrat(.bold, 18).uiFont
            return outcoming
        }
        view.addTarget(self, action: #selector(handleDone), for: .touchUpInside)

        return view
    }()
    
   
    
    var actions: Actions?
    var selectedTags: [WashingTag] = [] {
        didSet {
            iconPickerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            if selectedTags.isEmpty {
                iconPickerStackView.addArrangedSubview(selectedLabel)
            } else {
                selectedTags.forEach {
                    let imageView = UIImageView(image: .init(named: $0.imageNames.first!))
                    iconPickerStackView.addArrangedSubview(imageView)
                    imageView.layout(using: [
                        imageView.widthAnchor.constraint(equalToConstant: 16),
                        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
                    ])
                    imageView.contentMode = .scaleAspectFit
                }
                iconPickerStackView.addArrangedSubview(.init())
            }
            
            iconPickerStackView.addArrangedSubview(chevronImage)
        }
    }
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupKeyboardDismissGesture),
            name: UIApplication.keyboardDidShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeKeyboardDismissGesture),
            name: UIApplication.keyboardDidHideNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
     
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        addSubviews(backgroundImage,
                    titleLabel,
                    contentScrollView,
                    doneButton
        )
        contentScrollView.addSubviews(
            namePrompt,
            nameEntryTextField,
            categoryPrompt,
            categoriesDropdown,
            colorsPromptLabel,
            colorsDropdown,
            iconsPromptLabel,
            openIconPickerView,
            photoPicker
        )
        openIconPickerView.addSubview(iconPickerStackView)
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .washdColors.background
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endEditing(true)
    }
    
    func renderPickedImage() {
        photoPicker.renderDoneState(message: "Foto importada com sucesso!")
    }
}

@objc
private extension NewEntryView {
    
    func handleDone() {
        actions?.doneAction()
    }
    
    func openIconPicker() {
        actions?.openIconPicker()
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
    
    func setupKeyboardDismissGesture() {
        addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard)
        ))
    }
    
    func removeKeyboardDismissGesture() {
        gestureRecognizers?
            .filter { $0 is UITapGestureRecognizer }
            .forEach(removeGestureRecognizer)
    }
}

extension NewEntryView: DropdownDataSource {
    func numberOfOptions(_ dropdown: DropdownPicker) -> Int {
        if dropdown == categoriesDropdown {
            return ClothingType.allCases.count
        }
        
        return ClothingColor.allCases.count
    }
    
    func option(_ dropdown: DropdownPicker, at index: IndexPath) -> DropdownOption {
        let name: String
        
        if dropdown == categoriesDropdown {
            let item: ClothingType = .allCases[index.row]
            switch item {
            case .top:
                name = "Top"
            case .bottom:
                name = "Bottom"
            case .dresses:
                name = "Peça única"
            case .underwear:
                name = "Roupa íntima"
            case .sleepwear:
                name = "Pijama"
            case .fitness:
                name = "Fitness"
            }
        } else {
            let item: ClothingColor = .allCases[index.row]
            switch item {
            case .white:
                name = "Branca"
            case .black:
                name = "Preta"
            case .lightColors:
                name = "Colorida clara"
            case .darkColors:
                name = "Colorida escura"
            }
        }
        
        return .init(name: name)
    }
    
    func stateDidChange() {}
}

// MARK: - Constraints
extension NewEntryView {
    func constraintSubviews() {
        
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        titleLabel.layout(using: [
            titleLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            titleLabel.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            titleLabel.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        
        contentScrollView.layout(using: [
            contentScrollView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: LayoutMetrics.interPromptSpacing),
            contentScrollView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.9
            ),
            contentScrollView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            contentScrollView.bottomAnchor.constraint(
                equalTo: doneButton.topAnchor,
                constant: -8
            )
        ])
        
        doneButton.layout(using: [
            doneButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: LayoutMetrics.horizontalMargin
            ),
            doneButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -LayoutMetrics.horizontalMargin
            ),
            doneButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -LayoutMetrics.horizontalMargin
            ),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        photoPicker.layout(using: [
            photoPicker.topAnchor.constraint(
                equalTo: contentScrollView.topAnchor
            ),
            photoPicker.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            photoPicker.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            ),
        ])
        
        namePrompt.layout(using: [
            namePrompt.topAnchor.constraint(
                equalTo: photoPicker.bottomAnchor,
                constant: LayoutMetrics.interPromptSpacing
            ),
            namePrompt.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            namePrompt.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        
        nameEntryTextField.layout(using: [
            nameEntryTextField.topAnchor.constraint(
                equalTo: namePrompt.bottomAnchor,
                constant: LayoutMetrics.innerPromptSpacing
            ),
            nameEntryTextField.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            nameEntryTextField.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        
        categoryPrompt.layout(using: [
            categoryPrompt.topAnchor.constraint(
                equalTo: nameEntryTextField.bottomAnchor,
                constant: LayoutMetrics.interPromptSpacing
            ),
            categoryPrompt.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            categoryPrompt.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        categoriesDropdown.layout(using: [
            categoriesDropdown.topAnchor.constraint(
                equalTo: categoryPrompt.bottomAnchor,
                constant: LayoutMetrics.innerPromptSpacing
            ),
            categoriesDropdown.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            categoriesDropdown.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        
        colorsPromptLabel.layout(using: [
            colorsPromptLabel.topAnchor.constraint(
                equalTo: categoriesDropdown.bottomAnchor,
                constant: LayoutMetrics.interPromptSpacing
            ),
            colorsPromptLabel.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            colorsPromptLabel.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            )
        ])
        colorsDropdown.layout(using: [
            colorsDropdown.topAnchor.constraint(
                equalTo: colorsPromptLabel.bottomAnchor,
                constant: LayoutMetrics.innerPromptSpacing
            ),
            colorsDropdown.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            colorsDropdown.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            ),
        ])
        
        iconsPromptLabel.layout(using: [
            iconsPromptLabel.topAnchor.constraint(
                equalTo: colorsDropdown.bottomAnchor,
                constant: LayoutMetrics.interPromptSpacing
            ),
            iconsPromptLabel.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            iconsPromptLabel.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            ),
        ])
        
        openIconPickerView.layout(using: [
            openIconPickerView.topAnchor.constraint(
                equalTo: iconsPromptLabel.bottomAnchor,
                constant: LayoutMetrics.innerPromptSpacing
            ),
            openIconPickerView.widthAnchor.constraint(
                equalTo: contentScrollView.widthAnchor
            ),
            openIconPickerView.centerXAnchor.constraint(
                equalTo: contentScrollView.centerXAnchor
            ),
            
            openIconPickerView.widthAnchor.constraint(equalTo: colorsDropdown.widthAnchor
            ),
            openIconPickerView.heightAnchor.constraint(equalTo: colorsDropdown.heightAnchor
            ),
        ])
        
        iconPickerStackView.layout(using: [
            iconPickerStackView.topAnchor.constraint(
                equalTo: openIconPickerView.topAnchor,
                constant: 16
            ),
            iconPickerStackView.leadingAnchor.constraint(
                equalTo: openIconPickerView.leadingAnchor,
                constant: 8
            ),
            iconPickerStackView.trailingAnchor.constraint(
                equalTo: openIconPickerView.trailingAnchor,
                constant: -16
            ),
            
            iconPickerStackView.bottomAnchor.constraint(
                equalTo: contentScrollView.bottomAnchor,
                constant: -LayoutMetrics.interPromptSpacing
            ),
        ])
    }
}
