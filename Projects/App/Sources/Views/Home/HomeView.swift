import SwiftUI
import Entities
import APIServices
import Logging

import Supports
import Presenters
import Interactors

@MainActor
public struct HomeView<UseCase: HomeUseCaseProtocol>: View {

    @ObservedObject var viewModel: HomeViewModel<UseCase>

    public init(_ viewModel: HomeViewModel<UseCase>) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            profileView
                .padding()

            Spacer(minLength: 0)

            logoutButton
                .padding(.bottom, 30)
        }
        .alert(
            isPresented: $viewModel.hasError,
            error: viewModel.error,
            actions: { _ in
                AsyncButton(text: (viewModel.error ?? AlertError()).actionTitle) { await viewModel.tappedAlertAction()
                }
            },
            message: { Text($0.message) }
        )
        .activityIndicatorCover(isPresented: viewModel.isLoggingOut)
        .task {
            await viewModel.loadUser()
        }
    }

    private var profileView: some View {
        VStack(spacing: 10) {
            UserProfileView(user: viewModel.user)

            ReloadButton { @MainActor () async -> Void in
                await viewModel.loadUser()
            }
            .disabled(viewModel.isLoading)
        }
    }

    private var logoutButton: some View {
        AsyncButton(text: "Logout") {
            await viewModel.logout()
        }
        .disabled(viewModel.isLoggingOut)
    }
}
