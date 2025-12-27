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
    
    func bind(to viewModel: ViewModelType)
    
    func update(with state: State)
}

open class View<State: StateType, Action: ActionType, Segue: SegueType>:
    UIViewController,
    ViewInterface
{
    public typealias ViewModelType = ViewModelInterface<State, Action, Segue>
    
    public var viewModel: ViewModelType?
    private var cancellable: AnyCancellable?
    
    public var state: State? {
        viewModel?.state
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    open func bind(to viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        cancellable = viewModel.$state
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.update(with: state)
            }
    }
    
    open func setupView() { }
    
    open func update(with state: State) { }
}
