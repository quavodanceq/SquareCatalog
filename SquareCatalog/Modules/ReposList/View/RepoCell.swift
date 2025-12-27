//
//  RepoCell.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

final class RepoCell: UITableViewCell {
    
    static let reuseIdentifier = "RepoCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let languageIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.left.slash.chevron.right"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let languageBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    private let starsIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let forksIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "tuningfork"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let forksLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    private let forksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 14
        return stackView
    }()
    
    private let topRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    private let titleToDescriptionSpacing: CGFloat = 8
    private let oneLineDescriptionToStatsSpacing: CGFloat = 8
    private let twoLineDescriptionToStatsSpacing: CGFloat = 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with repo: Repo) {
        nameLabel.text = repo.name
        descriptionLabel.text = (repo.description?.isEmpty == false) ? repo.description : "No description"
        
        let languageText = repo.language?.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasLanguage = (languageText?.isEmpty == false)
        languageBadgeView.isHidden = !hasLanguage
        languageLabel.text = languageText
        if let languageText,
           !languageText.isEmpty,
           let languageImage = UIImage(named: languageText) {
            languageIconImageView.image = languageImage
            languageIconImageView.tintColor = nil
        } else {
            languageIconImageView.image = UIImage(systemName: "chevron.left.slash.chevron.right")
            languageIconImageView.tintColor = .secondaryLabel
        }
        starsLabel.text = formatCount(repo.stargazersCount)
        forksLabel.text = formatCount(repo.forksCount)

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateAdaptiveSpacing()
    }

    private func updateAdaptiveSpacing() {
        let availableWidth = descriptionLabel.bounds.width
        guard availableWidth > 0 else { return }

        let text = descriptionLabel.text ?? ""
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            contentStackView.setCustomSpacing(oneLineDescriptionToStatsSpacing, after: descriptionLabel)
            return
        }

        let singleLineHeight = descriptionLabel.font.lineHeight
        let boundingRect = (trimmedText as NSString).boundingRect(
            with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: descriptionLabel.font as Any],
            context: nil
        )

        let isMultiline = boundingRect.height > (singleLineHeight * 1.2)
        let spacing = isMultiline ? twoLineDescriptionToStatsSpacing : oneLineDescriptionToStatsSpacing
        contentStackView.setCustomSpacing(spacing, after: descriptionLabel)
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let totalHorizontalInsets: CGFloat = 16 + 16 + 14 + 14
        let availableWidth = max(0, targetSize.width - totalHorizontalInsets)
        updateAdaptiveSpacing(availableWidth: availableWidth)
        return super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
    }

    private func updateAdaptiveSpacing(availableWidth: CGFloat) {
        guard availableWidth > 0 else { return }
        let text = descriptionLabel.text ?? ""
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            contentStackView.setCustomSpacing(oneLineDescriptionToStatsSpacing, after: descriptionLabel)
            return
        }
        let singleLineHeight = descriptionLabel.font.lineHeight
        let boundingRect = (trimmedText as NSString).boundingRect(
            with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: descriptionLabel.font as Any],
            context: nil
        )
        let isMultiline = boundingRect.height > (singleLineHeight * 1.2)
        let spacing = isMultiline ? twoLineDescriptionToStatsSpacing : oneLineDescriptionToStatsSpacing
        contentStackView.setCustomSpacing(spacing, after: descriptionLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        languageLabel.text = nil
        languageBadgeView.isHidden = true
        starsLabel.text = nil
        forksLabel.text = nil
    }
    
    private func formatCount(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        if value >= 1_000_000 {
            let millions = Double(value) / 1_000_000.0
            return "\(formatter.string(from: NSNumber(value: millions)) ?? "\(millions)")M"
        } else if value >= 1_000 {
            let thousands = Double(value) / 1_000.0
            return "\(formatter.string(from: NSNumber(value: thousands)) ?? "\(thousands)")K"
        } else {
            return "\(value)"
        }
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)
        setupLanguageViews()
        setupNameLabel()
        setupTopRowStack()
        setupStack()
        languageBadgeView.isHidden = true
        setupConstraints()
    }
    
    private func setupLanguageViews() {
        languageStackView.addArrangedSubview(languageIconImageView)
        languageStackView.addArrangedSubview(languageLabel)
        languageBadgeView.addSubview(languageStackView)
        languageBadgeView.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setupNameLabel() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func setupTopRowStack() {
        topRowStackView.addArrangedSubview(nameLabel)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        topRowStackView.addArrangedSubview(spacerView)
        topRowStackView.addArrangedSubview(languageBadgeView)
    }
    
    private func setupStack() {
        starsStackView.addArrangedSubview(starsIconImageView)
        starsStackView.addArrangedSubview(starsLabel)
        forksStackView.addArrangedSubview(forksIconImageView)
        forksStackView.addArrangedSubview(forksLabel)
        statsStackView.addArrangedSubview(starsStackView)
        statsStackView.addArrangedSubview(forksStackView)
        contentStackView.addArrangedSubview(topRowStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(statsStackView)
        contentStackView.setCustomSpacing(titleToDescriptionSpacing, after: topRowStackView)
        cardView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        languageIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            languageIconImageView.widthAnchor.constraint(equalToConstant: 16),
            languageIconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        languageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            languageStackView.topAnchor.constraint(equalTo: languageBadgeView.topAnchor, constant: 6),
            languageStackView.leadingAnchor.constraint(equalTo: languageBadgeView.leadingAnchor, constant: 8),
            languageStackView.trailingAnchor.constraint(equalTo: languageBadgeView.trailingAnchor, constant: -8),
            languageStackView.bottomAnchor.constraint(equalTo: languageBadgeView.bottomAnchor, constant: -6),
        ])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
        ])
    }
}
