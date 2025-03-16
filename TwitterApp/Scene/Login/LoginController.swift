//
//  LoginController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - UI Elements
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Açıq placeholder rəngi
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
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Açıq placeholder rəngi
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let socialStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func createSocialButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 1, alpha: 0.2)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configureViewModel() {
        navigationItem.title = "Login"
                
        viewModel.loginSuccess = { loginModel in
            _ = KeychainManager.shared.save(key: "token", value: loginModel.data?.token ?? "")
            _ = KeychainManager.shared.save(key: "userId", value: String(loginModel.data?.user?.id ?? 0))
            _ = KeychainManager.shared.save(key: "email", value: loginModel.data?.user?.email ?? "")
            _ = KeychainManager.shared.save(key: "name", value: loginModel.data?.user?.name ?? "")
            _ = KeychainManager.shared.save(key: "username", value: loginModel.data?.user?.username ?? "")

            //Coordinator ile Home sehifesine yonlendirecem.
            print("navigation home")
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Email or password is wrong. Please try again"), animated: true)
        }
    }

    @objc func signInTapped() {
        if let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
            
            viewModel.login(email: email, password: password)
            
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please fill all inputs"), animated: true)
        }
    }
    
    @objc func signUpTapped() {
        let coordinator = RegisterCoordinator(navigationController: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(socialStackView)
        
        let googleButton = createSocialButton(imageName: "google_icon")
        let appleButton = createSocialButton(imageName: "apple_icon")
        let facebookButton = createSocialButton(imageName: "facebook_icon")
        
        socialStackView.addArrangedSubview(googleButton)
        socialStackView.addArrangedSubview(appleButton)
        socialStackView.addArrangedSubview(facebookButton)
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
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
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            
            socialStackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            socialStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            socialStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
