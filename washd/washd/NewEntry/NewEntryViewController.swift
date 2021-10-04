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
    
    var completion: (() -> Void)?
    
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
            openScanner: openScanner,
            doneAction: createPiece
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
    
    private func createPiece() {
        guard let name: String = newEntryView.name,
              let type: ClothingType = newEntryView.selectedType,
              let color: ClothingColor = newEntryView.selectedColor
        else { return }
                
        let clothing = Clothing(
            name: name,
            image: nil,
            type: type,
            color: color,
            nfcTagId: UUID(uuidString: currentTag?.id ?? ""),
            washingTags: newEntryView.selectedTags
        )
        ClosetDatabase.instance.add(clothing: clothing)
        completion?()
        dismiss(animated: true, completion: nil)
    }
}
