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
    
    private lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isDirectionalLockEnabled = true
        view.delegate = self
        view.isDirectionalLockEnabled = true
        return view
    }()
    
    private lazy var clothingInfoTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .singleLine
        return view
    }()
    
    private lazy var clothingPhoto: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
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
        self.addSubview(contentScrollView)
        
        contentScrollView.addSubview(clothingPhoto)
    }
    
    func constraintSubviews() {
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentScrollView.layout(using: [
            contentScrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            contentScrollView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            contentScrollView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
        
        clothingPhoto.layout(using: [
            clothingPhoto.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            clothingPhoto.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            clothingPhoto.heightAnchor.constraint(equalTo: clothingPhoto.widthAnchor, multiplier: 281/310),
            clothingPhoto.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

