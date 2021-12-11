enum ClothingColor: String, Codable, CaseIterable {
    case white
    case black
    case lightColors
    case darkColors
    
    var name: String {
        switch self {
        case .white:
            return "Branco"
        case .black:
           return "Preto"
        case .lightColors:
           return "Colorido claro"
        case .darkColors:
           return "Colorido escuro"
        
        }
        
    }
}
