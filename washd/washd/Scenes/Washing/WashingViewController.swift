import UIKit
import CoreNFC

final class WashingViewController: UIViewController {
    
    private var washingView: WashingView? { view as? WashingView }
    private let basketViewController = BasketViewController()
    private let clothingManager = ClothingManager()
    private let filterManager = ClothingFilterManager<ClothingType>()
    
    private var filteredItems: [ClothingType] = []
    private var filterText: String = ""
    private var allTypes: [ClothingType] {
        ClosetDatabase.instance.closet().clothes.map { $0.type }.unique
    }
    
    //  MARK: - View lifecycle
    
    override func loadView() {
        addChild(basketViewController)
        view = WashingView(
            closetDelegate: clothingManager,
            closetDataSource: clothingManager,
            filterDelegate: filterManager,
            filterDataSource: filterManager,
            basketView: basketViewController.view as! BasketView
        )
        
        filterManager.delegate = self
        washingView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketViewController.didMove(toParent: self)
        configureNavigationBar()
        view.backgroundColor = .washdColors.background
        filterManager.filterOptions = allTypes
    }
    
    private func configureNavigationBar() {
        title = "Lavar roupas"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.zPosition = 10
    }
    
    @objc
    private func handleAddPiece() {
        let controller = NewEntryViewController()
        controller.completion = {
            self.washingView?.reloadFilter()
            self.washingView?.reloadCloset()
        }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

extension WashingViewController: WashingViewDelegate {
    func updateNavigation(shouldPresent: Bool) {
        navigationController?.setNavigationBarHidden(shouldPresent, animated: true)
    }
    
    func searchTextDidChange(_ newText: String?) {
        filterText = newText ?? ""
        clothingManager.apply(search: filterText)
        washingView?.reloadCloset()
    }
}

extension WashingViewController: FilterDelegate {
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
        washingView?.reloadCloset()
    }
}
