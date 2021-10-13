import UIKit

class NewEntryViewController: UIViewController {

    let newEntryView = NewEntryView()
    
    var currentImage: Data?
    
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
            image: currentImage,
            type: type,
            color: color,
            nfcTagId: UUID(uuidString: currentTag?.id ?? ""),
            washingTags: newEntryView.selectedTags
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
        
        var image = info[.originalImage] as? UIImage
        if let metadata = info[.mediaMetadata] as? NSDictionary,
           let orientation = metadata["Orientation"] as? Int,
           orientation != 1 {
            image = image?.rotate(radians: 2 * .pi)
        }
           
        newEntryView.renderPickedImage()
        currentImage = image?.pngData()
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

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
