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



