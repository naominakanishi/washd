import UIKit

extension UITableView {
    func register<T>(_ type: T.Type) where T: UITableViewCell {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerAuxiliary<T>(_ type: T.Type) where T: UIView {
        self.register(
            type,
            forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    // Generics
    func dequeue<T>(_ type: T.Type, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(
            withIdentifier: type.reuseIdentifier,
            for: indexPath) as? T
        else { fatalError("Mano, vc esqueceu de registrar a celula.Ve la") }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T>(_ type: T.Type) -> T? where T: UITableViewHeaderFooterView {
        guard let cell = dequeueReusableHeaderFooterView(
            withIdentifier: type.reuseIdentifier
        ) as? T
        else { fatalError("Mano, vc esqueceu de registrar a celula.Ve la") }
        return cell
    }
}

extension NSObject {
    static var reuseIdentifier: String { String(describing: self) }
}
