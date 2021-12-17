import UIKit

final class WashingInstructionsView: UIView {
    struct Model {
        let clothes: [Clothing]
        let instructions: [String]
    }
    
    private lazy var instructionsTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Instruções"
        view.font = .appFont.montserrat(.semiBold, 18).uiFont
        return view
    }()
    
    private lazy var instructionsStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ClosetCell.self, forCellWithReuseIdentifier: "ClothesCell")
        collectionView.register(ClothingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ClosetHeaderView")
        collectionView.backgroundColor = .clear
        layout.sectionInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.keyboardDismissMode = .interactive
        return collectionView
    }()
    private var clothes: [Clothing] = []
    
    init(delegate: UICollectionViewDelegate,
         dataSource: UICollectionViewDataSource
    ) {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        addSubviews(instructionsTitleLabel,
                    instructionsStackView,
                    collectionView)
    }
    
    func constraintSubviews() {
        instructionsTitleLabel.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: 32)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor,
                                         constant: -32)
        }
        
        instructionsStackView.layout {
            $0.topAnchor.constraint(
                equalTo: instructionsTitleLabel.bottomAnchor,
                constant: 20)
            $0.leadingAnchor.constraint(equalTo: instructionsTitleLabel.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: instructionsTitleLabel.trailingAnchor)
        }
        
        collectionView.layout {
            $0.topAnchor.constraint(
                equalTo: instructionsStackView.bottomAnchor,
                constant: 24)
            $0.leadingAnchor.constraint(equalTo: instructionsTitleLabel.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: instructionsTitleLabel.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func configure(using model: Model) {
        clothes = model.clothes
        collectionView.reloadData()
        instructionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        model.instructions.forEach {
            let view = UILabel()
            view.font = .appFont.montserrat(.regular, 16).uiFont
            view.text = "·" + $0
            instructionsStackView.addArrangedSubviews(view)
        }
    }
}
