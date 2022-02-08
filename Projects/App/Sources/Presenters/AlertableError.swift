//
//  AlertableError.swift
//  LoginChallenge
//
//  Created by Junnosuke Matsumoto on 2022/01/22.
//

import Foundation
import Entities

public struct AlertError: Error, Identifiable {
    public var id: String { type.rawValue }

    enum ErrorType: String {
        case login, network, server, auth, unknown

        init(_ error: Error) {
            switch error {
            case is LoginError: self = .login
            case is NetworkError: self = .network
            case is ServerError: self = .server
            case is AuthenticationError: self = .auth
            default: self = .unknown
            }
        }
    }

    public let title: String
    public let message: String
    public let actionTitle: String
    let type: ErrorType

    public init() {
        self.init(SystemError())
    }

    init(_ error: Error) {
        let alertableError = error as? AlertableError ?? SystemError()
        title = alertableError.title
        message = alertableError.message
        actionTitle = alertableError.actionTitle
        type = ErrorType(error)
    }
}

extension AlertError: LocalizedError {

    public var errorDescription: String? {
        title
    }

    public var failureReason: String? {
        message
    }
}

private protocol AlertableError: Sendable {
    var title: String { get }
    var message: String { get }
    var actionTitle: String { get }
}

private struct SystemError: Error, AlertableError {
    let title = "システムエラー"
    let message = "エラーが発生しました"
    let actionTitle = "閉じる"
}

extension LoginError: AlertableError {
    var title: String { "ログインエラー" }
    var message: String { "IDまたはパスワードが正しくありません。" }
    var actionTitle: String { "閉じる" }
}

extension NetworkError: AlertableError {
    var title: String { "ネットワークエラー" }
    var message: String { "通信に失敗しました。ネットワークの状態を確認して下さい。" }
    var actionTitle: String { "閉じる" }
}

extension ServerError: AlertableError {
    var title: String { "サーバーエラー" }
    var message: String { "しばらくしてからもう一度お試し下さい。" }
    var actionTitle: String { "閉じる" }
}

extension AuthenticationError: AlertableError {
    var title: String { "認証エラー" }
    var message: String { "再度ログインして下さい。" }
    var actionTitle: String { "OK" }
}
