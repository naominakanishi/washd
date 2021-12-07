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
