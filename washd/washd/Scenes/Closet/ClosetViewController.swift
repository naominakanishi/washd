import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
    
    private var closetView: ClosetView? { view as? ClosetView }
    private let basketViewController = BasketViewController()
    
    //  MARK: - View lifecycle
    
    override func loadView() {
        addChild(basketViewController)
        view = ClosetView(
            delegate: self,
            dataSource: self,
            basketView: basketViewController.view as! BasketView
        )
        closetView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketViewController.didMove(toParent: self)
        configureNavigationBar()
        view.backgroundColor = .washdColors.background
    }
    
    private func configureNavigationBar() {
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        moreButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        moreButton.tintColor = .black
        moreButton.addTarget(self, action: #selector(handleAddPiece), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
        title = "Suas roupas"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.zPosition = 10
    }
    
    @objc
    private func handleAddPiece() {
        let controller = NewEntryViewController()
        controller.completion = {
            self.closetView?.reloadData()
        }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

extension ClosetViewController: ClosetViewDelegate {
    func updateNavigation(shouldPresent: Bool) {
        navigationController?.setNavigationBarHidden(shouldPresent, animated: true)
    }
}

extension ClosetViewController: UICollectionViewDelegate, UICollectionViewDataSource,
 UICollectionViewDelegateFlowLayout {
    
    var closet: Closet { ClosetDatabase.instance.closet() }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        closet.clothes.types().count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        closet.clothes.clothes(of: closet.clothes.types()[section]).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath) as! ClothesCell
        let section = indexPath.section
        let item = indexPath.item
        let type = closet.clothes.types()[section]
        let clothes = closet.clothes.clothes(of: type)
        let clothing = clothes[item]
        cell.configure(using: clothing)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(
            width: (collectionView.frame.width - 40) / 3,
            height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ClosetHeaderView", for: indexPath) as! ClosetHeaderView
        let type = closet.clothes.types()[indexPath.section]
        view.configure(using: type.name)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        closet.clothes.types()[section].name.size(
            withConstrainedWidth: collectionView.frame.width,
            font: .appFont.montserrat(.semiBold, 22).uiFont!)
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        print("-----", uniqueValues)
        return uniqueValues
    }
}

extension Array where Element == Clothing {
    func types() -> [ClothingType] {
        map { $0.type }
            .unique
            .sorted { $0.priority < $1.priority }
    }
    
    func clothes(of type: ClothingType) -> [Clothing] {
        filter { $0.type == type }
    }
}

final class ClosetHeaderView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .appFont.montserrat(.semiBold, 22).uiFont
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    func constraintSubviews() {
        titleLabel.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func configure(using title: String) {
        titleLabel.text = title
    }
}
