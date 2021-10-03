import UIKit

final class NewEntryView: UIView {
    
    struct Actions {
        let openIconPicker: () -> Void
    }
    
    enum LayoutMetrics {
        static let horizontalMargin: CGFloat = 30
        static let interPromptSpacing: CGFloat = 30
        static let innerPromptSpacing: CGFloat = 10
    }
    
    private lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .washdColors.lightGray
        view.attributedPlaceholder = .init(string: "Descrição básica da peça (ex.: camiseta branca)", attributes: [
            .font: UIFont.appFont.montserrat(.light, 14).uiFont,
            .foregroundColor: UIColor.washdColors.hintText
        ])
        view.layer.cornerRadius = 10
        return view
    }()
    
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
    
    private lazy var iconsPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Quais os ícones em sua etiqueta?"
        label.font = .appFont.montserrat(.semiBold, 20).uiFont
        return label
    }()
    
    private lazy var openIconPickerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .washdColors.lightGray
        view.layer.cornerRadius = 10
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(openIconPicker)
        ))
        
        return view
    }()
    
    private lazy var iconPickerStackView: UIStackView = {
        let view = UIStackView()
        let chevron = UIImage(systemName: "chevron.right")
        let label = UILabel()
        
        view.addArrangedSubview(label)
        view.addArrangedSubview(UIImageView(image: chevron))
        
        label.text = "Selecione"
        label.font = .appFont.montserrat(.light, 14).uiFont
        label.textColor = .washdColors.hintText
        
        return view
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .washdColors.unitedNationsBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Criar Item", for: .normal)
        button.titleLabel?.font = .appFont.montserrat(.semiBold, 16).uiFont
        
        return button
    }()
    
    var actions: Actions?
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
     
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        addSubviews(titleLabel,
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
            openIconPickerView
        )
        openIconPickerView.addSubview(iconPickerStackView)
    }
    
    func constraintSubviews() {
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
                equalTo: bottomAnchor
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
        
        namePrompt.layout(using: [
            namePrompt.topAnchor.constraint(
                equalTo: contentScrollView.topAnchor
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
            openIconPickerView.bottomAnchor.constraint(
                equalTo: contentScrollView.bottomAnchor
            )
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
                equalTo: openIconPickerView.bottomAnchor,
                constant: -16
            ),
        ])
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .washdColors.background
    }
    
    @objc private func openIconPicker() {
        actions?.openIconPicker()
    }
}

extension NewEntryView: DropdownDataSource {
    func numberOfOptions(_ dropdown: DropdownPicker) -> Int {
        return 100
    }
    
    func option(_ dropdown: DropdownPicker, at index: IndexPath) -> DropdownOption {
        if dropdown == categoriesDropdown {
            return .init(name: "Igual \(index.row)")
        }
        return .init(name: "Diferente \(index.row)")
    }
    
    func stateDidChange() {}
}
