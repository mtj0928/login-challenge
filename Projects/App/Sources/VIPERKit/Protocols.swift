//
//  Protocols.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import SwiftUI

public protocol ViewProtocol {
}

public protocol InteractorProcotol {
    associatedtype Dependency

    init(_ dependency: Dependency)
}

public protocol RouterProtocol {
    associatedtype Dependency

    init(_ dependency: Dependency)
}

public protocol PresenterProtocol {
    associatedtype Interactor: InteractorProcotol
    associatedtype Router: RouterProtocol
    associatedtype Dependency

    init(_ dependency: Dependency, interactor: Interactor, router: Router)

    func setToRouter(_ viewController: UIViewController)
}
