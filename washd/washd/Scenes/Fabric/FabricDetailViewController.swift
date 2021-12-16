import UIKit

final class FabricDetailViewController: UIViewController {
    
    private lazy var clothingDetailView = FabricDetailView()

    private let fabric: Fabric
    
    init(fabric: Fabric) {
        self.fabric = fabric
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = clothingDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothingDetailView.clothingInfoTableView.delegate = self
        clothingDetailView.clothingInfoTableView.dataSource = self

        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let image = fabric.image {
            clothingDetailView.set(clothingImage: image)
        }
    }
    
    
    private func configureNavigationBar() {
        title = fabric.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

extension FabricDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ClothingInfoCell.self, at: indexPath)
        switch indexPath.row {
        case 0:
            cell.configure(using: .init(title: "Origem: \(fabric.nature.name)"))
        case 1:
            cell.configure(using: .init(title: fabric.biodegradable == 1 ? "Biodegradável" : "Não biodegradável"))
        case 2:
            cell.configure(using: .init(title: fabric.description))
        default: fatalError("Unexpeceted item count!")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
