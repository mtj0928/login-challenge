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
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "ID"
        return textField
    }()

    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "PASSWORD"
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()

    private let stackView: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.spacing = 20
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
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

        addActions()
        addSubviews()
        addAutoLayoutConstraint()
    }

    private func addActions() {
        [idField, passwordField].forEach { textField in
            textField.addAction(
                .init { [weak self] _ in self?.updateViewModel() },
                for: .editingChanged)
        }

        loginButton.addAction(
            .init { [weak self] _ in self?.loginButtonPressed() },
            for: .touchUpInside
        )
    }

    private func addSubviews() {
        stackView.addArrangedSubview(passwordField)
        view.addSubview(stackView)
        view.addSubview(loginButton)
    }

    private func addAutoLayoutConstraint() {
        [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ]
            .forEach { $0.isActive = true }
    }

    private func loginButtonPressed() {
        Task { await viewModel.login() }
    }

    private func updateViewModel() {
        viewModel.update(id: idField.text ?? "", password: passwordField.text ?? "")
    }
}

// MARK: - Observe ViewModel

extension LoginViewController {

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
