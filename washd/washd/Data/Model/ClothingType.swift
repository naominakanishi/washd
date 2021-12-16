enum ClothingType: Codable, CaseIterable {
    case top
    case bottom
    case dresses
    case underwear
    case sleepwear
    case fitness
    
    var imageName: String{
        switch self {
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .dresses:
            return "dresses"
        case .underwear:
            return "underwear"
        case .sleepwear:
            return "sleepwear"
        case .fitness:
            return "fitness"
        }
    }
    
    var name: String {
        switch self {
        case .top:
            return "Tops"
        case .bottom:
            return "Bottoms"
        case .dresses:
            return "Peças únicas"
        case .underwear:
            return "Roupas íntimas"
        case .sleepwear:
            return "Pijamas"
        case .fitness:
            return "Fitness"
        }
    }
    
    var priority: Int {
        ClothingType.allCases.firstIndex(of: self) ?? -1
    }
}
