import Foundation

struct Closet {
    let clothes: [Clothing]
}

struct Clothing {
    let name: String
    let image: String
    let type: ClothingType
    let color: ClothingColor
    let nfcTagId: UUID?
    let washingTags: [WashingTag]
}
