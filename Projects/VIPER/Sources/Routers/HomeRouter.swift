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

    weak var viewController: UIViewController?

    public typealias Dependency = Void

    public required init(_ dependency: Void) {
    }

    @MainActor
    public func dismiss() async {
        await viewController?.dismiss(animated: true)
    }
}
