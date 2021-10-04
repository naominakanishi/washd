import UIKit

class NewEntryViewController: UIViewController, NFCReaderDelegate {
    func handleUnexpectedError(_ error: Error) {
        
    }
    
    func created(tag: WashdTag) {
        currentTag = tag
        currentSession?.end()
    }
    
    func detected(tag: WashdTag) {
        currentTag = tag
        currentSession?.end()
    }
    
    let newEntryView = NewEntryView()
    
    private var currentSession: NFCReader?
    private var currentTag: WashdTag? {
        didSet {
            DispatchQueue.main.async {
                self.newEntryView.renderPickedNFC()
            }
        }
    }
    
    override func loadView() {
        newEntryView.actions = .init(
            openIconPicker: openIconPicker,
            openScanner: openScanner
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
    
    private func openScanner() {
        currentSession = .init()
        currentSession?.delegate = self
        currentSession?.begin()
    }
}
