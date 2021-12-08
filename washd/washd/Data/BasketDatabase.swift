import Foundation

@objc
protocol BasketListener {
    func onWashDidChange(_ notification: Notification)
}

final class BasketDatabase {
    // MARK: - Shared instance
    
    static let shared = BasketDatabase()
    
    // MARK: - Properties
    
    private let basketDidChangeNotification = NSNotification.Name("basketDidChange")
    private let notificationCenter = NotificationCenter()
    private var clothes: [Clothing] = []
    private(set) var washes: [Wash] = []
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public API
    
    func add(clothing: Clothing) {
        clothes.append(clothing)
        generateWashes()
    }
    
    func remove(clothing: Clothing) {
        guard let index = clothes.firstIndex(of: clothing)
        else { return }
        clothes.remove(at: index)
        generateWashes()
    }
    
    func observe(_ listener: BasketListener) {
        notificationCenter.addObserver(
            listener,
            selector: #selector(listener.onWashDidChange(_:)),
            name: basketDidChangeNotification, object: nil)
    }
    
    func remove(observer: BasketListener) {
        notificationCenter.removeObserver(observer)
    }
    
    // MARK: - Private methods
    
    private func generateWashes() {
        self.washes.removeAll()
        washes = clothes
            .map(generateWash)
        
//        for wash in washes {
//            if self.washes.contains(where: { $0.clothes.unique() == wash.clothes.unique() }) { continue }
//            self.washes.append(wash)
//        }
        notificationCenter.post(name: basketDidChangeNotification, object: nil)
    }
    
    private func generateWash(for piece: Clothing) -> Wash {
        .init(
            clothes: clothes
                .filter { $0.washingTags.containsAny(piece.washingTags) },
            name: "Sugestão \(washes.count + 1)")
    }
}

extension Collection where Element: Equatable {
    func containsAny(_ elements: [Element]) -> Bool {
        for element in self {
            if elements.contains(element) {
                return true
            }
        }
        return false
    }
}
