//
//  InfoRowView.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import UIKit

final class InfoRowView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private var stack: UIStackView = UIStackView()
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        setupViews(title: title, value: value)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        self.stack.addArrangedSubview(titleLabel)
        self.stack.addArrangedSubview(valueLabel)
        stack.axis = .horizontal
        stack.spacing = 12
        addSubview(stack)
    }
    
    private func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}
