import UIKit

protocol FabricViewDelegate: AnyObject {
    func updateNavigation(shouldPresent: Bool)
    func searchTextDidChange(_ newText: String?)
}

final class FabricView: UIView {
    // MARK: - Inner properties
    
    enum PresentaionState {
        case minimized, open
        var opposite: PresentaionState {
            switch self {
                case .minimized: return .open
                case .open: return .minimized
            }
        }
    }
    
    // MARK: - Properties
    
    private var presentationState: PresentaionState = .minimized
    
    // MARK: - Presentation animation properties
    
    private var transitionAnimator: UIViewPropertyAnimator!
    private var presentationProgress: CGFloat = 0
//    private var basketBottomConstraint: NSLayoutConstraint?
    private var fabricTopConstraint: NSLayoutConstraint?
    
    // MARK: - Presentation constants
    
    private lazy var DEFAULT_BOTTOM_CONSTANT: CGFloat = -7 * self.frame.height / 8
    private lazy var EXPANDED_BOTTOM_CONSTRAINT: CGFloat =  -100
    
    // MARK: - Components
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        return view
    }()

    private lazy var searchBar: SearchBar = {
        let view = SearchBar()
        view.textDidChange = { [weak self] in
            self?.delegate?.searchTextDidChange($0)
        }
        return view
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(FilterTypeCell.self, forCellWithReuseIdentifier: "FilterTypeCell")
        view.backgroundColor = .clear
        view.allowsMultipleSelection = true
        return view
    }()
    
    private lazy var fabricCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FabricCell.self)
        collectionView.backgroundColor = .clear
        layout.sectionInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    // MARK: - Dependencies
    
    weak var delegate: FabricViewDelegate?
    
    // MARK: - Initialization
    
    init(fabricDelegate: UICollectionViewDelegate,
         fabricDataSource: UICollectionViewDataSource,
         filterDelegate: UICollectionViewDelegate,
         filterDataSource: UICollectionViewDataSource,
//         basketView: BasketView,
         frame: CGRect = .zero
    ) {
//        self.basketView = basketView
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        fabricCollectionView.dataSource = fabricDataSource
        fabricCollectionView.delegate = fabricDelegate
        filterCollectionView.delegate = filterDelegate
        filterCollectionView.dataSource = filterDataSource
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    private func addSubviews() {
        addSubviews(
            backgroundImage,
            fabricCollectionView,
            filterCollectionView,
            searchBar)
    }
    
    private func constraintSubviews() {
        let topConstraint = searchBar.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor
        )
        
        searchBar.layout {
            topConstraint
            $0.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20)
            $0.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20)
        }
        
        filterCollectionView.layout { filterCollectionView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 20
            )
            $0.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: 20)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.heightAnchor.constraint(equalToConstant: 50)
        }
        
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        fabricCollectionView.layout(using: [
            fabricCollectionView.topAnchor.constraint(
                equalTo: filterCollectionView.bottomAnchor,
                constant: 20
            ),
            fabricCollectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 30
            ),
            fabricCollectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            fabricCollectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30
            ),
        ])
        self.fabricTopConstraint = topConstraint
    }
    
    func reloadCloset() {
        fabricCollectionView.reloadData()
    }
    
    func reloadFilter() {
        filterCollectionView.reloadData()
    }
}

private class InsetTextField: UITextField {
    var insets: UIEdgeInsets

    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("not intended for use from a NIB")
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
         return super.textRect(forBounds: bounds.inset(by: insets))
    }
 
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return super.editingRect(forBounds: bounds.inset(by: insets))
    }
}