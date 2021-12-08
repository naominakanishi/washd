import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func layout(using constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func layout(@ConstraintCollector using constraintCollection: (UIView) -> [NSLayoutConstraint]) {
        self.layout(using: constraintCollection(self))
    }
}

@resultBuilder
struct ConstraintCollector {
    static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        components
    }
}
