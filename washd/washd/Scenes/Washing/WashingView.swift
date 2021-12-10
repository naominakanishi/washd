import UIKit

protocol WashingViewDelegate: AnyObject {
    func updateNavigation(shouldPresent: Bool)
    func searchTextDidChange(_ newText: String?)
}

final class WashingView: UIView {
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
    private var basketBottomConstraint: NSLayoutConstraint?
    private var closetTopConstraint: NSLayoutConstraint?
    
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
    
    private lazy var closetCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WashingCell.self, forCellWithReuseIdentifier: "ClothesCell")
        collectionView.register(ClosetHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ClosetHeaderView")
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        layout.sectionInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    // MARK: - Dependencies
    
    weak var delegate: WashingViewDelegate?
    private let basketView: BasketView
    
    // MARK: - Initialization
    
    init(closetDelegate: UICollectionViewDelegate,
         closetDataSource: UICollectionViewDataSource,
         filterDelegate: UICollectionViewDelegate,
         filterDataSource: UICollectionViewDataSource,
         basketView: BasketView,
         frame: CGRect = .zero
    ) {
        self.basketView = basketView
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        closetCollectionView.dataSource = closetDataSource
        closetCollectionView.delegate = closetDelegate
        filterCollectionView.delegate = filterDelegate
        filterCollectionView.dataSource = filterDataSource
        backgroundColor = .white
    
        basketView.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    private func addSubviews() {
        addSubviews(
            backgroundImage,
            closetCollectionView,
            basketView,
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
        
        closetCollectionView.layout(using: [
            closetCollectionView.topAnchor.constraint(
                equalTo: filterCollectionView.bottomAnchor,
                constant: 20
            ),
            closetCollectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 30
            ),
            closetCollectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            closetCollectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30
            ),
        ])
        
        basketBottomConstraint = basketView.topAnchor.constraint(
            equalTo: bottomAnchor,
            constant: EXPANDED_BOTTOM_CONSTRAINT)
        basketView.layout(using: [
            basketView.leadingAnchor.constraint(
                equalTo: leadingAnchor),
            basketView.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            basketView.bottomAnchor.constraint(
                equalTo: bottomAnchor),
            basketBottomConstraint!
        ])
        
        self.closetTopConstraint = topConstraint
    }
    
    func reloadCloset() {
        closetCollectionView.reloadData()
    }
    
    func reloadFilter() {
        filterCollectionView.reloadData()
    }
    
    @objc func handlePanGesture(_ sender: Any?) {
        guard let recognizer = sender as? UIPanGestureRecognizer
        else { return }
        switch recognizer.state {
        case .began:
            updateUIState(to: self.presentationState.opposite)
            presentationProgress = transitionAnimator.fractionComplete
            transitionAnimator.pauseAnimation()
            self.updateNavigation(shouldPresent: presentationState == .open)
        case .changed:
            let translation = recognizer.translation(in: self)
            var fraction = -translation.y / DEFAULT_BOTTOM_CONSTANT
            if self.presentationState == .open { fraction *= -1 }
            transitionAnimator.fractionComplete = fraction + presentationProgress
        case .ended:
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
        
    }
    
    func updateUIState(to state: PresentaionState, duration: TimeInterval = 1){
        
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.basketBottomConstraint?.constant = self.EXPANDED_BOTTOM_CONSTRAINT
            case .minimized:
                self.basketBottomConstraint?.constant = self.DEFAULT_BOTTOM_CONSTANT
            }
            self.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.presentationState = state.opposite
            case .end:
                self.presentationState = state
            case .current:
                ()
            }
            switch self.presentationState {
            case .open:
                self.basketBottomConstraint?.constant = self.EXPANDED_BOTTOM_CONSTRAINT
            case .minimized:
                self.basketBottomConstraint?.constant = self.DEFAULT_BOTTOM_CONSTANT
            }
            
            self.updateNavigation(shouldPresent: self.presentationState == .minimized)
        }
        transitionAnimator.startAnimation()
        self.endEditing(true)
    }
    
    private func updateNavigation(shouldPresent: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.closetTopConstraint?.constant = shouldPresent ? 500 : 0
            self.layoutIfNeeded()
        }
        self.delegate?.updateNavigation(shouldPresent: shouldPresent)
    }
}

final class SearchBar: UIView {
    private lazy var textField: UITextField = {
        let view = InsetTextField(insets: .init(top: 0, left: 8, bottom: 0, right: 0))
        view.font = .appFont.montserrat(.regular, 18).uiFont
        view.placeholder = "Buscar"
        view.addTarget(
            self,
            action: #selector(handleTextChange),
            for: .editingChanged)
        return view
    }()
    
    private lazy var magnifyingGlassIcon: UIImageView = {
        let view = UIImageView()
        view.image = .add.withRenderingMode(.alwaysTemplate)
        view.tintColor = .washdColors.text
        return view
    }()
    
    var textDidChange: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        backgroundColor = .white
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubviews(textField,
                    magnifyingGlassIcon)
    }
    
    func constraintSubviews() {
        textField.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: magnifyingGlassIcon.leadingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
        
        magnifyingGlassIcon.layout {
            $0.widthAnchor.constraint(equalToConstant: 24)
            $0.heightAnchor.constraint(equalToConstant: 24)
            $0.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8)
            $0.centerYAnchor.constraint(equalTo: centerYAnchor)
            $0.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8)
            $0.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8)
        }
    }
    
    @objc
    private func handleTextChange() {
        textDidChange?(textField.text)
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
