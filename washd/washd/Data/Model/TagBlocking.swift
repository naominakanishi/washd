protocol TagBlockListing {
    var blocks: [TagBlocker] { get }
}

enum TagBlocker: Equatable, Codable, Hashable, TagBlockListing {
    typealias WashingCategory = CaseIterable & Equatable & Codable & Hashable
    
    enum Ironing: WashingCategory {
        case iron
        case doNotIron
        case lowTemperature
        case mediumTemperature
        case highTemperature
    }
    
    enum DryCleaning: WashingCategory {
        case petroleumSolventOnly
        case anySolvent
        case demanded
        case noSteamFinishing
        case lowHeat
        case reducedMoisture
        case shortCycle
    }
    
    enum Drying: WashingCategory {
        case doNotDry
        case tumbleDry
        case lowHeat
        case mediumHeat
        case highHeat
        case noHeat
        case permanentPress
        case `weak`
        case delicate
        case hanging
        case dripping
        case notWringing
    }
    
    enum WaterTemperature: Int, WashingCategory {
        case under30
        case under40
        case under50
        case under60
        case under70
        case under95
    }
    
    enum Bleaching: WashingCategory {
        case bleach
        case dontBleach
        case nonChlorine
    }
    
    enum Washing: WashingCategory {
        case machine
        case `weak`
        case delicate
        case hand
        case dontWash
        case noWater
    }
    
    case washing(Washing)
    case ironing(Ironing)
    case drying(Drying)
    case dryCleaning(DryCleaning)
    case waterTemperature(WaterTemperature)
    case bleaching(Bleaching)
    case unique
    
    var blocks: [TagBlocker] {
        switch self {
        case let .washing(blocker):
            return blocker.blocks
        case let .ironing(blocker):
            return blocker.blocks
        case let .drying(blocker):
            return blocker.blocks
        case let .dryCleaning(blocker):
            return blocker.blocks
        case let .waterTemperature(blocker):
            return blocker.blocks
        case let .bleaching(blocker):
            return blocker.blocks
        case .unique:
            return [
                Ironing.allCases.map { .ironing($0) },
                DryCleaning.allCases.map { .dryCleaning($0) },
                Drying.allCases.map { .drying($0) },
                WaterTemperature.allCases.map { .waterTemperature($0) },
                Bleaching.allCases.map { .bleaching($0) },
                Washing.allCases.map { .washing($0) },
            ].flatMap { $0 }
            .excluding([self])
        }
    }
}

extension TagBlocker.Washing: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .machine:
            return []
        case .weak,
             .delicate:
            return [.washing(.machine)]
        case .hand:
            return [
                .washing(.machine),
                .washing(.weak),
                .washing(.delicate)
            ]
        case .dontWash,
             .noWater:
            return Self.allCases.excluding([self]).map { .washing($0) }
        }
    }
}

extension TagBlocker.Bleaching: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .bleach:
            return []
        case .dontBleach:
            return Self.allCases.excluding([self]).map { .bleaching($0) }
        case .nonChlorine:
            return [.bleaching(.bleach)]
        }
    }
}

extension TagBlocker.WaterTemperature: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .under30:
            return [
                .waterTemperature(.under40),
                .waterTemperature(.under50),
                .waterTemperature(.under60),
                .waterTemperature(.under70),
                .waterTemperature(.under95),
            ]
        case .under40:
            return [
                .waterTemperature(.under50),
                .waterTemperature(.under60),
                .waterTemperature(.under70),
                .waterTemperature(.under95),
            ]
        case .under50:
            return [
                .waterTemperature(.under60),
                .waterTemperature(.under70),
                .waterTemperature(.under95),
            ]
        case .under60:
            return [
                .waterTemperature(.under70),
                .waterTemperature(.under95),
            ]
        case .under70:
            return [
                .waterTemperature(.under95),
            ]
        case .under95:
            return []
        }
    }
}

extension TagBlocker.Ironing: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .iron,
                .highTemperature:
            return []
        case .doNotIron:
            return [
                .ironing(.iron),
                .ironing(.lowTemperature),
                .ironing(.mediumTemperature),
                .ironing(.highTemperature)
            ]
            
        case .lowTemperature:
            return [
                .ironing(.mediumTemperature),
                .ironing(.highTemperature)
            ]
        case .mediumTemperature:
            return [
                .ironing(.highTemperature)
            ]
        }
    }
}

extension TagBlocker.Drying: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .doNotDry:
            return TagBlocker.Drying.allCases
                .map { TagBlocker.drying($0) }
                .excluding([
                    .drying(.hanging),
                    .drying(.dripping),
                ])
        case .tumbleDry,
             .highHeat,
             .permanentPress,
             .notWringing:
            return []
        case .lowHeat:
            return [
                .drying(.mediumHeat),
                .drying(.highHeat),
            ]
        case .mediumHeat:
            return [
                .drying(.highHeat),
            ]
        case .noHeat:
            return [
                .drying(.lowHeat),
                .drying(.mediumHeat),
                .drying(.highHeat),
            ]
        case .weak,
            .delicate:
            return [
                .drying(.tumbleDry)
            ]
        case .hanging:
            return [
                .drying(.tumbleDry),
                .drying(.weak),
                .drying(.lowHeat),
                .drying(.mediumHeat),
                .drying(.highHeat),
                .drying(.noHeat),
            ]
        case .dripping:
            return [
                .drying(.tumbleDry),
                .drying(.weak),
                .drying(.lowHeat),
                .drying(.mediumHeat),
                .drying(.highHeat),
                .drying(.noHeat),
                .drying(.hanging)
            ]
        }
    }
}

extension TagBlocker.DryCleaning: TagBlockListing {
    var blocks: [TagBlocker] {
        switch self {
        case .petroleumSolventOnly:
            return [.dryCleaning(.anySolvent)]
        case .demanded:
            return [.unique]
        case .noSteamFinishing,
                .lowHeat,
                .reducedMoisture,
                .shortCycle,
                .anySolvent:
            return []
        }
    }
}
