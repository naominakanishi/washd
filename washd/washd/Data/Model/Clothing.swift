import Foundation

struct Closet: Codable {
    let clothes: [Clothing]
}

struct Clothing: Codable {
    let name: String
    let image: Data?
    let type: ClothingType
    let color: ClothingColor
    let nfcTagId: UUID?
    let washingTags: [WashingTag]
}
