enum TagCategory: Codable, CaseIterable {
    case washing
    case bleaching
    case waterTemperature
    case ironing
    case drying
    case dryCleaning
    
    var name: String {
        switch self {
        case .bleaching:
            return "Alvejante"
        case .dryCleaning:
            return "Lavar a seco"
        case .drying:
            return "Secar"
        case .ironing:
            return "Passar"
        case .washing:
            return "Lavar"
        case .waterTemperature:
            return "Temperatura da agua"
        }
    }
}
