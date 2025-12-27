//
//  ViewController.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

class ReposListViewController: View<RepoListState, RepoListAction, RepoListSegue> {
    
    private let tableView = UITableView()
    private let loadingOverlay = LoadingOverlayView()
    private let refreshControl = UIRefreshControl()
    
    private var isShowingErrorAlert = false
    private var didForceInitialLayout = false
    private var previousRepos: [Repo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        title = "Square Catalog"
        navigationItem.largeTitleDisplayMode = .always
        setupTableView()
        setupLoadingOverlay()
        setupConstraints()
        viewModel?.dispatch(action: .view(.didLoad))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didForceInitialLayout else { return }
        didForceInitialLayout = true
        tableView.performBatchUpdates(nil)
    }
    
    override func update(with state: RepoListState) {
        loadingOverlay.setLoading(state.isLoading || state.isRefreshing)

        if state.repos != previousRepos {
            previousRepos = state.repos
            tableView.reloadData()
        }

        guard let message = state.errorMessage, !message.isEmpty else { return }
        guard !isShowingErrorAlert else { return }
        isShowingErrorAlert = true
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.isShowingErrorAlert = false
            self?.viewModel?.dispatch(action: .retry)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.isShowingErrorAlert = false
        })
        present(alert, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
    }

    @objc private func refreshControlValueChanged() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        viewModel?.dispatch(action: .refresh)
    }
    
    private func setupLoadingOverlay() {
        view.addSubview(loadingOverlay)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ReposListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state?.repos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseIdentifier, for: indexPath) as? RepoCell,
            let repo = state?.repos[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configure(with: repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repo = state?.repos[indexPath.row] else { return }
        viewModel?.routing(.details(repo))
    }
}

