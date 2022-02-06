//
//  PresenterBuilder.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation

public enum PresenterBuilder<Presenter: PresenterProtocol> {

    public static func create() -> _PresenterBuilder<Presenter, Presenter.Interactor.Dependency?, Presenter.Router.Dependency?> {
        .init(interactorDependency: nil, routerDependency: nil)
    }
}

public struct _PresenterBuilder<Presenter: PresenterProtocol, T, U> {
    private let interactorDependency: T
    private let routerDependency: U

    fileprivate init(
        interactorDependency: T,
        routerDependency: U
    ) {
        self.interactorDependency = interactorDependency
        self.routerDependency = routerDependency
    }

    public func interactor(_ dependency: Presenter.Interactor.Dependency) -> _PresenterBuilder<Presenter, Presenter.Interactor.Dependency, U> where T == Presenter.Interactor.Dependency? {
        .init(interactorDependency: dependency, routerDependency: routerDependency)
    }

    public func router(_ dependency: Presenter.Router.Dependency) -> _PresenterBuilder<Presenter, T, Presenter.Router.Dependency> where U == Presenter.Router.Dependency? {
        .init(interactorDependency: interactorDependency, routerDependency: dependency)
    }

    public func build(_ dependency: Presenter.Dependency) -> Presenter where T == Presenter.Interactor.Dependency, U == Presenter.Router.Dependency {
        Presenter(
            dependency,
            interactor: Presenter.Interactor(interactorDependency),
            router: Presenter.Router(routerDependency)
        )
    }
}
