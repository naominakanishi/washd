import UIKit

final class IconPickerCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    final class SectionModel {
        let category: TagCategory
        var isOpened = true
        let tags: [Item]
        var selectedIndex: Int?
        init(category: TagCategory) {
            self.category = category
            self.tags = TagDatabase.allTags()
                .filter { $0.category == category }
                .flatMap { tag in tag.imageNames.map { .init(
                    tag: tag,
                    imageName: $0)
                }}
        }
        
        struct Item {
            let tag: WashingTag
            let imageName: String
        }
    }
    
    var sections = TagCategory.allCases.map { SectionModel(category: $0) }
    
    var selectedItems: [SectionModel.Item] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagSection = sections[section]
        if tagSection.isOpened {
            return tagSection.tags.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
        
        view.toggleSection = {
            section.isOpened.toggle()
            let change : ([IndexPath]) -> Void = !section.isOpened ?
                collectionView.deleteItems :
                collectionView.insertItems
            change(section
                    .tags
                    .indices
                    .map { .init(
                        item: $0,
                        section: indexPath.section) }
            )
        }
        view.titleLabel.text = section.category.name
        
        return view
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.tags[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "WasingTagCell",
            for: indexPath) as? WasingTagCell
        else { return .init() }
        
        cell.imageView.image = UIImage(named: item.imageName)?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = selectedItems.contains(where: { $0.imageName == item.imageName }) ? .washdColors.unitedNationsBlue : .washdColors.celeste
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].tags[indexPath.item]
        if let index = selectedItems.firstIndex(where: { $0.imageName == item.imageName }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

