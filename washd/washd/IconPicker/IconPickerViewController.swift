import UIKit
import CoreNFC

final class IconPickerViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .init(width: 100, height: 48)
        layout.sectionInset = .init(
            top: 20,
            left: 40,
            bottom: 0,
            right: 40)
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)

        view.register(
            HeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderCell")
        view.register(WasingTagCell.self, forCellWithReuseIdentifier: "WasingTagCell")
        view.delegate = manager
        view.dataSource = manager
        
        return view
    }()
    
    private let manager = IconPickerCollectionViewManager()
    
    override func loadView() {
        view = collectionView
    }
    
}
