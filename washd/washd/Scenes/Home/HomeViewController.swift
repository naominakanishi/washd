import UIKit

final class HomeViewController: UIViewController {
    
    
    private lazy var homeView = HomeView(actions: .init(
        registerItem: {
            let controller = NewEntryOptionsViewController()
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        },
        openCloset: {
            let controller = ClosetViewController()
            self.navigationController?.pushViewController(controller, animated: true)

        },
        openWash: {
            let controller = WashingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        },
        learnFabric: {
            // TODO
        },
        understandSymbols: {
            // TODO
        },
        understandUpcycling: {
            // TODO
        }))

   
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
