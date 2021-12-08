import Foundation

struct Closet: Codable {
    var clothes: [Clothing]
}

struct Clothing: Codable, Equatable, Hashable {
    let name: String
    var image: Data? { nil }
    let type: ClothingType
    let color: ClothingColor
    let nfcTagId: UUID?
    let washingTags: [WashingTag]
}
