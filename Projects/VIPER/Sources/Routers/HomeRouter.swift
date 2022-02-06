//
//  HomeRouter.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import UIKit

import Supports
import VIPERKit

public class HomeRouter: RouterProtocol {

    public weak var viewController: UIViewController?

    private let environment: RouterEnvirnonment

    public required init(_ dependency: RouterEnvirnonment) {
        self.environment = dependency
    }

    @MainActor
    public func dismiss() async {
        await viewController?.dismiss(animated: true)
    }
}
