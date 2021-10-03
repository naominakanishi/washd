import UIKit
import CoreNFC

final class IconPickerViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ícones"
        label.font = .appFont.montserrat(.bold, 34).uiFont
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .washdColors.unitedNationsBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Pronto", for: .normal)
        button.titleLabel?.font = .appFont.montserrat(.semiBold, 16).uiFont
        
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .init(width: 100, height: 48)
        layout.sectionInset = .init(
            top: 20,
            left: 40,
            bottom: 0,
            right: 40)
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)

        view.register(
            HeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderCell")
        view.register(WasingTagCell.self, forCellWithReuseIdentifier: "WasingTagCell")
        view.delegate = manager
        view.dataSource = manager
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let manager = IconPickerCollectionViewManager()
    
    override func loadView() {
        self.view = .init()
        view.backgroundColor = .washdColors.background
    }
    
    override func viewDidLoad() {
        addSubviews()
        constraintSubviews()
    }
    
    func addSubviews() {
        view.addSubviews(titleLabel,
        collectionView,
        doneButton)
    }
    
    func constraintSubviews() {
        titleLabel.layout(using: [
            titleLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 24),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30),
        ])
        
        collectionView.layout(using: [
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 24),
        ])
        
        doneButton.layout(using: [
            doneButton.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: 24),
            doneButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -30),
            doneButton.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.85),
            doneButton.heightAnchor.constraint(
                equalToConstant: 50),
        ])
        
        
    }
    
    var onDone: (([WashingTag]) -> Void)?
    
    @objc func handleDone() {
        onDone?(manager.selectedItems.map { $0.tag })
    }
}
