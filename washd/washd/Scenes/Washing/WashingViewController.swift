import UIKit
import CoreNFC

final class WashingViewController: UIViewController {
    
    private var washingView: WashingView? { view as? WashingView }
    private let basketViewController = BasketViewController()
    private let clothingManager = ClothingManager()
    private let filterManager = ClothingFilterManager()
    
    private var filteredItems: [ClothingType] = []
    private var filterText: String = ""
    
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

extension WashingViewController: ClothingFilterManagerDelegate {
    func select(type: ClothingType) {
        filteredItems.append(type)
        updateFilters()
    }
    
    func deselect(type: ClothingType) {
        filteredItems.removeAll(where: { $0 == type })
        updateFilters()
    }
    
    private func updateFilters() {
        clothingManager.applyFilter(types: filteredItems)
        washingView?.reloadCloset()
    }
}
