//
//  LoginRouter.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/01/25.
//

import UIKit
import SwiftUI
import VIPERKit

public class LoginRouter: RouterProtocol {

    public weak var viewController: UIViewController?

    private let environment: RouterEnvirnonment

    public required init(_ dependency: RouterEnvirnonment) {
        self.environment = dependency
    }

    @MainActor
    public func showHomeView() {
        let destination = environment.viewResolver.resolve(for: .home)
        destination.modalPresentationStyle = .fullScreen
        destination.modalTransitionStyle = .flipHorizontal
        viewController?.present(destination, animated: true)
    }
}
