import UIKit

final class BasketViewController: UIViewController {
    
    private var basketView: BasketView? { view as? BasketView }
    
    override func loadView() {
        view = BasketView()
        basketView?.openInstructions = { [navigationController] wash in
            let controller = WashingInstructionsViewController(clothes: wash.clothes)
            navigationController?.present(controller,
                                          animated: true,
                                          completion: nil)
        }
    }
    
    override func viewDidLoad() {
        BasketDatabase.shared.observe(self)
    }
    
    deinit {
        BasketDatabase.shared.remove(observer: self)
    }
}

extension BasketViewController: BasketListener {
    func onWashDidChange(_ notification: Notification) {
        let washes = BasketDatabase.shared.washes
        basketView?.badge(count: washes.count)
        basketView?.set(washes: washes)
    }
}
