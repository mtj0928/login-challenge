//
//  ViewResolver.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewResolver {
    @MainActor
    func resolve(for type: ViewType) -> UIViewController
}

public enum ViewType {
    case login
    case home
}
