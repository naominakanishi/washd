import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
    
    private var closetView: ClosetView? { view as? ClosetView }
    private let basketViewController = BasketViewController()
    private let closetManager = ClosetManager()
    private let filterManager = ClosetFilterManager()
    
    private var filteredItems: [ClothingType] = []
    
    //  MARK: - View lifecycle
    
    override func loadView() {
        addChild(basketViewController)
        view = ClosetView(
            closetDelegate: closetManager,
            closetDataSource: closetManager,
            filterDelegate: filterManager,
            filterDataSource: filterManager,
            basketView: basketViewController.view as! BasketView
        )
        filterManager.delegate = self
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
            self.closetView?.reloadCloset()
        }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

extension ClosetViewController: ClosetViewDelegate {
    func updateNavigation(shouldPresent: Bool) {
        navigationController?.setNavigationBarHidden(shouldPresent, animated: true)
    }
}

extension ClosetViewController: ClosetFilterManagerDelegate {
    func select(type: ClothingType) {
        filteredItems.append(type)
        updateFilters()
    }
    
    func deselect(type: ClothingType) {
        filteredItems.removeAll(where: { $0 == type })
        updateFilters()
    }
    
    private func updateFilters() {
        closetManager.applyFilter(types: filteredItems)
        closetView?.reloadCloset()
    }
    
}
