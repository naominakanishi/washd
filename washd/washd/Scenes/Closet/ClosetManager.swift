import UIKit

final class ClosetManager: NSObject,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    var closet: Closet { ClosetDatabase.instance.closet() }
    
    private var allowedTypes: [ClothingType] = []
    
    private var types: [ClothingType] {
        if allowedTypes.isEmpty {
            return closet.clothes.types()
        }
        return closet.clothes.types()
            .filter { allowedTypes.contains($0) }
    }
    
    func applyFilter(types: [ClothingType]) {
        allowedTypes = types
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        types.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        closet.clothes.clothes(of: types[section]).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath) as! ClothesCell
        let section = indexPath.section
        let item = indexPath.item
        let type = types[section]
        let clothes = closet.clothes.clothes(of: type)
        let clothing = clothes[item]
        cell.configure(using: clothing)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 3
        return .init(
            width: width,
            height: width * 164 / 113)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ClosetHeaderView", for: indexPath) as! ClosetHeaderView
        let type = types[indexPath.section]
        view.configure(using: type.name)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        types[section].name.size(
            withConstrainedWidth: collectionView.frame.width,
            font: .appFont.montserrat(.semiBold, 22).uiFont!)
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        print("-----", uniqueValues)
        return uniqueValues
    }
}

extension Array where Element == Clothing {
    func types() -> [ClothingType] {
        map { $0.type }
            .unique
            .sorted { $0.priority < $1.priority }
    }
    
    func clothes(of type: ClothingType) -> [Clothing] {
        filter { $0.type == type }
    }
}
