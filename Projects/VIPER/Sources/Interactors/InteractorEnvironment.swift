//
//  File.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import Entities

public protocol InteractorEnvironment {
    var services: Services { get }
}

public protocol Services {
    var auth: AuthServiceProtocol.Type { get }
    var user: UserServiceProtocol.Type { get }
}

public protocol AuthServiceProtocol {
    static func logInWith(id: String, password: String) async throws
    static func logOut() async
}


public protocol UserServiceProtocol {
    static func currentUser() async throws -> User
}
