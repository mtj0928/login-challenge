//
//  MockEnvironment.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation

import Interactors
import Routers
import Entities


class MockEnvironment: RouterEnvirnonment, InteractorEnvironment {

    var viewResolver: ViewResolver {
        ApplicationViewResolver(self)
    }

    let services: Services = MockServices()
}

class MockServices: Services {

    var auth: AuthServiceProtocol.Type {
        AuthMockService.self
    }

    var user: UserServiceProtocol.Type {
        UserMockService.self
    }
}

class AuthMockService: AuthServiceProtocol {
    static func logInWith(id: String, password: String) async throws {
    }

    static func logOut() async {
    }
}

class UserMockService: UserServiceProtocol {
    static func currentUser() async throws -> User {
        User(id: "matsuji", name: "まつじ", introduction: "奈良出身")
    }
}
