import UIKit

class NewEntryViewController: UIViewController {
    
    let newEntryView = NewEntryView()
    
    override func loadView() {
        newEntryView.actions = .init(
            openIconPicker: openIconPicker
        )
        self.view = newEntryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func openIconPicker() {
        let controller = IconPickerViewController()
        controller.onDone = { items in
            self.newEntryView.selectedTags = items
            controller.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
}

