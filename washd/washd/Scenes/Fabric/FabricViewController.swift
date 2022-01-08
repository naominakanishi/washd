import UIKit
import FirebaseDatabase
import FirebaseStorage

final class FabricViewController: UIViewController {

    private var fabricView: FabricView? { view as? FabricView }
    private let fabricManager = FabricManager()
    private let filterManager = ClothingFilterManager<FabricNature>()

    private var filteredItems: [FabricNature] = []
    private var fabricTypes: [FabricNature] { FabricNature.allCases }
    private var filterText: String = ""

    //  MARK: - View lifecycle

    override func loadView() {
        view = FabricView(
            fabricDelegate: fabricManager,
            fabricDataSource: fabricManager,
            filterDelegate: filterManager,
            filterDataSource: filterManager
        )
        fabricManager.delegate = self
        filterManager.delegate = self
        fabricView?.delegate = self
        
        Database.database().reference().child("fabrics").observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String : Any],
                  let name = dict["name"] as? String ,
                  let description = dict["description"] as? String,
                  let imageName = dict["image"]
            else { return }
            
            let biodegradable = dict["biodegradable"] as? Bool ?? false
            Storage.storage().reference().child("fabrics/\(imageName)").getData(maxSize: .max) { data, error in
                assert(error == nil)
                DispatchQueue.main.async {
                    let newFabric = Fabric(
                        name: name,
                        nature: .natural,
                        biodegradable: biodegradable ? 0 : 1,
                        description: description,
                        image: .init(data: data))
                    self.fabricManager.add(fabric: newFabric)
                    self.fabricView?.reloadCloset()
                    self.fabricView?.stopLoading()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = .washdColors.background
    }

    private func configureNavigationBar() {
        title = "Fibras e Tecidos"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layer.zPosition = 10
    }

    @objc
    private func handleAddPiece() {
        let controller = NewEntryViewController()
        controller.completion = {
            self.fabricView?.reloadCloset()
        }
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
}

extension FabricViewController: ClosetViewDelegate {
    func updateNavigation(shouldPresent: Bool) {
        navigationController?.setNavigationBarHidden(shouldPresent, animated: true)
    }

    func searchTextDidChange(_ newText: String?) {
        filterText = newText ?? ""
        fabricManager.apply(search: filterText)
        fabricView?.reloadCloset()
    }
}

extension FabricViewController: FabricManagerDelegate {
    func didSelect(fabric: Fabric) {
        let controller = FabricDetailViewController(fabric: fabric)
        present(
            UINavigationController(rootViewController: controller),
            animated: true, completion: nil)
    }
}
extension FabricViewController: FilterDelegate {
    func select(itemAt indexPath: IndexPath) {
        let type = fabricTypes[indexPath.item]
        filteredItems.append(type)
        updateFilters()
    }
    
    func deselect(itemAt indexPath: IndexPath) {
        let type = fabricTypes[indexPath.item]
        filteredItems.removeAll(where: { $0 == type })
        updateFilters()
        
    }
    
    private func updateFilters() {
        fabricManager.applyFilter(types: filteredItems)
        fabricView?.reloadCloset()
    }
}

extension FabricViewController: FabricViewDelegate {}
