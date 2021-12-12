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
        filterOptions.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTypeCell", for: indexPath) as! FilterTypeCell
            cell.configure(using: "Todos")
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            return cell
        }
        switch filterOptions[indexPath.item - 1] {
        case let .type(clothingType):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTypeCell", for: indexPath) as! FilterTypeCell
            cell.configure(using: clothingType.name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            collectionView.indexPathsForSelectedItems?.forEach({ indexPath in
                guard indexPath.item != 0 else { return }
                let option = filterOptions[indexPath.item - 1]
                switch option {
                case let .type(clothingType):
                    delegate?.deselect(type: clothingType)
                }
                collectionView.deselectItem(at: indexPath, animated: true)
            })
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            return
        }
        collectionView.deselectItem(at: .init(item: 0, section: 0), animated: true)
        let option = filterOptions[indexPath.item - 1]
        switch option {
        case let .type(clothingType):
            delegate?.select(type: clothingType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            return
        }
        let option = filterOptions[indexPath.item - 1]
        switch option {
        case let .type(clothingType):
            delegate?.deselect(type: clothingType)
        }
    }
}
