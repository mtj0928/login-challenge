//
//  ProductionEnvironment.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import App
import APIServices

import Routers
import Interactors

class ProductionEnvironment: RouterEnvirnonment, InteractorEnvironment {

    var viewResolver: ViewResolver {
        ApplicationViewResolver(self)
    }

    let services: Services = ApplicationServices()
}

class ApplicationServices: Services {

    var auth: AuthServiceProtocol.Type {
        AuthService.self
    }

    var user: UserServiceProtocol.Type {
        UserService.self
    }
}
