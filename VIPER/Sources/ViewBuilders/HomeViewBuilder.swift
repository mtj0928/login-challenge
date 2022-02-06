//
//  File.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation

import Routers
import Views
import SwiftUI

public enum HomeViewBuilder {
    public struct Dependency {
        public let routerEnvironment: RouterEnvirnonment

        public init(_ environment: RouterEnvirnonment) {
            self.routerEnvironment = environment
        }
    }

    @MainActor
    public static func resolve(_ dependency: Dependency) -> UIViewController {
        let viewController = UIHostingController(rootView: HomeView())
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        return viewController
    }
}
