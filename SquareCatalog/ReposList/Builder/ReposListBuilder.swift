//
//  ReposListBuilder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

class ReposListBuilder: BuilderType {
    typealias Segue = RepoListSegue
    typealias Product = ReposListViewController
    
    private var routing: ((RepoListSegue) -> Void)?
    
    func register(routing: @escaping (RepoListSegue) -> Void) {
        self.routing = routing
    }
    
    func make() -> ReposListViewController {
        let vc = ReposListViewController()
        let viewModel = ReposListViewModel(state: .initial, routing: routing ?? { _ in })
        vc.bind(to: viewModel)
        return vc
    }
}
