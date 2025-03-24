//
//  RegisterController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class RegisterController: UIViewController {
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
    
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Your Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()
    
    private let userNameField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Your username",
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
    
    @objc private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor.systemCyan
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
    
    // MARK: - Properties
    private var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureViewModel()
    }
    
    func configureViewModel() {
        navigationItem.title = "Sign up"
                
        viewModel.registerSuccess = { userId in
            let coordinator = RegisterApproveCoordinator(userId: userId, navigationController: self.navigationController ?? UINavigationController())
            coordinator.start()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Email already exists"), animated: true)
        }
    }

    @objc func signUpTapped() {
        if let email = emailField.text, let name = nameField.text, let userName = userNameField.text, let password = passwordField.text, !email.isEmpty, !name.isEmpty, !userName.isEmpty, !password.isEmpty {
            print("tapped")
            
            viewModel.register(username: userName, name: name, email: email, password: password)
            
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please fill all inputs"), animated: true)
        }
    }
    
    
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(nameField)
        view.addSubview(userNameField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(socialStackView)
        
//        let googleButton = createSocialButton(imageName: "google_icon")
//        let appleButton = createSocialButton(imageName: "apple_icon")
//        let facebookButton = createSocialButton(imageName: "facebook_icon")
//        
//        socialStackView.addArrangedSubview(googleButton)
//        socialStackView.addArrangedSubview(appleButton)
//        socialStackView.addArrangedSubview(facebookButton)
        
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
            
            nameField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            userNameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            userNameField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            userNameField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            socialStackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            socialStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            socialStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
