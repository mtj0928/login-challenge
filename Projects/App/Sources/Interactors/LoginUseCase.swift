import VIPERKit

public protocol LoginUseCaseProtocol: InteractorProcotol where Dependency == InteractorEnvironment {
    func login(id: String, password: String) async throws
}

public class LoginUseCase: LoginUseCaseProtocol, InteractorProcotol {

    let environment: InteractorEnvironment

    public required init(_ dependency: InteractorEnvironment) {
        self.environment = dependency
    }

    public func login(id: String, password: String) async throws {
        try await environment.services.auth.logInWith(id: id, password: password)
    }
}
