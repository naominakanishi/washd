enum ClothingColor: String, Codable, CaseIterable {
    case white
    case black
    case colored
    var name: String {
        switch self {
        case .white:
            return "Branco"
        case .black:
           return "Preto"
        case .colored:
           return "Colorido"
        
        }
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.singleValueContainer()
        switch try decoder.decode(String.self){
        case "white":
            self = .white
        case "black":
            self = .black
        case "colored",
             "lightColors",
             "darkColors":
            self = .colored
        default:
            throw DecodingError.valueNotFound(Self.self, .init(
                codingPath: decoder.codingPath,
                debugDescription: "Error decoding clothing color!",
                underlyingError: nil
            ))
        }
    }
}

// MARK: - Legacy cases
extension ClothingColor {
    static let lightColors: Self = .colored
    static let darkColors: Self = .colored
}
