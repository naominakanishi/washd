import UIKit

final class NewEntryOptionsViewController: UIViewController {
    
    override func loadView() {
        let view = NewEntryOptionsView()
        view.actions = .init(
            readNFCTapped: {
                // TODO
            },
            readQRCodeTapped: {
                // TODO
            },
            manualInputTapped: {
                let controller = NewEntryViewController()
                self.present(controller, animated: true, completion: nil)
            })
        self.view = view
    }
    
    override func viewDidLoad() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Cadastrar nova peça"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
}
