import UIKit

class ClothingDetailView: UIView, UIScrollViewDelegate {
    
    enum LayoutMetrics {
        static let horizontalMargin: CGFloat = 30
        static let interPromptSpacing: CGFloat = 30
        static let innerPromptSpacing: CGFloat = 10
    }
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "clothing-detail-bg")
        return view
    }()
    
    lazy var clothingInfoTableView: UITableView = {
        let view = UITableView()
        view.estimatedRowHeight = 44.0
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.register(ClothingInfoCell.self)
        view.register(ClothingSymbolsCell.self)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var clothingPhoto: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(backgroundImage)
        self.addSubview(clothingInfoTableView)
        self.addSubview(clothingPhoto)
    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        clothingPhoto.layout(using: [
            clothingPhoto.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            clothingPhoto.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            clothingPhoto.heightAnchor.constraint(equalTo: clothingPhoto.widthAnchor, multiplier: 281/310),
            clothingPhoto.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
            
        clothingInfoTableView.layout {
            $0.topAnchor.constraint(equalTo: clothingPhoto.bottomAnchor, constant: 24)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
    }
    
    func set(clothingImage image: UIImage) {
        clothingPhoto.image = image
    }
}
