import Combine
import UIKit
import Logging
import SwiftUI

import Presenters
import Interactors
import Supports

@MainActor
public final class LoginViewController<Interactor: LoginUseCaseProtocol>: UIViewController {

    private let idField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "ID"
        return textField
    }()

    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "PASSWORD"
        textField.isSecureTextEntry = true
        return textField
    }()

    private var loginButton: UIButton! = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()

    private let activityIndicatorViewController: ActivityIndicatorViewController = {
        let activityIndicatorViewController: ActivityIndicatorViewController = .init()
        activityIndicatorViewController.modalPresentationStyle = .overFullScreen
        activityIndicatorViewController.modalTransitionStyle = .crossDissolve
        return activityIndicatorViewController
    }()

    private let viewModel: LoginViewModel<Interactor>
    private var cancellables: [AnyCancellable] = []

    public init(_ viewModel: LoginViewModel<Interactor>) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        observeViewModel()
    }
}


// MARK: - Observe ViewModel

extension LoginViewController {

    private func setupView() {
        view.backgroundColor = .systemBackground

        [idField, passwordField].forEach {
            $0.addAction(
                UIAction { [weak self] _ in self?.updateViewModel() },
                for: .editingChanged
            )
        }

        loginButton.addAction(
            UIAction { [weak self] _ in self?.loginButtonPressed() },
            for: .touchUpInside
        )

        let vstack = UIStackView(arrangedSubviews: [idField, passwordField])
        vstack.axis = .vertical
        vstack.spacing = 20
        vstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack)

        view.addSubview(loginButton)

        // Layout
        [
            vstack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vstack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            vstack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ]
            .forEach { $0.isActive = true }
    }

    private func loginButtonPressed() {
        Task { await viewModel.login() }
    }

    @MainActor
    private func updateViewModel() {
        viewModel.update(id: idField.text ?? "", password: passwordField.text ?? "")
    }

    // MARK: - Observe ViewModel

    private func observeViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .ready(_, _): break
                case .loading: self?.handleLoading()
                case .success: self?.handleSuccess()
                case .error(let alertableError): self?.handleError(alertableError)
                }
            }
            .store(in: &cancellables)

        viewModel.$loginButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginButtonEnabled in
                self?.loginButton.isEnabled = loginButtonEnabled
            }
            .store(in: &cancellables)

        viewModel.$textFieldEnalbled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] textFieldEnalbled in
                self?.idField.isEnabled = textFieldEnalbled
                self?.passwordField.isEnabled = textFieldEnalbled
            }
            .store(in: &cancellables)
    }

    private func handleLoading() {
        present(activityIndicatorViewController, animated: true)
    }

    private func handleSuccess() {
        Task {
            await activityIndicatorViewController.dismiss(animated: true)
            viewModel.showHomeView()
            updateViewModel()
        }
    }

    private func handleError(_ alertableError: AlertError) {
        Task {
            await activityIndicatorViewController.dismiss(animated: true)
            await showAlert(alertableError)
        }
    }

    private func showAlert(_ alertableError: AlertError) async {
        let alertController: UIAlertController = .init(
            title: alertableError.title,
            message: alertableError.message,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: alertableError.actionTitle, style: .default, handler: { [weak self] _ in
            self?.updateViewModel()
        }))
        await present(alertController, animated: true)
    }
}
