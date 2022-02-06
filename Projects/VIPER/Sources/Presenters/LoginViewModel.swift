//
//  LoginViewModel.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/01/22.
//

import Foundation
import UIKit

import VIPERKit
import Interactors
import Routers
import Entities

public class LoginViewModel<Interactor: AuthenticationUseCaseProtocol>: ObservableObject, PresenterProtocol {

    public enum LoginViewState {
        case ready(id: String, password: String)
        case loading
        case success
        case error(AlertError)
    }

    @Published public private(set) var loginButtonEnabled: Bool = false
    @Published public private(set) var textFieldEnalbled: Bool = true
    @Published public private(set) var state: LoginViewState = .ready(id: "", password: "") {
        didSet {
            updateTextFieldEnabled()
            updateLoginButtonEnabled()
        }
    }

    private let interactor: Interactor
    private let router: LoginRouter

    public required init(_ dependency: Void, interactor: Interactor, router: LoginRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func updateLoginButtonEnabled() {
        if case .ready(let id, let password) = state {
            loginButtonEnabled = !id.isEmpty && !password.isEmpty
        } else {
            loginButtonEnabled = false
        }
    }

    private func updateTextFieldEnabled() {
        if case .ready(_, _) = state {
            textFieldEnalbled = true
        } else {
            textFieldEnalbled = false
        }
    }
}

// MARK: - Public methods

extension LoginViewModel {

    public func update(id: String, password: String) {
        switch state {
        case .ready(_, _), .error(_):
            state = .ready(id: id, password: password)
        default: break
        }
    }

    public func login() async {
        guard case let .ready(id, password) = state else {
            return
        }
        state = .loading

        do {
            try await interactor.login(id: id, password: password)
            state =  .success
        } catch {
            state = .error(.init(error))
        }
    }

    @MainActor
    public func showHomeView() {
        router.showHomeView()
    }

    public func setToRouter(_ viewController: UIViewController) {
        router.viewController = viewController
    }
}
