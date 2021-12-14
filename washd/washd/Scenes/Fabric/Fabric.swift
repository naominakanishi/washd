import Foundation
import UIKit

struct Fabrics {
    var fabrics: [Fabric]
}

enum FabricNature {
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

