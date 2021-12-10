import UIKit

protocol ClothingFilterManagerDelegate: AnyObject {
    func select(type: ClothingType)
    func deselect(type: ClothingType)
}

final class ClothingFilterManager: NSObject,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    enum FilterOption {
        case type(ClothingType)
    }
    
    var filterOptions: [FilterOption] = ClosetDatabase.instance
        .closet()
        .clothes
        .types()
        .map { .type($0) }
    
    weak var delegate: ClothingFilterManagerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch filterOptions[indexPath.item] {
        case let .type(clothingType):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTypeCell", for: indexPath) as! FilterTypeCell
            cell.configure(using: clothingType.name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = filterOptions[indexPath.item]
        switch option {
        case let .type(clothingType):
            delegate?.select(type: clothingType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let option = filterOptions[indexPath.item]
        switch option {
        case let .type(clothingType):
            delegate?.deselect(type: clothingType)
        }
    }
}
