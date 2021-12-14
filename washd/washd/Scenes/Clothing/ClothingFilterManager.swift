import UIKit

protocol FilterDelegate: AnyObject {
    func select(itemAt indexPath: IndexPath)
    func deselect(itemAt indexPath: IndexPath)
}


protocol ClothingCellProtocol: UICollectionViewCell {
    func configure(using title: String)
}

protocol FilterItem {
    var name: String { get }
}

final class ClothingFilterManager<T: FilterItem>: NSObject,
                                   UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
    
    enum FilterOption {
        case type(ClothingType)
    }
    
    var filterOptions: [T] = []
    weak var delegate: FilterDelegate?
    
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
        let item = filterOptions[indexPath.item - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTypeCell", for: indexPath) as! FilterTypeCell
        cell.configure(using: item.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            collectionView.indexPathsForSelectedItems?.forEach({ indexPath in
                guard indexPath.item != 0 else { return }
                delegate?.deselect(itemAt: indexPath)
                collectionView.deselectItem(at: indexPath, animated: true)
            })
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            return
        }
        collectionView.deselectItem(at: .init(item: 0, section: 0), animated: true)
        delegate?.select(itemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            return
        }
        delegate?.deselect(itemAt: indexPath)
    }
}
