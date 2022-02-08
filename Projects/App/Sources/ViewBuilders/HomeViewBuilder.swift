//
//  File.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import SwiftUI

import Views
import Interactors
import Presenters
import Routers
import VIPERKit

public enum HomeViewBuilder<UseCase: HomeUseCaseProtocol> {

    @MainActor
    public static func resolve(_ dependency: ApplicationEnvironment) -> UIViewController {
        let viewModel = PresenterBuilder<HomeViewModel<UseCase>>.create()
            .interactor(dependency)
            .router(dependency)
            .build(noDependency)

        let viewController = UIHostingController(rootView: HomeView(viewModel))
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        viewModel.setToRouter(viewController)
        return viewController
    }
}
