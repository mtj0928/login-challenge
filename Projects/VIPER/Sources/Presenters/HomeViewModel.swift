//
//  HomeViewModel.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import UIKit
import Logging

import VIPERKit
import Interactors
import Routers
import Entities

public class HomeViewModel<UseCase: HomeUseCaseProtocol>: PresenterProtocol, ObservableObject {
    @MainActor
    private let logger: Logger = .init(label: String(reflecting: HomeViewModel.self))

    @Published public var user: User?
    @Published public var isLoading = false
    @Published public var isLoggingOut = false
    @Published public var hasError = false
    @Published public private(set) var error: AlertError?

    private let router: HomeRouter
    private let useCase: UseCase

    public required init(_ dependency: Void, interactor: UseCase, router: HomeRouter) {
        self.useCase = interactor
        self.router = router
    }

    @MainActor
    public func logout() async {
        if isLoggingOut {
            return
        }
        isLoggingOut = true
        await useCase.logout()
        isLoggingOut = false

        await router.dismiss()
    }

    @MainActor
    public func loadUser() async {
        if isLoading {
            return
        }

        isLoading = true
        do {
            let user = try await useCase.loadUser()
            self.user = user
        } catch {
            logger.info("\(error)")
            self.error = AlertError(error)
            hasError = true
        }
        isLoading = false
    }

    public func setToRouter(_ viewController: UIViewController) {
        router.viewController = viewController
    }

    public func tappedAlertAction() async {
        guard let error = error else {
            return
        }

        if error.type == .auth {
            await router.dismiss()
        }
        self.error = nil
        hasError = false
    }
}
