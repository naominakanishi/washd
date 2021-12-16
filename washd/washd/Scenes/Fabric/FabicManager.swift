import UIKit

protocol FabricManagerDelegate: AnyObject {
    func didSelect(fabric: Fabric)
}

final class FabricManager: NSObject,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    weak var delegate: FabricManagerDelegate?
    
    private var allFabrics: [Fabric] = []
    private var fabrics: [Fabric] {
        searchFilter.isEmpty ?
        allFabrics :
        allFabrics.filter { $0.name.contains(searchFilter) }
    }
    
    private var allowedTypes: [FabricNature] = []
    private var searchFilter: String = ""
    
    func applyFilter(types: [FabricNature]) {
        allowedTypes = types
    }
    
    func apply(search: String) {
        self.searchFilter = search
    }
    
    func add(fabric: Fabric) {
        allFabrics.append(fabric)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fabrics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FabricCell.self, at: indexPath)
        let item = indexPath.item
        let fabric = fabrics[item]
        cell.configure(using: fabric)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        let clothing = fabrics[item]
        delegate?.didSelect(fabric: clothing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        return .init(
            width: width,
            height: width * 164 / 113)
    }
}
