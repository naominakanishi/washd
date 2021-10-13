import Foundation
struct WashingTag: Codable, Equatable, Hashable {
    let imageNames: [String]
    let name: String
    let category: TagCategory
    static func ==(_ lhs: WashingTag, _ rhs: WashingTag) -> Bool {
        lhs.category == rhs.category
    }
    
    var isBlocker: Bool {
        imageNames.allSatisfy { !$0.contains("not") }
    }
}
