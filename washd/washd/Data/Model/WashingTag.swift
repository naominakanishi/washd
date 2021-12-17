import Foundation
struct WashingTag: Codable, Equatable, Hashable {
    let imageNames: [String]
    let name: String
    let category: TagCategory
    let blockingDescriptor: TagBlocker
    static func ==(_ lhs: WashingTag, _ rhs: WashingTag) -> Bool {
        lhs.category == rhs.category
    }
}
