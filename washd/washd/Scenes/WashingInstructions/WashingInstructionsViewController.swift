import UIKit

final class WashingInstructionsViewController: UIViewController {
    
    private var instructionsView: WashingInstructionsView? { view as? WashingInstructionsView }
    private lazy var clothingManager = ClothingManager(closet: .init(clothes: clothes))
    private let clothes: [Clothing]
    
    init(clothes: [Clothing]) {
        self.clothes = clothes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WashingInstructionsView(
            delegate: clothingManager,
            dataSource: clothingManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsView?.configure(using: .init(
            clothes: clothes,
            instructions: clothes.map { $0.name }
        ))
    }
}
