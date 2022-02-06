//
//  LoginViewBuilder.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import UIKit

import Interactors
import Presenters
import Routers

import VIPERKit
import Views

public enum LoginViewBuilder<Interactor: AuthenticationUseCaseProtocol> {

    public struct Dependency {
        public let routerEnvironment: RouterEnvirnonment

        public init(_ environment: RouterEnvirnonment) {
            self.routerEnvironment = environment
        }
    }

    @MainActor
    public static func resolve(_ dependency: Dependency) -> UIViewController {
        let viewModel = PresenterBuilder<LoginViewModel<Interactor>>.create()
            .interactor(())
            .router(dependency.routerEnvironment)
            .build(())
        let viewController = LoginViewController(viewModel)
        viewModel.setToRouter(viewController)
        return viewController
    }
}
