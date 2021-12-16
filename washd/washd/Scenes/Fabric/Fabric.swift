import Foundation
import UIKit

struct Fabrics {
    var fabrics: [Fabric]
}

enum FabricNature: CaseIterable {
    case natural
    case synthetic
    case mixed
}


struct Fabric: Equatable, Hashable {
   
    let name: String
    let nature: FabricNature
    let biodegradable: Double
    let description: String
    let image: UIImage?
    
    internal init(name: String, nature: FabricNature, biodegradable: Double, description: String, image: UIImage?) {
        self.name = name
        self.nature = nature
        self.biodegradable = biodegradable
        self.description = description
        self.image = image
    }
    
}

extension FabricNature: FilterItem {
    var name: String {
        switch self {
        case .natural:
            return "Natural"
        case .synthetic:
            return "Sintético"
        case .mixed:
            return "Mix"
        }
    }
}

