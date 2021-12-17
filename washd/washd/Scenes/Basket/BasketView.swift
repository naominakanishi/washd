import UIKit

final class BasketView: UIView {
    
    // MARK: - Properties
    
    var washes: [Wash] = []
    var openInstructions: ((Wash) -> Void)?
    
    // MARK: - Components
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wash-icon")
        return view
    }()
    
    private lazy var washesTableView: UITableView = {
        let view = UITableView()
        view.register(WashViewCell.self, forCellReuseIdentifier: "WashCell")
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.estimatedRowHeight = UITableView.automaticDimension
        return view
    }()
    
    private lazy var badgeView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .washdColors.vividSkyBlue
        view.isHidden = true
        
        return view
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
    
        label.textColor = .white
        label.font = .appFont.montserrat(.semiBold, 12).uiFont
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureLayer()
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    
    func set(washes: [Wash]) {
        self.washes = washes
        washesTableView.reloadData()
    }
    
    func badge(count: Int) {
        badgeView.isHidden = count < 1
        badgeLabel.text = "\(count)"
        
        layoutIfNeeded()
        badgeView.layer.cornerRadius = badgeView.frame.height / 2
    }
    
    // MARK: - View lifecycle
    
    private func addSubviews() {
        addSubviews(imageView, washesTableView, badgeView)
        badgeView.addSubview(badgeLabel)
    }
    
    private func constraintSubviews() {
        imageView.layout(using: [
            imageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -20),
            imageView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(
                equalToConstant: 73),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor)
        ])
        washesTableView.layout(using: [
            washesTableView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 12),
            washesTableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 10),
            washesTableView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10),
            washesTableView.bottomAnchor.constraint(
                equalTo: bottomAnchor),
        ])
        badgeView.layout(using: [
            badgeView.centerXAnchor.constraint(
                equalTo: imageView.trailingAnchor),
            badgeView.centerYAnchor.constraint(
                equalTo: imageView.topAnchor),
            badgeView.widthAnchor.constraint(
                equalTo: badgeView.heightAnchor)
        ])
        
        badgeLabel.layout(using: [
            badgeLabel.topAnchor.constraint(
                equalTo: badgeView.topAnchor,
                constant: 4),
            badgeLabel.centerXAnchor.constraint(
                equalTo: badgeView.centerXAnchor),
            badgeLabel.bottomAnchor.constraint(
                equalTo: badgeView.bottomAnchor,
                constant: -4),
        ])
    }
    
    private func configureLayer() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 289.9, y: 69.3))
        path.addCurve(
            to: CGPoint(x: 260.4, y: 64),
            controlPoint1: CGPoint(x: 279.9, y: 69.3),
            controlPoint2: CGPoint(x: 269.9, y: 67.6))
        path.addCurve(
            to: CGPoint(x: 254.3, y: 61.5),
            controlPoint1: CGPoint(x: 258.4, y: 63.3),
            controlPoint2: CGPoint(x: 256.4, y: 62.5))
        path.addCurve(
            to: CGPoint(x: 241.6, y: 54.9),
            controlPoint1: CGPoint(x: 250, y: 59.6),
            controlPoint2: CGPoint(x: 245.7, y: 57.4))
        path.addCurve(
            to: CGPoint(x: 234.7, y: 49.7),
            controlPoint1: CGPoint(x: 239.2, y: 53.4),
            controlPoint2: CGPoint(x: 236.9, y: 51.6))
        path.addCurve(
            to: CGPoint(x: 208.5, y: 40),
            controlPoint1: CGPoint(x: 227.6, y: 43.2),
            controlPoint2: CGPoint(x: 218.2, y: 39.7))
        path.addCurve(
            to: CGPoint(x: 182.8, y: 51),
            controlPoint1: CGPoint(x: 198.8, y: 40.2),
            controlPoint2: CGPoint(x: 189.6, y: 44.2))
        path.addCurve(
            to: CGPoint(x: 170.8, y: 59.9),
            controlPoint1: CGPoint(x: 179.3, y: 54.6),
            controlPoint2: CGPoint(x: 175.2, y: 57.6))
        path.addCurve(
            to: CGPoint(x: 167.3, y: 61.5),
            controlPoint1: CGPoint(x: 169.7, y: 60.5),
            controlPoint2: CGPoint(x: 168.5, y: 61))
        path.addCurve(
            to: CGPoint(x: 159.3, y: 64.7),
            controlPoint1: CGPoint(x: 164.6, y: 62.7),
            controlPoint2: CGPoint(x: 161.9, y: 63.7))
        path.addCurve(
            to: CGPoint(x: 131.8, y: 69.3),
            controlPoint1: CGPoint(x: 150.4, y: 67.8),
            controlPoint2: CGPoint(x: 141.1, y: 69.3))
        path.close()

        
        shapeLayer.frame.origin.y -= 69.3
        shapeLayer.frame.origin.x -= 13.5
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = path.cgPath
        
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = .init(width: 0, height: -6)
        shapeLayer.shadowRadius = 3
        shapeLayer.shadowOpacity = 0.05
        
        layer.addSublayer(shapeLayer)
        
        layer.shadowColor = shapeLayer.shadowColor
        layer.shadowOffset = shapeLayer.shadowOffset
        layer.shadowRadius = shapeLayer.shadowRadius
        layer.shadowOpacity = shapeLayer.shadowOpacity
    }
    
    private func configureAdditionalSettings() {
        backgroundColor = .white
    }
}

extension BasketView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        washes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "WashCell",
            for: indexPath
        ) as? WashViewCell
        else { return .init() }
        let wash = washes[indexPath.row]
        cell.configure(using: wash)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wash = washes[indexPath.row]
        openInstructions?(wash)
    }
}
