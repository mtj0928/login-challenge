//
//  ApplicationViewResolver.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import UIKit

import ViewBuilders
import Interactors
import Entities
import Routers

class ApplicationViewResolver: ViewResolver {

    private let environment: MockEnvironment

    init(_ environment: MockEnvironment) {
        self.environment = environment
    }

    @MainActor
    func resolve(for type: ViewType) -> UIViewController {
        switch type {
        case .login: return LoginViewBuilder<LoginUseCase>.resolve(environment)
        case .home: return HomeViewBuilder<HomeUseCase>.resolve(environment)
        }
    }
}
