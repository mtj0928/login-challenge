//
//  LoginViewBuilder.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import UIKit

import Views
import Interactors
import Presenters
import Routers

import VIPERKit

public enum LoginViewBuilder<Interactor: LoginUseCaseProtocol> {

    @MainActor
    public static func resolve(_ dependency: ApplicationEnvironment) -> UIViewController {
        let viewModel = PresenterBuilder<LoginViewModel<Interactor>>.create()
            .interactor(dependency)
            .router(dependency)
            .build(noDependency)
        let viewController = LoginViewController(viewModel)
        viewModel.setToRouter(viewController)
        return viewController
    }
}
