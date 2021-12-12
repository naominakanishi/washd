import Foundation
import UIKit

struct Closet: Codable {
    var clothes: [Clothing]
}

struct Clothing: Codable, Equatable, Hashable {
    let name: String
    let type: ClothingType
    let color: ClothingColor
    let nfcTagId: UUID?
    let washingTags: [WashingTag]
    let description: String?
    let image: UIImage?
    
    internal init(name: String, type: ClothingType, color: ClothingColor, nfcTagId: UUID?, washingTags: [WashingTag], description: String?, image: UIImage?) {
        self.name = name
        self.type = type
        self.color = color
        self.nfcTagId = nfcTagId
        self.washingTags = washingTags
        self.description = description
        self.image = image
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(ClothingType.self, forKey: .type)
        color = try container.decode(ClothingColor.self, forKey: .color)
        nfcTagId = try container.decode(UUID?.self, forKey: .nfcTagId)
        washingTags = try container.decode([WashingTag].self, forKey: .washingTags)
        description = try container.decode(String?.self, forKey: .description)
        let imageData = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(color, forKey: .color)
        try container.encode(nfcTagId, forKey: .nfcTagId)
        try container.encode(washingTags, forKey: .washingTags)
        try container.encode(description, forKey: .description)
        try container.encode(image?.pngData(), forKey: .image)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, type, color, nfcTagId, washingTags, description, image
    }
}
