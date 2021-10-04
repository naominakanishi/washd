import UIKit

enum Colors {
    static let background: UIColor = .init(hex: 0xEBF4F4)
    static let unitedNationsBlue: UIColor = .init(hex: 0x4A8FE7)
    static let lightGray: UIColor = .init(hex: 0xE5E5E5)
    static let celeste: UIColor = .init(hex: 0xC8EDF1)
    static let hintText: UIColor = .init(hex: 0x333333).withAlphaComponent(0.5)
}
 
extension UIColor {
    static let washdColors = Colors.self
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}

