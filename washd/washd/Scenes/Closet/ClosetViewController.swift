import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
    
    private var closetView: ClosetView? { view as? ClosetView }
    private let clothingManager = ClothingManager()
    private let filterManager = ClothingFilterManager<Clothing>()
    
    private var filteredItems: [ClothingType] = []
    private var filterText: String = ""
    
    //  MARK: - View lifecycle
    
    override func loadView() {
        view = ClosetView(
            closetDelegate: clothingManager,
            closetDataSource: clothingManager,
            filterDelegate: filterManager,
            filterDataSource: filterManager
        )
        clothingManager.delegate = self
        filterManager.delegate = self
        closetView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func searchTextDidChange(_ newText: String?) {
        filterText = newText ?? ""
        clothingManager.apply(search: filterText)
        closetView?.reloadCloset()
    }
}

extension ClosetViewController: FilterDelegate {
    func select(itemAt indexPath: IndexPath) {
        let type = ClothingType.allCases[indexPath.item]
        filteredItems.append(type)
        updateFilters()
    }
    
    func deselect(itemAt indexPath: IndexPath) {
        let type = ClothingType.allCases[indexPath.item]
        filteredItems.removeAll(where: { $0 == type })
        updateFilters()
    }
    
    private func updateFilters() {
        clothingManager.applyFilter(types: filteredItems)
        closetView?.reloadCloset()
    }
}

extension ClosetViewController: ClothingManagerDelegate {
    func didSelect(clothing: Clothing) {
        let controller = ClothingDetailViewController(clothing: clothing)
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}
