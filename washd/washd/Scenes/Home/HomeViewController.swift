import UIKit

final class HomeViewController: UIViewController {
    
    
    private var homeView = HomeView()

   
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
