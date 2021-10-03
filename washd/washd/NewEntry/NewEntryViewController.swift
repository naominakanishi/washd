import UIKit

class NewEntryViewController: UIViewController {
    
    override func loadView() {
        let view = NewEntryView()
        view.actions = .init(
            openIconPicker: openIconPicker
        )
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func openIconPicker() {
        present(IconPickerViewController(), animated: true, completion: nil)
    }
}

