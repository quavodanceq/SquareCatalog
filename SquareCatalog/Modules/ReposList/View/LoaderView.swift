//
//  LoaderView.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import UIKit

final class LoaderView: UIView {
    private let text = "Loading"
    private let translateDuration: CFTimeInterval = 2.0
    private let opacityDuration: CFTimeInterval = 4.0
    private let lettersDuration: CFTimeInterval = 1.85
    private let stripeGap: CGFloat = 7
    private let stripeWidth: CGFloat = 1
    private let stack = UIStackView()
    private var letterLabels: [UILabel] = []
    private let stripesContainer = CALayer()
    private let afterLayer = CALayer()
    private let stripesMask = CAShapeLayer()
    private let ringMask = CAShapeLayer()
    
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        setupLetters()
        setupLoaderLayers()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLoaderLayers()
    }
    
    private func setupLetters() {
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .fill
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        for ch in text {
            let label = UILabel()
            label.text = String(ch)
            label.font = UIFont(name: "Poppins-SemiBold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold)
            label.textColor = .label
            label.alpha = 0
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            stack.addArrangedSubview(label)
            letterLabels.append(label)
        }
    }

    private func setupLoaderLayers() {
        layer.insertSublayer(stripesContainer, below: stack.layer)
        stripesContainer.mask = stripesMask
        stripesMask.fillColor = UIColor.black.cgColor
        stripesMask.backgroundColor = UIColor.clear.cgColor
        
        stripesContainer.addSublayer(afterLayer)
        afterLayer.mask = ringMask
        ringMask.fillRule = .evenOdd
        ringMask.fillColor = UIColor.black.cgColor
        ringMask.backgroundColor = UIColor.clear.cgColor
        
        afterLayer.contentsScale = UIScreen.main.scale
        afterLayer.contents = makeRadialBlobsImage(size: CGSize(width: 1400, height: 300))?.cgImage
        afterLayer.contentsGravity = .resizeAspectFill
        afterLayer.opacity = 0
    }
    
    private func layoutLoaderLayers() {
        stripesContainer.frame = bounds
        let extra = bounds.width * 0.9
        afterLayer.frame = bounds.insetBy(dx: -extra, dy: 0)
        updateStripesMaskPath()
        updateRingMaskPath()
    }
    
    private func updateStripesMaskPath() {
        let step = stripeGap + stripeWidth
        let path = UIBezierPath()
        var x: CGFloat = 0
        while x <= bounds.width + step {
            path.append(UIBezierPath(rect: CGRect(x: x + stripeGap, y: 0, width: stripeWidth, height: bounds.height)))
            x += step
        }
        stripesMask.path = path.cgPath
    }
    
    private func updateRingMaskPath() {
        let side = min(bounds.width, bounds.height)
        let outerRadius = side * 0.48
        let innerRadius = side * 0.20
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath()
        path.append(UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true))
        path.append(UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true))
        ringMask.path = path.cgPath
    }
    
    private func makeRadialBlobsImage(size: CGSize) -> UIImage? {
        let r = UIGraphicsImageRenderer(size: size)
        return r.image { ctx in
            let cg = ctx.cgContext
            cg.clear(CGRect(origin: .zero, size: size))
            
            func radial(center: CGPoint, color: UIColor, radius: CGFloat) {
                let colors = [color.withAlphaComponent(1).cgColor, color.withAlphaComponent(0).cgColor] as CFArray
                let locations: [CGFloat] = [0.0, 1.0]
                guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: locations) else { return }
                cg.drawRadialGradient(
                    gradient,
                    startCenter: center, startRadius: 0,
                    endCenter: center, endRadius: radius,
                    options: [.drawsAfterEndLocation]
                )
            }
            let w = size.width
            let h = size.height
            let base = min(w, h)
            radial(center: CGPoint(x: w * 0.50, y: h * 0.50), color: .yellow, radius: base * 0.50)
            radial(center: CGPoint(x: w * 0.45, y: h * 0.45), color: .red, radius: base * 0.45)
            radial(center: CGPoint(x: w * 0.55, y: h * 0.55), color: .cyan, radius: base * 0.45)
            radial(center: CGPoint(x: w * 0.45, y: h * 0.55), color: .green, radius: base * 0.45)
            radial(center: CGPoint(x: w * 0.55, y: h * 0.45), color: .blue, radius: base * 0.45)
        }
    }
    
    func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        isHidden = false
        alpha = 1
        layoutIfNeeded()
        afterLayer.removeAllAnimations()
        afterLayer.opacity = 1
        let amplitude = afterLayer.bounds.width * 0.55
        let move = CABasicAnimation(keyPath: "transform.translation.x")
        move.fromValue = -amplitude
        move.toValue = amplitude
        move.duration = translateDuration
        move.autoreverses = true
        move.repeatCount = .infinity
        move.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.8, 0.5, 1)
        let fade = CAKeyframeAnimation(keyPath: "opacity")
        fade.values = [0, 1, 0, 0]
        fade.keyTimes = [0, 0.15, 0.65, 1]
        fade.duration = opacityDuration
        fade.repeatCount = .infinity
        let group = CAAnimationGroup()
        group.animations = [move, fade]
        group.duration = opacityDuration
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.8, 0.5, 1)
        afterLayer.add(group, forKey: "loader.after")
        let baseTime = CACurrentMediaTime()
        let cycleDuration = lettersDuration
        let delays: [CFTimeInterval] = [
            0.1, 0.205, 0.31, 0.415, 0.521, 0.626, 0.731, 0.837, 0.942, 1.047
        ]
        for (idx, label) in letterLabels.enumerated() {
            label.layer.removeAllAnimations()
            label.alpha = 0
            let opacity = CAKeyframeAnimation(keyPath: "opacity")
            opacity.values = [0, 1, 0.2, 0]
            opacity.keyTimes = [0, 0.05, 0.2, 1]
            opacity.duration = cycleDuration
            opacity.repeatCount = .infinity
            let delay = idx < delays.count ? delays[idx] : (0.1 + (0.105 * Double(idx)))
            opacity.beginTime = baseTime + delay
            opacity.isRemovedOnCompletion = false
            
            let transform = CAKeyframeAnimation(keyPath: "transform")
            transform.values = [
                CATransform3DIdentity,
                CATransform3DConcat(CATransform3DMakeScale(1.1, 1.1, 1), CATransform3DMakeTranslation(0, -2, 0)),
                CATransform3DIdentity
            ]
            transform.keyTimes = [0, 0.05, 0.2]
            transform.duration = cycleDuration
            transform.repeatCount = .infinity
            transform.beginTime = opacity.beginTime
            transform.isRemovedOnCompletion = false
            let shadow = CAKeyframeAnimation(keyPath: "shadowOpacity")
            shadow.values = [0, 1, 0, 0]
            shadow.keyTimes = [0, 0.05, 0.2, 1]
            shadow.duration = cycleDuration
            shadow.repeatCount = .infinity
            shadow.beginTime = opacity.beginTime
            shadow.isRemovedOnCompletion = false
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowRadius = 6
            label.layer.shadowOffset = .zero
            label.layer.add(opacity, forKey: "letter.opacity.\(idx)")
            label.layer.add(transform, forKey: "letter.transform.\(idx)")
            label.layer.add(shadow, forKey: "letter.shadow.\(idx)")
        }
    }
    
    func stopAnimating() {
        isAnimating = false
        afterLayer.removeAnimation(forKey: "loader.after")
        afterLayer.opacity = 0
        letterLabels.forEach { $0.layer.removeAllAnimations(); $0.alpha = 0 }
        isHidden = true
    }
}
