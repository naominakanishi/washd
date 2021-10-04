import Foundation
final class ClosetDatabase {
    private let userDefaults = UserDefaults.standard
    
    static let instance = ClosetDatabase()
    
    private init() {}
    
    func closet() -> Closet {
        guard let stored = userDefaults.data(forKey: "closet"),
              let decoded = try? JSONDecoder().decode(Closet.self, from: stored)
        else { return .init(clothes: []) }
        return decoded
    }
    
    func add(clothing: Clothing) {
        var closet = closet()
        closet.clothes.append(clothing)
        set(closet: closet)
    }
    
    func set(closet: Closet) {
        guard let data = try? JSONEncoder().encode(closet)
        else { return }
        userDefaults.set(data, forKey: "closet")
    }
}
