import UIKit

final class ClothingDetailViewController: UIViewController {
    
    private lazy var clothingDetailView = ClothingDetailView()

    override func loadView() {
        self.view = clothingDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Editar esse nome"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
