import APIServices
import VIPERKit

public protocol AuthenticationUseCaseProtocol: InteractorProcotol where Dependency == Void {
    func login(id: String, password: String) async throws
    func logout() async
}

public class AuthenticationUseCase: AuthenticationUseCaseProtocol, InteractorProcotol {

    public required init(_ dependency: Void) {
    }

    public func login(id: String, password: String) async throws {
        try await AuthService.logInWith(id: id, password: password)
    }

    public func logout() async {
        await AuthService.logOut()
    }
}
