//
//  View.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit
import Combine

public protocol ViewInterface: AnyObject {
    associatedtype State: StateType
    associatedtype Action: ActionType
    associatedtype Segue: SegueType
    
    associatedtype ViewModelType: ViewModelInterface<State, Action, Segue>
    
    var viewModel: ViewModelType? { get set }
    
    /// Привязать вью к вью‑модели
    func bind(to viewModel: ViewModelType)
    
    /// Обновить UI по новому состоянию
    func update(with state: State)
}

open class View<State: StateType, Action: ActionType, Segue: SegueType>:
    UIViewController,
    ViewInterface
{
    public typealias ViewModelType = ViewModelInterface<State, Action, Segue>
    
    // MARK: - Properties
    
    public var viewModel: ViewModelType?
    private var cancellable: AnyCancellable?
    
    /// Удобно иметь доступ к текущему стейту
    public var state: State? {
        viewModel?.state
    }
    
    // MARK: - Init
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Binding
    
    open func bind(to viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        cancellable = viewModel.$state
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.update(with: state)
            }
    }
    
    // MARK: - Overridable
    
    /// Здесь настраиваешь UI (лейауты, сабвьюхи и т.д.)
    open func setupView() {
        // override in subclass
    }
    
    /// Здесь обновляется UI при изменении стейта
    open func update(with state: State) {
        // override in subclass
    }
}
