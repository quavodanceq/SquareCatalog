//
//  PrimaryChevronButton.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import UIKit

final class PrimaryChevronButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "")
    }
    
    private func configure(title: String) {
        semanticContentAttribute = .forceLeftToRight
        
        var configuration = UIButton.Configuration.filled()
        
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.font: titleFont])
        )
        
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        
        // Высота кнопки (меняй top/bottom)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        
        // Иконка чуть меньше, “как заглавная буква”
        let chevronFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        configuration.image = UIImage(systemName: "chevron.right")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: chevronFont))
        
        // Важно: оставляем центрирование, но позицию иконки поправим вручную ниже
        configuration.titleAlignment = .center
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        
        self.configuration = configuration
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        
        let trailingInset = configuration?.contentInsets.trailing ?? 0
        let rightEdge = bounds.width - trailingInset
        
        // Иконку ставим в центр пространства между концом текста и правым краем
        let minGapAfterText: CGFloat = 10
        let availableSpace = max(0, rightEdge - (titleLabel.frame.maxX + minGapAfterText))
        let desiredCenterX = titleLabel.frame.maxX + minGapAfterText + (availableSpace / 2)
        
        // Кламп, чтобы иконка не вылезала за край
        let halfIconWidth = imageView.bounds.width / 2
        let clampedCenterX = min(max(desiredCenterX, titleLabel.frame.maxX + minGapAfterText + halfIconWidth),
                                 rightEdge - halfIconWidth)
        
        imageView.center = CGPoint(x: clampedCenterX, y: imageView.center.y)
    }
}
