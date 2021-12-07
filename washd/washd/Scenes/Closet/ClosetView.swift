import UIKit

protocol ClosetViewDelegate: AnyObject {
    func updateNavigation(shouldPresent: Bool)
}

final class ClosetView: UIView {
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
    
    private lazy var closetCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ClothesCell.self, forCellWithReuseIdentifier: "ClothesCell")
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    // MARK: - Dependencies
    weak var delegate: ClosetViewDelegate?
    private let basketView: BasketView
    
    // MARK: - Initialization
    init(delegate: UICollectionViewDelegate,
         dataSource: UICollectionViewDataSource,
         basketView: BasketView,
         frame: CGRect = .zero
    ) {
        self.basketView = basketView
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        closetCollectionView.dataSource = dataSource
        closetCollectionView.delegate = delegate
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
        addSubviews(backgroundImage, closetCollectionView, basketView)
    }
    
    private func constraintSubviews() {
        closetTopConstraint = closetCollectionView.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor
        )
        
        backgroundImage.layout(using: [
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        closetCollectionView.layout(using: [
            closetTopConstraint!,
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
    }
    
    func reloadData() {
        closetCollectionView.reloadData()
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
