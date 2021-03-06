import UIKit

final class ClothingDetailViewController: UIViewController {
    
    private lazy var clothingDetailView = ClothingDetailView()

    private let clothing: Clothing
    
    init(clothing: Clothing) {
        self.clothing = clothing
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
        clothingDetailView.set(clothingImage: .init(
            fileNamed: clothing.image))
    }
    
    
    private func configureNavigationBar() {
        title = clothing.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

extension ClothingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4 - (clothing.description == nil ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(ClothingInfoCell.self, at: indexPath)
            cell.configure(using: .init(title: clothing.type.name))
            return cell
        case 1:
            let cell = tableView.dequeue(ClothingInfoCell.self, at: indexPath)
            cell.configure(using: .init(title: clothing.color.name))
            return cell
        case 2:
            let cell = tableView.dequeue(ClothingSymbolsCell.self, at: indexPath)
            cell.configure(using: .init(tags: clothing.washingTags))
            return cell
        case 3 where clothing.description != nil:
            let cell = tableView.dequeue(ClothingInfoCell.self, at: indexPath)
            cell.configure(using: .init(title: clothing.description!))
            return cell
        default: fatalError("Unexpeceted item count!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension UIImage {
    convenience init?(fileNamed name: String?) {
        guard let name = name,
              let file = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false)
                .appendingPathComponent(name)
        else { return nil }
        self.init(contentsOfFile: file.path)
    }
}
