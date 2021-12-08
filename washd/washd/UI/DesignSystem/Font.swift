import UIKit


enum Fonts {
    typealias FontSize = CGFloat
    enum FontStyle {
        case regular
        case bold
        case semiBold
        case light
        
        var name: String {
            switch self {
            case .bold:
                return "Bold"
            case .light:
                return "Light"
            case .regular:
                return "Regular"
            case .semiBold:
                return "SemiBold"
            }
        }
    }
    
    case montserrat(FontStyle, FontSize)
    
    var uiFont: UIFont? {
        switch self {
        case let .montserrat(style, size):
            return UIFont(
                name: "Montserrat-\(style.name)", size: size)
        }
    }
}

extension UIFont {
    static let appFont = Fonts.self
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
    
    func size(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return boundingBox.size
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
