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
        washes = AggregatedGenerator(
            from: ColorGenerator(),
            to: TagGenerator()
        ).modify(basket: clothes)
            .map {
                .init(
                    clothes: $0.unique
                )
            }
        notificationCenter.post(name: basketDidChangeNotification, object: nil)
    }
}

protocol BasketModifier {
    func modify(basket: [Clothing]) -> [[Clothing]]
}

struct ColorGenerator: BasketModifier {
    func modify(basket: [Clothing]) -> [[Clothing]] {
        basket
            .map { $0.color }
            .unique
            .map { color in basket.filter { color == $0.color }.unique }
    }
}

struct TagGenerator: BasketModifier {
    func modify(basket: [Clothing]) -> [[Clothing]] {
        var clothing: [[Clothing]] = []
        for possibility in basket.unique.permutations() {
            for clothing in possibility {
                let descriptors = clothing.washingTags.map { $0.blockingDescriptor }
                let allBlockers = possibility
                    .excluding(clothing)
                    .flatMap { $0.washingTags.flatMap { $0.blockingDescriptor } }
                if allBlockers.containsAny(descriptors) { continue }
            }
            clothing.append(possibility)
        }
        return clothing
    }
}

struct AggregatedGenerator: BasketModifier {
    let from: BasketModifier
    let to: BasketModifier
    func modify(basket: [Clothing]) -> [[Clothing]] {
        from.modify(basket: basket)
            .map { to.modify(basket: $0.unique).flatMap { $0 } }
            .filter { !$0.isEmpty }
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

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
    
    func between(x: Element, _ ys: [Element]) -> [[Element]] {
        guard let (head, tail) = ys.decompose() else { return [[x]] }
        return [[x] + ys] + between(x: x, tail).map { [head] + $0 }
    }

    func permutations(xs: [Element]? = nil) -> [[Element]] {
        let xs = xs ?? self
        guard let (head, tail) = xs.decompose() else { return [[]] }
        return permutations(xs: tail).flatMap { between(x: head, $0) }
    }
}
