//
//  File.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import VIPERKit
import Entities

public protocol HomeUseCaseProtocol: InteractorProcotol where Dependency == InteractorEnvironment {
    func logout() async
    func loadUser() async throws -> User
}

public class HomeUseCase: HomeUseCaseProtocol {

    let environment: InteractorEnvironment

    public required init(_ environment: InteractorEnvironment) {
        self.environment = environment
    }

    public func logout() async {
        await environment.services.auth.logOut()
    }

    public func loadUser() async throws -> User {
        try await environment.services.user.currentUser()
    }
}
