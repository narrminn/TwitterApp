//
//  LoginController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.image = UIImage(named: "twitter_logo")
          imageView.contentMode = .scaleAspectFit
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()

    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.systemCyan
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor.systemCyan
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureViewModel()
    }
    
    func configureViewModel() {
        navigationItem.title = "Login"
                
        viewModel.loginSuccess = { loginModel in
            self.loginSuccess(loginModel: loginModel)
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Email or password is wrong. Please try again"), animated: true)
        }
        
        bindViewModel()
    }
    
    func loginSuccess(loginModel: LoginModel) {
        _ = KeychainManager.shared.save(key: "token", value: loginModel.data?.token ?? "")
        _ = KeychainManager.shared.save(key: "userId", value: String(loginModel.data?.user?.id ?? 0))
        _ = KeychainManager.shared.save(key: "email", value: loginModel.data?.user?.email ?? "")
        _ = KeychainManager.shared.save(key: "name", value: loginModel.data?.user?.name ?? "")
        _ = KeychainManager.shared.save(key: "username", value: loginModel.data?.user?.username ?? "")
        _ = KeychainManager.shared.save(key: "profilePhotoPath", value: loginModel.data?.user?.profilePhotoPath ?? "")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let coordinator = AppCoordinator(window: sceneDelegate.window, navigationController: self.navigationController ?? UINavigationController())
            coordinator.start()
        }
    }
    
    func bindViewModel() {
        Task { @MainActor in
            viewModel.stateUpdated = { [weak self] state in
                switch state {
                case .loginSuccess(let loginModel):
                    self?.loginSuccess(loginModel: loginModel)
                case .loading:
                    break
                case .loaded:
                    break
                case .errorHandling(_):
                    self?.present(Alert.showAlert(title: "Error", message: "Email or password is wrong. Please try again"), animated: true)
                case .idle:
                    break;
                }
            }
        }
    }

    @objc func signInTapped() {
        if let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
            
//            viewModel.login(email: email, password: password)
        Task { @MainActor in
                await viewModel.loginAsync(email: email, password: password)
            }
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please fill all inputs"), animated: true)
        }
    }
    
    @objc func signUpTapped() {
        let coordinator = RegisterCoordinator(navigationController: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
                        
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
