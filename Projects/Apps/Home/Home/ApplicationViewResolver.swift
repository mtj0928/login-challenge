//
//  ApplicationViewResolver.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import UIKit

import ViewBuilders
import Interactors
import Routers

class ApplicationViewResolver: ViewResolver {

    private let environment: ApplicationEnvironment

    init(_ environment: ApplicationEnvironment) {
        self.environment = environment
    }

    @MainActor
    func resolve(for type: ViewType) -> UIViewController {
        switch type {
        case .login: return LoginViewBuilder<AuthenticationUseCase>.resolve(.init(environment))
        case .home: return HomeViewBuilder.resolve(.init(environment))
        }
    }
}

class AuthenticationMockUseCase: AuthenticationUseCaseProtocol {
    func login(id: String, password: String) async throws {
    }

    func logout() async {
    }

    required init(_ dependency: ()) {
    }
}
