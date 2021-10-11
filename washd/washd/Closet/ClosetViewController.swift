import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
 
    private lazy var closetTableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ClothesCell.self, forCellWithReuseIdentifier: "ClothesCell")
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        constraintSubviews()
        view.backgroundColor = .washdColors.background
    }
    
    private func addSubviews() {
        view.addSubviews(closetTableView)
    }
    
    private func constraintSubviews() {
        closetTableView.layout(using: [
            closetTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            closetTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            closetTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            closetTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            ),
        ])
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
    }
    
    @objc
    private func handleAddPiece() {
        let controller = NewEntryViewController()
        controller.completion = {
            self.closetTableView.reloadData()
        }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}


extension ClosetViewController: UICollectionViewDelegate, UICollectionViewDataSource,
 UICollectionViewDelegateFlowLayout {
    
    var closet: Closet { ClosetDatabase.instance.closet() }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closet.clothes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath) as! ClothesCell
        let clothing = closet.clothes[indexPath.item]
        cell.configure(using: clothing)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(
            width: (collectionView.frame.width - 40) / 3,
            height: 164)
    }
}



