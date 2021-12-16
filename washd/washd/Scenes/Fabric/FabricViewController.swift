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
                  let biodegradable = dict["biodegradable"] as? Double,
                  let imageName = dict["image"]
            else { return }
            
            Storage.storage().reference().child("fabrics/\(imageName)").getData(maxSize: .max) { data, error in
                DispatchQueue.main.async {
                    let newFabric = Fabric(
                        name: name,
                        nature: .natural,
                        biodegradable: biodegradable,
                        description: description,
                        image: .init(data: data))
                    self.fabricManager.add(fabric: newFabric)
                    self.fabricView?.reloadCloset()
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
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        moreButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        moreButton.tintColor = .black
        moreButton.addTarget(self, action: #selector(handleAddPiece), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
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
