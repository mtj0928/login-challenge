//
//  ApplciationEnvironment.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import Foundation
import Routers

class ApplicationEnvironment: RouterEnvirnonment {
    var viewResolver: ViewResolver {
        ApplicationViewResolver(self)
    }
}
