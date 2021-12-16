import UIKit

class NewEntryViewController: UIViewController {

    let newEntryView = NewEntryView()
    
    var currentImage: String?
    
    var completion: (() -> Void)?
    
    private var currentSession: NFCReader?
    
    private var currentTag: WashdTag?
    
    override func loadView() {
        newEntryView.actions = .init(
            openIconPicker: openIconPicker,
            openScanner: openScanner,
            doneAction: createPiece, openCamera: pickPhoto
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
            type: type,
            color: color,
            nfcTagId: UUID(uuidString: currentTag?.id ?? ""),
            washingTags: newEntryView.selectedTags, description: nil,
            image: currentImage
        )
        ClosetDatabase.instance.add(clothing: clothing)
        completion?()
        dismiss(animated: true, completion: nil)
    }
    
    private func pickPhoto() {
        let alertController = UIAlertController(
            title: "Escolher uma imagem",
            message: nil,
            preferredStyle: .actionSheet)
        alertController.addAction(.init(
            title: "Galeria de fotos",
            style: .default,
            handler: { _ in
                alertController.dismiss(animated: true) {
                    self.pickPhotoFromGallery(sourceType: .savedPhotosAlbum)
                }
            }))
        alertController.addAction(.init(
            title: "Câmera",
            style: .default,
            handler: { _ in
                alertController.dismiss(animated: true) {
                    self.pickPhotoFromGallery(sourceType: .camera)
                }
            }))
        alertController.addAction(.init(
            title: "Cancelar",
            style: .cancel,
            handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
            }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func pickPhotoFromGallery(sourceType: UIImagePickerController.SourceType) {
        let galleryViewController = UIImagePickerController()
        galleryViewController.delegate = self
        galleryViewController.sourceType = sourceType
        galleryViewController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(galleryViewController, animated: true, completion: nil)
    }
}

extension NewEntryViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { picker.dismiss(animated: true, completion: nil) }
        
        let image = info[.originalImage] as? UIImage
        let data = image?.pngData()
        let fileName = UUID().uuidString + ".png"
        do {
            let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
            try data?.write(to: file)
            newEntryView.renderPickedImage()
            currentImage = fileName
            print("CREATED", file)
        } catch {
            print("DEU ERRO!!!", error)
        }
    }
}

extension NewEntryViewController: NFCReaderDelegate {
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
    
}

// file:///var/mobile/Containers/Data/Application/F6A2B3DD-7867-4954-A785-0C7E35FEF8AF/Documents/3AFD1808-BA36-4C82-9A46-B98D4DDE71B7.png
// file:///var/mobile/Containers/Data/Application/8675FF4A-A5D6-42BF-8ED6-4560FC411F03/Documents/47AC3A11-9B17-46FA-81B6-AA31043B7CD1.png
