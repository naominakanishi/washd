//import UIKit
//import CoreNFC
//
//final class FabricViewController: UIViewController {
//
//    private var fabricView: FabricView? { view as? FabricView }
//    private let clothingManager = ClothingManager()
//    private let filterManager = ClothingFilterManager()
//
//    private var filteredItems: [ClothingType] = []
//    private var filterText: String = ""
//
//    //  MARK: - View lifecycle
//
//    override func loadView() {
////        addChild(basketViewController)
//        view = ClosetView(
//            closetDelegate: clothingManager,
//            closetDataSource: clothingManager,
//            filterDelegate: filterManager,
//            filterDataSource: filterManager
////            basketView: basketViewController.view as! BasketView
//        )
//        clothingManager.delegate = self
//        filterManager.delegate = self
//        closetView?.delegate = self
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        basketViewController.didMove(toParent: self)
//        configureNavigationBar()
//        view.backgroundColor = .washdColors.background
//    }
//
//    private func configureNavigationBar() {
//        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        moreButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
//        moreButton.tintColor = .black
//        moreButton.addTarget(self, action: #selector(handleAddPiece), for: .touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
//        title = "Suas roupas"
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.layer.zPosition = 10
//    }
//
//    @objc
//    private func handleAddPiece() {
//        let controller = NewEntryViewController()
//        controller.completion = {
//            self.closetView?.reloadCloset()
//        }
//        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
//    }
//}
//
//extension FabricViewController: ClosetViewDelegate {
//    func updateNavigation(shouldPresent: Bool) {
//        navigationController?.setNavigationBarHidden(shouldPresent, animated: true)
//    }
//
//    func searchTextDidChange(_ newText: String?) {
//        filterText = newText ?? ""
//        clothingManager.apply(search: filterText)
//        closetView?.reloadCloset()
//    }
//}
//
//extension FabricViewController: ClothingFilterManagerDelegate {
//    func select(type: ClothingType) {
//        filteredItems.append(type)
//        updateFilters()
//    }
//
//    func deselect(type: ClothingType) {
//        filteredItems.removeAll(where: { $0 == type })
//        updateFilters()
//    }
//
//    private func updateFilters() {
//        clothingManager.applyFilter(types: filteredItems)
//        closetView?.reloadCloset()
//    }
//}
//
//extension FabricViewController: ClothingManagerDelegate {
//    func didSelect(clothing: Clothing) {
//        let controller = ClothingDetailViewController(clothing: clothing)
//        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
//    }
//}
