//
//  RepoDetailsViewController.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import UIKit
import SafariServices

final class RepoDetailsViewController: View<RepoDetailsState, RepoDetailsAction, RepoDetailsSegue> {
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let openButton = PrimaryChevronButton(title: "Open on GitHub")
    
    private var starsRowView: InfoRowView!
    private var forksRowView: InfoRowView!
    private var issuesRowView: InfoRowView!
    private var languageRowView: InfoRowView!
    private var updatedRowView: InfoRowView!
    
    override func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        
        starsRowView = InfoRowView(title: "Stars", value: "—")
        forksRowView = InfoRowView(title: "Forks", value: "—")
        issuesRowView = InfoRowView(title: "Open issues", value: "—")
        languageRowView = InfoRowView(title: "Language", value: "—")
        updatedRowView = InfoRowView(title: "Updated", value: "—")
        
        infoStackView.addArrangedSubview(starsRowView)
        infoStackView.addArrangedSubview(forksRowView)
        infoStackView.addArrangedSubview(issuesRowView)
        infoStackView.addArrangedSubview(languageRowView)
        infoStackView.addArrangedSubview(updatedRowView)
        
        infoCardView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -16),
        ])
        
        let contentStackView = UIStackView(arrangedSubviews: [descriptionLabel, infoCardView, openButton])
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
    }
    
    override func update(with state: RepoDetailsState) {
        title = state.title
        descriptionLabel.text = (state.description?.isEmpty == false) ? state.description : "No description"
        
        starsRowView.updateValue("\(state.stars)")
        forksRowView.updateValue("\(state.forks)")
        issuesRowView.updateValue("\(state.issues)")
        languageRowView.updateValue(state.language ?? "—")
        updatedRowView.updateValue(state.updatedText)
    }
    
    @objc private func openButtonTapped() {
        viewModel?.dispatch(action: .openGitHub)
    }
}
