import UIKit

final class WashViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var clothes: [Clothing] = []
    
    // MARK: - UI Components
    
    private lazy var washNameLabel: UILabel = {
        let view = UILabel()
        
        view.text = "Lavar com alvejante"
        view.font = .appFont.montserrat(.semiBold, 22).uiFont
        
        return view
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .washdColors.unitedNationsBlue
        return view
    }()
    
    private lazy var piecesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ClothesCell.self, forCellWithReuseIdentifier: "ClothesCell")
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    private func addSubviews() {
        contentView.addSubviews(washNameLabel, chevronImageView, piecesCollectionView)
    }
    
    private func constraintSubviews() {
        washNameLabel.layout(using: [
            washNameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 14),
            washNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 18),
        ])
        
        chevronImageView.layout(using: [
            chevronImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -29),
            chevronImageView.topAnchor.constraint(
                equalTo: washNameLabel.topAnchor),
            chevronImageView.bottomAnchor.constraint(
                equalTo: washNameLabel.bottomAnchor),
            chevronImageView.widthAnchor.constraint(
                equalTo: chevronImageView.heightAnchor,
                multiplier: 16 / 26)
        ])
        
        piecesCollectionView.layout(using: [
            piecesCollectionView.topAnchor.constraint(
                equalTo: washNameLabel.bottomAnchor,
                constant: 26),
            piecesCollectionView.leadingAnchor.constraint(
                equalTo: washNameLabel.leadingAnchor),
            piecesCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            piecesCollectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
            piecesCollectionView.heightAnchor.constraint(
                equalToConstant: 164)
        ])
    }
    
    func configure(using wash: Wash) {
        washNameLabel.text = wash.name
        clothes = wash.clothes
        piecesCollectionView.reloadData()
    }
}

extension WashViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        clothes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath)
                as? ClothesCell
        else { return .init() }
        let clothing = clothes[indexPath.item]
        cell.configure(using: clothing)
        cell.itemPickingStackView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(
            width: 113,
            height: collectionView.frame.height)
    }
}

