import UIKit

final class BasketView: UIView {
    
    // MARK: - Properties
    
    var washes: [Wash] = []
    var openInstructions: ((Wash) -> Void)?
    
    // MARK: - Components
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wash-icon")
        view.alpha = 1
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
                constant: -35),
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
    
    override func draw(_ rect: CGRect) {
        configureLayer()
    }
    
    private func configureLayer() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        let imageCenter = imageView.frame.center
        let imageRadius = imageView.frame.width / 2 + 6
        let circleOpening: CGFloat = .pi / 3
        let startAngle: CGFloat =  -.pi / 2 + circleOpening
        let endAngle: CGFloat = -.pi / 2 - circleOpening
        let tailLenght: CGFloat = frame.size.width * 0.3
        
        
        let pA = CGPoint(
            x: imageCenter.x + imageRadius * cos(endAngle),
            y: imageCenter.y + imageRadius * sin(endAngle)
        )
        let pB = CGPoint(
            x: imageCenter.x + imageRadius * cos(startAngle),
            y: imageCenter.y + imageRadius * sin(startAngle)
        )
        
        path.move(to: imageCenter)
        path.moveBy(x: -tailLenght)
        path.addQuadCurve(
            to: pA,
            controlPoint: imageCenter.translating(x: -imageRadius))
        path.addLine(to: .init(x: path.currentPoint.x, y: imageCenter.y))
        path.close()
        
        path.move(to: imageCenter)
        path.addArc(
            withCenter: imageCenter,
            radius: imageRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        path.move(to: pA)
        path.addLine(to: .init(x: path.currentPoint.x, y: imageCenter.y))
        path.addLine(to: path.currentPoint.translating(x: imageRadius * 2))
        path.addLine(to: pB)
        path.close()
        
        
        path.move(to: imageCenter)
        path.moveBy(x: tailLenght)
        path.addQuadCurve(
            to: pB,
            controlPoint: imageCenter.translating(x: imageRadius))
        path.addLine(to: .init(x: path.currentPoint.x, y: imageCenter.y))
        path.close()
        
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
        
        bringSubviewToFront(imageView)
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

extension UIBezierPath {
    func moveBy(x: CGFloat = 0, y: CGFloat = 0) {
        move(to: .init(x: currentPoint.x + x, y: currentPoint.y + y))
    }
}

extension CGRect {
    var center: CGPoint { .init(x: midX, y: midY) }
}

extension CGPoint {
    func translating(x xOffset: CGFloat = 0, y yOffset: CGFloat = 0) -> Self {
        .init(
            x: x + xOffset,
            y: y + yOffset)
    }
}


extension UIBezierPath {
    func addDebugCircle() {
        addArc(
            withCenter: currentPoint,
            radius: 8,
            startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }
}
